Return-Path: <netdev+bounces-2047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B60670015B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3266D2819E4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634537461;
	Fri, 12 May 2023 07:23:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E3F2103
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:23:10 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0114A1992
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 00:23:05 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-96aadfb19d7so47385266b.2
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 00:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683876184; x=1686468184;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+CDLwhQC3B9TCv7yc7FEY8Dd3dj4D/OXlq4Q4OjYu4w=;
        b=NyiKMfB9anJurw3eG9BsTDeemyS+Ie25qb/J5vmUc0lymIRI5+yog6oWOgaqVvVzwF
         tzPUQV+fHg/nEQSZbv3yfdM3YdH5sU0AEwfDYtoFt/MlwqMfjN9ZSMPc4YSs7FAuR/gv
         Qe/+7ay55SgYGmX3S4lhjDHzzgbUcFDfn1MnjRn3np/wwBwDvnnZ3IMF7w+h21cKlq83
         H0UG7ys2brc3Eet5LRqJ3meMIAeebREweGUxt/6ntivPtNQHcqvgRrtG4wA3UEnyKfK8
         xMQLUNYZpjlDz8uAtqXcEEid0hOacQQdxR67QDmQSRV3KifIYK/MTPNswsZTN53ycLqq
         yVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683876184; x=1686468184;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+CDLwhQC3B9TCv7yc7FEY8Dd3dj4D/OXlq4Q4OjYu4w=;
        b=SkXcSWUemz157J66i2cHCKCb3CR+BxSWUcpR4/1qYhTXJciypF0ePVshiCo3aW9bzX
         iFVpVZQMEezg9CfJu7gc786kTDIXiEIbSvB6qnZJGqwK+g5u9DO9SELJx7Hi1NkF6fNl
         AhGD+qXTfacpLi5T8ii0fSkNg81k0qmWuFHQHF4gn3vP61hBBeOIlGMx3l3X9gJ2+/83
         GFPAUdh+Vo4xl8+TBvKJZ+HTvzy2/uP1pY4WkTlk+oId875pdgrTxjK6JzeydlnJo8UZ
         nkJjE6WVEBFOCtzugNyoGZxPjcBJ6aTJ31pCc9DVLkJrglzQrI+BrG7F/F7TRlaPTX6r
         DP7Q==
X-Gm-Message-State: AC+VfDy9l4UKkr5b6Aisa98l0ALdp8EVPvya5CRgCsUfuzIsZ52IsVIA
	d8LKetZHnSdrvRhiO9f29DA=
X-Google-Smtp-Source: ACHHUZ5f0d29NCgHqiXxA2JuO8+g0ED07oaEbjKvPQkqtTEnDJQuVW2+AoRv7fyztr26dGQOwhqPIg==
X-Received: by 2002:a17:907:1c01:b0:94d:57d2:7632 with SMTP id nc1-20020a1709071c0100b0094d57d27632mr24092245ejc.31.1683876184123;
        Fri, 12 May 2023 00:23:04 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b00965cd15c9bbsm5092871ejy.62.2023.05.12.00.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 00:23:03 -0700 (PDT)
Date: Fri, 12 May 2023 08:23:01 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, me@pmachata.org, jiri@resnulli.us,
	jmaloy@redhat.com, parav@nvidia.com,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2 v2] Add MAINTAINERS file
Message-ID: <ZF3pVX118sExgpXg@gmail.com>
Mail-Followup-To: Stephen Hemminger <stephen@networkplumber.org>,
	netdev@vger.kernel.org, me@pmachata.org, jiri@resnulli.us,
	jmaloy@redhat.com, parav@nvidia.com,
	Nikolay Aleksandrov <razor@blackwall.org>
References: <20230511160002.25439-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511160002.25439-1-stephen@networkplumber.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 09:00:02AM -0700, Stephen Hemminger wrote:
> Record the maintainers of subsections of iproute2.
> The subtree maintainers are based off of most recent current
> patches and maintainer of kernel portion of that subsystem.
> 
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> Acked-by: Petr Machata <me@pmachata.org> # For DCB
> Acked-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  MAINTAINERS | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 MAINTAINERS
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> new file mode 100644
> index 000000000000..ec193fd8459a
> --- /dev/null
> +++ b/MAINTAINERS
> @@ -0,0 +1,53 @@
> +Iproute2 Maintainers
> +====================
> +
> +The file provides a set of names that are are able to help
> +review patches and answer questions. This is in addition to
> +the netdev@vger.kernel.org mailing list used for all iproute2
> +and kernel networking.
> +
> +Descriptions of section entries:
> +
> +	M: Maintainer's Full Name <address@domain>
> +	T: Git tree location.
> +	F: Files and directories with wildcard patterns.
> +	   A trailing slash includes all files and subdirectory files.
> +	   A wildcard includes all files but not subdirectories.
> +	   One pattern per line. Multiple F: lines acceptable.
> +
> +Main Branch
> +M: Stephen Hemminger <stephen@networkplumber.org>
> +T: git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> +L: netdev@vger.kernel.org
> +
> +Next Tree
> +M: David Ahern <dsahern@gmail.com>
> +T: git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
> +L: netdev@vger.kernel.org
> +
> +Ethernet Bridging - bridge
> +M: Roopa Prabhu <roopa@nvidia.com>
> +M: Nikolay Aleksandrov <razor@blackwall.org>
> +L: bridge@lists.linux-foundation.org (moderated for non-subscribers)
> +F: bridge/*
> +
> +Data Center Bridging - dcb
> +M: Petr Machata <me@pmachata.org>
> +F: dcb/*
> +
> +devlink
> +M: Jiri Pirko <jiri@resnulli.us>
> +F: devlink/*
> +
> +Remote DMA - rdma
> +M: Leon Romanovsky <leon@kernel.org>
> +F: rdma/*
> +
> +Transparent Inter-Process Communication - tipc
> +M: Jon Maloy <jmaloy@redhat.com>
> +F: tipc/*
> +
> +Virtual Datapath Accelration - vdpa

Typo here, it should say Acceleration.

Martin

> +M: Parav Pandit <parav@nvidia.com>
> +M: Eli Cohen <elic@nvidia.com>
> +F: vdpa/*
> -- 
> 2.39.2
> 

