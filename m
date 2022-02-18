Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A614BAF2C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 02:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiBRBhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 20:37:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiBRBhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 20:37:05 -0500
Received: from conssluserg-04.nifty.com (conssluserg-04.nifty.com [210.131.2.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47ED64C0;
        Thu, 17 Feb 2022 17:36:49 -0800 (PST)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 21I1aP3F029682;
        Fri, 18 Feb 2022 10:36:26 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 21I1aP3F029682
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1645148186;
        bh=VKdbuX5iAWZp7EuE5zh/xocsqym/fIrci0mPxooYe28=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IWhfFvtew4XU+l1tL7Sq692w35/peSkY5xMOmfIiDPmNJsFG/dLnh6hvuX7ZTQUAv
         RRW+NYubKgOIhXlWjhKo/2EDILOCt78EfK6HwxqRRfooUeivpKtY1htnxsEICsK9f7
         E5ql2bG+4s1DtHOKKdrpXy044p38x41eVsw9RIgZFPss5pUUwxst2PuCkvzz9UvlJh
         +1RmkYZhSo9R5pPRI81FNE6r2L6eQHnKUKh4ulAcVwXBKvxh39KYHGOFSKlRQphiJy
         n7ZaF4Z/STeLg4vjvCaaV4QaRvbPk6GKJlpASNp11lAs8w/T/9J6IF4nN+lGAbtnBB
         CfH4t3KPiPU3A==
X-Nifty-SrcIP: [209.85.216.47]
Received: by mail-pj1-f47.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso7090066pjh.5;
        Thu, 17 Feb 2022 17:36:26 -0800 (PST)
X-Gm-Message-State: AOAM532U0FmFG9PBIDONcPzEOkTOvUH1yB2zbXQrBFvot8N0nLqimv0A
        MRSYl7ZbLZwaW1OpeMWCSVmMYI81zjXrQmbV2Qo=
X-Google-Smtp-Source: ABdhPJy0Ae337oqKkEUoK4O3IKhPlww6tXbKq+aJYguPXt6um9PiI+8T8dLczPOUtLJexLG3bu+W8fp8Z0qZsjNXFyc=
X-Received: by 2002:a17:90b:4d84:b0:1b9:4109:7118 with SMTP id
 oj4-20020a17090b4d8400b001b941097118mr10117749pjb.119.1645148185337; Thu, 17
 Feb 2022 17:36:25 -0800 (PST)
MIME-Version: 1.0
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
 <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com> <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
 <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu> <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com>
 <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com>
 <2e38265880db45afa96cfb51223f7418@AcuMS.aculab.com> <CAK7LNASvBLLWMa+kb5eGJ6vpSqob_dBUxwCnpHZfL-spzRG7qA@mail.gmail.com>
 <20220217180735.GM614@gate.crashing.org>
In-Reply-To: <20220217180735.GM614@gate.crashing.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 18 Feb 2022 10:35:48 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ3tdOEYP7LjSX5+vhy=eUf0q-YiktQriH-rcr1n2Q3aA@mail.gmail.com>
Message-ID: <CAK7LNAQ3tdOEYP7LjSX5+vhy=eUf0q-YiktQriH-rcr1n2Q3aA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in net/checksum.h
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 3:10 AM Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> On Fri, Feb 18, 2022 at 02:27:16AM +0900, Masahiro Yamada wrote:
> > On Fri, Feb 18, 2022 at 1:49 AM David Laight <David.Laight@aculab.com> wrote:
> > > That description is largely fine.
> > >
> > > Inappropriate 'inline' ought to be removed.
> > > Then 'inline' means - 'really do inline this'.
> >
> > You cannot change "static inline" to "static"
> > in header files.
>
> Why not?  Those two have identical semantics!

e.g.)


[1] Open  include/linux/device.h with your favorite editor,
     then edit

static inline void *devm_kcalloc(struct device *dev,

    to

static void *devm_kcalloc(struct device *dev,


[2] Build the kernel









>
>
> Segher







-- 
Best Regards
Masahiro Yamada
