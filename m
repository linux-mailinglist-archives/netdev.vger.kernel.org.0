Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D777B28AAFD
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbgJKWqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387717AbgJKWqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 18:46:04 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738AEC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 15:46:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e10so11763271pfj.1
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 15:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BAAAgGveWAxBCq3q++T6ZbUx+Nt0dHNHLu3JhI0mJco=;
        b=IeEXzgLXEuAknduYCNJ2ZHMMshjsdMGsKvCJGlrN9se4Ix+t8579E6Guq1aGnRp6dW
         JFS8zVKaZLNJC9AAEkYD7E94PDndScz5t0LGOTHz1XoLbtzLniyeNdtaVudoPJPQL4/x
         aN9H6/PdRkudejEFDyIWpxmaOz4yTOZw2PzMetWcsZ0R9lfKDJT3WbGzJIw7i+rl7+Oc
         0xsPc2jPu1qSQfpz5fom/4R0IaOVJMf/JoLir7lFSsIYL/71puZrx5w0NgjMfZvoc9ok
         dIej1+xKxe6o/9j0AjCcigccjsXhHRin9Rob6A9Cni0IGMVP46w19FuQpa67UO2iNdh8
         +5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BAAAgGveWAxBCq3q++T6ZbUx+Nt0dHNHLu3JhI0mJco=;
        b=uIcQ8E/qPLrj1n4uTGlb9Q5FZA9xX3cxGVbibnEG7UUmqp04y+VUqxG0DqWvY0Mnlc
         BKNlavnudOL0kLj56dR6ASIsE9QkFJa+PjrOkXGMCqkuNrB7rL+uxQiKRkdbQK+6r6xK
         WNXzGXFviwjyXt8hMmoMFyjJFcE9njf/jOpzzz1hVlXUBRZQ6nN1N3sVCkFMwMLPW4S9
         K89cnTPI3AmGTVfdzTnGv6ExrnF2PgElvyagZCounJlQxhyhevjuAaxKsFXRjezvy3oC
         4NItSDRDRHzPNaaj4j9qyynf8jHVkmRsudTpYVyTWRwyg8X5wJEblVK1psUr7jcUia/D
         rPBQ==
X-Gm-Message-State: AOAM532askEoKABXlFJd7dBR19A6yWfbqF5L8Zs+xCvnl0Ft4IBkIQuE
        oN6GmhNkNLDZ2wcOIw+v4sMU0CHsRGYI5qOwi0U=
X-Google-Smtp-Source: ABdhPJytyFGAB28HnSUBW9JiQfOSIGsCBmfUMcraGeU4ZJ7/lhPimJZxroJjzfx6bcNDz7SVM13hxwyX4Inn0Ekoby0=
X-Received: by 2002:a63:a55d:: with SMTP id r29mr10966397pgu.368.1602456361791;
 Sun, 11 Oct 2020 15:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201011191129.991-1-xiyou.wangcong@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 11 Oct 2020 15:45:50 -0700
Message-ID: <CAJht_ENA9cfnU2bpjgFDZN=4QPwEJBs_59h_AoH5Sk=BasgZ4g@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 12:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> @@ -626,8 +626,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
>
>         if (dev->header_ops) {
>                 /* Need space for new headers */
> -               if (skb_cow_head(skb, dev->needed_headroom -
> -                                     (tunnel->hlen + sizeof(struct iphdr))))
> +               if (skb_cow_head(skb, dev->hard_header_len))
>                         goto free_skb;
>
>                 tnl_params = (const struct iphdr *)skb->data;

As I understand, the skb_cow functions are for ensuring enough header
space before skb->data. (Right?) However, at this stage our skb->data
is already at the outer IP header, I think we don't need to request
additional header space before the outer IP header.
