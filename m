Return-Path: <netdev+bounces-976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A96986FBA60
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7920028112B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF39125AA;
	Mon,  8 May 2023 21:58:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B102F11187
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:58:16 +0000 (UTC)
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854A210D;
	Mon,  8 May 2023 14:58:15 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-38dec65ab50so2881834b6e.2;
        Mon, 08 May 2023 14:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683583095; x=1686175095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYD9qUfsMKsdWwBMnXikPPjoTvUwobnwMoNDEvNnnaY=;
        b=WaV2njf6ub3jNTiOp6qhZn195Si8U/jN3lbuU76eU9d0hw69Evi5GbXccKITtMejAZ
         YiHJSvy6P1z9SK2NOcjr52AKJ3o3z+3fBkQW+3VtFeXIN4N7SvX9v4oKVGwqEhL2HSSb
         X4C3p6pV0Yv+0anuFQZPlywpoHBByLkGG+ViMfc769ogZouhSogpw8o0I13lYl0mmlcD
         qkR0rsJo+JQhP5swHmZW6WwfQCPnkBwIwEW1l84CuQrCElHStWxl808pbPkGIrQmEZLp
         X5Y17avdEQEmyYMmaMgaK4LBTmSJAme6dMTZqEm8bHXzGLNHn1iR+Ubkeop21ufL2CKX
         9ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683583095; x=1686175095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYD9qUfsMKsdWwBMnXikPPjoTvUwobnwMoNDEvNnnaY=;
        b=QKtCS1Vpuhyx73l18U2XZACE4Gk7f/m6lY3E6firTRaxvHzI4Us819KueLnXPqZ9lW
         b1tXlbm3MEoyGdOQ07C5+HTWd+vQSYB1tpa1+g79r+fZrN9me/TjQEfOA1wCzfiW7uNG
         1jpC6g1FiJmZTlkZB62BWjBxfkdru6OEomCdR9oftCR2soorCCqq61ewmfJVrmEVaJqd
         aa4r/r0LCV+rv6E+8Br3sgrmVXRNmLEEwmWjChl5FvO9wIFfcoSCF3kycLgavHk83mbS
         Dm+uF2xxCvMnNMzNDbs/U3xHTCNwjXH6eSujowy4hHpLgZGYedR2CQHqnKnOimSISAS8
         DzPg==
X-Gm-Message-State: AC+VfDwDfm1zmckvlw+VOq6SeNvKvZVN2vJRqS2okv7XF1xUep0JtQ7m
	0DrCoCHwZ81ark7pw8XKwrT2xVRnzg==
X-Google-Smtp-Source: ACHHUZ78OsFdJ+lCqJLTphN/mSCRDehxvPfjFqsgtyIjGGbcUUXpxLW8hvxzjhxB9ZM0Lc2sfy4rvQ==
X-Received: by 2002:a05:6808:2805:b0:38b:a6be:7a55 with SMTP id et5-20020a056808280500b0038ba6be7a55mr211448oib.37.1683583094687;
        Mon, 08 May 2023 14:58:14 -0700 (PDT)
Received: from C02FL77VMD6R ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id bh11-20020a056808180b00b0038934c5b400sm470195oib.25.2023.05.08.14.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 14:58:14 -0700 (PDT)
Date: Mon, 8 May 2023 14:58:09 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZFlwcYY0nkCEEXFY@C02FL77VMD6R>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <CAM0EoMmFwgmip7pYSLavfXzduWCwS4AyuAON9oXKYAn5G2Yiog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMmFwgmip7pYSLavfXzduWCwS4AyuAON9oXKYAn5G2Yiog@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 07:32:01AM -0400, Jamal Hadi Salim wrote:
> Thanks for the excellent analysis Peilin and for chasing this to the
> end. I have no doubt it was a lot of fun! ;->

Of course ;-)

> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Thanks for reviewing this!

Peilin Ye


