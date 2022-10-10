Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E865FA179
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJJP41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 11:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJJP40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:56:26 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C2573934
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 08:56:25 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1364357a691so6412566fac.7
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 08:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FBlJGaToZEu6D+RvSCyaxxmx/t2AwVYuPW5gPgMk1tk=;
        b=7tmLSoXRtJfH4Dbqoikvsfh+/gCulAYIx1NWrvmt1/bxZ67ZOUWZ5K/xrU2OfEpG1f
         Rgl678+XBpgr/SDRuN4IqJ/YhV4Xbe+LDX6unNVPmsuTisLqfNr7/LEOnRjKWgAhKMGI
         6R2S6gpT9InaefaMZ33djbJe3Oeg5sifZ2SNHzyNzDu4QrfRGS6GRuRjE4hQlZV04YIo
         sVRYmrFMPmaNs7QE6I9BRei46/v+FGizKrTFY2yTY+Wf3pS+MRFLuy43CuqDfFRxyCYr
         LJaDMo9Yerb9kPup/5YnxIs8AMcaFd6t1bQ6eiobj0LLGjE+kZDPShNKAi4F2s0bMIq0
         atjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FBlJGaToZEu6D+RvSCyaxxmx/t2AwVYuPW5gPgMk1tk=;
        b=dlHCl3pu8IDnTDDW0vl2XohBumDJ3FnQZafwee4gZ1ON1bzqbwswGIg7Un1PLtP8NJ
         GjV34HUxfvT72XAP5K/H5LbwG6RcLEFOMwvZtvySbX//KH7I+JVWBLC0zboPgwTAmDSa
         6XS80I7HVnHXaCPRJzxNfzhiYghZA3X8/JJ3Qy7Me7QdQhjc26XL0MCKL6xKRV0YKYbl
         FKp3ypjxMP+3U96lSGVaQLKCEgIAtS1uBaOOsEF7S8E8nZT3H1uWXkexnznObyYSHTNh
         ucC3Mr5JSu086hgZM7AKTFxcxASWByBBxO80/WQj+h3J7koyDRsXi+BivB96rigcXRde
         iMyg==
X-Gm-Message-State: ACrzQf038reUYG2n6f1zuwX8p+HwhC1U4xDNxM9YVh4WLOVNYSOjHePg
        Z8qMojOFXRuaFC0EpO9U34tbJPSk3lHr4dD4CXHp
X-Google-Smtp-Source: AMsMyM7E58PKEIMT2pMlaK++ErltMfDSbBzoHG8lkSaC1jHVQXN22/TbjZ4o5ZhdmawyCSdC9gyK7IrpZVO6jOcWxRw=
X-Received: by 2002:a05:6870:9612:b0:136:66cc:6d5a with SMTP id
 d18-20020a056870961200b0013666cc6d5amr5406856oaq.172.1665417384952; Mon, 10
 Oct 2022 08:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
 <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
 <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
 <CAADnVQJ5VgTNiEhEhOtESRrK0q3-pUSbZfAWL=tXv-s2GXqq8Q@mail.gmail.com>
 <df4df4eb70594d65b40865ca00ecad09@AcuMS.aculab.com> <CAHC9VhQRywim8vKGUM+=US0nq_fqZH7MShaV2tC14gw5xUrSDA@mail.gmail.com>
 <ffe2b21ce6e04b07891261641b4d1f5b@AcuMS.aculab.com>
In-Reply-To: <ffe2b21ce6e04b07891261641b4d1f5b@AcuMS.aculab.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 10 Oct 2022 11:56:14 -0400
Message-ID: <CAHC9VhTBdLtK_spOS9axuYfHRb=zx3TFqKY2cvfy9tRd0ep-sg@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     David Laight <David.Laight@aculab.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 11:34 AM David Laight <David.Laight@aculab.com> wrote:
> From: Paul Moore
> > Sent: 10 October 2022 14:19
> ....
> > > It isn't really ideal for the buffer pointer either.
> > > That started as a single field (assuming the caller
> > > has verified the user/kernel status), then the is_kernel
> > > field was added for architectures where user/kernel
> > > addresses use the same values.
> > > Then a horrid bug (forgotten where) forced the is_kernel
> > > field be used everywhere.
> > > Again a structure with two pointers would be much safer.
> >
> > Any chance you have plans to work on this David?
>
> I'd only spend any significant time on it if there
> is a reasonable chance of the patches being accepted.
>
> My use would be an out-of-tree non-GPL module calling
> kernel_getsockopt().
> The main in-tree user is bpf - which seems to need an
> ever-increasing number of socket options, but support has
> been added one by one.
>
> While most getsockopt() calls just return set values, SCTP
> uses some to retrieve the result of values negotiated with
> the peer. The number of valid data streams is needed for
> even trivial SCTP applications.
> However I've a workaround for a bug in 5.1 to 5.8 that
> returned the wrong values (my tests didn't check negotiation)
> that also obtains the values on later kernels.
> So I'm not (yet) in a hurry!

It looks like it might still be a good idea to add hardening/support
for the LSM hook as your needs still seem a bit far off, but I
appreciate the background - thanks!

-- 
paul-moore.com
