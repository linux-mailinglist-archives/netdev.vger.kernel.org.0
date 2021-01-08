Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CDF2EEA9F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbhAHA5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbhAHA5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E6020799;
        Fri,  8 Jan 2021 00:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610067421;
        bh=0xI+7G0ghuUKPfbizvJxWHlyB5D166AW4pMT1FrRGeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C55r9uVGdpvMhuthIkRouOGUi1XZ9Wapfnbg6cSsTv+SJpUEFBJP197gigKIUgx/+
         DG5532y4dkvP8lT1YTrPchBtha7LoocdljpVjwQNAoOBd6P6LyOf0jYoXN0SIN92VU
         pcxbKULY+A/oxaSNsT6SfMO1KikdUohpD8A1nUMe0rKgrNEXbIXmRxRvV3Yjla2lMs
         7Flf4mjrHJuHV9X70bX4ukrNPCffpvUB/Y6LYDMpuF11d49rORWAZHjFe/Y1FGas+n
         Vd65Pp6Oy51yXHnU8M+VtMTdmS8mVGUBGFW33Z+TfU5Q5F3L6Y0dK3y6wbby0kdACH
         SzhfQMibp9MEg==
Date:   Thu, 7 Jan 2021 16:56:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     <netdev@vger.kernel.org>, <mst@redhat.com>,
        <willemdebruijn.kernel@gmail.com>, <jasowang@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        <chenchanghu@huawei.com>, <brian.huangbin@huawei.com>
Subject: Re: [PATCH v6] vhost_net: avoid tx queue stuck when sendmsg fails
Message-ID: <20210107165659.512fe71c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610012985-24868-1-git-send-email-wangyunjian@huawei.com>
References: <1610012985-24868-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 17:49:45 +0800 wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
> 
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
>    can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
>    the driver schedules the worker to try again.
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Hi! AFAIU this needs to go to net-next. You need to wait until net is
merged into net-next and then repost. It doesn't apply at the moment
and we get in excess of 100 patches a day right now so keeping track 
of dependencies on the maintainer side does not work. Also build bot
can't test it.

net should get merged into net-next some time tomorrow or on Saturday.
