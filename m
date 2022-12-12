Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D3B64A928
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiLLVDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiLLVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:03:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CECA1A3A2;
        Mon, 12 Dec 2022 13:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0997E6122C;
        Mon, 12 Dec 2022 21:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D7CC433D2;
        Mon, 12 Dec 2022 21:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670878945;
        bh=UYWCrX2SdeaGdrjephxWJSz8hd3vseMdWBi7qv9hc+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hUN2PuvqGhiX1804SHPtWkR41XtzZ52cTWV+5ALL1jp2YMmvhQqwLW5uwI2uygFtT
         4ATgsyhvJpUt1sce6VRMoOZ5nWFlxN/J4VHy43CDxOweWEyjShth8YYgpCs4+2NsVq
         1NMtiUsEy8KYbAMVN12ZccuraMkTPiRnpcAqObDtrB0WvcDF128N6+kUxJSGc0iLkV
         dkQ0k39cJG9uHzURV4AyyCH4iBsRo+uw2CdtOy92iK5/XZpFTO4V2K6Wa6Jwosgomo
         LQyv4NnmxMHISkDF5Aw2qKX0I3HZrmFEmcqcACuFq+gvHkRFwNzhWUVyjze5B+bdiM
         aPlhoLdSoovhw==
Date:   Mon, 12 Dec 2022 13:02:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <lars.povlsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        kernel test robot <lkp@intel.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [PATCH net-next] net: microchip: vcap: Fix initialization of
 value and mask
Message-ID: <20221212130224.19bf695f@kernel.org>
In-Reply-To: <20221209120701.218937-1-horatiu.vultur@microchip.com>
References: <20221209120701.218937-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Dec 2022 13:07:01 +0100 Horatiu Vultur wrote:
>  	case VCAP_FIELD_U128:
> +		value = data->u128.value;
> +		mask = data->u128.value;

If setting both to value is intentional - please mention in the commit
message. Otherwise this looks odd.
