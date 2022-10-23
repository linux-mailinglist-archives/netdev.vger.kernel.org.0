Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3708B609734
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 01:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJWXPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 19:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJWXPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 19:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1E367462
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666566946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nyv5Hncvb1stilpHTQMnrnE2heePDDJ+kgmXY4LCHNc=;
        b=c0Lj92KSGish+emBp0i9G1GUDNcx+RVPupkofx69RPcFlmshLDpoMLVaqPjYvpf23oKp+e
        QjbNpdQKX6qgjFZbNbxENhPhKA6lH38OY5JJ9t5iBvsyNRlYLMXmMs+mZfbvmdJAmQ7bZR
        zFPPoMcvwMs2/lIO79MPJgG97Y0WxtM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-s3hMvkMpMkiLmfZdjAo0_Q-1; Sun, 23 Oct 2022 19:15:45 -0400
X-MC-Unique: s3hMvkMpMkiLmfZdjAo0_Q-1
Received: by mail-ed1-f69.google.com with SMTP id m20-20020a056402511400b0045da52f2d3cso7816685edd.20
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 16:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nyv5Hncvb1stilpHTQMnrnE2heePDDJ+kgmXY4LCHNc=;
        b=AAR9SdWPKCv5cj7m1rjmmbQBv8wD59AR+xkcLlGt/xSjud5ykXBnLF9fYrwsMz8fgq
         I6b0g97B3UODL4aqflzWP0uJ4AW/IjRaqpSEQ57rzSoMKTaa76T87bOsm9yUxWW9J2PK
         pLiX7RnjtK7pFUA5FqWv/0/aGtVqDd5am+BtKrIpl5KPPOlTaZTg4eKCcHrJ0ztMaxr+
         ndeSzcuc0MYzm9Qm2gP7TqCVAOHXLBXg8I0RYohu6YM3rJt8bFnjSjAommYgO5GT4HcW
         u+htUvUpM9Q67zDRu880zDxaJtFl0PmlhKW3sv25OluKj2uqmj2NaLMFIJjXIHQvLZsI
         D3aQ==
X-Gm-Message-State: ACrzQf2j4g5DntCmK210ebdFUOSSd+nBDQVvD/6eSQj1h8zemv8zUX/v
        oz6+JOt9I2Ema98SLyLU9A0hLqJ4BXgCSIm/ZxJT2wAF5Yq7SjWrh7/My3STtU+7/5J+UokTaZ7
        Lmfr55g66UshxR9yAXXMQGvwpxNBDHZXy
X-Received: by 2002:a17:907:78a:b0:78d:9ac7:b697 with SMTP id xd10-20020a170907078a00b0078d9ac7b697mr24587524ejb.457.1666566944120;
        Sun, 23 Oct 2022 16:15:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7B1WgK/1cPBCckn8xj35VFzZwQZGGu3hKiJ3ERZTkNZc4B19245m++1MMJvj7F1UBBvOamqKqDG7oEH8ZKlgw=
X-Received: by 2002:a17:907:78a:b0:78d:9ac7:b697 with SMTP id
 xd10-20020a170907078a00b0078d9ac7b697mr24587514ejb.457.1666566943979; Sun, 23
 Oct 2022 16:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221019134423.877169-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221019134423.877169-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 23 Oct 2022 19:15:32 -0400
Message-ID: <CAK-6q+hphyOZKLgxM3Ez2O8Fj2j0jeuxVMPaekoGBrcphHyySw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v6 0/3] IEEE 802.15.4 filtering series followup
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Oct 19, 2022 at 10:14 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> The filtering series v4 [1] lead to a discussion about the use of a PIB
> attribute to save the required PHY filtering level instead of accessing
> the MAC internals, which is bein addressed in patch 1/3 and 2/3. The
> last patch has been sent alone as a v5 because of a debug message
> needing rewording. Actually Stefan wanted me to rebase on top of
> wpan-next without keeping a patch sent as a fix which conflicts with it,
> so here it is.
>
> Once these three patches will be merged (I don't expect much discussions
> on it to be honest?) I will send the next small series bringing support
> for COORD interfaces.
>
> Cheers, Miqu=C3=A8l
>

Acked-by: Alexander Aring <aahringo@redhat.com>

- Alex

