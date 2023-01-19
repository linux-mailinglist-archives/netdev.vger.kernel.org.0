Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FBD67374F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjASLrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjASLqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:46:55 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BC93801C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:46:38 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-4fc52a0f60cso6221257b3.11
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vDprj+8D5pGTX/+e8ZmPXb4rFhCE6TW6MBvJHNd1rAc=;
        b=UiP2EbVUWxm6nEHse+++CJPdPY3iaz5KglQ5CI5YvYrX3h6it2XsCBOn7u60UGDw0J
         owVqeXNLk+qlf/V2wvSiAFedwGQ+yyDjbNiN4BX2g/uwlibnog/m8YQkMUKKCVdAIvq7
         rbfYEHJ6kM/UIfPTUK47YpcrZZZLpDaKirskF+GW1FUvgbf6YI1fnfot9G9hhThaEi0m
         JmDh22yqAlnhXNX3yCzbzPLgr4APWsd2l1PO4Uw6vsQ4UBFpLGlQjFHuXvmcuPxqkg++
         e1II9Gdv5udeQUsCcim58E2zayLOMI7djIpUxuUuklIaONq6c/Tnn1kb6U98NL/THAfx
         D7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vDprj+8D5pGTX/+e8ZmPXb4rFhCE6TW6MBvJHNd1rAc=;
        b=z/8C1Ut56vH4ss7yAz9tnp6Io62sl+xYEA5Xvh5S8rEm1Fx6oZdu7/US0eJBtJk+vn
         eCfoF7OU16CttinRVpe91D7o51d9tPkTqlBQEHFPLiPFAOhMZtFx60tFrIH3hMydbUDu
         X+vyKhhuRv/0LrZ1/gemAN2dJNinWO6vzfbi+0McuaJUZ2Uq0AfIv3ET39d3tYjUgu/a
         ULYdHZUVdBvy8+jysIvwx+kifkEGl2dvTv5bCTxgnS3dnuAmSyTw6VEhbYTMcE2NP0gA
         ptzOW1zeXitfTxEjfQoD5gY9Rt5oEG//LP7boUnQbx80E2yl4jT0cAP/9Ez7L86YcG3+
         gEXg==
X-Gm-Message-State: AFqh2kqf53nik04Z4a1VV35zTXvbjDAD5B/6spS70iBZbMkQaQQGRjW+
        w7I+zzdo5fF4TWskIsK8ubMOfpkgaVj4SdTnZ50O9Q==
X-Google-Smtp-Source: AMrXdXvSRy4ShXACtMf3ElBUFvyZPX5cz4gQiOz8rwalUeWmbvxmGWSkEjclcp0uQJiU9q0mXvhkl9PVL6z2URPpOU4=
X-Received: by 2002:a05:690c:954:b0:4ef:2ac3:7ce0 with SMTP id
 cc20-20020a05690c095400b004ef2ac37ce0mr1350464ywb.489.1674128797668; Thu, 19
 Jan 2023 03:46:37 -0800 (PST)
MIME-Version: 1.0
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul> <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
 <20230118182600.026c8421@kernel.org> <e564a0de-e149-34a0-c0ba-8f740df0ae70@redhat.com>
 <CANn89iJPm30ur1_tE6TPU-QYDGqszavhtm0vLt2MyK90MYFA3A@mail.gmail.com> <d0ecbed5-0588-9624-7ecb-014a3bebf192@redhat.com>
In-Reply-To: <d0ecbed5-0588-9624-7ecb-014a3bebf192@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 12:46:26 +0100
Message-ID: <CANn89iLymg62A8GNy4jJ3tsyitNZvDnhbA90t4ZJQ2dX=RG2qw@mail.gmail.com>
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use kmem_cache_free_bulk
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 12:22 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 19/01/2023 11.28, Eric Dumazet wrote:
> > On Thu, Jan 19, 2023 at 11:18 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >>
> >> On 19/01/2023 03.26, Jakub Kicinski wrote:
> >>> On Wed, 18 Jan 2023 22:37:47 +0100 Jesper Dangaard Brouer wrote:
> >>>>> +           skb_mark_not_on_list(segs);
> >>>>
> >>>> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
> >>>>
> >>>> I don't understand why I cannot clear skb->next here?
> >>>
> >>> Some of the skbs on the list are not private?
> >>> IOW we should only unlink them if skb_unref().
> >>
> >> Yes, you are right.
> >>
> >> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
> >> returns true, meaning the SKB is ready to be free'ed (as it calls/check
> >> skb_unref()).
> >
> >
> > This was the case already before your changes.
> >
> > skb->next/prev can not be shared by multiple users.
> >
> > One skb can be put on a single list by definition.
> >
> > Whoever calls kfree_skb_list(list) owns all the skbs->next|prev found
> > in the list
> >
> > So you can mangle skb->next as you like, even if the unref() is
> > telling that someone
> > else has a reference on skb.
>
> Then why does the bug go way if I remove the skb_mark_not_on_list() call
> then?
>

Some side effects.

This _particular_ repro uses a specific pattern that might be defeated
by a small change.
(just working around another bug)

Instead of setting skb->next to NULL, try to set it to

skb->next = (struct sk_buff *)0x800;

This might show a different pattern.

> >>
> >> I will send a proper fix patch shortly... after syzbot do a test on it.
> >>
>
> I've send a patch for syzbot that only calls skb_mark_not_on_list() when
> unref() and __kfree_skb_reason() "permits" this.
> I tested it locally with reproducer and it also fixes/"removes" the bug.

This does not mean we will accept a patch with no clear explanation
other than "this removes a syzbot bug, so this must be good"

Make sure to give precise details on _why_ this is needed or not.

Again, the user of kfree_skb_list(list) _owns_ skb->next for sure.
If you think this assertion is not true, we are in big trouble.
