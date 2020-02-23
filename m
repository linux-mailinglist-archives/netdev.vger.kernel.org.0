Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992B41692D8
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 02:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgBWBfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 20:35:45 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39843 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgBWBfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 20:35:45 -0500
Received: by mail-ed1-f66.google.com with SMTP id m13so7401854edb.6
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 17:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=20P6VASIF4kXfRxGqIIEpQkeQCJGweC3KQmcTkimeB8=;
        b=RTm5uGX/k3ITY+whCQAA9gNJQlCO2ccrxW7bPatxz5RysxYUoyBKUJQyI17tNp1my6
         dYqJYn+aQk9mPJ7BHPPbv+On5oUrc0mBKp9Zb3eF6JM0hXDdEPX2dMVYeBCUvn3NebzG
         Bh3X/gOaNPBAAz5wUZ3gqxd/XfB08PaQ1YConNfBeJ4wBPGGv1q9UrkRd0aueq5oyRBf
         QSItvuj9Ngw4iRUBu+3c0XqFBxS3m4PcmKSxjEjOjI5NXjow8Wb4nytvKIY3Z8Ur27cz
         MN32/dxEY8gBK2EPgM/zcnJ+e7jOYYufjVHY0UgvtWKG8xjWwThRuoPd1ElKzZ7P7Rjr
         XwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=20P6VASIF4kXfRxGqIIEpQkeQCJGweC3KQmcTkimeB8=;
        b=lIkKzWFe+S0TdHWXsJ9GPUtm1IMP0dW3SsenW/JOQvHcsTEFWhuZ3wyWRoqFauEDbn
         ykqcC+2P5dPCZ1GtoBJstmmaqyoT3cXY4gljiE2MeSXVeHJ9+GEFsmg11tXDwRZ+c3Pm
         wraFDJNO4sXExlcpssK/+4oWZXUDiqhc5cMoT+PO7w2qGBy4pjLa1ht/m8rjFa8Ya6zM
         B3n6JfnsS+4vbCm1ViqzXBpRlCsbA68y+ZBISMrNqWKseqyp42uMHKylGZBuhqRJcDKB
         3G8leisrR/2fnORM7O/KdjrGOFOJ7t90qM/MdOxTFSTSMTJdkzgFFZ/wOT10xVfZZO+l
         2kMg==
X-Gm-Message-State: APjAAAVRtnQcmuboIG50LvW+BKU88C4PiEAZMEZJsUkP93vlYry6Ozsv
        YXhVEw7OvPEpBspzAkiEq6GWprYpDeBX3Q2BtcRU
X-Google-Smtp-Source: APXvYqz8DJKS5CKcLnZfHxjXlihVmzI0hJTOjd6/HsN9rvUBib9qD32P32RQSfCFIFr+XM7mZe8f07VSy739INwIpBk=
X-Received: by 2002:a17:906:9352:: with SMTP id p18mr40572590ejw.95.1582421743723;
 Sat, 22 Feb 2020 17:35:43 -0800 (PST)
MIME-Version: 1.0
References: <0000000000008e18fb059f1fd725@google.com>
In-Reply-To: <0000000000008e18fb059f1fd725@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 22 Feb 2020 20:35:32 -0500
Message-ID: <CAHC9VhTKzn-OdmmvCRPQSNF2beaA6E7Cm0KkxN0u3UjA3OkyXA@mail.gmail.com>
Subject: Re: kernel BUG at arch/x86/mm/physaddr.c:LINE! (4)
To:     linux-audit@redhat.com
Cc:     Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+1f4d90ead370d72e450b@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 8:13 PM syzbot
<syzbot+1f4d90ead370d72e450b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    36a44bcd Merge branch 'bnxt_en-shutdown-and-kexec-kdump-re..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=12524265e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
> dashboard link: https://syzkaller.appspot.com/bug?extid=1f4d90ead370d72e450b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123d9de9e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1648fe09e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1f4d90ead370d72e450b@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at arch/x86/mm/physaddr.c:28!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 9873 Comm: syz-executor039 Not tainted 5.6.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__phys_addr+0xb3/0x120 arch/x86/mm/physaddr.c:28
> Code: 09 4c 89 e3 31 ff 48 d3 eb 48 89 de e8 36 e2 40 00 48 85 db 75 0f e8 8c e0 40 00 4c 89 e0 5b 41 5c 41 5d 5d c3 e8 7d e0 40 00 <0f> 0b e8 76 e0 40 00 48 c7 c0 10 50 a7 89 48 ba 00 00 00 00 00 fc
> RSP: 0018:ffffc90005b47490 EFLAGS: 00010093
> RAX: ffff8880944f4600 RBX: 0000000002777259 RCX: ffffffff8134ad32
> RDX: 0000000000000000 RSI: ffffffff8134ad93 RDI: 0000000000000006
> RBP: ffffc90005b474a8 R08: ffff8880944f4600 R09: ffffed1015d2707c
> R10: ffffed1015d2707b R11: ffff8880ae9383db R12: 0000778002777259
> R13: 0000000082777259 R14: ffff88809a765000 R15: 0000000000000010
> FS:  0000000001436880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200004c0 CR3: 0000000096da8000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  virt_to_head_page include/linux/mm.h:721 [inline]
>  virt_to_cache mm/slab.h:472 [inline]
>  kfree+0x7b/0x2c0 mm/slab.c:3749
>  audit_free_lsm_field kernel/auditfilter.c:76 [inline]
>  audit_free_rule kernel/auditfilter.c:91 [inline]
>  audit_data_to_entry+0xb7b/0x25f0 kernel/auditfilter.c:603
>  audit_rule_change+0x6b5/0x1130 kernel/auditfilter.c:1130
>  audit_receive_msg+0xda5/0x28b0 kernel/audit.c:1368
>  audit_receive+0x114/0x230 kernel/audit.c:1513

Ugh, I think I see the problem.

In audit_data_to_entry() the code sets both an audit_field->type and
an audit_field->val near the top of the big for-loop (lines 466 and
467 in Linus' tree as of now); if the type happens to be one of the
types which cause the lsm_str field to be kfree()'d (see
audit_free_lsm_field()), then we could run into problems if we end up
following an error path in audit_data_to_entry() before the lsm_str
field is populated with an actual string.

If the above reasoning proves to be correct, it looks like the problem
was caused by 219ca39427bf ("audit: use union for audit_field values
since they are mutually exclusive").

I'll see about working up a fix.

--
paul moore
www.paul-moore.com
