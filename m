Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10175A1DB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF1RHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:07:24 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39188 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfF1RHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:07:23 -0400
Received: by mail-lf1-f67.google.com with SMTP id p24so4434406lfo.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vrV0dEwyk2LuSe6MmD0iqFfp+0OybudxsnVPHFscGuk=;
        b=XgU0I32QwxnqJMQU/Y/zPjlBDzTYke0s1vc6wj+BJA/lLgYABSFyQZASrTVQj/ahd5
         /XFhuUk0z+AirR8OB6pdC89jppmqEIvULUmSvzthbVf1JIEMZgoiOWxUfFtPTc3cgjQg
         YYlGPd6W0Z8rtMXWWfvqxq4F71dm+HS6U3Dpeap+koDLcnud2OTLn81c/Xqk6BdslgsU
         GcV+kHFKLb0Ww34nBMW5zNh2rEZaZaXxbS2qvHvD4X66Ru2vWmEF3+GJXntSzIo6IC6o
         Kk+9NNuMPNi+ZE1qIjhaVe/EknpUD/lM5sWlzn4oUgjnyB8fIan7xyWA6fjHHdA5BFfH
         f5Ew==
X-Gm-Message-State: APjAAAXksCJvVnh9T8EIB1qmp/j+JtT7JwbdNImkCKdX+k0DPvA6z/z+
        kBvmzfitCQNm3EUk92r/QoUF9hv6AuaHAQPCa3lG4VPD7OhrgA==
X-Google-Smtp-Source: APXvYqz2nrpriCXm3YK7rxMHPw1vV31LxgysWsxf3EfE1AuAUQWKd9l0BF81SEtXU0eEcRqmYJ3y6XlgymBer4iS+ho=
X-Received: by 2002:a19:ed07:: with SMTP id y7mr5813677lfy.56.1561741641146;
 Fri, 28 Jun 2019 10:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190626190343.22031-1-aring@mojatatu.com> <20190626190343.22031-2-aring@mojatatu.com>
 <293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com> <18557.1561739215@warthog.procyon.org.uk>
In-Reply-To: <18557.1561739215@warthog.procyon.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 28 Jun 2019 19:06:45 +0200
Message-ID: <CAGnkfhwe6p412q4sATwX=3ht4+NxKJDOFihRG=iwvXqWUtwgLQ@mail.gmail.com>
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

On Fri, Jun 28, 2019 at 6:27 PM David Howells <dhowells@redhat.com> wrote:
>
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>
> > David Howells was working on a mount notification mechanism:
> > https://lwn.net/Articles/760714/
> > https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=notifications
> >
> > I don't know what is the status of this series.
>
> It's still alive.  I just posted a new version on it.  I'm hoping, possibly
> futiley, to get it in in this merge window.
>
> David

Hi all,

this could cause a clash if I create a netns with name ending with .mounted.

$ sudo ip/ip netns add ns1.mounted
$ sudo ip/ip netns add ns1
Cannot create namespace file "/var/run/netns/ns1.mounted": File exists
Cannot remove namespace file "/var/run/netns/ns1.mounted": Device or
resource busy

If you want to go along this road, please either:
- disallow netns creation with names ending with .mounted
- or properly document it in the manpage

Regards,
-- 
Matteo Croce
per aspera ad upstream
