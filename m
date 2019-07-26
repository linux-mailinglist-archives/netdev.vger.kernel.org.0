Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA4E77384
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfGZVft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:35:49 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41122 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387559AbfGZVfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:35:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id 62so33153001lfa.8
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVmcZwFhu0VmRu42g2oqdHVRFxqVWleFTBghf3PdU0s=;
        b=auPaSao4Pu92MrHcL8ri0lwhHW+MxKtMjV1DpxAsA7pVZXiYOWxWxhMCN+yWqE/ApM
         N1RAQkb6zmoRJMBukop8ckoCwrxu+fdsXpdHaXZqjEngnR6ahHT+uJi/+bo3yEWp6UbC
         NE3E48fT2I4XCRhysWOc0g0KiUbHZXwqDqq8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVmcZwFhu0VmRu42g2oqdHVRFxqVWleFTBghf3PdU0s=;
        b=ciTPuaRZxiGufOFWKgRNJciO9lO4W47exRxEcGBTjZcwvPZzuoz8mZPMbkDSVfjgik
         plVY8nZyQVCsPClbl7a0daOCegyaBZPP2Zq2or+gCNTaHHP+X7XjD9LuaeOkCLOAnNB/
         P5Qu8KqWRvczX4UBR0HcBZ68Mx1YrTCHioDQ6I/O4OgNGWRor4zo37U0pDCGXDRrGGGB
         hJ8hIH/pC28JJdCt6rND97D5g5mM7FW3W3JIRszWRXk/PDwFXkWUAGjru68CWvU9g+2a
         avRhj7O9dZ+bnb7Co9GqSh5J0VVntxOQd8tezpduIXeIC4yiqQ4EG1NaX2fuPPBz/wiv
         fPzg==
X-Gm-Message-State: APjAAAW1UG0VApQNcVdR42VcARJo9x7wz5uOIo9srdvHmeMiOyWjpBBU
        Npbo8aGgjQi4hTIy/wIhco2APAO0fD0=
X-Google-Smtp-Source: APXvYqzkvrES3sMWcbUZnTdgk+IeNYYqDg43q7HIt0wlDPZerWzuk8NL/4VOKu2MF/c08645iHY5fQ==
X-Received: by 2002:ac2:514b:: with SMTP id q11mr20126134lfd.33.1564176943598;
        Fri, 26 Jul 2019 14:35:43 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id 24sm11896526ljs.63.2019.07.26.14.35.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 14:35:41 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id d24so52792110ljg.8
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 14:35:41 -0700 (PDT)
X-Received: by 2002:a2e:b003:: with SMTP id y3mr51555432ljk.72.1564176941127;
 Fri, 26 Jul 2019 14:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b4358f058e924c6d@google.com> <000000000000e87d14058e9728d7@google.com>
In-Reply-To: <000000000000e87d14058e9728d7@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Jul 2019 14:35:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whnM5+FBJuVoxXELvFgecuc0+vW7ibWy4Gc5qJbW8HL2Q@mail.gmail.com>
Message-ID: <CAHk-=whnM5+FBJuVoxXELvFgecuc0+vW7ibWy4Gc5qJbW8HL2Q@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in vhost_worker
To:     syzbot <syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        michal.lkml@markovi.net, "Michael S. Tsirkin" <mst@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        virtualization@lists.linux-foundation.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 8:26 AM syzbot
<syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 0ecfebd2b52404ae0c54a878c872bb93363ada36
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jul 7 22:41:56 2019 +0000
>
>      Linux 5.2

That seems very unlikely. That commit literally just changes the
EXTRAVERSION part of the version string.

So even if something actually depended on the version number, even
that wouldn't have triggered any semantic change.

              Linus
