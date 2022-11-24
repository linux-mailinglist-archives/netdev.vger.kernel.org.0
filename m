Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF7B637E5D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKXRjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXRjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:39:10 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C28134750
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669311549; x=1700847549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vtbyPX93DhGwU5PxJdT9VAwD2E+RkIWCfQrDLwNQotc=;
  b=dnMgMSL9qA1HB9mkyZFT0I3YtWSQfJ6tha7Kuc4hwOZFhp9L/pluz/Tp
   eRfSZPFkY6/WiBgVD8xUN1PVcw5pssMX1ztEG82DzPSwibdnkKVeqLyoJ
   ecQf8O7zG2FvGFO7JDakAVUS86u4MvetNCwrbpv+19mKRoPYIYYVRduFo
   pJoTzJiSH7iaiolt8MGNQQFTTxinGN5igb+96yeeFeouK2aDh30jPxaq3
   vZs+qQd5T1lpSii+a1/w7MyNP2glv1rdtR2m+kXX5Gtm1LTjUe5kKBG07
   CPWFdykwsQyERo6YFWAknVYc1P/psTtS5SI11NttBKM2I9awx5Q12m3c9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="376486625"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="376486625"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 09:39:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="767142884"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="767142884"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 24 Nov 2022 09:39:06 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AOHd5fp002097;
        Thu, 24 Nov 2022 17:39:05 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] pull request (net): ipsec 2022-11-23
Date:   Thu, 24 Nov 2022 18:38:55 +0100
Message-Id: <20221124173855.5237-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123093117.434274-1-steffen.klassert@secunet.com>
References: <20221123093117.434274-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Wed, 23 Nov 2022 10:31:10 +0100

> 1) Fix "disable_policy" on ipv4 early demuxP Packets after
>    the initial packet in a flow might be incorectly dropped
>    on early demux if there are no matching policies.
>    From Eyal Birger.
> 
> 2) Fix a kernel warning in case XFRM encap type is not
>    available. From Eyal Birger.
> 
> 3) Fix ESN wrap around for GSO to avoid a double usage of a
>     sequence number. From Christian Langrock.
> 
> 4) Fix a send_acquire race with pfkey_register.
>    From Herbert Xu.
> 
> 5) Fix a list corruption panic in __xfrm_state_delete().
>    Thomas Jarosch.
> 
> 6) Fix an unchecked return value in xfrm6_init().
>    Chen Zhongjin.
> 
> Please pull or let me know if there are problems.
> 
> Thanks!
> 
> The following changes since commit 1d22f78d05737ce21bff7b88b6e58873f35e65ba:
> 
>   Merge tag 'ieee802154-for-net-2022-10-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2022-10-05 20:38:46 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master
> 
> for you to fetch changes up to 40781bfb836eda57d19c0baa37c7e72590e05fdc:
> 
>   xfrm: Fix ignored return value in xfrm6_init() (2022-11-22 07:16:34 +0100)
> 
> ----------------------------------------------------------------
> Chen Zhongjin (1):
>       xfrm: Fix ignored return value in xfrm6_init()
> 
> Christian Langrock (1):
>       xfrm: replay: Fix ESN wrap around for GSO
> 
> Eyal Birger (2):
>       xfrm: fix "disable_policy" on ipv4 early demux
>       xfrm: lwtunnel: squelch kernel warning in case XFRM encap type is not available
> 
> Herbert Xu (1):
>       af_key: Fix send_acquire race with pfkey_register
> 
> Thomas Jarosch (1):
>       xfrm: Fix oops in __xfrm_state_delete()
> 
>  net/core/lwtunnel.c     |  4 +++-
>  net/ipv4/esp4_offload.c |  3 +++
>  net/ipv4/ip_input.c     |  5 +++++
>  net/ipv6/esp6_offload.c |  3 +++
>  net/ipv6/xfrm6_policy.c |  6 +++++-
>  net/key/af_key.c        | 34 +++++++++++++++++++++++-----------
>  net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
>  net/xfrm/xfrm_replay.c  |  2 +-
>  8 files changed, 57 insertions(+), 15 deletions(-)

(for the whole PR)

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Thanks,
Olek
