Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E44EC51F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfKAOzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:55:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38372 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfKAOzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:55:01 -0400
Received: by mail-io1-f65.google.com with SMTP id u8so11185148iom.5
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f12vuP0nBUFcZ780kKhktSOgCUAdlK4rkf+lIhXLJWw=;
        b=f+yu8fnAI1pqz1riMOLP3qh6MjJWsmyi1XYz5NPe4nLaDBQO26AlAT9g+XmaBTKm47
         a+6jTrL3bV6L5yl7OtWVkxAXXW5IdigEvdQjAo0tb1HJvDevIyub/Xg+Lr0q7AkSI7Ns
         h6ItiMkllJVox5/jyshScAWl6wv6aOOzTe7pFh1mRlWt3bnh3rw3u2QA7DbUrqw/DYIm
         1gmermhzVOSlmT4iv+MrhLq7g8e3tZq3WGvAHSBPblRU0SLCRv7h6V0SqbIHzTlWvKBu
         yiU6SN2gMk26naT4KjfhvGrvyMP8ZQT/J6WwIfhcS5/ER+kpgsJkyu+55XdGmj4Kw4vm
         uP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f12vuP0nBUFcZ780kKhktSOgCUAdlK4rkf+lIhXLJWw=;
        b=Df2vm0kyYkyzDN1BDK4yN9GI0Bk5d1hpMXgLVsr9K5dxJgB7VitgVzQckYOs5w5xWQ
         vILSSuvF+CPKI+HIfY1dXpGxkvYAS0/l+F/fsIfrMVrJXgQAY7wvFSowNcjqxiG+Onmt
         vFST+R/6ELBJoOhNnmilp2q+fkQCFrnp8l4IGwq83eumz3nSki+xU/14NoHW3dfEG6YX
         Vh59kCAuokK4xvLWxea0dE1z2Lv5YfqV4/RIlyyapeHJYf1wh7ZNSXdzHoWCHosOefos
         wlq9APVyXzusnUpRQhIhHAq+t+g829/VEJ+YSRPbjeyt6hOcULGHo+eIZ8Uk/OD3+h2B
         qwpw==
X-Gm-Message-State: APjAAAWA4wkp4vm8anUd7Q//JZxJzRwc/4LGtB2ay4t3vSlGaBaX0IEP
        KwtlKFc7+FFZeM7AHhzPILo632BRFgV2UrQxp2MLtFi4
X-Google-Smtp-Source: APXvYqzKQMeX5ymiR+wC58lyblp9ZN9M6u3v+D4Rfz83aJpL6oDegfUiyyx/+VCvxJSTP9x3hYfteIHFsgbyx7nVTnw=
X-Received: by 2002:a05:6602:2428:: with SMTP id g8mr10327646iob.246.1572620100162;
 Fri, 01 Nov 2019 07:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <1572548904-3975-1-git-send-email-john.hurley@netronome.com> <vbfeeyrycmo.fsf@mellanox.com>
In-Reply-To: <vbfeeyrycmo.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 1 Nov 2019 14:54:49 +0000
Message-ID: <CAK+XE==iPdOq65FK1_MvTr7x6=dRQDYe7kASLDEkux+D5zUh+g@mail.gmail.com>
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

On Fri, Nov 1, 2019 at 1:01 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Thu 31 Oct 2019 at 21:08, John Hurley <john.hurley@netronome.com> wrote:
> > When a new filter is added to cls_api, the function
> > tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
> > determine if the tcf_proto is duplicated in the chain's hashtable. It then
> > creates a new entry or continues with an existing one. In cls_flower, this
> > allows the function fl_ht_insert_unque to determine if a filter is a
> > duplicate and reject appropriately, meaning that the duplicate will not be
> > passed to drivers via the offload hooks. However, when a tcf_proto is
> > destroyed it is removed from its chain before a hardware remove hook is
> > hit. This can lead to a race whereby the driver has not received the
> > remove message but duplicate flows can be accepted. This, in turn, can
> > lead to the offload driver receiving incorrect duplicate flows and out of
> > order add/delete messages.
> >
> > Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
> > hash table per block stores each unique chain/protocol/prio being
> > destroyed. This entry is only removed when the full destroy (and hardware
> > offload) has completed. If a new flow is being added with the same
> > identiers as a tc_proto being detroyed, then the add request is replayed
> > until the destroy is complete.
> >
> > v1->v2:
> > - put tcf_proto into block->proto_destroy_ht rather than creating new key
> >   (Vlad Buslov)
> > - add error log for cases when hash entry fails. Previously it failed
> >   silently with no indication. (Vlad Buslov)
> >
> > Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> > Reported-by: Louis Peens <louis.peens@netronome.com>
> > ---
>
> Hi John,
>
> Patch looks good! However, I think we can simplify it even more and
> remove duplication of data in tcf_proto (hashtable key contains copy of
> data that is already available in the struct itself) and remove all
> dynamic memory allocations. I have refactored your patch accordingly
> (attached). WDYT?
>

Hi Vlad,
Thanks for the review/modifications.
The changes look good to me but I can fire it through our test setup to be sure.

The only thing I'm a bit concerned about here is the size of the
static allocation.
We are now defining quite a large hash table per block (65536 buckets).
It's hard to know exactly how many elements will be in this at the one time.
With flushes of large chains it may well become quite full, but I'd
expect that it will be empty a majority of the time.
Resizable hash seems a bit more appropriate here.
Do you have any opinions on this?

John

> [...]
>
