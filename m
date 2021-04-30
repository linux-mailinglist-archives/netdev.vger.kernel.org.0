Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C74237035F
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhD3WQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:16:35 -0400
Received: from p3plsmtpa07-04.prod.phx3.secureserver.net ([173.201.192.233]:44929
        "EHLO p3plsmtpa07-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230298AbhD3WQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 18:16:34 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id cbQGlEwIoHnyxcbQGlD5lo; Fri, 30 Apr 2021 15:15:45 -0700
X-CMAE-Analysis: v=2.4 cv=eI3WMFl1 c=1 sm=1 tr=0 ts=608c8191
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Oz0uATOGw0wBLZMfVz4A:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>,
        <don@thebollingers.org>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com> <008301d73e03$1196abb0$34c40310$@thebollingers.org> <YIx9UaSckIraOQCC@lunn.ch>
In-Reply-To: <YIx9UaSckIraOQCC@lunn.ch>
Subject: RE: [PATCH ethtool-next 0/4] Extend module EEPROM API
Date:   Fri, 30 Apr 2021 15:15:44 -0700
Message-ID: <008e01d73e0e$5d6a70c0$183f5240$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIoIhiQoNl9y+8EvClCms9DfxFPhwId/JxRAcWpIVaqDLk+wA==
Content-Language: en-us
X-CMAE-Envelope: MS4xfABNVXREfYz9sU/v/kNu2ifPGJFbVnks069u6lY/3WVpzhlyHoIZuj9UXoYHNPBZlNKM2fgQnylCQgn+gHVw/qedclmx3OFd5LgMcn0yxYKvLqpDp8s/
 2AJW3iHemAcn9a4Sk7z2Zr4lnr0fET30o7bEcbVNFHs7SyG7suYhxepkpA33b00Y3S+bORT8+WrtFHY+uatrL49Iygd5EOQ6av9Bur13tDwcEiDjFnf7gGpS
 pSyjY83IjI9IC8LCSx5HRzAPlGCQOSokWSbbiz3x2NyyfgR/JZEKkXZL+DMRKi/h4O298dk82jUhlaLnC/jKzlMRr0CD78Sc20wS4lTNhQZsmoekyZD6PD8h
 0Xz0YTw6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > There are routine functions to configure the devices that require
> > writing appropriate values to various registers.  Byte 26 allows
> > software control of low power mode, squelch and software reset.  Page
> > 10h is full of Lane and Data Path Control registers.
> 
> These all sounds like foot canons when in user space control. I would
expect
> the MAC and or SFP driver to make use of these features, no need to export
> them to user space, at least not in a raw format. I could however imagine
> ethtool commands to manipulate specific features, passing the request to
> the MAC to perform, so it knows what is going on.
> 
> > Beyond the spec, but allowed by the spec, there are vendor specific
> > capabilities like firmware download that require bulk write (up to 128
> > bytes per write).
> 
> This one is not so easy. Since it is vendor specific, we need to consider
how to
> actually make it vendor generic from Ethtool, or maybe devlink. Maybe code
> in the kernel which matches on the vendor string in the SFP EEPROM, and
> provides a standardized API towards ethtool, and does whatever magic is
> needed towards the SFP. But it gets messy when you don't have direct
> access to the SFP, there is a layer of firmware in the middle, which is
often
> the case.
> 
> 	 Andrew

Here we go again...  It is my experience that there are far more
capabilities in these devices than will ever be captured in ethtool.  Module
vendors can provide additional value to their customers by putting
innovative features into their modules, and providing software applications
to take advantage of those features.  These features don't necessarily
impact the network stack.  They may be used to draw additional diagnostic
data from the devices, or to enable management features like flashing
colored lights built into custom modules.  I've written code to do these and
more things which are unique to one vendor, and valued by their customers.

I'm asking for a generic interface that allows read/write access to
arbitrary registers.  Put the warnings in the documentation, limit access to
it, but make it available.

Don

