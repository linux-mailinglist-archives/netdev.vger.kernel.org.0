Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C8935A942
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 01:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhDIXcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 19:32:47 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:36615 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235053AbhDIXcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 19:32:46 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.west.internal (Postfix) with ESMTP id 4BA19FD7
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 19:32:33 -0400 (EDT)
Received: from imap22 ([10.202.2.72])
  by compute7.internal (MEProxy); Fri, 09 Apr 2021 19:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=fmZ6LhAzDWRjrzmUznGo6bkjI+hkk
        liLxt8R4N7PjXY=; b=NNVLdPWj7hrDGeKusgTdtsYvGRBOJuQMAcxBhu2LpnhkH
        +pnbuk3Y4vIdYATFUjCnudc0th+wVM6F0L7GVDK7UX2YbjUj7ZUW/GTkI+038sM+
        +t2GGkSKXePq1oO/VdyaWKs0irmYvNmLi7rV3Dt9OOPvZkpdOaz82gtIwSkACKeb
        BlW1Zk1/NgsDGMrRtnXAzWwtUmx/mYy8iADNZ6bFbzTZNFhBXC4hSIzdVJ5aMb5D
        7k6RXML5P8ui47+xpgmPy8nZDDcwisKIRB32o/twkkNwDh//FtEf/MjAp5hO1G2h
        c+5nB1W+EOA5WshaHF5M3t239ybRvw5RYdJreON2A==
X-ME-Sender: <xms:EORwYOxlTaR_ob3hvPIyg3robayOZm65iT7DlYE6KbfwIHsH6Q1cYw>
    <xme:EORwYKSJDGSIQWoIBHCS23K2-kRRO10H3Vi2yZg50Sl09yamFAZVN0ko7by3StTgk
    TqVLkEvXVZKl3SpK3s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekvddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpeguvghlihgtihhouhhslhihthihphgvugesnhgrsghlrghmsggu
    rgdrshihshhtvghmshenucggtffrrghtthgvrhhnpeefueefueffgeegjeekkedugefgie
    dttdetgeetleeiheeguefgkeefheekvdduteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpeguvghlihgtihhouhhslhihthihphgvugesnhgrsg
    hlrghmsggurgdrshihshhtvghmsh
X-ME-Proxy: <xmx:EORwYAVLkO-nWrxenlWwZelYUtOXPLkH1ak3nqRDoxHrb7kYTWYv5Q>
    <xmx:EORwYEjbVWe0yQbOIRrmTsB5CkauZTbT5azankF7jI6O0N_O_EU6EA>
    <xmx:EORwYADSNPWrS2hzLEx8AkNYRPK9uqNvFi9nL2TBrziOZ-sB-IcR_g>
    <xmx:EORwYIzyn-wlpsSHk_iS6cGNnzc_AUp0-si8ReJupuAWcHejr_dIsnkRLHA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9B9B262C0064; Fri,  9 Apr 2021 19:32:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-273-g8500d2492d-fm-20210323.002-g8500d249
Mime-Version: 1.0
Message-Id: <a2041593-3124-443a-ad2e-828013b57881@www.fastmail.com>
Date:   Sat, 10 Apr 2021 01:32:12 +0200
From:   deliciouslytyped@nablambda.systems
To:     netdev@vger.kernel.org
Subject: UX: ip netns, ip route del [...] is tedious
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello list,

1)
`ip netns` requires network namespaces to be symlinked in /var/run/netns to be recognized.

Several containerization tools seem to omit that, and besides, the system appears to have no obligation to maintain those symlinks. This means `ip netns` is not useful at best, misleading at worst.

Tools like `lsns` _appear_ (from a quick strace) to just enumerate by scanning through the /proc directories, but perhaps there are better options.

I would like to request that `ip netns` be modified to do it's own network namespace enumeration, so that it's possible to get an actually representative view of the system from this intuitive-seeming subcommand.

2)
With regards to `ip route del`, copy/pasting, or typing out the full/most of a network route, to delete it, is a bit tedious and annoying. Could `ip route (show)` not return an indexed list, or somesuch? - and allow that index be passed to to `ip route del`?

This naive solution may be bad, in that it allows things like race conditions between the routing table being changed, and doing the actual deletion. Perhaps there are better ways to implement something similar? 

The current implementation, with regards to similar issues at most (?: I'm not intimately familiar with iproute2) allows "misdeleting" a rule with a matching prefix.

Regards,
