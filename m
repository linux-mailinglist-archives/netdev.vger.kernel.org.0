Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1163E86D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLADpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLADpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:45:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9054A9076A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 19:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A10AB81D17
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C54C433C1;
        Thu,  1 Dec 2022 03:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669866307;
        bh=o5sBlsB/l7hjLFxDG2yD3RquRL+oFmftY6L8rt/3IeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTH/mbVvrC1ueKELF734XZqauOa8StWinC3jkHWGZ4QnbMHJaSn3nJclFIpvv/ti9
         K44AAsqI1eT9pg9jZeHaiAGkX4dZA8L6hooPDth/pmgw5ICA6XejmZ8DBjNoPlYcuz
         ZxkFFU7tUAKfdyg3CphfDoorQo8PH2Ehi59uRYa/mg2YRBufkb8ZdncfPbxiX0/JC/
         bGB8LNOWwXQ01TSKg7FudRmRfmiM/HoLPlZBMB+1ota1Om9b2AvV16RR6DSlmlNW1J
         KwHrhVEleRGd3v1gONp1b4tQD4jk0mNYhFvoJ8ZNJp0qQi23iFAASKiZfmp5X0Z4Uf
         xeU4CSY/B0gCg==
Date:   Wed, 30 Nov 2022 19:45:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221130194506.642031db@kernel.org>
In-Reply-To: <b839c112-df1f-a36a-0d89-39b336956492@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
        <20221128102828.09ed497a@kernel.org>
        <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
        <20221128153719.2b6102cc@kernel.org>
        <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
        <20221128165522.62dcd7be@kernel.org>
        <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
        <20221128175448.3723f5ee@kernel.org>
        <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
        <20221129180250.3320da56@kernel.org>
        <b839c112-df1f-a36a-0d89-39b336956492@amd.com>
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

On Wed, 30 Nov 2022 16:12:23 -0800 Shannon Nelson wrote:
> > Enough back and forth. I'm not going to come up with a special model
> > just for you when a model already exists, and you present no technical
> > argument against it.
> > 
> > I am against merging your code, if you want to override find other
> > vendors and senior upstream reviewers who will side with you.  
> 
> We're not asking for a special model, just to use the PF interface to 
> configure VFs as has been the practice in the past.

It simply does not compute for me. You're exposing a very advanced vDPA
interface, and yet you say you don't need any network configuration
beyond what Niantic had.

There are no upstream-minded users of IPUs, if it was up to me I'd flat
out ban them from the kernel.

> Anyway, this feature can wait and we can work out alternatives later. 
> For now, we'll drop the netdev portion from the driver and rework the 
> other bits as discussed in other messages.  I'll likely have a v2 for 
> comments sometime next week.

Seems reasonable, if it doesn't live in networking and doesn't use any
networking APIs it won't matter to me.
