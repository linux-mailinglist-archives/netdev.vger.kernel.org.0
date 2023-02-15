Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFA8697BA6
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbjBOMW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbjBOMWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3FA36446;
        Wed, 15 Feb 2023 04:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D230B8217D;
        Wed, 15 Feb 2023 12:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AACC433D2;
        Wed, 15 Feb 2023 12:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676463741;
        bh=GeSCjTFqgMCEWnnu2zVVsYJTBX5zY7VucmFUJcaJF8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JtBEjKhBFsb8y2w9HxMp223w9f5YI2nxNwvgAuh1RY9Z6zEen7ehWAC0QNuKFjyXi
         JvBH4Dl/3cv++thj0+lAptse19lPCQZBQkI5iBV9upwreE5KO4Mor7Z6gbKMRQ+/v3
         whrxdC9bx1Ql85Dh3pXm+ktnupR2wWPH13dvWw8KC9Su75zrPEpvZ1o5bHjb52xRMK
         HOh6LdPQ8t/qlFbpD2fxLLz+nXNl+BDlGLoaNAo/CkL7L03YrOQ/I5UhKDEJ8FrgMN
         wMuy9ILMsVORtXlel1gsuaKvPStR8bRwTDDwfbpgCcNaxdN9hZQ6DWfZnwio7L3Hpy
         Evq4ud7majwsw==
Date:   Wed, 15 Feb 2023 14:22:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y+zOeGYK0EctinF1@unreal>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
 <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
 <Y+s6vrDLkpLRwtx3@unreal>
 <ef18677a-74d0-87a7-5659-637e63714b15@gmail.com>
 <cac3fa89-50a3-6de0-796c-a215400f3710@intel.com>
 <DM6PR12MB4202CDD780F886E718159A8CC1A39@DM6PR12MB4202.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB4202CDD780F886E718159A8CC1A39@DM6PR12MB4202.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 08:43:21AM +0000, Lucero Palau, Alejandro wrote:
> 
> On 2/14/23 16:56, Alexander Lobakin wrote:
> > From: Edward Cree <ecree.xilinx@gmail.com>
> > Date: Tue, 14 Feb 2023 15:28:24 +0000
> >
> >> On 14/02/2023 07:39, Leon Romanovsky wrote:
> >>> On Mon, Feb 13, 2023 at 06:34:22PM +0000, alejandro.lucero-palau@amd.com wrote:
> >>>> +#ifdef CONFIG_RTC_LIB
> >>>> +	u64 tstamp;
> >>>> +#endif
> >>> If you are going to resubmit the series.
> >>>
> >>> Documentation/process/coding-style.rst
> >>>    1140 21) Conditional Compilation
> >>>    1141 ---------------------------
> >>> ....
> >>>    1156 If you have a function or variable which may potentially go unused in a
> >>>    1157 particular configuration, and the compiler would warn about its definition
> >>>    1158 going unused, mark the definition as __maybe_unused rather than wrapping it in
> >>>    1159 a preprocessor conditional.  (However, if a function or variable *always* goes
> >>>    1160 unused, delete it.)
> >>>
> >>> Thanks
> >> FWIW, the existing code in sfc all uses the preprocessor
> >>   conditional approach; maybe it's better to be consistent
> >>   within the driver?
> >>
> > When it comes to "consistency vs start doing it right" thing, I always
> > go for the latter. This "we'll fix it all one day" moment often tends to
> > never happen and it's applicable to any vendor or subsys. Stop doing
> > things the discouraged way often is a good (and sometimes the only) start.
> 
> 
> It is not clear to me what you prefer, if fixing this now or leaving it 
> and fixing it later.

He asked to fix.

Thanks

> 
> The first sentence in your comment suggest the latter to me. The rest of 
> the comment suggests the fix it now.
> 
> Anyway, patchwork says changes requested, so I'll send v8.
> 
> Thanks
> 
> > Thanks,
> > Olek
