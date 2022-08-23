Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB0959E576
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiHWO5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiHWO5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:57:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125D1308ABA
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661257350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBRONIqnt4E6MBax+RN8UNcJe1L53HfRKZaqNtIx+8M=;
        b=NAdFlsXNZzxQNGQln8ZE5dGAjg2TtnfWjwt1Sim5V68i9T4re4yHDZFORDxCkJS1uRybKJ
        vocsQU0MXJtg3mfLosEqA8n/EXPw/QcFQ65pBEoPSdRLmuWvj9lKYj3n0Aw+Yew8Z4Rw9v
        u3iw5xmj+G6fJSAOrGBMxgMI3LSxAC8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-86-GsjwMKvKOQaBq7vbxumy5A-1; Tue, 23 Aug 2022 08:22:24 -0400
X-MC-Unique: GsjwMKvKOQaBq7vbxumy5A-1
Received: by mail-qk1-f198.google.com with SMTP id s9-20020a05620a254900b006b54dd4d6deso11830357qko.3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=rBRONIqnt4E6MBax+RN8UNcJe1L53HfRKZaqNtIx+8M=;
        b=NGSrfJTUK2/weW5l2x+2/C8VA08mtJJJ4Z70gnjZWTjgpS9naqs3Vtrsgnh+cETM7D
         eSmjFC8XaXnsM3YQKFwpd37SLBJUvyfrjh4Y8jNVcEa0rF//mAr2xX4fzym3YChcYnp/
         eHDqvIzRpkYtniowUb7HYMMXTjAFm++oIohwrjDYYpLjPsWKtrlTk2+k1aK1/Paq29mH
         8fZS+AVSbzkzrX3z7OKxROBSBGJN1RKlmSTgp18q66CRcPaqmwJop6rObe2vcfvck21c
         z08ApXFi0MSsLitW2K1jRF2LXJkSrkfQl9v0lAuE5cRk7Jz546SyawAxD92+D/VJo0d4
         XjKA==
X-Gm-Message-State: ACgBeo1gUmQOsKgqjPQGNItoccme/FOXCTsw8/g3r976oyd0GoO1PWa+
        FmAPQ3sYydSkwkHrW6xNLnDCJwI/jrefPjdWgXiLm/za4exB/zuwUlj5vk2VqpK0VS0Sk/5HXMg
        SOf9ca7td0nLMHKexz3tUZ1Kp2l7fAOZQ
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id q13-20020a05622a04cd00b0034365a4e212mr18592697qtx.526.1661257344329;
        Tue, 23 Aug 2022 05:22:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5GKTbzDfd8wryS9ex6M02iafW0bT+KO4ivoTSlfqZwnK57plTGzb+b3/uHyQGZR/6c4pz3OUf4d7o+2xiJpKE=
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id
 q13-20020a05622a04cd00b0034365a4e212mr18592683qtx.526.1661257344138; Tue, 23
 Aug 2022 05:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220822071902.3419042-1-tcs_kernel@tencent.com> <f7e87879-1ac6-65e5-5162-c251204f07d4@datenfreihafen.org>
In-Reply-To: <f7e87879-1ac6-65e5-5162-c251204f07d4@datenfreihafen.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 23 Aug 2022 08:22:13 -0400
Message-ID: <CAK-6q+hf27dY9d-FyAh2GtA_zG5J4kkHEX2Qj38Rac_PH63bQg@mail.gmail.com>
Subject: Re: [PATCH] net/ieee802154: fix uninit value bug in dgram_sendmsg
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haimin Zhang <tcs_kernel@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Aug 23, 2022 at 5:42 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
> Hello.
>
> On 22.08.22 09:19, Haimin Zhang wrote:
> > There is uninit value bug in dgram_sendmsg function in
> > net/ieee802154/socket.c when the length of valid data pointed by the
> > msg->msg_name isn't verified.
> >
> > This length is specified by msg->msg_namelen. Function
> > ieee802154_addr_from_sa is called by dgram_sendmsg, which use
> > msg->msg_name as struct sockaddr_ieee802154* and read it, that will
> > eventually lead to uninit value read. So we should check the length of
> > msg->msg_name is not less than sizeof(struct sockaddr_ieee802154)
> > before entering the ieee802154_addr_from_sa.
> >
> > Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
>
>
> This patch has been applied to the wpan tree and will be
> part of the next pull request to net. Thanks!

For me this patch is buggy or at least it is questionable how to deal
with the size of ieee802154_addr_sa here.

There should be a helper to calculate the size which depends on the
addr_type field. It is not required to send the last 6 bytes if
addr_type is IEEE802154_ADDR_SHORT.
Nitpick is that we should check in the beginning of that function.

- Alex

