Return-Path: <netdev+bounces-2401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A82701B16
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 03:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F0EA28187E
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 01:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD034110B;
	Sun, 14 May 2023 01:47:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC4C10E3
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 01:47:18 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0D71FDB
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:47:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ab01bf474aso86898205ad.1
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684028837; x=1686620837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JZZSPgxHMb9KTgt/p8BHfYbPkv5futWetAPzR8az6J4=;
        b=NN9JZG+RYsdg7Xg074XpATthENk4Rg/fbQCKuEykRfLgMKZX7MFKdt+EQkh7WBaLUM
         vE1NoRgHLwCJkhlI6R3sYFkG1zytzPCZzuUb8uAvcHB98dNnSUGGitiK1Q9wCV/46HHI
         /sWLVxdxFrhQKkA9KhGpGIJs4qV9RiLgBkHvRTlAz4DT/Qr229wNrm0WNFVyzCIjBI8s
         +RLEvfc02SIUoPke5KCtz5ABV6f9VC2n0gitRo3bK+KnDa9uRVM9kT1k66VEM36AVjBV
         Fcr4cfBKBCM971QqhXkGf+FmSSJJtTsXCQo/T9NfSPcnDWgE0aLDt8il3k3PaQqjauAF
         FUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684028837; x=1686620837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JZZSPgxHMb9KTgt/p8BHfYbPkv5futWetAPzR8az6J4=;
        b=D6nXY9bfWh2NRE/AHzPP5Ej7ZGNE48bHohno/vAETAOJVSggHWlennGLuDlVhij+cI
         ixcp8gRBNZn91uKYnNF6bHixuTuKukKDXclvFIR1TNbzW2hRunzRQXYRqeBQj6DczGi6
         VvZ4LHQC2UVmyDEKGrtUViC311OxXduEXpEZKK9Qu9nBSLTfBwbur8UtsUwmcSMveQj4
         EiOzlcvrJsKwsc/uAjV+uKu7bywDN6K5ObmLTRl8yQwNKrmjbLGl+tSVhghzxk6fyoGo
         cgR1V2DXYbWzNrb1osHv+gDHB5SeJPZv/CPGvHA+e+Hs2M87CtxA+ArOXUejhZAbCqlY
         twHA==
X-Gm-Message-State: AC+VfDyLJrsB96NE7T9M2QoM9fK1SBK+YZM9xCHzKm2WugXtceLxGfTp
	A3K53o8BD210zCSKuDJJzsaI3Q==
X-Google-Smtp-Source: ACHHUZ4CxxfYqJxRxC7jj/D/X8SOFKdliJ1UPE1X8yzKhgLdFarTzODc8gvjzR4sa3s9zrokPHwKBA==
X-Received: by 2002:a17:903:22c9:b0:1aa:cf25:41d0 with SMTP id y9-20020a17090322c900b001aacf2541d0mr41486752plg.33.1684028836981;
        Sat, 13 May 2023 18:47:16 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902b40500b0019a6cce2060sm10470048plr.57.2023.05.13.18.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 18:47:16 -0700 (PDT)
Date: Sat, 13 May 2023 18:47:14 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Emil Tantilov <emil.s.tantilov@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, shannon.nelson@amd.com,
 simon.horman@corigine.com, leon@kernel.org, decot@google.com,
 willemb@google.com, Alan Brady <alan.brady@intel.com>,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, Alice Michael
 <alice.michael@intel.com>, Joshua Hay <joshua.a.hay@intel.com>, Madhu
 Chittim <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>,
 Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Subject: Re: [PATCH iwl-next v5 08/15] idpf: configure resources for RX
 queues
Message-ID: <20230513184714.4e0b9315@hermes.local>
In-Reply-To: <20230513225710.3898-9-emil.s.tantilov@intel.com>
References: <20230513225710.3898-1-emil.s.tantilov@intel.com>
	<20230513225710.3898-9-emil.s.tantilov@intel.com>
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

On Sat, 13 May 2023 15:57:03 -0700
Emil Tantilov <emil.s.tantilov@intel.com> wrote:

> +/**
> + * idpf_is_feature_ena - Determine if a particular feature is enabled
> + * @vport: vport to check
> + * @feature: netdev flag to check
> + *
> + * Returns true or false if a particular feature is enabled.
> + */
> +static inline bool idpf_is_feature_ena(struct idpf_vport *vport,
> +				       netdev_features_t feature)
> +{
> +	return vport->netdev->features & feature;
> +}

Minor nit. You could make vport const here?

