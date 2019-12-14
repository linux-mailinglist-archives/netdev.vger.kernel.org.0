Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7821F11F3A3
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 20:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfLNTT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 14:19:59 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:47102 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfLNTT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 14:19:59 -0500
Received: by mail-ed1-f66.google.com with SMTP id m8so1811845edi.13
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 11:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7QCBnhDtGDTW4QxtnwNG/GneoD6pSdnWnmBLV3DbUc=;
        b=Zf/bmAtf1upUJGSQAoqJg/2hr2bWPc43c225Oto24O/qObtSfVnnWXI1soYZn6m/jt
         QYgLzYQqOmKhlrTNUCnq4u41a3cJ3sUaEMHavDLEhZsc4rqk+EQM4sdULCis6J9af2kq
         n1jhGJROOXV4C50bi+GyOUoJ0fpAxjB/ifY2t0L+6IuwY3q7rEK3ZWvTnd6tc7m0UZqe
         X1oZ6tWnocdt55D1Bhz1PfbnUnlAW0p7PTiLkhMzQtEb6Z9lop6HNngYm+FBFMew1C9a
         eq6QrUS/CoNhlkndb6GJ6SqUFbVuuAxMsfAoJhsLBxkKk23ESfzwNJqKnm5ctIK9wKfz
         Sf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7QCBnhDtGDTW4QxtnwNG/GneoD6pSdnWnmBLV3DbUc=;
        b=atM/iHJt4IDH0brNc1Ip3uyJ+asIwSvAlAecmY4O6FLI/XoBlA6opfZFiSVdZs+hvr
         QcEtz+M1dxaW0oAihZJ1Y0fla3BXKRuyi3L+36YGVR4r0rAEB6G7TyuwPeL7CLRjApwd
         Bt18ayKaNFs/vnhEb3ztHS5WcbJTTBAsbMAJMgD9pWiafYmV2Wp+Vugao5g62uNaISc1
         +bloyVXB80dN4g+N27PR2dmLFt3QtAgRb5zo0UIAvrqu7lIzWUEJxg7ANU/e/JlEjVD0
         0CUSYnocoYwOmM2gd842greGxUjnGPfqyhTf/tJBtrhRvE0jgA+wRUSDpRqp2/7GAzqP
         j5Eg==
X-Gm-Message-State: APjAAAXieyKvwwe89gH2MD4ZJC4tibgfhNyRiZWXD3DDP3DuCyHE/uiT
        tvyTDZBYsJdqFpOJtFne70JUZSWEs3IbdzEYgrfsaA==
X-Google-Smtp-Source: APXvYqyCJqPX7ADnvrFLtuVgOh9PVwAOgTF8YeUo475vbRlMA7iEynUYBrvmGrUmrNEHJOBym2F1rk0HoIgm5+PO9VI=
X-Received: by 2002:a17:906:1e8b:: with SMTP id e11mr24136337ejj.305.1576351197022;
 Sat, 14 Dec 2019 11:19:57 -0800 (PST)
MIME-Version: 1.0
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-6-git-send-email-tom@herbertland.com> <20191006132547.stdd4hhj3y4dckqf@netronome.com>
In-Reply-To: <20191006132547.stdd4hhj3y4dckqf@netronome.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 14 Dec 2019 11:19:46 -0800
Message-ID: <CALx6S36RXXQgDqGGxnR=DRJyrweh5ARhS2YH1xHj9PJZb0AUNQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 5/7] ip6tlvs: Add TX parameters
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 6:25 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 03, 2019 at 02:58:02PM -0700, Tom Herbert wrote:
> > From: Tom Herbert <tom@quantonium.net>
> >
> > Define a number of transmit parameters for TLV Parameter table
> > definitions. These will be used for validating TLVs that are set
> > on a socket.
> >
> > Signed-off-by: Tom Herbert <tom@herbertland.com>
> > ---
> >  include/net/ipeh.h         | 18 ++++++++++++++++
> >  include/uapi/linux/ipeh.h  |  8 +++++++
> >  net/ipv6/exthdrs_common.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++-
> >  net/ipv6/exthdrs_options.c | 45 +++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 123 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/ipeh.h b/include/net/ipeh.h
> > index aaa2910..de6d9d0 100644
> > --- a/include/net/ipeh.h
> > +++ b/include/net/ipeh.h
>
> ...
>
> > @@ -54,6 +65,13 @@ struct tlv_param_table {
> >
> >  extern struct tlv_param_table ipv6_tlv_param_table;
> >
> > +/* Preferred TLV ordering for HBH and Dest options (placed by increasing order)
> > + */
> > +#define IPEH_TLV_PREF_ORDER_HAO                      10
> > +#define IPEH_TLV_PREF_ORDER_ROUTERALERT              20
> > +#define IPEH_TLV_PREF_ORDER_JUMBO            30
> > +#define IPEH_TLV_PREF_ORDER_CALIPSO          40
> > +
>
> Hi Tom,
>
> Could you expand on why thse values were chosen?
>
Pseudo random selection :-). The idea of having an ordering is to
constrain the use of TLVs (in some environments there may be TLV
ordering requirements or optimizations around specific ordering). Note
that the ordering only applies to validation of TLVs being set to
send, there are no ordering constraints in RX. Also, in the next patch
set where application can set individual HBH and DO options on a
socket, the ordering attribute is used to always produce the same
order on the wire regardless of the ordering that the application set
the options. For non-priviledeged applications especially, I believe
it's good to be conservative and apply reasonable constraints such as
ordering for TX (i.e. follow robustness principle).

> I can see that this patch implements a specific use of
> the 255 indexes available. But its not at all clear to me that
> this use fits expected use-cases (because I don't know what they are).
>
There are at more 253 non-padding option types. Fortunately the
protocol designers had the foresight to limit option type to a byte
and so it's reasonable to represent for lookup in simple arrays. Two
bytes for type would have been much more painful (compare lookup on
EtherType to IP protocol numbers for instance).

> ...
