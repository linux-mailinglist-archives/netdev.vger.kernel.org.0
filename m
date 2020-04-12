Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45EBA1A5E13
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 12:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgDLKjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 06:39:09 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34618 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgDLKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 06:39:08 -0400
Received: by mail-io1-f65.google.com with SMTP id f3so6565395ioj.1;
        Sun, 12 Apr 2020 03:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mB50ITuRAo45vr3yEb8CNvZ6X6/DqWAF63v0IHs/huk=;
        b=C70+d3ftVTHPJ4YDz5UWzWytEpPr478SefEVDz2ZHLx3PLV3IMFwjyAhOslonQ4jIB
         AR+AIDrKr4L2KJx2ybirfGiNixFdxEKqw2s9a80UXmMgaxnXCk8IwREAycKj7ikzeyPy
         JsnyvJyw3D0uHi4qgnTGxPsCk9H4HhZ9MNPdNnq1I0m0r+sxmyIl0Y7uCFRzcWeHZkEG
         o5P4PPGtJcccXZa2fm+EuCOj5D9Vx3UVOK463OSaq6BmLsRP4ATenR9LROvD/Hb/HgUP
         vEFXCiQOgi1mn8izS0eBazZaVUqhdWOwy6gat1SuxfGAJPBiHNnN7Wu1RxYc4mF0NP9s
         kJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mB50ITuRAo45vr3yEb8CNvZ6X6/DqWAF63v0IHs/huk=;
        b=JX75j1GgXh3BJvptmpWJvqywOfU9wYSWfJF937yaGrnMAZLuUA4vGbV5IJzF6bYD0w
         qe1A0Oe57G7wvTgv9bIGPQ96PhqOAyiDBdWVmD7/RWJR/Pj385eVokh7YmPhz5kI3nep
         qVc1YBer5G053+OUdRLWXXMWYx7oImIHM9itfaxde6Q45wZYMd6Gk/P03VcnSP48c9Ri
         ooxT6i1AbwbncSNU1qfMJPTFM/3yUqTXIkU9t9rpI2zRpCdz91rrnUdplZTPL2mDE5mJ
         zvcNYwW+kqDLkXKir4HmkftzqJg6BpLji5vEIP+ulioRcRMBfB/gmhtgW7GtNkgA93vN
         srfg==
X-Gm-Message-State: AGi0PuZhMsyuAHrHG72aeMi/aTCQePGixgw1eHmbTJuF/KReDZcXLDgH
        3nPcTUdkFH7LxaYcpsEyICVp+7aXXmcbV89oujsHe+6L
X-Google-Smtp-Source: APiQypIGAWmKLY3IBZTNsF7xonyMGYkQaY5+Bq/c8BhUrXrk0TMoDADZ4sRM0A+mpRjivLgKubtfP5yiY+od1UyhHn0=
X-Received: by 2002:a5e:cb02:: with SMTP id p2mr11839251iom.76.1586687945916;
 Sun, 12 Apr 2020 03:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-3-christian.brauner@ubuntu.com> <CADyDSO54-GuSUJrciSD2jbSShCYDpXCp53cr+D7u0ZQT141uTA@mail.gmail.com>
 <20200409082659.exequ3evhlv33csr@wittgenstein>
In-Reply-To: <20200409082659.exequ3evhlv33csr@wittgenstein>
From:   David Rheinsberg <david.rheinsberg@gmail.com>
Date:   Sun, 12 Apr 2020 12:38:54 +0200
Message-ID: <CADyDSO54FV7OaVwWremmnNbTkvw6hQ-KTLJdEg3V5rfBi8n3Yw@mail.gmail.com>
Subject: Re: [PATCH 2/8] loopfs: implement loopfs
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey

On Thu, Apr 9, 2020 at 10:27 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Thu, Apr 09, 2020 at 07:39:18AM +0200, David Rheinsberg wrote:
> > With loopfs in place, any process can create its own user_ns, mount
> > their private loopfs and create as many loop-devices as they want.
> > Hence, this limit does not serve as an effective global
> > resource-control. Secondly, anyone with access to `loop-control` can
> > now create loop instances until this limit is hit, thus causing anyone
> > else to be unable to create more. This effectively prevents you from
> > sharing a loopfs between non-trusting parties. I am unsure where that
> > limit would actually be used?
>
> Restricting it globally indeed wasn't the intended use-case for it. This
> was more so that you can specify an instance limit, bind-mount that
> instance into several places and sufficiently locked down users cannot
> exceed the instance limit.

But then these users can each exhaust the limit individually. As such,
you cannot share this instance across users that have no
trust-relationship. Fine with me, but I still don't understand in
which scenario the limit would be useful. Anyone can create a user-ns,
create a new loopfs mount, and just happily create more loop-devices.
So what is so special that you want to restrict the devices on a
_single_ mount instance?

> I don't think we'd be getting much out of a global limit per se I think
> the initial namespace being able to reserve a bunch of devices
> they can always rely on being able create when they need them is more
> interesting. This is similat to what devpts implements with the
> "reserved" mount option and what I initially proposed for binderfs. For
> the latter it was deemed unnecessary by others so I dropped it from
> loopfs too.

The `reserve` of devpts has a fixed 2-tier system: A global limit, and
a init-ns reserve. This does nothing to protect one container from
another.

Furthermore, how do you intend to limit user-space from creating an
unbound amount of loop devices? Unless I am mistaken, with your
proposal *any* process can create a new loopfs with a basically
unlimited amount of loop-devices, thus easily triggering unbound
kernel allocations. I think this needs to be accounted. The classic
way is to put a per-uid limit into `struct user_struct` (done by
pipes, mlock, epoll, mq, etc.). An alternative is `struct ucount`,
which allows hierarchical management (inotify uses that, as an
example).

> I also expect most users to pre-create devices in the initial namespace
> instance they need (e.g. similar to what binderfs does or what loop
> devices currently have). Does that make sense to you?

Our use-case is to get programmatic access to loop-devices, so we can
build customer images on request (especially to create XFS images,
since mkfs.xfs cannot write them, IIRC). We would be perfectly happy
with a kernel-interface that takes a file-descriptor to a regular file
and returns us a file-descriptor to a newly created block device
(which is automatically destroyed when the last file-descriptor to it
is closed). This would be ideal *to us*, since it would do automatic
cleanup on crashes.

We don't need any representation of the loop-device in the
file-system, as long as we can somehow mount it (either by passing the
bdev-FD to the new mount-api, or by using /proc/self/fd/ as
mount-source).

With your proposed loop-fs we could achieve something close to it:
Mount a private loopfs, create a loop-device, and rely on automatic
cleanup when the mount-namespace is destroyed.

Thanks
David
