Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB719031
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfEIS3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 14:29:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45887 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfEIS3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 14:29:25 -0400
Received: by mail-qt1-f194.google.com with SMTP id t1so3620203qtc.12
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 11:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6TX4Ch/ylEGR/Zx4Bl/32H7rH72Gvc2EMOaKvQY0xYk=;
        b=rm0RHv9+nNMEUumQ8Wd2a7wBOk3foOGmNUNn6lIs7a2nTmvFYHzSASv+yoGVKTCDcW
         btUAvTHvi9zBkbSm0EKqBckHjj9ODqEjOCohCRM2e9CpBQOmyFRtLTADbI6PudjjMm5b
         ijHUHy52TesO9t7BuSGiDtDA9w3U2vlBpQ+kqQfL8DpozcB12loX8h6t9R/fPYf+1dSV
         lpcsVU1OHMA1zqw6uzBHy7lR9ZXUAzESYnLP+RLXb/3lZ6cXRTa0JBWWspdqjxh0p9b2
         OQVKaNPhc88GHMvCf/sSl4zTsUx72gC5Lu6HkuzbZhhAyOrpL2zb3Jpqcrcky8g/fA1Q
         mvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6TX4Ch/ylEGR/Zx4Bl/32H7rH72Gvc2EMOaKvQY0xYk=;
        b=M7wovBHgTjiU9YcUuwH38ADJMEmHl4dfv88wObahZuaWjjgC2hwKRTqzfkOE+YuYXy
         dv3PlpbAGKBNfwtUHJllHMxO+Y6h6IT082UzGfMVdtABXFlE70imxrLbBPfT3FrC4zlR
         igPCpB4dOlrKxnBrVMBX4JEJElcHMk6zO5+dnWL+GYJ7pgJTpjcDQ0t7oi4GKz3CNafu
         vLslPMn+SZCiwYqyklBluR0sHarsYU/qswk+9Z7p5oZCYJBcXvP6HqBKaNy5oJRH5w4m
         8+e1e5Naf4acrI2LY9FDIkkeqnQppC8/gVcjV9kAMK+/szPmLLuDIL8TNREi5f99cayl
         /e8w==
X-Gm-Message-State: APjAAAUUkbN1htI09rI/tNmJ9RU0Ip9ngUvN5HBDQPBzoSZY/aTu2X4V
        gpSSLGMUnUCXiO6dnuUj0g8X6Q==
X-Google-Smtp-Source: APXvYqyZd60imGGU8w6kQMAUYW3jSOGxaqipnd66iyZkJafJVkxIZZU6QJmzan0XNSKocv+UGsdXhQ==
X-Received: by 2002:ac8:411e:: with SMTP id q30mr5091947qtl.319.1557426564395;
        Thu, 09 May 2019 11:29:24 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p19sm1626014qtp.19.2019.05.09.11.29.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 09 May 2019 11:29:24 -0700 (PDT)
Date:   Thu, 9 May 2019 11:29:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 0/2] netfilter: add hardware offload
 infrastructure
Message-ID: <20190509112902.2691c690@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190509163954.13703-1-pablo@netfilter.org>
References: <20190509163954.13703-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 May 2019 18:39:49 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds initial hardware offload support for nftables through
> the existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
> classifier and the flow rule API.
> 
> Patch 1 move the flow block callback infrastructure to
> 	net/core/flow_offload.c. More structure and enumeration definitions
> 	currently in include/net/pkt_cls.h can be also there to reuse this from
> 	the netfilter codebase.
> 
> Patch 2 adds hardware offload support for nftables.
> 
> This patchset depends on a previous patchset:
> 
> 	[PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block callbacks from netfilter
> 
> More information at: https://marc.info/?l=netfilter-devel&m=155623884016026&w=2
> 
> Comments welcome, thanks.

Jiri requested the drivers remember the block info, so we can't have
multiple block binds right now, unless we fix drivers.  See:

commit d6787147e15d ("net/sched: remove block pointer from common
offload structure")

for example.
