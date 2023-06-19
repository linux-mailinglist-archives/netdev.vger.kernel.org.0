Return-Path: <netdev+bounces-11991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9773B7359E2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FB5A2800FA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4FE7D539;
	Mon, 19 Jun 2023 14:42:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CAED518
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:42:30 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6251AF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:42:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-311167ba376so3265135f8f.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1687185747; x=1689777747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6epH37hdpG+43zHnm1jYAPdZwnsNsyegwEKE9/FA+rc=;
        b=pklYDm5xRYSW2AFNSWM+3VocxKr9BLg1Hr53FKkK9tKikvleoVDkWoGy0DGyvMtRhS
         1wf7MwFV/UENAd2a/dnHUPUgEEF4ffzQ5MJsDVu6iTkZIO5/NvnDLHHVrjYy9uOINf/2
         yaljpVx4+7G3iXza22CoRJTMXPNIc3nonETbQWvwiO86FNPUZ71BbOfSUiF21VGHrP1i
         /CwDxFubryo7T0HSuylB0Rx2jXGdIOjC/4gCT8rAHWk9IW7MHDaT+hL/gm+8w+Es61Dj
         sGgZgmpZaYX9DtUcG/vfOKZ73X9p6nDP1Fr/XcESVn3UbAr1ZSAheCCK5VCXYcQxmzof
         x5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687185747; x=1689777747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6epH37hdpG+43zHnm1jYAPdZwnsNsyegwEKE9/FA+rc=;
        b=U/xrr/opb2kYmcqDvb0a4JT7aMTsF6a+tvJ18W/CIVGmn2E96Yc3wp9dobIWW7Gkbo
         XpUZW8idBlOLPYoAVZuw9XO3jhczeUZeCVB8krX8nkWgPZfiZyh2tv93D3skVI+02ZBn
         sBHvYCNSoX8mbyEuvo8yDtzbJdIcDB+ndviiua98zjwaxlkkhCRX82LHlBCT1j9WvT+g
         RyLPPC+Ce9qQ5HLSK7QeYedf3VmRp89sin+Ji5cNmL35yBpRYvYlnd96wqc6l1JoefxI
         4SjY9b2MK/tZA5abnWgzA9eii8sfMJUU8P94dDMam20GRKDmj1tpxpuWItRRAnU6m3ba
         kKvw==
X-Gm-Message-State: AC+VfDzy0Jqe58fikxJY5Daz+n6ynQG7Exjyp2LPc1oihqdH3kNasiAJ
	0q8SBQGlwIgZqOTWfSfXxmawaQ==
X-Google-Smtp-Source: ACHHUZ5GsLFi7Eftr+GWDtD5vjtCFIBvjRQh0Vm+yoQ+n8kb4HQsZW8B15VQxQMJV9e38t0hfcFPFA==
X-Received: by 2002:a5d:574c:0:b0:30f:d05f:debc with SMTP id q12-20020a5d574c000000b0030fd05fdebcmr7467466wrw.43.1687185747252;
        Mon, 19 Jun 2023 07:42:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t12-20020adfeb8c000000b0030ae6432504sm31705801wrn.38.2023.06.19.07.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 07:42:26 -0700 (PDT)
Date: Mon, 19 Jun 2023 16:42:25 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next] mptcp: Reorder fields in 'struct
 mptcp_pm_add_entry'
Message-ID: <ZJBpUaUoAmIPpU70@nanopsycho>
References: <e47b71de54fd3e580544be56fc1bb2985c77b0f4.1687081558.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e47b71de54fd3e580544be56fc1bb2985c77b0f4.1687081558.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sun, Jun 18, 2023 at 11:46:46AM CEST, christophe.jaillet@wanadoo.fr wrote:
>Group some variables based on their sizes to reduce hole and avoid padding.
>On x86_64, this shrinks the size of 'struct mptcp_pm_add_entry'
>from 136 to 128 bytes.
>
>It saves a few bytes of memory and is more cache-line friendly.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

