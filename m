Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD222466B
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgGQWkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:40:05 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46502 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQWkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 18:40:04 -0400
Received: by mail-io1-f70.google.com with SMTP id z65so7456830iof.13
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bZyN/zZkAna3AuJV7mJCywjPBma23V/L6XGmPytQX3g=;
        b=ceihZpbk215dOrpQZPu7jsoc9yf5laf5Rx33nbjdRkG+JtSpg1Xb98WxazX1mMn1Zj
         wq5uZdW5A8zSN6lAaWdrfRss4K4S9kfU7iw+1OiQyCSTKnHznbmv+trv2ATiufaTRpAf
         iAPl2NIOetKZc/gtho+RqPXXRWVpo1lGgJSpXz/pz/5kJhK51kACLNPpyNRePdtlZJn3
         sCyvjHmwd7yWM/5obkFZu926syimswtiYSPXJAg6YvNgOVQ/B0o7+ekCfqTmOcLcqsRL
         BbkH5YbSIvdSsDhUwdnEvcoEezvoSbDxpD6+UoQ1fex6T4ybaQ15laIYuBgmWpiHcXvL
         lU/w==
X-Gm-Message-State: AOAM530SL50QMB307TvUJ2jZA61y0emEVu79Pj1rud1z3gN+cOEoF8ev
        /qjK86quw5hijwrgitOB5tMuClkBPwR3oyPRmJiMHBjfSEsg
X-Google-Smtp-Source: ABdhPJxLi7/gPDf4MlcBV9h1ItF5n6fCkgiWG0/+rbnSHUtonUG5WWXjJHmQs62JK8/EaZk4B+A2cmhJTAcbiYpEg6/zYnrU6Ale
MIME-Version: 1.0
X-Received: by 2002:a05:6638:dcf:: with SMTP id m15mr13454918jaj.86.1595025604135;
 Fri, 17 Jul 2020 15:40:04 -0700 (PDT)
Date:   Fri, 17 Jul 2020 15:40:04 -0700
In-Reply-To: <000000000000358aec05a9fc8aa8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ad07505aaaad631@google.com>
Subject: Re: general protection fault in khugepaged
From:   syzbot <syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        yang.shi@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit ffe945e633b527d5a4577b42cbadec3c7cbcf096
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Wed Jun 3 23:00:09 2020 +0000

    khugepaged: do not stop collapse if less than half PTEs are referenced

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17356c2f100000
start commit:   e44f65fd xen-netfront: remove redundant assignment to vari..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14b56c2f100000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b56c2f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
dashboard link: https://syzkaller.appspot.com/bug?extid=ed318e8b790ca72c5ad0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113406a7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175597d3100000

Reported-by: syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com
Fixes: ffe945e633b5 ("khugepaged: do not stop collapse if less than half PTEs are referenced")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
