Return-Path: <netdev+bounces-8925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB417264F8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE59A1C20E33
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF1E370E7;
	Wed,  7 Jun 2023 15:46:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F4C34D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:46:15 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F00198B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:46:13 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-514924ca903so1583147a12.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 08:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686152772; x=1688744772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qIw2A60B4BjBt1RP4tlsLtZqY4cMU7qp9v2JDYqqCto=;
        b=aobqQ6U9Zpq4LHvpXJvQ9XUToDPq9JiBtMkMIp2N/Lk3NlHM1tok7k7r50jnpC4+05
         AikIpMhUcNV5DThlk23Ho2oruyJT1M+vt7C7Ly1G9/adKvdKIt5DiAaVfFOgoFadSAqM
         IZbENBIrywmL0c62RkMyFRpGbQrTjCtmhjYCZBYlcVlnhjXIClTq1Z/EsVAEfLtp3pTX
         9MhOPg18QS4UX6/FlK5op41SSqwp+XudzMgGYjkO565o8ImThWm92MOA3xlFS+w7hLi+
         wGgLKKhqlb7JjuqCQ1pWO65EY+Z3638gCFa35J3G63BGC0sJflK5klDWOEAAks0XObvs
         N4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686152772; x=1688744772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIw2A60B4BjBt1RP4tlsLtZqY4cMU7qp9v2JDYqqCto=;
        b=SwNPbO0uNrvNNa5ANgRp+SdKOQgoPUeBQwhOe3o8kPGyIN8I9biRQsVoZsnM64z1Mo
         9eOD+jnW4bqDuciPPbQPHeDGOPz07D/sCZ8Ke+xJSMGACR16lGyOzz1ya7vO83MpS1bQ
         FvuvSKOtc1r1NucI0am/RprQ01ZKFQ+PeeDyk3ugDsu3VsmXjvDMWtUcKizzwaodnerA
         3u0dY3uvgG4IZTpEkeUfoUijuSnMq1PiLJHihXNgZ5fRWlpnpd9KsisBjW899e9WA6Bz
         LUTY77/2x0XnZ3TAnZ+edr0eyC5snEO01QT1p5c3Lhk/PtAaLE0N8zWvSnMhX/7S/7UC
         BqSA==
X-Gm-Message-State: AC+VfDzWE5KAoEmeDrAYbRNrAAVsiFrpCK6ZtFVCcTphJ0XYY/Ictnw7
	QxEKHRImIWLJU5F71PfsUFTXUQ==
X-Google-Smtp-Source: ACHHUZ4g6tW5iHA+QNpPU4ukI4ZrTJHFWDjP9J/4wzQRLnXt9+Pfe4DJPptOS4u0qezDWEU5hn4jRA==
X-Received: by 2002:a17:907:c1f:b0:96f:a39c:86d6 with SMTP id ga31-20020a1709070c1f00b0096fa39c86d6mr6474484ejc.8.1686152771715;
        Wed, 07 Jun 2023 08:46:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090616c500b0096a6be0b66dsm6956188ejd.208.2023.06.07.08.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:46:10 -0700 (PDT)
Date: Wed, 7 Jun 2023 17:46:09 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
	Jiri Pirko <jiri@nvidia.com>
Subject: Re: [net-next 13/15] net/mlx5: Skip inline mode check after
 mlx5_eswitch_enable_locked() failure
Message-ID: <ZICmQcFEJkDn71Xq@nanopsycho>
References: <20230606071219.483255-1-saeed@kernel.org>
 <20230606071219.483255-14-saeed@kernel.org>
 <20230606220117.0696be3e@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606220117.0696be3e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, Jun 07, 2023 at 07:01:17AM CEST, kuba@kernel.org wrote:
>On Tue,  6 Jun 2023 00:12:17 -0700 Saeed Mahameed wrote:
>> Fixes: bffaa916588e ("net/mlx5: E-Switch, Add control for inline mode")
>> Fixes: 8c98ee77d911 ("net/mlx5e: E-Switch, Add extack messages to devlink callbacks")
>
>The combination of net-next and Fixes is always odd.
>Why? 
>Either it's important enough to be a fix or its not important 
>and can go to net-next...
>

As Jason wrote, this is a fix, but not -net worthy. I believe that
"Fixes" tag should be there regardless of the target tree,
it makes things easier to follow.

