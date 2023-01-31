Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2F968361E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjAaTK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjAaTKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3D577EA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D270A616CD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396AFC433EF;
        Tue, 31 Jan 2023 19:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675192223;
        bh=/Fefv1OFyYiRPoUmOEmaegBxt6COX4bNc4H2IrzDRt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QbrHm9ZIxbXd3qLRXE+3DIdQ1j7FdYISBHkctVS9VFIV0IVkk21e/DJSE2uKh07K4
         DpZxBIy7kIqjN4hXJW1koP4hUZ4Tx5MiVHOWxNar+8hH8VYtxdsoJzyMLKq/5YQpPd
         sEm+nihmVnXHL9MZn+9PHYx/qH6x2UgfOGR45l6hGc3sNElj49b9CSS2rxBhcsU1ym
         AYklDvZgndQuKzT7giNDOz4PajW5yEt12YECHXr1CWg54CBfG3FU165sSc12R0HyBV
         p7C1Oi6GJkLgUtNL/0MAdHXKeSRiTFXSnVPbyvEW9Whe37Ys+XQEg4aCBdKVJCaIH0
         1ug/5xSkMXvrw==
Date:   Tue, 31 Jan 2023 11:10:20 -0800
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
Message-ID: <20230131111020.2821ea17@kernel.org>
In-Reply-To: <CAM0EoMmPbdZD7ZNn2UWKQWnWTnAnnWhdSQtq05PvejAz0Jfx9w@mail.gmail.com>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
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
        <20230130201224.435a4b5e@kernel.org>
        <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
        <CAM0EoMmPbdZD7ZNn2UWKQWnWTnAnnWhdSQtq05PvejAz0Jfx9w@mail.gmail.com>
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

On Tue, 31 Jan 2023 05:30:10 -0500 Jamal Hadi Salim wrote:
> > Note, there are two paths in P4TC:
> > DDP loading via devlink is equivalent to loading the P4 binary for the hardware.
> > That is one of the 3 (and currently most popular) driver interfaces
> > suggested. Some of that drew  
> 
> Sorry didnt finish my thought here, wanted to say: The loading of the
> P4 binary over devlink drew (to some people) suspicion it is going to
> be used for loading kernel bypass.

The only practical use case I heard was the IPU. Worrying about devlink
programming being a bypass on an IPU is like rearranging chairs on the
Titanic.
