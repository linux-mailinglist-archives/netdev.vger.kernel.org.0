Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353A814CA9E
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgA2MPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:15:34 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:60663 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbgA2MPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 07:15:34 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2d4a5f4a;
        Wed, 29 Jan 2020 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:content-type; s=mail; bh=bHEDAC
        llkomB/iUjyWoesygVpj8=; b=tDU0csZ7/+Q8X+BqhpGDOWRM/LU9VawEj5CMAi
        0PXYjh01kQ90u4h53BC6ThihbYwc5e/2srX8uIVUxEZC1uCp4Xy0YDdteDbD9Kwn
        fsYNY9IszTlCKWF15lN2N5ARLG9ZNgLqN63xkAdvLW5+5NFmZDTlbvubhTNlFRcY
        1FGVxb2rn0T6hGP0obgd3s8jRwc191f7yEwFnOR/18Y2xbmX6QhfB4pJTskcYA3x
        JH+TZdBxnS4YMxrXbACE7x53T85QhXpsHpnhRYwonO5oSPsG9mDkLDfJMSRUILoq
        g2rhOgoJUa1ifTRwPXJov5Ll2HWyowXtRRc24WVHP3lUDO/g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f27b5d92 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jan 2020 12:15:30 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id a15so15300601otf.1;
        Wed, 29 Jan 2020 04:15:31 -0800 (PST)
X-Gm-Message-State: APjAAAU9LfLcUwgIRHC3e+p/YA6dMZoEo/BGQ2zuRNIB53c3NPE/Adki
        cjoBmY3JQ++zmDyU8146F/JK6NOhSu6xwysj34I=
X-Google-Smtp-Source: APXvYqxJypQ1UgGrE8bjJimKMKeAtsELhQjFOTmf0/hm0fKoKjpfT8uV1Ak1niOk5q9jBXlP0X+2ln2EJz4pVUrEQkk=
X-Received: by 2002:a9d:811:: with SMTP id 17mr20808826oty.369.1580300130876;
 Wed, 29 Jan 2020 04:15:30 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 29 Jan 2020 13:15:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9rProfVf4VGHGX9no3KTa08nL_oYkK8Nv+eknk4ewVMAw@mail.gmail.com>
Message-ID: <CAHmME9rProfVf4VGHGX9no3KTa08nL_oYkK8Nv+eknk4ewVMAw@mail.gmail.com>
Subject: wireguard ci hooked up to quite a few kernel trees
To:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

With the merging of wireguard, I've hooked the project's CI up to
quite a few trees. We now have:

- net-next
- net
- linux-next
- linux (Linus' tree)
- wireguard-linux (my tree)
- wireguard-linux-compat (backports to kernels 3.10 - 5.5)

When the various pushes and pulls click a few more cranks through the
machinery, I'll probably add crypto and cryptodev, and eventually
Greg's stable trees. If anybody has suggestions on other relevant
trees that might help catch bugs as early as possible, I'm all ears.

Right now builds are kicked off for every single commit made to each
one of these trees, on x86_64, i686, aarch64, aarch64_be, arm, armeb,
mips64, mips64el, mips, mipsel, powerpc64le, powerpc, and m68k. For
each of these, a fresh kernel and miniature userland containing the
test suite is built from source, and then booted in qemu.

Even though the CI at the moment is focused on the wireguard test
suite, it has a habit of finding lots of bugs and regressions in other
weird places. For example, linux-next is failing at the moment on a
few archs.

I run this locally every day all day while developing kernel things
too. It's one command to test a full kernel for whatever thing I'm
working on, and this winds up saving a lot of time in development and
lets me debug things with printk in the dumbest ways possible while
still being productive and efficient.

You can view the current build status here:
https://www.wireguard.com/build-status/

This sort of CI is another take on the kernel CI problem; I know a few
organizations are doing similar things. I'd be happy to eventually
expand this into something more general, should there be sufficient
interest -- probably initially on networking stuff -- or it might turn
out that this simply inspires something else that is more general and
robust, which is fine too. Either way, here's my contribution to the
modicum of kernel CI things happening.

Regards,
Jason
