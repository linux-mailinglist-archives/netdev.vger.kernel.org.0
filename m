Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CD633159A
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhCHSMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCHSMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:12:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB9AC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 10:12:12 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id m9so16098960edd.5
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 10:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OqopxqISgbDC0SR+TF4LgpGs83P68cEOgU0oL+9mBy0=;
        b=rK4orARib+uFue26kj7MItzjbMeCQujuEDB+aGDeIbin57sP23YVBgNZsvAxZ2H28v
         YnNz46zJWdkav61XGtp4BuQc2/KlwBhX3wlN0n6jMM9STBkezask2A7Fl3DxRM5R0mbb
         8SeMgsh5Y7LeqSf/6iRHsTYBPkntQaOqEogzT5gszPvnQAWC9LpHNHLYhh0r3hcZI5Yr
         9i5A84YYMdUZUcQnGNPFpp2FmYojMQuyy2aOPKeQg6OxP5w3ey768Pwtajg1mBjHRNpH
         PDLfuJ0VviolFVEl/DEyob/fNM0ZzFnJfYRt1685C/d7RqbZKTIriWmB+y0DuwtUsLK7
         GjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqopxqISgbDC0SR+TF4LgpGs83P68cEOgU0oL+9mBy0=;
        b=WTnNTc1FsjIE6gdH6iEbVMimfgm7SQSCoJxjrUFKfs1yGkyEZiK61Jsw3qe0xQZiY9
         65rLdEZb7ckFtBuY7xwKHMIgsZ7pPxOOyUfXHNFVc4r9JHnDcWUxePg5tBVmMMH99Eeb
         S8TuDIEqYenP1esF3niFnSv0obaBlVSNqx1ZjWbbSNmcko+SAWOgU+hIbad1/6+7lvEX
         ijjHoibcCw3HEdAvlPAwRNRlAOcF6/55+OmGXhi/P7RjG3TFUhxwbsUNq62BV6TE0kJ6
         +uD8E1R9bZmER3ghkj5+lfIOwN8Ffny1ZsgSS8Z8u3AJr76bL7bW5e6HeNJKE8a/zWpq
         PE1w==
X-Gm-Message-State: AOAM530cC68I2fH/57GXYp3fonPVOjm43JOgeM27WKZpg2QHnOBRT1jS
        d5JtX03u2y7raUxKB4Dojh/RyzCmwfs=
X-Google-Smtp-Source: ABdhPJytn1zt4yUAvG2Xy2x0xdjKws1zYkubnDwP0m/NMMyx73zCZ4lVqmQJUAPQ30MLzjQImOpftQ==
X-Received: by 2002:aa7:c398:: with SMTP id k24mr23161789edq.61.1615227130854;
        Mon, 08 Mar 2021 10:12:10 -0800 (PST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id p9sm3299928edu.79.2021.03.08.10.12.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 10:12:10 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id d15so12477471wrv.5
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 10:12:10 -0800 (PST)
X-Received: by 2002:adf:ee92:: with SMTP id b18mr22954054wro.275.1615227129949;
 Mon, 08 Mar 2021 10:12:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615199056.git.bnemeth@redhat.com> <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
 <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
 <718e4f13-31a8-037c-9725-08ae3cd93ccd@gmail.com> <543ebc518aa31f04bb6a85b66f37d984ede4b031.camel@redhat.com>
 <f1fc417e-946b-6e92-3650-865834c289f3@gmail.com>
In-Reply-To: <f1fc417e-946b-6e92-3650-865834c289f3@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 8 Mar 2021 13:11:30 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdZyePKSOz=r48VaoiF_yFGYxHFnh+FYYCh4KrOpPJ-xw@mail.gmail.com>
Message-ID: <CA+FuTSdZyePKSOz=r48VaoiF_yFGYxHFnh+FYYCh4KrOpPJ-xw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: avoid infinite loop in mpls_gso_segment when
 mpls_hlen == 0
To:     David Ahern <dsahern@gmail.com>
Cc:     Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 11:43 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/8/21 9:26 AM, Balazs Nemeth wrote:
> > On Mon, 2021-03-08 at 09:17 -0700, David Ahern wrote:
> >> On 3/8/21 9:07 AM, Willem de Bruijn wrote:
> >>>> diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
> >>>> index b1690149b6fa..cc1b6457fc93 100644
> >>>> --- a/net/mpls/mpls_gso.c
> >>>> +++ b/net/mpls/mpls_gso.c
> >>>> @@ -27,7 +27,7 @@ static struct sk_buff *mpls_gso_segment(struct
> >>>> sk_buff *skb,
> >>>>
> >>>>         skb_reset_network_header(skb);
> >>>>         mpls_hlen = skb_inner_network_header(skb) -
> >>>> skb_network_header(skb);
> >>>> -       if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
> >>>> +       if (unlikely(!mpls_hlen || !pskb_may_pull(skb,
> >>>> mpls_hlen)))
> >>>>                 goto out;
> >>>
> >>> Good cathc. Besides length zero, this can be more strict: a label
> >>> is
> >>> 4B, so mpls_hlen needs to be >= 4B.
> >>>
> >>> Perhaps even aligned to 4B, too, but not if there may be other
> >>> encap on top.

On second thought, since mpls_gso_segment pulls all these headers, it
is correct to require it to be a multiple of MPLS_HLEN.
