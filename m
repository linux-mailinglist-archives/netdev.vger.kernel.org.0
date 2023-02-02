Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC8F6887BB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjBBTqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBTqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:46:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B232D53;
        Thu,  2 Feb 2023 11:46:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D3261CC7;
        Thu,  2 Feb 2023 19:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241E4C433D2;
        Thu,  2 Feb 2023 19:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675367182;
        bh=Cl+ZB49K+wR5GQHPN3c0zVbPF7vb5FMRvpQuIw92MqA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m4TXHJ0RvwqX24zEyBFmZ6wwAoKizleLYo7T6lfCEcO7puu0Ye3p+3IBnc2aPKj34
         7GUByvhd4xnFWJXOfLcLodbKwPs6e1cnL7Mq69M6IhQVR4fcgmOfIQIDPoCOTgoTLj
         8eaVnO0tqcrOhnxg3W5V/aUGRpkK5IZW8lBL9DtQAseGOzpVb9l3qJsSG1QM4r9sFe
         VaPXYSVpneRtxhAOZW3G0lzJe2VwPg6rESCIU+ntLlpCzX8gTcuQAzHIjUvj/FSdgg
         rxQ+UwpKiQ1/NSesTcL757k2t5x75sOJGEHCz3vofwGRv7kgQJ9+w7ao9+S2i8Q05B
         VjDz1AsLJ/oHg==
Date:   Thu, 2 Feb 2023 11:46:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 7/7] devlink: Move devlink dev selftest code to
 dev
Message-ID: <20230202114621.3f32dae1@kernel.org>
In-Reply-To: <52392558-f79e-5980-4f10-47f111d69fc0@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
        <1675349226-284034-8-git-send-email-moshe@nvidia.com>
        <20230202101712.15a0169d@kernel.org>
        <52392558-f79e-5980-4f10-47f111d69fc0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 21:33:52 +0200 Moshe Shemesh wrote:
> On 02/02/2023 20:17, Jakub Kicinski wrote:
> > On Thu, 2 Feb 2023 16:47:06 +0200 Moshe Shemesh wrote:  
> >> Move devlink dev selftest callbacks and related code from leftover.c to
> >> file dev.c. No functional change in this patch.  
> > selftest I'd put in its own file. We don't want every command which
> > doesn't have a specific sub-object to end up in dev.c, right?
> > At least that was my initial thinking. I don't see any dependencies
> > between the selftest code and the rest of the dev code either.
> > WDYT?  
> 
> I thought as it is devlink dev selftest, the sub-object is dev. 
> Otherwise, what should be the rule here ?
> 
> How do we decide if it should get its own file ?

My thinking was that it should be much easier for newcomers to grok
"what does it take to implement a devlink command" if most of the
subcommands where in their own files, like in ethtool.

The implementation could have as well made selftest a subobject.
But I don't feel strongly, if noone agrees we can apply as is and 
see if dev.c does indeed start to grow out of proportion.
