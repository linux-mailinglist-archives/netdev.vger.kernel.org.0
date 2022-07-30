Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442F45857CE
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 03:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbiG3BlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 21:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3BlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 21:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC8411C30;
        Fri, 29 Jul 2022 18:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0558A61D78;
        Sat, 30 Jul 2022 01:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024A3C433D7;
        Sat, 30 Jul 2022 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659145262;
        bh=tn/1bObisYaqKTsPtjD0sltAOnDgfGtGu8ptNILVe5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WgZK6bKweW/CpYRKAGETW0Wkz+X6HAvYEpPOBKp/0OCzSqK+UzUhxOMUxSzZAF6IU
         0HsnT8OqbEF0y1OgrKoIbio8h/SZI22qGX/TevFqDSI3nZ/V/6edccvQIIMxOUGk0q
         PH16Wv5H3q2W5EO0bK/7qm10HrTpF5Dci+7lQfyUhCEF8UgAQ7SgPnILiIScCsWPln
         sI8uGAO2aS9e0Zauoa2G2k9tsJbHwx9bLJjkz3qwAVWt58bwsgOl8GstpLvLnrYoDH
         iOo1KlSg4aekDZjq95umbL4mYSRoLryahkv6WsQx5PSjO05pcIVuz8BvA7CbVW6U9g
         PkUCRWM3sGIJw==
Date:   Fri, 29 Jul 2022 18:41:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "U'ren, Aaron" <Aaron.U'ren@sony.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between
 5.10 and 5.15
Message-ID: <20220729184101.00364f0b@kernel.org>
In-Reply-To: <DM6PR13MB3098595DDA86DE7103ED3FA0C8999@DM6PR13MB3098.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
        <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
        <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
        <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
        <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
        <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com>
        <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
        <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
        <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info>
        <DM6PR13MB309846DD4673636DF440000EC8BA9@DM6PR13MB3098.namprd13.prod.outlook.com>
        <20220630110443.100f8aa9@kernel.org>
        <d44d3522-ac1f-a1e-ddf6-312c7b25d685@netfilter.org>
        <DM6PR13MB309813DF3769F48E5DE2EB6EC8829@DM6PR13MB3098.namprd13.prod.outlook.com>
        <DM6PR13MB3098595DDA86DE7103ED3FA0C8999@DM6PR13MB3098.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=APOSTROPHE_TOCC,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 20:21:17 +0000 U'ren, Aaron wrote:
> Jozef / Jakub / Thorsten-
> 
> Thanks for all of your help with this issue. I think that we can close this out now.
> 
> After continuing to dig into this problem some more, I eventually figured out that the problem was caused because of how our userspace tooling was interacting with ipset save / restore and the new (ish) initval option that is included in saves / restores.
> 
> Specifically, kube-router runs an ipset save then processes the saved ipset data, messages it a bit based upon the state from the Kubernetes cluster, and then runs that data back through ipset restore. During this time, we create unique temporary sets based upon unique sets of options and then rotate in the new endpoints into the temporary set and then use swap instructions in order to minimize impact to the data path.
> 
> However, because we were only messaging options that were recognized and important to us, initval was left alone and blindly copied into our option strings for new and temporary sets. This caused initval to be used incorrectly (i.e. the same initval ID was used for multiple sets). I'm not 100% sure about all of the consequences of this, but it seems to have objectively caused some performance issues.
> 
> Additionally, since initval is intentionally unique between sets, this caused us to create many more temporary sets for swapping than was actually necessary. This caused obvious performance issues as restores now contained more instructions than they needed to.
> 
> Reverting the commit removed the issue we saw because it removed the portion of the kernel that generated the initvals which caused ipset save to revert to its previous (5.10 and below) functionality. Additionally, applying your patches also had the same impact because while I believed I was updating our userspace ipset tools in tandem, I found that the headers were actually being copied in from an alternate location and were still using the vanilla headers. This meant that while the kernel was generating initval values, the userspace actually recognized it as IPSET_ATTR_GC values which were then unused.
> 
> This was a very long process to come to such a simple recognition about the ipset save / restore format having been changed. I apologize for the noise.

Thanks for working it out and explaining the root cause :)
I'm probably going to get the syntax wrong, but here goes nothing:

#regzbot invalid: user space mis-configuration
