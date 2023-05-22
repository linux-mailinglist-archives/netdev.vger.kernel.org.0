Return-Path: <netdev+bounces-4432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A5270CC8F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13EA0280DFA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54423174E5;
	Mon, 22 May 2023 21:33:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EFE174D3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 21:33:45 +0000 (UTC)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E324A9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:33:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-51b33c72686so4481733a12.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684791223; x=1687383223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfDDeTmK+Pp6jvryWrnf5ZNYaQVJGV9RCOjhg3ro8zw=;
        b=eZ7JHf5DTC7i+ZedgwUVCM2i3AQFHDfa+mtzXp1F295rKNYvNXLSPX+m0c/f4P0qC3
         2VrMTVzfai+siWg2/u+XsGHYl8rXr+72lQlFhE9JRPWHZTjvUHxLMXiV9MOIkDQnFg7D
         +ag5Sn9ulTt9mfOe4hbqIJoPImAQsHWHzTEMul0pCYSg5eonaSpT9KL4CIR24hFC602z
         vGN60pd0TbIdDy6V0/s8YCR4AiHeqCPdy1RoPRk3wpBph+8IJUdYKxxrmg8OoDR1qcSM
         fAmH+OE91t8A1x6Hq3z6BCXrge4SbqsbKkPRjMw0q1Mc7j59NO8fckwAWN9hzDekep8H
         UB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684791223; x=1687383223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GfDDeTmK+Pp6jvryWrnf5ZNYaQVJGV9RCOjhg3ro8zw=;
        b=CJV8DlhaOYCBXjhdBo0oKcpOl99XZy2Pk3rkZ3U8jy2By3j4qkgttW3sdNxfW66TUi
         4S9lgpvT4drfo/6uUuYNAzw5ltSQLw8cOob92YBuPAjKfuHAusxFzYBcSw32lLl37rQn
         MCWMR83A0+Fb626TFLvVhzR4tmmaK4VnUG5SYsdt9RO3Fu60gY3juE866GqI3FF27+C3
         +iFKLgjQgsC7F8USq3Ke5mtRGJksYPv7RejngLrQEMm1qPHJZ3oYlhYTUocu5AbAgept
         NGs9FgVf5fByp9p5I+i/5TTxWMjMn7/yIO0Jj58S6f5MTg7r7sJRrenvzUu3dZTefd+a
         e8zQ==
X-Gm-Message-State: AC+VfDxY9WiB6E5R72JlA18OxjLKH/XSnrMkgE/7dvCEix+9/+RqcEu9
	ByDv7m9YRycFO3WTKwgouL6c7g==
X-Google-Smtp-Source: ACHHUZ56udjLsFNfb+oMLsTLyrcYjdcCgbNFgXDFxwE16rGoH5upuqFICSz4vHOwTh9xmWDpaqIIcA==
X-Received: by 2002:a17:903:2303:b0:1af:a03:8d82 with SMTP id d3-20020a170903230300b001af0a038d82mr11703352plh.57.1684791223546;
        Mon, 22 May 2023 14:33:43 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id g23-20020a170902869700b001aafa2e4716sm5254647plo.264.2023.05.22.14.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 14:33:43 -0700 (PDT)
Date: Mon, 22 May 2023 14:33:41 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
 <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Message-ID: <20230522143341.71a53a58@hermes.local>
In-Reply-To: <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
	<20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
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

On Mon, 22 May 2023 20:41:06 +0200
Daniel Machon <daniel.machon@microchip.com> wrote:

> +int dcb_app_print_pid_dec(__u16 protocol)
>  {
> -	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> +	return print_uint(PRINT_ANY, NULL, "%d", protocol);
>  }

Should be %u for unsigned value.

