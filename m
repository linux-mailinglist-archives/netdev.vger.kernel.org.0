Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7EB584968
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 03:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiG2Bpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 21:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiG2Bpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 21:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E899733A18
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 18:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929E6B8265E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A8C433C1;
        Fri, 29 Jul 2022 01:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659059128;
        bh=6dPPkIGkS6fNABa9IfPChBLUah2P6PV/ApuRtN5UFPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdElER1SlEexIR+ntpO/ySSQgVzAblwP+9e+bpt/qyplSCyQrIlRg72xdF4zVJApO
         oEwrv5MEmy2e2lrhYnIamoavJt8ZrVw6jPBrdkT+RENIiF9dmeT8Si8FWXPp4bA8CZ
         6N23yPfhWg+1HZ81L95fMhLleHoECxp7pZjQVz23Gsr3zBdMvCi4184G6neJ7aYvOi
         VhVTgJxPgAE5IYjlZGCNwM7y2R0SGtTf7zL5pQLWgN20fd5J4NwuVejxy9/whK0d31
         dEjROB/vD2ELGG+C+cU2xlViHpnmg/GmY+PCs8diql5tf8O35BrFYGziklV8++VKM3
         tKSWyLW5HgIxQ==
Date:   Thu, 28 Jul 2022 18:45:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
Message-ID: <20220728184527.3f3dd520@kernel.org>
In-Reply-To: <5a4d22f2-e315-b6f4-5fb5-31134960c430@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
        <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
        <20220727201034.3a9d7c64@kernel.org>
        <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
        <20220728092008.2117846e@kernel.org>
        <8bfec647-1516-c738-5977-059448e35619@gmail.com>
        <20220728113231.26fdfab0@kernel.org>
        <bfc03b98-53ce-077a-4627-6c8d51a29e08@gmail.com>
        <20220728122745.4cf0f860@kernel.org>
        <5a4d22f2-e315-b6f4-5fb5-31134960c430@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 21:23:23 +0100 Edward Cree wrote:
> Sadly I was too busy with EF100 bring-up, and na=C3=AFvely assumed that I
>  could safely ignore devlink port stuff as it was so obviously going
>  to be a classic Mellanox design: tasteless, overweight, and not
>  cleanly mappable onto any other vendor.  Which seems to have been
>  true but they've managed to make it the standard anyway by virtue
>  of being there first, as usual :'(
> (Yeah, I probably shouldn't publicly say things like that about
>  another vendor's devs.  But I'm getting frustrated at this recurring
>  pattern.)

I spend an unhealthy amount of time thinking about the problem=20
of vendors not paying attention when new uAPIs are forged.
Happy to try things.

> Devlink port function *would* be useful for administering functions
>  that don't have a representor.  I just can't see any good reason
>  why such things should ever exist.

The SmartNIC/DPU/IPU/isolated hv+IO CPU can expose storage functions
to the peer. nVidia is working on extending the devlink rate limit API
to cover such cases.
