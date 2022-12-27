Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4D656CD5
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 17:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiL0QXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 11:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiL0QXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 11:23:35 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C9209
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 08:23:35 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-45ef306bd74so190151577b3.2
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 08:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r+ONteBtjOZq2UCk3aJdu41ZWGa4QHSm9wumtsJEft0=;
        b=GlL4kN9HyK6uC+b6jJu7SbEm8yYpy8Ov75+xgppNcTNBL8/S4pQLZ805iiOCyWg2+r
         cPUvgy9YlIoVnd6rIFBGXorGmRkLvJqufQChHdL6nBTCeAQwCZScWanzh2XXDtlphqo5
         RU2oUwsZJjpNRQv9SqW7BwdOg8e1B9O+c/idXW79rIFwqu66+GAgHfSG3T4SEMMyrOjh
         IbFeMkhyOy1zcqItHaYTmA8V7RW0fKsR5JtzAZzamSIPNaiHf7MakgbblPFQIUu7SEI9
         sHE54VjKKkOekTRv535uaCeb9mMddQ78d85o/Lao1aJwxdcnD2Cvg3rlSRvvdM7owoA2
         uv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+ONteBtjOZq2UCk3aJdu41ZWGa4QHSm9wumtsJEft0=;
        b=OOVrVbUXu2XWWwL3UVimpXVlgcEtAt9WHj9MmaXLHE7wNBneRFtX1hVg/9qh9SfuhI
         wiGrQwSdWdjhclg7UBzbydEAbeb6CkP845HMn9L3RrdTXqv2suwasgPmtyy2Wj72WhTA
         0rrtNN7UMXyR3SLRXUDFZssV9yv2P3af5y1SL9SvxmKb9n5tbfPh2Kgi8FO+BX/OnMCa
         e27wdrjm+R5dJl/3vFEybFmjWKLT1j8I5+COrROCi+oi49cweD8Lfstu4kLxmDKGEezH
         YMdCNVSzCdHPiX8+x5pkEAf35tSKECA6kTXmumuzQI1Bkq3hSpGV5j7wtANMle5GTjiB
         BMiA==
X-Gm-Message-State: AFqh2krjEtcqQp+PMca4k55e88jG8xTtbghrPaCrXBoTBsO1IvrOw9oM
        uDJbNZ3DjZrQwZadT99QtLe+cCoqP83s04hGlFAvWA==
X-Google-Smtp-Source: AMrXdXtPhzlooHKWf0vOqr/xB7OutnLSwJf60fWcRYSLPthOk4ROin0ccgHlJDatQZEGNiEljHYB6Y45f79zi96fQ4c=
X-Received: by 2002:a81:652:0:b0:464:1695:fbe1 with SMTP id
 79-20020a810652000000b004641695fbe1mr2230776ywg.395.1672158214337; Tue, 27
 Dec 2022 08:23:34 -0800 (PST)
MIME-Version: 1.0
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org> <Y6QLz7pCnle0048z@Laptop-X1>
 <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org> <Y6UUBJQI6tIwn9tH@Laptop-X1>
 <CAM0EoMndCfTkTBhG4VJKCmZG3c58eLRai71KzHG-FfzyzSwbew@mail.gmail.com> <Y6ptX6Sq+F+tE+Ru@Laptop-X1>
In-Reply-To: <Y6ptX6Sq+F+tE+Ru@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 27 Dec 2022 11:23:23 -0500
Message-ID: <CAM0EoM=rMPpXEs6xdRvfJtXFo8OjtGiOOMViFuWR7QiRQfx7DA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

On Mon, Dec 26, 2022 at 10:58 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Hi Jamal,
> On Mon, Dec 26, 2022 at 11:31:24AM -0500, Jamal Hadi Salim wrote:
> > My only concern is this is not generic enough i.e can other objects
> > outside of filters do this?
> > You are still doing it only for the filter (in tfilter_set_nl_ext() -
> > sitting in cls_api)
> > As i mentioned earlier, actions can also be offloaded independently;
> > would this work with actions extack?
> > If it wont work then perhaps we should go the avenue of using
> > per-object(in this case filter) specific attributes
> > to carry the extack as suggested by Jakub earlier.
>
> Yes, I think we can do it on action objects, e.g. call tfilter_set_nl_ext()
> in tca_get_fill:
>
> tcf_add_notify() - tca_get_fill()
>
> I will rename tfilter_set_nl_ext() to tc_set_nl_ext(). BTW, should we also
> do it in qdisc/ class?
>
> tclass_notify() - tc_fill_tclass()
> qdisc_notify() - tc_fill_qdisc()
>

The only useful cases imo are the ones that do h/w offload. So those two seem
reasonable. Not sure where you place that tc_set_nl_ext() so it is
visible for all.

cheers,
jamal
