Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743B11B6A34
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgDXAFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgDXAFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:05:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3E7C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:05:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t4so3054575plq.12
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XHt+FuftJsPGeqKy6heDhwHg5C+HSjbnEYws52bz+vg=;
        b=iG8USReCJE1ztEZykLXV7uL9Fy8/axncNlw+Bv/Q61VZ+IWsyngZOqRASZ6M5x44qB
         EOc/OWaB1foWWTqyCLHFzJ2IbhUf5EHueFzU/+vf+LfTksaTHNeDgyFmlDchIRFueVTe
         np46R07CrQETTvX4PrfvpwGVhAVyKLgACyXr/dlmyRyyp+dUSjXyebwne0nL3dnozeJN
         pbCwj8I0fPluDjjOSpFm4ET1T+7T9gi0aziJORIw6u1CzwHNYsKMF8v00hsR8CXu5+Zo
         cepx7pvgqE1XLOdDhd4EkZr+g6uvrlvPoGUApreJ2DCccoX2k2ZVr1UjbxH3Bn/I6v7v
         3iQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHt+FuftJsPGeqKy6heDhwHg5C+HSjbnEYws52bz+vg=;
        b=AM5OOahpdQEjg1rIE/X7uouNcKIz/2qpfCgLLBTQPJBBgx3StEnFRrNnFN1t+jGqcV
         EFtPuZRII8W4fUudyS0cwrAE3lX7VF39nm340Fo+NiX/ruKESSVWLDjz8wMoe2aoIyAV
         1ned41RrEMzhjctKruLI0icizTXo8tfJCCHNXGR7rIkUbAAqBHp2HUtXla1fCcC5xtrI
         FSfKuvYHl3eX0xKMCne55RHKYql99IgX//ew4dJkz6jgauszdE8sC7mKWvoaH0MygR8X
         xv1mm22cYXqVj3VQYA0NXtarBzjYEcntmCZTdie7EhD0J8MeTv5/AJZXen72ZFF2CZ21
         ZWsQ==
X-Gm-Message-State: AGi0Pua4MYDSqIMg9eAheTByCGKI4zVmk5Y4cmSVZr7O7j5+VizbBn/f
        LNkBRPXbiP3aSor8WMtwjBJejw==
X-Google-Smtp-Source: APiQypJvm23OV35t16ydy9e9LoxsKRo2WLGGXHyEG0PLKSWISnq2TVqRGPNdWN4YWMwdckZNAjHshw==
X-Received: by 2002:a17:902:9a03:: with SMTP id v3mr6151155plp.272.1587686730810;
        Thu, 23 Apr 2020 17:05:30 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o15sm3325488pjp.41.2020.04.23.17.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 17:05:30 -0700 (PDT)
Date:   Thu, 23 Apr 2020 17:05:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net v3] net: bridge: fix vlan stats use-after-free on
 destruction
Message-ID: <20200423170521.65a3bc59@hermes.lan>
In-Reply-To: <20181116165001.30896-1-nikolay@cumulusnetworks.com>
References: <20181114172703.5795-1-nikolay@cumulusnetworks.com>
        <20181116165001.30896-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Nov 2018 18:50:01 +0200
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> Syzbot reported a use-after-free of the global vlan context on port vlan
> destruction. When I added per-port vlan stats I missed the fact that the
> global vlan context can be freed before the per-port vlan rcu callback.
> There're a few different ways to deal with this, I've chosen to add a
> new private flag that is set only when per-port stats are allocated so
> we can directly check it on destruction without dereferencing the global
> context at all. The new field in net_bridge_vlan uses a hole.
> 
> v2: cosmetic change, move the check to br_process_vlan_info where the
>     other checks are done
> v3: add change log in the patch, add private (in-kernel only) flags in a
>     hole in net_bridge_vlan struct and use that instead of mixing
>     user-space flags with private flags
> 
> Fixes: 9163a0fc1f0c ("net: bridge: add support for per-port vlan stats")
> Reported-by: syzbot+04681da557a0e49a52e5@syzkaller.appspotmail.com
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Why not just use v->stats itself as the flag.
Since free of NULL is a nop it would be cleaner?
