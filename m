Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF11C771C4
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbfGZTAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:00:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42060 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387743AbfGZTAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:00:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so24925492pff.9
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcYN5Q9Hjr0hMPLfqRBf7DLwR/Gxtv0qzHNrUUJF6Fc=;
        b=lMOwHWc7lz61tyqZVK9uwpjjRol9ZbyAnZTQpJ5XauhyFOS5fZeWSlYHHxSkAZw0Hl
         sGCmil5kMargc1ySphyhpYiNjaiEty0pSoMXiqWp0wzbJ6QsoqPny+YUoAVoHpee2RRC
         mE3FccW2oWYK5Tx494lKUrIRLfYRw1hEI66c5K8C/J8YGVeHlYWpq0FVI+AiVAO9dONX
         HMwM3z0QEs7h8zwAE6jwn9ms7kmh9ZNXy/7CC9Krm8PFCqiDogZGCbeLoIpJPj8SFrHl
         ZvIH5LAYUFazPei/KQWq3r8CR5R/hXVTQRRPFz4jHtpX2n7z6VG62d1S/X2BuwopiFf6
         fyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcYN5Q9Hjr0hMPLfqRBf7DLwR/Gxtv0qzHNrUUJF6Fc=;
        b=oONILhrsHjxGpVpmhsihPrgt4xUS/kUDHh4fXTxpKk/95XnWChLiGLQSZ2nZsL3An0
         GwyclndUrB8Xkz7666j+y2bIb+NLG6RyRMleARzolRyyveR6Qtj4ArP1oatHR2dlwfk6
         X4gbdQHW+ZrlqID5oabWk+XQ4RRBsqKedKGurHs2krKFSF0wPOCCPiZ7XWzhERjo3yYf
         o3k2LZF9C8uVBSltCpfjsnc1WTqr10VOWYVo/7tMP8IkNDg2AapoJrl8WvTb/DOolIza
         1Pw5xtzqdxqc2DXm+4R6kWXiQygaVW7cZHnw7Ve/jS224Y3Qj5/ITJEkTcBwmkSLMYBa
         u3+g==
X-Gm-Message-State: APjAAAUPWqXjwKCpy7CN5ozOAmUfn7VR7EFyBsMR4hYzkmYCSzZCF13m
        KGPPLH1HinVV6w/fM7aUMwm28v1A
X-Google-Smtp-Source: APXvYqxTktmJwA0ylqGQLYv/hUW5mYHjFhmJQ/CD8x02bRa1bbWECrmzdp2Cu9lDwqEzTgMbrsRgzg==
X-Received: by 2002:a62:2582:: with SMTP id l124mr23612927pfl.43.1564167612234;
        Fri, 26 Jul 2019 12:00:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f27sm36976210pgm.60.2019.07.26.12.00.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 12:00:11 -0700 (PDT)
Date:   Fri, 26 Jul 2019 12:00:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Message-ID: <20190726120001.73f0bdb6@hermes.lan>
In-Reply-To: <20190723193600.GA2315@nanopsycho.orion>
References: <20190723112538.10977-1-jiri@resnulli.us>
        <20190723105401.4975396d@hermes.lan>
        <20190723193600.GA2315@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 21:36:00 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Tue, Jul 23, 2019 at 07:54:01PM CEST, stephen@networkplumber.org wrote:
> >On Tue, 23 Jul 2019 13:25:37 +0200
> >Jiri Pirko <jiri@resnulli.us> wrote:
> >  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> One cannot depend on *argv being null in case of no arg is left on the
> >> command line. For example in batch mode, this is not always true. Check
> >> argc instead to prevent crash.
> >> 
> >> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> >> Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>  
> >
> >Actually makeargs does NULL terminate the last arg so what input
> >to batchmode is breaking this?  
> 
> Interesting, there must be another but out there then.
> 
> My input is:
> filter add dev testdummy parent ffff: protocol all prio 11000 flower action drop
> filter add dev testdummy parent ffff: protocol ipv4 prio 1 flower dst_mac 11:22:33:44:55:66 action drop

This maybe related. Looks like the batchsize patches had issues.

# valgrind ./tc/tc -batch filter.bat 
==27348== Memcheck, a memory error detector
==27348== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==27348== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
==27348== Command: ./tc/tc -batch filter.bat
==27348== 
==27348== Conditional jump or move depends on uninitialised value(s)
==27348==    at 0x4EE9C0C: getdelim (iogetdelim.c:59)
==27348==    by 0x152A37: getline (stdio.h:120)
==27348==    by 0x152A37: getcmdline (utils.c:1311)
==27348==    by 0x115543: batch (tc.c:358)
==27348==    by 0x4E9D09A: (below main) (libc-start.c:308)
==27348== 
==27348== Conditional jump or move depends on uninitialised value(s)
==27348==    at 0x152BE4: makeargs (utils.c:1359)
==27348==    by 0x115614: batch (tc.c:366)
==27348==    by 0x4E9D09A: (below main) (libc-start.c:308)
==27348== 
==27348== Conditional jump or move depends on uninitialised value(s)
==27348==    at 0x11EBFD: parse_action (m_action.c:225)
==27348==    by 0x13633E: flower_parse_opt (f_flower.c:1285)
==27348==    by 0x1190EB: tc_filter_modify (tc_filter.c:217)
==27348==    by 0x115674: batch (tc.c:404)
==27348==    by 0x4E9D09A: (below main) (libc-start.c:308)
==27348== 
==27348== Use of uninitialised value of size 8
==27348==    at 0x11EC0B: parse_action (m_action.c:225)
==27348==    by 0x13633E: flower_parse_opt (f_flower.c:1285)
==27348==    by 0x1190EB: tc_filter_modify (tc_filter.c:217)
==27348==    by 0x115674: batch (tc.c:404)
==27348==    by 0x4E9D09A: (below main) (libc-start.c:308)
==27348== 
Error: Parent Qdisc doesn't exists.
Error: Parent Qdisc doesn't exists.
Command failed filter.bat:1
