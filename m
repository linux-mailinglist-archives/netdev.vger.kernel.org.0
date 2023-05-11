Return-Path: <netdev+bounces-1890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2756FF682
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6691B281752
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79A22107;
	Thu, 11 May 2023 15:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5C22106
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:54:57 +0000 (UTC)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A58F6E8C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:54:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-528dd896165so6248055a12.2
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683820496; x=1686412496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OMLaXG3kn9J1t0D8UdL377w+Iu6C1rddJ1+6LY7WuQ=;
        b=o2j86sMAjKRwrNcSOUc1D2lNvbnwpfLDIMXnDPW/JL+p7m3o1BMVPk5w0mFww7/Qnp
         t0j1eCrx3jC6C/HsBWL3WTyYP9h6ZyHiIWMCG+CwGxIk6DeppKW+MYoxXAvWvNAIP9/u
         KUBGEoxs+faJMKgi80frPDFLTQO69XZ/S5I1idVq++dOEMYTSZDFA2VUtPszNFbDFI4/
         KcDnnTj3poNx5SdD4tH4thehMfq+60G6CxqQoKT2Ci7YnE5sVfYUcRyWuEDXFjI1WGgT
         uc+aHnQyxfK7lAZ6IcTAuMD8665b5lx1CbpZRD2z/IEqDjdnvz4JHzucWgZMLPXGH+0c
         gv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683820496; x=1686412496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4OMLaXG3kn9J1t0D8UdL377w+Iu6C1rddJ1+6LY7WuQ=;
        b=J8mJpalFjvxZCTTwiaf4xB77mbZu7fxpw75soFIqCVeAO2q1/UfYSAvloaiB3n/m5F
         dgDUvawIH5/WDH6Sw9ded8JQgN89FeZrWSQG8DG+i+av7cv1izi5eI7ehKBn4f2QlA9O
         kEobUDHBrEDrcL7hnK86wVEhSaT3+hC+ZW5nIKGI/5b/jKDHZNf9m1P2r2XtlEHqGlws
         xyR0i9KBPb8549iT1XfjBNuGvszRP6Z5/73+Po2J8NxWqPOXkg/iIdd3RBc8TxEBuV2G
         yVz0y6PB1gBfndPPMZaTox+pzUFbgMRLwOOwESZH3Pj55KseMGXCNVrZWDWjuCn79L/n
         Azjw==
X-Gm-Message-State: AC+VfDzs4BfpD7omw/6kjw1ppzE2Pmdw0s82ugfPdOA9oeLvTZyd82SX
	JsYf1itg/DGlWi3tSEH5vfVcXQ==
X-Google-Smtp-Source: ACHHUZ5+A5WzzInU+dmYhGcas2Vq9d1UU5sle82Hegffgt41Kmc5mwhNEST0CGFCNe1n3HBQEl8M7A==
X-Received: by 2002:a17:90b:85:b0:24e:4350:cb50 with SMTP id bb5-20020a17090b008500b0024e4350cb50mr21416343pjb.29.1683820495804;
        Thu, 11 May 2023 08:54:55 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090a859500b0024e33c69ee5sm16810157pjn.5.2023.05.11.08.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 08:54:55 -0700 (PDT)
Date: Thu, 11 May 2023 08:54:53 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ipvlan: Remove NULL check before dev_{put, hold}
Message-ID: <20230511085453.25ef33fc@hermes.local>
In-Reply-To: <20230511072119.72536-1-yang.lee@linux.alibaba.com>
References: <20230511072119.72536-1-yang.lee@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 11 May 2023 15:21:19 +0800
Yang Li <yang.lee@linux.alibaba.com> wrote:

> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold},
> remove it to silence the warning:
> 
> ./drivers/net/ipvlan/ipvlan_core.c:559:3-11: WARNING: NULL check before dev_{put, hold} functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4930
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Maybe add new coccinelle script for this? scripts/free/dev_hold.cocci?

