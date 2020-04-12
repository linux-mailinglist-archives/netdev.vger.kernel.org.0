Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF53D1A5ECB
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgDLNo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 09:44:58 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:36164 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgDLNo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 09:44:57 -0400
Received: by mail-il1-f194.google.com with SMTP id t8so1648559ilj.3;
        Sun, 12 Apr 2020 06:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYsC8YIiUn94Jux5CSjT7x5juT2k9650lk3hczfKxeU=;
        b=Oep9Bi1KORyB+M4gSQ9Ws2AopSAiNXqkK4Sl4EY0j4Qjao5GDHCT+b1ZNLWKxre3bl
         J0Cuvh+URweme+qqz/X2KQzSYLEbPPGZ+Fhf4JEH+62qeZSS0XMKE1zYZB5Gm6n7oOHe
         ai5WniXnSWug3aX3aC38jNkpnhk0X+S2H0SwDuAhoe7F7h2N9wH7Kpr9wrd27BEXtonN
         6QiGz1Cik42cnuVZumwh5DuSTZZ/SYQEB+RnDN3obW4B3V7exE5xbA8PL+X3oEFoZprR
         fS0WDjrB1/b5QUt+EUxb2ng+cyjybl5oimyeDEcS2Z347LxPFh8EI77UbG5YqDo31GwC
         6n9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYsC8YIiUn94Jux5CSjT7x5juT2k9650lk3hczfKxeU=;
        b=qS2fRr644Hi8fkqZZbFedWtt31OW4M4gJDEwE3Uk/Q03y/0PMuV8YiiqU8ot8ca3Br
         h/iWFYhOfgHaWPoXUgBZ51WHBks9fmgO0Lp0M1IwU9TDdy9yxrqftqz0zwU6cFFhnPx1
         SdRTDV8JE7iH+vN5XOzMmimah+pieOWSnFaoS4Tlt93VH9FhnhG1yD26yyHuyjEa8GDS
         Qcn86eFLfez8uExnCWbSHyaxcNlF/u0uPaSnAyabgoULoytiwL6QgJor/7PXuWR9S036
         P/K/QVyBHa8eeafJPr8T9aq4Gg+3p/sdKg9VsdkmpwKBHNXfuf9xZIGXyMLUHJ3qBWwL
         KfwA==
X-Gm-Message-State: AGi0PuanjFaLPxEj1dyEX4/F/xsqv7q51XGaq2ly6r95REBR5DXn4Wk4
        x5shgJXESUh3VlEKBQog2LwHajLXs6UqmqeovZA=
X-Google-Smtp-Source: APiQypLeUWHD17m1jcbll/fLl+WNlRp5MHeZrHx9Sis4ExawTsb46KBo0x4pr2nQB7+6GAnsRzgb5Hpcoi15NETpuKM=
X-Received: by 2002:a92:dc09:: with SMTP id t9mr11365390iln.308.1586699095577;
 Sun, 12 Apr 2020 06:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-3-christian.brauner@ubuntu.com> <CADyDSO54-GuSUJrciSD2jbSShCYDpXCp53cr+D7u0ZQT141uTA@mail.gmail.com>
 <20200409082659.exequ3evhlv33csr@wittgenstein> <CADyDSO54FV7OaVwWremmnNbTkvw6hQ-KTLJdEg3V5rfBi8n3Yw@mail.gmail.com>
 <20200412120300.vuigwofazxfbxluu@wittgenstein>
In-Reply-To: <20200412120300.vuigwofazxfbxluu@wittgenstein>
From:   David Rheinsberg <david.rheinsberg@gmail.com>
Date:   Sun, 12 Apr 2020 15:44:44 +0200
Message-ID: <CADyDSO7t7xXWmc=GJVbi6GWicuvDh_80tdYbWsneR7ZoTqE79A@mail.gmail.com>
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

Hi

On Sun, Apr 12, 2020 at 2:03 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
[...]
> On Sun, Apr 12, 2020 at 12:38:54PM +0200, David Rheinsberg wrote:
> > which scenario the limit would be useful. Anyone can create a user-ns,
> > create a new loopfs mount, and just happily create more loop-devices.
> > So what is so special that you want to restrict the devices on a
> > _single_ mount instance?
>
> To share that instance across namespaces. You can e.g. create the
> mount instance in one mount namespace owned by userns1, create a second
> user namespace usern2 with the same mapping which is blocked from
> creating additional user namespaces either by seccomp or by
> /proc/sys/user/max_user_namespaces or lsms what have you. Because it
> doesn't own the mount namespace the loopfs mount it is in it can't
> remount it and can't exceed the local limit.

Right. But now you re-use the userns-limit to also limit loopfs (or
other userns restrictions to limit loopfs access). Existing safe
setups allow contained processes to create their own user-namespace.
With your patchset merged, every such existing contained system with
userns-access gets access to a kernel API that allows them unbound
kernel memory allocations. I don't think you can tell every existing
system to not enable CONFIG_LOOP_FS. Or to make sure to install
seccomp filters before updating their kernels. Right? These setups
already exist, and they happily use distribution kernels.

I think there is no way around `struct user_struct`, `struct ucount`,
or whatever you like.

> > Furthermore, how do you intend to limit user-space from creating an
> > unbound amount of loop devices? Unless I am mistaken, with your
> > proposal *any* process can create a new loopfs with a basically
> > unlimited amount of loop-devices, thus easily triggering unbound
> > kernel allocations. I think this needs to be accounted. The classic
> > way is to put a per-uid limit into `struct user_struct` (done by
> > pipes, mlock, epoll, mq, etc.). An alternative is `struct ucount`,
> > which allows hierarchical management (inotify uses that, as an
> > example).
>
> Yeah, I know. We can certainly do this.

My point is, I think we have to.

[...]
> > With your proposed loop-fs we could achieve something close to it:
> > Mount a private loopfs, create a loop-device, and rely on automatic
> > cleanup when the mount-namespace is destroyed.
>
> With loopfs you can do this with the old or new mount api and you don't
> need to have loopfs mounted for that at all. Here's a sample program
> that works right now with the old mount api:

Yeah, loopfs would certainly allow this, and I would be perfectly
happy with this API. I think it is overly heavy for the use-case we
have, but I do acknowledge that there are other use-cases as well.
But I think your claim that "you don't need to have loopfs mounted" is
misleading. loopfs must be mounted for the entirety of the program.
Instead, you don't have to have it linked in your mount-namespace,
since you can immediately detach it. And with the new mount-APIs, you
don't even need it linked initially, as you can create a detached
mount right away.

Thanks
David
