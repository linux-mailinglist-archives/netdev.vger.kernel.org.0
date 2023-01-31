Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE703682A79
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjAaK2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjAaK2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:28:06 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411A244A8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:28:05 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e15so17463758ybn.10
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MFt+xVAWwlG/IJX5YhnruoOMETUc+JmyEGQdjhNEOj4=;
        b=U51YlhmJF4sM9BUDKN1Q/ROqVJaOzhKCzjp1nU7L3wwqRFaGMO3jGwNnhyr+Wcw0hM
         U68jRCGwND2FNOztJM7DFnreApZG6vUCcJPosVxkG/e64oMo1mWFlfhCsG3PHdaQSK1t
         VolokaF49ZH1gqZFCvj18gHlDcTTOzQX+chbmkR+Rf5kMq2XWkgLvebKVyf7NUgNa05K
         a7nsK+eBa5uKUnwwy5EwNJDdamVGLmDyt0iDUCT6wEmfdnPSpRMJPcQqPy4tOQHdcK7L
         H0mg0XeEjGHrHZUArD9Q/v5ZpbYvIETpI/xxKA3rWqMZcGR2NtM6RD0hlWzEXgVUF2Mg
         EMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFt+xVAWwlG/IJX5YhnruoOMETUc+JmyEGQdjhNEOj4=;
        b=4cDOo6MOfY4DuwkvojMtGUARPqSatJ3RWqW6E1S3Dn1Yg+z20CgDy5fOZJo4wrK1VV
         pL1HuVqsZvOp/zezItfrSWTbejKlDXfskUwSe6gzIeAQrDVDPcloK/eZHH6iKASqnIAA
         YIkMBddd6Jgj3G7avuCju8kp0R8duXzFRUbxtH3mhJEZ06MNyToM8I/wo8a4S3ParVsX
         Af1DSS7av+ZLPGHd7PjoKdK4Ay9J3UHTl3wNSGFWB6GNmCxQMQFDRhv7cSsLLH94/fxv
         CYY5Sf/9ppQIWhGwJoTtKsJ2Ql8aRuzNNwNVQpDXC7feheU5TtvcJxNamGIkAmWjrqay
         w7WA==
X-Gm-Message-State: AFqh2kqETqn0eUQIyj5UTnus1YxFkC/ISfxqoqVwRo2Ydn+QV6JDOREU
        0BFJljm3wcyqma+ajyFCZyg4lSNkD2LeyiHaSmEtaQ==
X-Google-Smtp-Source: AMrXdXt1R5ZWeTEbv8XBe8j5b0phEHRXXwOepUixejFkQ5O8sVztvioV2CRQ7EOt6q/tpfpQ6fYVKPzQyQZMe1XesT0=
X-Received: by 2002:a25:4dc6:0:b0:7e0:8c3a:15da with SMTP id
 a189-20020a254dc6000000b007e08c3a15damr4761048ybb.204.1675160884466; Tue, 31
 Jan 2023 02:28:04 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
 <63d85b9191319_3d8642086a@john.notmuch> <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
 <20230130201224.435a4b5e@kernel.org>
In-Reply-To: <20230130201224.435a4b5e@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 31 Jan 2023 05:27:53 -0500
Message-ID: <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 30 Jan 2023 19:26:05 -0500 Jamal Hadi Salim wrote:
> > > Didn't see this as it was top posted but, the answer is you don't program
> > > hardware the ebpf when your underlying target is a MAT.
> > >
> > > Use devlink for the runtime programming as well, its there to program
> > > hardware. This "Devlink is NOT for the runtime programming" is
> > > just an artificate of the design here which I disagree with and it feels
> > > like many other folks also disagree.
> >
> > We are going to need strong justification to use devlink for
> > programming the binary interface to begin with
>
> We may disagree on direction, but we should agree status quo / reality.
>
> What John described is what we suggested to Intel to do (2+ years ago),
> and what is already implemented upstream. Grep for DDP.
>

I went back and looked at the email threads - I hope i got the right
one from 2020.

Note, there are two paths in P4TC:
DDP loading via devlink is equivalent to loading the P4 binary for the hardware.
That is one of the 3 (and currently most popular) driver interfaces
suggested. Some of that drew
Second is runtime which is via standard TC. John's proposal is
equivalent to suggesting moving the flower interface Devlink. That is
not the same as loading the config.

> IIRC my opinion back then was that unless kernel has any use for
> whatever the configuration exposes - we should stay out of it.

It does for runtime and the tc infra already takes care of that. The
cover letter says:

"...one can be more explicit and specify "skip_sw" or "skip_hw" to either
offload the entry (if a NIC or switch driver is capable) or make it purely run
entirely in the kernel or in a cooperative mode between kernel and user space."

cheers,
jamal
