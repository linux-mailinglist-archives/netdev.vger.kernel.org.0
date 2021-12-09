Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC2746E3DA
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhLIIPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:15:49 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:59736
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234438AbhLIIPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:15:49 -0500
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0F3DC3F1BA
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 08:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639037535;
        bh=fBYCECAJevs/zh6Lenm9Wbk6Z5sCtP6TImy1jaIY/bc=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=krnz8Yhqxhb2tgRM696JPvr5GYf8j36xCaYTuIDaKAIwGp9mY7HXZv/eQzGQJXYEO
         7x5N4eB0JzgdHIL3sczC2UyJ9Fh6Jf1afuZdruYlCG9QFY7par6u/LY5j+Y794H5nl
         DJEyDOX6YHB1I7PxWYDGyXsHea5WWeNyzqgkM9Gzb1r+dFl1JMPBwf0xlqJS7AVebz
         y7azEReOsRxPCNa3H9DuL/FCBX6xLnzonRi7h+vdmwP98VYIJvN5oxFXHRojLznwxN
         co/MTjHkB91Jhc+glIRe4XMXl01WAK0dsATcw8TMfON+PFGAye9j7bVefpLr2MxNyR
         kZfi1zD27I24g==
Received: by mail-lj1-f199.google.com with SMTP id 83-20020a2e0556000000b00218db3260bdso1515212ljf.9
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 00:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fBYCECAJevs/zh6Lenm9Wbk6Z5sCtP6TImy1jaIY/bc=;
        b=nbqfWZ5F+NTWRv9XYrf5LavQrDnfg9nQgK4saiqIShJgY+abunJkzHwtPwB/nKQnJY
         q+SvcORYf3XzySWp1RzC3OcqLnQiWgfqXqY/GiFcLBzt4Dhd9mM1ZN98OYoX5F8Ew8GU
         67OrFa6q4VLOVKreWHQ7j3m4TfTLo8njvqJgc/GXSVHEGFeFngli3ucAWWRrDl99YvUg
         WERMv/SsI4pz9wHFWf6dz2/d4G3v1KnYKnIvwMoY1gsYbRICqNXEYxGA2m04BqNhl98H
         XZJgCYHpNxUHx5/pavRJuwD2VLb3VlxtDwAY2tPe1AmA4TpI4i7bCbKFS7mromMyPArb
         wC9Q==
X-Gm-Message-State: AOAM531TTjbDt1/tmbDXTYwUMFohKSivJ1zErRDmMbUCDye1GJ3QFBQY
        UXdrjI9lrY+lRZXXksDDlfEqt8APCc8/cGvk/1+0r/AaD3H4cfs9IvGglEoVwPdm7wHzG3KRLmu
        SgmNUhYo8rM46s2WhVtE0VgnCyqkmx5iIig==
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr4372058lfr.663.1639037533929;
        Thu, 09 Dec 2021 00:12:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzCh6D9KFbIjH70+q4mk9ijSh2M0NWaUeJ3/1sGWaRnyi/AyAL30CqWfzi7r4a7vbfvvzEbA==
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr4372037lfr.663.1639037533607;
        Thu, 09 Dec 2021 00:12:13 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id g26sm499826ljn.107.2021.12.09.00.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 00:12:12 -0800 (PST)
Message-ID: <20dcbf40-0ca0-690d-182a-e21ee6af1db4@canonical.com>
Date:   Thu, 9 Dec 2021 09:12:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] nfc: fix segfault in nfc_genl_dump_devices_done
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com
References: <20211208182742.340542-1-tadeusz.struk@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211208182742.340542-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2021 19:27, Tadeusz Struk wrote:
> When kmalloc in nfc_genl_dump_devices() fails then
> nfc_genl_dump_devices_done() segfaults as below
> 
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 5.16.0-rc4-01180-g2a987e65025e-dirty #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 04/01/2014
> Workqueue: events netlink_sock_destruct_work
> RIP: 0010:klist_iter_exit+0x26/0x80
> Call Trace:
> <TASK>
> class_dev_iter_exit+0x15/0x20
> nfc_genl_dump_devices_done+0x3b/0x50
> genl_lock_done+0x84/0xd0
> netlink_sock_destruct+0x8f/0x270
> __sk_destruct+0x64/0x3b0
> sk_destruct+0xa8/0xd0
> __sk_free+0x2e8/0x3d0
> sk_free+0x51/0x90
> netlink_sock_destruct_work+0x1c/0x20
> process_one_work+0x411/0x710
> worker_thread+0x6fd/0xa80
> 
> Link: https://syzkaller.appspot.com/bug?id=fc0fa5a53db9edd261d56e74325419faf18bd0df
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  net/nfc/netlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Cc: <stable@vger.kernel.org>
Fixes: 4d12b8b129f1 ("NFC: add nfc generic netlink interface")

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

I will fix other similar cases.

Best regards,
Krzysztof
