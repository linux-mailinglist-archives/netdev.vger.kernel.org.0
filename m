Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01544D5B99
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 07:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345082AbiCKG3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 01:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiCKG3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 01:29:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5694331DE9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:28:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB82B82675
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7F6C340E9;
        Fri, 11 Mar 2022 06:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646980087;
        bh=ynCDeyn0VJU3xU7X1PkaeMf4Aa/SZyuHHOySx4RVSVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AlgrsuQE+3qUtjD15gU6UNo1x+DrdAfiF83LDgXX8hXFDLHPBo7SLEPlZWp50BFQn
         2QlG1T/OpM9pKl0cQQnuAvCFrXAVG5iKNzolNlvvdycrmJsJQDVbMUoNQjF2feZcGW
         X7d0QrH/+mi2q7NUZDv6T7OnjD70m8GZOtSE5/2bRmY6nXpEeYXBvlvohOBw6F+tXB
         AWtBQdEoXm/snRxQhbLz8WQWygSPPU+1odZEI/WCXuhLKsPZRAz7QRdJG6GV0aMkhj
         yFzx6ByAlNOALO9DDqu/KrpB6qfR34h0uivPaGMtT9P8Yf+JNy6jrF8Sf2AYwqLjSm
         xGH9mLxkIwxDw==
Date:   Thu, 10 Mar 2022 22:28:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        <netdev@vger.kernel.org>, <sudheer.mogilappagari@intel.com>,
        <amritha.nambiar@intel.com>, <jiri@nvidia.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 1/2] devlink: Allow parameter
 registration/unregistration during runtime
Message-ID: <20220310222805.7da57c96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YirqTaKPzmKLy6EB@unreal>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
        <20220310231235.2721368-2-anthony.l.nguyen@intel.com>
        <20220310203348.40663525@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YirqTaKPzmKLy6EB@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 08:21:01 +0200 Leon Romanovsky wrote:
> > I'm pretty sure what you're doing is broken. You should probably wait
> > until my patches to allow explicit devlink locking are merged and build
> > on top of that.  
> 
> Yes, it is broken, but I don't see how your devlink locking series will
> help here. IMHO, devlink_params_register() should not be dynamic [1]. 

Quite possible, I can't think of an in-tree use case that may require
adding and removing params.
