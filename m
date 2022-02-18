Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED9F4BBD7B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbiBRQ3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:29:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiBRQ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:29:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED87A527C5
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 08:29:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ki18-20020a17090ae91200b001b8be87e9abso8310985pjb.1
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 08:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+S2A0TOvwCJqKZEf2n99ER8D0GRma+qu1vDI6jWof+k=;
        b=17FGGI/YNQ0KAFTAypdxgCTm9RsrQp5K+/cVxDpHxnSkxeVsiaSt9Ac07mjSXc13ZK
         h5Ktl0Ae9ERA3vumep+jO9/6crSymL4N2TdTM5DBCyniUTz322SOFXsEU2aB7M3NSZQp
         z5hdVjRJWawRVRC0hpmiGDUjVPj0CD4yz5GQBg6hUP2yFvgjq4iPANEEQRU+8mSBTiHQ
         A74gL4IMVRFT6lyj4iCaPqObqquNtP7bwR2C5I2kljvhaKHQ9gMBTIUNlISvXQcvzFwd
         VQmKQo8+Hfr3ClRpm9RFA9lJXxMQ8O/AZd5D3rPCYmee6i9hEsWNVIuVLJwzf83SOXO7
         fY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+S2A0TOvwCJqKZEf2n99ER8D0GRma+qu1vDI6jWof+k=;
        b=te2su1UMQHlrf5npKOiXMSCKUPRueQbj7zbjWEAJYmqNOHT5zw4/UxFsGwCEXfZ7I9
         50rOUPUdXNK/4FgDiNzClKj2VMhjY5BcJgQiNAarQNTLJVCfUVKXQfiRWQ03tnPKs+vT
         dHjWtKi0iOET7efbznK6aK5MS0axiMSdDwkUfbPjXJbFr6DiYSRF0Wb3TsGjo9fcqdcW
         UMOPXf3pP72wNmGR24WZi4z0U1e3zmjH9gz042X/SD+giJ31HlFcPsET03+yZ4lAK3Bg
         R619KzXD/dYfXgOD5ci0nJyQy6ndlItCtohUU5AG7m/QsALObU/E//qLPhScb04jYv5X
         CEjw==
X-Gm-Message-State: AOAM532Xgd+EK1D1SdyIQ5lZ0mpyPrE69BtU8CIEIgct7t+VntKOAScO
        YFDKScTAm4pUoOiGxGYIT0braA==
X-Google-Smtp-Source: ABdhPJwExeAIiHnGtSDYvzLTn9a79LfvNamR7Qrx/rmjXi3TsyKaPlksaqY9nzNuXqJXPRkk8OfIyw==
X-Received: by 2002:a17:90a:bb0d:b0:1b8:a958:543d with SMTP id u13-20020a17090abb0d00b001b8a958543dmr9142994pjr.51.1645201763446;
        Fri, 18 Feb 2022 08:29:23 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f16sm3920555pfa.147.2022.02.18.08.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:29:23 -0800 (PST)
Date:   Fri, 18 Feb 2022 08:29:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Message-ID: <20220218082920.06d6b80f@hermes.local>
In-Reply-To: <20220218121237.GQ614@gate.crashing.org>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
        <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com>
        <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
        <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu>
        <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com>
        <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com>
        <2e38265880db45afa96cfb51223f7418@AcuMS.aculab.com>
        <CAK7LNASvBLLWMa+kb5eGJ6vpSqob_dBUxwCnpHZfL-spzRG7qA@mail.gmail.com>
        <20220217180735.GM614@gate.crashing.org>
        <CAK7LNAQ3tdOEYP7LjSX5+vhy=eUf0q-YiktQriH-rcr1n2Q3aA@mail.gmail.com>
        <20220218121237.GQ614@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 06:12:37 -0600
Segher Boessenkool <segher@kernel.crashing.org> wrote:

> On Fri, Feb 18, 2022 at 10:35:48AM +0900, Masahiro Yamada wrote:
> > On Fri, Feb 18, 2022 at 3:10 AM Segher Boessenkool
> > <segher@kernel.crashing.org> wrote:  
> > > On Fri, Feb 18, 2022 at 02:27:16AM +0900, Masahiro Yamada wrote:  
> > > > On Fri, Feb 18, 2022 at 1:49 AM David Laight <David.Laight@aculab.com> wrote:  
> > > > > That description is largely fine.
> > > > >
> > > > > Inappropriate 'inline' ought to be removed.
> > > > > Then 'inline' means - 'really do inline this'.  
> > > >
> > > > You cannot change "static inline" to "static"
> > > > in header files.  
> > >
> > > Why not?  Those two have identical semantics!  
> > 
> > e.g.)
> > 
> > 
> > [1] Open  include/linux/device.h with your favorite editor,
> >      then edit
> > 
> > static inline void *devm_kcalloc(struct device *dev,
> > 
> >     to
> > 
> > static void *devm_kcalloc(struct device *dev,
> > 
> > 
> > [2] Build the kernel  
> 
> You get some "defined but not used" warnings that are shushed for
> inlines.  Do you see something else?
> 
> The semantics are the same.  Warnings are just warnings.  It builds
> fine.

Kernel code should build with zero warnings, the compiler is telling you
something.
