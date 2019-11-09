Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E13F5F8F
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 15:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfKIOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 09:32:04 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:45675 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfKIOcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 09:32:03 -0500
Received: by mail-io1-f69.google.com with SMTP id c17so8423415ioh.12
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 06:32:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JZi5tkp/gckqrQSG8tYsCT0DyycZxwi5ufMcg5DoU5o=;
        b=L4m6Jd4ECPql2Zecxsf9R0yhcV623U+vWOpM0QibBaJeHxUnOaQQLV/9sR/wPXIiI+
         vFSpN7iCaW9BvIeCwSnSbh8nLlf8UP6/LLhwdx3KXqZgfr9zeoJucHMRFRf0k35FhZMH
         nCkqgxsn+I/cufb06ydNw3eyEx2Ke0hCvrY8Fjj2J2L59xDaBL3MktS0+Z0O5WttAA+h
         pwTB0pO+gNoQtEV1Sop4VRCqyq1pxTZck02ZwT1cI6cZ6VG3o8tXSp6MAcIjv5bbTGla
         m/AaYFVVgKkV/iOQJS66g1ShCpXPccg8n2lh44PkFRitJ3oksQd+QZf74Ih/K1WXQe50
         ol/g==
X-Gm-Message-State: APjAAAXK6ERvulBm3A5htMpm7Q+Ju/v8vXn57HvRutZ7VUzX2t4kslS+
        vt/OZxxYgvtH7v8xd9mzJPOWOR+bnqkuYiRN2nJ69sSCGgrQ
X-Google-Smtp-Source: APXvYqyoeCdf8LV4IECaLdOHYImFqe90Hff/exUBRMytawJCGLHrKdaUiBLrWfSr7NsrTpsl73JiShExe8f7ksVJLj1e/jt5f1X9
MIME-Version: 1.0
X-Received: by 2002:a6b:7847:: with SMTP id h7mr16503562iop.141.1573309921226;
 Sat, 09 Nov 2019 06:32:01 -0800 (PST)
Date:   Sat, 09 Nov 2019 06:32:01 -0800
In-Reply-To: <0000000000002b42040573b8495a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9fb820596eac28b@google.com>
Subject: Re: WARNING: refcount bug in igmp_start_timer
From:   syzbot <syzbot+e28037ac1c96d2a86e89@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ap420073@gmail.com, ast@kernel.org,
        benjamin.gaignard@linaro.org, cmetcalf@ezchip.com,
        daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        daniel@iogearbox.net, davem@davemloft.net, ecree@solarflare.com,
        edumazet@google.com, f.fainelli@gmail.com, idosch@mellanox.com,
        jiri@mellanox.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, mcroce@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        petrm@mellanox.com, sd@queasysnail.net, stephen@networkplumber.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vincent.abriou@st.com, xiangxia.m.yue@gmail.com,
        xiyou.wangcong@gmail.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 323ebb61e32b478e2432c5a3cbf9e2ca678a9609
Author: Edward Cree <ecree@solarflare.com>
Date:   Tue Aug 6 13:53:55 2019 +0000

     net: use listified RX for handling GRO_NORMAL skbs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a5452ce00000
start commit:   ae596de1 Compiler Attributes: naked can be shared
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
dashboard link: https://syzkaller.appspot.com/bug?extid=e28037ac1c96d2a86e89
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178537da400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net: use listified RX for handling GRO_NORMAL skbs

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
