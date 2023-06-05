Return-Path: <netdev+bounces-8035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB749722805
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85F762811F3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D557B1D2CA;
	Mon,  5 Jun 2023 13:59:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCF31D2B3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:59:06 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7E094;
	Mon,  5 Jun 2023 06:59:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-30aebe2602fso3986097f8f.3;
        Mon, 05 Jun 2023 06:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685973544; x=1688565544;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCDndboYofs1euZozUPZ+wnkvppaYLsmW/x22Y7k9M0=;
        b=pvV+1QGkdTwyZVyWQBE4H57sf4SvOHNIIJwSSDPCX5sbiigvDQx1XAd9yORmbpC0I/
         IgjijCwGDme1HiuHePb3QmZAImM7Tl0y4988DbqOL+QRMGgfuNf/gjjp1TD+3Bs9/QMF
         I1+hUybPmKRwVRvRKyy6xSec8WUJT4or8unei0NCZWL7hPRX1lSGF/owrdy8n32y4KmD
         3v3kuRhQSau4a5Nbs9z7sYNijM++d8pxDB5w7bcJ591ZXeYRhJtGz8LmvBR4/IaNlZOn
         yWxN+HGJiU4g/QZ8JOQ/THt7CztMijvUXp2/uqopPTCQSHie9GdEV0pkeSLGiW30rISP
         /8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973544; x=1688565544;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCDndboYofs1euZozUPZ+wnkvppaYLsmW/x22Y7k9M0=;
        b=EJDhFV6YsUh7JP38S5f1+20nwpSJ0DrSs5l1bjA2D6fYzNIMpGtI/KQn9A9ku0AgoL
         SjtAp4pamFHafBRW1GHbl6PmT68NkqM+sxzuwYiUV65AaAsPvKszloWgX/bBH5XA4maI
         BV//4N+9pkt0XkzXpSyEv6aSTSVN+u8+4IW+0Sy/GKiVdxd4Qs70jk5P0fCUNiPGz7fn
         w5Z+DYMdjrQwMALLZNN79qAVKlG8zemGR0IJMD+t4slLeh9xE23u2plzXoBYIBpz2JLJ
         KqO5VS1Deerts9P7Kj5dmwtzGC7bOUbHJ5QDmdvdVAml9AisMbGBfVYDQ0lehjIWZV2v
         W8ew==
X-Gm-Message-State: AC+VfDyjxNb4zUWApKJGym+jZ1+9ivzl7O3NfBzj+/10BR8u9T5aZrZX
	tKa5bEO6NCpK/O1+p7dBEF4=
X-Google-Smtp-Source: ACHHUZ78YsjSY1NfptdogV0zvYdPfYdfyz8LlSiElz6nTgR68VFQMWzCSU8irsroAhjJD8wIyhd0Rw==
X-Received: by 2002:adf:fed2:0:b0:306:368d:8a1c with SMTP id q18-20020adffed2000000b00306368d8a1cmr4857559wrs.45.1685973543846;
        Mon, 05 Jun 2023 06:59:03 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id j14-20020adff54e000000b0030aec5e020fsm9886635wrp.86.2023.06.05.06.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:59:03 -0700 (PDT)
Date: Mon, 5 Jun 2023 15:58:23 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, lixiaoyan@google.com, lucien.xin@gmail.com,
	alexanderduyck@fb.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/1] gro: decrease size of CB
Message-ID: <20230605135821.GA8361@debian>
References: <20230601160924.GA9194@debian>
 <3f6cd784-767e-02e3-0c30-c0dda12e51ab@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f6cd784-767e-02e3-0c30-c0dda12e51ab@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I hope you've checked that there's no difference in object code with and
> w/o `inline`? Sometimes the compilers do weird things and stop inlining
> oneliners if they're used more than once. skb_gro_reset_offset() is
> marked `inline` exactly due to that =\

Checked on standard x86-64 and arm64 gcc compilers.
Would you check any other cases?

