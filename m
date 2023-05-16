Return-Path: <netdev+bounces-3129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35472705ADF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9D631C20C35
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C9EDF6F;
	Tue, 16 May 2023 22:58:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DB23C15
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:58:54 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6468213E;
	Tue, 16 May 2023 15:58:53 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75795493bceso13399285a.3;
        Tue, 16 May 2023 15:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684277932; x=1686869932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=obGFfPSstGK57Wl5NPoD/AZ7KNFXNho09WEyyfqv2LU=;
        b=ZREduQEloKwVflWTdkehKcRky45p76piWosa/r2L3QZuhh+WYc+abP9gftaMGTaEem
         LRTCRiVJoBKPcIwrDVfFVSWWpt/8hPDwuiw1TONJ7uayYLu5hlW0TBrcXQ5J/5Qy0ksP
         ZaRUOFswF/L8PY9ff2/QEHB+njQrWLVjnJkUPMmxXsFKv+e6QnGnQmBqhWMDCI5HAdqL
         LObPBCArRSRNRbEIa414alNX+0R5kDj+FiIOHXSqACjmJw4CigbQzwos3E/c9p/C0rnG
         He7j9UP5DkZYKo07NNJ6yltATbG4QWMSqcZK3sLpYrtOcu7hNLxRXi+a/asNp0xKPlpk
         n8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684277932; x=1686869932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obGFfPSstGK57Wl5NPoD/AZ7KNFXNho09WEyyfqv2LU=;
        b=OzqN89SNwH2aobvRV0Oz6kTgnjimtJ8ED32wqCms8T4dBB3qsC4TRd1bIvVQjkHsmE
         Chsg0bghmbbQdhDl8udg6xfg/Rfn0R7smYM4wMHjxamMRHBk+iI5T2eo+UJ1tq+cz6hn
         AW/aVG0Rz5ZV7LwUiapy0Mv8xrLIlihw2TzqHZCE4yxe95LeAVjf2M7Na4Hfnce9JVJg
         vnQ3xarz+mxE8QGP6T4pn2K2q1XOL5c7bp/GkQNJY+PGWspbvd5+V0Mml43vpMOusODD
         ZdEFUdW4QQKpAt/qyhzrfnu++h7uO1QDdEd72AeG3n/1W9fh+h0I93xQtk4eM6r357E+
         4v7w==
X-Gm-Message-State: AC+VfDxcytBO7Ojvh9aozeWpjbLYiUNqz53dDypNAl02vrW/Q5pAq2YW
	Q22oqdlyPW6rJmN7O3shoQ==
X-Google-Smtp-Source: ACHHUZ7EoxhVmn5BFmrFzf7EWlm1hXe4pOL/+n4vASsU4cidJmHbNqLd5o5gJUF0ldKFgbwmChZKcg==
X-Received: by 2002:ad4:5cce:0:b0:5ee:e4f8:c7e5 with SMTP id iu14-20020ad45cce000000b005eee4f8c7e5mr60470935qvb.41.1684277932388;
        Tue, 16 May 2023 15:58:52 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:45b7:59dd:1e6c:1110])
        by smtp.gmail.com with ESMTPSA id r17-20020a0ccc11000000b00623813aa1d5sm533307qvk.89.2023.05.16.15.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 15:58:52 -0700 (PDT)
Date: Tue, 16 May 2023 15:58:46 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZGQKpuRujwFTyzgJ@C02FL77VMD6R.googleapis.com>
References: <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
 <20230510161559.2767b27a@kernel.org>
 <ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
 <20230511162023.3651970b@kernel.org>
 <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
 <ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
 <ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
 <20230516122205.6f198c3e@kernel.org>
 <87y1lojbus.fsf@nvidia.com>
 <20230516145010.67a7fa67@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516145010.67a7fa67@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 02:50:10PM -0700, Jakub Kicinski wrote:
> > > Vlad, could you please clarify how you expect the unlocked filter
> > > operations to work when the qdisc has global state?  
> > 
> > Jakub, I didn't account for per-net_device pointer usage by miniqp code
> > hence this bug. I didn't comment on the fix because I was away from my
> > PC last week but Peilin's approach seems reasonable to me. When Peilin
> > brought up the issue initially I also tried to come up with some trick
> > to contain the changes to miniqp code instead of changing core but
> > couldn't think of anything workable due to the limitations already
> > discussed in this thread. I'm open to explore alternative approaches to
> > solving this issue, if that is what you suggest.
> 
> Given Peilin's investigation I think fix without changing core may
> indeed be hard. I'm not sure if returning -EBUSY when qdisc refcnt
> is elevated will be appreciated by the users, do we already have
> similar behavior in other parts of TC?

Seems like trying to delete an "in-use" cls_u32 filter returns -EBUSY:

net/sched/cls_u32.c:

	if (ht->refcnt == 1) {
		u32_destroy_hnode(tp, ht, extack);
	} else {
		NL_SET_ERR_MSG_MOD(extack, "Can not delete in-use filter");
		return -EBUSY;
	}

Thanks,
Peilin Ye


