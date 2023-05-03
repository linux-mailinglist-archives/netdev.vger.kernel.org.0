Return-Path: <netdev+bounces-211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC8B6F5E8C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ABD02816C0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6CDBDF5F;
	Wed,  3 May 2023 18:51:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB557DF43
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:51:46 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582EA7EF2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:51:34 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1aaf70676b6so30548505ad.3
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 11:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683139885; x=1685731885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJR063Tsy8kiJMrAjmP9eTHL19NenDXl50aN/hjdgUY=;
        b=XqB5n6+xh26ExSn2DvN7xv2JZkmmWN9o8J0LwwIUN3GMITsefQzSVlbQotb2/98hwZ
         7BaIxAe9zOhYY/S9BnmLpoTLvqI584Ot3Lo/fENlkMfqQWOS/jTQIfyEicTMx1jQUkmG
         MB7cRb/92KNfSIIo1/BVywgZH+WYTX+iN7ZbZuE1PXSAUulj9LmNvuZJSjHVyan81sJC
         BVnI9Y+gMRM7HYyXrFJDY00UTgIdNTQqRl5iJ0X/I3L0y1zLyI8RgaZUDgyuDpqRaWvb
         rsloJyrUPXkDY05Sq3egLnDo41ctKZNKApMepGXa2HZw9ZnX6K8Iexu2g16LvImz/ELp
         7bzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683139885; x=1685731885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJR063Tsy8kiJMrAjmP9eTHL19NenDXl50aN/hjdgUY=;
        b=ZzCbg/IEcaNQQfkWHh1xicRQ/nPR/ne+ZaNkBo+IpNNXpNahHwyI3TBxPikE/TIuKS
         BCfeKJ+2xBAL4SwUa9AD076wJJg47xw5RiTdbJ8NV80/eA+WW/YPnf2l1olGQWtMuyED
         fUnGL6+sjVqsGdZmRsLGvhggiz7OvAlZ3UW4e6jsq4dsSNHnWewQCQqSgrt7wnoTfHp2
         VXG2yutVGOv3gVYuNm9MT5UXsBIB2U8L4O4+R6dYRaGeuC8JVDifmV+OLrp0Mh2Fy2/F
         AgpoDHA+ioaDgjpfGgsLSVL9qws6V7vX0abi95qEJL5bcRzHUUZ/zKo3ED7zzrqWN6mI
         pHMQ==
X-Gm-Message-State: AC+VfDxiFi2lpEboukL2LeHS1C988Z7LFeTJ/j+kKqgrWC0prb+mRRVX
	xBF5jSFEriId+3Q++rzSb6XBiT3ZqYAurnVjexsmjw==
X-Google-Smtp-Source: ACHHUZ6IvbTV8Lr3SPH1K7Stio/7eXf9ExqqC6GdDMYTUtP+QLwPHtcrq7ix2CiCPt1S+G3FOB4oSw==
X-Received: by 2002:a17:903:1112:b0:1ab:1184:1d74 with SMTP id n18-20020a170903111200b001ab11841d74mr1103228plh.21.1683139885601;
        Wed, 03 May 2023 11:51:25 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id fy17-20020a17090b021100b0024e208a6464sm1731944pjb.15.2023.05.03.11.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 11:51:25 -0700 (PDT)
Date: Wed, 3 May 2023 11:51:23 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Max Tottenham <mtottenh@akamai.com>
Cc: <netdev@vger.kernel.org>, <johunt@akamai.com>
Subject: Re: [RFC PATCH iproute2] Add ability to specify eBPF pin path
Message-ID: <20230503115123.13a1c077@hermes.local>
In-Reply-To: <20230503173348.703437-2-mtottenh@akamai.com>
References: <20230503173348.703437-1-mtottenh@akamai.com>
	<20230503173348.703437-2-mtottenh@akamai.com>
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

On Wed, 3 May 2023 13:33:49 -0400
Max Tottenham <mtottenh@akamai.com> wrote:

> diff --git a/tc/f_bpf.c b/tc/f_bpf.c
> index a6d4875f..4eb3e817 100644
> --- a/tc/f_bpf.c
> +++ b/tc/f_bpf.c
> @@ -28,7 +28,7 @@ static void explain(void)
>  		"\n"
>  		"eBPF use case:\n"
>  		" object-file FILE [ section CLS_NAME ] [ export UDS_FILE ]"
> -		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ]\n"
> +		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ] [pin_path PATH]\n"

Help text should match other options.

You need to update man page man/man8/tc-bpf.8 as well.

