Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274FF28C4BC
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388807AbgJLW0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388361AbgJLW0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:26:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7585C0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 15:26:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l8so19349063ioh.11
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 15:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFMTJJaoHl8g9jrSjPdss0thVlNcust6I6ikRgUYGS0=;
        b=vDAPCXD9CkuYa7Al2J4n04fyyzxIb8ivcwcVb0cXDrHr4YKc7oQT8bUKEtdQZYSwQm
         ld/eQYwFdbEzargl0QX3UkBKU7/hM27f2+WXW2wMMvAIhyLlVXqJZWW2Sl0aiPQRfrwQ
         vGUegqa+SRfo6ex2fDP6aoPfejgJyr2TX2h4TY+QQJx0q0Ku/YDUwrFukBghCWDpmS3r
         2ZYdtHVHHFpepAIDME9+/T6U6qep4Bh5DWykWh4GGed6CQhNxV1R156DCkF9v2qZ9vL4
         ZRuVXXo6IugNMxh7ndKrRX4gnHxYcDWPfKJidmEjrnIfl+o6IXhjX8eJ3rwonYedaCpB
         wr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFMTJJaoHl8g9jrSjPdss0thVlNcust6I6ikRgUYGS0=;
        b=KXbemTEHMM2cp6MZasfzewkLS13IXjr9eegTTAAXPEbs1Fy0duqBo3vDVwQB/VjtIf
         TQ5f15HXP0LFe6zO0DAnRbQrwYBYFGXZeN4JE4k1HJmZgbycvl1w4Ycy9wBgYqCSiQ1F
         Bmr2rfvDzUSRTlIX30fRcG7VPKjEI9yytBUiwpWn27VaufUQL+uF+YjM3B+hXcEpYnQ1
         sVpGEq6jYcW/cv6fiiialZzQSW0gdza4/uKIQr+kbs0V5serQjS+ybzZHZZuMIweE+WO
         pcBPTqE8bdtEb2tgc7Ma35QEwzIv4QpVPXKlx5IccJG+hMznxvm3dE08I1yYVxSohfcp
         3Q6A==
X-Gm-Message-State: AOAM532lGCMybIEi/f1xbHwOu2Tc/tfJi/u2zFfORN+PSeIUl12hSzUm
        QQTqJlxm72xbbdhnsTVArMEtNMa4m8BSwk5ae5M=
X-Google-Smtp-Source: ABdhPJxorbE5yy307fqNf+emS19zT9LeDHjTXzQrLW9URHUC4LUwsI3luV5c5Zyh0YAeBnVcbqUlt7K16MTrPn/2MXA=
X-Received: by 2002:a02:94cd:: with SMTP id x71mr20269630jah.124.1602541613122;
 Mon, 12 Oct 2020 15:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com> <CAJht_ENA9cfnU2bpjgFDZN=4QPwEJBs_59h_AoH5Sk=BasgZ4g@mail.gmail.com>
In-Reply-To: <CAJht_ENA9cfnU2bpjgFDZN=4QPwEJBs_59h_AoH5Sk=BasgZ4g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 12 Oct 2020 15:26:41 -0700
Message-ID: <CAM_iQpVv+OKb4483TOvdVrVXonLOvw9NAw=WApU5MnHmMdHz7Q@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 3:46 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sun, Oct 11, 2020 at 12:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > @@ -626,8 +626,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
> >
> >         if (dev->header_ops) {
> >                 /* Need space for new headers */
> > -               if (skb_cow_head(skb, dev->needed_headroom -
> > -                                     (tunnel->hlen + sizeof(struct iphdr))))
> > +               if (skb_cow_head(skb, dev->hard_header_len))
> >                         goto free_skb;
> >
> >                 tnl_params = (const struct iphdr *)skb->data;
>
> As I understand, the skb_cow functions are for ensuring enough header
> space before skb->data. (Right?) However, at this stage our skb->data
> is already at the outer IP header, I think we don't need to request
> additional header space before the outer IP header.

Good point, I thought skb_headroom() == dev->hard_header_len,
but skb->data already points to the tunnel header like you said, so
we should pass 0 to skb_cow_head() here.

Thanks.
