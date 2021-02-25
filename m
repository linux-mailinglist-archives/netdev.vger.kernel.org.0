Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BFD3247D1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbhBYARx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhBYARu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:17:50 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE40C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 16:17:10 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id m188so3656486yba.13
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 16:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cV+K1B3T7+bLB8WquCUhoLS7xMKiF2FSDSxOu1BCl0I=;
        b=AAVAnMAq+qYI59bt3MUdi7ppypQHQ23af55aDLUVzeQENlP6nGmU1/jNrFyQc/j6VG
         8LVrgEG05Fft5a5Qr/PSc8HniysJW9qPeGj7QX+Bjd3HJtqSMJhJWT4rmWL6Mm0kvc9I
         FiUDMC+umuuwBqcCmgujVZlhWh7AD/VkZl2EcwgeBK07jRgLw+/lXQcTkrwpPAcQJQwN
         QddYZJt3NsrNDyea0tVp1Oj0T5GYvO6N+T08lpUR/fkHgTb/FG4ZEM6Mer2/fu267rxg
         b/Yk+A7ieDkFSGOGvVtf9/RdgHOH/fWtoKpBTx9yQMJAYZp3oB388/FkwDhpEpcdEWLy
         w/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cV+K1B3T7+bLB8WquCUhoLS7xMKiF2FSDSxOu1BCl0I=;
        b=ZAQ9/+2q7AJTkdrmxNTeZYvELSHm77Im9flF+wME0nQvrPcEE9pRCsUTl/ymEUM1q1
         OlFK4vucUtlbkwsvDLwOflre7NUGjPcwn5E7XAcdDrKhVSUc1tk1/kMdPnVDghYYOtHy
         MAEmJEudK2AURdDWLfhxGfCelMXR3xJ1QpIL9y+sTJxCII0EWWBIqWIgIsR8WQc2ntzz
         bS63ob9nMnsOXUIjrdHu7HPYwqIoHkgEaj8F6E6oX2ok4+1vshTdnB0XAmXMk/m/uf7q
         S5wbPEmLymwCuzpCe4VxI+pXSIilyYDQk7qxNSSUw8JLyYf811ThnU7wb1gTcBk91uFL
         Z/AA==
X-Gm-Message-State: AOAM530KzubCaTtugvL0/3NfSkxyh/w2PEUiKuvAh/jMh0V/8yqSZ3Z7
        qTHLXEZHCnS/ZYjkFYvqpuB7lUXyfrHGrQ7CfXGCtg==
X-Google-Smtp-Source: ABdhPJx1kDB2tV6vefCP6v+s/S2hM1grRKOOQZufxzatFimKSQP/1IQC6pw8p90RbOwwKiwzMAH/g49aCDEEyR30Hhc=
X-Received: by 2002:a25:bb8f:: with SMTP id y15mr286792ybg.139.1614212229263;
 Wed, 24 Feb 2021 16:17:09 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
In-Reply-To: <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 24 Feb 2021 16:16:58 -0800
Message-ID: <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 4:11 PM Alexander Duyck <alexanderduyck@fb.com> wro=
te:
>
>
>
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, February 24, 2021 4:07 PM
> > To: Eric Dumazet <edumazet@google.com>
> > Cc: Wei Wang <weiwan@google.com>; David S . Miller
> > <davem@davemloft.net>; netdev <netdev@vger.kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; Hannes Frederic Sowa
> > <hannes@stressinduktion.org>; Alexander Duyck
> > <alexanderduyck@fb.com>; Martin Zaharinov <micron10@gmail.com>
> > Subject: Re: [PATCH net] net: fix race between napi kthread mode and bu=
sy
> > poll
> >
> > On Thu, 25 Feb 2021 00:59:25 +0100 Eric Dumazet wrote:
> > > On Thu, Feb 25, 2021 at 12:52 AM Jakub Kicinski <kuba@kernel.org> wro=
te:
> > > > Interesting, vger seems to be CCed but it isn't appearing on the ML=
.
> > > > Perhaps just a vger delay :S
> > > >
> > > > Not really upsetting. I'm just trying to share what I learned
> > > > devising more advanced pollers. The bits get really messy really qu=
ickly.
> > > > Especially that the proposed fix adds a bit for a poor bystander
> > > > (busy
> > > > poll) while it's the threaded IRQ that is incorrectly not preservin=
g
> > > > its ownership.
> > > >
> > > > > Additional 16 bytes here, possibly in a shared cache line, [1] I
> > > > > prefer using a bit in hot n->state, we have plenty of them availa=
ble.
> > > >
> > > > Right, presumably the location of the new member could be optimized=
.
> > > > I typed this proposal up in a couple of minutes.
> > > >
> > > > > We worked hours with Alexander, Wei, I am sorry you think we did =
a
> > poor job.
> > > > > I really thought we instead solved the issue at hand.
> > > > >
> > > > > May I suggest you defer your idea of redesigning the NAPI model
> > > > > for net-next ?
> > > >
> > > > Seems like you decided on this solution off list and now the fact
> > > > that there is a discussion on the list is upsetting you. May I
> > > > suggest that discussions should be conducted on list to avoid such
> > situations?
> > >
> > > We were trying to not pollute the list (with about 40 different email=
s
> > > so far)
> > >
> > > (Note this was not something I initiated, I only hit Reply all button=
)
> > >
> > > OK, I will shut up, since you seem to take over this matter, and it i=
s
> > > 1am here in France.
> >
> > Are you okay with adding a SCHED_THREADED bit for threaded NAPI to be
> > set in addition to SCHED? At least that way the bit is associated with =
it's user.
> > IIUC since the extra clear_bit() in busy poll was okay so should be a n=
ew
> > set_bit()?
>
> The problem with adding a bit for SCHED_THREADED is that you would have t=
o heavily modify napi_schedule_prep so that it would add the bit. That is t=
he reason for going with adding the bit to the busy poll logic because it a=
dded no additional overhead. Adding another atomic bit setting operation or=
 heavily modifying the existing one would add considerable overhead as it i=
s either adding a complicated conditional check to all NAPI calls, or addin=
g an atomic operation to the path for the threaded NAPI.

Please help hold on to the patch for now. I think Martin is still
seeing issues on his setup even with this patch applied. I have not
yet figured out why. But I think we should not merge this patch until
the issue is cleared. Will update this thread with progress.
