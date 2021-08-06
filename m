Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28D3E2494
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbhHFHyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:54:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230364AbhHFHyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628236425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwKjSicg1/CC2JCNXAf9DmDABT5ux8HSbuTo0nyJ9FU=;
        b=PWBq4j378yRbuzBlK8Tg1mPvZzgIAFr7+PXQzzdFKrCSfmlhnYBj2miP57Zldn1bOlTPJh
        m6VV0ytS3IRq/CxiO8yaprcIJ8NiIDKJ4jAWSrdv7Aj4zuyH7umchvNHT0MdejcdkD4zMv
        pA9FUHCdsBOzne6/XrYRzuKEWUHSrbI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-xhR6Y09mPpOGVRdM9p-E6A-1; Fri, 06 Aug 2021 03:53:44 -0400
X-MC-Unique: xhR6Y09mPpOGVRdM9p-E6A-1
Received: by mail-wr1-f69.google.com with SMTP id l7-20020a5d48070000b0290153b1557952so2879025wrq.16
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 00:53:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hwKjSicg1/CC2JCNXAf9DmDABT5ux8HSbuTo0nyJ9FU=;
        b=qNzUWRLMvmDhZjk4FwyTpo5AndHef/qgksExmprnVn/rWiq8l/t7Sn6RNg7U0sLyLP
         Uab1YWqGu02rJxlpUvPyJunbdNTvhuNbAibkWzVWAjVl4SQp6qbYH9xRURtXLO0rf4Z4
         CSdMu6aNlWslpDtJo3oWgEeaHuOZDOeBd8I2ZGdpniPAjI7CIQZ/AGXQraYXfnYdOH+M
         VJuWas3xrytw5APNlpChfxlneKssYydZdRqRL3coDWljMaRhqP1rayfw98HxR7vCUqxd
         o7PsiZuiF5oXEFI2OjzB1Aw5HcDOeEzFDt97RXUPsq0aIoZ7cZtS8sdXWj6KOp6RwWtQ
         QdrQ==
X-Gm-Message-State: AOAM533Xjn33ZpfzoHeUGaigvd1Hf+Gk2qT9W7O0AUydJUfmkgMgkfv7
        oUn31rPnWLEHNaQxwc6QhgWewqi03uI6nvCuqyludABGIWGf4dy6CEQDmo48G1KcqRf+tANH8v7
        s7d5TExOZtEnYSyDP
X-Received: by 2002:a5d:6949:: with SMTP id r9mr9476122wrw.159.1628236422904;
        Fri, 06 Aug 2021 00:53:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQIESAfAll03UZKaCptqbt/ezz+ta6/vmap5cj3mC8fmZFMULX/8cXXmickpnNEW+KHzwQqg==
X-Received: by 2002:a5d:6949:: with SMTP id r9mr9476112wrw.159.1628236422711;
        Fri, 06 Aug 2021 00:53:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-240-80.dyn.eolo.it. [146.241.240.80])
        by smtp.gmail.com with ESMTPSA id l4sm8525108wrw.32.2021.08.06.00.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:53:42 -0700 (PDT)
Message-ID: <ed3b7303f1acb2487f001dbbf3122d52cc0a22f7.camel@redhat.com>
Subject: Re: [net-next] WARNING: CPU: 2 PID: 1189 at
 ../net/core/skbuff.c:5412 skb_try_coalesce+0x354/0x368
From:   Paolo Abeni <pabeni@redhat.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev <netdev@vger.kernel.org>
Date:   Fri, 06 Aug 2021 09:53:41 +0200
In-Reply-To: <dcf8012a-ffa5-f5ab-af68-5c59a410299f@ti.com>
References: <dcf8012a-ffa5-f5ab-af68-5c59a410299f@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2021-08-05 at 22:04 +0300, Grygorii Strashko wrote:
> with current net-next is see below splat when run netperf TCP_STREAM
> 
> <REMOTE HOST> netperf -l 10 -H 192.168.1.2 -t TCP_STREAM -c -C -j -B "am6 " -s 1 -s 1
> 
> Is this know issue?
> 
> <FAILED DUT>
> root@am65xx-evm:~# uname -a
> Linux am65xx-evm 5.14.0-rc3-00973-g372bbdd5bb3f #5 SMP PREEMPT Thu Aug 5 21:57:28 EEST 2021 aarch64 GNU/Linux
> 
> root@am65xx-evm:~# [  227.929271] ------------[ cut here ]------------
> [  227.933917] WARNING: CPU: 2 PID: 1189 at ../net/core/skbuff.c:5412 skb_try_coalesce+0x354/0x368
> [  227.942624] Modules linked in:
> [  227.945679] CPU: 2 PID: 1189 Comm: netserver Not tainted 5.14.0-rc3-00973-g372bbdd5bb3f #5
> [  227.953931] Hardware name: Texas Instruments AM654 Base Board (DT)
> [  227.960098] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> [  227.966097] pc : skb_try_coalesce+0x354/0x368
> [  227.970449] lr : tcp_try_coalesce.part.74+0x48/0x180
> [  227.975410] sp : ffff80001544fa40
> [  227.978716] x29: ffff80001544fa40 x28: ffff0008013a0dc0 x27: 0000000000000000
> [  227.985851] x26: 0000000000000000 x25: 0000000000002d20 x24: ffff000809f25240
> [  227.992984] x23: ffff000809f286c0 x22: 0000000000002d40 x21: ffff80001544fac4
> [  228.000118] x20: ffff000807536600 x19: ffff000807535800 x18: 0000000000000000
> [  228.007251] x17: 0000000000000000 x16: 0000000000000000 x15: ffff00080794a882
> [  228.014384] x14: 72657074656e0066 x13: 0000000000000080 x12: ffff000800792e58
> [  228.021517] x11: 0000000000000000 x10: 0000000000000001 x9 : ffff000000000000
> [  228.028650] x8 : 0000000000002798 x7 : 00000000000005a8 x6 : ffff000809f24c82
> [  228.035783] x5 : 0000000000000000 x4 : 0000000000000640 x3 : 0000000000000001
> [  228.042915] x2 : ffff80001544fb57 x1 : 0000000000000007 x0 : ffff000809f286c0
> [  228.050050] Call trace:
> [  228.052490]  skb_try_coalesce+0x354/0x368
> [  228.056497]  tcp_try_coalesce.part.74+0x48/0x180
> [  228.061108]  tcp_queue_rcv+0x12c/0x170
> [  228.064853]  tcp_rcv_established+0x558/0x6f8
> [  228.069118]  tcp_v4_do_rcv+0x90/0x220
> [  228.072775]  __release_sock+0x70/0xb8
> [  228.076439]  release_sock+0x30/0x90
> [  228.079926]  tcp_recvmsg+0x90/0x1d0
> [  228.083411]  inet_recvmsg+0x54/0x128
> [  228.086983]  __sys_recvfrom+0xbc/0x148
> [  228.090728]  __arm64_sys_recvfrom+0x24/0x38
> [  228.094906]  invoke_syscall+0x44/0x100
> [  228.098655]  el0_svc_common+0x3c/0xd8
> [  228.102314]  do_el0_svc+0x28/0x90
> [  228.105626]  el0_svc+0x24/0x38
> [  228.108679]  el0t_64_sync_handler+0x90/0xb8
> [  228.112857]  el0t_64_sync+0x178/0x17c
> [  228.116517] ---[ end trace 2e0ec9d02424634a ]---        0

The above should be fixed by the net-next
commit af352460b465d7a8afbeb3be07c0268d1d48a4d7

Could you please have a shot at that?

Thanks!

Paolo



