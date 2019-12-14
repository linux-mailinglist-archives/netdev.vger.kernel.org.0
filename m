Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC911F39E
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 20:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfLNTIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 14:08:42 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43109 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfLNTIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 14:08:42 -0500
Received: by mail-ed1-f67.google.com with SMTP id dc19so1806966edb.10
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 11:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xl+V+XSiAFEVmw5fCtg75/r9D0U99JGQcElIcJcuNeU=;
        b=cw8veqWHif2mT6/sDjYfVhKSdvgE3m/1t4Kl0w9V4C5lZY/xueglJCzCX2m10NDezL
         vOwiNPNGb8OACFLonKk/saihZeDaEaSjlzbSuQey1xXpXhDXsiHahzBv4jPCMu8wUtqN
         HjTSMfdsKZ/BTWrzNoUKoTWQuODlxVoUMekfLLupOQkvfzPU4h8dZPVyeXkgf6xdGa2u
         GPZGtNyYR9+uc0MNrVtjiIest3vciIG+cFvj/pWo+V5/ZNR0iX3+sYoS378iZzoCWLxl
         6KNIgKaYH1JMaqycjDCUrYpLPOebSEva4wF4cCthGldSNkKUHWQ9Q2ZcWh61jkhErYrX
         7Q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xl+V+XSiAFEVmw5fCtg75/r9D0U99JGQcElIcJcuNeU=;
        b=MpWv6RJuSSruZA8talfUQmkPUwAbr79hoCrbkUcCtIhj+Uv/+7JBBPGUOYLC6IRnT2
         yXbcWcwfup8de+LPlQwuuR1XsuLO6aAzYBxDJIgvwJ9894t67JtwODy4y5Busvxyp/5a
         u/hlgjtkghoVHgF7Nl0YBk5yXlvrnX5H7xfX1ag7wwag28Dw1Ytwcne2tLpE/4L+tiEm
         gduol3ChQdsm7fbklsVYXStMeD7jAZ3enKs8bsVk5OCJDUjSd9yc1MClnk0lmu1wg2ZW
         DzQH7n88/nxDKtZ/XEd+ntZcMeHf6lag9SIgxFmTWBjvGdv9AWSO4RkiAVilejSnu2/i
         CbNw==
X-Gm-Message-State: APjAAAVmgYZGBKQxJ1gK9DnQEu3W1Guss+tiI6whe9amVtPOS8cLthjx
        MHqY5w3n+yOfwwggNFbxCjIFppFaNsLWectUX9AmYg==
X-Google-Smtp-Source: APXvYqzIKVDDfoJWa0MaKA9cXIbik+gI26j9zF4x+Aex90Z0Ht6tGyTlGGAsxONTOo7V6hvU7rtPaCTKwzrBKqa7Z3w=
X-Received: by 2002:a17:906:1e8b:: with SMTP id e11mr24085961ejj.305.1576350520549;
 Sat, 14 Dec 2019 11:08:40 -0800 (PST)
MIME-Version: 1.0
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-4-git-send-email-tom@herbertland.com> <20191006130526.c65ibu5hoizctaq6@netronome.com>
In-Reply-To: <20191006130526.c65ibu5hoizctaq6@netronome.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 14 Dec 2019 11:08:28 -0800
Message-ID: <CALx6S37Mejm1_nbwxJhKC3o5EY0gidTLuY5roepF2dKyXEB1eg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 3/7] ipeh: Generic TLV parser
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 6:05 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 03, 2019 at 02:58:00PM -0700, Tom Herbert wrote:
> > From: Tom Herbert <tom@quantonium.net>
> >
> > Create a generic TLV parser. This will be used with various
> > extension headers that carry options including Destination,
> > Hop-by-Hop, Segment Routing TLVs, and other cases of simple
> > stateless parsing.
> >
> > Signed-off-by: Tom Herbert <tom@herbertland.com>
> > ---
> >  include/net/ipeh.h        |  25 ++++++++
> >  net/ipv6/exthdrs.c        | 159 +++++++++++-----------------------------------
> >  net/ipv6/exthdrs_common.c | 114 +++++++++++++++++++++++++++++++++
> >  3 files changed, 177 insertions(+), 121 deletions(-)
> >
> > diff --git a/include/net/ipeh.h b/include/net/ipeh.h
> > index 3b24831..c1aa7b6 100644
> > --- a/include/net/ipeh.h
> > +++ b/include/net/ipeh.h
> > @@ -31,4 +31,29 @@ struct ipv6_txoptions *ipeh_renew_options(struct sock *sk,
> >  struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
> >                                         struct ipv6_txoptions *opt);
> >
> > +/* Generic extension header TLV parser */
> > +
> > +enum ipeh_parse_errors {
> > +     IPEH_PARSE_ERR_PAD1,            /* Excessive PAD1 */
> > +     IPEH_PARSE_ERR_PADN,            /* Excessive PADN */
> > +     IPEH_PARSE_ERR_PADNZ,           /* Non-zero padding data */
> > +     IPEH_PARSE_ERR_EH_TOOBIG,       /* Length of EH exceeds limit */
> > +     IPEH_PARSE_ERR_OPT_TOOBIG,      /* Option size exceeds limit */
> > +     IPEH_PARSE_ERR_OPT_TOOMANY,     /* Option count exceeds limit */
> > +     IPEH_PARSE_ERR_OPT_UNK_DISALW,  /* Unknown option disallowed */
> > +     IPEH_PARSE_ERR_OPT_UNK,         /* Unknown option */
> > +};
> > +
> > +/* The generic TLV parser assumes that the type value of PAD1 is 0, and PADN
> > + * is 1. This is true for Destination, Hop-by-Hop and current definition
> > + * of Segment Routing TLVs.
> > + */
> > +#define IPEH_TLV_PAD1        0
> > +#define IPEH_TLV_PADN        1
> > +
> > +bool ipeh_parse_tlv(const struct tlvtype_proc *procs, struct sk_buff *skb,
> > +                 int max_count, int off, int len,
> > +                 bool (*parse_error)(struct sk_buff *skb,
> > +                                     int off, enum ipeh_parse_errors error));
> > +
> >  #endif /* _NET_IPEH_H */
>
> Hi Tom,
>
> Unless I misread things, which is entirely possible, it seems
> as well as moving code around this patch changes behaviour under
> some error conditions via the parse_error callback and
> the ipv6_parse_error() implementation of it below.
>
> I think such a change is worth of at lest calling out in the changelog
> and perhaps braking out into a separate patch.
>
Okay, makes sense to split out the parse_error code. I also noticed
that there's no counter being bumped when we drop a HBH option, I'll
fix that.

> ...
