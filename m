Return-Path: <netdev+bounces-2810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB2E704112
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D8701C20C79
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474EF19BCB;
	Mon, 15 May 2023 22:45:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3346C1952F
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:45:24 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F90D052;
	Mon, 15 May 2023 15:45:22 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-757942bd912so431878085a.2;
        Mon, 15 May 2023 15:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684190721; x=1686782721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RYvc5AJ9ic4v+7Jv0Cue6d/v+WlGvy4SGOuFoUu4yI0=;
        b=HaiKlOlnX8LcWlPI8Os1Tl+lYf1Kb+bYS4XKTyzFH8UGat1q2Ndu0974KKemJS9c/4
         077IXP+zU7SUJx9c5FeToKtQ34ZZ2XSYFIjeiSqS9JhTpEPSO/nXtUPU1wPagiEHqy6D
         PnASpY1/izClxtqP8rzYKAnRIupBl8L+UCJy4mUYI/DTYg7ylKRM1wFy54JdDcrpTrAX
         upmwxBEjlMYys/WAvO+oVfaDYnLDTGe9S+gwhxon7Zz3RPYJDoSsjHtg/Xt/mG8iFRpY
         3k6Q1rTVnQqiHAumXM7ZjNMMmMSLV/bYeagRoxT0tHBCZhlgzGK+oUwqdGmE+Y7TIGHk
         fOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684190721; x=1686782721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYvc5AJ9ic4v+7Jv0Cue6d/v+WlGvy4SGOuFoUu4yI0=;
        b=T+wURvocVS6G+Bp7xGVarqeh8Ii9p5eVEhQm6HSVzBNTcTs8XS8D81GHpdD4shHDIV
         6iOmE1NA11Hbr4nu0ZQb0hOpi9dSbPKCIE9h5KJag7GgJ0dexEkR6Dx7xtqEhdzm8fja
         8CJIZ+RHtG0J3QuyRSrDKyxdsTBnVr6mWmN/vs3Lv8Plg2YHYRfCrlLJIJHsxtD5m25/
         vvokYr5phiL+N3NSxMmwNQXtlmNkd5ytOlohTqQtYmuSeij0+VJmepZqOPVpWlFrfHDI
         18ZyxRmVcmRy+3YgG6FFsIuXDJDA/aHd93qhvBmViXjl8uUu56FBmy2dC+D6TpbUZsBn
         CHaA==
X-Gm-Message-State: AC+VfDw6yMrbeNX5NnTA7gpOJEDTTamjapnNSemcu5u4GFLGmsNiMBSm
	uQgKl/4ao9DGjwFrLwXeyQ==
X-Google-Smtp-Source: ACHHUZ5cwxDprX2wc4Vs34Xs79euK1IfX+4P9wu6q6zhhCSdqHaXYd9cksut7gu/eQGwPBBJyeTHYQ==
X-Received: by 2002:ad4:5e88:0:b0:61b:6e28:5c3a with SMTP id jl8-20020ad45e88000000b0061b6e285c3amr58508422qvb.27.1684190721396;
        Mon, 15 May 2023 15:45:21 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:65a5:6400:e9e0:2451:1fdc:4815])
        by smtp.gmail.com with ESMTPSA id bv24-20020a05622a0a1800b003f3c9754e1dsm5166927qtb.17.2023.05.15.15.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 15:45:20 -0700 (PDT)
Date: Mon, 15 May 2023 15:45:15 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZGK1+3CJOQucl+Jw@C02FL77VMD6R.googleapis.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <20230508183324.020f3ec7@kernel.org>
 <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
 <20230510161559.2767b27a@kernel.org>
 <ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
 <20230511162023.3651970b@kernel.org>
 <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
 <ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF2EK3I2GDB5rZsM@C02FL77VMD6R.googleapis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 05:11:23PM -0700, Peilin Ye wrote:
> > > ->init() may be too early, aren't there any error points which could
> > > prevent the Qdisc from binding after ->init() was called?
> >
> > You're right, it's in qdisc_create(), argh...
>
> ->destroy() is called for all error points between ->init() and
> dev_graft_qdisc().  I'll try handling it in ->destroy().

Sorry for any confusion: there is no point at all undoing "setting dev
pointer to b1" in ->destroy() because datapath has already been affected.

To summarize, grafting B mustn't fail after setting dev pointer to b1, so
->init() is too early, because e.g. if user requested [1] to create a rate
estimator, gen_new_estimator() could fail after ->init() in
qdisc_create().

On the other hand, ->attach() is too late because it's later than
dev_graft_qdisc(), so concurrent filter requests might see uninitialized
dev pointer in theory.

Please suggest; is adding another callback (or calling ->attach()) right
before dev_graft_qdisc() for ingress (clsact) Qdiscs too much for this
fix?

[1] e.g. $ tc qdisc add dev eth0 estimator 1s 8s clsact

Thanks,
Peilin Ye


