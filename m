Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48374590536
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiHKQ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiHKQ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:56:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F44D5734
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:28:48 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ng1-20020a17090b1a8100b001f4f9f69d48so2882031pjb.4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=zIlQYs4X5YHGNKL+XhHl/u0V1nxNXtN2feUtkOQ/Ko8=;
        b=prNepyqrICI4EnOwKQ5P43sqTO7CufZhCdjSKSEXRFpX3nQyyG4oMwx+ojmdWz7TYN
         Z68hO1EZSsLJ3purk5FyiXvfCNjr3pymn9jd9/ppQSDUbpkUF5Rzrt++XErJISvF48x1
         0Yxmjxer9fXoww4iEZLIFgj2rMCwq8Gtiu2LHMPrDocOrDZLu3mtm/QzHwl1SLU5Odly
         VKpYJ5AHeVrRrlORphLSEQerCviZHcUqR9mbhqPLdpSxxB4SFeExQDRzvXwO7985gsjF
         RywSsXjLNQBzDVV4FqjQ4CuLv0WdXm1BDR5kbAolbBzjtyrGpy9zB7FXMzTpc31X5KOT
         uOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=zIlQYs4X5YHGNKL+XhHl/u0V1nxNXtN2feUtkOQ/Ko8=;
        b=WTiCW9gjYPRzZ9PH9/kXu4ZAZv4u1k7Rh3GOlV96+uCrFi9oACiEngTgxOoNQ+48UG
         suZa6c+wIO4vrjE8v8++NI47uX1l0yVNwMuRGo1knRDaWOnPo0eTLB9ERhM/Y2ENdugo
         8OzZMXhJXKCpAiWkbbSJkjaZjnfYqmimL40p76eJ93/HEf/MB8rxTt1Z3cbRghADFYXj
         obOx3NcAc0Ihwb/A61YeNHOQUwAeHwqlP1NBMCnoW82lBbTqXzJrAvbpKVQ54nwxrsME
         +jKMNsIAoCIb6t/oie/1SXM1Ib2UiCnHRg11Wpt7YLLrYSKb337hjMQ+GATTkmvXN18H
         FDrw==
X-Gm-Message-State: ACgBeo2ChL2ZaiAwsRI6KpfowfvmZpKMKbZiNn4m0tDNnF1vLLNi2/2g
        7GW7ABPHYlFNysrlT8yQyMIlYNA=
X-Google-Smtp-Source: AA6agR4zGOojT8rPILE2tfNT1WRmNQ0G09I29OEmQaLvnEOKzUETzGlNcyCib2z8w/fdm2jVMWwPTsU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id
 s2-20020a170902a50200b0015182890b19mr32600969plq.149.1660235326722; Thu, 11
 Aug 2022 09:28:46 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:28:45 -0700
In-Reply-To: <20220811083435.1b271c7f@kernel.org>
Message-Id: <YvUuPU8dMSvv2tdJ@google.com>
Mime-Version: 1.0
References: <20220811022304.583300-1-kuba@kernel.org> <20220810211534.0e529a06@hermes.local>
 <20220810214701.46565016@kernel.org> <20220811080152.2dbd82c2@hermes.local> <20220811083435.1b271c7f@kernel.org>
Subject: Re: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
From:   sdf@google.com
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/11, Jakub Kicinski wrote:
> Randomly adding Michal to CC since I just realized I forgot
> to CC him on the series.

> On Thu, 11 Aug 2022 08:01:52 -0700 Stephen Hemminger wrote:
> > > On Wed, 10 Aug 2022 21:15:34 -0700 Stephen Hemminger wrote:
> > > > Would rather this be part of iproute2 rather than requiring it
> > > > to be maintained separately and part of the kernel tree.
> > >
> > > I don't understand what you're trying to say. What is "this",
> > > what is "separate" from what?
> >
> > I am saying that ynl could live as a standalone project or as
> > part of the iproute2 tools collection.

> It's a bit of a strange beast, because the YNL C library ends up being
> relatively small:

>   tools/net/ynl/lib/ynl.c                  | 528 +++++++++++++++++++++++++
>   tools/net/ynl/lib/ynl.h                  | 112 ++++++

> The logic is mostly in the codegen:

>   gen.py                                   | 1601 +++++++++++++++++++++++++

> but that part we need for kernel C code as well.

> The generated code is largish:

>   tools/net/ynl/generated/dpll-user.c      | 371 ++++++++++++++++++
>   tools/net/ynl/generated/dpll-user.h      | 204 ++++++++++
>   tools/net/ynl/generated/ethtool-user.c   | 367 ++++++++++++++++++
>   tools/net/ynl/generated/ethtool-user.h   | 190 +++++++++
>   tools/net/ynl/generated/fou-user.c       | 322 ++++++++++++++++
>   tools/net/ynl/generated/fou-user.h       | 287 ++++++++++++++
>   tools/net/ynl/generated/genetlink-user.c | 635  
> +++++++++++++++++++++++++++++++
>   tools/net/ynl/generated/genetlink-user.h | 201 ++++++++++

> but we don't have to commit it, it can be created on the fly
> (for instance when a selftest wants to make use of YNL).

> Then again it would feel a lot cleaner for the user space library
> to be a separate project. I've been putting off thinking about the
> distribution until I'm done coding, TBH. Dunno.

my 2c:

Putting it into iproute2 will make it carry a 'networking' badge on it
meaning no other subsystem would look into it.

I'd rather make netlink more generic (s/netlink/kernelink/?) and remove
CONFIG_NET dependency to address https://lwn.net/Articles/897202/
