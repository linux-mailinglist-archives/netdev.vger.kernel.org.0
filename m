Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7845E564B1C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 03:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiGDBSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 21:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGDBSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 21:18:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32F806274
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 18:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656897487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBcId0LsMiJ8kchATAtPUDOo18oCzMowzraY14qwnJc=;
        b=aT9XqSDjhoDtkFWMchAN+m7ovgpjUWbYvYanf/bAUPbzCtoAH/oSDM5WJZ1Qt9XsFGuAG/
        vo04xCyrhIMg/olwbw8hYMFVjBZ6AivpdzVMsinzgU2Crvehd99JDJAYI+V3elsqsDm0q2
        3leYp6crf50dQh+4N3LQqV6vTHmAaoo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-ZQ3Uv7Y_PQ6CedmD1fK3oA-1; Sun, 03 Jul 2022 21:18:03 -0400
X-MC-Unique: ZQ3Uv7Y_PQ6CedmD1fK3oA-1
Received: by mail-qt1-f199.google.com with SMTP id ck12-20020a05622a230c00b00304ee787b02so4519854qtb.11
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 18:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rBcId0LsMiJ8kchATAtPUDOo18oCzMowzraY14qwnJc=;
        b=0D3ISKzmqL2soXVguJCwmr0XR2Sul2LQY0xAlb2V/iEN8SXEnmtzLxtPS/Po4zMFt+
         vAUgJe3qBVhXY1ssxtsI5YrFaLM4NNd8iZHQ7dk0VhmK2KdSW/wu990S/apUxAxgYeOW
         Ty+8MWpIGdAiQYh9tRQEPQWdH3tkOS3J8tyOm/Yor2YGH9UytB55/5T9CAo+cDIL5njw
         SU9JSR2SEtzmmpabcUnPAgZ2cRq6eKWwYlzBT3f9b2qB0oOv9AYTdK0Z3mHot0xB/lRv
         PlW2+gY6t4xMcIoQec1PGV0HJwCOqB2E7kzRCyZycdwJcNCG0Ad7pzrJGEGCvYPgJw8A
         6bYQ==
X-Gm-Message-State: AJIora/4AjSWjwBweWWJFmVIciXEM67h0WsxwtOG/SVAwzdyz/1VYnOG
        6X5wEpMWIOEpmue2b6CaCSwLZYKBEEpuU96i5WDp8fWqoh1axOLAE4bkPp3cQNM+7rh19PnVEyq
        dBT/yGx52eEshXFFCOlyRxg0RQ6bfo14y
X-Received: by 2002:a05:622a:1306:b0:31a:f73e:3d6d with SMTP id v6-20020a05622a130600b0031af73e3d6dmr22388484qtk.339.1656897482817;
        Sun, 03 Jul 2022 18:18:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1syz7xlfqoZFtm72jwtXJn8D6qO7f/i/zDerAeST5FMthivoVI/zdvKXb8JZXdbJyaIYsR2AWLIwVq1jSH/Yvc=
X-Received: by 2002:a05:622a:1306:b0:31a:f73e:3d6d with SMTP id
 v6-20020a05622a130600b0031af73e3d6dmr22388477qtk.339.1656897482655; Sun, 03
 Jul 2022 18:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 3 Jul 2022 21:17:51 -0400
Message-ID: <CAK-6q+jxyRVc=qwWQfhnnzOFOny5cp=eAn_pz_4_=NbK-NY5Eg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 00/20] net: ieee802154: Support scanning/beaconing
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> After a few exchanges about inter-PAN management with Alexander, it was
> decided that most of this series would be dropped, because the kernel
> should in the end not really care about keeping a local copy of the
> discovered coordinators, this is userspace job.
>
> So here is a "first" version of the scanning series which hopefully
> meets the main requirements discussed the past days on the mailing
> list. I know it is rather big, but there are a few very trivial patches
> there, so here is how it is built:

I have probably more to say about this patch series, but I need more
days to look into it closely. So maybe we can first discuss here more
about things I comment on and have questions about it.

Thanks.

- Alex

