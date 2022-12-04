Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FC8642020
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 23:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiLDWuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 17:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiLDWuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 17:50:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6E2F5B7
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 14:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670194189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UAH0a91c7U1jqtpok3gsbLLRM6v87SVVxbB37wK7DIA=;
        b=SuQ0ZUpGPt7tq88pOql0fGwIaBDkg4veBYlu6GcJd7bmOefMgVHCCkwy3fDTCuQVwzkx5b
        r2oFomw6LIBXaBb4zGHJlodqOZTXQX0pQmcibeOAeP5seukXSHIOgFL+rvVvThtWtDd8/3
        SHoIkNn6GpYUF3gmXn9/Dlz63osqKC8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-sWcJ6C38PZ2fihfHEx7cAA-1; Sun, 04 Dec 2022 17:49:48 -0500
X-MC-Unique: sWcJ6C38PZ2fihfHEx7cAA-1
Received: by mail-ed1-f71.google.com with SMTP id w4-20020a05640234c400b004631f8923baso4687104edc.5
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 14:49:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UAH0a91c7U1jqtpok3gsbLLRM6v87SVVxbB37wK7DIA=;
        b=XK98EPEo0dwaAQAYoKTzhvors29zAtU3298jSpEq1le1RXcMWwpmBD4wbWCNMpBKD8
         Z/hE3qcPH6hRKY+kE0n6jNCB9ezrZ+SHw7PilRd4MofrhYMF9XASfH1KuQZ7Kc3ooHAE
         9OXQErdFFtOHFAC1VYsn6uhePi5RzvaclykkNhiuME7h1LfYPrI7rFGzcxzvkoFnGT4d
         ggCDIP/JA2V3JVR0bwBBmrXe/aFA6aJCgaj1OVE6sdIjUr8CZ1J9/1JDKMdmNG5PI4D0
         nVtoPy7yNvFkXSePIx+sV2hrQTK6sRq9hQLgsuQ+GomEQ2ASg2KhIXaFaGzCjDVxSi3E
         8fDQ==
X-Gm-Message-State: ANoB5pkM06kDXxERvkFFWZhI/jtZ07wOdQx4soyiCRR5pdk+K1MrBSlw
        jGEgrxyGZTEsP7zv4Kofsr8D8LcNK08jA5uSwQIXWXSY7hWN90oVhAp1LxY7sBTaMJ+HL5wV72H
        amRVlshY2lYRw2tvQBZzMy/a8uCvtMSa5
X-Received: by 2002:a17:906:698f:b0:78d:93b1:b3ba with SMTP id i15-20020a170906698f00b0078d93b1b3bamr69575379ejr.66.1670194186290;
        Sun, 04 Dec 2022 14:49:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7TZ3aOChwOEI1M64XGnQEXCszIrZ0w3nmS13wa7e/xB9FJwTErCNwaGXgqxtnrEcH0zUQa48CYQ/nOY2Jts2Q=
X-Received: by 2002:a17:906:698f:b0:78d:93b1:b3ba with SMTP id
 i15-20020a170906698f00b0078d93b1b3bamr69575372ejr.66.1670194186091; Sun, 04
 Dec 2022 14:49:46 -0800 (PST)
MIME-Version: 1.0
References: <20221130091705.1831140-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221130091705.1831140-1-weiyongjun@huaweicloud.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 4 Dec 2022 17:49:34 -0500
Message-ID: <CAK-6q+gN9d2_=bN9tvCqCxSbymMfyJjF0j=gj4kUbi-bfSnF4g@mail.gmail.com>
Subject: Re: [PATCH wpan] mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 30, 2022 at 4:19 AM Wei Yongjun <weiyongjun@huaweicloud.com> wrote:
>
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Kernel fault injection test reports null-ptr-deref as follows:
>
> BUG: kernel NULL pointer dereference, address: 0000000000000008
> RIP: 0010:cfg802154_netdev_notifier_call+0x120/0x310 include/linux/list.h:114
> Call Trace:
>  <TASK>
>  raw_notifier_call_chain+0x6d/0xa0 kernel/notifier.c:87
>  call_netdevice_notifiers_info+0x6e/0xc0 net/core/dev.c:1944
>  unregister_netdevice_many_notify+0x60d/0xcb0 net/core/dev.c:1982
>  unregister_netdevice_queue+0x154/0x1a0 net/core/dev.c:10879
>  register_netdevice+0x9a8/0xb90 net/core/dev.c:10083
>  ieee802154_if_add+0x6ed/0x7e0 net/mac802154/iface.c:659
>  ieee802154_register_hw+0x29c/0x330 net/mac802154/main.c:229
>  mcr20a_probe+0xaaa/0xcb1 drivers/net/ieee802154/mcr20a.c:1316
>
> ieee802154_if_add() allocates wpan_dev as netdev's private data, but not
> init the list in struct wpan_dev. cfg802154_netdev_notifier_call() manage
> the list when device register/unregister, and may lead to null-ptr-deref.
>
> Use INIT_LIST_HEAD() on it to initialize it correctly.
>
> Fixes: fcf39e6e88e9 ("ieee802154: add wpan_dev_list")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Nice catch. :)

Acked-by: Alexander Aring <aahringo@redhat.com>

- Alex

