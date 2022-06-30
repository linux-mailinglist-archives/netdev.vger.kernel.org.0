Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6F562185
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiF3Rwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbiF3RwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:52:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D712494F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2A80B82CD9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 17:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A27C34115;
        Thu, 30 Jun 2022 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656611540;
        bh=NFrVP9CssCeZllk/GLg2XqLrOstvy6FRjuR3h2lIm5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l8XZUO2OfdPMx3Co7KHotjnSMyXF5xMpj4PYQ3NTgDvetJ3FSHfSANh4EETmJP/fu
         MzgXiNdxX2F5xmotxcvPTd/YsxqT+YnyqOEqyvuX4l+OnDblcMBJUzDlEh31Cj3+fy
         Q1Ym5TkSXgsFj+/l3c3zmoGcRLI6IQgBdcdvY13rOlGcNuV07L3jBGEB2LyXfBEtxA
         K+MASK+L+GYeAwrIr7/GGEbTzBXMEBiaMDXiDbv5YDsEpqFss5PVt7ZPlLNDvqkU5y
         hG2j7IJjvSCFIdwPN/8gkbijKsS2jPlXj+e5eANwHrCsRrR0JECRRD9T10M+rHu6di
         SKyW/S8CFkZ3w==
Date:   Thu, 30 Jun 2022 10:52:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rick Lindsley <ricklind@us.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        nnac123@linux.ibm.com, mmc@linux.ibm.com
Subject: Re: [PATCH]     ibmvnic: Properly dispose of all skbs during a
 failover.
Message-ID: <20220630105218.7f23f31c@kernel.org>
In-Reply-To: <20220630000317.2509347-1-ricklind@us.ibm.com>
References: <20220630000317.2509347-1-ricklind@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 17:03:17 -0700 Rick Lindsley wrote:
>     During a reset, there may have been transmits in flight that are no
>     longer valid and cannot be fulfilled.  Resetting and clearing the
>     queues is insufficient; each skb also needs to be explicitly freed
>     so that upper levels are not left waiting for confirmation of a
>     transmit that will never happen.  If this happens frequently enough,
>     the apparent backlog will cause TCP to begin "congestion control"
>     unnecessarily, culminating in permanently decreased throughput.
> 
>     This was noted during testing of heavy data transfers in
>     conjunction with multiple consecutive device failovers.

The indentation in the patch itself is unnecessary, git adds it when
formatting the output of git log (I'm guessing that's the reason you
went this way). Note that the same goes for the subject which looks
padded with spaces from the left.

Please add a Fixes tag pointing at a commit which introduced the
behavior (initial git commit if it's always been there), and repost 
with [PATCH net v2] in the subject.

Please keep the review tags you already received when reposting.
