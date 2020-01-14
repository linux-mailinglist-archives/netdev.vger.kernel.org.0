Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C234139FA2
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgANC40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:56:26 -0500
Received: from mx4.wp.pl ([212.77.101.12]:6860 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgANC40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:56:26 -0500
Received: (wp-smtpd smtp.wp.pl 6345 invoked from network); 14 Jan 2020 03:56:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578970583; bh=nh+SpzcVz9PdRA4EUKXJMNWDTbd5tTvZHBf3TO8V5Ls=;
          h=From:To:Cc:Subject;
          b=vLm+ykKHyMt4U5fsPsfBhBQbi9gP+NYXIAeb2K7NnVgXycc93GZsvTrTJ9jFh8Gz4
           fMVKXaXWPCWi81S0jbsVWNZsSWQZOyrgBdB4/Zx5jKiHSGMP4chkb/cktTMxSzTd+n
           4CLY5YwS1yIpowz8rxjlOeqUXBymDiN4CLP2clF0=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <johan@kernel.org>; 14 Jan 2020 03:56:23 +0100
Date:   Mon, 13 Jan 2020 18:56:15 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Johan Hovold <johan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] NFC: pn533: fix bulk-message timeout
Message-ID: <20200113185615.5aa7720a@cakuba>
In-Reply-To: <20200113172358.30973-1-johan@kernel.org>
References: <20200113172358.30973-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 65ac5bd168de56cbec22fb9484b94580
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [oTOk]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 18:23:58 +0100, Johan Hovold wrote:
> The driver was doing a synchronous uninterruptible bulk-transfer without
> using a timeout. This could lead to the driver hanging on probe due to a
> malfunctioning (or malicious) device until the device is physically
> disconnected. While sleeping in probe the driver prevents other devices
> connected to the same hub from being added to (or removed from) the bus.
> 
> An arbitrary limit of five seconds should be more than enough.
> 
> Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
> Cc: stable <stable@vger.kernel.org>     # 4.18
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied to net, thank you. In the future please don't CC stable
explicitly on networking patches, Dave (or I) will select and send
all relevant patches to stable as noted in netdev FAQ.
