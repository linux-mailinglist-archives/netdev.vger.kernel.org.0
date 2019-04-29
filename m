Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1956EBB4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 22:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfD2UgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 16:36:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32772 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfD2UgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 16:36:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id z6so761812wmi.0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 13:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2iEOU5kdQoYHAnD+f9Ty/sBTZWw1beOQsiZRZ679r8o=;
        b=xH+K+so7q9WZBWSvqWgG0Mh5C7ari3OKlCkGDB+/CRVaINdpEi+KHwbvbH015+3y76
         rrpIIrhDpt9gqCE511xnU83ukHIhf1Lu5lV2IxH0sS87ZI06bUmbbVYJLhtOAuQv68Ou
         ui292lmhRABnzqHw1BKZXjnSJ63DhWmVarKqNtHPlMKYkD1qFDCbHTkEoccS1cmMhjB/
         mW0X89SjQcOeTUgsRcILRkJNOAYHXi5JMq1leP6w3FCQuS0bm0dSQypegz37OJ/F9HUE
         cdHqCcjf7lraDcdUilN0SHgf96NXYprWJ8hKKP99x3tjPDxCPBrDNxURoEQ5dYufqOtn
         8kjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2iEOU5kdQoYHAnD+f9Ty/sBTZWw1beOQsiZRZ679r8o=;
        b=FAhmL490RMuBwuiCrolNC3cZsc6k8KLmVRhwH+7BqkO2YzDUTzAXtMRU65+2ZcOBgg
         kk4v5BMZ3a0FYpAWtkbuNeTfYcqMiDRz711J9KsrpPvKo8mhpPu6GCX/HmQsopb1q9qQ
         f9pJL08K23fsObTYBRH9CrXEisXCpENRxqUAsmOyKHHtBWIakjRGSUt2DA/hHGjn/j6s
         iYA2yQInwLX6+4485sIDuoJBvR9rEmkjoH3rIwXIEuAxHrHLwvkvFWQ78Nv+h0pDxe93
         I7Axh+RoYkA8KW736HR/qYs/hdKGFTc9firBTyoR/jdRxQdGM/iSwNrB2rSxpZvQRMlW
         EU7g==
X-Gm-Message-State: APjAAAWBwfUm0wn1JcEYMKw/6+YaPfmFcG4CCMS0o4Y+tdkzqICSoXEu
        SuAkJNafZ0XjyZJcmxMCPfLFq7QzJG5Uj/ijXnk6xqiU
X-Google-Smtp-Source: APXvYqz08Ylde7ivIHcaAslOGUrxKs/IpoAuvJ53vBM+lwuewkP4VJgrKh8m6spfc0doFLx96WS9CH7gb5z5/2dVueA=
X-Received: by 2002:a1c:c910:: with SMTP id f16mr562379wmb.47.1556570174963;
 Mon, 29 Apr 2019 13:36:14 -0700 (PDT)
MIME-Version: 1.0
References: <1556563576-31157-1-git-send-email-tom@quantonium.net>
 <1556563576-31157-5-git-send-email-tom@quantonium.net> <20190429123520.419ed9d4@hermes.lan>
In-Reply-To: <20190429123520.419ed9d4@hermes.lan>
From:   Tom Herbert <tom@quantonium.net>
Date:   Mon, 29 Apr 2019 13:36:03 -0700
Message-ID: <CAPDqMerHkVN5Rr6OQkp534usb9pR8z1X0eMKquBt475BChh6Ww@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 4/6] exthdrs: Add TX parameters
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tom Herbert <tom@herbertland.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 12:35 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 29 Apr 2019 11:46:14 -0700
> Tom Herbert <tom@herbertland.com> wrote:
>
> >  /* Default (unset) values for TLV parameters */
> >  static const struct tlv_proc tlv_default_proc = {
> > -     .params.rx_class = 0,
> > +     .params.r.class = 0,
> > +
> > +     .params.t.preferred_order = 0,
> > +     .params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
> > +     .params.t.user_perm = IPV6_TLV_PERM_NONE,
> > +     .params.t.class = 0,
> > +     .params.t.align_mult = (4 - 1), /* Default alignment: 4n + 2 */
> > +     .params.t.align_off = 2,
> > +     .params.t.min_data_len = 0,
> > +     .params.t.max_data_len = 255,
> > +     .params.t.data_len_mult = (1 - 1), /* No default length align */
> > +     .params.t.data_len_off = 0,
> >  };
>
> This looks cleaner if you skip the unnecessary 0 entries
> and also use additional {}.

Hi Stephen,

I sort of like being explict here to list all the fields to make it
easy to use as a template for adding new structures.

Tom

>
> static const struct tlv_proc tlv_default_proc = {
>         .params.t = {
>                 .admin_perm = IPV6_TLV_PERM_NO_CHECK,
>                 .user_perm = IPV6_TLV_PERM_NONE,
>                 .align_mult = 3,  /* Default alignment: 4n + 2 */
>                 .align_off = 2,
>                 .max_data_len = 255,
>         },
> };
>
>
