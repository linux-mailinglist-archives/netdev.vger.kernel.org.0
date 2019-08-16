Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D39D9019A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfHPMcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:32:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:34718 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHPMcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:32:01 -0400
Received: by mail-io1-f70.google.com with SMTP id u84so3123913iod.1
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 05:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wryiOfAG/Vz/DIYvCN28nq1K6mp/nU+skMXU68jljsg=;
        b=OLG0iQ8+N/xlDNHp1WiY+Edaw6EQ042WbioUyDK+tUlLob5VHgyHfUDMWrfmKsr8c/
         4E0ziNjne3qa+Oz6Uop8uWjskfVXeEhDRdf1yn1ejxaSYkxbCYKj9uiGKVYnZ37zltCp
         KtDXjh5V18NorYrY/zdlNTdZY9w4CMfI4odQAv2ILkK4uDMBnOFv4EaP6wZhZhN+25Go
         3E6HWq5z6Dq0DLV37GECtxLIWK1ITTHUfmUbxk/nfUG60SSbq10/wzeliqMWq9tJTJes
         9luHMcjuzRm9GuHNZLa7/GoiCqXOQGBBcgpqnUgaJDveIpO8TVL8hl2SxGYW6zs1W8D2
         bAkw==
X-Gm-Message-State: APjAAAUpSYlDvTjQRMolox0HR668Xs5XlDoVQULQjf16hqP14JWgRkHS
        lvD65Y+yw0+P+PBsiCCQP4aLevWeI6/f/m4rRVP0vOVIX7HD
X-Google-Smtp-Source: APXvYqwVJZ1Ky9uvJUxacOGklcVPT1U9nm8gtTHrxo5JaCS/yJtbc56F1jQsb9fE/hCBKAGguMun8qINwfLvsNNf8Go2W64uQ/Eb
MIME-Version: 1.0
X-Received: by 2002:a02:a703:: with SMTP id k3mr10331137jam.12.1565958720687;
 Fri, 16 Aug 2019 05:32:00 -0700 (PDT)
Date:   Fri, 16 Aug 2019 05:32:00 -0700
In-Reply-To: <000000000000ab6f84056c786b93@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000479a1705903b2dc9@google.com>
Subject: Re: WARNING in tracepoint_probe_register_prio (3)
From:   syzbot <syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com>
To:     antoine.tenart@bootlin.com, ard.biesheuvel@linaro.org,
        baruch@tkos.co.il, bigeasy@linutronix.de, davem@davemloft.net,
        gregkh@linuxfoundation.org, gustavo@embeddedor.com,
        jeyu@kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, maxime.chevallier@bootlin.com,
        mingo@kernel.org, netdev@vger.kernel.org, paulmck@linux.ibm.com,
        paulmck@linux.vnet.ibm.com, rmk+kernel@armlinux.org.uk,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ecb9f80db23a7ab09b46b298b404e41dd7aff6e6
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Aug 13 08:00:25 2019 +0000

     net/mvpp2: Replace tasklet with softirq hrtimer

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ffb9ee600000
start commit:   ecb9f80d net/mvpp2: Replace tasklet with softirq hrtimer
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=100079ee600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ffb9ee600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=774fddf07b7ab29a1e55
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b02a22600000

Reported-by: syzbot+774fddf07b7ab29a1e55@syzkaller.appspotmail.com
Fixes: ecb9f80db23a ("net/mvpp2: Replace tasklet with softirq hrtimer")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
