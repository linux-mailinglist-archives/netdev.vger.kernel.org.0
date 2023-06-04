Return-Path: <netdev+bounces-7731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 060917214AF
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 06:51:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6C91C20AE2
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 04:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5504B17F3;
	Sun,  4 Jun 2023 04:51:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC115CC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 04:51:52 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE2BD3
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 21:51:50 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso593261666b.0
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 21:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685854308; x=1688446308;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xszXk3I/mv4XEU+Q0x66alNWoOSfPLq9xuhadpbqECg=;
        b=q3/MRgoWlMgIlTvKZUYxXPcrtnsMBgH1GMpR89gQvtFcrsJzbmTp9GteXUzm03g/xs
         d3I/+Yq6bsj6pLrUGEFyQUOC483pNb9wl5sNXJAy25nJRkmWC3BrUCFA9tjTj5ITb8+8
         Fxqb4viBnQ/JbpbXqRc49LbQEOERkE/rgHK1Z7x4xuMLKxjJqE0l0VbsC/yKOgfIaV9e
         xCPEQvFDpmEDmerXjy025U3+J9NqHRxvyeLMcIq8p0ZNlRqr2VcAXDepgnfjTR+MSf2j
         mdhfYDTeOX6sH1VuPuoMNSBe56wZJWU/0gkYjVg68ZAAZPYG5Fr8OXWXbgbJB3z6JH5l
         0QBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685854308; x=1688446308;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xszXk3I/mv4XEU+Q0x66alNWoOSfPLq9xuhadpbqECg=;
        b=ickyUB/2+xS9wwYYPmw+2Utedlclt/uOzLxyO2AcT29i/Vop++tP21jNazefSLdqbN
         51aoZ2f7m8MLIirpI78OpEuIPIHJcErY3gg/UP3G5wgPymbZnYOGcaOFF7XsXpxVfVpv
         SgQWNZOJtoyAqNkzFJmjb5y6emVlsNeJsskmsVv01UIuiLhv7RJBY0+OdgMd8nfkv+2R
         8qnNkhfaPVldzhwr0fGY+6GRQIBrsPZppizUAR68yIXoK02osvBdngcNChMVujvgtbxR
         RmjWBwFyGTllje1b/zCHo98p93wFMbQRMJ4NGdn+Mjv/brFz0pzyAFeEbSF3UAAhtUjk
         9xtA==
X-Gm-Message-State: AC+VfDxEF3Eo6Ie823u6dOC27GpE6ofOcMT5iR0AcXeaSWYKKQE/maBO
	p9yVz2ZCj4+BUJXZatl9HFmrqRJeNJk=
X-Google-Smtp-Source: ACHHUZ45KT063snNOPyp2+/z4ulFiacHiXnyn8dWPMzUfioL1FrxCF/DirmQENOoqnmOBub8NFLawg==
X-Received: by 2002:a17:907:8a05:b0:973:9c54:5723 with SMTP id sc5-20020a1709078a0500b009739c545723mr3943143ejc.2.1685854308071;
        Sat, 03 Jun 2023 21:51:48 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id m4-20020a170906848400b00965a56f82absm2625670ejx.212.2023.06.03.21.51.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Jun 2023 21:51:47 -0700 (PDT)
From: Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Bug Report with kernel 6.3.5
Message-Id: <20F611B6-2C76-4BD3-852D-8828D27F88EC@gmail.com>
Date: Sun, 4 Jun 2023 07:51:36 +0300
To: netdev <netdev@vger.kernel.org>,
 Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Team one bug report=20

after upgrade from kernel 6.2.12 to 6.3.5=20
After fell hour system get this error.

If is possible to check.


Jun  4 01:46:52  [12810.275218][  T587] INFO: task nginx:3977 blocked =
for more than 609 seconds.
Jun  4 01:46:52  [12810.275350][  T587]       Tainted: G           O     =
  6.3.5 #1
Jun  4 01:46:52  [12810.275436][  T587] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  4 01:46:52  [12810.275527][  T587] task:nginx         state:D =
stack:0     pid:3977  ppid:1      flags:0x00000006
Jun  4 01:46:52  [12810.275624][  T587] Call Trace:
Jun  4 01:46:52  [12810.275707][  T587]  <TASK>
Jun  4 01:46:52  [12810.275786][  T587]  __schedule+0x352/0x820
Jun  4 01:46:52  [12810.275878][  T587]  =
schedule_preempt_disabled+0x61/0xe0
Jun  4 01:46:52  [12810.275963][  T587]  =
__mutex_lock.constprop.0+0x481/0x7a0
Jun  4 01:46:52  [12810.276049][  T587]  ? __lock_sock_fast+0x1a/0xc0
Jun  4 01:46:52  [12810.276135][  T587]  ? lock_sock_nested+0x1a/0xc0
Jun  4 01:46:52  [12810.276217][  T587]  ? =
inode_wait_for_writeback+0x77/0xd0
Jun  4 01:46:52  [12810.276307][  T587]  =
eventpoll_release_file+0x41/0x90
Jun  4 01:46:52  [12810.276416][  T587]  __fput+0x1d9/0x240
Jun  4 01:46:52  [12810.276517][  T587]  task_work_run+0x51/0x80
Jun  4 01:46:52  [12810.276624][  T587]  =
exit_to_user_mode_prepare+0x123/0x130
Jun  4 01:46:52  [12810.276732][  T587]  =
syscall_exit_to_user_mode+0x21/0x110
Jun  4 01:46:52  [12810.276847][  T587]  =
entry_SYSCALL_64_after_hwframe+0x46/0xb0
Jun  4 01:46:52  [12810.276954][  T587] RIP: 0033:0x15037529155a
Jun  4 01:46:52  [12810.277056][  T587] RSP: 002b:000015036bbb6400 =
EFLAGS: 00000293 ORIG_RAX: 0000000000000003
Jun  4 01:46:52  [12810.277185][  T587] RAX: 0000000000000000 RBX: =
000015036bbb7420 RCX: 000015037529155a
Jun  4 01:46:52  [12810.277311][  T587] RDX: 0000000000000000 RSI: =
0000000000000000 RDI: 0000000000000013
Jun  4 01:46:52  [12810.277440][  T587] RBP: 00001503647343d0 R08: =
1999999999999999 R09: 0000000000000000
Jun  4 01:46:52  [12810.277567][  T587] R10: 000015037531baa0 R11: =
0000000000000293 R12: 0000000000000ba5
Jun  4 01:46:52  [12810.277693][  T587] R13: 0000150348731f48 R14: =
0000000000000000 R15: 000000001f5b06b0
Jun  4 01:46:52  [12810.277820][  T587]  </TASK>

Martin=

