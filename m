Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22465575FA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiFWIy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiFWIyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 948843585A
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655974491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ULy9IIamPdfsZSRsFJ2H0uvIsCHgd0HnbDP0BI9tL4I=;
        b=c1yZ6YjpAvFJsD473U1QzOU78HgoftUsk6hIluYupi2k6gVPIWLkYJ7CH/aqXd/E6DR5+4
        udgtYrgGZx+mdKNcbFW+yZV6KFCRjeltz7hikwYqZWJ1vaStYwWHhcCgOB+4ZDz4IsPGwl
        aPpE7YFrxrw1K27YV9LEO96emE5HA0w=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-l0_ui4FePneYX9NM92asCA-1; Thu, 23 Jun 2022 04:54:50 -0400
X-MC-Unique: l0_ui4FePneYX9NM92asCA-1
Received: by mail-pl1-f198.google.com with SMTP id d3-20020a170903230300b0016a4d9ded01so1958887plh.6
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULy9IIamPdfsZSRsFJ2H0uvIsCHgd0HnbDP0BI9tL4I=;
        b=tJW/gz4RITA5T0pQdUXSaydSaYlsN1T/FFFTktQzE6Rn68eWMDsgM4Zm2hGmjO27Mr
         Z1xrQNl6vtcRYT1ikq4d7/Jxs//vuqRqyACuN7gtI1ldzxaLdHqJTeTNWg1LfBZJkEE2
         78eveRle9PH2xH1/e3+/u4alVPOOrztxzvcJ7jDZ4Ug/ecfEjImwszbL344jAo4ZkMvK
         BfjaPTtZopeqVjuf7+FzDgiWT4NmzUEG4Z49szS54DrKwOqd2WEzTOfFbwe9Kfaklaw3
         tQz8eb5hirx492pwAcuroRb/yyF4Zr3f8B7osU5EtZ0IXfLRAjavvMyup0hCrW/9Lw4d
         WSRw==
X-Gm-Message-State: AJIora+lWalsfAheLL/NgANeJKN3lWXZ9+AWo7oxFRqVmITMBL4DOehw
        ggtsSVurmfCCTVbT1JJyy7Jgc8HiaMImkeROWRuu4s9HnKJB4lhBDO8iXaeL7N6b/ada32fm+0w
        OMVBlK1l59afzLqNQfugUJbEw8oU3YwIC
X-Received: by 2002:a17:902:ec83:b0:16a:3029:a44 with SMTP id x3-20020a170902ec8300b0016a30290a44mr15842260plg.141.1655974489107;
        Thu, 23 Jun 2022 01:54:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vK4B3HncgW6duS5f+hx8kUoau/VW9nbZ05rE0/VJMQKcwWRVhW79OpJQA/P7Sn6FUm+rj+FSdF2+5UqBofQ2s=
X-Received: by 2002:a17:902:ec83:b0:16a:3029:a44 with SMTP id
 x3-20020a170902ec8300b0016a30290a44mr15842235plg.141.1655974488824; Thu, 23
 Jun 2022 01:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b9edeb05e1aca987@google.com> <0000000000008b8cd205e2187ea2@google.com>
In-Reply-To: <0000000000008b8cd205e2187ea2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 23 Jun 2022 10:54:37 +0200
Message-ID: <CABgObfarsDqG3g1L561CHvg3j0aROSz5zdcB5kOibcjbLN_y9g@mail.gmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage (5)
To:     syzbot <syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com>
Cc:     Alexander Lobakin <alobakin@pm.me>, Borislav Petkov <bp@alien8.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Anvin, H. Peter" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: x86/kvm: Fix broken irq restoration in kvm_wait

On Thu, Jun 23, 2022 at 9:35 AM syzbot
<syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit c2ff53d8049f30098153cd2d1299a44d7b124c57
> Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date:   Thu Feb 18 20:50:02 2021 +0000
>
>     net: Add priv_flags for allow tx skb without linear
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11596838080000
> start commit:   a5b00f5b78b7 Merge branch 'hns3-fixres'
> git tree:       net
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13596838080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15596838080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
> dashboard link: https://syzkaller.appspot.com/bug?extid=9cbc6bed3a22f1d37395
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b22abf00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125194eff00000
>
> Reported-by: syzbot+9cbc6bed3a22f1d37395@syzkaller.appspotmail.com
> Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>

