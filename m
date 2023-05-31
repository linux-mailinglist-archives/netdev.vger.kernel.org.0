Return-Path: <netdev+bounces-6632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB88E717269
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 939111C20DA1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DB37E5;
	Wed, 31 May 2023 00:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284747E1
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:29:26 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC5BF3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:29:24 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-5ed99ebe076so52752266d6.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685492964; x=1688084964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ilnrElbgoo0fUR/wUVqGUqQ/XWiCJWwa8sGv7hKxKm0=;
        b=OHy0D1SloksfIMYc/fzxQMzmL77W9+9PiQoMoudlxMRodV+MLpq5pB6/Q+S2tQ73iQ
         Q9fkO819THfgct7aWb69CfcqArjEF1gjvNMFqEWODroqowVZuWLupWnQ+9k7by687ho/
         UinrVvgHHAR8rYX/rGrcSic3EXwGPOVTBnLCTehEO9IBvMs7oEz5XNUG0GAOshMeUFSj
         dBvoDnE3yGR2UxrpQbHMet57ZeRVgxHvxFZHBCCjqPAElhn9loDul5oa8g2b67aqKywp
         PMkjIxAxDKVKQG1Rdscfxc8WuSSeutCaBYtAMhVUDEhtYyB6fIyS+kQJkuPMJ1tPFKCk
         TXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685492964; x=1688084964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilnrElbgoo0fUR/wUVqGUqQ/XWiCJWwa8sGv7hKxKm0=;
        b=EjXI56qXj6W1zTXD84sk2RG893nwh7uC7uhtDCoETaAOF8ZNlISGwiDtLtaNRafhGd
         CCBK5W9aHohqGhjfsq15B75lLCqo11Y+oLZh8CnsO6bYcCj3bw5QwfgHvCSXMtecr0g6
         mqkKicgi7WSFZw3cp9UBErDwA38nxbiUs/VdD2cu+Irq/sMEIDZ1KRRMY6w1vUstuRFR
         k1huQzu+NwNLlkFycFl/n6LXdSaBQnEWU02ia9bq+l6LcIq6mQYVYTeDbjU7XZMkz3NW
         wjt2Z+FmUN2TK0X1xP6qmnlO6vQgit9PgCZikrPJ8nxPB+P3Ux38eCUrKl9AagYl6L+c
         GO2A==
X-Gm-Message-State: AC+VfDwcRosIDQdZgq+BlGZJrChepVm+tPfBpF4fF9DdWm2Hydl8n4NF
	DVDvQwbLOWJP63ejRg7VJg==
X-Google-Smtp-Source: ACHHUZ7FeCNgyXHZjo/uqecVq5Uk85wuJZmN29Hq+eoFVwlS0iO7nsKlvw8tnDddxDsca00n/37MMQ==
X-Received: by 2002:a05:6214:408:b0:5f7:a9e1:bbbf with SMTP id z8-20020a056214040800b005f7a9e1bbbfmr5454331qvx.44.1685492963798;
        Tue, 30 May 2023 17:29:23 -0700 (PDT)
Received: from C02FL77VMD6R.usts.net (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id l6-20020a0cd6c6000000b00626117620aasm3562241qvi.105.2023.05.30.17.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:29:23 -0700 (PDT)
Date: Tue, 30 May 2023 17:29:18 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZHaU3r/h1TyZgq76@C02FL77VMD6R.usts.net>
References: <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bki2xb3d.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 03:18:19PM +0300, Vlad Buslov wrote:
> >> If livelock with concurrent filters insertion is an issue, then it can
> >> be remedied by setting a new Qdisc->flags bit
> >> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
> >> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
> >> insertion coming after the flag is set to synchronize on rtnl lock.
> >
> > Thanks for the suggestion!  I'll try this approach.
> >
> > Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
> > the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
> > later than Qdisc is flagged as being-deleted) sync on RTNL lock without
> > (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
> > even longer?).
> 
> Yeah, I see what you mean. Looking at the code __tcf_qdisc_find()
> already returns -EINVAL when q->refcnt is zero, so maybe returning
> -EINVAL from that function when "DELETED-REJECT-NEW-FILTERS" flags is
> set is also fine? Would be much easier to implement as opposed to moving
> rtnl_lock there.

Ah, I see, sure.

Thanks,
Peilin Ye


