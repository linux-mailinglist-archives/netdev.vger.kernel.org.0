Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C443B5515AA
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbiFTKUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbiFTKTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:19:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4B313F85;
        Mon, 20 Jun 2022 03:19:53 -0700 (PDT)
Date:   Mon, 20 Jun 2022 12:19:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1655720391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+gOFJVRzxcO7qZkVW4n1+mq7b+cmJCRjJw0+qfAQR04=;
        b=jkej/6jbYDD+i0FdkqiDtrKRBeBfLjCBx30wGELUP6jIOrSdhMJH+QzRM+d/tTNISq5uJK
        a/IUz/OHK5tB+d8YbyA9SvR57+PrONE+MZ6IyFZJuTqnLhr045BqbvF1l+kIIuKeKQbJa+
        +LIWBJYkVR7lIER7wnZ98zNObi18kt8P6sqGBywAH1sMbscNih5JJErk10jGfRhPn2MRyF
        7i2scfCi7Npk4x/KWzu9yOikB3aVShV9zm9dS+TBaUrG6rkYtDn3bsSRF4tSlqlUec7OGD
        SfWlEfgh0cavN9rUogj56wYBxzjXVaGQdYtaMMxwFd+ZbfeT92Igx4ELcBevfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1655720391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+gOFJVRzxcO7qZkVW4n1+mq7b+cmJCRjJw0+qfAQR04=;
        b=LwUL2esLEgCBtMngnNlmv0aq9kVTLuPdvBF6fdd33HIrNIsSHykXPFffbw7FvK0v6pstTr
        jE0jd94D7hK2/gDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     syzbot <syzbot+b577bc624afda52c78de@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net,
        david@redhat.com, ebiederm@xmission.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, yhs@fb.com,
        linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 __vmalloc_node_range
Message-ID: <YrBJxrbq8Yvrpshj@linutronix.de>
References: <000000000000e57c2b05e1c03426@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <000000000000e57c2b05e1c03426@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: mm/page_alloc: protect PCP lists with a spinlock
#syz dup: BUG: sleeping function called from invalid context in relay_open_=
buf

The version of the patch above in next-20220614 is buggy leading to the
report below. The version in next-20220620 is fine. Not sure how to tell
syz bot this=E2=80=A6

On 2022-06-18 15:15:20 [-0700], syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    35d872b9ea5b Add linux-next specific files for 20220614
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D155b0d10080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd7bf2236c6bb2=
403
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Db577bc624afda52=
c78de
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+b577bc624afda52c78de@syzkaller.appspotmail.com
>=20
> BUG: sleeping function called from invalid context at mm/vmalloc.c:2980
=E2=80=A6
> Preemption disabled at:
> [<ffffffff81bc76f5>] rmqueue_pcplist mm/page_alloc.c:3813 [inline]
> [<ffffffff81bc76f5>] rmqueue mm/page_alloc.c:3858 [inline]
> [<ffffffff81bc76f5>] get_page_from_freelist+0x455/0x3a20 mm/page_alloc.c:=
4293

Sebastian
