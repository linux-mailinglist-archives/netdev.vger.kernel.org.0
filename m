Return-Path: <netdev+bounces-4953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D125A70F5B3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8686280F18
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B019417ABD;
	Wed, 24 May 2023 11:54:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F80C8FF
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:54:28 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED24B9D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:54:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510dabb39aeso1641561a12.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684929265; x=1687521265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jrkT9JijtJoJX9jnOgTfzYfNDcAOoqyvINrRuCKkB5g=;
        b=fliuRIY33+xXI8BsAMRiof7i9iIZNF4lNBWYeyf6fD9qPD6HojUFEIaHC0gwqNnTOq
         DvdTF9+i9gRKhs0C416xsiRNk7PjFhhTQcTmEN5BnNrExTDjs0C0wqHKEwrRHSayHyMp
         aOqFrNeMUE7/pVPRGej2ltACcxLaoB6z1SkJlcAmUbmw/1j3Ipx2xKW/AwaYXCsuy7+i
         6S0M9ybZZ+dHc4bXpg5LFh0DXru5NsTUNt/AbkVXvzHl2f0Cv2ss+fdHtV4mAox4abVa
         +3g/KEeFuJC2CWA+1V+2SgpoTA5qejzSJbwtFk5yJJBOlw1k/Wt1pxH9t+dev8SD3MJr
         +akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684929265; x=1687521265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrkT9JijtJoJX9jnOgTfzYfNDcAOoqyvINrRuCKkB5g=;
        b=UEfLyVAC1dtLpkasLs3GJjont7rH4/axR8dVGMjGXLraQsFRlCfyJWkSyvN2yiyXtK
         6aLj1LPwR4PLxBNmcnMT9jRdAJDBxa3a3BtdvO7JPyQg02B5uvBqlpDpE43VQFGBzA6O
         heQ6zzf8fZPpG7XvVHC9zFFcIhvqtDl7CYfTXaZWKA0w0ULlIpNUvnx2H7gYOZQAwg7K
         gvT/OMzbJOIPKiwUzTc58FqxokqZoTNE4IV3ouKSPNqHJlAp8cvDoJWIA2aM5qsKO9x7
         4S6XK/PGJ9CPaL9eswuXYaJE34kVxBI4BTogrfCYKRegJeMlyl66ZMdunm/MzeVgjt9i
         Ufng==
X-Gm-Message-State: AC+VfDyB8lXkRK8NSZS9VZ+cFFjKH56M362vkflPONqRROznRFvKv6Og
	F2rY4ko3oY8aQjlRn7u+ISufXA==
X-Google-Smtp-Source: ACHHUZ7/+O9om7pgkd4GNhslQpfxRVtamkE5jfRF0c4weku9ncD+y7MAJMCy7wKSSk8XCPK9GknbyQ==
X-Received: by 2002:a05:6402:3ce:b0:514:2690:cd84 with SMTP id t14-20020a05640203ce00b005142690cd84mr948054edw.28.1684929265079;
        Wed, 24 May 2023 04:54:25 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f25-20020a05640214d900b0050dab547fc6sm5033411edx.74.2023.05.24.04.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 04:54:24 -0700 (PDT)
Date: Wed, 24 May 2023 13:54:23 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	michal.wilczynski@intel.com, lukasz.czapnik@intel.com,
	przemyslaw.kitszel@intel.com
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Message-ID: <ZG367+pNuYtvHXPh@nanopsycho>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 23, 2023 at 07:40:03PM CEST, anthony.l.nguyen@intel.com wrote:
>Michal Wilczynski says:
>
>For performance reasons there is a need to have support for selectable
>Tx scheduler topology. Currently firmware supports only the default
>9-layer and 5-layer topology. This patch series enables switch from
>default to 5-layer topology, if user decides to opt-in.

Why exactly the user cares which FW implementation you use. From what I
see, there is a FW but causing unequal queue distribution in some cases,
you fox this. Why would the user want to alter the behaviour between
fixed and unfixed?


>
>The following are changes since commit b2e3406a38f0f48b1dfb81e5bb73d243ff6af179:
>  octeontx2-pf: Add support for page pool
>and are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
>
>Lukasz Czapnik (1):
>  ice: Add txbalancing devlink param
>
>Michal Wilczynski (2):
>  ice: Enable switching default tx scheduler topology
>  ice: Document txbalancing parameter
>
>Raj Victor (2):
>  ice: Support 5 layer topology
>  ice: Adjust the VSI/Aggregator layers
>
> Documentation/networking/devlink/ice.rst      |  17 ++
> .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  31 +++
> drivers/net/ethernet/intel/ice/ice_common.c   |   6 +
> drivers/net/ethernet/intel/ice/ice_ddp.c      | 200 ++++++++++++++++++
> drivers/net/ethernet/intel/ice/ice_ddp.h      |   7 +-
> drivers/net/ethernet/intel/ice/ice_devlink.c  | 161 +++++++++++++-
> .../net/ethernet/intel/ice/ice_fw_update.c    |   2 +-
> .../net/ethernet/intel/ice/ice_fw_update.h    |   3 +
> drivers/net/ethernet/intel/ice/ice_main.c     | 105 +++++++--
> drivers/net/ethernet/intel/ice/ice_nvm.c      |   2 +-
> drivers/net/ethernet/intel/ice/ice_nvm.h      |   3 +
> drivers/net/ethernet/intel/ice/ice_sched.c    |  34 +--
> drivers/net/ethernet/intel/ice/ice_sched.h    |   3 +
> drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
> 14 files changed, 534 insertions(+), 41 deletions(-)
>
>-- 
>2.38.1
>

