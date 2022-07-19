Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501405793FB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiGSHT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiGSHTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:19:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB61252A8
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:19:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fz10so13916861pjb.2
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/44W4csikJj17tvTsJ7de3OfqmHZimKZxfcO1AtGT0w=;
        b=z7R1HpqAbKEr+q+cD71tHY+671jOMvom2k10lJ/FzFSLG9VdGjp1RHy370C/rnlZVc
         9r/zK2is8or8ZVaNN+L+QNtD3wEoFUL6F1MndSCVTtfKGS07+guA6wicXJtVNKdxx3GY
         Wi8AYY3Y6KTnVuUCyZXn1gIqzFfpHOkNytmKzXmhuVmpMx4V9y1bbIUT83ottHLdRoYF
         7ZH6kOV5vMSp0vQrYN9kiaG3JrmwO4e605y9e6PLNoUEFaPv23ZxHblgFD9+98/mYk0s
         AqOchVE8pXQQOGV8gh3IACQ+MqEg4kBU5vzVpztpApZt5Adnu0MG+x4ZonqEzqBLb5CL
         ZGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/44W4csikJj17tvTsJ7de3OfqmHZimKZxfcO1AtGT0w=;
        b=kriHPoFxYFoVj54yJd2uZ5dBPwsSzczaY6PpSqkRgidYMzvl8+QDRVTL7UmXGzDUn2
         VkNXqsZ6/9IhxSCCCxcGVAIQQP7tNBYgb2r3YxQXObdJqMF2lSKSiBpRexEwDF91tBLr
         hZTVIJxMos6+vOfggr/wJ9DdUxmvJSQImn6cDyM6xuBoPvYGwXJ84HpKg8wttXCtHj6W
         WhP7L0JGKrdn5xMBw6l2U297HBUiqBzLJn2tXbMrGGNDjQ90nVZ5L3ihXBnqhjcEKAxu
         ARkauauE0dP+O7DU/o+sloztG565aWgfDsl0rv5UwHES9PvUpi+3aGndO4CnsV74PN75
         YEXA==
X-Gm-Message-State: AJIora+iG7Wtki2do1G7fTorVXIXrMuPv/htu4tZg4V9AnUDk0nj2jUv
        G+eF3BVTuKdocky+ZrDEFG5Jx0OX4qOXyVjUuuqRFQ==
X-Google-Smtp-Source: AGRyM1uC5MhLp6XNktcIhhcqvS+Os/XG5b9IFKqGHhL742JNpWt49TcVrbAqVI+HWSCjX6PRpu4XzCBkFMTzulhpftc=
X-Received: by 2002:a17:90b:1284:b0:1ef:877b:2f06 with SMTP id
 fw4-20020a17090b128400b001ef877b2f06mr36113460pjb.37.1658215161408; Tue, 19
 Jul 2022 00:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <d6423ae9-aa8b-7213-17c9-6027e9096143@redhat.com> <CAJs=3_CQmOYsz5N0=tX-BKyAuiFge3pfzx9aR46hMzkcP7E4MQ@mail.gmail.com>
 <CACGkMEt-37P-Qc7_1hnEN91LRuP4-uQTMwk7E0kGp64MjsqUUg@mail.gmail.com>
In-Reply-To: <CACGkMEt-37P-Qc7_1hnEN91LRuP4-uQTMwk7E0kGp64MjsqUUg@mail.gmail.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 19 Jul 2022 10:18:45 +0300
Message-ID: <CAJs=3_DghKfyFMNzxLkmM9g-yPkoWF2s5Y36g920J9=9j_LvmQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes but this "issue" exists before VIRTIO_NET_F_NOTF_COAL. It might be
> better to have an independent patch to fix.


Maybe I'm wrong, but I don't think that you could receive
tx_coalesce_usecs/rx_coalesce_usecs without this patch, since the
ethtool_ops struct without this patch is:

static const struct ethtool_ops virtnet_ethtool_ops = {
.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
        .......

And with this patch is:
static const struct ethtool_ops virtnet_ethtool_ops = {
.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
ETHTOOL_COALESCE_USECS,
