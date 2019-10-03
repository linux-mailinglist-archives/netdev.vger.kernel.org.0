Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D50CA9D5
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406052AbfJCRAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:00:03 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45051 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404232AbfJCRAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:00:02 -0400
Received: by mail-io1-f67.google.com with SMTP id w12so7133441iol.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LucIM4zExaBiBE5BPEs0shZO3Qv5TQYLzSGwm8iuz+k=;
        b=letJo8bvhCcv7SPkmAHSSCqjHJ1Z6lhtn6DBNpT3asV3d3Qx1ZYVVEJRDkg7XnqNCz
         LPSQtTTiSzG9TW6CUgpqaK+otOLZ21OT5+VA1qIIk+LaNWHnka0cIiNzhmXLN6FNDl1t
         tBCXVCFMR/spFo9ek6N6Clt3rFWgl7Kgzx592991ASTG376qS4cEmQ253hc9R4IOs+Q5
         Cnor3TIkqXgAuqTGXVHql86YaGc6Y+lsDFp3HI38480AFSyvbpelcz3ccddOqf9qyTl6
         rOQUF5RrdW+7ezQOAEdHwr/hH80pY8aVvXj+oHi7maPggBD8+MmJ6as8jqaCQgRXeMGl
         pM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LucIM4zExaBiBE5BPEs0shZO3Qv5TQYLzSGwm8iuz+k=;
        b=XUkZ8Is8XnyIYxxdtu+w6knxuZ3O2vcCJQlG+joTIyTQuPUgbgDyjcdLPFBHQcciUB
         bCeBbPTMag7r4gWGyNev5QyxZ6Hr4MWtY4IpUmwBhLxP2D1D4vWGYKPc5/OndAVLtyu2
         KEnfGArL6H8Qu3nKhXffS/c7QASR95siFVWfyKECS7COzVXDn2IQujH7b0DNPUbYzD4S
         wFNf0YNh5QWHhMRnwTQ0bGmCUmjw8Lxv7C0cT/eIb57Najrts1QeUe0Yft9Smy+uhv00
         a1uw0EDO8dUDq/9H7+j+xvLTNdQ1QWp613KMAVfqyguLumlL2dZsg21TRZyxAKNRLi6s
         PvkA==
X-Gm-Message-State: APjAAAV4gu6qLwBM9uPjZn8Dww3PpDS+nczK4zPafRax+5Jq0huBy/Ax
        8T8GzdLUECo8Rr4/TDzgq8KCV34mI4BZc7WEYEP2jg==
X-Google-Smtp-Source: APXvYqwlvMJnhDF+JqT71jbVYrw9O5RTG4tXJSvIkywLnxDWlZNp/SEP0aO51MKw2rshG9+u1OoueqfLW9UXJTEjCJU=
X-Received: by 2002:a92:9198:: with SMTP id e24mr10821540ill.195.1570122000943;
 Thu, 03 Oct 2019 10:00:00 -0700 (PDT)
MIME-Version: 1.0
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com> <vbfk19lokwe.fsf@mellanox.com>
In-Reply-To: <vbfk19lokwe.fsf@mellanox.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Thu, 3 Oct 2019 17:59:50 +0100
Message-ID: <CAK+XE=mjARd+DodNg9Sn4C+gg6dMTmvdNrKtEYhsLGVqtGrysw@mail.gmail.com>
Subject: Re: [RFC net-next 0/2] prevent sync issues with hw offload of flower
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 5:26 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wrote:
> > Hi,
> >
> > Putting this out an RFC built on net-next. It fixes some issues
> > discovered in testing when using the TC API of OvS to generate flower
> > rules and subsequently offloading them to HW. Rules seen contain the same
> > match fields or may be rule modifications run as a delete plus an add.
> > We're seeing race conditions whereby the rules present in kernel flower
> > are out of sync with those offloaded. Note that there are some issues
> > that will need fixed in the RFC before it becomes a patch such as
> > potential races between releasing locks and re-taking them. However, I'm
> > putting this out for comments or potential alternative solutions.
> >
> > The main cause of the races seem to be in the chain table of cls_api. If
> > a tcf_proto is destroyed then it is removed from its chain. If a new
> > filter is then added to the same chain with the same priority and protocol
> > a new tcf_proto will be created - this may happen before the first is
> > fully removed and the hw offload message sent to the driver. In cls_flower
> > this means that the fl_ht_insert_unique() function can pass as its
> > hashtable is associated with the tcf_proto. We are then in a position
> > where the 'delete' and the 'add' are in a race to get offloaded. We also
> > noticed that doing an offload add, then checking if a tcf_proto is
> > concurrently deleting, then remove the offload if it is, can extend the
> > out of order messages. Drivers do not expect to get duplicate rules.
> > However, the kernel TC datapath they are not duplicates so we can get out
> > of sync here.
> >
> > The RFC fixes this by adding a pre_destroy hook to cls_api that is called
> > when a tcf_proto is signaled to be destroyed but before it is removed from
> > its chain (which is essentially the lock for allowing duplicates in
> > flower). Flower then uses this new hook to send the hw delete messages
> > from tcf_proto destroys, preventing them racing with duplicate adds. It
> > also moves the check for 'deleting' to before the sending the hw add
> > message.
> >
> > John Hurley (2):
> >   net: sched: add tp_op for pre_destroy
> >   net: sched: fix tp destroy race conditions in flower
> >
> >  include/net/sch_generic.h |  3 +++
> >  net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
> >  net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++---------------------
> >  3 files changed, 61 insertions(+), 26 deletions(-)
>
> Hi John,
>
> Thanks for working on this!
>
> Are there any other sources for race conditions described in this
> letter? When you describe tcf_proto deletion you say "main cause" but
> don't provide any others. If tcf_proto is the only problematic part,

Hi Vlad,
Thanks for the input.
The tcf_proto deletion was the cause from the tests we ran. That's not
to say there are not more I wasn't seeing in my analysis.

> then it might be worth to look into alternative ways to force concurrent
> users to wait for proto deletion/destruction to be properly finished.
> Maybe having some table that maps chain id + prio to completion would be
> simpler approach? With such infra tcf_proto_create() can wait for
> previous proto with same prio and chain to be fully destroyed (including
> offloads) before creating a new one.

I think a problem with this is that the chain removal functions call
tcf_proto_put() (which calls destroy when ref is 0) so, if other
concurrent processes (like a dump) have references to the tcf_proto
then we may not get the hw offload even by the time the chain deletion
function has finished. We would need to make sure this was tracked -
say after the tcf_proto_destroy function has completed.
How would you suggest doing the wait? With a replay flag as happens in
some other places?

To me it seems the main problem is that the tcf_proto being in a chain
almost acts like the lock to prevent duplicates filters getting to the
driver. We need some mechanism to ensure a delete has made it to HW
before we release this 'lock'.

>
> Regards,
> Vlad
