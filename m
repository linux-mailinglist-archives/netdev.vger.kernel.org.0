Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7747C7AE
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbhLUTnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:43:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234440AbhLUTnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 14:43:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v4cRE+dqB1kREJhaOpxiR5eVM67UdnPFH7HkElyMAlA=; b=nJwQ/tXvJOPYP9PcPUlCeb6K4X
        JmUtizN76tn5AS5arX8QKgXOj79IUtl6ZdtySMq3uUcnoVYHsQgxhHgvDtdVmJtEyT/+SCQwdhTbd
        wtRxWxJw2Dbgwr3rZdEbqONwp0kfFC2CxLh4INmjC2B8TgvBq6g26KkPRCMHRpVwi9eY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzl23-00HA80-M2; Tue, 21 Dec 2021 20:42:43 +0100
Date:   Tue, 21 Dec 2021 20:42:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, freddy@asix.com.tw,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] asix: fix uninit-value in asix_mdio_read()
Message-ID: <YcIuM05AO8CN1pxD@lunn.ch>
References: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 10:39:32PM +0300, Pavel Skripkin wrote:
> asix_read_cmd() may read less than sizeof(smsr) bytes and in this case
> smsr will be uninitialized.
> 
> Fail log:
> BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
> BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
> BUG: KMSAN: uninit-value in asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
>  asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
>  asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
>  asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
> 
> Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
> Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
