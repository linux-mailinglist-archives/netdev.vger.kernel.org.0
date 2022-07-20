Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BCF57B2E5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240356AbiGTI2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240383AbiGTI2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:28:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 105626BC13
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658305725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L3DfenUCS2zT2sZOgTK20oeEKlbuLDUSug72qMlfIEA=;
        b=D1NFgTuXy5YNSpy0S3V1qroiUXAFjblezcNCywhE5uKIWoUFJkHHdqPjKJ1LgIHumzVtqu
        JLkaoKJEB0pH2OkuPW6ajdz1YLt5WwkkFvSmUE0GU1HLla4Z4YLuq7k/1ZLw/eGEj9I6LF
        yfOxRbDWd5R4G+y5yDfq0aYXdEskvq4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-jL_WpCjnM7a-sEZbL3iMsw-1; Wed, 20 Jul 2022 04:28:44 -0400
X-MC-Unique: jL_WpCjnM7a-sEZbL3iMsw-1
Received: by mail-lj1-f199.google.com with SMTP id h21-20020a2e9ed5000000b0025d516572f4so2946899ljk.12
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L3DfenUCS2zT2sZOgTK20oeEKlbuLDUSug72qMlfIEA=;
        b=13czvrBc8Tigwm28cVFoVEDEf+w4se5BXSllOlarj15LF0H1SAYF+J85U05N4YwAoc
         ZeG2GZru7wNAOArJpNRW+EiDDv4j6MMx91wifyvp7Yr7k7Rx4rv/z9GLGobhlC8fwlXy
         LoPw+yZ9WLrtwvnF7RYzNFWeEjx6oq/YcGddoehqj5KKHN4tnBhGqu6JB2jeQaBL8pFa
         kHJeczDxl6MdEcA5o29tzbVSe6AratxlN8pOAUo4aaiZP6+gTp1FIgQ6QRxcGgd33SCv
         VQ3DvBmbK0p8tPN+OVx0ZvypJpNelFcZPaPqOtBnB9PdVF+l1rvOQjk4idxnoBhgk/I9
         8sxA==
X-Gm-Message-State: AJIora9m+CdDOohR+4dmqjznZcoXFtPR9+QisjVRAGCmzLVs2Vl+mkPx
        9cEd5md7GsnaK5f3qIXvCX+omjf9cFzZfQtJMQ50z0TAkxR4y3FktF0ZWdPtguKaDQGzwkyDI+I
        Qaarn4fImO6aUQLtLZ3M5v6TWsHFxFIAH
X-Received: by 2002:ac2:4c4c:0:b0:489:fe2c:c877 with SMTP id o12-20020ac24c4c000000b00489fe2cc877mr21359816lfk.238.1658305723096;
        Wed, 20 Jul 2022 01:28:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uLAZh5XaF/U2o2Y+GJcoVM2SgiH2Q0PL1pTCphliOM2ioV10XQ+8kac8O0GewO0nmoCuNlrNjn1wj2ekRmpWs=
X-Received: by 2002:ac2:4c4c:0:b0:489:fe2c:c877 with SMTP id
 o12-20020ac24c4c000000b00489fe2cc877mr21359810lfk.238.1658305722871; Wed, 20
 Jul 2022 01:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org> <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org> <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
 <20220720031436-mutt-send-email-mst@kernel.org> <CACGkMEuhFjXCBpVVTr7fvu4ma1Lw=JJyoz8rACb_eqLrWJW6aw@mail.gmail.com>
 <CACGkMEttcb+qitwP1v3vg=UGJ9s_XxbNxQv=onyWqAmKLYrHHA@mail.gmail.com> <CAJs=3_BtM2CTRLaA28R7_yjfFcq+wexQudfXBM0jWX02ZkacyQ@mail.gmail.com>
In-Reply-To: <CAJs=3_BtM2CTRLaA28R7_yjfFcq+wexQudfXBM0jWX02ZkacyQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Jul 2022 16:28:31 +0800
Message-ID: <CACGkMEs96L+p1M+iK84tu0D5RGuTjo1=LgH0S9eeS57fSe-6mA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 3:57 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> > And we need an upper limit for those values, this helps for e.g
> > migration compatibility.
>
> Why not let the device decide the upper limit, making it device specific?

For example we may want to migrate VM from src to dst.

In src, we set tx-max-coalesced-frames to 512 but the dst only supports 256.

> As written in the spec., a device can answer to the coalescing command
> with VIRTIO_NET_ERR,
> If it was not able to set the requested settings.
>
> If a physical device uses virtio datapath, and can for example
> coalesce notifications up to 500us, why should we limit it with a
> lower number?
>

See above, for migration compatibility.

Thanks

