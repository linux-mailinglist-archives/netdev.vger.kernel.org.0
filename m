Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBB743E186
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhJ1NEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhJ1NEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:04:13 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A276C0613B9
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:01:46 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id x8so3846781oix.2
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A3PFuF6YvLBcLpDR2wBX2gm8p1PRn5ff3+97DYxaVOE=;
        b=REJWxnjRNMm3b2SNxFuOyFJm5Kky2tGBLRtTHdGMJQpEs66Cg7A4z9s3AVjOtoZyGH
         QJ6o6VNYtxR3jMiWx1s3dyCzWvH8b6Q+diSYsv/Rmx7jr9CanBgSnt14zKnqL4hqojWY
         u3/sinOenT9+fQyNQlekER3mANxZN20ufbKzdryAtvmtgQ+UpNvQ3ScfJHdqhfZgleBz
         Kr0jMRSFL554Y3NF736FSvFsv62hsHu3vU+mFTsGEUywPO3S3aayn4e/Wv+f58jnaSnm
         JtrGGhoyUvz8uYpKjAkBatqcMwnvs58+9x5/shB0B/TnrsEg3H7RT2NxOguornAVnr8i
         z9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A3PFuF6YvLBcLpDR2wBX2gm8p1PRn5ff3+97DYxaVOE=;
        b=e+vttb203F1mjlUhAjd8bmfFR7StR7A5zmg2Xe/9pISm9vFe+Op3Jr2tgL0vwnUOuM
         xbZiR2MOMAKrn/AxpOdF0Sq2+fy+zKDmy70jGCr7l5IYftr/aYY/OpkwBG8nr1ayXN+I
         KASTJDRE0MaMLXgS+ImsHXTcG3OBsPIpHGr8V9gJlmqmQouomncjUYsx0CGuZKZ5UR91
         D4QPZE9qO6l+Ru0jRQ0vNJxEwV/fQ3+TiMcoN7YMBMeZHdiPh5QcH1K6I+R+JPGt1kxD
         cMSPbwmDjFEwFckoCKIf9ec+eQw4/N7OCYnf3oHYjHCp8CJjP/D5rH5V2+roo4nJFPB6
         FmBQ==
X-Gm-Message-State: AOAM531Km0+O3iAXGprRVKrf7fgA0JI08eDqFZ4jOVEA+H8NueE8aXiN
        mW+6vFxG7rHaFPXy7nUZR1MpEhCWqN3TiRc4exD+6Q==
X-Google-Smtp-Source: ABdhPJwtTf2pAvokpijYpbMwmIt7HAzhD9jU4o+bGhJBmqWwSCnd3HeGQSvnphDQ9q7Ta/MXSsGvW9ZBxKKfe2d2Vg0=
X-Received: by 2002:a54:4390:: with SMTP id u16mr2780487oiv.109.1635426105697;
 Thu, 28 Oct 2021 06:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000058e2f605b6d2ad46@google.com> <000000000000b6cfc405cf4860a7@google.com>
In-Reply-To: <000000000000b6cfc405cf4860a7@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 28 Oct 2021 15:01:34 +0200
Message-ID: <CACT4Y+ZDvKgc7Z-qKVie2mvoEw9FpA8hEZ3NyRaLDf-KnK+J7A@mail.gmail.com>
Subject: Re: [syzbot] INFO: rcu detected stall in ieee80211_tasklet_handler
To:     syzbot <syzbot+7bb955045fc0840decd3@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, fweisbec@gmail.com, hdanton@sina.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 at 23:44, syzbot
<syzbot+7bb955045fc0840decd3@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 313bbd1990b6ddfdaa7da098d0c56b098a833572
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Sep 15 09:29:37 2021 +0000
>
>     mac80211-hwsim: fix late beacon hrtimer handling
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151766bab00000
> start commit:   835d31d319d9 Merge tag 'media/v5.15-1' of git://git.kernel..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9c32e23fada3a0e4
> dashboard link: https://syzkaller.appspot.com/bug?extid=7bb955045fc0840decd3
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e08125300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b17dde300000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: mac80211-hwsim: fix late beacon hrtimer handling
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks plausible:

#syz fix: mac80211-hwsim: fix late beacon hrtimer handling
