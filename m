Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C60A5EF9E8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiI2QNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiI2QNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:13:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7A41D66FD
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:13:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 023E861A3F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 16:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2A2C433D6;
        Thu, 29 Sep 2022 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664467983;
        bh=drRKiLAPoaGIh4dOq8I2mgRFozPK4sMbUP1m09g6MH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TVDAmCXBnJuCQZGVKyYkX5vOPW5rm8mo4Jm/3SJDL0pbwLF0AgD2eKC0UTBPphw+c
         7Lpm/4yRo5RIAriV5jGn6I+4CSLmY7irWoatsnln6jQPd1YbyDraekJXFMlAIreT8L
         9rHkvqNv8rDvjueawtDBK8DALiw18TXHHMNcjcBj2I/gI5qtNRlrxlBk8lXvpY3zG9
         LsHwYC0zbHSib1IC6MEZCH28zWJCfJW+kfNYMNPu95X7sB+3vCnDx34yWYs/kD8hzj
         s7UgcO95LfKrmzJm9cS99behS9uNE0IX29mAbSePMsPCfAMvLJNznp9v77LJZj9rtD
         N3bj+TUHypF6w==
Date:   Thu, 29 Sep 2022 09:13:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <sgoutham@marvell.com>,
        <naveenm@marvell.com>, Geetha sowjanya <gakula@marvell.com>,
        Vamsi Attunuru <vattunuru@marvell.com>
Subject: Re: [net-next PATCH v2 6/8] octeontx2-af: cn10k: mcs: Handle MCS
 block interrupts
Message-ID: <20220929091302.13d3248e@kernel.org>
In-Reply-To: <1664337490-20231-7-git-send-email-sbhatta@marvell.com>
References: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
        <1664337490-20231-7-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 09:28:08 +0530 Subbaraya Sundeep wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> Hardware triggers an interrupt for events like PN wrap to zero,
> PN crosses set threshold. This interrupt is received
> by the MCS_AF. MCS AF then finds the PF/VF to which SA is mapped
> and notifies them using mcs_intr_notify mbox message.
> 
> PF/VF using mcs_intr_cfg mbox can configure the list
> of interrupts for which they want to receive the
> notification from AF.

clang is still upset at a couple of patches here, for instance:

drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c:102:6: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
        if (err)
            ^~~
drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c:87:9: note: initialize the variable 'err' to silence this warning
        int err, pf;
               ^
                = 0
