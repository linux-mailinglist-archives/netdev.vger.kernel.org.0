Return-Path: <netdev+bounces-8435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B637240BD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 974381C20EF0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C7B15AD3;
	Tue,  6 Jun 2023 11:21:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1ED468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:21:18 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50168E52
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:21:16 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-977d6aa3758so377574266b.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686050475; x=1688642475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WgEiERv4Bqd8wYQ9qGd58dje1mGdDZnpS8Q33NIZosE=;
        b=wnxII4xg6UhjdYQWVBrx+4Svi6hEZiufrEz1S2U8BuPUtzZHyEWdQmhCihcqZd1skY
         8LReU2JOhUXSaM7xm0VEdSDS195XArVE04Rht8GJzldSHrTfKIi7boRXiE3SeFexl66b
         K4CE685yHVi56qYK7JL04MBjZFUQtqDGLzt6GUMGwQnsDTDLdM29ZKJ/2VBcz5h8ZRqM
         AgI6efazcDIQGrMut8pLeVwwCIcVNTqeGsoFE7mqlnCWxSxetrfoigrrqgHUNXZkv1dp
         Ylhpggwz8/IWa94OQbrCMMJPA5KivrOjvysN0WT0NNRac3Y/9b9N+X5CXnHMV5ogRDK2
         aP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686050475; x=1688642475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WgEiERv4Bqd8wYQ9qGd58dje1mGdDZnpS8Q33NIZosE=;
        b=H/KtJEvdB9xrB4MBBONR8TL8NWSKRjnnR7h5TwTSTumaKL5w5eT9sCnCQzPqYRWtTg
         iOXAstHdzU3AdsG8IlVu8dbF1bf9UTskoyoMHF1mzI1Spiu4913OEaJtgHLvJmfvNV7f
         hdXQjCxZAEy+3hi2lLkGTAp2SmF4sa6czbMHltSC+ZSOUKbsfkPMVC+Yp5ozxCG7Jdg7
         DWpXYLZaW+l0F7qJVD6I6qxqBoOL+Q2ZxY6GwbV2wBK8yymCWgaeJgkoKuSAJ+HeV99J
         n/cJaqREKiqS7Nsm5FS7SilKGo4gVoa1MvRttzg3gbdMipdoPUUr28lSj3cb3SDk2cb/
         q7tA==
X-Gm-Message-State: AC+VfDzfcxL5D4Qebw/Gg0YrvH4JlnqTi/9YT+yACul2AP/p+50aSl8f
	Bop9OPmoCuBkow9dXoMe9XzlCw==
X-Google-Smtp-Source: ACHHUZ4W8h7HbUt/slejTdu2ShesuI6S68HrQo12VgfWHb2zXa8uQ1H7x1LX41CnzWzS5T/bNEja7A==
X-Received: by 2002:a17:907:8a08:b0:973:ad8f:ef9b with SMTP id sc8-20020a1709078a0800b00973ad8fef9bmr2301783ejc.5.1686050474742;
        Tue, 06 Jun 2023 04:21:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v3-20020a1709063bc300b0096650f46004sm5412062ejf.56.2023.06.06.04.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 04:21:13 -0700 (PDT)
Date: Tue, 6 Jun 2023 13:21:12 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
Message-ID: <ZH8WqFQZrniml8Yq@nanopsycho>
References: <20230605070158.48403-1-hbh25y@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605070158.48403-1-hbh25y@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, Jun 05, 2023 at 09:01:58AM CEST, hbh25y@gmail.com wrote:
>try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
>implement the corresponding function we should call module_put to drop
>the refcount.

Who's "we"? Use imperative mood. Tell the codebase what to do, what to
change, etc.

Code-wise, this is fine. Please fix the patch description.


>
>Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
>Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>---
> net/sched/cls_api.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index 2621550bfddc..92bfb892e638 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -2952,6 +2952,7 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
> 		return PTR_ERR(ops);
> 	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
> 		NL_SET_ERR_MSG(extack, "Chain templates are not supported with specified classifier");
>+		module_put(ops->owner);
> 		return -EOPNOTSUPP;
> 	}
> 
>-- 
>2.34.1
>

