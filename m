Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC535A048C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiHXXTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiHXXTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:19:03 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C476C115;
        Wed, 24 Aug 2022 16:19:02 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o13so5508124ilt.3;
        Wed, 24 Aug 2022 16:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5IQ9tevn+xHu8ONaxA775pRqHsEhtIoa7rMSZUkMk9g=;
        b=YJlcc3V/ioBC8ouaOMt34qwNYVbXNgc0IXck4aolt8mVUGzVqIT3ATYsDas45gT4Ip
         17KRfOW446Yvbtv4h72Z8MJ4Jxqz1CpvCq0obyohN8zdV8AeBiJ2Hos4Scq/B3MR9BWK
         Q+sgwjqqdJ3sQDHXZNT910xSIdJHGc2yei58ntOCBKyKF61HxfK4tZL1LH6Glt5W1wJt
         KeKj3zXO/MZeUdXCJn1eq+vWh2YVfwc+Lz4946tDeiNan96NKjZC9KpmxAYRElo8VLFK
         7v90voeWEy9QVJriZctOO6OyjdnVXrI5ucN2l6D/fySEb5CbNxCKX2W+jr3sX8j+HATq
         hLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5IQ9tevn+xHu8ONaxA775pRqHsEhtIoa7rMSZUkMk9g=;
        b=irpyTemaFsP35MkTGBhfe62rRk7K3xafdXjyy4PG3GyTEiuX2vakb3QUjL1lKp08AQ
         kh2DhWzFXasDSAGIi+4h4g6I9vmMrjHQC3juIaP0U+mZU0RaxYO++MEXIooKS3Xb4VRw
         nKegNu9mHbw1wLJxeFYt6J3Ekj38lJJqaQgBJ4nzfDf0CFXB+lsgPzJUYFD0v4GGnxOz
         DFhhsxYBrVTB0OX2GGPwuLwXCrmCRZP11vvAKceNi8zOV6/rwobg+j9n4mGHrHd8a3M3
         qOumRyjbSijp+GwGCF6NidaIM6icYGseJQD3jfAGdN1twg1IVE2eZF2ZA/8H/qZwzkm1
         u+kg==
X-Gm-Message-State: ACgBeo0JoE4/i734Jenpr7aPykWWlu2yDXo4tLCGEyfpEp3ggJy0CkDF
        7+ZvHkEt4z8s8DbSUQDYouV7/WW2Mf5hmrWNU5I=
X-Google-Smtp-Source: AA6agR5hW5rlxUY7mHU9jc1SPn5VIXnSVH31Bziwgt9IPq4hQ9UkjI5W99KdAoqhSpJLkPLHo83dPoeX5dRm4eWgjDM=
X-Received: by 2002:a92:ca07:0:b0:2e9:7f3d:4df5 with SMTP id
 j7-20020a92ca07000000b002e97f3d4df5mr590261ils.216.1661383142018; Wed, 24 Aug
 2022 16:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <CAP01T74LUHjpnVOtwV1h7ha4Dqz0EU5zjwojz-9gWPCN6Gih0Q@mail.gmail.com>
 <CAJnrk1amsYS51deoXTOnWvMKSQNvbCK_JSPaGW=OBZZsEyNVuQ@mail.gmail.com> <CAEf4BzZGL--5D-ok45U5TyogG-Wqa1SvQhbQFLhkdpn=gmDXNA@mail.gmail.com>
In-Reply-To: <CAEf4BzZGL--5D-ok45U5TyogG-Wqa1SvQhbQFLhkdpn=gmDXNA@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 25 Aug 2022 01:18:25 +0200
Message-ID: <CAP01T76cOa3B5njcDtBo44s2x4WBUofu=uqeaZ-h=u0LXU8vFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] Add skb + xdp dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 at 20:02, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 23, 2022 at 11:52 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Mon, Aug 22, 2022 at 7:32 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Tue, 23 Aug 2022 at 02:06, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
> > > >
> > > > This patchset adds skb and xdp type dynptrs, which have two main benefits for
> > > > packet parsing:
> > > >     * allowing operations on sizes that are not statically known at
> > > >       compile-time (eg variable-sized accesses).
> > > >     * more ergonomic and less brittle iteration through data (eg does not need
> > > >       manual if checking for being within bounds of data_end)
> > > >
> > >
> > > Just curious: so would you be adding a dynptr interface for obtaining
> > > data_meta slices as well in the future? Since the same manual bounds
> > > checking is needed for data_meta vs data. How would that look in the
> > > generic dynptr interface of data/read/write this set is trying to fit
> > > things in?
> >
> > Oh cool, I didn't realize there is also a data_meta used in packet
> > parsing - thanks for bringing this up. I think there are 2 options for
> > how data_meta can be incorporated into the dynptr interface:
> >
> > 1) have a separate api "bpf_dynptr_from_{skb/xdp}_meta. We'll have to
> > have a function in the verifier that does something similar to
> > 'may_access_direct_pkt_data' but for pkt data meta, since skb progs
> > can have different access restrictions for data vs. data_meta.
> >
> > 2) ideally, the flags arg would be used to indicate whether the
> > parsing should be for data_meta. To support this though, I think we'd
> > need to do access type checking within the helper instead of at the
> > verifier level. One idea is to pass in the env->ops ptr as a 4th arg
> > (manually patching it from the verifier) to the helper,  which can be
> > used to determine if data_meta access is permitted.
> >
> > In both options, there'll be a new BPF_DYNPTR_{SKB/XDP}_META dynptr
> > type and data/read/write will be supported for it.
> >
> > What are your thoughts?
>
> I think separate bpf_dynptr_from_skb_meta() and
> bpf_dynptr_from_xdp_meta() is cleaner than a flag. Also having a
> separate helper would make it easier to disable this helper for
> program types that don't have access to ctx->data_meta, right?
>

Agreed, and with flags then you also need to force them to be constant
(to be able to distinguish the return type from the flag's value),
which might be too restrictive.
