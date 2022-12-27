Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF68656730
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 04:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiL0D6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 22:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiL0D6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 22:58:31 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04BC6334
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 19:58:30 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jl4so5901504plb.8
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 19:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4pnD+VKmtWNyIz77k45GFBFGYjPCVlBkVaePeWHK0Kg=;
        b=jUBvjqRGrNGCo6oaPjntISpTmEOKivvLVUa2tl6Isxc5B8oxUWzfuLfuqsT79J6Vus
         FQw7FLMAC7qzgcFQLhKZbOj1ux9gMttcuungDOVEXavXrMlUb5jxJWMhwbYvux4sbZ0+
         1YYcq/E2av3BwJ7maJaVj+AmoVA3C73GMsjdE2lYAVf4lGBXtLPlinI1FvhrghNFu7g6
         NxU0iEQtLzB02MouB745WNtBIZWlM2hnHI/egCBhxU/VoyNI3Rs2wtWrfnrsj+DN1QW0
         ojarGrPVIwmDb8hTK4BTtzuKM1Uj4fDGgdvnvrarhHUXQ/cUHIwdnPRqmrBJ88tRbpPY
         49Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pnD+VKmtWNyIz77k45GFBFGYjPCVlBkVaePeWHK0Kg=;
        b=Xj07rVRMopu26yubslLLswa75n7wItoPSkmZ/EeWOAbVTlw1gUScayUQdnJZggwWOi
         3fZ2B7pp3bdb6fscL3RQGB9+BVtso0dqxKK8otWOxhkDUurzLb19SlU5FvmgrByTY5Ys
         seUPWhK6WZI0F5DTC2dty5kFQx+J2usdMCa3lUvCpaN6Joi2RGgbbUnbxrk65G8IN0Yy
         Baqh0CiDrClaNJh+aZC/UcPblqnSSJ9rNHNlSDdlQUkr+GECbSUFFa+b6yzDLZK7jkCm
         J7P8RxlVVpc4yZvZ4Ij3uDxfJmz4eNobLU7E9VMAQbaNUBiEbvcGidzVlFYveUeNVACm
         EfVg==
X-Gm-Message-State: AFqh2kpqq8XCP9cAma20lF/muhQikLTDKpPhhrIB6Xa6JY+FUFRnXIli
        cKcSezj7//Wfxe+S88Nf8/8=
X-Google-Smtp-Source: AMrXdXtUad5hl7ZOl9UXVloqy7j6PWCKu/ZMFD6gqQL0tgcps/jMqaqTbPJLWIK/tg104jkCtsw5EA==
X-Received: by 2002:a17:902:8bc6:b0:187:16c2:d52c with SMTP id r6-20020a1709028bc600b0018716c2d52cmr23216535plo.50.1672113510189;
        Mon, 26 Dec 2022 19:58:30 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n16-20020a170902d2d000b00176b84eb29asm7753946plc.301.2022.12.26.19.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 19:58:29 -0800 (PST)
Date:   Tue, 27 Dec 2022 11:58:23 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
Message-ID: <Y6ptX6Sq+F+tE+Ru@Laptop-X1>
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org>
 <Y6QLz7pCnle0048z@Laptop-X1>
 <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org>
 <Y6UUBJQI6tIwn9tH@Laptop-X1>
 <CAM0EoMndCfTkTBhG4VJKCmZG3c58eLRai71KzHG-FfzyzSwbew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMndCfTkTBhG4VJKCmZG3c58eLRai71KzHG-FfzyzSwbew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,
On Mon, Dec 26, 2022 at 11:31:24AM -0500, Jamal Hadi Salim wrote:
> My only concern is this is not generic enough i.e can other objects
> outside of filters do this?
> You are still doing it only for the filter (in tfilter_set_nl_ext() -
> sitting in cls_api)
> As i mentioned earlier, actions can also be offloaded independently;
> would this work with actions extack?
> If it wont work then perhaps we should go the avenue of using
> per-object(in this case filter) specific attributes
> to carry the extack as suggested by Jakub earlier.

Yes, I think we can do it on action objects, e.g. call tfilter_set_nl_ext()
in tca_get_fill:

tcf_add_notify() - tca_get_fill()

I will rename tfilter_set_nl_ext() to tc_set_nl_ext(). BTW, should we also
do it in qdisc/ class?

tclass_notify() - tc_fill_tclass()
qdisc_notify() - tc_fill_qdisc()

Thanks
Hangbin
