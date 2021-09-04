Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1040093E
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 04:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhIDCHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 22:07:13 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:50793 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbhIDCHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 22:07:12 -0400
Received: by mail-il1-f198.google.com with SMTP id x4-20020a92b004000000b0022b3cb3b4deso624946ilh.17
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 19:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zRIZHEuwoWOZaFEYOhQYWbRsZA/HnSh/xL4xkgPXzcc=;
        b=fhR32R3ZWEmTmBS7wqrT8gG0vvmVYMXUs/EtILtk542cfo+VUWPUWpYTjguxpJ6x64
         Lfu+E5WeRBof55kkvWsHA08BUhAmCGD9oh1a2ir9gkgnbAVk3JMfWR1JEOVRHVuE7cGy
         572Mke+nHzhh2vh2ffOXvovVS+Vdb66rwtx9ed5+jFwDccyHPkh0JsqQ8sslrMgzJdlC
         bIGlJZosSqYF7n8hLV9RgEBZOkJZhL5rdSkrru17t/303o6VYU6cOV8k8p9FUI0pNRlk
         QW/hm29ZmvJwlN1wESlu/ZcbvV0q9BvBbgujHP9wwM5HvF/TqeLObMF2hP20Axo/z0L3
         Fe9A==
X-Gm-Message-State: AOAM5308R5raSslXbfjNCrgJkg7vkXF6O0xIB2IRyt6Mmnh8Mlzyh+mh
        8QWDPAeUhyJ/Tu6t2RIMpXZJ9Hwu0WX1KMB8WQcgxzUZapXd
X-Google-Smtp-Source: ABdhPJw9Np9RoKEz/LYgjUEKyZW1euqFQbMviBTa0A8MNSn66Y8d6bK+OvzYK041vGvMfoC0VmTIIndIbGS42wYFBjUHFOu/w5Dq
MIME-Version: 1.0
X-Received: by 2002:a92:cda4:: with SMTP id g4mr1287797ild.236.1630721171596;
 Fri, 03 Sep 2021 19:06:11 -0700 (PDT)
Date:   Fri, 03 Sep 2021 19:06:11 -0700
In-Reply-To: <000000000000f0cdb005cb1ff6ec@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000292cce05cb21dcd8@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_net_create
From:   syzbot <syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, chaitanya.kulkarni@wdc.com,
        coreteam@netfilter.org, davem@davemloft.net,
        eric.dumazet@gmail.com, fw@strlen.de, hch@lst.de,
        ira.weiny@intel.com, johan.hedberg@gmail.com, kadlec@netfilter.org,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, martin.petersen@oracle.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e6e7471706dc42cbe0e01278540c0730138d43e5
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jul 27 05:56:34 2021 +0000

    bvec: add a bvec_kmap_local helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d7ad33300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11d7ad33300000
console output: https://syzkaller.appspot.com/x/log.txt?x=16d7ad33300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
dashboard link: https://syzkaller.appspot.com/bug?extid=2b8443c35458a617c904
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fba55d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15bd2f49300000

Reported-by: syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com
Fixes: e6e7471706dc ("bvec: add a bvec_kmap_local helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
