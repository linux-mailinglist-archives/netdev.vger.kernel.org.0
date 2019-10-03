Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B41CADB8
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfJCR6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:58:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41467 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbfJCR6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:58:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so2224284pfh.8
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3hQthO6lsPW8RRlhAk9IrovIeEkiWds5m8qIvV55R+c=;
        b=odf+AoESJ8mx+ysTYVvVr0XyZt0N28owHfGYhFX1UwxarbVqZ0vU4j4xQWT6rUOhn3
         Dqi12DmCOYAHNofFl0fo+8KB53/DKGuIL7Xw2PtcW/8gbtD07Dw7NMHA8Swiwxbggk0y
         diG2jYm4rMdrHHzwVrwql4omfWW8Hry5DPtyaLENaYMXpMeOqUSkx18m7j3Yc8ZLtYPN
         PXmJMV4x8wvSVh22zJ3BqWumlMzFjqejr1tFSmO9wqXxccU73k/iQoGhyXS1WQzrYujM
         udDsZDK5mrolQCoodPBGUPhQ5oYxTsUAGRXDlphe2LfzzjwU4V6QWgC+8OGTc9faIWPd
         B19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3hQthO6lsPW8RRlhAk9IrovIeEkiWds5m8qIvV55R+c=;
        b=r90bHW9YdSXnCA7JD3tIE7ZzTlPs4MpzbX8dUSmRd395dBrpyLzyJ9lcPAngSSWV0Q
         C24NQxwe1OiVVwOjY2qKC8T4bx9J00d2Lp0c09mgaAG1OwpnSUzzNBtWj+4yEoOim7oE
         AYpNKYjpeJORjA6vuZrswoABsg2jm0RQMBC2mfGWENxSPlPInxNdIGp6CTSzm0jGu/wX
         Gfa5iLO//wSZFFTWq6KvW6z27p1+MBHKhKIlaUAiLlzMaFfmRBDaiwBiJcFRExHPLAZE
         9lkLSzYx8oNjaunhxujTuAoPvL09t1dZmZ01DlHF+r9vH7bvoL26HOI2RrFzZ3SxQEVP
         kGTw==
X-Gm-Message-State: APjAAAV82D3Vh1wFziIlUcabeQEqR3aAae+N1FL0P8+PhdPfe1fDbwBW
        m1Uwqwg+gNLrFXbjnL2kMV6x4w==
X-Google-Smtp-Source: APXvYqwVjt79jy1JSYGuTINvBJpvLywL17Bl2CZcPoAXQYejyShispvcJFXxUKsryed9kMiXkfrcAQ==
X-Received: by 2002:aa7:9f0e:: with SMTP id g14mr12554603pfr.100.1570125529529;
        Thu, 03 Oct 2019 10:58:49 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s73sm2942765pjb.15.2019.10.03.10.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 10:58:48 -0700 (PDT)
Date:   Thu, 3 Oct 2019 10:58:48 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
Message-ID: <20191003175848.GE3223377@mini-arch>
References: <20191002173357.253643-1-sdf@google.com>
 <20191002173357.253643-2-sdf@google.com>
 <CAEf4BzZuEChOL828F91wLxUr3h2yfAkZvhsyoSx18uSFSxOtqw@mail.gmail.com>
 <20191003014356.GC3223377@mini-arch>
 <CAEf4BzZnWkdFpSUsSBenDDfrvgjGvBxUnJmQRwb7xjNQBaKXdQ@mail.gmail.com>
 <20191003160137.GD3223377@mini-arch>
 <CAEf4BzYbJZz7AwW_N=Q2b-V8ZQCJVTHeUaGo6Ji848aB_z8nXA@mail.gmail.com>
 <5d9633a2de69c_55732aec43fe05c41@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9633a2de69c_55732aec43fe05c41@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03, John Fastabend wrote:
> Andrii Nakryiko wrote:
> > On Thu, Oct 3, 2019 at 9:01 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 10/02, Andrii Nakryiko wrote:
> > > > On Wed, Oct 2, 2019 at 6:43 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > > >
> > > > > On 10/02, Andrii Nakryiko wrote:
> > > > > > On Wed, Oct 2, 2019 at 10:35 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > > >
> > > > > > > Always use init_net flow dissector BPF program if it's attached and fall
> > > > > > > back to the per-net namespace one. Also, deny installing new programs if
> > > > > > > there is already one attached to the root namespace.
> > > > > > > Users can still detach their BPF programs, but can't attach any
> > > > > > > new ones (-EPERM).
> > > >
> > > > I find this quite confusing for users, honestly. If there is no root
> > > > namespace dissector we'll successfully attach per-net ones and they
> > > > will be working fine. That some process will attach root one and all
> > > > the previously successfully working ones will suddenly "break" without
> > > > users potentially not realizing why. I bet this will be hair-pulling
> > > > investigation for someone. Furthermore, if root net dissector is
> > > > already attached, all subsequent attachment will now start failing.
> > > The idea is that if sysadmin decides to use system-wide dissector it would
> > > be attached from the init scripts/systemd early in the boot process.
> > > So the users in your example would always get EPERM/EBUSY/EXIST.
> > > I don't really see a realistic use-case where root and non-root
> > > namespaces attach/detach flow dissector programs at non-boot
> > > time (or why non-root containers could have BPF dissector and root
> > > could have C dissector; multi-nic machine?).
> > >
> > > But I totally see your point about confusion. See below.
> > >
> > > > I'm not sure what's the better behavior here is, but maybe at least
> > > > forcibly detach already attached ones, so when someone goes and tries
> > > > to investigate, they will see that their BPF program is not attached
> > > > anymore. Printing dmesg warning would be hugely useful here as well.
> > > We can do for_each_net and detach non-root ones; that sounds
> > > feasible and may avoid the confusion (at least when you query
> > > non-root ns to see if the prog is still there, you get a valid
> > > indication that it's not).
> > >
> > > > Alternatively, if there is any per-net dissector attached, we might
> > > > disallow root net dissector to be installed. Sort of "too late to the
> > > > party" way, but at least not surprising to successfully installed
> > > > dissectors.
> > > We can do this as well.
> > >
> > > > Thoughts?
> > > Let me try to implement both of your suggestions and see which one makes
> > > more sense. I'm leaning towards the later (simple check to see if
> > > any non-root ns has the prog attached).
> > >
> > > I'll follow up with a v2 if all goes well.
> > 
> > Thanks! I don't have strong opinion on either, see what makes most
> > sense from an actual user perspective.
> 
> 
> From my point of view the second option is better. The root namespace flow
> dissector attach should always happen first before any other namespaces are
> created. If any namespaces have already attached then just fail the root
> namespace. 
> 
> Otherwise if you detach existing dissectors from a container these were
> probably attached by the init container which might not be running anymore
> and I have no easy way to learn/find out about this without creating another
> container specifically to watch for this. If I'm relying on the dissector
> for something now I can seemingly random errors. So its a bit ugly and I'll
> probably just tell users to always attach the root namespace first to avoid
> this headache. On the other side if the root namespace already has a
> flow dissector attached and my init container fails its attach cmd I
> can handle the error gracefully or even fail to launch the container with
> a nice error message and the administrator can figure something out.
> I'm always in favor of hard errors vs trying to guess what the right
> choice is for any particular setup.
> 
> Also it seems to me just checking if anything is attached is going to make
> the code simpler vs trying to detach things in all namespaces.
Agreed, I was also leaning towards this option. Thanks!
