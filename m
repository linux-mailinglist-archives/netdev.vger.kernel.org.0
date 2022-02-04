Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1DF4A991D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 13:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiBDMSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 07:18:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:62117 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbiBDMSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 07:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643977091; x=1675513091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rsHwhycQBjzKkVaQzgpTFJJr9GYVk+lgPSRFfSQlesQ=;
  b=bGQLPfHYMKd0yFkivXvojCKX3nb8oKmD60dS12Jprjd1hQTlYkWal3DL
   lg/M3vkQ9niVDalLjf0U4JUK54T3suhfdD2OSswT80SVm2h9xg2RqpmNa
   HmYqZ9zUcg5dOG0hmMIz2y6ZhCiHrBYz4ekWgDqnbm+JRWSqX/qJUtvLV
   JWEugTkFYlCBLw6dL1lKk6QCn21ly5pTq3pat0F3sjG1q+vexsDvMCBm4
   JqqmYygVTpqPMXu+yHCiVBuVWgiVVjgrv4Ux8SRtktGadHRdPdbLKMVue
   fxKRPGSKJh5zgWt+b/X4BJ1QbPGH4qtOTjVmIO8a1Qdxu9BrnzZ9YP7PH
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="231926123"
X-IronPort-AV: E=Sophos;i="5.88,342,1635231600"; 
   d="scan'208";a="231926123"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 04:18:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,342,1635231600"; 
   d="scan'208";a="600215757"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2022 04:18:09 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214CI8BP019539;
        Fri, 4 Feb 2022 12:18:08 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 0/2] gro: a couple of minor optimization
Date:   Fri,  4 Feb 2022 13:16:06 +0100
Message-Id: <20220204121606.81211-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643972527.git.pabeni@redhat.com>
References: <cover.1643972527.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  4 Feb 2022 12:28:35 +0100

> This series collects a couple of small optimizations for the GRO engine,
> reducing slightly the number of cycles for dev_gro_receive().
> The delta is within noise range in tput tests, but with big TCP coming
> every cycle saved from the GRO engine will count - I hope ;)
> 
> v1 -> v2:
>  - a few cleanup suggested from Alexander(s)
>  - moved away the more controversial 3rd patch
> 
> Paolo Abeni (2):
>   net: gro: avoid re-computing truesize twice on recycle
>   net: gro: minor optimization for dev_gro_receive()

Looks nice to me now, thanks!
For the series:

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> 
>  include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
>  net/core/gro.c    | 16 ++++-----------
>  2 files changed, 32 insertions(+), 36 deletions(-)
> 
> -- 
> 2.34.1

Al
