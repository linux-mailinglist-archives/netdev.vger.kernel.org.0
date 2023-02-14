Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5273696EAA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 21:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBNUoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 15:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjBNUoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 15:44:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C925D2BED2
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 12:44:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7847CB81F19
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED153C433EF;
        Tue, 14 Feb 2023 20:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676407474;
        bh=KDuEwSOeR44suihGKrhx5bTDrsJl+4eFw5HHomsFoGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hiokcNktxqT6jk/e+Ncf7WZYeLmb25Glu3JRe+G+ny7c23RDVRoiw0U/HNVL6r9UE
         t/EX63kSoFzAgyVLXekLmzdW9qQZ5gTBk2CSkebln3b82L4LTVFIsI2SDV8qKYbtsH
         k1CTHpm63sKPXsVrhbqAXsi9qAYX+zWj6Ba8pdlgZIIZ8O06w/8bOkvCn1Yz+X+Nu7
         xwlUSgwr4W94uj7Xs/+UgF6mXUvmEwmrIx0kJ/djSJDrhj+vSDsozf94I9RNzZlLvR
         yBd+1itBgNmvXO0Ys87ZakWat7dOXudvo1QxT5QZeSYpqFXNYD7C2UeI/9TT6ONpR7
         taJBovJyVQPzQ==
Date:   Tue, 14 Feb 2023 12:44:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jacob.e.keller@intel.com>,
        <jiri@nvidia.com>, <idosch@idosch.org>
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Message-ID: <20230214124433.29748e23@kernel.org>
In-Reply-To: <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
        <20230210202358.6a2e890b@kernel.org>
        <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
        <20230213164034.406c921d@kernel.org>
        <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
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

On Tue, 14 Feb 2023 08:14:04 -0800 Paul M Stillwell Jr wrote:
> >> I don't know how other companies FW interface works so wouldn't assume
> >> that I could come up with an interface that would work across all devices.  
> > 
> > Let's think about devlink health first.  
> 
> I'm happy to think about it, but as I said I don't see how our FW 
> logging model fits into the paradigm of devlink health. I'm open to 
> suggestions because I may not have thought about this in a way that 
> would fit into devlink health.

Maybe just use ethtool set_dump / get_dump_data then?
That's more of an ad-hoc collection API.
