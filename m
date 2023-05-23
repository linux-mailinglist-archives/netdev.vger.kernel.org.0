Return-Path: <netdev+bounces-4721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CC870E02A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A13F3281300
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7AD1F940;
	Tue, 23 May 2023 15:16:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4581F922
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:16:44 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E746010D5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:16:14 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1afa6afcf4fso27904995ad.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684854953; x=1687446953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJeGQEMrpM8eeqfU3xH3VNZZx7eme2tUb730Gdj7mkI=;
        b=KyIi31O/Owy3g843BEza62p3uTnMJH27d+iHDycD2Zy1NgPs/zwBwOdzcs4waW5TBI
         V5V4h/psU5uzOX52s6uhJ3XKm/glhHBO0djG+wa2kPd+nEHQhoPZ4xjDpiCEo3dFfwEA
         Io3aoqMfcqDCQo5kyaZ5ekgA2QakZay0sudY4dzOLEguMxfvKvgeEA4SHu269EhHbTz1
         L8FE3i3y61Lk9LGXY25KZDEdRxMxTV7jDEPrs1+lXjF4o6YiRtJ+N8+Ke7y8wQUA0cdd
         d9yU3jPMZyeOGXOBC8CBdejJEnlfE3u66akUchGjeFRNxDS32FxjrBeJGO8SL+bCCv3X
         zO/g==
X-Gm-Message-State: AC+VfDyzw99vX3hiXY/FBaAU919RyDxLNndYIKdT99DPkKWylCNiyy0e
	aoG5F7rPykQRVZwXAjCAooE=
X-Google-Smtp-Source: ACHHUZ4xFXkiB/BvdLUoKTFRgeVpyuCwCMcGSxWP57ZlD0BqfYdE3+H9GMSiNjXnpz2La8kYeQDaNQ==
X-Received: by 2002:a17:902:7683:b0:1ac:637d:5888 with SMTP id m3-20020a170902768300b001ac637d5888mr13387115pll.43.1684854952831;
        Tue, 23 May 2023 08:15:52 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ea8400b001ac40488620sm6955882plb.92.2023.05.23.08.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 08:15:52 -0700 (PDT)
Date: Tue, 23 May 2023 15:15:50 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: Re: [PATCH] xen/netback: Pass (void *) to virt_to_page()
Message-ID: <ZGzYpm/Vs+TfSBMR@liuwe-devbox-debian-v2>
References: <20230523140342.2672713-1-linus.walleij@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523140342.2672713-1-linus.walleij@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 04:03:42PM +0200, Linus Walleij wrote:
> virt_to_page() takes a virtual address as argument but
> the driver passes an unsigned long, which works because
> the target platform(s) uses polymorphic macros to calculate
> the page.
> 
> Since many architectures implement virt_to_pfn() as
> a macro, this function becomes polymorphic and accepts both a
> (unsigned long) and a (void *).
> 
> Fix this up by an explicit (void *) cast.
> 
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Paul Durrant <paul@xen.org>
> Cc: xen-devel@lists.xenproject.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Wei Liu <wei.liu@kernel.org>

