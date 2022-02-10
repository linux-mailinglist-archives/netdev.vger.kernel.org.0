Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2E4B06C6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 08:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiBJHCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 02:02:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbiBJHCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 02:02:15 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2041007
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 23:02:15 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ch26so9165327edb.12
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 23:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8W8qNsQkPekx4+jBc/rCyADx6fiSCeEy7qv0YDJEz88=;
        b=4o+JMS3rdmjt+g1J3QFITq+TZSTKGRuxLoxc0CjtqNWBBi4qithMjTsOBKg26gNcDc
         VTLnb39R8b3NxFmtS0/6w4k4uhe8C/5V36bSVd+Jwd4iZ6RyTmWnzSepJHTdglHcufaA
         9JRR8EYuWCLQpM03Y7LdHgdxTEd2sQ1sfftV/blEloM0+Ka/IC8DQyLKh7Z32EG7yf/N
         vS22MFH8o7GdDetXK5vn++ksGZ0yiKeoQ2xBbM8u4f+XIfMxoL8znHIirXD4LGwNLGlo
         idaClRwVE+S0XQZwLZnGARFuGg/xdG8tWbkX3P9w2IHC1O31ll8jwoBf6D6ObzEk8NiN
         eSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8W8qNsQkPekx4+jBc/rCyADx6fiSCeEy7qv0YDJEz88=;
        b=eTSLzwLhpvErYiVZAz5yNhOyILKvjXJWnwHKJjBrq+8yHoYcXSE8sGFsJYAUIrRuBm
         Srb1TKragJ5Ts5Y3pHNPQtFKsiBiAk7nmJgzoAShydOkLG1Pp7oQPUMFL87jy2r7LX+F
         ScYgpT5JSO2YIuXwoC4bNzgB5UngckuI5ejd1EcrBy1uddmSmOosiZw15WDssU2XEdaK
         zj+/ZqTYtbKBKswdIOGg7LF7xoxlNyJbidBlEfNFTQJ4RzeEHhuOxs2LUUwFnJsZyBZ1
         NPZhQPISVS9bCVUgNiEYGfFGoINeASNmgv8laxhEMqIU3EOLazbdzC8OGDuaVENoJeh+
         FsaQ==
X-Gm-Message-State: AOAM533MZikkEkSJ0VDWFftrSs1gRLIfv/jpsGNzwIWDm4l3X4VdGM5h
        ToUkfPXc/DZFdOiLN4upg5jxWg==
X-Google-Smtp-Source: ABdhPJxlDHHK73hDkQqMYWRIurlz7AdZtYqkU6ZeihEyFDPU6Q3mF2n+XsBeID30velI8V06BJDCuQ==
X-Received: by 2002:a50:ccd3:: with SMTP id b19mr6831351edj.253.1644476534054;
        Wed, 09 Feb 2022 23:02:14 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b7sm9215079edv.58.2022.02.09.23.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 23:02:13 -0800 (PST)
Date:   Thu, 10 Feb 2022 08:02:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Message-ID: <YgS4dFHFPPMITaoV@nanopsycho>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
 <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgOQAZKnbm5IzbTy@nanopsycho>
 <20220209172525.19977e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209172525.19977e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 10, 2022 at 02:25:25AM CET, kuba@kernel.org wrote:
>On Wed, 9 Feb 2022 09:39:54 +0200 Moshe Shemesh wrote:
>> Well we don't have the SFs at that stage, how can we tell which SF will 
>> use vnet and which SF will use eth ?
>
>On Wed, 9 Feb 2022 10:57:21 +0100 Jiri Pirko wrote: 
>> It's a different user. One works with the eswitch and creates the port
>> function. The other one takes the created instance and works with it.
>> Note that it may be on a different host.
>
>It is a little confusing, so I may well be misunderstanding but the
>cover letter says:
>
>$ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
>              value false cmode runtime
>
>$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>
>So both of these run on the same side, no?
>
>What I meant is make the former part of the latter:
>
>$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11 noprobe

I see. So it would not be "global policy" but per-instance option during
creation. That makes sense. I wonder if the HW is capable of such flow,
Moshe, Saeed?


>
>
>Maybe worth clarifying - pci/0000:08:00.0 is the eswitch side and
>auxiliary/mlx5_core.sf.1 is the... "customer" side, correct? 

Yep.
