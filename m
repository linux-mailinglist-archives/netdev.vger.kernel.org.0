Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2D55A0106
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240461AbiHXSDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240556AbiHXSCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:02:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FECA4330C;
        Wed, 24 Aug 2022 11:02:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d21so15691709eje.3;
        Wed, 24 Aug 2022 11:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=im2SBWTnvsjrSirpAj4+pT4GY9SiJsqqLVRFzSItoMo=;
        b=FnyYPdubjA9XuFj2KtzF8NnwtlBbbWAGvHuhYJhzAPx1Nt/daQssAZEoxejdLK2AIf
         zNOGJLZT43fnB0YZ41caIcJ1rHdH4CYCGJjMUAMqz/Z9wqoLfSy5fNLtdfYMkpzRLvcN
         G+bTCGbAXQFvnNJYEjH+LGEKUc5kLUTlphjJRw+5M/9g+ftISNQLiJ+Uo4E2BS97+0Uh
         Edu1ZCp4qATjuFd9newv23pcid2TWD5fO/f/6SVh5m0c78KMt/3GHfV+J42IfOKKqaTV
         k8hFU7XDlhu33DJo9VpPt+aoIAxk4bk3o4Un/Q3URXDyPIrKLXVCIWcfWjHetOvmu6TT
         dPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=im2SBWTnvsjrSirpAj4+pT4GY9SiJsqqLVRFzSItoMo=;
        b=W7/KuzQniXuIhpGaqIs+PefCl0oarVGeQCD4RdxYKrsJPkrZg7zxSyVUidhNV6uAxh
         vJPrJfBQj4+MCwHfWLcA6Lk88QK1Hqljob/rDWhH04ANt1UnGdcJXOV//VxWRuSJHo34
         kGxuDLgXuFRdLFjSmp3dOdR7ZCQitjoQ3MXPy8CQpiGu3OX9BXevopK7e0QxD6Ipcv8G
         71OASWIjVerhqBum0aIjpOgv1cbA1QqwjWG3QWvmnfgZFSAGMT45d/3031GyFPykQu/G
         uwuHaptK5PnfuIeK4EzwvBIi4s0Z84eAgVvU/Rn61XuBXSTZ0aaXCx3LJxGhGbKW8lA/
         LCXw==
X-Gm-Message-State: ACgBeo0w8/+CuYAnOQtAPBXlsZ2wSFQtqmFI6hhHHJD8qfYX+A0znELs
        AX/xiRGsPu4gM4KbbtXBhKAUgABoHm9uHgSsERg=
X-Google-Smtp-Source: AA6agR4suELQokE/zEGO+9tk3wuJLVr04sWGvCaOz+GnoEGxH/MFikI4Ky2uPjwVF6Dgi2kWFigX5Eg8QAYG8hNpGcw=
X-Received: by 2002:a17:907:6e8b:b0:73d:c094:e218 with SMTP id
 sh11-20020a1709076e8b00b0073dc094e218mr105427ejc.226.1661364131949; Wed, 24
 Aug 2022 11:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <CAP01T74LUHjpnVOtwV1h7ha4Dqz0EU5zjwojz-9gWPCN6Gih0Q@mail.gmail.com> <CAJnrk1amsYS51deoXTOnWvMKSQNvbCK_JSPaGW=OBZZsEyNVuQ@mail.gmail.com>
In-Reply-To: <CAJnrk1amsYS51deoXTOnWvMKSQNvbCK_JSPaGW=OBZZsEyNVuQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Aug 2022 11:01:59 -0700
Message-ID: <CAEf4BzZGL--5D-ok45U5TyogG-Wqa1SvQhbQFLhkdpn=gmDXNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] Add skb + xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
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

On Tue, Aug 23, 2022 at 11:52 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Mon, Aug 22, 2022 at 7:32 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Tue, 23 Aug 2022 at 02:06, Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
> > >
> > > This patchset adds skb and xdp type dynptrs, which have two main benefits for
> > > packet parsing:
> > >     * allowing operations on sizes that are not statically known at
> > >       compile-time (eg variable-sized accesses).
> > >     * more ergonomic and less brittle iteration through data (eg does not need
> > >       manual if checking for being within bounds of data_end)
> > >
> >
> > Just curious: so would you be adding a dynptr interface for obtaining
> > data_meta slices as well in the future? Since the same manual bounds
> > checking is needed for data_meta vs data. How would that look in the
> > generic dynptr interface of data/read/write this set is trying to fit
> > things in?
>
> Oh cool, I didn't realize there is also a data_meta used in packet
> parsing - thanks for bringing this up. I think there are 2 options for
> how data_meta can be incorporated into the dynptr interface:
>
> 1) have a separate api "bpf_dynptr_from_{skb/xdp}_meta. We'll have to
> have a function in the verifier that does something similar to
> 'may_access_direct_pkt_data' but for pkt data meta, since skb progs
> can have different access restrictions for data vs. data_meta.
>
> 2) ideally, the flags arg would be used to indicate whether the
> parsing should be for data_meta. To support this though, I think we'd
> need to do access type checking within the helper instead of at the
> verifier level. One idea is to pass in the env->ops ptr as a 4th arg
> (manually patching it from the verifier) to the helper,  which can be
> used to determine if data_meta access is permitted.
>
> In both options, there'll be a new BPF_DYNPTR_{SKB/XDP}_META dynptr
> type and data/read/write will be supported for it.
>
> What are your thoughts?

I think separate bpf_dynptr_from_skb_meta() and
bpf_dynptr_from_xdp_meta() is cleaner than a flag. Also having a
separate helper would make it easier to disable this helper for
program types that don't have access to ctx->data_meta, right?

>
> >
> >
> >
> > > When comparing the differences in runtime for packet parsing without dynptrs
> > > vs. with dynptrs for the more simple cases, there is no noticeable difference.
> > > For the more complex cases where lengths are non-statically known at compile
> > > time, there can be a significant speed-up when using dynptrs (eg a 2x speed up
> > > for cls redirection). Patch 3 contains more details as well as examples of how
> > > to use skb and xdp dynptrs.
> > >
> > > [0] https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gmail.com/
> > >
> > > --
