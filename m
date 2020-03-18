Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52ECC18A511
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgCRU6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:58:46 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33733 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbgCRU47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:56:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id z65so32684311ede.0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g4AW1divsHMPr3pCP4CdP4Cl7K8Ooaeq6pBA6GUaETQ=;
        b=vKUVcXTVLCHqGtHDPpcfyVqC7Iyjswe5s6J8QA9fOEK3HpHui7X1QKcUp6EbQ9CrJA
         C05DjEwPknqFMwyMxVdqOASL4j0b74tzhGVN0rVlDcTqP9r+6muRk44tUHGBiJX0FH3l
         0kSJ6xSo1oAI9qxQ9gvTZog0w8m3+yD8qjRaTynTXcNhuDoADAvpXa2+efq0e6D5YD6n
         3CHbsifYNfb0CcekkOIbFkd9XH2x71AkNHltG81Un5wU3LND7OYeks7yEgdlSRFl1uJ5
         VwR+O1FlMTPjN3UY4K4PQO/XHK+MSLNlCxZ0KmE3m5D5D1kIPJi19WSDxOhR1iInmt9f
         77jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g4AW1divsHMPr3pCP4CdP4Cl7K8Ooaeq6pBA6GUaETQ=;
        b=pwtBJNfOQwvK5A5Tixw6yyhT4H3Bn/FnPvHsMS37x2PGU1cx22JoD7UgFwEKjkpm8V
         IdYhGzmLMprnMempw/SrYcsAK8ujM6DrRADr7wM1FOPuIdd7IZ9vZBrT938hQmVQPduG
         5R7yAG5wij+IKLXNqLWyecC7wFMyJTU3nHJW6XxcinGrO9KfZdGSNeAnIVGLiU28c567
         8Anrhls0qDzOTuN/9KzlpYMeCX9ZsODYLvQCr9CN6nq3TZgVS+sfUbPnfEpA6dm8kkc5
         VXw5eSWUrcgEh3Zdnqy/RqYMUuTdXGIZZDjnTR5RvVFZ9GXj1vtAnQBMen0yhZTw52t3
         zpog==
X-Gm-Message-State: ANhLgQ3GjZTrYl/aFI7Kh85t0UZROxlNSCKOwcCz+XMietzG+p35NQMR
        PAPYuv0Nx410pFkLJDm2jbaG+XjyKVpwJyGH3Pjq
X-Google-Smtp-Source: ADFU+vufKN/Y6D0NZVHBfHqWGsUn/HVoc7DCLKs6yGElrUkdM/dJMEcsEF5RKrrMdJTSmw7tnsN+cSFDtag+WxqrPu4=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr120333ejo.77.1584565017755;
 Wed, 18 Mar 2020 13:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <CAHC9VhS09b_fM19tn7pHZzxfyxcHnK+PJx80Z9Z1hn8-==4oLA@mail.gmail.com>
 <20200312193037.2tb5f53yeisfq4ta@madcap2.tricolour.ca> <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
 <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca>
In-Reply-To: <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 16:56:46 -0400
Message-ID: <CAHC9VhR2zCCE5bjH75rSwfLC7TJGFj4RBnrtcOoUiqVp9q5TaA@mail.gmail.com>
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

On Fri, Mar 13, 2020 at 2:59 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-13 12:29, Paul Moore wrote:
> > On Thu, Mar 12, 2020 at 3:30 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-02-13 16:44, Paul Moore wrote:
> > > > This is a bit of a thread-hijack, and for that I apologize, but
> > > > another thought crossed my mind while thinking about this issue
> > > > further ... Once we support multiple auditd instances, including the
> > > > necessary record routing and duplication/multiple-sends (the host
> > > > always sees *everything*), we will likely need to find a way to "trim"
> > > > the audit container ID (ACID) lists we send in the records.  The
> > > > auditd instance running on the host/initns will always see everything,
> > > > so it will want the full container ACID list; however an auditd
> > > > instance running inside a container really should only see the ACIDs
> > > > of any child containers.
> > >
> > > Agreed.  This should be easy to check and limit, preventing an auditd
> > > from seeing any contid that is a parent of its own contid.
> > >
> > > > For example, imagine a system where the host has containers 1 and 2,
> > > > each running an auditd instance.  Inside container 1 there are
> > > > containers A and B.  Inside container 2 there are containers Y and Z.
> > > > If an audit event is generated in container Z, I would expect the
> > > > host's auditd to see a ACID list of "1,Z" but container 1's auditd
> > > > should only see an ACID list of "Z".  The auditd running in container
> > > > 2 should not see the record at all (that will be relatively
> > > > straightforward).  Does that make sense?  Do we have the record
> > > > formats properly designed to handle this without too much problem (I'm
> > > > not entirely sure we do)?
> > >
> > > I completely agree and I believe we have record formats that are able to
> > > handle this already.
> >
> > I'm not convinced we do.  What about the cases where we have a field
> > with a list of audit container IDs?  How do we handle that?
>
> I don't understand the problem.  (I think you crossed your 1/2 vs
> A/B/Y/Z in your example.) ...

It looks like I did, sorry about that.

> ... Clarifying the example above, if as you
> suggest an event happens in container Z, the hosts's auditd would report
>         Z,^2
> and the auditd in container 2 would report
>         Z,^2
> but if there were another auditd running in container Z it would report
>         Z
> while the auditd in container 1 or A/B would see nothing.

Yes.  My concern is how do we handle this to minimize duplicating and
rewriting the records?  It isn't so much about the format, although
the format is a side effect.

-- 
paul moore
www.paul-moore.com
