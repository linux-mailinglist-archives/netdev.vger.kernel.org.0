Return-Path: <netdev+bounces-91-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 191EE6F51A3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ABD01C20AB3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFF546BE;
	Wed,  3 May 2023 07:33:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57846B2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:33:20 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C507D3C3F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:33:17 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f27a9c7970so4419833f8f.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 00:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683099196; x=1685691196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIGb7XSQmfygip3uPI7YIkc+jVgo9j0/NaSXlE5KQng=;
        b=3kL/VGHs5KbT8f35ZW9BiDN6eK+VGNTRQ4xhClMNIR3yTmwaREU3NcIJ9S+G6+u/jP
         qJtYQqwP/JZpN6MUlVoW1mQO0luz5DnJ8KvAignJvCy8ThTIX7QhDhJxp+tc9A1P5nTY
         vtg9AeFKCvdmsHlbROHui+DrsZ0eQuA8mRgQR6ZiPKWNfSzS/UYtuJup4T9WdHd3MnvF
         7Y6kVAMzkiiD5J0CXEK1u7DAYgrJAxQzB1ayeYcck6hXJ3RjjQs7hfLx2k345m3QqDW6
         xEa1IMqUGV2c3gyTd1qCa50UBCZO3wvcxqD/RyTFmFQSGntV88py+sPj1yZRGR972DMG
         AcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683099196; x=1685691196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIGb7XSQmfygip3uPI7YIkc+jVgo9j0/NaSXlE5KQng=;
        b=Ll2avKLOM6gkjQHegwRcCTBh482dglKTSXuugVcopxzqYz5XfaWo7SvpKURNc1UvJc
         F8jGLAgJZv7SW8kEBwJZoLv7G15uE4u90QKxdcZY4zghHC2CcT0Owbd3tijj4W6eadzf
         12LOzYcSB1h6uIYEBw3J2mu+7f+8FkXhIYhOYuvo4PknS0db/pudKJCfQtIB3ifrGUMM
         NluT5DqtDBeei0ROehRVfJcpgbp0qJWLwZERmh9CnVzShsFGFkyJt9NKNk8HBkNv3zvz
         XhRL0w05m7yDrnh03mNRAe55QPuN0543v/7wo3PmJlIVWWaQzoNVlkFw55lLyTsfk4Sw
         XPbg==
X-Gm-Message-State: AC+VfDxMNuUdwr8rW31hPqItcwOlsWvk+jv4ZJMc2EqmVHHP57/OqgQL
	dVlQOAUbzm/DnlN5CC7nzeHQEQ==
X-Google-Smtp-Source: ACHHUZ4xPrfT9ga+2kH2GzcUTilFSeguWo4ltNQF34GZruKX+jcIkedydsYcCWANVYe2yCcPnuYItA==
X-Received: by 2002:adf:e0ca:0:b0:2ef:8c85:771b with SMTP id m10-20020adfe0ca000000b002ef8c85771bmr11622570wri.51.1683099196124;
        Wed, 03 May 2023 00:33:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e14-20020adfef0e000000b003063938bf7bsm3419924wro.86.2023.05.03.00.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 00:33:15 -0700 (PDT)
Date: Wed, 3 May 2023 09:33:14 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	drivers@pensando.io
Subject: Re: [PATCH v2 net] ionic: catch failure from devlink_alloc
Message-ID: <ZFIOOp1j2O5g6V0+@nanopsycho>
References: <20230502183536.22256-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502183536.22256-1-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 02, 2023 at 08:35:36PM CEST, shannon.nelson@amd.com wrote:
>Add a check for NULL on the alloc return.  If devlink_alloc() fails and
>we try to use devlink_priv() on the NULL return, the kernel gets very
>unhappy and panics. With this fix, the driver load will still fail,
>but at least it won't panic the kernel.
>
>Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
>Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

