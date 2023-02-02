Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19656882ED
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjBBPpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjBBPpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:45:17 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA86D7961D
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:44:48 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ud5so7145454ejc.4
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 07:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Larx4zrp/OS0f2YK4Nurdgp9E3q9pvZQ+O3YyQF6LE0=;
        b=N2yTY4wMB/3/sAUiH7vSAhukjRWgIKSiDqm6dPmz6z2pyKZvw2vcwYX8J6o8S5O7Oj
         WdhljRfBg7/TEXTHeoCx4Avck1y4EwBaGvOLT8i4PiNgSF8h0psBdiTjVllKhRT8R6sp
         +Xh+MpB7RDNG9KX/FVP7qvAU7AI05nFHR/AC9HIWTjzfU8gdZFYbF1TEi+axV/9tivFN
         iwjjfcQAMoMT2JPOurC69RlWgXm9TOfBb3yTdSviYwZQYNZ6KeM8ViUL6B90IFOIwL2n
         WTl+kAUIrnR/sRuLjC+uDV3fLfAE3sN2GU1NMHVwZuh17gIKOun9NxOdjh5K9T20iUsB
         GYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Larx4zrp/OS0f2YK4Nurdgp9E3q9pvZQ+O3YyQF6LE0=;
        b=eGglGx58B7kw7LLeyCJ2P2Z0Sf/eWKfhnVIpGEu1Ob5DtrNVHeNy57uBEZ2lNH558R
         kTfrcRcIMVY8AKe31dmROuBlvCJsCEVO9H5VEWSsAceFncE3O64nZOhzKG6I7Qe+ZuGY
         UiVuheprQf+nQy1+Xt1t93V5edH+V4FwQUmxXHMeSoHgqGRrVDROtTO1a6Y+2rzo1Jun
         k1LPwwaII2xc+ngjxL0LbPchxVhM/nYW1y3MRCoNwOQFJ8HjqopfiQEPV96KX0smOX4z
         bly964GNNfPShbzNS+xuvQ5Xdv1jvPrgDuN2XLITSI7V1LEwjOOLCMS7OyBSn2DjTQVA
         Na+w==
X-Gm-Message-State: AO0yUKWqLlIC7/ZU465/y8XvDdmvTqd89obeYCiDN2Y8mG7lY3vDBtn9
        bVuKtCofyEhAxomMbQHRIF7gQw==
X-Google-Smtp-Source: AK7set8cbNQBhXkYcUM25lzZrCVG3jA4R9/dpx0iVCHSkzGXWJY7GDoZJGVrXYMhY1IktXOugXNd4Q==
X-Received: by 2002:a17:906:c241:b0:878:60da:1f63 with SMTP id bl1-20020a170906c24100b0087860da1f63mr5884676ejb.43.1675352659261;
        Thu, 02 Feb 2023 07:44:19 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id cf8-20020a0564020b8800b004a18f2ffb86sm10529264edb.79.2023.02.02.07.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:44:18 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:44:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] devlink: Move devlink dev code to a
 separate file
Message-ID: <Y9vaUZkiERmasO/9@nanopsycho>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 03:46:59PM CET, moshe@nvidia.com wrote:
>This patchset is moving code from the file leftover.c to new file dev.c.
>About 1.3K lines are moved by this patchset covering most of the devlink
>dev object callbacks and functionality: reload, eswitch, info, flash and
>selftest.
>
>Moshe Shemesh (7):
>  devlink: Split out dev get and dump code
>  devlink: Move devlink dev reload code to dev
>  devlink: Move devlink dev eswitch code to dev
>  devlink: Move devlink dev info code to dev
>  devlink: Move devlink dev flash code to dev
>  devlink: Move devlink_info_req struct to be local
>  devlink: Move devlink dev selftest code to dev
>
> net/devlink/Makefile        |    2 +-
> net/devlink/dev.c           | 1343 ++++++++++++++++++++++++++++++++
> net/devlink/devl_internal.h |   30 +
> net/devlink/leftover.c      | 1470 ++---------------------------------
> 4 files changed, 1435 insertions(+), 1410 deletions(-)
> create mode 100644 net/devlink/dev.c

Looks fine to me.

Thanks Moshe!

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
