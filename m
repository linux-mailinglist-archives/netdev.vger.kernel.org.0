Return-Path: <netdev+bounces-543-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 524836F80C9
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70B2B280FE6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63802156C2;
	Fri,  5 May 2023 10:32:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DEA156C0
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:32:18 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5C4160AD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:32:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-965f7bdab6bso5165566b.3
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 03:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683282734; x=1685874734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oqFM0dfkiOziqgm+y7EAdXu3SisD+1/na/JyXA0Db3s=;
        b=NQZWiOt0UJlZjfg3GJnTv8hNzqx+Nl7N072M4bTaZxs0xwR0Yf7ZsNZ4lJOlNfNDT7
         tAM3IidgUlachT+I6uvo+sFy/kMTy4CK4kukqyLPIxM+4fNh6qP+GdbKDMu/oZh/a6qx
         UFwyD9deiM0sw3nx+TM0ukDI3KvNWNazhdaRacEp3YbYfQKLYoOkNL+2c02960OWlZa4
         v1wl7PnHnmRMcL/+zpccmr8m9ef2nHaEwHGPx5fMOA2aVjLtWhJyIX+sgEHtfAkADg7z
         jfXRcxJZYna4QCHkG+bmOZM1W4qv++/IHR1xYL6PO6xpRHk1cBF4ttlvVaugTUBYdLDg
         zOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683282734; x=1685874734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqFM0dfkiOziqgm+y7EAdXu3SisD+1/na/JyXA0Db3s=;
        b=ePV/H7jCmqGdOW2ann4kcIPzjDPxGMhjeUtU3DBajx7vQMzmF3Kd5MuqyUSUauDtF1
         qz+rwoC+yCQJyhklNGHl2Q/7+NIU0BlWwDPHP9YWUbsNw2nQj8zUbePmW89rwhyMM6va
         TDwMO1eaJKboA3z10SykwBft2dCpDuvNt0lRzX1dodqPGTOu67qBSXp4D0rDluvdCGcf
         +2ulFja3JmOOBUDpKB/yVz3KVx+cAWZP0TtjPn7gkK932dgDQkPblk5eyTkp0oauqC7Z
         XYfaiduu4jnGItTSjd6byHDbwR3fTZ6qAFZQvm2YVf8uvvEJl4643vp9nXQgQjoxmvlM
         q2Rg==
X-Gm-Message-State: AC+VfDzkGucbPyqR0sVtVbvvyh+0ppW4SYOb3EkR+6wBojakJrJGDYyi
	uC04MD3jhZD1NuU5E9wkVCPp4g==
X-Google-Smtp-Source: ACHHUZ4pZ9j/Mdczi1SYO7f5/FVFXb5vlqeJq2kBdYMCcTQvfFJrB/MTmDxvlObDskpJSZp8Qu6MUQ==
X-Received: by 2002:a17:907:7204:b0:94f:2bd0:4780 with SMTP id dr4-20020a170907720400b0094f2bd04780mr725346ejc.58.1683282733904;
        Fri, 05 May 2023 03:32:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id de5-20020a1709069bc500b0094ef96a6564sm772766ejc.75.2023.05.05.03.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 03:32:13 -0700 (PDT)
Date: Fri, 5 May 2023 12:32:12 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vadim Fedorenko <vadfed@meta.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org, Jiri Pirko <jiri@nvidia.com>,
	poros@redhat.com, mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 7/8] netdev: expose DPLL pin handle for netdevice
Message-ID: <ZFTbLHnL9SXxqtzt@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-8-vadfed@meta.com>
 <20230504133140.06ab37d0@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504133140.06ab37d0@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 04, 2023 at 10:31:40PM CEST, kuba@kernel.org wrote:
>On Thu, 27 Apr 2023 17:20:08 -0700 Vadim Fedorenko wrote:
>> @@ -2411,6 +2412,10 @@ struct net_device {
>>  	struct rtnl_hw_stats64	*offload_xstats_l3;
>>  
>>  	struct devlink_port	*devlink_port;
>> +
>> +#if IS_ENABLED(CONFIG_DPLL)
>> +	struct dpll_pin		*dpll_pin;
>> +#endif
>
>kdoc is missing. I'm guessing that one pin covers all current user
>cases but we should clearly document on what this pin is, so that when
>we extend the code to support multiple pins (in/out, per lane, idk)
>we know which one this was.. ?

Oh, yeah. Will do.

