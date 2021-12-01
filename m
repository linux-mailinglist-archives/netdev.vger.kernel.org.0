Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948984644CE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhLACTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhLACTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:19:34 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836AAC061574;
        Tue, 30 Nov 2021 18:16:14 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id n6so45811495uak.1;
        Tue, 30 Nov 2021 18:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RteSdb/R0jAzB1lXUtH7yILGR4OkUHo/u21+WaN7Uc=;
        b=fdHDhoVcfJRyxCaPJ0r+dEuNkvh5NZMouiLAd8laOjYfj8vrye04yRNcNk4A5xyeKr
         e3F5UMAp9H5ofbLmOogsvzEHM8ntIsL/as0Tl0F4Lz1QKs9ZJkvR/Rn+xD0IQnc3feU9
         D+1KxQq3tlanTPLvBUszeVQxacrUaGif/3BJGVJ+D9TubPDN6//QMsIy+opwiDvCC2xo
         s7YMkjG4g7O4J1BpCLQ8Frayj6EBMh5n0msxPeybhL2RLl2sMIv/CeJSim+kA6eRSEmo
         6hEjSg8qLMTA+0/lM7SQIpXflgdrRsvB4PmHQylrKAbxzjAFod/SxeSUTaTftYsSZvq8
         W4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RteSdb/R0jAzB1lXUtH7yILGR4OkUHo/u21+WaN7Uc=;
        b=1WMTkqHTiLUhsaAaCoFAa+WcR5l7phNRpHPgmZPYAZ3j/6Qm01ZquCyxt5i25+LVZX
         /dbIURw+GKhgfSxNxuB9I4gPmoqkEkBfmfzGXm9WOLzuR8uAlCC+Afpy8VzxCTmrq/pD
         nDRqU7SRaY/v3CYLFj5VqZTKJbDZc3BCLC3XZtaA/XHpFkMoYM75DWwkCqwZ2uPprtsJ
         KwOrFOUO7OxOlp1xfFEKUnNqplsz9+uCRUUiVkWRxMws46NRVwMHZtreXyQAc7z26AHx
         5PncpxyjxuuoqjRtEp59bm02FPs5DVn3i8u5ArMFFozythopsNTQBMEHnqf6u70BUWbP
         epEA==
X-Gm-Message-State: AOAM533UusXzUPAVc9EO36U54DfJIPqK2fwrYiyU0Fou4m2YbwsarDkS
        yXZXiN34NzD2AlieUhNlkJgbT5ib5TUR7JJe1TE=
X-Google-Smtp-Source: ABdhPJwPsk0H7uL7kqrMTBV0zIRZYhIaGzzD3FpNJ9Gl1Az+2m03A8enSStCO9ubUBfV90oyYTjD0RZ+DZLRiOPdWbI=
X-Received: by 2002:a67:e114:: with SMTP id d20mr5058285vsl.5.1638324973624;
 Tue, 30 Nov 2021 18:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
 <20211201000215.1134831-2-luiz.dentz@gmail.com> <20211130171105.64d6cf36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130171105.64d6cf36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 30 Nov 2021 18:16:02 -0800
Message-ID: <CABBYNZJGpswn03StZb97XQOUu5rj2_GGkj-UdZWdQOwuWwNVXQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] skbuff: introduce skb_pull_data
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Nov 30, 2021 at 5:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 30 Nov 2021 16:02:01 -0800 Luiz Augusto von Dentz wrote:
> > From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> >
> > Like skb_pull but returns the original data pointer before pulling the
> > data after performing a check against sbk->len.
> >
> > This allows to change code that does "struct foo *p = (void *)skb->data;"
> > which is hard to audit and error prone, to:
> >
> >         p = skb_pull_data(skb, sizeof(*p));
> >         if (!p)
> >                 return;
> >
> > Which is both safer and cleaner.
>
> It doesn't take a data pointer, so not really analogous to
> skb_put_data() and friends which come to mind. But I have
> no better naming suggestions. You will need to respin, tho,
> if you want us to apply these directly, the patches as posted
> don't apply to either netdev tree.

I cross posted it to net-dev just in case you guys had some strong
opinions on introducing such a function, it was in fact suggested by
Dan but I also didn't find a better name so I went with it, if you
guys prefer we can merge it in bluetooth-next first as usual.

-- 
Luiz Augusto von Dentz
