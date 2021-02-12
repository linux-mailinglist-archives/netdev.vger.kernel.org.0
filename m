Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A631A514
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBLTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhBLTJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:09:54 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840F5C061574;
        Fri, 12 Feb 2021 11:09:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d15so354192plh.4;
        Fri, 12 Feb 2021 11:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTjy0dgeoHsEd0mGLVX1SE8z/D5vjwKGcESeectcBLc=;
        b=rj5BszzM2au4AQ+Otsuxp31NRq0tpKkqaTIIJ8y4nPBuWliKAZjLfYi0e2bf2/dQOr
         9cdKsKi8f+71jJoe9SBywDimkV8638aEAes7XUH3kNOY/4sbhWlbC48xnM51Pcpj3nGY
         R5dVuDnhGV9UxrGu6ynm/gslXLXskQ+42dHk6caIm+rYvbiomEkZDp15mA7W0NJXIwV3
         8mGNk4jUYu79XasALeGHKvpNw7ZGuno17UsKZZIp/gymRRErPomTEVKoJ7Nvfb9G1jW0
         bijnWC5yZriBY/Bj6ED1ZcbCNBRMtzGQbCI6Y0P0vSOU5om+9UV1SMvwHJqOoTwD5Sue
         WFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTjy0dgeoHsEd0mGLVX1SE8z/D5vjwKGcESeectcBLc=;
        b=bcrrRqSSsFLqdDX/gbx+RkSJLDCdUERvjR0/Jv4HKj9YDVdBJDIR10klmvz3InNEHD
         scKbBfb7FyvvWelYgxW2v2eUicG8PK3JRzyu5T58ZjtTzfrKWqYaV8CsZz8Ac6fkebpT
         BYqwfBiPDadv8OFk1FR5Euf8pLSbgIGxofMig3Q1lDw5ln4LoXluJ+ePM46BGId+05jk
         9rnrH/+OHUMgPHOHcTZWui58NDXrNL+e6asXKg1LiSWlenRcH5Wo+WUfT5IWh/25mdYT
         mTjAC+/JasEW7o4CJI+IKw3ESkiRZ7sGCNUKRRaFmeEc37FN1IuTpCElgZhXBHyY78Qg
         uAvw==
X-Gm-Message-State: AOAM533q1IA6occ1iqNuzfdak7OFhlnhIRwJ2hEeMseaBkA8+x94I3zw
        HBYfRJ9sG03P3ISvq4tOHXT59U5ZuswW+G+UqG/Aa2Ovv2tGVw==
X-Google-Smtp-Source: ABdhPJyxzKOmIQEC+MNX1nqq/ivhjMyrY5qmBW/373VwjwCZRtvvTt2mrOtf5Enq/U9h7jZvFczS/A1mUwD3zCy5/0A=
X-Received: by 2002:a17:90a:bc4b:: with SMTP id t11mr2880835pjv.52.1613156954045;
 Fri, 12 Feb 2021 11:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
 <20210210022136.146528-3-xiyou.wangcong@gmail.com> <CACAyw98HxkT99rA-PDSGqOyRgSxGoye_LQqR2FmK8M3KwgY+JQ@mail.gmail.com>
In-Reply-To: <CACAyw98HxkT99rA-PDSGqOyRgSxGoye_LQqR2FmK8M3KwgY+JQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 12 Feb 2021 11:09:03 -0800
Message-ID: <CAM_iQpUvaFry3Pj+tWoM9npMrARfQ=O=tmg7SkwC+m54G0T6Yg@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] skmsg: get rid of struct sk_psock_parser
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 2:56 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 10 Feb 2021 at 02:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > struct sk_psock_parser is embedded in sk_psock, it is
> > unnecessary as skb verdict also uses ->saved_data_ready.
> > We can simply fold these fields into sk_psock, and get rid
> > of ->enabled.
>
> Looks nice, can you use sk_psock_strp_enabled() more? There are a
> couple places in sock_map.c which test psock->saved_data_ready
> directly.

Its name tells it is for stream parser, so not suitable for others.

Are you suggesting to rename it to sk_psock_enabled() and use
it? Note it still has an additional !psock test, but I think that is fine
for slow paths.

Thanks.
