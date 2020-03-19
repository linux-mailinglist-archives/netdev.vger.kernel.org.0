Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A807F18BCE0
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgCSQma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:42:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28907 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbgCSQm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584636148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zOA+IMIU8Q7WJF49pLVV19IvK2l47KrbLmH0N3YKQfA=;
        b=i4xCU8o9Gv+e8dG31+nLJov9r66vhVMD4NBMQDBiH658ChLc0EKA94SGHCfekLf0K4/7xd
        GwGvEtxEpofadiDKS3el9SmIJiZpBcfjxJkW8pRMSUraZA7dMeWp0EpbpUtyTFVsZF6Q2r
        3+6DVcjCaxq26EI3HW8fHWXzpmP2S6g=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-BcWg29wLNiCjMzFdJ-3hsw-1; Thu, 19 Mar 2020 12:42:26 -0400
X-MC-Unique: BcWg29wLNiCjMzFdJ-3hsw-1
Received: by mail-io1-f70.google.com with SMTP id k5so2200808ioa.22
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 09:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOA+IMIU8Q7WJF49pLVV19IvK2l47KrbLmH0N3YKQfA=;
        b=VuSr5hu7T6RSdlBoTapbkpYFSOxOvu0hTI9eknRgFzc33hVTOsihmIBFfibxxNEw8i
         VIWR2IgqexHQ6xl622DX1iFmLmB9mXnSVdqE+72AlN15/mf26FvTo0A/V/+t6whr2L+2
         SVWKdztvMd+P0WXXnIgMqNvh6kzgNdoV9VOBgDhNOPX429TLldMAACcA6GGE6fc/KxXe
         sEy8lb+G8BCnxuzIppmXwDw7CB10xh6SJK+CxHUszgPVNrdYcj1gEUSFenqPjyLo8JgY
         +ln2bksUZ0RpZ7angFIL0RrsAHzgqVvphH3uuc2SevaMViDLLgJrSqTADw7OJIbVzdcE
         Wotw==
X-Gm-Message-State: ANhLgQ3Q1zyvsb7V29ut0o9Y0SnfDYUWGsi/u96yO0G/VbP7EHkWTxB5
        nbnZyvEIbxyo0/SbZKZoeEZd+8VGEHljK4P/VPtNbL7g/60/u5flq5tZLF3wM7W5xdGdoXOWWuw
        neWt9obiJg5kW8zq69ScxS+B3UwVxo6uG
X-Received: by 2002:a6b:be02:: with SMTP id o2mr3477760iof.39.1584636144620;
        Thu, 19 Mar 2020 09:42:24 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs8iofIYJ+iNpo9+omXOEAEZcpDGFzEXydxLKvQtkjHH4wpvAEyj5/8Q2KiQ1Qpj4eSOH80FA0MxKZjmfU4MgQ=
X-Received: by 2002:a6b:be02:: with SMTP id o2mr3477735iof.39.1584636144322;
 Thu, 19 Mar 2020 09:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200318140605.45273-1-jarod@redhat.com> <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com>
 <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com> <25629.1584564113@famine>
In-Reply-To: <25629.1584564113@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Thu, 19 Mar 2020 12:42:14 -0400
Message-ID: <CAKfmpScbzEZAEw=zOEwguQJvr6L2fQiGmAY60SqSBQ_g-+B4tw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 4:42 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >On Wed, Mar 18, 2020 at 2:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >> On 3/18/20 7:06 AM, Jarod Wilson wrote:
> >> > Bonding slave and team port devices should not have link-local addresses
> >> > automatically added to them, as it can interfere with openvswitch being
> >> > able to properly add tc ingress.
> >> >
> >> > Reported-by: Moshe Levi <moshele@mellanox.com>
> >> > CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
> >> > CC: netdev@vger.kernel.org
> >> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> >>
> >>
> >> This does not look a net candidate to me, unless the bug has been added recently ?
> >>
> >> The absence of Fixes: tag is a red flag for a net submission.
> >>
> >> By adding a Fixes: tag, you are doing us a favor, please.
> >
> >Yeah, wasn't entirely sure on this one. It fixes a problem, but it's
> >not exactly a new one. A quick look at git history suggests this might
> >actually be something that technically pre-dates the move to git in
> >2005, but only really became a problem with some additional far more
> >recent infrastructure (tc and friends). I can resubmit it as net-next
> >if that's preferred.
>
>         Commit
>
> c2edacf80e15 bonding / ipv6: no addrconf for slaves separately from master
>
>         should (in theory) already prevent ipv6 link-local addrconf, at
> least for bonding slaves, and dates from 2007.  If something has changed
> to break the logic in this commit, then (a) you might need to do some
> research to find a candidate for your Fixes tag, and (b) I'd suggest
> also investigating whether or not the change added by c2edacf80e15 to
> addrconf_notify() no longer serves any purpose, and should be removed if
> that is the case.
>
>         Note also that the hyperv netvsc driver, in netvsc_vf_join(),
> sets IFF_SLAVE in order to trigger the addrconf prevention logic from
> c2edacf80e15; I'm not sure if your patch would affect its expectations
> (if c2edacf80e15 were removed).

Interesting. We'll keep digging over here, but that's definitely not
working for this particular use case with OVS for whatever reason.

-- 
Jarod Wilson
jarod@redhat.com

