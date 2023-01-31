Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF1F68232C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjAaEMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAaEMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:12:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF66E20681
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:12:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 000E0B81984
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D565C433EF;
        Tue, 31 Jan 2023 04:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675138346;
        bh=9Tp3auadVLKqTHbe8b0liiSWF2iOu7ArVm0gQGXxHZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BqInk0FabHeMBNQddAdaSimknfwi63VelulxPcib+e0TR20k04ji64KgQmWJCZEPD
         BPpsV3a/nzBe1NlfA6mGRSlp7P+ls6LsFNvboykA+yFuRsSlN3MMI2o2Ww7+u5RrSW
         Zi0aOPNaFBBHWYBSG0/g9nHlvK1npq69EhpTOTH3kUCYlbdrLPZvGWq1NNGxMh+A+E
         pFT13/UweVhtwpbZqRyGTHv52pWADqrkkyM9b6pZIcGv3UL7eZV9j6DZUjdaMiQ0a1
         ZVt1xrUf7kGBKF76Kq7apxnRAoW0qlYao8MhDuB25+3gFUwgW3wKhORXSGdvpk/O4W
         b+VgqckuhsoHQ==
Date:   Mon, 30 Jan 2023 20:12:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <20230130201224.435a4b5e@kernel.org>
In-Reply-To: <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
        <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
        <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
        <63d6069f31bab_2c3eb20844@john.notmuch>
        <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
        <63d747d91add9_3367c208f1@john.notmuch>
        <Y9eYNsklxkm8CkyP@nanopsycho>
        <87pmawxny5.fsf@toke.dk>
        <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
        <878rhkx8bd.fsf@toke.dk>
        <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
        <87wn53wz77.fsf@toke.dk>
        <63d8325819298_3985f20824@john.notmuch>
        <87leljwwg7.fsf@toke.dk>
        <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
        <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
        <63d85b9191319_3d8642086a@john.notmuch>
        <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
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

On Mon, 30 Jan 2023 19:26:05 -0500 Jamal Hadi Salim wrote:
> > Didn't see this as it was top posted but, the answer is you don't program
> > hardware the ebpf when your underlying target is a MAT.
> >
> > Use devlink for the runtime programming as well, its there to program
> > hardware. This "Devlink is NOT for the runtime programming" is
> > just an artificate of the design here which I disagree with and it feels
> > like many other folks also disagree.
> 
> We are going to need strong justification to use devlink for
> programming the binary interface to begin with

We may disagree on direction, but we should agree status quo / reality.

What John described is what we suggested to Intel to do (2+ years ago),
and what is already implemented upstream. Grep for DDP.

IIRC my opinion back then was that unless kernel has any use for
whatever the configuration exposes - we should stay out of it.

> - see the driver models discussion. 
> 
> And let me get this clear: you are suggesting we
> use it for runtime and redo all that tc ndo and associated infra?
