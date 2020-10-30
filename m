Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6F29F9FA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgJ3Atn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgJ3Atn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:49:43 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D0AC0613D2;
        Thu, 29 Oct 2020 17:49:43 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 133so3795494pfx.11;
        Thu, 29 Oct 2020 17:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DsTq0eaBSRmyjts94r7jVkRg1FP8IscyEg7XHscMyuM=;
        b=F+98Wo2D0Zeu0ZxEW+2kYa5yfGJ+I3NOXsRPX3WSev3nTlgxAM2FVEFg6EsHrr+oyc
         z8zpQ044rQSX/EAfWcVTWS1snVdd5alqc4k7MHcJhRy930k3WSUm/FCIKcso90AGqH6M
         iX7iNHg9C32TjIbkGSn5JkVMjfuING/HGWTrehzXthFcsDbBor0YlvKNe0BtRJVkC6xl
         HSsTlKfb8ik+gfBml+oV0iFS+8RTJfEDEu4g0fbJGfmv1WVirYLHlHY6BeMR4neIUn4t
         Hg1ermBpuu1jkM78ZRbTHXEr1+w+x+terEqvJa+pURzJp+2V3cOlW3HZueNYKg6w/v0R
         GM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DsTq0eaBSRmyjts94r7jVkRg1FP8IscyEg7XHscMyuM=;
        b=YqyVPiscPk2pUQ85zeOV5xZabXZb1kJAIM3xdT7rHgN8PQcBrMFnbh+tc50nAybKaH
         gxZ33ANcokWHEYFCbRx8le7BXRQyhJx8h9SFYrYSmcGzheV697Owj1a8QJ6qUU5WWXFR
         zX0wHxu0HwMDM9lTaZfhjOOSo+o31hPNQwu0jVzbFdKKt9bLJT7MZnkB2y6YomF6ciwI
         jcrYXZbAWcBoJdxTeGUzVBh7iJRFNqGE4h+0acWhSfM5Zwo8uqtRLmNYU8L8qMBp4UW7
         DeMTiFphN98s1Y+RuMl3p/u4zIgzc/2DVQDPJfhfCuRTRzCO9NBVyYj2q8iygdMrCCd4
         D9Hg==
X-Gm-Message-State: AOAM5328bYHxZcLMRpmb/brezdH/JmlpbF6AAiBYCgdiEW4MmcZ6RpJj
        jlFHJq6FxQyONdFk8rYmjg8sTTyzOl8U6nwuybs=
X-Google-Smtp-Source: ABdhPJzjnf8q17mVpNIdFn7ayDBkcGHZhtFfhICd7YA/n7uNze+xpb+wERCv4xjYDfQC3+ED2MgTRtRXuawRu6G6xPo=
X-Received: by 2002:a63:7347:: with SMTP id d7mr6496141pgn.63.1604018982521;
 Thu, 29 Oct 2020 17:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201028131807.3371-1-xie.he.0141@gmail.com> <20201028131807.3371-5-xie.he.0141@gmail.com>
 <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com> <CAJht_EMOxSn-hraig1jnF_KwNsYaCYnwaZvVH7rutdS0Lj0sGA@mail.gmail.com>
In-Reply-To: <CAJht_EMOxSn-hraig1jnF_KwNsYaCYnwaZvVH7rutdS0Lj0sGA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 29 Oct 2020 17:49:31 -0700
Message-ID: <CAJht_EPggyhiaROvReNJ4hCwQ6+Z0wf4zHADrSAaT8jBE0J+1w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: hdlc_fr: Add support for any Ethertype
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 4:53 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> > Does it make sense to define a struct snap_hdr instead of manually
> > casting all these bytes?
>
> > And macros or constant integers to self document these kinds of fields.
>
> Yes, we can define a struct snap_hdr, like this:
>
> struct snap_hdr {
>         u8 oui[3];
>         __be16 pid;
> } __packed;
>
> And then the fr_snap_parse function could be like this:
>
> static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
> {
>        struct snap_hdr *hdr = (struct snap_hdr *)skb->data;
>
>        if (hdr->oui[0] == OUI_ETHERTYPE_1 &&
>            hdr->oui[1] == OUI_ETHERTYPE_2 &&
>            hdr->oui[2] == OUI_ETHERTYPE_3) {
>                if (!pvc->main)
>                        return -1;
>                skb->dev = pvc->main;
>                skb->protocol = hdr->pid; /* Ethertype */
>                skb_pull(skb, 5);
>                skb_reset_mac_header(skb);
>                return 0;
>
>        } else if (hdr->oui[0] == OUI_802_1_1 &&
>                   hdr->oui[1] == OUI_802_1_2 &&
>                   hdr->oui[2] == OUI_802_1_3) {
>                if (hdr->pid == htons(PID_ETHER_WO_FCS)) {
>
> Would this look cleaner?

Actually I don't think this is significantly cleaner than the previous
version of code. A reader of this code may still wonder what are the
values of all these macros, and he/she may still want to look up the
values of them. The comment in the previous version of code has made
the meaning of these values very clear, and the reader of the code
would not need to go to another place of this file to find the values.

The struct snap_hdr eliminates a cast, but only one cast. So it might
not be very necessary, either. Introducing this struct also makes the
reader need to go to another place of this file to look up the
definition of this struct. So it does not significantly improve the
readability (IMHO).
