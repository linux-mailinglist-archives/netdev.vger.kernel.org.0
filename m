Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D84A4FDBC7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343965AbiDLKHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354330AbiDLKDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:03:23 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE786E8F6;
        Tue, 12 Apr 2022 02:10:30 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id u2so13636675vsl.6;
        Tue, 12 Apr 2022 02:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LmC2G1kIC2bjPYIdvitbx5KXueFp/+sexGyQ4odL7qI=;
        b=WBvobLH5KLi6Jflqi4+K9mLcfHiASYqCcI9tr6wtc5F8ebkEW2Hp2dBLHpaJID78hB
         XMzIYXVY/guqlwBP5rwvCPA/w/ZaLgMrdJTscqTkmRGIBLEajBtLrZGVOmqpyCFe5n4N
         xZPTbjnLKiuJGye6o0olrzZrmj9XlEFJ1rnjErRXGo/eRgkgGStcZnHy+2tKZr2QppyE
         szBMAoOmPDyvDSRYwCJiM7CxbthSHwTPQFvrQQpRJP/nlOHXwwogt/WKkUKiVhqHiM45
         cIsRmm/VTJB4qT/zml8EVFdVXo23lgGIEEO4ugfKw2NEN3ISysd1mTvWX1AXvlgSfnA6
         sUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LmC2G1kIC2bjPYIdvitbx5KXueFp/+sexGyQ4odL7qI=;
        b=N1iazT2sqe36XDrIS1QnRuOLHZZAYMKkEiACFBEF5cjxtL6gW0Gu76xW0vlvERQoOq
         IB63b/K3zUZXOi2vlkcBXdtA65bKXT5ufWlM79rhuco+BBnmNmkk2ZyfNOrOf2mFDjPp
         ZlESYac75GIi7x525NH9+JCpjz+3a1XP2B1uV2vWPAKtHFqeqwm+goUN9t/OYVRRqFSO
         NIFmJSNFGoSQpyL77Z2SwjEddQqSe4YdPk7dvCj4BD6sULR0q/F8Hjp47j6O8nazVyov
         cFO32h8TsRFts6SwTvOWnrwV1eHm/+JVbDtCP5VQ0raR4qDjHa1VV22lHVuG+21vgst3
         YNgA==
X-Gm-Message-State: AOAM5310m45UMjHBb/ABWsbWt/Uw839UCbKFdaPBZPqJXvP+879+NRtY
        By3qEEZ8hzlBeQQpvTrBtRukjlbf7ydz/BUalJc=
X-Google-Smtp-Source: ABdhPJxHCqelE2YrKMEsQ3BujCVr7G3u5Mo/6g1Tf9IHCCWKPVh24iVU3I84se8WdJ9gaTZ+Xv/N27J+Sp7Es95QiHA=
X-Received: by 2002:a67:cd85:0:b0:329:c97:af2f with SMTP id
 r5-20020a67cd85000000b003290c97af2fmr524126vsl.6.1649754629222; Tue, 12 Apr
 2022 02:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220412064940.14798-1-guozhengkui@vivo.com>
In-Reply-To: <20220412064940.14798-1-guozhengkui@vivo.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 12 Apr 2022 11:11:11 +0200
Message-ID: <CAOi1vP-OQFQ9-PmUnv_qO6Yy4iMKCWDXX+jupfKSZKYnHnb66w@mail.gmail.com>
Subject: Re: [PATCH linux-next] net: ceph: use swap() macro instead of taking
 tmp variable
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:CEPH COMMON CODE (LIBCEPH)" <ceph-devel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        zhengkui_guo@outlook.com
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

On Tue, Apr 12, 2022 at 9:01 AM Guo Zhengkui <guozhengkui@vivo.com> wrote:
>
> Fix the following coccicheck warning:
> net/ceph/crush/mapper.c:1077:8-9: WARNING opportunity for swap()
>
> by using swap() for the swapping of variable values and drop
> the tmp variable that is not needed any more.
>
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  net/ceph/crush/mapper.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 7057f8db4f99..1daf95e17d67 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -906,7 +906,6 @@ int crush_do_rule(const struct crush_map *map,
>         int recurse_to_leaf;
>         int wsize = 0;
>         int osize;
> -       int *tmp;
>         const struct crush_rule *rule;
>         __u32 step;
>         int i, j;
> @@ -1073,9 +1072,7 @@ int crush_do_rule(const struct crush_map *map,
>                                 memcpy(o, c, osize*sizeof(*o));
>
>                         /* swap o and w arrays */
> -                       tmp = o;
> -                       o = w;
> -                       w = tmp;
> +                       swap(o, w);
>                         wsize = osize;
>                         break;
>
> --
> 2.20.1
>

Applied.

Thanks,

                Ilya
