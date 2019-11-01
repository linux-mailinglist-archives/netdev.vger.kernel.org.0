Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9365EC598
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfKAP2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:28:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43897 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfKAP2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:28:12 -0400
Received: by mail-io1-f68.google.com with SMTP id c11so11265602iom.10
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 08:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCPLD3i3+dRuyoblXDbOm+/SSyE/ZZuWhvLohOhKZiY=;
        b=a1j3ovMvt99wt5sJDUpBjw6KtzzMg09dxPsrnoO6/XU9CNU1Bl3SDCvBqte9sJ824G
         PI+phHaG9NvmNNSX4QWwXsEcC6ynhTjSRzFndGbfHHQuMHKm2bI0l+qhuuoEqpW1asLD
         6mFothMchjUQ7EEShaxPYgLaoRQ9uCzPPPliagAW/BA+tGjVci3ySgD41br2zCDu1+qf
         awU3qhdWa+Pc5Enpz9VX1svTrf3IcrKD9Pa7PsqqlwE59TtBdKZybHv7beZldJT7OYne
         nPmCRhqfCsEQIZLExpegFVCrpN0S1dxmWf/4cIDgnpHAb//LbYjCvpUKLd0b/4AePSlW
         AvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCPLD3i3+dRuyoblXDbOm+/SSyE/ZZuWhvLohOhKZiY=;
        b=Vu+GeO8CAmos54zL3xTt3c1GSeMH4tw1RgyDsWBfeQG1MIeQIOFOlOAloSRzoeZkUE
         G6TUH5tdbn8tJq+P79GQ/CXuD+P1WCs6dvAVQbyjzqqONQr+cI0gA8RYKeU1LUst1Bsw
         Aq8PJdJupFIlNQ7rjyng5DnfMECelxWixvLOrK2hsgQnoLwHDEgNygpR7bZmYyjpIcSU
         ++0/zT587i/GOETK/GbcKoXAbuCRVVje3o/CmrDtCCgbREPk+zduYR1hV8cfpVIuVGMk
         3wL2es0h3JxZPKyxhH9PfBbfRAWu7JMveOZS9enDkWXuDRGipm5HlIhH42aBYudE6D67
         pyGQ==
X-Gm-Message-State: APjAAAXEZCptAxc8tNmnTfjKdiGMahmf8hBUJIeVWZsYL69dB65SOQlE
        z3efN6PmH8kUgm2ESpdekXdtVSVKBqSZFg2CnxJi6g==
X-Google-Smtp-Source: APXvYqxiN5Ltvl0rtIAcARA4yCzaQEXwGrr+ML5g7jPnQq7E0EBPSVk4VH3SvlnNp7hlPsi8c5wLs+LDBqZJg6DzxKc=
X-Received: by 2002:a5d:8905:: with SMTP id b5mr10630650ion.187.1572622089456;
 Fri, 01 Nov 2019 08:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <1572548904-3975-1-git-send-email-john.hurley@netronome.com>
 <vbfeeyrycmo.fsf@mellanox.com> <CAK+XE==iPdOq65FK1_MvTr7x6=dRQDYe7kASLDEkux+D5zUh+g@mail.gmail.com>
 <vbfd0eby6qv.fsf@mellanox.com>
In-Reply-To: <vbfd0eby6qv.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 1 Nov 2019 15:27:58 +0000
Message-ID: <CAK+XE=kV9xodyQj0URF+9zN=fO4hf=B7VzHwewNtVLVquC4udQ@mail.gmail.com>
Subject: Re: [RFC net-next v2 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 3:08 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Fri 01 Nov 2019 at 16:54, John Hurley <john.hurley@netronome.com> wrote:
> > On Fri, Nov 1, 2019 at 1:01 PM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >>
> >> On Thu 31 Oct 2019 at 21:08, John Hurley <john.hurley@netronome.com> wrote:
> >> > When a new filter is added to cls_api, the function
> >> > tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
> >> > determine if the tcf_proto is duplicated in the chain's hashtable. It then
> >> > creates a new entry or continues with an existing one. In cls_flower, this
> >> > allows the function fl_ht_insert_unque to determine if a filter is a
> >> > duplicate and reject appropriately, meaning that the duplicate will not be
> >> > passed to drivers via the offload hooks. However, when a tcf_proto is
> >> > destroyed it is removed from its chain before a hardware remove hook is
> >> > hit. This can lead to a race whereby the driver has not received the
> >> > remove message but duplicate flows can be accepted. This, in turn, can
> >> > lead to the offload driver receiving incorrect duplicate flows and out of
> >> > order add/delete messages.
> >> >
> >> > Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
> >> > hash table per block stores each unique chain/protocol/prio being
> >> > destroyed. This entry is only removed when the full destroy (and hardware
> >> > offload) has completed. If a new flow is being added with the same
> >> > identiers as a tc_proto being detroyed, then the add request is replayed
> >> > until the destroy is complete.
> >> >
> >> > v1->v2:
> >> > - put tcf_proto into block->proto_destroy_ht rather than creating new key
> >> >   (Vlad Buslov)
> >> > - add error log for cases when hash entry fails. Previously it failed
> >> >   silently with no indication. (Vlad Buslov)
> >> >
> >> > Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
> >> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> >> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> >> > Reported-by: Louis Peens <louis.peens@netronome.com>
> >> > ---
> >>
> >> Hi John,
> >>
> >> Patch looks good! However, I think we can simplify it even more and
> >> remove duplication of data in tcf_proto (hashtable key contains copy of
> >> data that is already available in the struct itself) and remove all
> >> dynamic memory allocations. I have refactored your patch accordingly
> >> (attached). WDYT?
> >>
> >
> > Hi Vlad,
> > Thanks for the review/modifications.
> > The changes look good to me but I can fire it through our test setup to be sure.
> >
> > The only thing I'm a bit concerned about here is the size of the
> > static allocation.
> > We are now defining quite a large hash table per block (65536 buckets).
> > It's hard to know exactly how many elements will be in this at the one time.
> > With flushes of large chains it may well become quite full, but I'd
> > expect that it will be empty a majority of the time.
> > Resizable hash seems a bit more appropriate here.
> > Do you have any opinions on this?
> >
> > John
>
> Yeah, I agree that 65536 buckets is quite an overkill for this. I think
> cls API assumes that there is not too many tp instances because they are
> attached to chain through regular linked list and each lookup is a
> linear search. With this I assume that proto_destroy_ht size can be
> safely reduced to 256 buckets, if not less. Resizable table is an
> option, but that also sounds like an overkill to me since linear search
> over list of chains attached to block or over list of tp's attached to
> chain will be the main bottleneck, if user creates hundreds of thousands
> of proto instances.
>

Yes, it's a valid point about the tp/chain lookup being the bottleneck
in cases of high usage.
Let's reduce the buckets to say 128 and avoid the need for rhash.
Thanks


> >
> >> [...]
> >>
