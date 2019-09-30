Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4BCC1BCD
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfI3G5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:57:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:45646 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726121AbfI3G5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:57:14 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iEpcE-0008QN-4w; Mon, 30 Sep 2019 09:57:02 +0300
Message-ID: <ab9673e80e53e217b0a4a871713b375b3e4a2fa3.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 30 Sep 2019 09:57:00 +0300
In-Reply-To: <20190927205608.8755-1-navid.emamdoost@gmail.com>
References: <20190927205608.8755-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iwlwifi: fix memory leaks in
 iwl_pcie_ctxt_info_gen3_init
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-09-27 at 15:56 -0500, Navid Emamdoost wrote:
> In iwl_pcie_ctxt_info_gen3_init there are cases that the allocated dma
> memory is leaked in case of error.
> DMA memories prph_scratch, prph_info, and ctxt_info_gen3 are allocated
> and initialized to be later assigned to trans_pcie. But in any error case
> before such assignment the allocated memories should be released.
> First of such error cases happens when iwl_pcie_init_fw_sec fails.
> Current implementation correctly releases prph_scratch. But in two
> sunsequent error cases where dma_alloc_coherent may fail, such releases
> are missing. This commit adds release for prph_scratch when allocation
> for prph_info fails, and adds releases for prph_scratch and prph_info
> when allocation for ctxt_info_gen3 fails.
> 
> Fixes: 2ee824026288 ("iwlwifi: pcie: support context information for 22560 devices")
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---

Thanks, Navid! I have applied this to our internal tree and it will
reach the mainline following our usual upstreaming process.

--
Cheers,
Luca.

