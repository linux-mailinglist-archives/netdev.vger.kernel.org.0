Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4321B688881
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjBBUrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbjBBUq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:46:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4638684B46
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:46:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBB2A61CDF
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 20:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0621EC433EF;
        Thu,  2 Feb 2023 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675370776;
        bh=036NL2RbCfH1G9yJwe9NEnuki1+SFv2M0dPWU64wVlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T2fqefgUvKBVL/rcMNl34gcCe3y2NKhRMKSVuZki2vlwaLQBF16xtzS5ZcMu3Ada+
         2syiqAfCaJXprpJn5kvJ1A+CCyXVdMtIeb0jwzwXIjzRUsbY1wHlDLX0Ce0UyUM1p9
         gdhfEriCmFB7BOuqbyZTqBHiEiEMx9z+yO57VFhEcsYt9a0r7SpZH+RQpSDq85GalC
         mwMkC6HKUT2iLNnvrOE4tvxlKyHm9Q1JiFFUO6TglCt19oU4dTU8PIzIKXrNUvqskW
         52Fkp2hR9sXFyGVqNYLQdaaWfcUR2hJFv2u7tOqUgdiHbSMPoZFtfpPsc8UB1vD6cI
         QtOaCvj6QXONA==
Date:   Thu, 2 Feb 2023 12:46:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
Subject: Re: [PATCH net 3/6] ionic: add check for NULL t/rxqcqs in reconfig
Message-ID: <20230202124615.1bf1a2f9@kernel.org>
In-Reply-To: <917e57c0-fd37-18a8-a418-c439badb7d41@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
        <20230202013002.34358-4-shannon.nelson@amd.com>
        <20230202100538.6f9a4ea3@kernel.org>
        <917e57c0-fd37-18a8-a418-c439badb7d41@amd.com>
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

On Thu, 2 Feb 2023 12:06:52 -0800 Shannon Nelson wrote:
> On 2/2/23 10:05 AM, Jakub Kicinski wrote:
> > On Wed, 1 Feb 2023 17:29:59 -0800 Shannon Nelson wrote:  
> >> Make sure there are qcqs to clean before trying to swap resources
> >> or clean their interrupt assignments.  
> > 
> > ... Otherwise $what-may-happen
> > 
> > Bug fixes should come with an explanation of what the user-visible
> > misbehavior is  
> 
> I can add some text here and post a v2.
> 
> Would you prefer I repost some of these as net-next rather than net as 
> Leon was suggesting, or keep this patchset together for v2?  I have a 
> couple other larger net-next patches getting ready as well...

I'm not sure what the user impact of the fixes is, but at a glance
splitting this into separate series makes most sense. We merge net 
into net-next every Thu, so if there is a dependency the wait should
not be too long.
