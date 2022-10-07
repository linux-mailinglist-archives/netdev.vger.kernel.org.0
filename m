Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B315F723E
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 02:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJGA1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 20:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiJGA07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 20:26:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E619E699
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 17:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F4C0B821DC
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 00:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28CFC433C1;
        Fri,  7 Oct 2022 00:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665102415;
        bh=OUhjSABgL+NIB0A6BmjMw4fIEmcLJpXD5df7gOTaIbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PWkIZFfXNMPLvooJmCy7s2B+xTqPjSRJmbdq3D3zGkttDyJu4HrWlnmB0ieZfSSae
         0WcvpbgL7z+VLVMvtizwkc8L3T1zgKR3W3lHUZ2zBF6M0VtSbD7zXkdrsGR5qhJual
         CBRZ5WGE9vdWEHdo5h0puO6pJXIfRt6nuodU9ixMSOxoFr5G5UUSEwg/5mZnsd/m+X
         44DlcgLtX9sUuYkS92xfZ2f52jN+GSEZZTOkszYV7m6Dou3bG9N0tqU/XnvhilWRQz
         FtTsS5DOF6rScLpDvS5GaC278iM2zdwnF+HXzASnVtu2aT2rThRLrh+vpmCQMgDBq6
         FQTsPTRmXVXJA==
Date:   Thu, 6 Oct 2022 17:26:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, rrangoju@amd.com
Subject: Re: [PATCH net 1/3] amd-xgbe: Yellow carp devices do not need rrc
Message-ID: <20221006172654.45372b3b@kernel.org>
In-Reply-To: <7a1b3750-1b3d-a9b9-ebba-3258c90fff7e@amd.com>
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
        <20221006135440.3680563-2-Raju.Rangoju@amd.com>
        <7a1b3750-1b3d-a9b9-ebba-3258c90fff7e@amd.com>
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

On Thu, 6 Oct 2022 09:32:34 -0500 Tom Lendacky wrote:
> On 10/6/22 08:54, Raju Rangoju wrote:
> > Yellow carp devices disables the CDR workaround path,
> > receiver reset cycle is not needed in such cases.
> > Hence, avoid issuing rrc on Yellow carp platforms.

Not entirely clear why this is a Fix, TBH.

What harm comes from doing the reset? You need to describe 
the user-observable harm if the patch is a fix.

> > Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")  
> 
> That is the wrong Fixes: tag. Yellow Carp support was added with commit
> 
> dbb6c58b5a61 ("net: amd-xgbe: Add Support for Yellow Carp Ethernet device")
> 
> However, the changes to allow updating the version data were made with
> 
> 6f60ecf233f9 ("net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices")
> 
> so that is the tag most likely needed should you want this to be able to
> go to stable.

FWIW the Fixes tag should point to the commit where the bug is
introduced, not where the patch will apply. The automation will
figure out where it applies.

> With a change to the Fixes: tag:
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

These devices are only present on SoCs? Changing global data during
probe looks odd.
