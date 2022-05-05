Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E551CADB
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385355AbiEEVBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 17:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiEEVBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 17:01:17 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83D25D640
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:57:36 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id y11so3649721ilp.4
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 13:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8YC8W9B91rXlP/MWeXz615ZAZibC3F+FRMvosrxHK8A=;
        b=DJggn+M8CsI29ONQJ1zm0CBr6vfHIx/OzhHcEPgLwYHsm3Dny70RRnWhu9vg1C+WDs
         AxF0mwZLD8aVdgD0KOR+fAjaRVke8AHOQkDbJhk2O+iAz6BrSFka36cDefOdCOHDHn+r
         HU4AuGfjDwMSkKuUDPbdOnDqxF5rp6keCQ9dI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8YC8W9B91rXlP/MWeXz615ZAZibC3F+FRMvosrxHK8A=;
        b=rErmJjgyTXuU2TRgG/e5vDVWiH3o0rgIemFN3k8wvDBnxCKFk/3q3PzL0UJNRRGC0D
         9uY/wtN8xbhcu5+d3dXwZE0tlaQCVxIRB5IBCCMPmDCgwLfhRLOvjHyvPxTL6SEmFYtt
         UnveKmWKxR8yLM8CJJzF/tNRfxAnpmxEvwKU5Ecm/yp1r1DA5nsHGdJHRTmf5ospOt66
         Mq6UYsu73t4iBg2/IrkHoehjMuczHLY/4Q+IbmCAZJdP4PzoFQdJyTqwUeXSdonRQ2M2
         FP61NiE7j2ZzEu/5NjPsPG7OnwgeOQHLHUaF3mAPuXiUsJVwYMXsUOHOkXZqgp5Gwb06
         XQgQ==
X-Gm-Message-State: AOAM530777m9Vzm6ROamdBBEJGvlaMNcNwJaT6JTwss/ckKk6GCdZg+s
        mlH2quQNDpO/S+vt48o+8Nhi9jYp79E2GfVPaGVs4pkOwr8=
X-Google-Smtp-Source: ABdhPJzxKZkJXZQjruStiTwU7HCnMNP18Ii6TEjTf5K91VjiWf02IspK1UT787I0vDQtL+3Lp70AXsvncqGsNwodk7w=
X-Received: by 2002:a05:6e02:b28:b0:2cf:4d2a:dc99 with SMTP id
 e8-20020a056e020b2800b002cf4d2adc99mr22011ilu.296.1651784255448; Thu, 05 May
 2022 13:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220418231746.2464800-1-grundler@chromium.org>
 <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com>
 <23cbe4be-7ced-62da-8fdb-366b726fe10f@marvell.com> <CANEJEGtVFE8awJz3j9j7T2BseJ5qMd_7er7WbdPQNgrdz9F5dg@mail.gmail.com>
 <BY3PR18MB4578949E822F4787E95A126CB4C09@BY3PR18MB4578.namprd18.prod.outlook.com>
 <CANEJEGvsfnry=tFOyx+cTRHJyTo2-TNOe1u4AWV+J=amrFyZpw@mail.gmail.com>
 <BY3PR18MB4578158E656F2508B43B21F6B4C39@BY3PR18MB4578.namprd18.prod.outlook.com>
 <CANEJEGuVwMa9ufwBM817dnbUxBghM0mcsPvrwx1vAWLoZ+CLaA@mail.gmail.com> <735b9c21-6a8f-0f28-d11d-bd9bbd78986b@marvell.com>
In-Reply-To: <735b9c21-6a8f-0f28-d11d-bd9bbd78986b@marvell.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Thu, 5 May 2022 13:57:24 -0700
Message-ID: <CANEJEGuPUBQ3c12RkzBsDu0Ub+QAb3BJxA_v8GsDTeq9Uvzt8g@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        Dmitrii Bezrukov <dbezrukov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 5, 2022 at 12:11 AM Igor Russkikh <irusskikh@marvell.com> wrote:
>
>
> Hi Grant and Dmitrii,
>
> >> So to close session I guess need to set is_rsc_completed to true when
> >> number of frags is going to exceed value MAX_SKB_FRAGS, then packet will
> >> be built and submitted to stack.
> >> But of course need to check that there will not be any other corner cases
> >> with this new change.
> >
> > Ok. Sounds like I should post a v2 then and just drop 1/5 and 5/5
> > patches.  Will post that tomorrow.
>
> I think the part with check `hw_head_ >= ring->size` still can be used safely (patch 5).

Ok - I'll rewrite 5/5 to only include this hunk.

> For patch 1 - I agree it may make things worse, so either drop or think on how to interpret invalid `next` and stop LRO session.

I'll drop the proposed patch for now and discuss with Aashay (ChromeOS
security) more.

cheers,
grant

>
> Thanks,
>    Igor
