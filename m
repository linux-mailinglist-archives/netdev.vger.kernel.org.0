Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1CF2B4466
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgKPNHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:07:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727212AbgKPNHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605532030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hp7/XGrMjjbxTryFPRwkhJ9mINX2i7AhQuO6lk+85Ik=;
        b=DCMa5AnSMLUNBJ9FJo41TzXUS3IOHeEtmq4MZsRcauDQDJLoO39RTdT8tx27LCO0x4C72Q
        sSWCrMacCuksnPRc2iFK79BI33rVOOvHlxhxdcrs/eBT90JA1qmz4LCwNwVN3IdKFXFDc7
        rt00zMQfUQyJd11U3Ho5baViOq4Mw9Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-DPOOzGJXNCimYk12iC0D7Q-1; Mon, 16 Nov 2020 08:07:08 -0500
X-MC-Unique: DPOOzGJXNCimYk12iC0D7Q-1
Received: by mail-wr1-f72.google.com with SMTP id h13so5672220wrr.7
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 05:07:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hp7/XGrMjjbxTryFPRwkhJ9mINX2i7AhQuO6lk+85Ik=;
        b=tTLJ0lprAE3f3CVvazgqocnzGj2nIWfcvsyGxC1AGBCH8drVYrmeDRjFMZry8zAKzc
         1ENsIVoKrAI8/VkKH4ORSWJg/KH9+arV9PgiOwLYhmssPeSOE0yfxh8SK7NwGiS9mwNW
         vJw/O5CY3soSEKtRwviwzkeY9Xlu77ldTyxyNwh3Q5iH1TPJ7pUFgzyAe6iL3TC1zrpp
         WU9zk59tUvPls2US+6nAub/7lk3wjJxkNThEn9hlHWbetqZXEa6/H/zrFN4Qwbov/Nqb
         HoHH7U3pFqsFoHDfe0TtUT3+gUGCFarZC60+m2pLHfujd8PLUg5uAsdRxBNJxphGJ1Xz
         UL/g==
X-Gm-Message-State: AOAM530Yvl2VewCwD1mUtj2u6V76nbl5dJalyVpY23UtIA/lJv1p28Jj
        AnC269iqKeXlY3sqdR3zQwEq5D/8vinX8BZK0YgbnQRFA5Thxk1bgKz06dWJj3SFzZbSBGIt7ih
        KhN3DC8OmKeeTR8eQnHIOiDkBootUO9iJ
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr19572632wrp.142.1605532026810;
        Mon, 16 Nov 2020 05:07:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyE0w188WkdB7Bp/Nkxx892OynTXXfN5PEDQwR4CfhprUKR2rGevw9tw4aHr6ZggEnGX56or9k+Codlm4pIusk=
X-Received: by 2002:adf:f2c7:: with SMTP id d7mr19572601wrp.142.1605532026600;
 Mon, 16 Nov 2020 05:07:06 -0800 (PST)
MIME-Version: 1.0
References: <20201109072930.14048-1-nusiddiq@redhat.com> <20201109213557.GE23619@breakpoint.cc>
 <CAH=CPzqTy3yxgBEJ9cVpp3pmGN9u4OsL9GrA+1w6rVum7B8zJw@mail.gmail.com>
 <20201110122542.GG23619@breakpoint.cc> <CAH=CPzqRKTfQW05UxFQwVpvMSOZ7wNgLeiP3txY8T45jdx_E5Q@mail.gmail.com>
 <20201110131141.GH23619@breakpoint.cc>
In-Reply-To: <20201110131141.GH23619@breakpoint.cc>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Mon, 16 Nov 2020 18:36:52 +0530
Message-ID: <CAH=CPzrBY3_nt7OmhFk2D+7ajZvxOFcE6tZRSd_hYmhpDTcRZA@mail.gmail.com>
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp flag
 - BE_LIBERAL per-ct basis.
To:     Florian Westphal <fw@strlen.de>
Cc:     ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 6:41 PM Florian Westphal <fw@strlen.de> wrote:
>
> Numan Siddique <nusiddiq@redhat.com> wrote:
> > On Tue, Nov 10, 2020 at 5:55 PM Florian Westphal <fw@strlen.de> wrote:
> > >
> > > Numan Siddique <nusiddiq@redhat.com> wrote:
> > > > On Tue, Nov 10, 2020 at 3:06 AM Florian Westphal <fw@strlen.de> wrote:
> > > > Thanks for the comments. I actually tried this approach first, but it
> > > > doesn't seem to work.
> > > > I noticed that for the committed connections, the ct tcp flag -
> > > > IP_CT_TCP_FLAG_BE_LIBERAL is
> > > > not set when nf_conntrack_in() calls resolve_normal_ct().
> > >
> > > Yes, it won't be set during nf_conntrack_in, thats why I suggested
> > > to do it before confirming the connection.
> >
> > Sorry for the confusion. What I mean is - I tested  your suggestion - i.e called
> > nf_ct_set_tcp_be_liberal()  before calling nf_conntrack_confirm().
> >
> >  Once the connection is established, for subsequent packets, openvswitch
> >  calls nf_conntrack_in() [1] to see if the packet is part of the
> > existing connection or not (i.e ct.new or ct.est )
> > and if the packet happens to be out-of-window then skb->_nfct is set
> > to NULL. And the tcp
> > be flags set during confirmation are not reflected when
> > nf_conntrack_in() calls resolve_normal_ct().
>
> Can you debug where this happens?  This looks very very wrong.
> resolve_normal_ct() has no business to check any of those flags
> (and I don't see where it uses them, it should only deal with the
>  tuples).
>
> The flags come into play when nf_conntrack_handle_packet() gets called
> after resolve_normal_ct has found an entry, since that will end up
> calling the tcp conntrack part.
>
> The entry found/returned by resolve_normal_ct should be the same
> nf_conn entry that was confirmed earlier, i.e. it should be in "liberal"
> mode.

I debugged a bit. Calling nf_ct_set_tcp_be_liberal() in ct_commit
doesn't work because
  - the first SYN packet during connection establishment is committed
to the contract.
  - but tcp_in_window() calls tcp_options() which clears the tcp ct
flags for the SYN and SYN-ACK packets.
    And hence the flags get cleared.

So I think it should be enough if openvswitch calls
nf_ct_set_tcp_be_liberal() once the connection is established.


I posted v2. Request to take a look.

Thanks
Numan

>

