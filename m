Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42975AD88
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 23:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfF2Vqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 17:46:36 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44026 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfF2Vqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 17:46:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id 16so9266727ljv.10
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 14:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xkEYc72WKRbMxn5L/m1epy636FdcowEH46eJVLsCsgI=;
        b=CNOHONwzA+LuXtd3Oxq0FB03X0eK8nEuE/GoNa8XvBFGfrOdkygfnaZEZNXIqwovLD
         oI3rx8X6rkr+rKo3iB5v69dNu1bfgLFhZ9Cng01axAV7QLpduDmy66Cgu4kW60zEflHE
         49MqsoIzfExbosVo8eASwKi4o+1VpSopyKfmAKp1dUH/DZ0wenur9a+yT+3snApY4exK
         VuWjhzNxhFylCrqkjGjuVp3jqFEOgPMfEfwEin8E6zCbggVeklh7uHZ405yIbwT8lSLE
         yDlyzSh/e8bLvPJsN+vU0p306D4J20XDkHaOb93+51v2N1oVxL6VZbVmmk0l5j1yrzQa
         3x8g==
X-Gm-Message-State: APjAAAVLu9DYtGYrMdYps56rBiCc8dEmu6JPfpRXCpop57dEiutuhdok
        +yDCtt1i5MuVpFQ53EAB2KykyT/8Kj+J5MVd0jhifFVuv7k=
X-Google-Smtp-Source: APXvYqzs+IPReceD2rzEsJnE/IkN+E6EJRWw+/EgGzGKxRG6U0Cq76ySy3Znw4J1ci5XIbj3n0mjZU+kzlgVbuHy2C8=
X-Received: by 2002:a2e:3e01:: with SMTP id l1mr9876346lja.208.1561844794156;
 Sat, 29 Jun 2019 14:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190626190343.22031-1-aring@mojatatu.com> <20190626190343.22031-2-aring@mojatatu.com>
 <293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com> <18557.1561739215@warthog.procyon.org.uk>
 <CAGnkfhwe6p412q4sATwX=3ht4+NxKJDOFihRG=iwvXqWUtwgLQ@mail.gmail.com>
In-Reply-To: <CAGnkfhwe6p412q4sATwX=3ht4+NxKJDOFihRG=iwvXqWUtwgLQ@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 29 Jun 2019 23:45:57 +0200
Message-ID: <CAGnkfhwKBaqE72A+0J-hLy_aWXvXWhW+tdvzOYJamM3V4iGiXA@mail.gmail.com>
Subject: Re: [RFC iproute2 1/1] ip: netns: add mounted state file for each netns
To:     David Howells <dhowells@redhat.com>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Aring <aring@mojatatu.com>,
        netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 7:06 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Fri, Jun 28, 2019 at 6:27 PM David Howells <dhowells@redhat.com> wrote:
> >
> > Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> >
> > > David Howells was working on a mount notification mechanism:
> > > https://lwn.net/Articles/760714/
> > > https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=notifications
> > >
> > > I don't know what is the status of this series.
> >
> > It's still alive.  I just posted a new version on it.  I'm hoping, possibly
> > futiley, to get it in in this merge window.
> >
> > David
>
> Hi all,
>
> this could cause a clash if I create a netns with name ending with .mounted.
>
> $ sudo ip/ip netns add ns1.mounted
> $ sudo ip/ip netns add ns1
> Cannot create namespace file "/var/run/netns/ns1.mounted": File exists
> Cannot remove namespace file "/var/run/netns/ns1.mounted": Device or
> resource busy
>
> If you want to go along this road, please either:
> - disallow netns creation with names ending with .mounted
> - or properly document it in the manpage
>
> Regards,
> --
> Matteo Croce
> per aspera ad upstream

BTW, this breaks the namespace listing:

# ip netns add test
# ip netns list
Error: Peer netns reference is invalid.
Error: Peer netns reference is invalid.
test.mounted
test

A better choice IMHO could be to create a temporary file before the
placeholder, and delete it after the bind mount, so an inotify watcher
can listen for the delete event.
For example, when creating the namespace "foo":

- create /var/run/netns/.foo.mounting
- create /var/run/netns/foo
- bind mount from /proc/.. to /var/run/netns/foo
- remove /var/run/netns/.foo.mounting

and exclude .*.mounting from the netns listing

Or, announce netns creation/deletion in some other way (dbus?).

Regards,
-- 
Matteo Croce
per aspera ad upstream
