Return-Path: <netdev+bounces-4572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C46570D44E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAF1E2811E3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E9A1B8E7;
	Tue, 23 May 2023 06:50:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A114C92
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:50:39 +0000 (UTC)
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4C7118;
	Mon, 22 May 2023 23:50:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-62577da77d0so10194286d6.2;
        Mon, 22 May 2023 23:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684824637; x=1687416637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o7SNpUk9L8sPTDBesPpfIbr42FYbwR5/O0DPmZt9cV8=;
        b=hHUqRqNTlMReguiCCvffdP2wrFSJFf3TSURl4lwfFDtiEZXguhZ+NfI4UjRcisb+G3
         iPKdiXHsPr5ZXPBcjgpndl3ahXhpFuCx6Kj5d+AeXivyyt/knoVEK1USgOGhVdQNcT/c
         zhiqcqbg7zpcHx0r/bwqS26g1eVMovisDNX5bK6WFqvQn/W0eUnaY7Jwu7a2azBot6j2
         r0Gzti4y/0nQ744UwOQNvbTT31X+3r61TVvI1/gUlvdSOTb2t3CfsBC6uI8v3NkT8D/1
         HZplETrhfV8ceIn59DkKNRBH5unXPDJeoAKCw2GDPxF2qjpmsjrm3TgsG7Co2KRzq43m
         3+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684824637; x=1687416637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7SNpUk9L8sPTDBesPpfIbr42FYbwR5/O0DPmZt9cV8=;
        b=YLHyim26d8KhJnN1PTgAr1nNN2pnm3+0As2163J9GrHuSN/55mE3b0Cdj5Mnj7ph95
         zAkQ769P8BQ4i+VhJ55YZZyAXz7Kq53/2uIS2ncUQwVqF+kIcswT+Oz+7UILG9FEE0BP
         EtFOfEV9QDIYLEYDcXGa+1+Jca0xY6FyxFA7NBF0kA0drTXpHLs9bPjAX/ynxHrf8gJ4
         nPiyA9NdwARlooTBbaRq5ZI8c/a7oBikrkJZUlB6+7ksLhYLCxtbG+/yQdA7Gqe3YMye
         UXQhCgS+lSCXKLo9X2KYeEbT9jjs2s239cJ89D+V21bsuNtoCe23mEiUi3FutxYVl0hZ
         6UxA==
X-Gm-Message-State: AC+VfDzDBTZUEsPTybD6yz6JTW8J3bOgbUmFDlROtNPvrCOCpbjFpUe6
	oWEnlO2tABvV1J2Im6jk6Q==
X-Google-Smtp-Source: ACHHUZ7iFOu1kBXeCGLp+5dV7nz1aIFPnn0Cy+XDl1fEus8Qkix9+zwyJn4EtWE8lDAcG89ErXB8Tw==
X-Received: by 2002:a05:6214:4005:b0:5ef:50a3:f9ca with SMTP id kd5-20020a056214400500b005ef50a3f9camr21076901qvb.47.1684824637525;
        Mon, 22 May 2023 23:50:37 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id ff20-20020a0562140bd400b006238b6bd191sm2497225qvb.145.2023.05.22.23.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 23:50:37 -0700 (PDT)
Date: Mon, 22 May 2023 23:50:31 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <peilin.ye@bytedance.com>
Subject: Re: [PATCH v3 net 1/6] net/sched: sch_ingress: Only create under
 TC_H_INGRESS
Message-ID: <ZGxiN8raxTcdqinD@C02FL77VMD6R.googleapis.com>
References: <cover.1684821877.git.peilin.ye@bytedance.com>
 <72c5a2b8ae1c3301175419a18da18f186818fa7c.1684821877.git.peilin.ye@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72c5a2b8ae1c3301175419a18da18f186818fa7c.1684821877.git.peilin.ye@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 11:19:44PM -0700, Peilin Ye wrote:
> From: Peilin Ye <yepeilin.cs@gmail.com>

Wonderful.

> From: Peilin Ye <peilin.ye@bytedance.com>

Sorry,
Peilin Ye


