Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF81B602D61
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiJRNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJRNu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:50:29 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A257AC0C
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:50:24 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id i65so11784497ioa.0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsKL3kH6OF1w/NZ+YY872M+o6HjD/ZEJcQjJ7Y+vwpw=;
        b=HajVnk1eg9uLTv7YCLsDxaVaPB9u0Ed61Bwgi0RziGzSnqfkC/k8yuww8ORMkTp/5j
         63fdYBARZPO3MrmOKHFlR8ZemWyWwpmCeDkWMBIHVzy04uzTytjW35/c/+AfiATytesF
         s6z0vl0J0ozdiWUIlbO9YUtFd7PPhUuSbkrFJMAWU0+vaUsUSEtlxerTirftdgGE5gCL
         OWOxf0gBBmu5QO3hJShPUi91lgce46UrO8XG+vjS13y+uZZM3i9TYob7o4Bbljwtu0mF
         Z2KZ2oWJwB4magSZFP9DWXbNlRuqMZMUXwTDjH6TP9Q0DZHzG8id//P4SlyMNljEQtm0
         lslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZsKL3kH6OF1w/NZ+YY872M+o6HjD/ZEJcQjJ7Y+vwpw=;
        b=ea7h7KvrCEcYj/g3hmYqqduuJ0e2NTANKf3DnR+wUokpUNS2KAmpUQ8sNwCq6vRFWL
         LJklUJrif5ETIKozGqqStaoPkm02R2W2rHds3DLW7fYAc63H18J1hxigtCAL/nJxtJCU
         YHB/mBcpOKM/1kCvRMXjK9KsMOykWRtbrS5kM3VqMtKlL7nmDmfTOUBPl9cI+3bBVA+C
         wmE1j2OqRhugMZkPOWn6Uhfu2P6N9K2+mlT+zTQd+0AgN+JeFZzbAzNnPsvWLqO3GJyV
         emBxRmfOeLTqMaFwn2TyoQ+A0widSE9Y2/QPBYpfUYGLrgMz9pyYZanRchMeJTkUFRnX
         SyYg==
X-Gm-Message-State: ACrzQf2vvqjWyXL5z/Gw7kHe9EDPQ25UW7s/7RDdGJlINWVuBROn2DgQ
        BzpplUGGmZ8uoY7jcS5xs9eifWNlBU0Yfci4Y9D9JnW2aixCtg==
X-Google-Smtp-Source: AMsMyM7gF8ouCSIgFKO73wrmeEOhbp9KO17ul8RVYyXFtJSHxsDpUQnfPSoOZhzhVmBrWxYUFL0vIPdd6Ptm9T0MFYo=
X-Received: by 2002:a5d:9c5a:0:b0:6bc:c117:4be4 with SMTP id
 26-20020a5d9c5a000000b006bcc1174be4mr1742295iof.179.1666101024396; Tue, 18
 Oct 2022 06:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221018131607.1901641-1-yangyingliang@huawei.com>
In-Reply-To: <20221018131607.1901641-1-yangyingliang@huawei.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 18 Oct 2022 17:50:22 +0400
Message-ID: <CAHNKnsRrrHV7hdie==inxuPat5=K9-9EcSNwsrq2QSRfvZVs1g@mail.gmail.com>
Subject: Re: [PATCH net] wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, loic.poulain@linaro.org,
        johannes@sipsolutions.net, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Yang,

On Tue, Oct 18, 2022 at 5:17 PM Yang Yingliang <yangyingliang@huawei.com> wrote:
> Inject fault while probing module, if device_register() fails,
> but the refcount of kobject is not decreased to 0, the name
> allocated in dev_set_name() is leaked. Fix this by calling
> put_device(), so that name can be freed in callback function
> kobject_cleanup().
>
> unreferenced object 0xffff88810152ad20 (size 8):
>   comm "modprobe", pid 252, jiffies 4294849206 (age 22.713s)
>   hex dump (first 8 bytes):
>     68 77 73 69 6d 30 00 ff                          hwsim0..
>   backtrace:
>     [<000000009c3504ed>] __kmalloc_node_track_caller+0x44/0x1b0
>     [<00000000c0228a5e>] kvasprintf+0xb5/0x140
>     [<00000000cff8c21f>] kvasprintf_const+0x55/0x180
>     [<0000000055a1e073>] kobject_set_name_vargs+0x56/0x150
>     [<000000000a80b139>] dev_set_name+0xab/0xe0
>
> Fixes: f36a111a74e7 ("wwan_hwsim: WWAN device simulator")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Nice catch!

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
