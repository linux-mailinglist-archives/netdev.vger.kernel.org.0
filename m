Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B64821333
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 06:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfEQEng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 00:43:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38092 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQEng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 00:43:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so3034165pfb.5
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 21:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=twT/SHyRXz2WuIiDZ5ZWmKGDBP1VLuZrvtfMAWQsRVQ=;
        b=bYSTRYKLoaCwr21II9/IhcWWo3AqdsrIIGyz47Lmb4BepgEkdg11u7NBjuHrt3Kp09
         DOACfXAB8p8XqesvWYips1OBdlyn4eKICe38WuzhWU7Vv/GwC+s7E+Tt4BveAafZeQF9
         3WXGOdka8AKWzYXAKfGahAqs64BaV+JjgE+hzBV9HaD6ieEIWkRnv3Gul+xgAGX0unPB
         VSbkhFiSEVFP+Bmm0dwQ81sRLG09zHgu8KMleqihcfBMpqyStnGsPhrWdty3JDRZ9IyD
         69F9j0UdSLuMrHjcdIL/xGO/OWfd6OQa4fh9Wtnvw1eoVfIHhMETtsp4yTP0TfiQMqAe
         B8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=twT/SHyRXz2WuIiDZ5ZWmKGDBP1VLuZrvtfMAWQsRVQ=;
        b=A7PhRNx45C3Uyru9lL9sKR8MNnE56JPU9i/5mSC6m3qVjtkEGgaDmXlah9Xu2/frnF
         qtV5xdYDZP8wNUDiFnHCIXa3wNR8vVyFMtV17qwWUfbg3KbbJE4B/ymXW9BnCGpk3JSo
         XeY/kCf5TY4ghbhbsgg/P3uEzgwtUhslUpg5/l8m6mvrTWreXlXGMKe15SBzzCh6kM9V
         D0PNhYy928URM1o2Ap/bax66AALzNUUvvAlLT/xVNPASCasLHX2CnRIBDyUFIQpF1scB
         g4MBBpy/ugaF9pZHzoXgYSq3q8SpbEW4hupEK9SsIoapIRgWl2SUpMSCZa869c6HpKi+
         622g==
X-Gm-Message-State: APjAAAV3nFTApHEQHqkQM/xaZDxZGHkQImmdS+CT7xBovvigwAKaz2B9
        SV4YE+tVnoXyzZOUO0M3a9U=
X-Google-Smtp-Source: APXvYqxskRvhF1syTrUC4yCf7J8hu/w3Q2m0HXF1kTa4+UqXPWlVRNn3d/5Aqhcy8IHoWRylgfD06w==
X-Received: by 2002:a65:60ca:: with SMTP id r10mr54429905pgv.64.1558068215299;
        Thu, 16 May 2019 21:43:35 -0700 (PDT)
Received: from [192.168.1.2] (155-97-234-108.usahousing.utah.edu. [155.97.234.108])
        by smtp.gmail.com with ESMTPSA id z18sm8464224pfa.101.2019.05.16.21.43.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 21:43:34 -0700 (PDT)
To:     davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
From:   Cyrus Sh <sirus.shahini@gmail.com>
Subject: [PATCH] Hirman: Clock-independent TCP ISN generation
Openpgp: preference=signencrypt
Autocrypt: addr=sirus.shahini@gmail.com; prefer-encrypt=mutual; keydata=
 mQENBFeVDCUBCADQxg44Jls52jg8sAvXE2CC8BKZBXxjI2SbHtWkYdchayCiOOhSn7P+aW8F
 OEiI6qJD8/jcq5F7xQv4LZSm5KRG7RbHhfk2ZgB/yM9GksXS4lZdzu+mR1YoIc9/rtgLQ+bv
 mIfbXSyI0zidQ3mpZAmfIxLg8aNNAbW6AIafCwmUS847cK3vadzu1Jc5j3VLFATkh4eb0HXR
 tbwtqqvLLKqXBfre4sMysUFK/0bcF4FtGBw89iMD9CpXKtTF+UmJ8Ir7/eK4qUIPMvCCvpcO
 wH38xP1biWKzknmK0NDgDmUOVAgPB82puYJHZwGLHB2K1Wl+kBR0td1LrOP7+XCMUELjABEB
 AAG0IkN5cnVzLlNoIDxzaXJ1cy5zaGFoaW5pQGdtYWlsLmNvbT6JATgEEwECACIFAleVDCUC
 GwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJELUzPfwK/ZGvHn4H/iSfPYufKTwJU9DD
 ynx5/HsyMOGh5JKXyDu84WE3+8jlNXKNCpPAHylvCE1CgIF6d4W60Zy7sSgOep3svKSdo9A0
 qbajUttEv2xSuv4il+8Z3QcdVnHw11IoQxj/ayxsctPDDYvk/7vPmVXMZEnpIbDw/nPzR+Jt
 axa/xWOp8kufOSc7DdP2OiRTXLqddCM6uWqL/ckvmvBB58BP4QYedUEZxxaMj3/ErzEGEjUY
 tke796IU8HWcc/venQfPEEuHgNsfgbXtUiKu4UBAhVmXwCRgrUodd+9ZJlqYOY56e9y6bLjj
 gw3Ls8Du7SsRP/apFwnbQMbLpxiPOSUWYngNGOK5AQ0EV5UMJQEIAMLFZAP8zwnD8Q/smVtJ
 8ltJn1w1gNuUTEQvIzGTYVTW1E5LqZZB+RLte+UH+uZ04ii2/Qm+//xk23gq+4wQvlX8Vpxj
 gEyaZl2QibaUWDzh+1w4XcLHs9su37kSQoBljm86fk4qgnyTDxTa4sUACZzj+dT6tvxM+yYg
 WM2rglpFQ2d4boAa0/ScEXOVhPKV7D8jVSerK8Jb1jDjG3zovS8h6+Sv3II50K2Fwg+qLz6r
 KQRcxqM7FTBrurug8HGpYXwUs96ZtkOvdBr0Rll9ibi/3ksNbVJVJqKixIHxHwoddfDqS3Xc
 t1F0spHPkZK1FB5Kj7gvlFq8Fd8N7S2tescAEQEAAYkBHwQYAQIACQUCV5UMJQIbDAAKCRC1
 Mz38Cv2Rr6ZXB/9M3Er23Hu5/aHHceCTwPbQIsM1GzQ7vCzzb7+L908tjlc5mj1S7wNyBg+J
 XhaK3N1QYgc4ZEQiY91h3lAgiAw1fghDK9CEEcVV9RgakfLbhfMsQQj0TnhZ/afSAD84h8gZ
 K0Ilqi1XNb0quwm3lGE8SJqbM3yFV5ArMFG5QZN7O+TK+uC9Ruj3kV6hqV4LXaNJ4lug76yx
 tPbu9w6p2nOJ8d2Gv5T6K0uSoUCfplZa0hmX8ZZBYSQZLrEk0KrlorH0GZfvr1Rv2gXa6/Ne
 I9Sdj0Bd/WQRUnr8l6HlVPHA/diIFwSzo5taOqx62QXI1RbSozDjJ7QoR/gTilEDF18C
Message-ID: <2c83e862-1b1a-4ae4-256f-18f89ca4c463@gmail.com>
Date:   Thu, 16 May 2019 22:43:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the privacy issue of TCP ISN generation in Linux
kernel. Currently an adversary can deanonymize a user behind an anonymity
network by inducing a load pattern on the target machine and correlating
its clock skew with the pattern. Since the kernel adds a clock-based
counter to generated ISNs, the adversary can observe SYN packets with
similar IP and port numbers to find out the clock skew of the target
machine and this can help them identify the user.  To resolve this problem
I have changed the related function to generate the initial sequence
numbers randomly and independent from the cpu clock. This feature is
controlled by a new sysctl option called "tcp_random_isn" which I've added
to the kernel. Once enabled the initial sequence numbers are guaranteed to
be generated independently from each other and from the hardware clock of
the machine. If the option is off, ISNs are generated as before.  To get
more information about this patch and its effectiveness you can refer to my
post here:
https://cyrussh.com/?p=285
and to see a discussion about the issue you can read this:
https://trac.torproject.org/projects/tor/ticket/16659

Signed-off-by: Sirus Shahini <sirus.shahini@gmail.com>
---
diff -uprN -X dontdiff a/include/net/tcp.h b/include/net/tcp.h
--- a/include/net/tcp.h	
+++ b/include/net/tcp.h	
@@ -242,6 +242,7 @@ void tcp_time_wait(struct sock *sk, int
 
 /* sysctl variables for tcp */
 extern int sysctl_tcp_max_orphans;
+extern int sysctl_tcp_random_isn;
 extern long sysctl_tcp_mem[3];
 
 #define TCP_RACK_LOSS_DETECTION  0x1 /* Use RACK to detect losses */
diff -uprN -X dontdiff a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
--- a/include/uapi/linux/sysctl.h	
+++ b/include/uapi/linux/sysctl.h	
@@ -426,6 +426,7 @@ enum
 	NET_TCP_ALLOWED_CONG_CONTROL=123,
 	NET_TCP_MAX_SSTHRESH=124,
 	NET_TCP_FRTO_RESPONSE=125,
+	NET_IPV4_TCP_RANDOM_ISN=130,
 };
 
 enum {
diff -uprN -X dontdiff a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c	
+++ b/kernel/sysctl_binary.c	
@@ -332,6 +332,7 @@ static const struct bin_table bin_net_ip
 };
 
 static const struct bin_table bin_net_ipv4_table[] = {
+    {CTL_INT,   NET_IPV4_TCP_RANDOM_ISN     "tcp_random_isn"}
 	{CTL_INT,	NET_IPV4_FORWARD,			"ip_forward" },
 
 	{ CTL_DIR,	NET_IPV4_CONF,		"conf",		bin_net_ipv4_conf_table },
diff -uprN -X dontdiff a/net/core/secure_seq.c b/net/core/secure_seq.c
--- a/net/core/secure_seq.c	
+++ b/net/core/secure_seq.c	
@@ -22,6 +22,8 @@
 static siphash_key_t net_secret __read_mostly;
 static siphash_key_t ts_secret __read_mostly;
 
+static siphash_key_t last_secret = {{0,0}} ; 
+
 static __always_inline void net_secret_init(void)
 {
 	net_get_random_once(&net_secret, sizeof(net_secret));
@@ -133,12 +135,33 @@ u32 secure_tcp_seq(__be32 saddr, __be32
 		   __be16 sport, __be16 dport)
 {
 	u32 hash;
-
+	u32 temp;
+	
 	net_secret_init();
+	
+	if (sysctl_tcp_random_isn){
+		if (!last_secret.key[0] && !last_secret.key[1]){
+			memcpy(&last_secret,&net_secret,sizeof(last_secret));	
+					
+		}else{
+			temp = *((u32*)&(net_secret.key[0]));
+			temp >>= 8;
+			last_secret.key[0]+=temp;
+			temp = *((u32*)&(net_secret.key[1]));
+			temp >>= 8;
+			last_secret.key[1]+=temp;
+		}
+		hash = siphash_3u32((__force u32)saddr, (__force u32)daddr,
+			        (__force u32)sport << 16 | (__force u32)dport,
+			        &last_secret);
+		return hash;
+	}
+		
 	hash = siphash_3u32((__force u32)saddr, (__force u32)daddr,
 			    (__force u32)sport << 16 | (__force u32)dport,
 			    &net_secret);
 	return seq_scale(hash);
+		
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
diff -uprN -X dontdiff a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c	
+++ b/net/ipv4/sysctl_net_ipv4.c	
@@ -437,6 +437,13 @@ static int proc_fib_multipath_hash_polic
 #endif
 
 static struct ctl_table ipv4_table[] = {
+    {
+    	.procname	= "tcp_random_isn",
+		.data		= &sysctl_tcp_random_isn,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec  
+    },
 	{
 		.procname	= "tcp_max_orphans",
 		.data		= &sysctl_tcp_max_orphans,
diff -uprN -X dontdiff a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c	
+++ b/net/ipv4/tcp_input.c	
@@ -80,6 +80,7 @@
 #include <linux/static_key.h>
 #include <net/busy_poll.h>
 
+int sysctl_tcp_random_isn __read_mostly = 0;
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 
 #define FLAG_DATA		0x01 /* Incoming frame contained data.		*/
