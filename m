Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A057612EEB
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 03:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJaCV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 22:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJaCVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 22:21:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D33B1DE
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 19:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667182822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BjafgW3rTkQyfi6E7wSIxq6H/qqptWcpoOjhgbVJRUc=;
        b=dUEVlW90Rxnp4g6aTOi2obYPkR5JGF88u6dIY1n/jH05KxWqTkKMsDekhCpJ12rc62xKt3
        bjQEElIft8y50/nxAaMSqFEQiiFU/w2HMK0wIYQ71Z9wWygvtcy6ybSuWOsPw9T18xaBCh
        WqtP2+g9nekA/GJa8RarElFRRANxgtM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-225-1G-Ykx3pMzOLL-uVlA99zw-1; Sun, 30 Oct 2022 22:20:16 -0400
X-MC-Unique: 1G-Ykx3pMzOLL-uVlA99zw-1
Received: by mail-ej1-f72.google.com with SMTP id oz34-20020a1709077da200b007adc8d68e90so794928ejc.11
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 19:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BjafgW3rTkQyfi6E7wSIxq6H/qqptWcpoOjhgbVJRUc=;
        b=EasxNUOCRfkuiT8FLNUQmLuuuN/PyY/znh0ot0HUGR7Gl0DwL6Ax45BcotJ9JxhQuQ
         lXV2dnfGm9Z9tPadreFrutuiQXd64usielZXx0Ezd0rTgr6ASQnO4tfm/x3R52RST82M
         ia69gRD8Kb2P7xlxxuTDUqqA37YUePFlTEVSnX6b9sDjZYSORpLWj23OVB2yvApZGrA1
         KIo5kFFf9EAiYAIyYeQWlnubxDdc4et61L0xYuGmHjBm+mLdfvCVBgyKgjZx/NUIzYJd
         h2JciZXKEomncsw1ldf2jii0n2w8YT/WiWyeIlEAmryx1NM/adqL2zh4SetH8GNJv5mM
         rJLA==
X-Gm-Message-State: ACrzQf2+QS6IB6+P9RJc2iTfz8bZp9dqdO7+cuH7EtYdK+rVSbe5jFWY
        VQdOq8mcJO9HH4aUWNDDEjDP/kehvfwEj6NZQx1oAM0C6+8DL3ML1CL5BVTEhGks2eUM/Shz9LA
        zeNYI/wVEolyapLN540604NuKhlihQbWN
X-Received: by 2002:a17:907:2d91:b0:78d:8747:71b4 with SMTP id gt17-20020a1709072d9100b0078d874771b4mr10784851ejc.545.1667182815015;
        Sun, 30 Oct 2022 19:20:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4xU1KHI4idWmAHMlxXdU4BufbnzGj7b7j0AbjuJ3gHXYpGqeb09NigNmoMkcJBldcdamEApf70gIcNgTEaoEc=
X-Received: by 2002:a17:907:2d91:b0:78d:8747:71b4 with SMTP id
 gt17-20020a1709072d9100b0078d874771b4mr10784839ejc.545.1667182814825; Sun, 30
 Oct 2022 19:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221026093502.602734-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 30 Oct 2022 22:20:03 -0400
Message-ID: <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/3] IEEE 802.15.4: Add coordinator interfaces
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
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Oct 26, 2022 at 5:35 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
> These three patches allow the creation of coordinator interfaces, which
> were already defined without being usable. The idea behind is to use
> them advertizing PANs through the beaconing feature.
>

I still don't know how exactly those "leaves" and "non-leaves" are
acting here regarding the coordinator interfaces. If this is just a
bit here to set in the interface I am fine with it. But yea,
"relaying" feature is a project on its own, as we said previously.

Another mail I was asking myself what a node interface is then,
currently it is a mesh interface with none of those 802.15.4 PAN
management functionality? Or can it act also as a "leave"
coordinator... I am not sure about that.

However I think we can think about something scheduled later as we can
still decide later if we really want that "node" can do that.
Regarding to 6LoWPAN I think the current type what "node" interface is
as a just a node in a mesh is required, it might depends on if you
want routing on IP or "relaying" on MAC (mesh-over vs mesh-under), but
I never saw mesh-under in 6LoWPAN.

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks.

- Alex

