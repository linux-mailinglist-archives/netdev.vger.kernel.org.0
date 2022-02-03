Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA04E4A839F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350200AbiBCMOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:14:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235416AbiBCMOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:14:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643890475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODOQArJJvYfML0pKRD0g+/Ott6+hxp0VKQUHIOq19B0=;
        b=YLzEtk94eShGmSo/4aiMqBqkZJD3fPEzRyduLkZrV6i6CsQsrx8HN4Gc2dRGQr8XDOF5n9
        nMupTjY3ioYj1h3l084CpWfgTsuITG/U4JoF8TWyWbgCmOxenlqlx1lkZwGcY4quB4mgFE
        c7H8IsUhO4MPPCNPIwaO9fE/ASOF/Q4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-5w9OcBacMbm72nBKzCuCsg-1; Thu, 03 Feb 2022 07:14:32 -0500
X-MC-Unique: 5w9OcBacMbm72nBKzCuCsg-1
Received: by mail-qt1-f197.google.com with SMTP id e28-20020ac8415c000000b002c5e43ca6b7so1740415qtm.9
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 04:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ODOQArJJvYfML0pKRD0g+/Ott6+hxp0VKQUHIOq19B0=;
        b=4d8z0w8VUh98FlnCI/scOyKdLFeArIXP9Ldz+va/vBWvEHyt0gq774HoaQZB9cQufr
         SWoRRy0CD414uX/unDf25J8AcUwi7YvcfQFLbp/V6+kIyZ7Z7q6RSZmEX8knViw7yzIj
         Vy5nf4lxxCWrCfAWen1nHC6z6kNXgfTz0DJB2QmFli1A6Fhi8raVMJsUDQ+1I3mdQI8y
         y2hs/aEKBkpIn7/V9+urUvh5h0j7BGZT+/MaXV3OJXxuhkC1okrZXG3yAkbeeRgZGuCE
         4zmoG12Iu3DFLd6N6wQmZRxrDgR2kXunEKs5CalFqGpMMbKdD2HBqDuejh0oSkyyWB9o
         rcAg==
X-Gm-Message-State: AOAM532BRTwo4I103GAieT0Y3sff8TxDKrsx6VF7x0QWio02VVvVjX42
        AUFaO/hYKlhGCQYNRnjtS10FpYAwzRwTKz/F2SYOEjm7ex945iMQKUd6S7tptJofmft1f12kUd6
        hOUZ8EX4kx1FCs012
X-Received: by 2002:a05:6214:5189:: with SMTP id kl9mr30379816qvb.9.1643890471144;
        Thu, 03 Feb 2022 04:14:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvpa629qj80OU8UG9SO57p7Cq9/hr+NM7WkasmLeij/E+wi2zQVqhlpjDAIKoUxNu4dkHDwQ==
X-Received: by 2002:a05:6214:5189:: with SMTP id kl9mr30379687qvb.9.1643890468898;
        Thu, 03 Feb 2022 04:14:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j186sm13350515qkb.57.2022.02.03.04.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:14:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CFC02180703; Thu,  3 Feb 2022 13:14:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 2/4] net: dev: Remove get_cpu() in
 netif_rx_internal().
In-Reply-To: <20220202122848.647635-3-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-3-bigeasy@linutronix.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Feb 2022 13:14:26 +0100
Message-ID: <87sft0b10d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> The get_cpu() usage was added in commit
>     b0e28f1effd1d ("net: netif_rx() must disable preemption")
>
> because ip_dev_loopback_xmit() invoked netif_rx() with enabled preemtion
> causing a warning in smp_processor_id(). The function netif_rx() should
> only be invoked from an interrupt context which implies disabled
> preemption. The commit
>    e30b38c298b55 ("ip: Fix ip_dev_loopback_xmit()")
>
> was addressing this and replaced netif_rx() with in netif_rx_ni() in
> ip_dev_loopback_xmit().
>
> Based on the discussion on the list, the former patch (b0e28f1effd1d)
> should not have been applied only the latter (e30b38c298b55).
>
> Remove get_cpu() since the function is supossed to be invoked from
> context with stable per-CPU pointers (either by disabling preemption or
> software interrupts).
>
> Link: https://lkml.kernel.org/r/20100415.013347.98375530.davem@davemloft.=
net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

