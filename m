Return-Path: <netdev+bounces-11138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BE1731AB8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72CFA2811E8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E6C171A5;
	Thu, 15 Jun 2023 14:02:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870F915AE9
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:02:15 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFE81FD4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:02:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f8d1eb535eso17038235e9.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686837732; x=1689429732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iuyq1q4Civx77PzFHDpUKjHueDOZzYAPik1VN/lXMjU=;
        b=N4QpRNULdQTn1NUO/iUp8WyMddebbz+L8BZPtSAVMqhZ4jS80V1cWa4Pil0diJQkAw
         DhCHbqsSjI4uM7MgeYO67u5tP/INNBO5NKUjFlmbqaK7LSsGuxrZGQWp6lOhD8LotFLQ
         DupgDjg0yJmIL+/oLVAytEkkpOCG++boHf44jnB3L1ZBz14x2TD6git3VPmDOcfODst6
         aXTgk7lMzTtEc981/Gs1re5ndsa+DPQ0llX5aig1q+CmmP8EKhD7Or/BlHFcswyY5ZQm
         HYX25Pl2pbe0UPEtiJdgxy6LXQvqmy/67SuTOX41SnbFadNOjucM9s1lkqjt6TyXPJmu
         LhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686837732; x=1689429732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iuyq1q4Civx77PzFHDpUKjHueDOZzYAPik1VN/lXMjU=;
        b=b3pCCZ0z9qBcVrCAsSH1Sru9JPa2Fjzv3rwqQc3zgswbrY1RrLhVDBdUgi8nDbUZSS
         RV72EkpKcsb4zpDbcxvU+HtNjrTEd8xGSc6n/2a05/PeMsElUJxTCSNUPDD7gNF9WuJO
         QP71ZUOQf2h/DKpY0u4j9Dx8fHzxFfXuTIm1VswBn9BkYzmWX7lH3vYT1HAI4zArZalT
         jhXmIBxY2l3G9vLYczcE53hQUtpZex/D+XEIJ0G2gyYuqqLEzGeB2KUAkw/kanM3wyvw
         8s90yyPor+ytlE8ARJHviJ1k8ePe7Zv1oquLwH2T+pjzFK8zaiebVyTuctXcIXh9Pddm
         vTYw==
X-Gm-Message-State: AC+VfDw00XN9nVzua9weO8PceACQAESidZneDhUFRN5aIl7WI76oSsGN
	LE73efwpWB+Rl45v/qQd7JXZAQ==
X-Google-Smtp-Source: ACHHUZ4iD1QD4PcU+1Mi7cLd3fj4RqTIZLLfpbM5IniOHsfJxvG3gxKMkIe8r+04/YXuNVSV3DhkBw==
X-Received: by 2002:a05:600c:2204:b0:3f6:be1:b8d9 with SMTP id z4-20020a05600c220400b003f60be1b8d9mr12830537wml.6.1686837731830;
        Thu, 15 Jun 2023 07:02:11 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o6-20020a05600c378600b003f42d8dd7d1sm20851147wmr.7.2023.06.15.07.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 07:02:10 -0700 (PDT)
Date: Thu, 15 Jun 2023 17:02:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: Re: [PATCH v2 net-next 6/9] net: netdevsim: create a mock-up PTP
 Hardware Clock driver
Message-ID: <64c98e79-2de5-419a-9565-2523635bd3dc@kili.mountain>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
 <20230613215440.2465708-7-vladimir.oltean@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613215440.2465708-7-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 12:54:37AM +0300, Vladimir Oltean wrote:
> +
> +	spin_lock_init(&phc->lock);
> +	timecounter_init(&phc->tc, &phc->cc, 0);
> +
> +	phc->clock = ptp_clock_register(&phc->info, dev);
> +	if (IS_ERR_OR_NULL(phc->clock)) {
> +		err = PTR_ERR_OR_ZERO(phc->clock);
> +		goto out_free_phc;
> +	}
> +
> +	ptp_schedule_worker(phc->clock, MOCK_PHC_REFRESH_INTERVAL);
> +
> +	return phc;
> +
> +out_free_phc:
> +	kfree(phc);
> +out:
> +	return ERR_PTR(err);
> +}

Simon added me to the CC list because this code generates a Smatch
warning about passing zero to ERR_PTR() which is NULL.  I have written
a blog about this kind of warning.

https://staticthinking.wordpress.com/2022/08/01/mixing-error-pointers-and-null/

Returning NULL can be perfectly fine, but in this code here it will lead
to a crash.  The caller checks for error pointers but after that it
assumes that "phc" is a non-NULL pointer.

The IS_ERR_OR_NULL() check is not correct.  It should just be if
if (IS_ERR()).

However, the question is can this driver work without a phc->clock?
Depending on the answer you have to do one of two things.
If yes, then the correct thing is to add NULL checks throughout the
driver to prevent a NULL dereference.

If no, then the correct thing is to ensure that CONFIG_PTP_1588_CLOCK is
enabled using Kconfig.  We should never have a driver where we compile
it and then it can't probe.

regards,
dan carpenter



