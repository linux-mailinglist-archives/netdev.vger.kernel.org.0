Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D18E683973
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjAaWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjAaWhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:37:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0943755299
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545C7616FD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 22:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB9FC433D2;
        Tue, 31 Jan 2023 22:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675204584;
        bh=37fS1gAIHcQvpOlYCTDcAngslBFREIEnHUHiUxOynKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tsZy9kgDJBW46UyOrDUIjXO6taHh4yOh4MfK9z1Dwl/B94zXXNcQzZl3X7WBmmVty
         CDIpKpwjtdSdV+qbSDguh3t9xLAENlBoZZHumBtB49mUmE5GC6+y0MvaOFhH51xkhu
         G86DE7xCNoKMa5p3T/pUzKZl3VXLR9nM6kcWOq0GSBOWhHD8x9UjJ6HD+vpcz5QC33
         4GpRojzTLIR96PPtTeAYfwMxM3Ey7iDLB+Ji2BA17wGfj1U5Tf2TaZ9Mb0ivB5HpgU
         ITbEMo1FkHFkIR0j58cj3FHWGngnDP/1u53a4r+VknP9wubEJWQxfQ52Jq0JOCHaye
         J+pMoR0JDBmUQ==
Date:   Tue, 31 Jan 2023 14:36:23 -0800
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
Message-ID: <20230131143623.738f232e@kernel.org>
In-Reply-To: <CAM0EoMnKk9=WFm7ZtPbHDRc6_J7Xw8WR3TG2_Em4ucJ6nCNJOw@mail.gmail.com>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
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
        <20230130201224.435a4b5e@kernel.org>
        <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
        <CAM0EoMmPbdZD7ZNn2UWKQWnWTnAnnWhdSQtq05PvejAz0Jfx9w@mail.gmail.com>
        <20230131111020.2821ea17@kernel.org>
        <CAM0EoMnKk9=WFm7ZtPbHDRc6_J7Xw8WR3TG2_Em4ucJ6nCNJOw@mail.gmail.com>
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

On Tue, 31 Jan 2023 17:32:52 -0500 Jamal Hadi Salim wrote:
> > > Sorry didnt finish my thought here, wanted to say: The loading of the
> > > P4 binary over devlink drew (to some people) suspicion it is going to
> > > be used for loading kernel bypass.  
> >
> > The only practical use case I heard was the IPU. Worrying about devlink
> > programming being a bypass on an IPU is like rearranging chairs on the
> > Titanic.  
> 
> BTW, I do believe FNICs are heading in that direction as well.
> I didnt quiet follow the titanic chairs analogy, can you elaborate on
> that statement?

https://en.wiktionary.org/wiki/rearrange_the_deck_chairs_on_the_Titanic
