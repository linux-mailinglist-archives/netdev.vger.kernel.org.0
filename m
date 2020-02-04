Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222E4151586
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 06:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgBDFlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 00:41:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47135 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgBDFlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 00:41:02 -0500
Received: by mail-io1-f69.google.com with SMTP id 13so11014025iof.14
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 21:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=AM193aqkTInnm2sGLnq+KUrIMqtAH2ZiKkzgZdOGVwQ=;
        b=CBtJz8Mx2rrLIouYH5ol4FDMv/x16jbRXCnBihIfLiKAIEVNooFN+7q3p8OZUQjakT
         CDnbxFIJt+7zAZhKq42u/Rb3/DzLn/iaE01aYTjNeCgGvZLtd6OSY8aaz7zZ03tuxGbz
         APFPFqVziJMEHC7QOPxbGEQQA+FZCLdOlz2H5YhAyu3HjXTPjGhy4taZsPUhGT40S6jL
         FtHl8SAJfFIHnAE91n/D3dtIwqddzSpFU/F/PGYEgKU8IuDQEdLRwOdG6sucqxjtwpjI
         PaTiBFgBBIyVcttNtxxKvd5ipjkjmLC92TJTLNbCTXjJA8VGD10AW1cRAKafZV2ZIm1w
         3YbQ==
X-Gm-Message-State: APjAAAXJ9Q9DkTFz7m9R+R2DykpTbesYecS1SCjSKe+Zsvp9GON6mpyc
        AXUOEh4PtXzbCLigIrRet+tByjOpgk2hl4bU6asZPHSMgf6r
X-Google-Smtp-Source: APXvYqwvRwRXAdFpSeJjYEpr6KHxHErox1HBAN2yNAGNRqLGQTC61VxpwWiTrg0QVCAeJf2FuqLD24CFactmGu/hKq+lNVtjl291
MIME-Version: 1.0
X-Received: by 2002:a6b:24b:: with SMTP id 72mr20523024ioc.63.1580794861893;
 Mon, 03 Feb 2020 21:41:01 -0800 (PST)
Date:   Mon, 03 Feb 2020 21:41:01 -0800
In-Reply-To: <000000000000350337059db54167@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034bde7059db97cf4@google.com>
Subject: Re: inconsistent lock state in rxrpc_put_client_conn
From:   syzbot <syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 5273a191dca65a675dc0bcf3909e59c6933e2831
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jan 30 21:50:36 2020 +0000

    rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1182314ee00000
start commit:   3d80c653 Merge tag 'rxrpc-fixes-20200203' of git://git.ker..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1382314ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1582314ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b275782b150c86
dashboard link: https://syzkaller.appspot.com/bug?extid=3f1fd6b8cbf8702d134e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ac314ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec4c5ee00000

Reported-by: syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com
Fixes: 5273a191dca6 ("rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
