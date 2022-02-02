Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC3A4A7B43
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 23:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiBBWsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 17:48:14 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:47715 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiBBWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 17:48:13 -0500
Received: by mail-il1-f200.google.com with SMTP id g14-20020a056e021e0e00b002a26cb56bd4so486070ila.14
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 14:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wPRVy6cCZjxIGaY7GW0QhGPoF6HyxL4xHm0Y75S1HfY=;
        b=AwhYoqLldRLPkmLUo+cJtFofpkzgitbNWSXyp2/HVCcGO4lvKZEnZYz9giVK59QKLo
         +IBvTGN85o3+JjwjpBpoz1USUytEIggsdWd432H0dtNNQDiCas64CgcxZx3Hy/ffwlYP
         kWpgOOPaXmfBdillWOgVUo/aaDQ4rQIPzKlBKCS4xxDXFZVEdCggDiDTg3nyOQzrSeoH
         xjgmP4sHgPitgRPfJQvxpyFN7HnfbPGSqaOik5jWdLpoWtZtcxEuENYbMBVN8S50xWu9
         p1Tbjl+1o83Vy6lQPxSN3IlBldDVbcAUPXA2hYC6IEhA0YzbxkJGMyGO5faw1bAMWIGx
         dAJQ==
X-Gm-Message-State: AOAM530O6oLF0LutnVsDFFiI0UItVcO+dI839HCT+OB50KUswOFxT9Qo
        BkzhLX/TFGiW4wtp5MJD+7MRAnqzD2fAIx2fy+MBG5hzF/PO
X-Google-Smtp-Source: ABdhPJxazeG/KSFW4yUcasmzMOdmC/DL0bFZExqauOUeXy/hnReM+RRSSGklrexPTcyyuAPHnKRqalDWqVAqFarV3Dxl2/1VlXzE
MIME-Version: 1.0
X-Received: by 2002:a92:d68a:: with SMTP id p10mr3673258iln.85.1643842093461;
 Wed, 02 Feb 2022 14:48:13 -0800 (PST)
Date:   Wed, 02 Feb 2022 14:48:13 -0800
In-Reply-To: <000000000000df66a505d68df8d1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000c37d105d710d0e1@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in bpf_prog_test_run_xdp
From:   syzbot <syzbot+6d70ca7438345077c549@syzkaller.appspotmail.com>
To:     alexei.starovoitov@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, lorenzo@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, toke@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 1c194998252469cad00a08bd9ef0b99fd255c260
Author: Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Fri Jan 21 10:09:58 2022 +0000

    bpf: introduce frags support to bpf_prog_test_run_xdp()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a1e914700000
start commit:   000fe940e51f sfc: The size of the RX recycle ring should b..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a1e914700000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a1e914700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e029d3b2ccd4c91a
dashboard link: https://syzkaller.appspot.com/bug?extid=6d70ca7438345077c549
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c08cc8700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1258f610700000

Reported-by: syzbot+6d70ca7438345077c549@syzkaller.appspotmail.com
Fixes: 1c1949982524 ("bpf: introduce frags support to bpf_prog_test_run_xdp()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
