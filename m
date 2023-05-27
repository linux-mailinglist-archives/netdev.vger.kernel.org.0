Return-Path: <netdev+bounces-5861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 356C5713349
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C7B62817A2
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 08:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AAC17E9;
	Sat, 27 May 2023 08:23:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3977E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:23:38 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77FADF
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:23:36 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f80cd74c63so13436991cf.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685175815; x=1687767815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KLZQgG6zEDDslIDDAXjje7aWMS1J/DrPvGUiBrKkWZQ=;
        b=bHqZRTEtIAZXW127qypzQwyDfPT980hPFiz2naGdYYXOC2Qc6YVP1gPMXfJkSB5cZ3
         NJfPB1CGkB8op0ZqAO92gScJ69K+YDV4ORTxDDQzvXmilNAWARzs4dJ91Dp5ebgAXQfv
         wSHm0ffcucYPAm6oq1uOgPUYfeXS2u/la4ICG7Kgz77LqS3Bm2qTyJaZo52bdSa1LUMe
         HPBMG3rxDV0p65nriEJUMyThDP3Q/FXVPKypVLC87gOdPuIKR3JMye2vVjY+1rWHOFV5
         t9bRNmlegpSEMIok7BSOj400qvWtj4V0nrgmdaRHbEV+15tOVm2byFaqIbjytdxQbx0e
         KTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685175815; x=1687767815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLZQgG6zEDDslIDDAXjje7aWMS1J/DrPvGUiBrKkWZQ=;
        b=P7Nkf3dOqCEfNjwtRTt7/SmjNVxMPnUhFGT6If5loihuZDVumjQ80ujv+2NSO3Vdlb
         wClqDCw6JxvetWjaXg7jiZNWSNE+ee83VKx9OwY9jpjqAvAztwAfVfAAuO9qlMqJ1m4R
         8AzbGBOuzV9snHrQ0dEitV/qBVyr6U+tWQhoFiIqR/GUqJRnkNA8JGGBAlE/cRiraUpc
         OVWHnj9lXPvFmynAWMAAzqOG8JYSxgnJ1YB1HI/Eel+gXMgF8WqjPYvBN04VNVaVdtGA
         Uao9AemtrAjGaRRPHf60Kb7m2Zezemzm7bwRwRVHU7ccnfYdH8hqqayAgvR5rGo7LcnI
         rtpQ==
X-Gm-Message-State: AC+VfDyc7RIix6qNHE6VIYsT5OC6Kci2A3AGKCgXiqvR9HucJjAelvb+
	su+vBiBzndJ2jowr+Xu3rw==
X-Google-Smtp-Source: ACHHUZ7DeD/pb+zJEX0AeWuJY5DL9H820EYLx0GFmbHp3Phg23+l+IsxCosowfQaVmxpu5ZEp5eJfQ==
X-Received: by 2002:a05:622a:48e:b0:3f7:f5d4:33af with SMTP id p14-20020a05622a048e00b003f7f5d433afmr4145292qtx.33.1685175815598;
        Sat, 27 May 2023 01:23:35 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:65a5:6400:9cc6:6c8:ad49:fed])
        by smtp.gmail.com with ESMTPSA id f2-20020ac87f02000000b003f6b0f4126fsm1924761qtk.8.2023.05.27.01.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 01:23:35 -0700 (PDT)
Date: Sat, 27 May 2023 01:23:29 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
 <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
 <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526193324.41dfafc8@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub and all,

On Fri, May 26, 2023 at 07:33:24PM -0700, Jakub Kicinski wrote:
> On Fri, 26 May 2023 16:09:51 -0700 Peilin Ye wrote:
> > Thanks a lot, I'll get right on it.
>
> Any insights? Is it just a live-lock inherent to the retry scheme
> or we actually forget to release the lock/refcnt?

I think it's just a thread holding the RTNL mutex for too long (replaying
too many times).  We could replay for arbitrary times in
tc_{modify,get}_qdisc() if the user keeps sending RTNL-unlocked filter
requests for the old Qdisc.

I tested the new reproducer Pedro posted, on:

1. All 6 v5 patches, FWIW, which caused a similar hang as Pedro reported

2. First 5 v5 patches, plus patch 6 in v1 (no replaying), did not trigger
   any issues (in about 30 minutes).

3. All 6 v5 patches, plus this diff:

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 286b7c58f5b9..988718ba5abe 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1090,8 +1090,11 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
                         * RTNL-unlocked filter request(s).  This is the counterpart of that
                         * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
                         */
-                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
+                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping)) {
+                               rtnl_unlock();
+                               rtnl_lock();
                                return -EAGAIN;
+                       }
                }

                if (dev->flags & IFF_UP)

   Did not trigger any issues (in about 30 mintues) either.

What would you suggest?

Thanks,
Peilin Ye


