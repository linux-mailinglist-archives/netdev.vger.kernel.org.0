Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2A30B82B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhBBG5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbhBBG5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:57:03 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12B2C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:56:23 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id ew18so9444949qvb.4
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UOkJp4TyDm6k5mGRDEPNldOm6QTwM5DZytsoHH4gU28=;
        b=rzBdOlVAUAnkiL85YEOga79QFLq80X6BDD0ogoJ4PfUpE09gtAlg5Va7JQSe5Mye9b
         bY8CHhj+UxewHbMJcicqwll9E1gJuBw5mPv4UsiRSj+s1tBcix0GxXkoxNNMFpBZNTFP
         Y2DVj2XEdN76XSu3EUBdPYRrl0MK3qZPs92UHmDbMmk0Ooyky33VfPcSC3y17HjH9u9K
         ouzEp3sWVBKgdafbzYHc33eXJxQ8p8+k/+lVrwArX+W9rwtwUHueIpToGQgUdqjeCK02
         H7gBfwYgvPpnh7f0RXxDpV9OjTAzOearlCpECGX9oCclj6zJFTTIs6f4PY8FRHJWybHs
         hanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UOkJp4TyDm6k5mGRDEPNldOm6QTwM5DZytsoHH4gU28=;
        b=GeutL4gjogdnkvoLKA2T9kdIN5wlV96OgQIIdhhJbl+hk1Cx9xdkGJroAOYu54cnEw
         VOYfsYD4gMnsIt0sV0vcCu9llBLoO+jXPGRP2i3CfpFBBp1+NL2OvfZ4+i5stRH7sXZu
         L4eGjQUEAJhFvtFY3Z8UiNwrn23qqVEppofQ5xudKzjImsP5eaxStIRkBD+4gZ2NPDnY
         supDsql+ejWLFBkKwUp4VlGBC9iiNsRYEWRpRbq+zkGC9O2Hgf76eHFCvvyfbLOnlfNa
         IKqB8KtJe3O33NAnzP7EpBdxnXkvi9OzfYXSYgX0u0RMJ7Knx/THRnlIycASkmMk47iR
         Yi3g==
X-Gm-Message-State: AOAM531ZMhEdTCtgS3oX7xSG3WRvEg+RrKhV55rEy72f+ZC/00wqKHQp
        e9+I2OpVqYkc/YxxC66h02MvFCzeXQ1a9B29Y9Uckgxyzahxhg==
X-Google-Smtp-Source: ABdhPJwT+Lpz3zeKASMiOlTTqw3ZkGygmmngk0Adu/Et6s9tugnsczSLTXYA/zrofcXSEZY7G6COP51e7EhKejlbic0=
X-Received: by 2002:a05:6214:118e:: with SMTP id t14mr18757905qvv.50.1612248983034;
 Mon, 01 Feb 2021 22:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se> <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
 <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se> <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
 <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
 <20210201124414.21466bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <03621476-ed9b-a186-3b9a-774c703c207a@norrbonn.se>
In-Reply-To: <03621476-ed9b-a186-3b9a-774c703c207a@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Mon, 1 Feb 2021 22:56:12 -0800
Message-ID: <CAOrHB_D101x6H3U1e0gUZZd5-VqmPMbaczPwJY1GA=6LXGafDw@mail.gmail.com>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 9:24 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Jakub,
>
> On 01/02/2021 21:44, Jakub Kicinski wrote:
> > On Sat, 30 Jan 2021 12:05:40 -0800 Pravin Shelar wrote:
> >> On Sat, Jan 30, 2021 at 10:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>> On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:
> >>>> On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>>> Following are the reasons for extracting the header and populating metadata.
> >>>> 1. That is the design used by other tunneling protocols
> >>>> implementations for handling optional headers. We need to have a
> >>>> consistent model across all tunnel devices for upper layers.
> >>>
> >>> Could you clarify with some examples? This does not match intuition,
> >>> I must be missing something.
> >>
> >> You can look at geneve_rx() or vxlan_rcv() that extracts optional
> >> headers in ip_tunnel_info opts.
> >
> > Okay, I got confused what Jonas was inquiring about. I thought that the
> > extension headers were not pulled, rather than not parsed. Copying them
> > as-is to info->opts is right, thanks!
> >
>
> No, you're not confused.  The extension headers are not being pulled in
> the current patchset.
>
> Incoming packet:
>
> ---------------------------------------------------------------------
> | flags | type | len | TEID | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
> ---------------------------------------------------------------------
> <--------- GTP header ------<<Optional GTP elements>>-----><- Pkt --->
>
> The "collect metadata" path of the patchset copies 'flags' and 'type' to
> info->opts, but leaves the following:
>
> -----------------------------------------
> | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
> -----------------------------------------
> <--------- GTP header -------><- Pkt --->
>
> So it's leaving _half_ the header and making it a requirement that there
> be further intelligence down the line that can handle this.  This is far
> from intuitive.
>

The patch supports Echo, Echo response and End marker packet.
Issue with pulling the entire extension header is that it would result
in zero length skb, such packets can not be passed on to the upper
layer. That is the reason I kept the extension header in skb and added
indication in tunnel metadata that it is not a IP packet. so that
upper layer can process the packet.
IP packet without an extension header would be handled in a fast path
without any special handling.

Obviously In case of PDU session container extension header GTP driver
would need to process the entire extension header in the module. This
way we can handle these user data packets in fastpath.
I can make changes to use the same method for all extension headers if needed.
