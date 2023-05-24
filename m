Return-Path: <netdev+bounces-4959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 706ED70F5EA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4902811B3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727F217FE3;
	Wed, 24 May 2023 12:08:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8417ADB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:08:12 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD979130
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:08:09 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f5685f902so122980266b.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684930088; x=1687522088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJcZbYU6Azl/IewoL1Xb5DU47MmhVR+5fyECNSqyDz8=;
        b=dH/t5OUqHCP0OKLdaTDRKReei5OeS1ZHtq7FPzBXvLvsEPlaBrn8Jv11e4A4h7rYlz
         Qx5iLoNSnxUTY84mMjfAam47bj62ae/XJNeJjZHKWvnyDOCVlK9Ffv3WJSRl8gJgJxGL
         8xkXyT+hWfBKIph4wh/x5lj4rxzEt7ql9lwynprSFQakQag+is5qMvf5OxFerUhPWfmf
         EVVTN5+4M/1xexZl8A7PN/ZbfXqqrmfmybWp85bfS/LxH5xAGNX1emDoK6+0jVIAc2vd
         lJ/wZ5+vP23Lj2qrXVt/tpeA6yHt0tO2wcHwU6EitRA0rCuOHWVUlHj2gGhrcisEUSq8
         SeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930088; x=1687522088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJcZbYU6Azl/IewoL1Xb5DU47MmhVR+5fyECNSqyDz8=;
        b=TlrghpoZno0nrpFS/iLCeOQyUBQQKoAdXAOClTUxgkL89tNzFzMniMqiN8rh6wUf0z
         JEZmG4RXoUW5fJfabpdLLPi1CrmtwTzrDXc9RywwnoyLzJAC/QJh7jcc6BmOXeOSXX9t
         1c3tZ+orSK9F0nWstmSN/8De1NoW79hA1bKu4+4u7LrA81kPEqLGPlO9UpC28p7x4LmI
         Q9CdCj3ByZAVyLiKGWtuvRj13FO7l1oe2bXouk/wvW4eib/oKdomxBv8626sdv5WdVoO
         w31h2mEhkPXMDgR5/sfVrDDqcfKes2P0BTfLC0iuJ7w5WPhQ1rH1NC/VZFxc8YWGIo/y
         Qq9A==
X-Gm-Message-State: AC+VfDx0R2msZFXrm1gxbFGgMZ6DIZMrCpNqAZBFs4PRTK1fuBETySaD
	v8v2ziWKlDHexGNMZPQTLB0tuh4vglFw+bEAtisBNw==
X-Google-Smtp-Source: ACHHUZ66A4oIp6e/Skxs8Z9Xt5LbVHjNnywBtYFXgWlRhvL8HmPSD4Egd49d/AoTo2n5z/mtynQ6ig==
X-Received: by 2002:a17:907:7f26:b0:968:8b67:4507 with SMTP id qf38-20020a1709077f2600b009688b674507mr18511154ejc.69.1684930088118;
        Wed, 24 May 2023 05:08:08 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b3-20020a1709064d4300b009545230e682sm5682387ejv.91.2023.05.24.05.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:08:07 -0700 (PDT)
Date: Wed, 24 May 2023 14:08:06 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Dave Ertman <david.m.ertman@intel.com>, mschmidt@redhat.com,
	ihuguet@redhat.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net-next 4/5] ice: Remove LAG+SRIOV mutual exclusion
Message-ID: <ZG3+Jrok46tEjXLV@nanopsycho>
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
 <20230517165530.3179965-5-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517165530.3179965-5-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 17, 2023 at 06:55:29PM CEST, anthony.l.nguyen@intel.com wrote:
>From: Dave Ertman <david.m.ertman@intel.com>
>
>There was a change previously to stop SR-IOV and LAG from existing on the
>same interface.  This was to prevent the violation of LACP (Link
>Aggregation Control Protocol).  The method to achieve this was to add a
>no-op Rx handler onto the netdev when SR-IOV VFs were present, thus

Uff, that is a very ugly misuse of rxhandler :/

Glad to see it go!

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

