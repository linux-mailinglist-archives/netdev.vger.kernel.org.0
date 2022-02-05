Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43B4AA648
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379240AbiBEDkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiBEDkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:40:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE61C061346;
        Fri,  4 Feb 2022 19:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3295D60FC0;
        Sat,  5 Feb 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F94C340E8;
        Sat,  5 Feb 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644032414;
        bh=DeIK05nMZdtUO3RAH+fW8Eb1bl3owcR36z1tTBSsvuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ttfKPDXvIVa/PftWt2GkyO4dJJp9mRW7IlstUPHvobQ/5z5I8V34n0NxW7oOQNaDd
         WnWLDWibiS/Z/mqe9/IK+uL4bOd/36ydsIoXRc0dYGqsu1BA+4saMMoJ/d8P2kfP/A
         7cRmcGAOX4FkukUEa//HswpBc/U9Y3jlpGpcFyHpfBv6E6u5ObLoUPJ4wp9pl7yXaW
         Q+Lljsb1DlqbDjIIaDHcoLvQW8SF2GakbFp3Vo7q60GlgV5JHHAznfiSH+68FFxF79
         U8VhE31t9f+46WzU+cmnMSvtVH8RWPzdXnTzt8ovv3QDQeQzPE9+TH0VDIudGlKNn4
         1vdyLt0ZwV32g==
Date:   Fri, 4 Feb 2022 19:40:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: sundance: Replace one-element array with
 non-array object
Message-ID: <20220204194013.1204e1b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204232906.GA442985@embeddedor>
References: <20220204232906.GA442985@embeddedor>
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

On Fri, 4 Feb 2022 17:29:06 -0600 Gustavo A. R. Silva wrote:
> It seems this one-element array is not actually being used as an
> array of variable size, so we can just replace it with just a
> non-array object of type struct desc_frag and refactor a bit the
> rest of the code.
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
