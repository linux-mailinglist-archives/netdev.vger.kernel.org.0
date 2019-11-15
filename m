Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4AECFE548
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 19:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfKOSvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 13:51:24 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40230 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfKOSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 13:51:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id j26so8762205lfh.7
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 10:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7KBOVje7axB7pbf+Jm8hMxH+EszmRa01cxvO8ZHQsZs=;
        b=QOW+3rSc+Fc0pHsSSjbyPJRswhVEr/DY/nG0bwatWiNtA5A25PU9UMRM/tIzcedTrj
         Zx7qZQAI5Q/d5hihyfmYAdE64yQEVLG5ygA+DPsEAzQpU24p3iQqVqPzjFt9PNHIyxIp
         hIO6dIv2EbMkvlPOVtiO4ZxewtqRiRQ7qFSyzYTND6MySPsmQblwybrGNmijlCDfMWJU
         /9M9kJ6YCbGj4JWT8d2FNRVuxp97VJESZY1P8jF0GcM7GzOYKSK64yASfdGAk81NtRsl
         cgv3wu/NsiboYZB/5SH9xE2GbGg8Uo3aXevGkjXYxQLxXrjqznuUZVE4oOoH+0rRn9Zo
         fz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7KBOVje7axB7pbf+Jm8hMxH+EszmRa01cxvO8ZHQsZs=;
        b=sjECGo88SUaY9QZt1fWeDHdVif9Rmn6mkEcxRSWEik2MAbxGuo25eVtTPgNyxEciV+
         sx7R6eIo3A3NH/UH5BBgqCucTzLWnY1Lv45vZKyh6YpC3yjVcw+IoiC39vZx0up+g4oV
         hBI1dhenHVVn1Can3pNV6g9C8+0smc9dsXSvzeAAQkaEDTPbfrZ/znOJ5C+IrH4iO1iB
         VUEnQKHVmlVy6IAUEKCE6YlIoQFa21kziSgzjiwWm+ekKZHMSe4mT+W7whMkijd8IZUa
         ZksQz6KrHfocvdSG+MYMFRVNY3jZ9/Js+Z3yh0J9GtZsAkxOu94sn8cel206PrDX5awD
         royg==
X-Gm-Message-State: APjAAAXp2nbUH4/Zy7xAAoLZvGYiyT3JiiupGa6z+WI7ksW5LkeyNoCi
        6B7VMxE7jpIErXVe3f58ZChy/hpTJgI=
X-Google-Smtp-Source: APXvYqxWOhHJ9QuhTZFgJyfXCra1ngr8lEoW6O3WNQSX9AVoulBfHsx3RCWofeEtcuIBCq0oW6hF5A==
X-Received: by 2002:ac2:4d17:: with SMTP id r23mr12634420lfi.56.1573843881458;
        Fri, 15 Nov 2019 10:51:21 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o196sm4903739lff.59.2019.11.15.10.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 10:51:21 -0800 (PST)
Date:   Fri, 15 Nov 2019 10:51:12 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v3 1/2] cxgb4: add TC-MATCHALL classifier
 egress offload
Message-ID: <20191115105112.17c14b2b@cakuba.netronome.com>
In-Reply-To: <20191115153247.GD2158@nanopsycho>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
        <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
        <20191115135845.GC2158@nanopsycho>
        <20191115150824.GA14296@chelsio.com>
        <20191115153247.GD2158@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 16:32:47 +0100, Jiri Pirko wrote:
> Fri, Nov 15, 2019 at 04:08:30PM CET, rahul.lakkireddy@chelsio.com wrote:
> >On Friday, November 11/15/19, 2019 at 14:58:45 +0100, Jiri Pirko wrote:  
> >> Fri, Nov 15, 2019 at 01:14:20PM CET, rahul.lakkireddy@chelsio.com wrote:
> >> >+static int cxgb4_matchall_egress_validate(struct net_device *dev,
> >> >+					  struct tc_cls_matchall_offload *cls)
> >> >+{
> >> >+	struct netlink_ext_ack *extack = cls->common.extack;
> >> >+	struct flow_action *actions = &cls->rule->action;
> >> >+	struct port_info *pi = netdev2pinfo(dev);
> >> >+	struct flow_action_entry *entry;
> >> >+	u64 max_link_rate;
> >> >+	u32 i, speed;
> >> >+	int ret;
> >> >+
> >> >+	if (cls->common.prio != 1) {
> >> >+		NL_SET_ERR_MSG_MOD(extack,
> >> >+				   "Egress MATCHALL offload must have prio 1");  
> >> 
> >> I don't understand why you need it to be prio 1.  
> >
> >This is to maintain rule ordering with the kernel. Jakub has suggested
> >this in my earlier series [1][2]. I see similar checks in various
> >drivers (mlx5 and nfp), while offloading matchall with policer.  
> 
> I don't think that is correct. If matchall is the only filter there, it
> does not matter which prio is it. It matters only in case there are
> other filters.

Yup, the ingress side is the one that matters.

> The code should just check for other filters and forbid to insert the
> rule if other filters have higher prio (lower number).

Ack as well, that'd work even better. 

I've capitulated to the prio == 1 condition as "good enough" when
netronome was adding the policer offload for OvS.
