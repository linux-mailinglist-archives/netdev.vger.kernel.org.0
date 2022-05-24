Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2225331A0
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 21:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbiEXTNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 15:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiEXTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 15:13:52 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3EC5E755
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 12:13:50 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id n135so8918203vkn.7
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 12:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=arw0P8k+NP+OLvn8slPhK0vapAkPJiFCnnKrTlVQ2dQ=;
        b=fxvtpZoMh3OxVUEMAN40o3IvR5U82FZpExl+aNvCRdeXPMP55fmp0E9E2vBJzMqCTV
         jBP5m31O17jQ5xU7MQa5MlO5guYLQ3qWxiuIC3cBvWvYBTZG6UDjYgUB/nyctTfx1aoN
         f9Eif2wr7/H9cioRTrphJi95DNyoCafZsHzOz8Q47SkqcCODUTfeEeYuR63lgbT7cZtK
         rkMkPoITnwhkw8WRsAgT2VEygjoTGop6Yc5Kko7RdsnfS7K8h9FmzkCt44b71NsINXfN
         wmHOhnaGa4mPDsK0Lpzzo5xsjgB67mPrbv17LZNQos8baQI7xGrHw9L92dV650bV6eqq
         1dxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=arw0P8k+NP+OLvn8slPhK0vapAkPJiFCnnKrTlVQ2dQ=;
        b=x8tyxH7r1VdCOWU43nKaM7Q+PIlCFbHVaThICfXUGBx9Y76A5wT3gJ+QPQHlQZlmcQ
         MstFIFE1ju3nLy1jRm+I4CeVSBejKhKP2BphTvf9Of4lHxgWvSxA0kmU4EwyJry4byV1
         FSvixCGSubVitDsnl9svVvMG1EbXASVm/KZJMhzabY7ZD7sqj3EcMjfQcmrwJvI1PxXI
         4roeKZj1Figtp4Ry0hxKsKwl6lR+PQTUln4fZDWXVtF0PUE98a6bcZ5nWbF9lo6vJ34n
         aDfLOurCiT8IptLGWnHBGTPpX3f452aQp9627/js+NY8w/5BDmbFmomTClnZsSlKLwPP
         PYow==
X-Gm-Message-State: AOAM531NTnmEnzP/LeVxGInk9k5/jkJ4opKYwyT7aiKd66i8Rq3m9pYG
        Hzn13bhG/XLD/uLhyyL9tt4DuH4DCES+lwwahaxDgpqU3W4FnOzZSgbcXRkP
X-Google-Smtp-Source: ABdhPJzbe8mU6UivvBusoIgMkyxDmasRo/Ssvre4GWIZJFJyJ7SbePKAsUS72W2ZVofxJ5/fCgW2awFKpTCyABE3a8E=
X-Received: by 2002:a05:6122:8d5:b0:356:deb3:3c50 with SMTP id
 21-20020a05612208d500b00356deb33c50mr10429991vkg.28.1653419629512; Tue, 24
 May 2022 12:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220522031739.87399-1-wangyuweihx@gmail.com> <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
 <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
 <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
 <797c3c53-ce1b-9f60-e253-cda615788f4a@iogearbox.net> <20220524110749.6c29464b@kernel.org>
In-Reply-To: <20220524110749.6c29464b@kernel.org>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Wed, 25 May 2022 03:13:38 +0800
Message-ID: <CANmJ_FN6_79nRmmzKzoExzD+KJ5Uzehj8Rw_GQhV0SiBpF3rPg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time for
 periodic probe
To:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, yuwei wang <wangyuweihx@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 at 02:07, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 24 May 2022 17:32:57 +0200 Daniel Borkmann wrote:
> > Right, maybe we could just split this into two: 1) prevent misconfig (see
> > below), and 2) make the timeout configurable as what Yuwei has. Wdyt?
> >
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 47b6c1f0fdbb..54625287ee5b 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
> >          list_for_each_entry(neigh, &tbl->managed_list, managed_list)
> >                  neigh_event_send_probe(neigh, NULL, false);
> >          queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> > -                          NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
> > +                          max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
> >          write_unlock_bh(&tbl->lock);
> >   }
>
> FWIW that was my reaction as well. Let's do that unless someone
> disagrees.

I agree too, so there will be as following parts:
1) prevent misconfig by offering a minimum value
2) separate the params `INTERVAL_PROBE_TIME` as the probe interval for
`MANAGED` neigh
3) notify the change of `INTERVAL_PROBE_TIME` and set the driver poll interval
according to `INTERVAL_PROBE_TIME` instead of `DELAY_PROBE_TIME`

I still have doubt about whether we need part 3, or if exist this scenario:
- the NIC offloading the data plane.
- the driver needs periodically poll the device for neighbours activity

May I ask for further explanation?

Thanks,
Yuwei Wang
