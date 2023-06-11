Return-Path: <netdev+bounces-9909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA57D72B260
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0C4F1C20934
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 15:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC41BA57;
	Sun, 11 Jun 2023 15:06:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4333F1
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 15:06:59 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F2FC9
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:06:58 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b3b5a5134dso4691255ad.2
        for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686496017; x=1689088017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCataqj/hrvaZ6Ebi2N8eosMT0yZiqBJ+mZQi04Vhlw=;
        b=cw7UX+76Qa7kEnqHHZ+5LLWd4QEZcDgbhPU/VXR8z7nA6Ln0//hGZHetKs9Fmih1wz
         h1y1pj6lqcODR4xliSd8ZtfGWGPUVdT8DU9Uq3Liy2qCF5YEo9JoUne5643UVvgMiNeG
         n4PVfpI6SDxidqv3QAwIst6xcwUoKR3KjmWcxP1zjsuVo4DzACB3DJLwP1uY0Dzqy+IM
         KfbER/KpCGn1wPfxCgZrYGEDijLyM0ttJNEWIUc6uEBwVmJsDCBRayNZOEfqHlpa7Wlq
         Rzflo5/eFqJEvXPR+ZH0J/nKdOXbg7hNpuLvu5vPrDq73JR8hJCzPfBSsc0THRINrAFt
         3k1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686496017; x=1689088017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jCataqj/hrvaZ6Ebi2N8eosMT0yZiqBJ+mZQi04Vhlw=;
        b=dY3Ll0ZX4/coals3fZkl6O++Nf4oP0KL050oQF7TPxI6U6hYAU2rffzfk4U/SiwEZZ
         TVbXT/d2oqy32vT3Khz3MGdBhro+uxsDjdDgZsGkDY1FZTXAZkebhEFCW2VDydhtVgQz
         rzIZX3ZiXG6t9RENW4cHZ02mRivrN9BDoWNv3lvQAU8xLJJdVyMIcLAlo7DKWU4204hJ
         rO21VGMdYaPnD5JDVZBqft0OKSJaH619K0c9a+fjcjvATWDSZ+wJ8WmHcXm6G1RWqa14
         IHU/bw6IWpOo3VOnVbi0TkYsw6ofiOcfqml77vQJVB9pYfZiPYFzxvHGiG60nUbeCY9U
         8teQ==
X-Gm-Message-State: AC+VfDyi71RZ+DZuufStJwCZ/5eznGmgfEpB7zGeSs7dy2vcWBLX6Ie+
	7H9YvzDWMje8w9SZjvyfdIE/kQ==
X-Google-Smtp-Source: ACHHUZ4Q7s8+kjedHGvtmajVa0LpL+/drnn7Y2sUEUt/SRA83APdCmrL/Wz65CEy5bo14zUB7GDVMg==
X-Received: by 2002:a17:902:ea0e:b0:1ad:e198:c4fc with SMTP id s14-20020a170902ea0e00b001ade198c4fcmr5216210plg.54.1686496017431;
        Sun, 11 Jun 2023 08:06:57 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id jl1-20020a170903134100b001a245b49731sm5071923plb.128.2023.06.11.08.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 08:06:57 -0700 (PDT)
Date: Sun, 11 Jun 2023 08:06:55 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Gal Pressman <gal@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, David Ahern <dsahern@gmail.com>, Michal Kubecek
 <mkubecek@suse.cz>, <netdev@vger.kernel.org>, Edwin Peer
 <edwin.peer@broadcom.com>, Edwin Peer <espeer@gmail.com>
Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
Message-ID: <20230611080655.35702d7a@hermes.local>
In-Reply-To: <20230611105108.122586-1-gal@nvidia.com>
References: <20230611105108.122586-1-gal@nvidia.com>
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

On Sun, 11 Jun 2023 13:51:08 +0300
Gal Pressman <gal@nvidia.com> wrote:

> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> This filter already exists for excluding IPv6 SNMP stats. Extend its
> definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.
> 
> This patch constitutes a partial fix for a netlink attribute nesting
> overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
> requester doesn't need them, the truncation of the VF list is avoided.
> 
> While it was technically only the stats added in commit c5a9f6f0ab40
> ("net/core: Add drop counters to VF statistics") breaking the camel's
> back, the appreciable size of the stats data should never have been
> included without due consideration for the maximum number of VFs
> supported by PCI.
> 
> Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
> Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Cc: Edwin Peer <espeer@gmail.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---

Better but it is still possible to create too many VF's that the response
won't fit.

