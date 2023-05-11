Return-Path: <netdev+bounces-1665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BB06FEB8C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1F4D281670
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F4321CD5;
	Thu, 11 May 2023 06:05:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FBA371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:05:55 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A026C49D6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:05:44 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2ac770a99e2so88308431fa.3
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683785143; x=1686377143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDwuvdZbgP8xGCcyRCmYsXqLGUmnVPl9QB37DHVbcpQ=;
        b=Q3+2yDQ0Ng164GUsK1QMnnVmrhAaNuREYWJ47bVrEFuh3wGqHAC9vlV0S+NtesJY34
         r4otGufA1Csq75p01UHsgB0W2QYPbSiJoEytEWWBiNoVS2T2FLQX95slqhKEuRTdA+iS
         bvXZfejKlXFKuuX3RNPIs6bqQI0TZOb8XnOZWw7M70w2Zg/Bp2XWwFJH9rwF8Tvn4xmg
         mEknSR1ihBS3dQRZaj+0krC4vlmG9MyShFmIzxh3mDmlPvvdZ2TkovxRKyEOvOkTjBRq
         TK4ZC994iyIi32JjspZ1rJOKSu0e+b7cJXIcOxEtveEB/xQY70WFb0KwDmcB8XmjJ8/R
         nKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683785143; x=1686377143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDwuvdZbgP8xGCcyRCmYsXqLGUmnVPl9QB37DHVbcpQ=;
        b=XDyIIBet2jRXoHjjenV/u3k98PS4mj82/+q5gCgpEVDcLWG8q6y2OSEoRku51AxdXg
         o0Hs5uytS479t4+eYxTtRDmjaWx0SoV3r+ub4hqnMaTGW79Mxza/I2hW/2Nwa4UV58Rj
         gimXIAWF/fdEXyD1gLKdGMjpLpyTqmNrazUp+WLfh9gsav6zcMR+RhZXhZK8+LaH1EMT
         KEG51fPspGwpge/5eek9szuROsKcFq+QprG5AWQlT38eiCfcaOKufz3u6Ag7rwlQWVxU
         QbcLTiGP7Dqm91shEebXJStDbY1+Pv2rkwustPqpzuBQW+54rTN4bUFo7g9TxU5m4YT8
         oqkA==
X-Gm-Message-State: AC+VfDxNKu7I0v2Zf0Y2gi4J6Wy5roLpg5V6orTPjtqnqsdKsl0aptz0
	z9E1+THNizR+cphvdpbrHf864w==
X-Google-Smtp-Source: ACHHUZ7cHTR1TSlYoXM97buI3cOwy3T9QpBLoylhlrpoAujEduWTahH8Jfzgsmo1SJQu83KBMCkBwA==
X-Received: by 2002:a2e:9f47:0:b0:2ac:90db:2a3d with SMTP id v7-20020a2e9f47000000b002ac90db2a3dmr2643028ljk.8.1683785142596;
        Wed, 10 May 2023 23:05:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c24-20020a05651c015800b002a9ebff8431sm2262327ljd.94.2023.05.10.23.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 23:05:41 -0700 (PDT)
Date: Thu, 11 May 2023 08:05:40 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, me@pmachata.org, jmaloy@redhat.com,
	parav@nvidia.com, elic@nvidia.com,
	Nikolay Aleksandrov <razor@blackwall.org>, leonro@nvidia.com
Subject: Re: [PATCH iproute2] Add MAINTAINERS file
Message-ID: <ZFyFtHNjcxOz0Ayp@nanopsycho>
References: <20230510210040.42325-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510210040.42325-1-stephen@networkplumber.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 10, 2023 at 11:00:40PM CEST, stephen@networkplumber.org wrote:
>Record the maintainers of subsections of iproute2.
>The subtree maintainers are based off of most recent current
>patches and maintainer of kernel portion of that subsystem.
>
>Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
>Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
>---
> MAINTAINERS | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 49 insertions(+)
> create mode 100644 MAINTAINERS
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>new file mode 100644
>index 000000000000..fa720f686ba8
>--- /dev/null
>+++ b/MAINTAINERS
>@@ -0,0 +1,49 @@
>+Iproute2 Maintainers
>+====================
>+
>+The file provides a set of names that are are able to help
>+review patches and answer questions. This is in addition to
>+the netdev@vger.kernel.org mailing list used for all iproute2
>+and kernel networking.
>+
>+Descriptions of section entries:
>+
>+	M: Maintainer's Full Name <address@domain>
>+	T: Git tree location.
>+	F: Files and directories with wildcard patterns.
>+	   A trailing slash includes all files and subdirectory files.
>+	   A wildcard includes all files but not subdirectories.
>+	   One pattern per line. Multiple F: lines acceptable.
>+
>+Main Branch
>+M: Stephen Hemminger <stephen@networkplumber.org>
>+T: git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
>+L: netdev@vger.kernel.org
>+
>+Next Tree
>+M: David Ahern <dsahern@gmail.com>
>+T: git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
>+L: netdev@vger.kernel.org
>+
>+Ethernet Bridging - bridge
>+M: Roopa Prabhu <roopa@nvidia.com>
>+M: Nikolay Aleksandrov <razor@blackwall.org>
>+L: bridge@lists.linux-foundation.org (moderated for non-subscribers)
>+F: bridge/*
>+
>+Data Center Bridging - dcb
>+M: Petr Machata <me@pmachata.org>
>+F: dcb/*
>+
>+Device Link - devlink

It's actually just "Devlink". I don't think we have "device link"
anywhere.


>+M: Jiri Pirko <jiri@resnulli.us>
>+F: devlink/*
>+
>+Transparent Inter-Process Communication - Tipc
>+M: Jon Maloy <jmaloy@redhat.com>
>+F: tipc/*
>+
>+Virtual Datapath Accelration - Vdpa
>+M: Parav Pandit <parav@nvidia.com>
>+M: Eli Cohen <elic@nvidia.com>
>+F: vdpa/*
>-- 

What about "rdma"? I think Leon is a fit for that area.

Overall, good idea to have this!

Thanks!



