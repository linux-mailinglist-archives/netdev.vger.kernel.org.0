Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45D4E6973
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 20:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353083AbiCXTp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 15:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353082AbiCXTp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 15:45:27 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21183335C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:43:55 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id j15so3858189ila.13
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qLlnXC64OIFFaMc00J42HVbldAWj/pRv6VE+kP34E9k=;
        b=jKAVovxOluF8tT0FLmIGOf1GdzH9Ijr6S9mdz3/++bvQhyLVQjJQjv7zbskhIoV/7M
         UoKX8HX6SDOq9Joo2wU4X4Tkid4lldZEC1Ipw/GNnfqmco/XbDMmPeeXKnSqY5CidoyK
         JMGQfR1R/IvLJybC/wlUWiiDw9LejogtOBgAgwGGGiffPlJqF5yIc+4iaIEiJ+gRp4+K
         4v8IO+IDLSuIyJUOKQuoUvFeEf0TsU4UQguavTdhhk2VtpcMa330etYlFVEjTUX+sW0Z
         loN2SztUv7NYec5q+2P4O6iVguXh4Sw7O/JK9fe7HilVmdajETzh68uD9L4731/DBGup
         c3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qLlnXC64OIFFaMc00J42HVbldAWj/pRv6VE+kP34E9k=;
        b=uTwpIF3Cnkgipkq7gJAN4A3lduhJ3/zyukFDWyP3Rg8sXkx5RaYdeIU9qMF+l1cF00
         ythvXpUArUOD+gME7UxQpytRtvXjzMTnVEeFzb74m1WPtTqwdRzmdcLuj0TQ9mIAj2rv
         U4scRbgEn/NjEHHw14JGbsYMJEiZFrID01CRnzEtoFJSuEDG/Ut6O0jb8exvd1L/d3Vl
         fauSmyGDBDEITM9oqtbqvsqZx0ha6upNE1UTTWur04o9Ba4LyGOaopGtUmXH4yweG47S
         hLkjOH86Dz6vBAmOMEme8f5L0HFdKx43PpHDT3XELAb9UTj2y+i6pjOJTiSJCZTjuPsm
         GlBA==
X-Gm-Message-State: AOAM531nNJitqIU9AQ9TEQVXkuOEQpFNx8ch2adaPnZ2kYQxA961Corp
        0g5ds+dEH7tCy52U0TnTLpvuybF8pzgclLtS2Sfv2g==
X-Google-Smtp-Source: ABdhPJwbOecLeXF9/K4OOQ0vIkULnFkrrGjtVb01iWQZKoEsy2hYoKtDeTK8k+n5Rh03a5MOIGK2JWJj95gCdXig3X8=
X-Received: by 2002:a05:6e02:1526:b0:2c7:b94e:195a with SMTP id
 i6-20020a056e02152600b002c7b94e195amr3331171ilu.225.1648151035304; Thu, 24
 Mar 2022 12:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-3-gerhard@engleder-embedded.com> <20220324134934.GB27824@hoboy.vegasvil.org>
In-Reply-To: <20220324134934.GB27824@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 24 Mar 2022 20:43:44 +0100
Message-ID: <CANr-f5wrm7ASB61-rR9VPF5ePYC4gb4W-1rM5Ym7TixwMQv_Jw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] ptp: Request cycles for TX timestamp
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -683,9 +683,17 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
> >  {
> >       u8 flags = *tx_flags;
> >
> > -     if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE)
> > +     if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE) {
> >               flags |= SKBTX_HW_TSTAMP;
> >
> > +             /* PTP hardware clocks can provide a free running time called
> > +              * cycles as base for virtual clocks.
>
> "PTP hardware clocks can provide a free running cycle counter as a
> time base for virtual clocks."

I'll use your wording here. I'll also update other comments and commit messages
with this wording.

Thanks,
Gerhard
