Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604BA10B752
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfK0USM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:12 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33805 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfK0USL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:11 -0500
Received: by mail-lj1-f193.google.com with SMTP id m6so18510212ljc.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4lHQcXh/Zh0dZRNnXWmnAAWS+nMt4tBVG2yRW9EibR8=;
        b=DLEgrnWoP/ycG1C7T06EgMEJxpvgotOzvPW5SUoSl83NC7LEoxdp3ULyKMXMnp8MNJ
         rd1sUcjuqJ0PaxrgERHbC77jQw3Pl7qRYlH2aYBb+qU7jfkOfmydMyBv9L7MARRxcARS
         Xa1i/fowWFf40GD5pwR1eIohmy8bzl4EGVOW2aC4cArVwjY8QWWWcVsImgKnfTq5sWnz
         MGusYHcV2kJrnAqvhTUX/fWtEnq+86QMFe0UtNENrL3Yi9qdpzH3Y5rPP2qrPKscmfNK
         AGmRodql+VcW39JU5u7nOL/sF9RQKPQfo1+LGDq4pWHeOfOoq75n+sc8FNDSmqgwXEw0
         0HOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4lHQcXh/Zh0dZRNnXWmnAAWS+nMt4tBVG2yRW9EibR8=;
        b=Xa7At11NROw27Cn3W6x43VGQR2zGU0ZV6GL5ntcjcf20rjHDiHBWHiwKHblQmmjIf7
         31aM/uHCugqRh6DyEs9Uaz5LvG1HCoDAYog1ViJj7ZTtGVhb8F+19gmWyZHry/sjKgPc
         +56wgG7iaBqDAI6LHFo9LglCChjxNNQQf0otQ4xTdPmdyIKB4maCrAPkg/gI3eVYcIhD
         7HyTT78J0T2OnER+hVUH2kJjcrTvjRPGSJxhoglpuDhQzxmFgNvFZht5QJg/YY+oceS5
         QbB8M+AAwkiW1Nhj+ZF49kLnxXPv2zdC/TXRBcw6lxfdDxGECc17Io82Xl1OBCe4HzeZ
         xC0w==
X-Gm-Message-State: APjAAAUwfK2xTCe/J06YmiVMKcNrqD3dfWUTclFgu0unsUkHv8mgPERA
        O6YAfRy0cLBfrwDVWN619JFlVA==
X-Google-Smtp-Source: APXvYqweNgMIcdf2Aq1tT7a1C5dLFSXhO4OANWjFATCmS9T4v2BC+EGfwHKVBVvgoPwqWT+6usSZbQ==
X-Received: by 2002:a2e:3a15:: with SMTP id h21mr32133023lja.256.1574885889520;
        Wed, 27 Nov 2019 12:18:09 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:18:08 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 5/8] net/tls: remove the dead inplace_crypto code
Date:   Wed, 27 Nov 2019 12:16:43 -0800
Message-Id: <20191127201646.25455-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like when BPF support was added by commit d3b18ad31f93
("tls: add bpf support to sk_msg handling") and
commit d829e9c4112b ("tls: convert to generic sk_msg interface")
it broke/removed the support for in-place crypto as added by
commit 4e6d47206c32 ("tls: Add support for inplace records
encryption").

The inplace_crypto member of struct tls_rec is dead, inited
to zero, and sometimes set to zero again. It used to be
set to 1 when record was allocated, but the skmsg code doesn't
seem to have been written with the idea of in-place crypto
in mind.

Since non trivial effort is required to bring the feature back
and we don't really have the HW to measure the benefit just
remove the left over support for now to avoid confusing readers.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls.h | 1 -
 net/tls/tls_sw.c  | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 6ed91e82edd0..9d32f7ce6b31 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -100,7 +100,6 @@ struct tls_rec {
 	struct list_head list;
 	int tx_ready;
 	int tx_flags;
-	int inplace_crypto;
 
 	struct sk_msg msg_plaintext;
 	struct sk_msg msg_encrypted;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index dbba51b69d21..5989dfe5c443 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -710,8 +710,7 @@ static int tls_push_record(struct sock *sk, int flags,
 	}
 
 	i = msg_pl->sg.start;
-	sg_chain(rec->sg_aead_in, 2, rec->inplace_crypto ?
-		 &msg_en->sg.data[i] : &msg_pl->sg.data[i]);
+	sg_chain(rec->sg_aead_in, 2, &msg_pl->sg.data[i]);
 
 	i = msg_en->sg.end;
 	sk_msg_iter_var_prev(i);
@@ -976,8 +975,6 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			if (ret)
 				goto fallback_to_reg_send;
 
-			rec->inplace_crypto = 0;
-
 			num_zc++;
 			copied += try_to_copy;
 
@@ -1176,7 +1173,6 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 
 		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor || sk_msg_full(msg_pl)) {
-			rec->inplace_crypto = 0;
 			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
 						  record_type, &copied, flags);
 			if (ret) {
-- 
2.23.0

