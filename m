Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC24BA7EC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244131AbiBQSPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:15:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbiBQSPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:15:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6611213423;
        Thu, 17 Feb 2022 10:14:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 400AEB82362;
        Thu, 17 Feb 2022 18:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEC1C340E8;
        Thu, 17 Feb 2022 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645121683;
        bh=7AJ1b0nf0U+JgkfWShs9n3f+Q1vwfp9Hvr/sX+YrLlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mHKwk8ywjFOzqn48JQECgebzBVKFAw1p6qR588QdoteDeYj0ptogTq2pf5lX54SV0
         U7tFrDHvTq2nOLDr5O/mCJkDU/Rwb/kvSp4CdLihmBKQUGMxAhfbNWPwAChRq8XE2M
         vhDbiGKi9iKSEOLvOkR79kQr0VFWpH4vq//jTNSP0wMn0clu572rN5NAFozk+OMf9E
         aiqMM//GjsOTeS/oHJpRvgt3zpiIdnrFreLtleq5LmlDrCQPfYs+593rPRcWSu+34c
         zbnHD6Awdq+iysDrLh1iWoom7iQeY2HuIz/iG4h+K1ouxWIVgwPgcGvyFg8LF1Wocw
         TRdE8siLudDKg==
Date:   Thu, 17 Feb 2022 10:14:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Message-ID: <20220217101442.0a2805b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <13805dc8-4f96-9621-3b8b-4ec5ea6aeffe@csgroup.eu>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
        <20220217092442.4948b48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <13805dc8-4f96-9621-3b8b-4ec5ea6aeffe@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 18:11:58 +0000 Christophe Leroy wrote:
> Looks like csum_replace4() expects __be32 inputs, I'll look at it but 
> I'm not inclined at adding force cast, so will probably leave 
> nft_csum_replace() as is.

That may imply also leaving it in your tree..
