Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1229F562B06
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 07:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbiGAFrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 01:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiGAFra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 01:47:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FA086B25A
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 22:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656654448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kxaw70hoiHwUI/cqTZ5YO6DN+NgrafhvITSveXQq/1Y=;
        b=WHJujJlrxOI21lr68P/JTyf+ogssbOV66QbiKCGEYajzTLYcOyo//XkLMV/MmQD1APXZ0M
        UViBaYe4Bweq5qZeFqXRsq5ViyhvRvbRcU7/Mflm5Hyu47BN2uqsIFBZVthGcgD0aEYjg4
        kHW6T7qEbU/Hk3uZmNO35xSLOZDxHl4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-EMG6fO2NPVqKT65OQELdhA-1; Fri, 01 Jul 2022 01:47:27 -0400
X-MC-Unique: EMG6fO2NPVqKT65OQELdhA-1
Received: by mail-lf1-f72.google.com with SMTP id e8-20020ac24e08000000b0047fad5770d2so652121lfr.17
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 22:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kxaw70hoiHwUI/cqTZ5YO6DN+NgrafhvITSveXQq/1Y=;
        b=227vZCpyo8/xwFaCtMJkbPJKV+1+TM1YIAsJ4Z9Jh7/eFFsnxowZM8XpYtg+5BkGu7
         2u9X2Lyd5dWx2ttXMYef3Vep2QEkN4tnNBiVJ03i1zt1a6poVBtW/4TI5+ut8PH6+Mwz
         BULMNr7taLLD4BIjTvnkgwLTky2bi8Ku8DmC4tlnQNjtd9qvohM3WKdmxh0OhWDLJHZX
         0pmyXfLhNRYeDHM1ZMiLFzSCA0phLGBTacYUGCjHZyGtMcsv8nvdzbd2BPmR/t4BOV3r
         GfO4CxBYNmciEOJIlxNYShIrEuJoCEOGvpyvksJqrTs8SNowRtpKU4zBJ5axwqnebz/W
         0zKw==
X-Gm-Message-State: AJIora+3VqBdIef/rjAdE+3wM3jlvelf2aaMYfLEGS/YsVesknibETxs
        dL2gIIpkpsT/C5XpsjIzrUF/M5l/VW7PuNXIjbKkAHcHgNJ3Un0ueqdUggBgbZEMgkqET/Ob4G5
        78ZDNLFt9KBzRKgS68RAaHoBiAQKCXuTZ
X-Received: by 2002:a05:6512:ba1:b0:47f:c0bd:7105 with SMTP id b33-20020a0565120ba100b0047fc0bd7105mr8341313lfv.641.1656654445512;
        Thu, 30 Jun 2022 22:47:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v0se/FzcmxliJW6fuUGUSnkLWgJBUFrZl0mlLPLSRxp5AulWkBQuSlkKahwAKOQVa7v5Ii718oBi82YszhcQs=
X-Received: by 2002:a05:6512:ba1:b0:47f:c0bd:7105 with SMTP id
 b33-20020a0565120ba100b0047fc0bd7105mr8341293lfv.641.1656654445190; Thu, 30
 Jun 2022 22:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220701020655.86532-1-jasowang@redhat.com> <20220630210344.4ab805fe@kernel.org>
In-Reply-To: <20220630210344.4ab805fe@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 1 Jul 2022 13:47:14 +0800
Message-ID: <CACGkMEvMnxK-VhEQvf6itBiG=ZYuFjPuPCkpJJT=4VqWrDK32w@mail.gmail.com>
Subject: Re: [PATCH net V3] virtio-net: fix the race between refill work and close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mst <mst@redhat.com>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 12:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  1 Jul 2022 10:06:55 +0800 Jason Wang wrote:
> > We try using cancel_delayed_work_sync() to prevent the work from
> > enabling NAPI. This is insufficient since we don't disable the source
> > of the refill work scheduling. This means an NAPI poll callback after
> > cancel_delayed_work_sync() can schedule the refill work then can
> > re-enable the NAPI that leads to use-after-free [1].
> >
> > Since the work can enable NAPI, we can't simply disable NAPI before
> > calling cancel_delayed_work_sync(). So fix this by introducing a
> > dedicated boolean to control whether or not the work could be
> > scheduled from NAPI.
>
> Hm, does not apply cleanly to net or Linus's tree.

May bad, let me post a new version.

Thanks

>

