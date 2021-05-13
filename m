Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A289137F3DC
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 10:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhEMIHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 04:07:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhEMIGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 04:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620893144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atqrAmaf3840CzupKFx4SPR74UQ6jXvWuELLASaNxTQ=;
        b=eiVM1xbPXZ+9M6FExpk6/75wHf9iLS+uA0MNcJKf8233v2ofXXGMQfOTpXK6cSPiHwLToz
        66f61asLCV1PXUw2DCHP91mVUIo7C+o8rtkCe4a6C2ZXsPmkZswyD/Kn0vZ3BZSxSTFTs3
        Ht3lbRB7NzjRItUjBxBYkov2x0t6jek=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-mng0evmQMsGZXghO5_D8KA-1; Thu, 13 May 2021 04:05:42 -0400
X-MC-Unique: mng0evmQMsGZXghO5_D8KA-1
Received: by mail-wm1-f72.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso1897733wmj.0
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 01:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=atqrAmaf3840CzupKFx4SPR74UQ6jXvWuELLASaNxTQ=;
        b=R6PzLb/mxJ88j0QmiXlDxayzD7Z39EEILtgf4QnCU9HDWsSrz4x7Tn3TNqc/38fwwX
         LQ+hfdCeGw9BRkA413LTj+bKsY6QHrgTtf0YmIpVtn+m3K69QJIUFyntrm5ONGiwu3Bj
         Dp7voFcC0i9BT6QB8EsUagTi2PGDnQ1eW4FGv2Zq0h20nIfMynDl216vrxH++l/okLhg
         55os9+IZ18ZViN9ozV0kgbNExc9ssrNsunDPSrlwV+9QEC0qYYtXFzN2vVTQasQr+mWK
         PUGSaJ8kcyobbHS0RC1fZtfE+Jl9du19cl2NyX/vmB6ZzbSNtGTdzps2pUrrUmUi9WSx
         ix3Q==
X-Gm-Message-State: AOAM532N6834huq4Ha7KekcvxaDni6gVI9BEee419SVCSkKJOlTpySlQ
        ZR2BaZcoDEx+umSiGDOHpr/8Hc69avcsAbG230Rn9hvh/S3SApMU1oofpF7FfQuVcy4ESE1L1yZ
        I374cKzTx4ycWJz+Y
X-Received: by 2002:a7b:c346:: with SMTP id l6mr5861589wmj.109.1620893141446;
        Thu, 13 May 2021 01:05:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXb/JI/qQf4+lG42PiaqwmZus9XISegjL09b8+79VKZ5yfg0r4QWX1mXG2ABwep5fqJeebUw==
X-Received: by 2002:a7b:c346:: with SMTP id l6mr5861569wmj.109.1620893141190;
        Thu, 13 May 2021 01:05:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-162.dyn.eolo.it. [146.241.242.162])
        by smtp.gmail.com with ESMTPSA id v20sm1666258wmj.15.2021.05.13.01.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:05:40 -0700 (PDT)
Message-ID: <a0728eea0f9f2718a6c4bc0f12ba129f1ed411b7.camel@redhat.com>
Subject: Re: Panic in udp4_lib_lookup2
From:   Paolo Abeni <pabeni@redhat.com>
To:     kapandey@codeaurora.org, willemb@google.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        sharathv@codeaurora.org, subashab@codeaurora.org
Date:   Thu, 13 May 2021 10:05:37 +0200
In-Reply-To: <eda8bfc80307abce79df504648c60eae@codeaurora.org>
References: <eda8bfc80307abce79df504648c60eae@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2021-05-12 at 23:51 +0530, kapandey@codeaurora.org wrote:
> We observed panic in udp_lib_lookup with below call trace:
> [136523.743271]  (7) Call trace:
> [136523.743275]  (7)  udp4_lib_lookup2+0x88/0x1d8
> [136523.743277]  (7)  __udp4_lib_lookup+0x168/0x194
> [136523.743280]  (7)  udp4_lib_lookup+0x28/0x54
> [136523.743285]  (7)  nf_sk_lookup_slow_v4+0x2b4/0x384
> [136523.743289]  (7)  owner_mt+0xb8/0x248
> [136523.743292]  (7)  ipt_do_table+0x28c/0x6a8
> [136523.743295]  (7) iptable_filter_hook+0x24/0x30
> [136523.743299]  (7)  nf_hook_slow+0xa8/0x148
> [136523.743303]  (7)  ip_local_deliver+0xa8/0x14c
> [136523.743305]  (7)  ip_rcv+0xe0/0x134

It would be helpful if you could provide a full, decoded, stack trace
and the relevant kernel version.

> We suspect this might happen due to below sequence:

Some email formatting made the "graph" very hard to read...

> Time                                                   CPU X             
>                                                                           
>                                     CPU Y
> t0                                inet_release -> udp_lib_close -> 
> sk_common_release -> udp_lib_unhash                            
> inet_diag_handler_cmd -> udp_diag_destroy -> __udp_diag_destroy -> 
> udp_lib_rehash

... but it looks like udp_lib_close() is missing a
lock_sock()/release_sock() pair. Something alike:
---
diff --git a/include/net/udp.h b/include/net/udp.h
index 360df454356c..06586b42db3f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -209,7 +209,9 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
 
 static inline void udp_lib_close(struct sock *sk, long timeout)
 {
+	lock_sock(sk);
 	sk_common_release(sk);
+	release_sock(sk);
 }
 
 int udp_lib_get_port(struct sock *sk, unsigned short snum,
---

could u please give the above a spin in your testbed?

Thanks!

Paolo


