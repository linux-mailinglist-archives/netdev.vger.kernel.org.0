Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9659820BC0F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgFZWBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:01:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F755C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:01:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u5so5202862pfn.7
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lxaxMyrU1zNhtGVJmQYInG+3Ux8u7KVzHER9Vu5WtSA=;
        b=WUAB3OFcFWr/Qundtoha7tOL4LlKlslF33Jo3j3deKUSAi55fCHDTcY4WCe/VWNvQy
         JEqnEKIed1wocgzJYiv9wTUWFQZHJVRyBlOosWqZwFHoHbtUo9O/jZ4KkgR9DcmvWw4e
         xF+SrPlVMJuhoppXjCORikTmlr9ukjVsnviJAHcPrNJ75ATaGhrN+/mnZOkYm4uM+ejf
         EdaQ5crcQLzW1HlwF/fcryce2cBRZXPwdwNW9rD36cOrjqd+dvcImCxbYW+qpCqycDrf
         Y9nl/ZKLthltRgAnTmdgmRoZOpEKOI0kifRhZKJ5CVatgrFuFzEmAG1L/Wbbh94bLBvd
         /YRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lxaxMyrU1zNhtGVJmQYInG+3Ux8u7KVzHER9Vu5WtSA=;
        b=uJGPacdullv7zpSlCvmeW96u6q7I8sb7WF8yO/Pm/X+e8HbtgjkgULFeo/sAZQU+2r
         9ukxnye4cmfYYa+Kcd00cr9ETF4Xg488bZmmYCMlQwQ/oHwt0Ultnb1X0KHYW8ugqx6l
         zkCfQMzJUJiHUI6eacgpkC5tSSs0ogZUP6EDHyTmM00RTA8i7CCj+oQfz+q2U0fpieM+
         zKjJopeldxeLwoc6aRpJzIZ9Xysm/PhhQ/C/7I5WuXKoapa0DeRXYiKRjSLUdfVGTmGx
         Pb0ZG5uTbaRJrB0z1grGFwBwJVTLmunC0lYYHgK0ecNDApf7U074iE6BLmayW/2QVGMz
         2crQ==
X-Gm-Message-State: AOAM531YHHHbzRMFmh94AHzRqQyqtcLEce2d2SSrUnREPWEUAghG2COa
        aWAxj3dnthwuGt1a756Pl0mj4w==
X-Google-Smtp-Source: ABdhPJwJ1vnSzzWMtQio9AJ5Iz/GuTGwDRYr7ySqsk/wFoTr8/YS5IsiG75Sd0BN5mZKr74dyHA1Ug==
X-Received: by 2002:a65:4507:: with SMTP id n7mr742674pgq.180.1593208867651;
        Fri, 26 Jun 2020 15:01:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 140sm26547791pfz.154.2020.06.26.15.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 15:01:07 -0700 (PDT)
Date:   Fri, 26 Jun 2020 15:00:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jonathan Morton <chromatix99@gmail.com>
Cc:     Davide Caratti <dcaratti@redhat.com>, cake@lists.bufferbloat.net,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [Cake] [PATCH net-next 1/5] sch_cake: fix IP protocol handling
 in the presence of VLAN tags
Message-ID: <20200626150059.785647cb@hermes.lan>
In-Reply-To: <78C16717-5EB2-49BF-A377-21A9B22662E1@gmail.com>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
        <159308610390.190211.17831843954243284203.stgit@toke.dk>
        <20200625.122945.321093402617646704.davem@davemloft.net>
        <87k0zuj50u.fsf@toke.dk>
        <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
        <78C16717-5EB2-49BF-A377-21A9B22662E1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 16:11:49 +0300
Jonathan Morton <chromatix99@gmail.com> wrote:

> Toke has already replied, but:
> 
> > Sure, my proposal does not cover the problem of mangling the CE bit inside
> > VLAN-tagged packets, i.e. if we should understand if qdiscs should allow
> > it or not.  
> 
> This is clearly wrong-headed by itself.
> 
> Everything I've heard about VLAN tags thus far indicates that they should be *transparent* to nodes which don't care about them; they determine where the packet goes within the LAN, but not how it behaves.  In particular this means that AQM should be able to apply congestion control signals to them in the normal way, by modifying the ECN field of the IP header encapsulated within.
> 
> The most I would entertain is to incorporate a VLAN tag into the hashes that Cake uses to distinguish hosts and/or flows.  This would account for the case where two hosts on different VLANs of the same physical network have the same IP address.
> 
>  - Jonathan Morton
> 
> _______________________________________________
> Cake mailing list
> Cake@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/cake

The implementation of VLAN's is awkward/flawed. The outer VLAN tag is transparent
but the inner VLAN is visible. Similarly the outer VLAN tag doesn't count towards
the MTU but inner one does.
