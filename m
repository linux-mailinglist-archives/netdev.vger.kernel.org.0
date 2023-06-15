Return-Path: <netdev+bounces-11232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA6E732144
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43E981C20EEF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623BC12B92;
	Thu, 15 Jun 2023 21:02:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559582E0FC
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:02:31 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ED02955
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:02:26 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-778d823038bso864153339f.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686862945; x=1689454945;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n4hXMNSzNgX9qcNCtjmUZbMdzYOaYR79wSe3L4m7Iq0=;
        b=UsK2jFSR4jaxnPaMNR0UJk+e2dVSY93PMcuXsybWi7DZ5x206CbWnwmgZBsoCiDTfY
         lja28C7//K39NrFIldjifmcqgN8sma3atQEt6TKnlKW/N6Y2JQuPXyzrSKYDoDzsxWrS
         NfbGgrZ/DD5M2kbBrnCmz6FFOppgtkndbFRwk3UlT2FnXBf+wb2ZzN7Qxcho2+2rGejF
         atdJwnTSDxyLJIaPc3RtFQmHpfaI53ZvscC7bw29E83QfXT9uch0/RU2AWVM2Y+cWLGa
         qNBfy3B2+umc3roRtUyplphW92XXNlzKMsUa84u7PVrPthRiBE8SIQQ74aHUTOlNnBxB
         EFRg==
X-Gm-Message-State: AC+VfDxRT6jBh/EJZPNbRN+oqHlGzQI6zYv+G37znQFX6dJTHmWgejo5
	06PPWe+K0X/kJN8qXKTDB2rGK4TrSYLYCqDVzq/lZnREz4cy
X-Google-Smtp-Source: ACHHUZ6USDC6PDWcEo+gfpDJs9g2SM4qwmGn+hEQt8nQOfRMl2i2RpbGbn/LJN2jsjD6+hkn/9TTEE0EoYZWM6rU7UkLMOgtbQUB
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:a18f:0:b0:420:d53f:2821 with SMTP id
 n15-20020a02a18f000000b00420d53f2821mr90094jah.5.1686862945444; Thu, 15 Jun
 2023 14:02:25 -0700 (PDT)
Date: Thu, 15 Jun 2023 14:02:25 -0700
In-Reply-To: <262282.1686860686@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5e86b05fe316253@google.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
From: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	kuba@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com

Tested on:

commit:         97c5209b leds: trigger: netdev: uninitialized variable..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=13705753280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10d19cbb280000

Note: testing is done by a robot and is best-effort only.

