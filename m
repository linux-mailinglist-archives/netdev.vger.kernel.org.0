Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDF1B151F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgDTSsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgDTSr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:47:59 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AD5C061A0F;
        Mon, 20 Apr 2020 11:47:59 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t11so5521628pgg.2;
        Mon, 20 Apr 2020 11:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ea2mQmg+8A1lXBRsTjPBIeegijXnIt7tuxUQQkZzy6E=;
        b=bGO3EnGp37YefoPOMGqxeZCcQpdOthASA1zuI4spziRipgcHghEPa8DiSSvHKGQQ2R
         iUR2SzSCKMB4HieMEyUr9Afr7N4KP0piStTgw1Or6T3I2K5mbGr/4RA24ghWkeyUdqVr
         SGX3Nr/lT+E4lx2SVnBHQgLQh42Mu2FjprPVApV1BsBPJlr3bgSGu4N1F9bWz2IKFu8n
         s3K38nKJphvK/DoHWwRJDbwiah8RoMS1hTRNmbzk4TqSVMkF2vJqTLGZ8q/2+BXPOi/B
         myEfHRWpBR7XyDdYoj0IYhyMR4gJWJQ9YTCOisLjrdDJV6CSH1dbAqzeMIljA7FWV63p
         vf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ea2mQmg+8A1lXBRsTjPBIeegijXnIt7tuxUQQkZzy6E=;
        b=W4pzqRI56745+seOyeaCir7ZKd4TLmPStqfjixFjTPeG30rlj236/Mtxu+CiIDuV8G
         3ao8goq7bpBOg917j2uEokA06A7EF18oMLBPJkx6hIG4drvR0oSxxgLN9miaA/C2skKS
         C8HgLsorbSVzjrtHZ4ONxIGUo8D9RV0aOiEow5OniK3LFgIcvx068xs977nQia7zuteT
         ZL0LZyDqZ+3p+MT8C7V3thdcu+5PTsOQopoo0LvnV1GugLyvD4u5Q0/fFkL/AHyYK2F/
         j4VdOP9DpSuDqYD25MZv25RHylGkH1IXDxEa81/w4AjODGb54/ExWydkA8QKYkiK8VNE
         omiA==
X-Gm-Message-State: AGi0PuZeXc0c4hFaDBjnyjLknQ2sEAVsV/6x6GwgJoZOJbOvSyWm5WDP
        ZhD/eVB7CHtkfRqnd5UKC98=
X-Google-Smtp-Source: APiQypLBNsqEEPAJKnvnqIwMMbARdlUEMBALoL7bX+jkAponvZxUydUnURCABEPk8a7h6QZfEjd0TQ==
X-Received: by 2002:a62:520e:: with SMTP id g14mr17488593pfb.216.1587408478794;
        Mon, 20 Apr 2020 11:47:58 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id h14sm61979pjc.46.2020.04.20.11.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:47:58 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: bpf: make bpf_ktime_get_ns() available to non GPL programs
Date:   Mon, 20 Apr 2020 11:47:50 -0700
Message-Id: <20200420184750.218489-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

The entire implementation is in kernel/bpf/helpers.c:

BPF_CALL_0(bpf_ktime_get_ns) {
       /* NMI safe access to clock monotonic */
       return ktime_get_mono_fast_ns();
}

const struct bpf_func_proto bpf_ktime_get_ns_proto = {
       .func           = bpf_ktime_get_ns,
       .gpl_only       = false,
       .ret_type       = RET_INTEGER,
};

and this was presumably marked GPL due to kernel/time/timekeeping.c:
  EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);

and while that may make sense for kernel modules (although even that
is doubtful), there is currently AFAICT no other source of time
available to ebpf.

Furthermore this is really just equivalent to clock_gettime(CLOCK_MONOTONIC)
which is exposed to userspace (via vdso even to make it performant)...

As such, I see no reason to keep the GPL restriction.
(In the future I'd like to have access to time from Apache licensed ebpf code)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index bafc53ddd350..a5158a179e81 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -151,7 +151,7 @@ BPF_CALL_0(bpf_ktime_get_ns)
 
 const struct bpf_func_proto bpf_ktime_get_ns_proto = {
 	.func		= bpf_ktime_get_ns,
-	.gpl_only	= true,
+	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 };
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

