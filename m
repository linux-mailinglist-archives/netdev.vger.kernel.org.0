Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A4868F9DB
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjBHVrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjBHVrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:47:02 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95B91CAE6;
        Wed,  8 Feb 2023 13:47:01 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-52bf225460cso535977b3.4;
        Wed, 08 Feb 2023 13:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xgd2yofr2ZTSTBeZiA2gtSNheayk7SMhBNIknp+9Bgo=;
        b=emEg07OHqmz+ZNWoUS2DgjuIKATVcESXU/bf3U8zeMXuuiBY16bGFlR1fmPJ6Wkt8V
         nuvTDOLmcKhsJZyEJpj5IXI046FbigZLEaOL/QDgeSlIAszDl1oTN0p29CerQJyWAcag
         tk/47yzMhXVuwyZIM6UqQbOZPtku950TPNhXKIW8OBVbNTXDnr7k946hkZYGVxvDVzHM
         GSm8LoMLuY2V3uzVv3HhQq1rwI9L+perREx4XYglTCMtS0dooetSBVnd4AP2amezGgwm
         kQz9RyQYVOYpPiMbI2S6mCtlxrSXSY1tOB6q21Dk2hlHTTfQEYfxewYA0KryC3547fFb
         SpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xgd2yofr2ZTSTBeZiA2gtSNheayk7SMhBNIknp+9Bgo=;
        b=ka38IXrrY6Q0fIKq/RBKfV5tVLgOvvl/J+owt5QSX0QNCEx1t9/IqnOo+MKittjuab
         H40oeB/zHtv9OSSq6Z6prXVO1sqVaeM28fxVKG6Uwte9/1OmxSrOPCaouC3hQQs3UxKA
         cVw48CYSp2iY5wAHBo0iAHkRQJO++6uVuw8otx1UOfkKc40v+SQnfcW56Ev+mzTNfe4N
         TwHXhOHMgwHgbQAte9OFh4+A765Y+pJ0seCvN16cEfRoFH67cG6vodujKbE21GqlBUGI
         m5f+t5ePcruH3TixEEDcjDmxYd+IZuk/fgo1ug709FbeJWmYwfyUF3XcWsJ2P13OSuc7
         Dddw==
X-Gm-Message-State: AO0yUKVv7mdonxVhGIk4H8qJwab4B/BlSRhKBr3OvUoAZbnUVBM8NT6K
        mTnLWzMjI9GcOzN5f42SAReme3n4/8vzkNoMKYA=
X-Google-Smtp-Source: AK7set92HmJ1GMvFSA97JqgR1nIVnHqgVXB6ttmUnM5qxqCjL2ukTAPV96wA2KcEMo7pzaURg+hRDGOMyBbtQI/1QR0=
X-Received: by 2002:a0d:ea0a:0:b0:52b:ee03:d4d6 with SMTP id
 t10-20020a0dea0a000000b0052bee03d4d6mr431356ywe.418.1675892820928; Wed, 08
 Feb 2023 13:47:00 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
 <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com>
 <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com> <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com>
In-Reply-To: <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 8 Feb 2023 13:46:49 -0800
Message-ID: <CAJnrk1bxm3_QQFK_aqiApiu5vYC+z++jRj9HF2jO6a+WWkswpQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 9:54 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 9:36 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 04:44:12PM -0800, Joanne Koong wrote:
> > > On Sun, Jan 29, 2023 at 3:39 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
[...]
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index 6da78b3d381e..ddb47126071a 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -1684,8 +1684,8 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
> > > > >               skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
> > > > >  }
> > > > >
> > > > > -BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
> > > > > -        const void *, from, u32, len, u64, flags)
> > > > > +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> > > > > +                       u32 len, u64 flags)
> > > >
> > > > This change is just to be able to call __bpf_skb_store_bytes() ?
> > > > If so, it's unnecessary.
> > > > See:
> > > > BPF_CALL_4(sk_reuseport_load_bytes,
> > > >            const struct sk_reuseport_kern *, reuse_kern, u32, offset,
> > > >            void *, to, u32, len)
> > > > {
> > > >         return ____bpf_skb_load_bytes(reuse_kern->skb, offset, to, len);
> > > > }
> > > >
> > >
> > > There was prior feedback [0] that using four underscores to call a
> > > helper function is confusing and makes it ungreppable
> >
> > There are plenty of ungreppable funcs in the kernel.
> > Try finding where folio_test_dirty() is defined.
> > mm subsystem is full of such 'features'.
> > Not friendly for casual kernel code reader, but useful.
> >
> > Since quadruple underscore is already used in the code base
> > I see no reason to sacrifice bpf_skb_load_bytes performance with extra call.
>
> I don't have a preference either way, I'll change it to use the
> quadruple underscore in the next version

I think we still need these extra __bpf_skb_store/load_bytes()
functions, because BPF_CALL_x static inlines the
bpf_skb_store/load_bytes helpers in net/core/filter.c, and we need to
call these bpf_skb_store/load_bytes helpers from another file
(kernel/bpf/helpers.c). I think the only other alternative is moving
the BPF_CALL_x declaration of bpf_skb_store/load bytes to
include/linux/filter.h, but I think having the extra
__bpf_skb_store/load_bytes() is cleaner.
