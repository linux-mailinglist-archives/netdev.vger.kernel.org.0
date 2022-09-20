Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2DA5BD891
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiITAAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiITAAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:00:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B1E101DA
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:00:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE3862116
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E66BC433D6;
        Tue, 20 Sep 2022 00:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663632039;
        bh=NnmscK+qEIpRmtoD3T5Xlx8zeBJiDacI1wnjlPlgbzw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rk9EDLpq5xNeGGuSFG4AetVj7KPBFHTfaLGWQ0pG0UGLzL1EoOGznpwCgRwLNYeKM
         0jqGRAFB5HvO1brv6UV8bMfPBGVTwThbRsBGRldCRvTjr01lOO/bzHDxXxlCs2OGXP
         FY8mARqdRLslQKNUhy2X4QNlFudNw5qHKblXIetIPkF3/3Wmfj+6VlJqatG/5QP/Uz
         TIy/fgGl3GeGaTGW0TDcyHIV4qOhSf3T4UataFbwFTdNFO5twbxLNBkuTALOIIpbni
         ZDQuAjOh0v98ooH+xaQkBXi0M7VWXCLD5Y5ddqgxWSM3MxvrW6ACC2JDGcsLLOOGr9
         BSYlDNf2aIqDg==
Date:   Mon, 19 Sep 2022 17:00:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: [PATCH ipsec-next 1/7] xfrm: add extack support to
 verify_newsa_info
Message-ID: <20220919170038.23b6d58e@kernel.org>
In-Reply-To: <b492239e903e8491abfd91178b572b59a48851e3.1663103634.git.sd@queasysnail.net>
References: <cover.1663103634.git.sd@queasysnail.net>
        <b492239e903e8491abfd91178b572b59a48851e3.1663103634.git.sd@queasysnail.net>
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

On Wed, 14 Sep 2022 19:04:00 +0200 Sabrina Dubroca wrote:
>  	case IPPROTO_COMP:
> +		if (!attrs[XFRMA_ALG_COMP]) {
> +			NL_SET_ERR_MSG(extack, "Missing required attribute for COMP: COMP");
> +			goto out;
> +		}

Did NL_SET_ERR_ATTR_MISS() make it to the xfrm tree?
