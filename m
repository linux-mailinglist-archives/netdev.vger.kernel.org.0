Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF9B616C18
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiKBS0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiKBS0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:26:08 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AD52E6B4
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:26:06 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-368edbc2c18so173960247b3.13
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ULxNV0Y7ObC/UK3IdOnSD/Vynj/215SLWO43fDO8Lz8=;
        b=TAWW3m8UL5LDFG8C5gf7E3dMuHygxgu6yswn9PmrqsByIQCZ0c30noNS+qq6tWhn1B
         Z0g3s4wyuwoWgQ/SfCSK9KWahrIm58SDkKbPOjM/KJzKSnxwk9yw2fyfT6hB264wI1TH
         /aneHQVowmTlQPO4/kfq+HbuB73l8yxkcEZEbKb9sa42tv7EkRZlwc+UjqwbvEhoAlXl
         a9+m0pkRgC5CHjT7iljQ8DGTMySEZmn1frCJLkAO+NsjrZZeAaWx2z/WAWW8rDDsWnF5
         n0YBGD834JmcA2b2ZTNW9x84QF3HrHM2VcVbWy/mD5xjXK+iHjk5wSHgiBG9PE1SnC90
         UDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ULxNV0Y7ObC/UK3IdOnSD/Vynj/215SLWO43fDO8Lz8=;
        b=mgGh0DmheaDcTJcvwlYudhxgO/JyPSQivGry+VWKx4X2CnIWEvldNG4Q9y24AaJ2wN
         2nGgtWtE6n0BDDHYshl8F/jXJ+7oyETaAgyVaEAXKZt0dE2UT1lQ45SQOXAWDgRnF1hE
         wR6p/WJ6OQ9ayCH1BiWtk46BZ3wrq0HBHUibSCZsqFeebiFr7tqWu+Yy9ziEC0PkLV2t
         6vYFv6NCeqxdEa8XPGrrdjwilRrZnxOLrmeMtSCX5I94rDJp1Ira54nYrvYYSlrGfdxb
         A1IEoSR6v564Xr1BCjod+a6+fU1DEfT11Q+Q+6aS9mzRnwvmKOoBpZDI0cT0u8kVC2+W
         RAIw==
X-Gm-Message-State: ACrzQf2y1GKsIftSel6DZu78RXrxUsN+EX2CnQu1pXFonjyqsckNnH1Q
        fYblKDL33k7TV0yKmaU+TlCuM9RMu4Z5SnK4TWWTQQ==
X-Google-Smtp-Source: AMsMyM5/s1ZlPxsmc3KM9M9KFHK/LBqCyXGfiUT6gJBpOWlkIyFLGxflMfDIytZ89otdK5GJcFlOsxP73GBwQZ2Sh6U=
X-Received: by 2002:a81:c11:0:b0:36a:bcf0:6340 with SMTP id
 17-20020a810c11000000b0036abcf06340mr24170753ywm.467.1667413565888; Wed, 02
 Nov 2022 11:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221024051744.GA48642@debian> <20221101085153.12ccae1c@kernel.org>
 <CAJLv34RKj6u_7EZwYWiNujC-R4nxKHJ24DVYqydgHPy88NqMPA@mail.gmail.com> <CANn89iJeg+wQUdi7i=EbSS7Z__j+LEakPab3oKD7_Rr4hmV_xg@mail.gmail.com>
In-Reply-To: <CANn89iJeg+wQUdi7i=EbSS7Z__j+LEakPab3oKD7_Rr4hmV_xg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 11:25:54 -0700
Message-ID: <CANn89iKKFABZxAv5PkNmCVZTyHxqghC9zoRSvbfDo+04qrHH9w@mail.gmail.com>
Subject: Re: [PATCH net-next] gro: avoid checking for a failed search
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 11:20 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Nov 2, 2022 at 9:46 AM Richard Gobert <richardbgobert@gmail.com> wrote:
> >
> > > Why does it matter? You see a measurable perf win?
> >
> > In the common case, we will exit the loop with a break,
> > so this patch eliminates an unnecessary check.
> >
> > On some architectures this optimization might be done
> > automatically by the compiler, but I think it will be better
> > to make it explicit here. Although on x86 this optimization
> > happens automatically, I noticed that on my build target
> > (ARM/GCC) this does change the binary.
>
> What about taking this as an opportunity to reduce the indentation
> level by one tab ?
>
> Untested patch:
>
> diff --git a/net/core/gro.c b/net/core/gro.c
> index bc9451743307bc380cca96ae6995aa0a3b83d185..ddfe92c9a5e869d241931b72d6b3426a0e858468
> 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -491,43 +491,44 @@ static enum gro_result dev_gro_receive(struct
> napi_struct *napi, struct sk_buff
>         list_for_each_entry_rcu(ptype, head, list) {
>                 if (ptype->type != type || !ptype->callbacks.gro_receive)
>                         continue;
> +               goto found_ptype;
> +       }
> +       rcu_read_unlock();
> +       goto normal;


Or even better:

        list_for_each_entry_rcu(ptype, head, list) {
               if (ptype->type == type && ptype->callbacks.gro_receive)
                       goto found_ptype;
       }
       rcu_read_unlock();
       goto normal;
