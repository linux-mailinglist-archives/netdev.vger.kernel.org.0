Return-Path: <netdev+bounces-5396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC582711167
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 765A02815AC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC5017AC8;
	Thu, 25 May 2023 16:53:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AC47E3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:53:45 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D2219A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:53:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-95fde138693so161483466b.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685033622; x=1687625622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsqFa77Bwum+LtairNZj22MO6XmaOivV+QrcLFIRDaQ=;
        b=Fsl2ZU2qWiczTchrU9m2HoWvip1z8ltGFAciz8Ox0ylE+H89uzaEUHB5d+B1/oboey
         87DwCMGB6NybFuacOIVsYTgu3lOtYrOgfMgaOuICW+GZthDxz1aG/PS88duNkXu/4vyz
         kr6KFHFrIXoK6/s3rsKf31belGrs73C/+QOEOpf7VjHVmZxO8cx9udccwb9yGHysoWxT
         ikZ3DRaHAOz8CinvgMRFWU7kQYkMEQf0+ak8hb0kw2/th5sgQpu+roH9frNlh9j1dUBa
         HUbVjTqsjfth/eSAOVVMDQ6jnc8YIeoDwXAqL1lyGbF6iDw6vfexUUEcCT39xZ+qxHLh
         rdqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685033622; x=1687625622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PsqFa77Bwum+LtairNZj22MO6XmaOivV+QrcLFIRDaQ=;
        b=EtXnR+cX3/d7FHj4fRl1l6XeO59jvcUjjfQQ0EPqLnmlMDdPGKNEZd8M35x2WY1q/M
         7hVr+b5aj0wv8vnXwbYQSnT+OXk2dxO982fSolVJouiCF+UyYdGYNZH7jBErGc5kI5Qb
         qujLOZMfiLu4bcrOwHbz9zXSupA937jBdFwOQtfCJQY/6AtprQHhPwkV1jiHYVRaFvJi
         Lq28hy+B+vM3N7qp1SQ0RfUPYpBaHHX6dFGHgr0QN14BxpJmRV39gQSHQTr1g+vhA1f/
         H3ILaC0XNL7RSssLjw2k58ARIpNZdkPDayzUg3NZMQ2WHkkNNniQeIRYPW+6BFjRSwue
         u3fw==
X-Gm-Message-State: AC+VfDzXcjX42HnKqjv7Ks0lA7iaWchVfATCfaRUsP/3XoQPNC1Jyh4r
	fdw3w296s2nEt0xZNrE1vjWitQ==
X-Google-Smtp-Source: ACHHUZ55NxYEwRLWLTAWm1DYPJ/uSe725r/A1SCQbW00/EKxXDP8ZWwBEIB81T0eW4xgQDuszIBfzA==
X-Received: by 2002:a17:907:6e87:b0:94e:bf3e:638 with SMTP id sh7-20020a1709076e8700b0094ebf3e0638mr1851025ejc.11.1685033622621;
        Thu, 25 May 2023 09:53:42 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id re7-20020a170906d8c700b0094f109a5b3asm1054605ejb.135.2023.05.25.09.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 09:53:42 -0700 (PDT)
Date: Thu, 25 May 2023 18:53:41 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next 05/15] devlink: move port_split/unsplit() ops
 into devlink_port_ops
Message-ID: <ZG+SlRD9aBBkuCsv@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-6-jiri@resnulli.us>
 <20230524215301.02ae701e@kernel.org>
 <ZG76ohK00xF2LHeK@nanopsycho>
 <20230525082703.0922dab0@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525082703.0922dab0@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 05:27:03PM CEST, kuba@kernel.org wrote:
>On Thu, 25 May 2023 08:05:22 +0200 Jiri Pirko wrote:
>> >I think it's because every time I look at struct net_device_ops 
>> >a little part of me gives up.  
>> 
>> Does this work? I checked the existing layout of devlink_ops and the
>> internal comments are ignored by kdoc. Actually the whole devlink_ops
>> struct is omitted in kdoc. See:
>> $ scripts/kernel-doc include/net/devlink.h
>
>Hm, it should work, it's documented as a legal way to kdoc:
>
>https://www.kernel.org/doc/html/next/doc-guide/kernel-doc.html#in-line-member-documentation-comments
>
>We should ask Jon if you're sure it's broken.

IDK, you can try, I don't see it there.

