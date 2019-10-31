Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97EFEB1DF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfJaOAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:00:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43329 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfJaOAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:00:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id s4so6726804ljj.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 07:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DuatfVoIRwFhp1fiwVqEQDhLv5NKcD5+eL4mURteBJw=;
        b=T0WGQpXFDtrHJfxqFmxbHxIc4bAH6IQvZs0OTPR85eE1GuPEBycmk9QZ+dEad3gcBZ
         111Tl8gHMDWobnSVm/oAzghXtZ67XKZeU7Iv1i1wit1eJeMjOr73oWKibGez8sYJXCg5
         +cQOCUohhdbNghmuNdLDmn228db2gz+xBmkAIvJqZTSY4dHUXeEEkpIrb7ncIQmqboAt
         Z/ov5p25AUY1THMKi1DviI/uX3DGy8zd/T97zX+udzdtsfjL4srz+5gXsM7b01LCQpzv
         BX6g51anf+KwtwI58WA9i6Uh/aOtyToAeS5ZFqybf4ztcFcPzqIgUxpnTGSLbS4pEaEu
         btAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DuatfVoIRwFhp1fiwVqEQDhLv5NKcD5+eL4mURteBJw=;
        b=oHYEZEP3ife54kjJK9sB9KhA9m0JJScXq4crDWVho/Bwsa6DRHXbV8v08sPXPUTbJL
         RZjy42wQ9KOAnfvYtGfN2JwXK1KOwFxg7yElTkZBhEguH7E7Gaaz81DXhMx+ltAL+Y47
         /WTjkMI0cljgtxanoKgycdx2I9Sen071C3mrUXHZEKWMyGIAVgZ7K66yN2p5/DBENex6
         nOqFN1TZVV2Z2LWoGHYw5M5FjAnuCqfL8F0QzrKBs/9Qfg/zvRdriPL14sXyyWGceCvA
         g+uuDMER0GlNsv+PjPKM0pmlbDSQfxWoo/HPbjQHBUuZTfUbEmnYoe7Eg9sKmDUuhWoS
         /ctg==
X-Gm-Message-State: APjAAAU5ACFrjP57NG8KlYfKf8zz785tIkK7ZENepkVAfR0mjOwkZ/65
        NgPMK4GwpgI+STnAgwGTnKs72cl4I/PsDNUX3zag
X-Google-Smtp-Source: APXvYqwq2wNVb076m3Quvyq9PXqhSEvG470R+68J3/Y3Ahcr5xKs7JewCzfRlqwmRAqfj89jdi6yOS5N64nrB3PIo6A=
X-Received: by 2002:a05:651c:1056:: with SMTP id x22mr1097948ljm.225.1572530400425;
 Thu, 31 Oct 2019 07:00:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca> <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca> <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca> <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
 <20191024210010.owwgc3bqbvtdsqws@madcap2.tricolour.ca> <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
 <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
In-Reply-To: <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 31 Oct 2019 09:59:48 -0400
Message-ID: <CAHC9VhTKaBwFxEnY9vLRgtZ5ptQzF-WvwiAyVgtTNn6tt4bZqw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 6:04 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-30 16:27, Paul Moore wrote:
> > On Thu, Oct 24, 2019 at 5:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Here's the note I had from that meeting:
> > >
> > > - Eric raised the issue that using /proc is likely to get more and more
> > >   hoary due to mount namespaces and suggested that we use a netlink
> > > audit message (or a new syscall) to set the audit container identifier
> > > and since the loginuid is a similar type of operation, that it should be
> > > migrated over to a similar mechanism to get it away from /proc.  Get
> > > could be done with a netlink audit message that triggers an audit log
> > > message to deliver the information.  I'm reluctant to further pollute
> > > the syscall space if we can find another method.  The netlink audit
> > > message makes sense since any audit-enabled service is likely to already
> > > have an audit socket open.
> >
> > Thanks for the background info on the off-list meeting.  I would
> > encourage you to have discussions like this on-list in the future; if
> > that isn't possible, hosting a public call would okay-ish, but a
> > distant second.
>
> I'm still trying to get Eric's attention to get him to weigh in here and
> provide a more eloquent representation of his ideas and concerns.  Some
> of it was related to CRIU(sp?) issues which we've already of which we've
> already seen similar concerns in namespace identifiers including the
> device identity to qualify it.

Okay, let's leave this open until we hear from Eric to see if he has
any additional information, but it's going to need to be pretty
compelling.

> > At this point in time I'm not overly concerned about /proc completely
> > going away in namespaces/containers that are full featured enough to
> > host a container orchestrator.  If/when reliance on procfs becomes an
> > issue, we can look at alternate APIs, but given the importance of
> > /proc to userspace (including to audit) I suspect we are going to see
> > it persist for some time.  I would prefer to see you to drop the audit
> > container ID netlink API portions of this patchset and focus on the
> > procfs API.
>
> I've already refactored the code to put the netlink bits at the end as
> completely optional pieces for completeness so they won't get in the way
> of the real substance of this patchset.  The nesting depth and total
> number of containers checks have also been punted to the end of the
> patchset to get them out of the way of discussion.

That's fine, but if we do decide to drop the netlink API after hearing
from Eric, please drop those from the patchset.  Keeping the patchset
small and focused should be a goal, and including rejected/dead
patches (even at the end) doesn't help move towards that goal.

> > Also, for the record, removing the audit loginuid from procfs is not
> > something to take lightly, if at all; like it or not, it's part of the
> > kernel API.
>
> Oh, I'm quite aware of how important this change is and it was discussed
> with Steve Grubb who saw the concern and value of considering such a
> disruptive change.  Removing proc support for auid/ses would be a
> long-term deprecation if accepted.

As I mentioned, that comment was more "for the record" than you in
particular; I know we've talked a lot over the years about kernel API
stability and I'm confident you are aware of the pitfalls there. :)

-- 
paul moore
www.paul-moore.com
