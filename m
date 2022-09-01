Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60FC5A8B95
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiIACqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbiIACqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:46:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D924115C785
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:46:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BFAAB823F1
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C435C433D6;
        Thu,  1 Sep 2022 02:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662000372;
        bh=jAgq4+Lrxe8TLYJmCd9EXdtzd5pL0BAHrt1CtL5FQbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R4Iw3oLUfDWvObFe14qO5xnzckbJqf/loMjZtGiGLlx5FZ/Om5LU9i5tSZChhD7Vk
         IcI4hTreXFoOIaLp/+hO1/Dw9qtV2yC3SVu9nFLxF0Sib2KyszDwbE1+9fINZnp8OK
         lsInfECB41U/ACDw5IBpHHaOq+DFR6XAyBT1XE1FXJEfD3+I/Ed3Fswj56+73gOdU5
         lijofVyPdvwwMx0UIfoFUpCKoH86TG3Qp300+54lIP+wfl8ETqcTUUQgDm72+MDok3
         LYsJdF4/2wuyt5S8GJDvB50O49iXQjka5SizHU890CX9YBBhSYPhyhJg9EH0lnbS/X
         G7AS2LKmqvn7g==
Date:   Wed, 31 Aug 2022 19:46:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     netdev@vger.kernel.org, alexander.h.duyck@intel.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com
Subject: Re: [net-next PATCH 0/3] Extend action skbedit to RX queue mapping
Message-ID: <20220831194611.4113660a@kernel.org>
In-Reply-To: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
References: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 02:28:39 -0700 Amritha Nambiar wrote:
> Based on the discussion on
> https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> the following series extends skbedit tc action to RX queue mapping.
> Currently, skbedit action in tc allows overriding of transmit queue.
> Extending this ability of skedit action supports the selection of receive
> queue for incoming packets. Offloading this action is added for receive
> side. Enabled ice driver to offload this type of filter into the
> hardware for accepting packets to the device's receive queue.

Thinking about this again - is redirecting to a queue really the most
useful API to expose? Wouldn't users want to redirect to a set of
queues, i.e. RSS context?

Or in your case the redirect to a set of queues is done by assigning
a class?

Either way we should start documenting things, so please find (/create)
some place under Documentation/networking where we can make notes for
posterity.
