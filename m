Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03361F1CE3
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgFHQGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730378AbgFHQGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:06:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15DFC08C5C2;
        Mon,  8 Jun 2020 09:06:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s18so19309699ioe.2;
        Mon, 08 Jun 2020 09:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=m0MCfyAVvG/TnOOlixlSlNHg0o6ZIZMmhOPM1yKrMsk=;
        b=sfxTc+T/k0Mho9L39uU9FVHb2ybu9cUIVG5skJKsPQcUIXMFQz8B8iqv7vWuAnpO76
         qkRvSDxdWhNDz/fv9x3vu+QDY9mkoRnflPz3codabnyVY61rQUtwJNvXHN0ns1hlPnux
         jxWt3I6Pxgs+RsCf6b7UcCIKJAibJ9yOJq5mskdqiFtEhnRzBkgBHyS/MEIUmvAqQFCC
         QgOcnoY73Ai7zb+tLr/fEmbxeFJpVW1/XsquQz1o697ZzfzABPdQwYetdWaKEioi7TqX
         s9ZvHXvFa01646sIIXO+oDGzJEMiDzP6gGHx++foHf1hw0FpCd+XmK3o4dwfzvW4c1LM
         dLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=m0MCfyAVvG/TnOOlixlSlNHg0o6ZIZMmhOPM1yKrMsk=;
        b=omd55WAnrrhdYzrW2iSnfr4tuMGat+ci7m+IkVXGghtMgmYLP//bfLf24sO4RZ38WC
         5hjYIn6KtuHA8QQ5O7H6Xe32tNcSpEmMWNhlxpBUC3qyMa/wLwx8QJ3aU1F2YLBON2G+
         c11rYS1eXlSHzO5MoRkrQSKBI+FqhhuoGOKQaJ1gNnKyij/JvOHYRlWhE4PfrZhbSDyj
         v3QHRPlvJO8rt71ki/PMmXz5ln9ysysjp7nB7fEKra6AXzMvpeo8ndNYGjkcSzHhoOFT
         S5PpZbTwEUg6sQSt+s/ofIY7TgtBkkuJqg3GO3Z9FrQCWJDp9F1dq5ZFySCNHKZiYtSA
         zpJw==
X-Gm-Message-State: AOAM532LIgFbCifp34u5UqyawIKGYyK6JaI+nO/DodnWRx7a8Z6m3M9J
        EoK6+q8WyhVEq2lZokQrUk2CJOgbXAw=
X-Google-Smtp-Source: ABdhPJwyZT+R6bq/65KQY0F4Egc1frdjkNNDesAzriYQHZ6yXj6Q/iRLH4JyhjGh9oMil22yUeIS0Q==
X-Received: by 2002:a6b:9144:: with SMTP id t65mr20397005iod.99.1591632396889;
        Mon, 08 Jun 2020 09:06:36 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c3sm1866364ilr.45.2020.06.08.09.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 09:06:35 -0700 (PDT)
Date:   Mon, 08 Jun 2020 09:06:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     dihu <anny.hu@linux.alibaba.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, dihu <anny.hu@linux.alibaba.com>
Message-ID: <5ede6203aba1d_2c272afa690ca5c4c6@john-XPS-13-9370.notmuch>
In-Reply-To: <20200605084625.9783-1-anny.hu@linux.alibaba.com>
References: <20200605084625.9783-1-anny.hu@linux.alibaba.com>
Subject: RE: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dihu wrote:
> When user application calls read() with MSG_PEEK flag to read data
> of bpf sockmap socket, kernel panic happens at
> __tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
> queue after read out under MSG_PEEK flag is set. Because it's not
> judged whether sk_msg is the last msg of ingress_msg queue, the next
> sk_msg may be the head of ingress_msg queue, whose memory address of
> sg page is invalid. So it's necessary to add check codes to prevent
> this problem.
> 
> [20759.125457] BUG: kernel NULL pointer dereference, address:
> 0000000000000008
> [20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
> 5.4.32 #1
> [20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
> 4.1.12 06/18/2017
> [20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
> [20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
> [20759.276099] tcp_bpf_recvmsg+0x113/0x370
> [20759.281137] inet_recvmsg+0x55/0xc0
> [20759.285734] __sys_recvfrom+0xc8/0x130
> [20759.290566] ? __audit_syscall_entry+0x103/0x130
> [20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
> [20759.301700] ? __audit_syscall_exit+0x1e4/0x290
> [20759.307235] __x64_sys_recvfrom+0x24/0x30
> [20759.312226] do_syscall_64+0x55/0x1b0
> [20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Signed-off-by: dihu <anny.hu@linux.alibaba.com>
> ---
>  net/ipv4/tcp_bpf.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Thanks, looks good to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>
