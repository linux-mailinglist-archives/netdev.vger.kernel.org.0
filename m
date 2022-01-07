Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15D8486FA2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345193AbiAGBUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345195AbiAGBUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:20:07 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FAAC061245;
        Thu,  6 Jan 2022 17:20:07 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id z30so599286pge.4;
        Thu, 06 Jan 2022 17:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fw29SMG9zs2Lc8ckvr2Ud0WuhWRxk7FcTRUOfZLouWI=;
        b=qgGfeHebJnI2mPy1fCaGOSyNojWYJJpUjAS0OdJPR9/+jXwplYkVxXzIGHtZ6yjcnG
         gz45mlXRnSdJoGaVF1j0pyWogtD33YnYYOzHmW5h/TURflIeHl5AMN11OB9iZv3unziS
         DGbkpZVP7B9FkiiTC8TsWUtrR7EsO1Y+7/9oKnvAedR9PvCMOYXD6S5vjsQeQ5i1xIvZ
         2HHm+39YJ4RJIBITnFPxrBA5si/NmSWxqtXV2wHMCXrBO4lBTf6Z0X8kwnWkkScUwDYX
         7BCTErqGz9du0G5EVIMzE/vZll79EfE+cSW8qIWfRgQrBJV0adwIjwk80kisTUQFiNsq
         D4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fw29SMG9zs2Lc8ckvr2Ud0WuhWRxk7FcTRUOfZLouWI=;
        b=UP2CECRIv7hieF+dbLFvjANXRepaxn6HjtKaRn4IMIiK+2VFHlklYO/TOQSHXnDbWc
         pNOCVAh83M/uCWrCWH0mHWfKolqjeoXG2GNRQRgtEnQsP3VDNxrGzOjq/GCdBnZf7jJE
         arF+R1jgcOX2Zb5kMkhnoEU6k8q4nppZfIeJaqOWV6vey7pBo0SQ1ySyxWCX9E+l07z1
         4jVbFzHOkx4D729yyBqiWg/GA5XW+J8vS1jW8C9Lxe992Fccv2ZyKwulDuFXhyH1Bg/D
         rG3rxkIVYxzglrMxlgt4bIUmBB7jI3BlGOtQWWdcGHreHv7mN0narUurTADFdQ5N2fgq
         Sw4A==
X-Gm-Message-State: AOAM533SyZpCEz9u0GuKGZjLw4F0T1MhUu0boW/lsFuhh3J+pgO4YMpM
        0hvbUzy6uEUC9xxveT1kSBfHFKvXfVLpBf2bULM=
X-Google-Smtp-Source: ABdhPJx9kdiC9H7F8/0GppMF32c4y0gvMqPnzyIsGPRGZbsOfetEhWFolPNs9CBWNyQg47YnFWEC9mNf+MukmnZnS10=
X-Received: by 2002:a63:8f06:: with SMTP id n6mr55290339pgd.95.1641518407032;
 Thu, 06 Jan 2022 17:20:07 -0800 (PST)
MIME-Version: 1.0
References: <20220106132022.3470772-1-imagedong@tencent.com>
In-Reply-To: <20220106132022.3470772-1-imagedong@tencent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 17:19:55 -0800
Message-ID: <CAADnVQJQxaxDc6VPVRvqVbUyp7160TzxVOED_ZQgu5nxJLxQhg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 0/3] net: bpf: handle return value of
 post_bind{4,6} and add selftests for it
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 5:20 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> The return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND() in
> __inet_bind() is not handled properly. While the return value
> is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
> exit:
> exit:
>
>         err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
>         if (err) {
>                 inet->inet_saddr = inet->inet_rcv_saddr = 0;
>                 goto out_release_sock;
>         }
>
> Let's take UDP for example and see what will happen. For UDP
> socket, it will be added to 'udp_prot.h.udp_table->hash' and
> 'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
> called success. If 'inet->inet_rcv_saddr' is specified here,
> then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
> to (because inet_saddr is changed to 0), and UDP packet received
> will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
> specified here, the sock will work fine, as it can receive packet
> properly, which is wired, as the 'bind()' is already failed.
>
> To undo the get_port() operation, introduce the 'put_port' field
> for 'struct proto'. For TCP proto, it is inet_put_port(); For UDP
> proto, it is udp_lib_unhash(); For icmp proto, it is
> ping_unhash().
>
> Therefore, after sys_bind() fail caused by
> BPF_CGROUP_RUN_PROG_INET4_POST_BIND(), it will be unbinded, which
> means that it can try to be binded to another port.
>
> The second patch use C99 initializers in test_sock.c
>
> The third patch is the selftests for this modification.
>
> Changes since v4:
> - use C99 initializers in test_sock.c before adding the test case

Thanks for the fix. Applied.

In the future please make sure to tag your patches with
[PATCH bpf-next]
so that BPF CI can properly test it right away.
