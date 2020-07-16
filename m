Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A29221C0B
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 07:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGPFne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 01:43:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60285 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725844AbgGPFne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 01:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594878212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rMQuOOR/FgYUKMmBCkJ91hqdkU0gpIxVlrymTn/eb2U=;
        b=L+9xPps9MHlBVUQ6a0wdmabuNJiZhbOWLNWA4yiPgya+9k/JrJrwyJu6Ayh/J3Mkm9Wr7Q
        TRoenIRMfiZThzXRZDYm3n0y3zm35YH2ALUwUsA+B/L82zyNMZdkc1hCIxYQ1GgK4bsTaS
        hOzBjm6P09yQbA7Pb5uKKmQffBzGNqk=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-RVMVMzjmP_GoYlG9lElwdQ-1; Thu, 16 Jul 2020 01:43:30 -0400
X-MC-Unique: RVMVMzjmP_GoYlG9lElwdQ-1
Received: by mail-ot1-f72.google.com with SMTP id j37so2178880ota.4
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 22:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rMQuOOR/FgYUKMmBCkJ91hqdkU0gpIxVlrymTn/eb2U=;
        b=iDKs2Txs4tOsMDikhHLVgNoksrr9mDj0qN1xe4iOIdwOT0DvSntBdZJszU9IQ16216
         qLmznqFW3N+ek3/dRHGlLfSJjjA3gVX5DNyInu6VuK0LYivSaOOhkJt88ILRDfW3+NmB
         K08toyppuS/B3N15e7A3DJO+rDsPgmVyoMcHCrZt6qpIfmUXpuIAuiF2RuVigsmiaKbi
         jbE63kt5f+9QIl54D7mZuKim/fpcve4i+wWWjCMqtqZMHXLUcDFWE4cjTOgcri0R/68L
         h3vPvHS4B6dOghkgpklNDaRblJdtvcWmK5w3rP9V7HHVlc3npcynD2vbZ4iToOQpFIMV
         McRw==
X-Gm-Message-State: AOAM530biPX8KK0uGDD7vxrjCPYo6eDhXLhkx2juMWdypA44WwNFxF4x
        Rnl3NWCLIFe3wOkDvnyRYkXHO9uUi0mIzMveH0i8k3MUeqUc9vHcDg0jx/pZURX3wktgU4YR5sD
        lARF4LHxFLCYBUwlXvtyxP6E+c/j29pBB
X-Received: by 2002:a9d:6659:: with SMTP id q25mr2748566otm.330.1594878209165;
        Wed, 15 Jul 2020 22:43:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmwBvwTQq9INO2eg1TTgMKuCNJgnDNkW2slyl22XTwqYHtGkreGcf8PMG4J+Yh9XL4XoVDBKMnTZDxdYu218Y=
X-Received: by 2002:a9d:6659:: with SMTP id q25mr2748557otm.330.1594878208924;
 Wed, 15 Jul 2020 22:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713154118.3a1edd66@hermes.lan>
 <20200714002609.GB1140268@lunn.ch> <CAKfmpSdD2bupC=N8LnK_Uq7wtv+Ms6=e1kk-veeD24EVkMH7wA@mail.gmail.com>
 <20200716031842.GI1211629@lunn.ch>
In-Reply-To: <20200716031842.GI1211629@lunn.ch>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Thu, 16 Jul 2020 01:43:18 -0400
Message-ID: <CAKfmpSdSfrQjio2gSE7wSZnR82ROPwF4zH+Wyy4Xg-aOaOjvsQ@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 11:18 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jul 15, 2020 at 11:04:16PM -0400, Jarod Wilson wrote:
> > On Mon, Jul 13, 2020 at 8:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > Hi Jarod
> > >
> > > Do you have this change scripted? Could you apply the script to v5.4
> > > and then cherry-pick the 8 bonding fixes that exist in v5.4.51. How
> > > many result in conflicts?
> > >
> > > Could you do the same with v4.19...v4.19.132, which has 20 fixes.
> > >
> > > This will give us an idea of the maintenance overhead such a change is
> > > going to cause, and how good git is at figuring out this sort of
> > > thing.
> >
> > Okay, I have some fugly bash scripts that use sed to do the majority
> > of the work here, save some manual bits done to add duplicate
> > interfaces w/new names and some aliases, and everything is compiling
> > and functions in a basic smoke test here.
> >
> > Summary on the 5.4 git cherry-pick conflict resolution after applying
> > changes: not that good. 7 of the 8 bonding fixes in the 5.4 stable
> > branch required fixing when straight cherry-picking. Dumping the
> > patches, running a sed script over them, and then git am'ing them
> > works pretty well though.
>
> Hi Jarad
>
> That is what i was expecting.
>
> I really think that before we consider changes like this, somebody
> needs to work on git tooling, so that it knows when mass renames have
> happened, and can do the same sort of renames when cherry-picking
> across the flag day. Without that, people trying to maintain stable
> kernels are going to be very unhappy.

I'm not familiar enough with git's internals to have a clue where to
begin for something like that, but I suspect you're right. Doing
blanket renames in stable branches sounds like a terrible idea, even
if it would circumvent the cherry-pick issues. I guess now is as good
a time as any to start poking around at git's internals...

-- 
Jarod Wilson
jarod@redhat.com

