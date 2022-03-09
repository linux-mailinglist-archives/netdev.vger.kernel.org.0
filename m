Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4BF4D3666
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiCIQv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbiCIQso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:48:44 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91214A8898
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:42:41 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id jq9so2471160qvb.0
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 08:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=japqQLXCRrV8PCyHdjA0uszSf6L92AW4oPss1TXIsWM=;
        b=YEYF7JoCcxDzDBVSnjS+ga5AgbGOXh4sOcKrKZEU5QBVncPfwSPmg6LSrs/QC3PsLF
         /+9JFQAn+r9fJl77zBKg9t//yL+2PzT5HBUK787sxVcshza9RNhkfc0a4syrSFT97yik
         IzPlbHjzk1rg26EZtx3A2dtTgvXyPYLEFqptDLbXKzoazmmrKTZRcEfI3Snhas/lz/uh
         355WsbRWYPr//soUfvzr2HH/REVZT5pe1CW4uNHno3L42cYvjwHU1foeYcJ1IYPU9XGt
         5eU8J1np46Q9bAO6+ksigOaMfwzLBbDXNDO8kcZGeUUPDmvbDqqshspO53tUp2Gk+iTK
         IqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=japqQLXCRrV8PCyHdjA0uszSf6L92AW4oPss1TXIsWM=;
        b=gmiO9iKaaZZ1T1Jj/IQ05tNYs9zBo/5mA0SzApLlwLnOxYUtx3OZVuaepBZq1zOBlO
         69KFMnLVau5M3h6GBdcmox2A+hdAX9wsiiL3z5RnGdWqQhCBBkZMhgvxTuDIbW5SYWJq
         tK+69N+V/BZzQ6BPKXxLmh2bWFAr2fXYqEJNyAWLrVsqXZ8dLPRniWzfDITN18u/b1pE
         FF4DltQuHrF7qGURngVN6DwCuN+ZaAvEJDerip+GiclaBrij3QwniwENq8tSpMlq8QE9
         2mfMmr1kONjn/NtU5tN49/L83ozymoYM2CkZk5bijipeXU1EJdsMFlBFWvsS2uSm7gc0
         ZlTg==
X-Gm-Message-State: AOAM532BX8YZw/Rv8Lyi/IUGOd5mOyFSlLEF+shvMRtMpxqLXWpmdQM2
        ARrSccsMS6iZGGjol3tBqoox/TTui22/Pr3mGfrJ/w==
X-Google-Smtp-Source: ABdhPJyBFTnJ0QD/X5H8JpxBuFQKo1xSx5xXQfP/XbipAA7zy7gjc3qVOt7xionOjtFksiWbeEzc1bBiWlao4xcDMNw=
X-Received: by 2002:a05:6214:627:b0:435:cddc:3db0 with SMTP id
 a7-20020a056214062700b00435cddc3db0mr354477qvx.47.1646844160437; Wed, 09 Mar
 2022 08:42:40 -0800 (PST)
MIME-Version: 1.0
References: <20220308030348.258934-1-kuba@kernel.org> <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
 <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com> <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
 <20220308161821.45cb17bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308161821.45cb17bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 9 Mar 2022 11:42:24 -0500
Message-ID: <CADVnQykz55R-UVu4RbP=uYBaK309X7oCpDk=JyUy=VudJ7z+ZA@mail.gmail.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 7:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 8 Mar 2022 11:53:38 -0800 Eric Dumazet wrote:
> > Jakub, Neal, I am going to send a patch for net-next.
> >
> > In conjunction with BIG TCP, this gives a considerable boost of performance.
>
> SGTM! The change may cause increased burstiness, or is that unlikely?
> I'm asking to gauge risk / figure out appropriate roll out plan.

In theory it could cause increased burstiness in some scenarios, but
in practice we have used this min_rtt-based TSO autosizing component
in production for about two years, where we see improvements in load
tests and no problems seen in production.

neal
