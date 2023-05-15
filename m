Return-Path: <netdev+bounces-2725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C51767036B2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA2911C20C67
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A4AFC06;
	Mon, 15 May 2023 17:12:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E901FFC00
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 17:12:54 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1720B100FE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:12:35 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f42d937d2eso46296005e9.2
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684170753; x=1686762753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XXyT1LTgUSs+PYs2aHi9g7bS+bsT2Sf8immn5YPZM/I=;
        b=QXaaryjz7gwC2qtK8Rxrp/sFwaJKI3ptWp5sNVBMBl1umue/sdP+jMKlVLXkOfc4eV
         kZ3Zjwj8ZFp/OntulHkglOmTXUHDQOyRcKEYmeONsAXlsGIUKCH+Vs+KsmCDZK3Dg7pg
         87jGPcnao+37dXgOl5FQkOwFCAjqtUMSqDwSvZulY34RgZXNlT9kIxd4hZ0aO771Or0x
         6SdXx0F7WPjOrmbqHJrRTNP9aXCd7CdxR8WfMsBF1xaDBR19p2/FC4pmJYfEUZtu5aOZ
         3ahoZ4p6G0195A+jDSrfoprWbUksEKCVnwqTEFBX12B+9nudqTFvSOLVcdq9PkxlPZUl
         6u9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684170753; x=1686762753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXyT1LTgUSs+PYs2aHi9g7bS+bsT2Sf8immn5YPZM/I=;
        b=QBhvuEpz335CUHnTgcYwiAAmmkhyQ+Xx2gKr58AO1Wm576b63Mnym/fcBhnGYiumYy
         RpuDXUozNlukOISe70pC/ALDnIr9dLpILNJY2KMwYfk6SYuSIaxsyCQHujAvNiV36idR
         XLnXHvTAud6Q/A9IPBUnD6+8D6yZJpXt+Gsve+/arg7wYF/O5irhR0zaFiUbMjTUsgQi
         485gaJ/I1vei6Bi9CdbayCdRHyoUOjIgmUKrrfLTrC7hIbo0ounEU/ub2dm9FiLqPMQM
         22rw/qvDzdiCDa/8puQzX0FQc0n8hK95TpsPpcRNsJluDfYxeC/070uc/a56Jlf+OyZm
         pRew==
X-Gm-Message-State: AC+VfDwU/qgfKG/88qKqGxpuba9ngZE644mvIvwZc/3hrYG1NKetS1dB
	kRp30VR4Oylr7AGT4tDS2H4fng==
X-Google-Smtp-Source: ACHHUZ4eMhIwBT7w1XF/fJHFKfPz/0uLX5aoUDa0kGf78PzmiGLWIUCUXXJ0QmARz8UDaF7I7TctZw==
X-Received: by 2002:a7b:c8c6:0:b0:3f4:2220:28d5 with SMTP id f6-20020a7bc8c6000000b003f4222028d5mr19288837wml.29.1684170752657;
        Mon, 15 May 2023 10:12:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k18-20020a7bc412000000b003f427db0015sm764wmi.38.2023.05.15.10.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 10:12:32 -0700 (PDT)
Date: Mon, 15 May 2023 19:12:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Message-ID: <ZGJn/tKjzxNYcNKU@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-6-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:

[...]

>+static const enum dpll_lock_status
>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] = {
>+	[ICE_CGU_STATE_INVALID] = DPLL_LOCK_STATUS_UNSPEC,
>+	[ICE_CGU_STATE_FREERUN] = DPLL_LOCK_STATUS_UNLOCKED,
>+	[ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_CALIBRATING,

This is a bit confusing to me. You are locked, yet you report
calibrating? Wouldn't it be better to have:
DPLL_LOCK_STATUS_LOCKED
DPLL_LOCK_STATUS_LOCKED_HO_ACQ

?


>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] = DPLL_LOCK_STATUS_LOCKED,
>+	[ICE_CGU_STATE_HOLDOVER] = DPLL_LOCK_STATUS_HOLDOVER,
>+};

[...]

