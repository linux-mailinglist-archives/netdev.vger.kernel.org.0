Return-Path: <netdev+bounces-4044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A43BA70A486
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C023C281920
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D7362C;
	Sat, 20 May 2023 02:00:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D37624
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:00:40 +0000 (UTC)
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9ADE46;
	Fri, 19 May 2023 19:00:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-2533d3acd5fso3570833a91.2;
        Fri, 19 May 2023 19:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684548038; x=1687140038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbtOdWMUbGHFmlrhAZaFe3zlF5reDGxWr2RyYcaH25I=;
        b=dGPrd/nblZTm2Jjkb+GshHfNqM2s/ezF5IwYiWVjYX/VitBs8sn2zKFpJP+aNtE2L2
         Af44AWwh0eSwtY/5j8Q+TAJtteJPhHUxu9fnD6lvz8oYReePTibbXaF1q9UcT1KfnqAe
         HDCXxo1XKjQVpqDtQ9e3UkCJvLf0KNb8sLtz0TboSKbXcsvKAOgt202+i9nLxD1ggWqi
         Z/eYG8HPRMH/bKX3z2azr/zexvN1PoLr16qiN2TOc/am3vyBsoxoGdx3EoYInrILG9VY
         RIiV7rl97dBFVbMhdst1PvquOoIQpNtNt/u/hZagszTE04ctRl4OALpMHI9UJB2ClqY+
         ykDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684548038; x=1687140038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbtOdWMUbGHFmlrhAZaFe3zlF5reDGxWr2RyYcaH25I=;
        b=M3OVAoHA/qwPax7qIq2cNUtLabKMrWDoIp6AmlXDZnWJE3d6tP4llabTLhMD5xVbFU
         CDluYcthaa/5/bv9gF6PWrlciqWJOuiWiZ6q7PCKKAz9FqU76EIxRJEPkv/+UbZTUemQ
         +OfZ0LLalzMx3fk7+ulMDrGhtWUIwbfEizggvb061Ui+yC4ibcHKdYoZ+6nhYKoMtJMh
         hbb1AzHVhVUzSK24JGLS7jjVGgFeESB853ULyLw1RrtNM7yiCySW4DcQ/jvhOiwA5x/u
         FuPieJ1hKQUoQGHejEHkiLpvwvNXD6o569vdy/Kixp1JitwZtM+egttv7FXUvx3TUpQm
         zxRQ==
X-Gm-Message-State: AC+VfDxKMS2YFpZ9p0q7w+nksFOMSqc3vbN/mgprud+hQs4Da4lPZAQH
	hcQ2O//K/NU2W1wb4W+/cco=
X-Google-Smtp-Source: ACHHUZ69kNb9SpaiQXNVW2SBDEhRD4BxkA9zZaCshMAkqCUtZYTdsesjkufeZ42vLbMTO8D1hF7tvg==
X-Received: by 2002:a17:90a:dd82:b0:255:2daa:4796 with SMTP id l2-20020a17090add8200b002552daa4796mr953887pjv.44.1684548038469;
        Fri, 19 May 2023 19:00:38 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id a18-20020a17090aa51200b002535a337d45sm255577pjq.3.2023.05.19.19.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 19:00:38 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: kuba@kernel.org
Cc: claudiu.beznea@microchip.com,
	davem@davemloft.net,
	edumazet@google.com,
	linux-kernel@vger.kernel.org,
	minhuadotchen@gmail.com,
	netdev@vger.kernel.org,
	nicolas.ferre@microchip.com,
	pabeni@redhat.com
Subject: Re: [PATCH] net: macb: use correct __be32 and __be16 types
Date: Sat, 20 May 2023 10:00:35 +0800
Message-Id: <20230520020035.216060-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230519152807.57d3f4c8@kernel.org>
References: <20230519152807.57d3f4c8@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>On Sat, 20 May 2023 06:19:39 +0800 Min-Hua Chen wrote:
>> This patch fixes the following sparse warnings. No functional changes.
>> 
>> Use cpu_to_be16() and cpu_to_be32() to convert constants before comparing
>> them with __be16 type of psrc/pdst and __be32 type of ip4src/ip4dst.
>> Apply be16_to_cpu() in GEM_BFINS().
>
>same story as with your stmmac patch, the warning is a false positive

yes, the same story and let's discuss this in the stmmac thread [1].

[1] https://lore.kernel.org/lkml/20230520015527.215952-1-minhuadotchen@gmail.com/

thanks,
Min-Hua

