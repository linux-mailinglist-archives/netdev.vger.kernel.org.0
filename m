Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D390640F71
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiLBUvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiLBUuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:50:50 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C617E38BB;
        Fri,  2 Dec 2022 12:49:49 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id z192so7485767yba.0;
        Fri, 02 Dec 2022 12:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu84QcF4nGS1pRC8Av6fg3KQ7KwDjJQ4dLvyiZ13eHk=;
        b=Tus0r5uMYaRAJz+2MnvZSM9L+9gP82Q4ojUcUqHic8lEw6bLz/l9UXbXBZZgyRl9oP
         5gsHZVD01uYm/oEm/ih+orHOqPSMhP2qHtR3E65s0QpvDs94x0lt1cYOSmAzxo/GA5gb
         LfVFPzEQpiPU3KB4kfVGMvrbaeCVRzGlOwkuc80FX2N5Ni1RxLJ8J9k5GV4Lgk0dFUUZ
         VTEagQbT4VhQMuqy4MxfBWm5I/q04AB/1Ae5iFbLtNCeGfJy2Y+E5nuV6f33uxqhTKVi
         Svol8J+zIWCdgH+Zm27uQ+O9YzSVL5YJXai/zwW14G8Wr+QQq67jMSQ5bFUMABMQ+QL0
         +oOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mu84QcF4nGS1pRC8Av6fg3KQ7KwDjJQ4dLvyiZ13eHk=;
        b=EUqOd3BHwT8/YJIwFi5ldp7llmVHasbEawk91d1uTfICb1ADouTSWftpLpSS5Nbthr
         maJwvt2tMP9B0I0yPCf5hgltFPo8LTb3qfekimXjxZMKfBHb0qyScZlwtg1aS3OCdQlJ
         +tnHnCV2y4oQtYao+vQy71uT/vMqgb6oJN9iefNDsDVmgeSrc4/Y7/dhFiVb2zBjcMz8
         /Agzggi+iLQtfI9N8nciVXeSv136/nuKfmqeMEeNXQBNWY/Ko7DKdePTCW/eamnknjoz
         TB/t8qB5DvLsloMc1p1Pt5QM4k6dUmtQSc5CYaKY0YJ5+u6ZbaNp6uSAPTkNxXdk1ZLW
         w6dw==
X-Gm-Message-State: ANoB5pksSbjJ6OpbHFNMFGkD08FLThHgTO6DlQJqAx7Rk/QEmZeeEBJy
        Ytax989W+sSBRIVxncv8ZYFrlB3ikVoGO0eJOvIbD7/xyl6NYA==
X-Google-Smtp-Source: AA0mqf5G8fgB6xxIczohQ/X7u6CGL/qnAqg5943cNlIcDefwH1BJKc8d47UVjhtEc1jbGSYWQYxdwdVzpWJQC611SJw=
X-Received: by 2002:a25:401:0:b0:6fa:8a4b:40b6 with SMTP id
 1-20020a250401000000b006fa8a4b40b6mr13041679ybe.230.1670014188666; Fri, 02
 Dec 2022 12:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
 <20221202095920.1659332-3-eyal.birger@gmail.com> <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
 <CAHsH6Gtt4vihaZ5kCFsjT8x1SmuiUkijnVxgAA9bMp4NOgPeAw@mail.gmail.com> <4cf2ecd4-2f21-848a-00df-4e4fd86667eb@linux.dev>
In-Reply-To: <4cf2ecd4-2f21-848a-00df-4e4fd86667eb@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Fri, 2 Dec 2022 22:49:37 +0200
Message-ID: <CAHsH6Gt=WQhcqTsrDRhVyOSMwc4be5JaY9LpkbtFunvNZx3_Cg@mail.gmail.com>
Subject: Re: [PATCH bpf-next,v4 2/4] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
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

On Fri, Dec 2, 2022 at 10:27 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/2/22 11:42 AM, Eyal Birger wrote:
> > Hi Martin,
> >
> > On Fri, Dec 2, 2022 at 9:08 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>
> >> On 12/2/22 1:59 AM, Eyal Birger wrote:
> >>> +__used noinline
> >>> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> >>> +                       const struct bpf_xfrm_info *from)
> >>> +{
> >>> +     struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> >>> +     struct metadata_dst *md_dst;
> >>> +     struct xfrm_md_info *info;
> >>> +
> >>> +     if (unlikely(skb_metadata_dst(skb)))
> >>> +             return -EINVAL;
> >>> +
> >>> +     md_dst = this_cpu_ptr(xfrm_md_dst);
> >>> +
> >>> +     info = &md_dst->u.xfrm_info;
> >>> +
> >>> +     info->if_id = from->if_id;
> >>> +     info->link = from->link;
> >>> +     skb_dst_force(skb);
> >>> +     info->dst_orig = skb_dst(skb);
> >>> +
> >>> +     dst_hold((struct dst_entry *)md_dst);
> >>> +     skb_dst_set(skb, (struct dst_entry *)md_dst);
> >>
> >>
> >> I may be missed something obvious and this just came to my mind,
> >>
> >> What stops cleanup_xfrm_interface_bpf() being run while skb is still holding the
> >> md_dst?
> >>
> > Oh I think you're right. I missed this.
> >
> > In order to keep this implementation I suppose it means that the module would
> > not be allowed to be removed upon use of this kfunc. but this could be seen as
> > annoying from the configuration user experience.
> >
> > Alternatively the metadata dsts can be separately allocated from the kfunc,
> > which is probably the simplest approach to maintain, so I'll work on that
> > approach.
>
> If it means dst_alloc on every skb, it will not be cheap.
>
> Another option is to metadata_dst_alloc_percpu() once during the very first
> bpf_skb_set_xfrm_info() call and the xfrm_md_dst memory will never be freed.  It
> is a tradeoff but likely the correct one.  You can take a look at
> bpf_get_skb_set_tunnel_proto().
>

Yes, I originally wrote this as a helper similar to the tunnel key
helper which uses bpf_get_skb_set_tunnel_proto(), and when converting
to kfuncs I kept the
percpu implementation.

However, the set tunnel key code is never unloaded. Whereas taking this
approach here would mean that this memory would leak on each module reload
iiuc.

Eyal.
