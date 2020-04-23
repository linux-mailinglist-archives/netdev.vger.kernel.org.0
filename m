Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00A1B5414
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgDWFSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWFSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:18:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8992BC03C1AB;
        Wed, 22 Apr 2020 22:18:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r14so2371548pfg.2;
        Wed, 22 Apr 2020 22:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=l8LWkxvey9Hd79SGqrSqUJiOWTNMAJRbACX2qSq2ln4=;
        b=H5EWF0lYUrxxpaKuojPYYefKw8mE/5+f8ios6XJ+oAFyJBdxwEXDXfWUbYl4CI+rXb
         NJdax4IcjJo9P2sfaDXtP6xg2bKG5+AaoiQ3gFRDMaRLPN0VGf5iTu1A9Zj9P9NZ79bE
         Xaxa2DoKhfEtcoVUPXbGUIFAfbJfblXZSXJEsNbc8p+YyL4qMUNtbH5F32Ricoh3fWhT
         RVbtDyVLavSSwFSEHj1iUX68ZpvHiTl35I/34mOMD5vE35DPNwTSVUiDcP7t4kKcViAt
         l5WQFiu9ep2uZtwcIWNmOBB3HUzxxW9O8k+Tzc1/sYlbVuT57Qw0ol4VZmYg1pDKKyks
         +Tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=l8LWkxvey9Hd79SGqrSqUJiOWTNMAJRbACX2qSq2ln4=;
        b=hMASv2vCp7tCJSopBuND2bDYv97FnodBH/dnw0YUkEjykhgL0nvcLfMIdBpfOEMujm
         K21/Kj3x2Ll4iosgElfPiiAb0s1UOGFoAsdc8IKDjBYc1WDwkX31/BqKBpn2YbOse0at
         hKNHygoXg+idM1yrDTlVCqvlmwuB/KjT0D5XQMPOV2oV2fxZDY1HMfEJUQBi0wk7Yw4Y
         uZ7qv1sUyIX8ZrbwY6zkAnV/b88u2CzJWLcAD4Lzh/3XA80+alnzkbsBRLUt/3bNPad2
         SzgMnCcS2vd2Kf753N7mQF6045oHXM78todkrQPnYsd76eFKIq8c/Q9hmQla0K8UgDuv
         dBjg==
X-Gm-Message-State: AGi0PuY13n4uP7qod/yRD45elnKLIrTUEJxrT1zz7h+KJ/dyCUFqdu3p
        xex+FWIX6erCumh96ByWFmHnq2m6
X-Google-Smtp-Source: APiQypJfZ5VCVKkn5GQPwGkKVeCYzBIgX76ZJWzKuUz+EalyeEVAuHevhKjsSi9VKBO1o/awjueKww==
X-Received: by 2002:a62:4e88:: with SMTP id c130mr2191578pfb.122.1587619086049;
        Wed, 22 Apr 2020 22:18:06 -0700 (PDT)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id k10sm1300719pfa.163.2020.04.22.22.18.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 22:18:05 -0700 (PDT)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id 03N56cTC004174;
        Thu, 23 Apr 2020 13:06:38 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id 03N56bZS004173;
        Thu, 23 Apr 2020 13:06:37 +0800
Date:   Thu, 23 Apr 2020 13:06:37 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, davem@davemloft.net, jiong.wang@netronome.com,
        kuznet@ms2.inr.ac.ru, tglx@linutronix.de, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf, x86_32: Fix logic error in BPF_LDX zero-extension
Message-ID: <20200423050637.GA4029@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, daniel@iogearbox.net,
        ast@kernel.org, davem@davemloft.net, jiong.wang@netronome.com,
        kuznet@ms2.inr.ac.ru, tglx@linutronix.de, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When verifier_zext is true, we don't need to emit code
for zero-extension.

Fixes: 836256bf ("x32: bpf: eliminate zero extension code-gen")

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 4d2a7a764602..ed34dd16ebc5 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1847,7 +1847,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			case BPF_B:
 			case BPF_H:
 			case BPF_W:
-				if (!bpf_prog->aux->verifier_zext)
+				if (bpf_prog->aux->verifier_zext)
 					break;
 				if (dstk) {
 					EMIT3(0xC7, add_1reg(0x40, IA32_EBP),
-- 
2.17.1

