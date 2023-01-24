Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806EE67974E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjAXMIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjAXMIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:08:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552152330C
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1YUMuvyDQOzvM78Ab3VaeXMQnof8qsAT1BsLgsVFus=;
        b=gzt146k5qKKtaJy+CnOxx5e3Fa9TFIvL7c4jNR5j1Ck0Rzi9Lgfvy+KW5dcS8OBebiBgJ8
        SNtQ2drTwjdoIvK97gRALeNByLyOMutsDGLlxWN8BDyMoVbLr+etlsY1Y2bgfo2DGEbjlW
        Ak4DeRxCHqKaA+IeHJBiDVbZKruEP8k=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-bAjAxCo8P0yDQuRdMKFc3w-1; Tue, 24 Jan 2023 07:07:19 -0500
X-MC-Unique: bAjAxCo8P0yDQuRdMKFc3w-1
Received: by mail-qk1-f198.google.com with SMTP id bi7-20020a05620a318700b007091d3fe2d3so8074582qkb.4
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:07:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H1YUMuvyDQOzvM78Ab3VaeXMQnof8qsAT1BsLgsVFus=;
        b=swPX/A0Eli+QWRMC8rTZfg5uu/W7JNFCaQsn1+3b5/CVBpa6ii5WM4czE8G8lzz3Z9
         e3EU3MrOxz3mPj2p+n/w8WurPlREAWQUhcBeywedml1oXCmPlUvCpajDolktemBa+ut0
         ewCt+9WIgic3CdWA7chFa4Txhy4pvZMg+v8ONRxyjQC7sfkajw84Gw//8NOzhmhSndIp
         sv7O/pt35IlYCe1A19x5Bccsul63jkth7OrGkJUkB41rFecchYR4j5cx3aLrlGUCjg6q
         qnu1f7c1iPiPbAfxcMHbG9B0QXMp+u4P+ABCpcurCgmm01/MT7WSNot78KYpYMGDQ6L2
         44EA==
X-Gm-Message-State: AFqh2kqkrd000OOLMUoD0Q99x+aK5uSyd7Fhi2wqWxjoGdk6WPKGrOVw
        y3iPOQSWNYDEagTwOH1QAZY/lRTZq2HrNOJxAoKg6VYw73fkAvJ1bvI35UafffAmVNVzH4XOoJb
        0Ouv8szx4kyYTygNn
X-Received: by 2002:ac8:41c5:0:b0:3b6:33be:34d3 with SMTP id o5-20020ac841c5000000b003b633be34d3mr39210559qtm.1.1674562038905;
        Tue, 24 Jan 2023 04:07:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsH6EPs9776/5zmYwuxLIYCzbff96ZrpELQLqisJt/8awKQRiXXa4PVd4mCCfasHKBTMUHU1Q==
X-Received: by 2002:ac8:41c5:0:b0:3b6:33be:34d3 with SMTP id o5-20020ac841c5000000b003b633be34d3mr39210543qtm.1.1674562038623;
        Tue, 24 Jan 2023 04:07:18 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id o3-20020ac80243000000b003a6a19ee4f0sm1127050qtg.33.2023.01.24.04.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 04:07:18 -0800 (PST)
Message-ID: <1b7dbb0a7e228faea3ffe5737969eb3fd3492a27.camel@redhat.com>
Subject: Re: [PATCH net-next] tsnep: Fix TX queue stop/wake for multiple
 queues
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
Date:   Tue, 24 Jan 2023 13:07:15 +0100
In-Reply-To: <20230122190425.10041-1-gerhard@engleder-embedded.com>
References: <20230122190425.10041-1-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2023-01-22 at 20:04 +0100, Gerhard Engleder wrote:
> netif_stop_queue() and netif_wake_queue() act on TX queue 0. This is ok
> as long as only a single TX queue is supported. But support for multiple
> TX queues was introduced with 762031375d5c and I missed to adapt stop
> and wake of TX queues.
>=20
> Use netif_stop_subqueue() and netif_tx_wake_queue() to act on specific
> TX queue.
>=20
> Fixes: 762031375d5c ("tsnep: Support multiple TX/RX queue pairs")
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Any special reason to have this on net-next instead of on the net tree?
The fix is reasonably small and safe and the culprit commit is on net
already.

Thanks,

Paolo

