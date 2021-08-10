Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25713E7C82
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243374AbhHJPkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:40:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243586AbhHJPkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628609988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PosN/BQlgO407DGmnaZ7DbLvbofuu3rHwhQkO8w4Da4=;
        b=Ric68/kW5zBTIGoA4zkmsgPWcEgJZq7dDMtgJl0I9jWGVR/9zZaC1yn/WtRv/SLimlWGwv
        BuLcAiNLZJZho+7hTcZrzzs3GedOC7smqlppbdF1meymUp4dTae74OG1VPHMlsaempAchc
        T421PPf6dT5Mggp4cKoZI1Qlfp6b+n4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-O3PavGnqMAenFxePL0glSg-1; Tue, 10 Aug 2021 11:39:45 -0400
X-MC-Unique: O3PavGnqMAenFxePL0glSg-1
Received: by mail-wm1-f71.google.com with SMTP id i6-20020a05600c3546b029025b0d825fd2so1118822wmq.4
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PosN/BQlgO407DGmnaZ7DbLvbofuu3rHwhQkO8w4Da4=;
        b=AprFIOdmRZHHBK6MMLIsLBPU+NXH8gYaD5ihiikM+axkpqn+XS0sCjHhTwxsoWBKc2
         +PAkSPIRaEszpQX9Gp1B///MofqYwOEGf8u3IrcbEDgre4ZzmQuyluk2cbnCOtJFVge9
         NYJegAyAf4h+I/H4XS/KS1J56mgUHObPqYrIMbqSGiOKlGVfE6F948/NZjGH3Vx5eL02
         ajS0GcAh89h6HPUoXqFkdJDvRK2VSt52oMQhMPuRrcyJjf5W3DWD+8aYsECCPJvm2z9b
         DKlNRglHDvTK0YaDcmh+13KQ0EPXpcTfLBKLOoajOmoEVDa9KoJa8g2mSCb2PN/KGXeP
         mDgA==
X-Gm-Message-State: AOAM530++0n2m2wNTaJBENkarxE9tJL4ksO65vXu586o7NDJFyxNyv73
        v4tmAKpsin0oe7HpVtl70dyQJnh12WRWUQm4JeZkd+YfTKGQiOwD+80Dv2VQLUjC8++weZes9z/
        dgJHSZ/75agAroM3R
X-Received: by 2002:a1c:7d06:: with SMTP id y6mr3626173wmc.7.1628609984511;
        Tue, 10 Aug 2021 08:39:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw72W8jCGvxKisUudy1C9Uk3WRrkPv1bMEx4uTRO/fxaJ6DDCtTXdBXdyOy3DU2WnJ8uX49ww==
X-Received: by 2002:a1c:7d06:: with SMTP id y6mr3626164wmc.7.1628609984390;
        Tue, 10 Aug 2021 08:39:44 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p8sm3029396wme.22.2021.08.10.08.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:39:43 -0700 (PDT)
Date:   Tue, 10 Aug 2021 17:39:41 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210810153941.GB14279@pc-32.home>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210809193109.mw6ritfdu27uhie7@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 09:31:09PM +0200, Pali Rohár wrote:
> Better to wait. I would like hear some comments / review on this patch
> if this is the correct approach as it adds a new API/ABI for userspace.

Personally I don't understand the use case for setting the ppp unit at
creation time. I didn't implement it on purpose when creating the
netlink interface, as I didn't have any use case.

On the other hand, adding the ppp unit in the netlink dump is probably
useful.

