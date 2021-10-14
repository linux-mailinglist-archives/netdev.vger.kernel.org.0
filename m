Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3642D62B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhJNJhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNJhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 05:37:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260F4C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 02:35:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r10so17329766wra.12
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 02:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8pRDUzeWH3PX+APszLVS7LOxK72vEpSEe248P0QwjWU=;
        b=bhYIUpg1+7mW0CRcZjyZDVv6rUv816JJQeitYSXdBK6ielhiZQqWf7PpIwfYIp1Vst
         IyQVazihjYizyMO+G0dQAMcdm+46W8oR/mUvyhKyd+3nRISclcLECvqTArOglcraJ+68
         zH9+WRXJpDgRZXqNMb1WnACtkIAERJGTT2jY0TAx+PgkbpywjcOkXINQq+x6oc/CEOKe
         SZKMWszJIF5gOzoFSjzUE4g3Q131R6Td0ZW866aa61mWzlE0MXpFj5oCKqGBqybln9oP
         qITlT1rVlFrmFqRwlfKAH5drB8EdjfGZkgLgRnVK/VvRbZznE5AmHIqwSEh1HktCRjZV
         feKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8pRDUzeWH3PX+APszLVS7LOxK72vEpSEe248P0QwjWU=;
        b=qxVSeKOrkg+m2MFmSg5O+ODqmhkRXQIJBgYtbZcMAi2WeLdtD6bQSBjq463I25qr8/
         3ZZiNOCYQEy/WnGDBtFRWhjXlGK+R7DqNyw7UoRUqKB0rdOke1JOlq4Kfn2hIoh5uLWS
         Xdv0bn7lA27i4JGT2W1AixaSrqJm7agh1NcHiLYjjLEuYBDPdczgJecdhqhoKG51YyLm
         nHRYpU9lAfX9oP9bEUVSFe9IieSvlN3PlYDtO23ykRxkglGXD89Ac9fIxgGhi8DUwY9G
         cYRYZ7SrT+Nn0BCHO3k7F1gTf9GisbcWQLecZwUXC9+xx9p7lSVMu43sfmWGRNHgfPxh
         0/Dw==
X-Gm-Message-State: AOAM532r2hL38M2SvjklMSCt4fifNVp/EF7rqG2waGi3T5S/Vnns5MGZ
        J5APUL8Bc9GmRyfNdqcVEB1/oaV+bQXnGMsL1oC+tgslwK21mg==
X-Google-Smtp-Source: ABdhPJxCJc1qQbk6PvVcS2XBSC5YMpSSYx5GSqOS0cWESdOJeCz554cgXa9wjkBdcoucoW2CE0VXIlKPFCJ8QfCMe8k=
X-Received: by 2002:a1c:f713:: with SMTP id v19mr4526677wmh.188.1634204133115;
 Thu, 14 Oct 2021 02:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <345b3f75bea482f7b3174297261db24cdf7e15e1.1634185497.git.lucien.xin@gmail.com>
 <46778adf-6a5c-17cd-94fd-285d954e8392@gmail.com>
In-Reply-To: <46778adf-6a5c-17cd-94fd-285d954e8392@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 14 Oct 2021 17:35:22 +0800
Message-ID: <CADvbK_eMQcw0iFt+VtaVGU-i20FPJFdHQb9XT4-H_J5rk7EW2g@mail.gmail.com>
Subject: Re: [PATCHv2 net] icmp: fix icmp_ext_echo_iio parsing in icmp_build_probe
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 12:43 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/13/21 9:24 PM, Xin Long wrote:
> > In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> > step by step and skb_header_pointer() return value should always be
> > checked, this patch fixes 3 places in there:
> >
> >   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
> >     from skb by skb_header_pointer(), its len is ident_len. Besides,
> >     the return value of skb_header_pointer() should always be checked.
> >
> >   - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
> >     skb_header_pointer(), and also do the return value check for
> >     skb_header_pointer().
> >
> >   - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
> >     ctype3_hdr.addrlen, skb_header_pointer() should be called first,
> >     then check its return value and ident_len.
> >     On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
> >     addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
> >     On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
> >     "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
> >     sizeof(struct in_addr)" or "ident_len".
> >
> > v1->v2:
> >   - To make it more clear, call skb_header_pointer() once only for
> >     iio->indent's parsing as Jakub Suggested.
> >
> > Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv4/icmp.c | 20 +++++++++-----------
> >  1 file changed, 9 insertions(+), 11 deletions(-)
> >
> > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > index 8b30cadff708..bccb2132a464 100644
> > --- a/net/ipv4/icmp.c
> > +++ b/net/ipv4/icmp.c
> > @@ -1057,11 +1057,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
> >       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
> >               goto send_mal_query;
> >       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
> > +     iio = skb_header_pointer(skb, sizeof(_ext_hdr),
> > +                              sizeof(iio->extobj_hdr) + ident_len, &_iio);
>
> ??? How has this been tested ???
This actually is difficult to cook a non-linear skb to be tested.
In the testing, if it's a linear skb, I realized it won't use &_iio memory.
when the value was greater than skb's len, it returned NULL.
when the value was less than skb's len, it just used skb->data memory.

>
> If you pass &_iio for last argument, then you _must_ use sizeof(__iio) (or smaller) too for third argument,
> or risk stack overflow, in the case page frag bytes need to be copied into _iio
>
> If the remote peer cooks a malicious packet so that ident_len is big like 1200,
> then for sure the kernel will crash,
> because sizeof(iio->extobj_hdr) + ident_len will be bigger than sizeof(_iio)
You're right, more check is needed before calling skb_header_pointer():

-       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
+       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr) ||
+           ntohs(iio->extobj_hdr.length) > sizeof(_iio))
                goto send_mal_query;
        ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
        iio = skb_header_pointer(skb, sizeof(_ext_hdr),

Thanks.
>
>
> > +     if (!iio)
> > +             goto send_mal_query;
> > +
> >       status = 0;
> >       dev = NULL;
> >       switch (iio->extobj_hdr.class_type) {
