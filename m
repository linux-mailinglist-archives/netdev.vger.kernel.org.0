Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D676885AF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjBBRoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjBBRoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:44:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB33A24C;
        Thu,  2 Feb 2023 09:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9A11B826AB;
        Thu,  2 Feb 2023 17:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4AFC433EF;
        Thu,  2 Feb 2023 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675359841;
        bh=bTHe0fthr5z/2TZ1dF0QoAeyJtSX1h6WBuxBggSfbIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V+yFUjFJxQXKnT70M63SL579RjE23M5Z/uqS3uBPvLITMpAxPaFx7j2wZgbUFkb7Q
         swIOXs/Yjn04Tp8+wIK/BR07ohSLbSF+FPNsxK7DXqekDZjTSMI5r3NFoFKpgVqWvF
         2cQqnuJxZQMHox2y4y7a3um0bjSSdlu44aWE9w87XlXedmBMJawiclkmPdrlXdR2Fi
         AZsUdn9nZzuF/K9IAG20haIBQkqdB0LC9O2PSeO6kmvK0QRhTsaE/fJ/rOlulWgOyB
         6WcoCYO07RahW45ZN1HJYWNSGNaoRmk2iI3C4E0Mlj/Pdch1vlM2e/oW3YEvwRZezn
         BYYN2f5gdikBA==
Date:   Thu, 2 Feb 2023 09:43:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <20230202094359.7a79ee6d@kernel.org>
In-Reply-To: <Y9uA8Vk430k+ezTt@gmail.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
        <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
        <Y9k7Ap4Irby7vnWg@nanopsycho>
        <44b02ac4-0f64-beb3-3af0-6b628e839620@amd.com>
        <Y9or1SWlasbNIJpp@nanopsycho>
        <20230201110148.0ddd3a0b@kernel.org>
        <Y9uA8Vk430k+ezTt@gmail.com>
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

On Thu, 2 Feb 2023 09:24:56 +0000 Martin Habets wrote:
> > FWIW I'd just take the devl lock in the main driver code.
> > devlink should be viewed as a layer between bus and driver rather 
> > than as another subsystem the driver registers with. Otherwise reloads
> > and port creation get awkward.  
> 
> I see it a bit differently. For me devlink is another subsystem, it even is
> an optional subsystem.
> At the moment we don't support devlink port for VFs. If needed we'll add that
> at some point, but likely only for newer NICs.

That's fine. I believe the structure I suggest is the easiest one 
to get right, but it's not a hard requirement.

> Do you think vDPA and RDMA devices will ever register with devlink?

Good question, I can't speak for the entire project but personally 
I have little interest in interfaces to proprietary world, 
so I hope not.

> At the moment I don't see devlink port ever applying to our older hardware,
> like our sfn8000 or X2 cards. I do think devlink info and other commands
> could apply more generally.
> 
> There definitely is a need to evolve to another layer between bus and
> devices, and devlink can be used to administer that. But that does not
> imply the reverse, that all devices register as devlink devices.
> For security we would want to limit some operations (such as port creation)
> to specific devlink instance(s). For example, normally we would not want a
> tennant VM to flash new firmware that applies to the whole NIC.
> I hope this makes sense.

