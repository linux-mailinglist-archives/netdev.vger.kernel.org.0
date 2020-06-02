Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF201EBE80
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgFBOzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 10:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBOzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 10:55:43 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A353CC08C5C0;
        Tue,  2 Jun 2020 07:55:43 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i68so10844283qtb.5;
        Tue, 02 Jun 2020 07:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=eHWCJpGvOMEPpbXW8VfTPl1JdLuLDh+ZhBh8b3W6cCY=;
        b=jpqGqN5fusT3dEfyPkAsKndNeYEfRXRWU1PhJd65J8bZN2d1/bfpNZ9IA1O92M+0N7
         dROeL52SwahvX5Q6zIVdg4xJOeUgeh4LcYz02Zo3G2GD4oVN7S6tEeXjUe+bEDTo9JIE
         yV5bA30W1QANra6CGbp6JgocbhtOvnXiL+jZCEFLAaXrIpQZbIjb1b7TE6bmtTTmSZX8
         HYTDVQH0YNr4Gu1Qz0hs4y38CgLuHh3AuNnma9AX88CCaJA05BD96z9kySU+0NAJNQBN
         1y+/1iWkY8zC8yjczOyJZaogzKHscp2hhOC4CmUBHEPPf8Dkjc0AOr1KBKA1RD6ug0HF
         IS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=eHWCJpGvOMEPpbXW8VfTPl1JdLuLDh+ZhBh8b3W6cCY=;
        b=PfsptOiyHWZenMv1fP4UaqB80lVchW8wTarcgWDz+Z+d2apfr4vi/Ln5ImukCiql42
         VYeFnVZyesV46gYXazrsED+EvKSKq/fZheIFPU+svNIdjO79TIkRiSxQ9raChnxkUaKP
         TEmyhIPmEKFT8WRl0NvpXSJroz5jsUVTHYJMaGxmar1UHMsfjM62FYorxUdbA9+Pbf3V
         74ma3yXPccMq8ffp8uVucwRUJjV61FiQ/U7Ue3k/NRZSz3RK3XUczJXjCxF7pbN4dmOA
         jbqxwDGsMw14kTeMzSf3XU7ml8c8A0toZa0Jv5B2og2WW6QCW3fg7BeSM04FYxm3uza/
         v9mg==
X-Gm-Message-State: AOAM5318uAdJxoFQCJ4AsWw8kA7oQGPmEv3UZOlWU0JHUE86RKlgVYVN
        A6FTK3E212DFQuRFYhXiiz0=
X-Google-Smtp-Source: ABdhPJz1Ct9gAsI5WNAA/0iVbz1MV6e4nAoXjyM5/drYO5uvJS6nmIgxrDcPzfa28AwAWvDch5HBUw==
X-Received: by 2002:aed:24db:: with SMTP id u27mr27047925qtc.256.1591109742727;
        Tue, 02 Jun 2020 07:55:42 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id c58sm2923849qtd.27.2020.06.02.07.55.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jun 2020 07:55:42 -0700 (PDT)
From:   Pooja Trivedi <poojatrivedi@gmail.com>
X-Google-Original-From: Pooja Trivedi <pooja.trivedi@stackpath.com>
To:     mallesh537@gmail.com, pooja.trivedi@stackpath.com,
        josh.tway@stackpath.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [RFC 0/1] net/tls(TLS_SW): Data integrity issue with sw kTLS using sendfile
Date:   Tue,  2 Jun 2020 14:55:33 +0000
Message-Id: <1591109733-14159-1-git-send-email-pooja.trivedi@stackpath.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sendfile is used for kTLS file delivery and 
the size provided to sendfile via its 'count'
parameter is greater than the file size, kTLS fails
to send the file correctly. The last chunk of the 
file is not sent, and the data integrity of the 
file is compromised on the receiver side. 
Based on studying the sendfile source code, in
such a case, last chunk of the file will be passed
with the MSG_MORE flag set. Following snippet from
fs/splice.c:1814 shows code within the while loop 
in splice_direct_to_actor() function that sets this
flag:

--------

	/*
	 * If more data is pending, set SPLICE_F_MORE
	 * If this is the last data and SPLICE_F_MORE 
	 * was not set initially, clears it.
	 */
	if (read_len < len)
		sd->flags |= SPLICE_F_MORE;
	else if (!more)
		sd->flags &= ~SPLICE_F_MORE;

--------

Due to this, tls layer adds the chunk to the pending 
records, but does not push it. Following lines of code
from tls_sw_do_sendpage() function in tls_sw.c:1153 show 
the end of record (eor) variable being set based on 
MSG_MORE flag:

--------

	bool eor;

	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));

--------

This eor bool is then used in the condition check for 
full_record, end of record, or sk_msg_full in 
tls_sw_do_sendpage() function in tls_sw.c:1212:

--------

	if (full_record || eor || sk_msg_full(msg_pl)) {
		ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
				  record_type, &copied, flags);
		if (ret) {
			if (ret == -EINPROGRESS)
				num_async++;
			else if (ret == -ENOMEM)
				goto wait_for_memory;
			else if (ret != -EAGAIN) {
				if (ret == -ENOSPC)
					ret = 0;
				goto sendpage_end;
			}
		}
	}
	continue;

--------

Changing the code in splice_direct_to_actor() function 
in fs/splice.c to detect end of file by checking 'pos'
variable against file size, and setting MSG_MORE flag
only when EOF is not reached, fixes the issue:

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -980,10 +980,12 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
                 * If this is the last data and SPLICE_F_MORE was not set
                 * initially, clears it.
                 */
-               if (read_len < len)
-                       sd->flags |= SPLICE_F_MORE;
-               else if (!more)
+               if (read_len < len) {
+                       if (pos < i_size_read(file_inode(in)))
+                               sd->flags |= SPLICE_F_MORE;
+               } else if (!more)
                        sd->flags &= ~SPLICE_F_MORE;
+               }


Sending a followup patch to this that adds a selftest 
that helps reproduce the issue.
