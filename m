Return-Path: <netdev+bounces-7134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5540E71A390
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D01D5281772
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032A734CE2;
	Thu,  1 Jun 2023 16:01:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E75BA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:01:16 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA5BB3;
	Thu,  1 Jun 2023 09:01:12 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so10242375e9.0;
        Thu, 01 Jun 2023 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685635270; x=1688227270;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPluXae0kyLKtWpiruh6/0ByQLwFOTT0OPGO9YuUBHw=;
        b=Y9Rh6cHGs1r5HIUvwJkITLFjYF8HCHgzYP78DgSUGUTttn3d9lzNr0mIMqeRNsO7kl
         1yFxyp0oCsDpRsC6eA6dRmmZ9aqv6cVIucK+vcy3V3bJEVRBKcC4CMQl2ImGwS2svTa+
         WnzcUV2t7iu/980RlRa26Z1Ep3Ymmm6klcooLjte4AUmw2phgSTVn1hrh8gghPYW3Tgg
         4l3Wcjn/mSmAHPx+OFvfwxIulpyLeKxRd1iKQK5W0YPTQmsq4m1ADjByPFOqWIYpgGDE
         JEiyUxNkkJO7rolXf71HnNpRNWzPCzEJxeIHlEP2HWIF/2Nu4nHmZngF+pQo3A+TsVuz
         p38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685635270; x=1688227270;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPluXae0kyLKtWpiruh6/0ByQLwFOTT0OPGO9YuUBHw=;
        b=c4j3HLTx4Q2kz6Z+P1z9n7sKxoIgyQAfT5G6Dpt88g0/w+J+Wn48dvVsANxFeXQFSZ
         qgh3sWXifqyQMDrkmHqyz3Rf51FRoPARWjzQLAmhdkaxyxf45XTRPbA7olUsrzMEZxx1
         HnZ+m2og5fTL3g//eUD25qOVJ4E1aDL5JlD1suiEhNFsbpVlKFwwMuSa/SdltqIlBHGT
         lwhlUHkjrvnv7erdOMTlNu/hfFy7Mr2/Y/zGNAcCMrqlBDwG9tQ2NKNfuzXFQHKLH5G1
         33zWshGxD4bwNQJvbMJYILUs9cTY11NHP2FTlbHPKUNrJczCQmstaw59m80RcuU+WITj
         cxRQ==
X-Gm-Message-State: AC+VfDzcI58Zdzeim8U7S0C1Ol9LKJu70/cXpdz04EeewZRUCZptHD9O
	Ao9UUvin3kgeG82Ewk6EunU=
X-Google-Smtp-Source: ACHHUZ7b4QzYijfgMCjsDy6QBL7LPHe88w92aErLp/7g9WoZQqMWeNykfecuWWnxrMjqmYNZqskTZQ==
X-Received: by 2002:a7b:ce16:0:b0:3f6:444:b33e with SMTP id m22-20020a7bce16000000b003f60444b33emr2488794wmc.30.1685635270466;
        Thu, 01 Jun 2023 09:01:10 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id c17-20020adffb11000000b0030633152664sm10683590wrr.87.2023.06.01.09.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 09:01:10 -0700 (PDT)
Date: Thu, 1 Jun 2023 18:00:53 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	lixiaoyan@google.com, alexanderduyck@fb.com, lucien.xin@gmail.com,
	linyunsheng@huawei.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] gro: decrease size of CB
Message-ID: <20230601160051.GA9082@debian>
References: <20230531141825.GA8095@debian>
 <20230531143010.GA8221@debian>
 <CANn89iJme7C4p1v6fnhUdXccgXQ3-9tUqFHbfjGMbGVqUtyT=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJme7C4p1v6fnhUdXccgXQ3-9tUqFHbfjGMbGVqUtyT=Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Could you add a comment here or in front of gro_try_pull_from_frag0() ?
> 
> /* Must be called before setting NAPI_GRO_CB(skb)->{age|last} (/

Of Course, I will post a new version with it.

