Return-Path: <netdev+bounces-6813-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CCD71849E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED212815A5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EB4154AD;
	Wed, 31 May 2023 14:19:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C215485
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:19:15 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2874CE61;
	Wed, 31 May 2023 07:18:57 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30ac4e7f37bso4180466f8f.2;
        Wed, 31 May 2023 07:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685542735; x=1688134735;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uKt10d33GLS918xBYr9ig6gEIvplOafeyOdPT52Gvtw=;
        b=sxE1PVz6gliaJYtzEHuOV9OFdJsIWQmxrcN2RzTCBl6xgBpaV+4DSBJ1Rt1GowfS5R
         RAUGn5w4hHgkH0CCjEqbEQklBQCpzJ9cNYNAr/YEzwJbdFLTHndGS7oHrtRD3l9aacEL
         2ZgUiv7Ji+72vFINTlh8gYig5I46mK4HqA4Y+aILY/s9TNt2VWalLbiAXNF8L0LVr5oI
         CiYRo9XGI2otaq2KXrFSZDtFZ5IvkuHQ1XOe9+ejkraTGFX1RnjBNi3LiqOgULCBgDgW
         7ZQAE2fYIE/HccGHsns7jH7dN/QbmC+WaOcHTTaATEOEGvVI1iUuO77JoBd2/4fllD9/
         royA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685542735; x=1688134735;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uKt10d33GLS918xBYr9ig6gEIvplOafeyOdPT52Gvtw=;
        b=V2OKj4gSSiKVDYsiLUUsGQr++uraWVsbiGEt1mFU/+qVGQX9w7AjhQCjFGy5j+wqUw
         /NI9w1SFb/OlZzVN6HwdteRmoHUJD/+owjsu4sZB7MvxMLQ8FBMYPIHqVWyERbS89DSg
         +bmUPxqWkLBWBvLruYvB1ya2wuOM0/QL+vaAmlegJ0UEFRUDCTL9iy6oHGIRQxyASA/2
         SiW9UVfmO0SbE/oWBA4ickDiay2soJPf2h0ne6hr6Yk0srub0bdtYGf8aRsn8MwXB+gc
         b6FExyvKamPzJl5+AIONUBrLQBvtUtWGHQYO1xNomlDBm0Lt0tHfzUsZAPXWASKoYe91
         Qe2Q==
X-Gm-Message-State: AC+VfDwYWelu8efXmTGn5YtG9t7M13vCjUSm7hhr1dtwnzePARXvV5fc
	T77RcIY8ARMDq2UCjr+/FN0=
X-Google-Smtp-Source: ACHHUZ4K8EBprZj5LyLdGlzap3gDbQaYDD4K+vuuZre72Z/sRJ6dDSFbitBRb9Z2vUxPLOJpbcTQfw==
X-Received: by 2002:adf:e6cd:0:b0:2cb:2775:6e6 with SMTP id y13-20020adfe6cd000000b002cb277506e6mr4179103wrm.45.1685542735351;
        Wed, 31 May 2023 07:18:55 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id k16-20020a5d66d0000000b0030ae6432504sm6940337wrw.38.2023.05.31.07.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 07:18:54 -0700 (PDT)
Date: Wed, 31 May 2023 16:18:36 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
	lucien.xin@gmail.com, linyunsheng@huawei.com,
	richardbgobert@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] gro: decrease size of CB
Message-ID: <20230531141825.GA8095@debian>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch frees up space in the GRO CB, which is currently at its maximum
size. This patch was submitted and reviewed previously in a patch series,
but is now reposted as a standalone patch, as suggested by Paolo.
(https://lore.kernel.org/netdev/889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com/)

Changelog:

v1 -> v2:
  * remove inline keyword

Richard Gobert (1):
  gro: decrease size of CB

 include/net/gro.h | 26 ++++++++++++++++----------
 net/core/gro.c    | 18 +++++++++++-------
 2 files changed, 27 insertions(+), 17 deletions(-)

-- 
2.36.1


