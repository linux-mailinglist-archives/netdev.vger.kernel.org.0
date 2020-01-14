Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713F713A9B7
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 13:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgANMwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 07:52:02 -0500
Received: from mx3.wp.pl ([212.77.101.10]:19597 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgANMwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 07:52:02 -0500
Received: (wp-smtpd smtp.wp.pl 30740 invoked from network); 14 Jan 2020 13:51:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1579006317; bh=kSC9TeFUobiO3Iz/cyDPdWPcN3QsQfg0WTbYeDOz+PU=;
          h=From:To:Cc:Subject;
          b=lZPhlWcVJ2DsliFxcUNtxkmqSMEeO9Yfdrsah7E1tx25EE4F2AHXd2Fj4V9xskmf+
           r43qlGV5WNpg3+chbg5Kd2RjOFA6Flv4OjWY7kPX1yxn9jcajiy9OclOtFr1G+vYQH
           DVQLH3FYL+7h7PVIuXbxvjCIrVIf3NPdS88/QMg8=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <ms@dev.tdt.de>; 14 Jan 2020 13:51:57 +0100
Date:   Tue, 14 Jan 2020 04:51:49 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     khc@pm.waw.pl, davem@davemloft.net, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wan/hdlc_x25: make lapb params configurable
Message-ID: <20200114045149.4e97f0ac@cakuba>
In-Reply-To: <83f60f76a0cf602c73361ccdb34cc640@dev.tdt.de>
References: <20200113124551.2570-1-ms@dev.tdt.de>
        <20200113055316.4e811276@cakuba>
        <83f60f76a0cf602c73361ccdb34cc640@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 107e775709673ca4f5508c7caa3a988f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [waMU]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 06:37:03 +0100, Martin Schiller wrote:
> >> diff --git a/include/uapi/linux/hdlc/ioctl.h 
> >> b/include/uapi/linux/hdlc/ioctl.h
> >> index 0fe4238e8246..3656ce8b8af0 100644
> >> --- a/include/uapi/linux/hdlc/ioctl.h
> >> +++ b/include/uapi/linux/hdlc/ioctl.h
> >> @@ -3,7 +3,7 @@
> >>  #define __HDLC_IOCTL_H__
> >> 
> >> 
> >> -#define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc 
> >> utility */
> >> +#define GENERIC_HDLC_VERSION 5	/* For synchronization with sethdlc 
> >> utility */  
> > 
> > What's the backward compatibility story in this code?  
> 
> Well, I thought I have to increment the version to keep the kernel code
> and the sethdlc utility in sync (like the comment says).

Perhaps I chose the wrong place for asking this question, IOCTL code
was my real worry. I don't think this version number is validated so 
I think bumping it shouldn't break anything?

> > The IOCTL handling at least looks like it may start returning errors
> > to existing user space which could have expected the parameters to
> > IF_PROTO_X25 (other than just ifr_settings.type) to be ignored.  
> 
> I could also try to implement it without incrementing the version by
> looking at ifr_settings.size and using the former defaults if the size
> doesn't match.

Sounds good, thank you!
