Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F3A18A73C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCRVmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:42:43 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39824 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgCRVmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:42:43 -0400
Received: by mail-ed1-f66.google.com with SMTP id a43so10961678edf.6
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 14:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wywIpBmnfonP+SMsK60nELfMnC1movwf9uyeVdD853s=;
        b=T6mq9rK5P4XpQWpFfgAiIKi3lH6pQ6GrbiqcMaiWfr84rHUjaBgAPLyvhXpYETE4kf
         hcDCkpv1bWurwcrlC+pdyLmJ7HjGj+jJTTPLOsi6OPDpp0OhaCzlySAOEoFzgwsLyNve
         riGrdxe9qj9V/sK9YGkwAhJvugJjcnoZunY6ijk+/FC40Niqe/7YKhSYc/e0cJNueFZ6
         MLKmmruNYdIFErSAF28rG/44y7aci8x84AylNieoqtKWrsl83QneKNR/oymmyR1uTUtV
         2im+8o6LX4BTBghxmI4mwpR0taGPa67j5MS5vEGJtUTSOhmOUdMg9kiIEOBCoyS9T79h
         wuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wywIpBmnfonP+SMsK60nELfMnC1movwf9uyeVdD853s=;
        b=paY8jxoxLl5iocGh/QyN3PAJcb22jpCc04CFseYwf8BVHmiHuYNb2VY6q0K8crfS3a
         I5bunyyNFezS9Rn/yzdeFdX3BosRw8Ilnzfcv0gjR34/kCIE9x94/AafFUTgvNH7b2fD
         TMCh+XrfMJFLPT68I8Brjaevl42z6kXXoVyXWK+mLp3oZHefsuZMdhG3iUuwKhVy+zUU
         PAyFtzuf+uBAYe4JeLpEbo/l3p9eFDXr0Fbc2kHe1nveE7KmQ5/I6SeaUhJ29Eakg7rt
         yFlS8xNbcfGp1h7+GOOOH6dEF74y+hoVSjUZ98/zD/k9oy95APls8K5msgcBxFD4BgjZ
         INSw==
X-Gm-Message-State: ANhLgQ1NPQ8xrtA/WaGadAWZdpiZVgnvLEYfDCXS5Nlayhe1bIeFH7kb
        yn75rTdhhA1sH8dxUxD/NuhFthXD8w7Ek8TgDay9
X-Google-Smtp-Source: ADFU+vsFfxpWZoWPoQfNzQoKkFTZAgqPPLMBHZEXieGrsLv/NxY4XpzprF2kknyaJZWIiPi4S6FHLOmCkd5dO3fhL3E=
X-Received: by 2002:aa7:dd01:: with SMTP id i1mr5988476edv.164.1584567759671;
 Wed, 18 Mar 2020 14:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <CAHC9VhS09b_fM19tn7pHZzxfyxcHnK+PJx80Z9Z1hn8-==4oLA@mail.gmail.com>
 <20200312193037.2tb5f53yeisfq4ta@madcap2.tricolour.ca> <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
 <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca> <CAHC9VhR2zCCE5bjH75rSwfLC7TJGFj4RBnrtcOoUiqVp9q5TaA@mail.gmail.com>
 <20200318212630.mw2geg4ykhnbtr3k@madcap2.tricolour.ca>
In-Reply-To: <20200318212630.mw2geg4ykhnbtr3k@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 17:42:28 -0400
Message-ID: <CAHC9VhRYvGAru3aOMwWKCCWDktS+2pGr+=vV4SjHW_0yewD98A@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 5:27 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-18 16:56, Paul Moore wrote:
> > On Fri, Mar 13, 2020 at 2:59 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-13 12:29, Paul Moore wrote:
> > > > On Thu, Mar 12, 2020 at 3:30 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-02-13 16:44, Paul Moore wrote:
> > > > > > This is a bit of a thread-hijack, and for that I apologize, but
> > > > > > another thought crossed my mind while thinking about this issue
> > > > > > further ... Once we support multiple auditd instances, including the
> > > > > > necessary record routing and duplication/multiple-sends (the host
> > > > > > always sees *everything*), we will likely need to find a way to "trim"
> > > > > > the audit container ID (ACID) lists we send in the records.  The
> > > > > > auditd instance running on the host/initns will always see everything,
> > > > > > so it will want the full container ACID list; however an auditd
> > > > > > instance running inside a container really should only see the ACIDs
> > > > > > of any child containers.
> > > > >
> > > > > Agreed.  This should be easy to check and limit, preventing an auditd
> > > > > from seeing any contid that is a parent of its own contid.
> > > > >
> > > > > > For example, imagine a system where the host has containers 1 and 2,
> > > > > > each running an auditd instance.  Inside container 1 there are
> > > > > > containers A and B.  Inside container 2 there are containers Y and Z.
> > > > > > If an audit event is generated in container Z, I would expect the
> > > > > > host's auditd to see a ACID list of "1,Z" but container 1's auditd
> > > > > > should only see an ACID list of "Z".  The auditd running in container
> > > > > > 2 should not see the record at all (that will be relatively
> > > > > > straightforward).  Does that make sense?  Do we have the record
> > > > > > formats properly designed to handle this without too much problem (I'm
> > > > > > not entirely sure we do)?
> > > > >
> > > > > I completely agree and I believe we have record formats that are able to
> > > > > handle this already.
> > > >
> > > > I'm not convinced we do.  What about the cases where we have a field
> > > > with a list of audit container IDs?  How do we handle that?
> > >
> > > I don't understand the problem.  (I think you crossed your 1/2 vs
> > > A/B/Y/Z in your example.) ...
> >
> > It looks like I did, sorry about that.
> >
> > > ... Clarifying the example above, if as you
> > > suggest an event happens in container Z, the hosts's auditd would report
> > >         Z,^2
> > > and the auditd in container 2 would report
> > >         Z,^2
> > > but if there were another auditd running in container Z it would report
> > >         Z
> > > while the auditd in container 1 or A/B would see nothing.
> >
> > Yes.  My concern is how do we handle this to minimize duplicating and
> > rewriting the records?  It isn't so much about the format, although
> > the format is a side effect.
>
> Are you talking about caching, or about divulging more information than
> necessary or even information leaks?  Or even noticing that records that
> need to be generated to two audit daemons share the same contid field
> values and should be generated at the same time or information shared
> between them?  I'd see any of these as optimizations that don't affect
> the api.

Imagine a record is generated in a container which has more than one
auditd in it's ancestry that should receive this record, how do we
handle that without completely killing performance?  That's my
concern.  If you've already thought up a plan for this - excellent,
please share :)

-- 
paul moore
www.paul-moore.com
