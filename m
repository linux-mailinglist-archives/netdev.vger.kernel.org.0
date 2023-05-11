Return-Path: <netdev+bounces-1649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB426FE9D1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3843B1C20E76
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393DC1F18D;
	Thu, 11 May 2023 02:23:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7E53C13
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:23:41 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC993593
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:23:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-645cfeead3cso950665b3a.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683771820; x=1686363820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J3qacVid6H3ngo9qDEzmETTaSM1k+A/gnjDyOMReDZo=;
        b=afKZHilpNs5h+wZU6XscmllVe1cnnQoNgJhfxWU6qQU/sn5/0qgM3IfgwpsTRBUt3i
         n/OTVHenw4HSwQRXoRH+u2zHkpY+R36TjM/uTSm6ewSz6YMtOqc1sSOL3WDBeNTyjeeN
         Y83AFP4kQ4wiLc4g2ubMznnadGWRqVUkGctEoKdG5B1H7sf+FyS9dbzj9g6NolSlX8dV
         awfuKRTQ7fwBGQpvR6bVgK5/eSYT7NAgP9OM793YX8YELu4sm2ShuJ+Of0Ra7ILxGSAk
         dpDtRYZgfXG3rwIxyf9kCaZciGccCqrPj1oRITtWueTAa5hBVchOsnNZgpdznoSho4ou
         g09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683771820; x=1686363820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J3qacVid6H3ngo9qDEzmETTaSM1k+A/gnjDyOMReDZo=;
        b=QXnmQ1LKKNX5BPowYX8AkHER0lyqxeHTCdbaA+EJvQHjmPJ/M7NReKGXXoUsoWwFq2
         7/eEeVvFUt1XTX1I1TsHVgGfYkl7+Xjv8KXFlbfe6yRrl89YD5Z4N/53Q+YHbUlJ2FZT
         ZCLokVhQxzpinvQGFlqUllwu54laBcRJoEMBv3r5ShFDFV+VDYV831/ePOmjY6R+IWVr
         t6qoYcZwq+iNT/PDoTGyiEvH/J2sOMc2SVQEvDbOcwgwU/1afKXdjpnGGF451vUXm6yd
         8/XIpbriNBZ8/8nNMlrf+Qbsy2UfFDVjAfN2rQCbS/Qv5TNbo+E3B2bAUgfB0WFP+Z/V
         CG+Q==
X-Gm-Message-State: AC+VfDxctdgxvVkcxvq1q9cDzjjHCtvNWDeGcRpgyLSIQIb8aZUCFWnZ
	4Ls7wTNHE+u7IZz7/rQE8O+fUax9B7g=
X-Google-Smtp-Source: ACHHUZ51+EmT9q/6ONsfV3y9rjr3VCJ2Hq7qPoX+H+ZCVjQO31aRC9Ufko4bUJW8+rKZdukr53J2kA==
X-Received: by 2002:a05:6a00:1885:b0:644:c382:a380 with SMTP id x5-20020a056a00188500b00644c382a380mr20704088pfh.0.1683771819632;
        Wed, 10 May 2023 19:23:39 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q15-20020a62e10f000000b0062ddaa823bfsm4148786pfh.185.2023.05.10.19.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:23:39 -0700 (PDT)
Date: Wed, 10 May 2023 19:23:37 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 0/9] ptp .adjphase cleanups
Message-ID: <ZFxRqRUT9XazAl8B@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:52:57PM -0700, Rahul Rameshbabu wrote:
> The goal of this patch series is to improve documentation of .adjphase, add
> a new callback .getmaxphase to enable advertising the max phase offset a
> device PHC can support, and support invoking .adjphase from the testptp
> kselftest.

Let's make sure to get ACKs on these three...

3600   C 10.May'23 Rahul Rameshbab      ├─>[PATCH net-next 7/9] ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
3601   C 10.May'23 Rahul Rameshbab      ├─>[PATCH net-next 8/9] ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
3602   C 10.May'23 Rahul Rameshbab      └─>[PATCH net-next 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info callback

Thanks,
Richard

