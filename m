Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1506667DB65
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjA0BqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjA0BqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:46:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F88402F6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674783928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDHoyOIbGQ1AMtpykgf34aAsw8zvrgKY4crUtTJZMM4=;
        b=UEKSBDdy0QTc4eqDxU0Vp8v+4/Wou/1sz40u1ybfimXMmJI3XmSS5+ug9RS86VId4U6zM2
        ebdGIr5D5XDm/5kWGbSvsSMCZowMrcNoauZJJXyFMVeYCAeAGwFmakvhJPXBedLTzfROA3
        kqD1E2+9LTkzkRP3eRRwgIxbBly6844=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-448-B6U6zXrhOz2EjaOenkvgJA-1; Thu, 26 Jan 2023 20:45:27 -0500
X-MC-Unique: B6U6zXrhOz2EjaOenkvgJA-1
Received: by mail-ej1-f69.google.com with SMTP id kt9-20020a1709079d0900b00877f4df5aceso2342175ejc.21
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 17:45:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iDHoyOIbGQ1AMtpykgf34aAsw8zvrgKY4crUtTJZMM4=;
        b=1Mc/YByta7mk+P+kv1jLi6H+yDN0Rq3msoDuaNf82X45fh57RswLxAs8EpzOKPMx5r
         VQ86umI5E37l4ELBdzext+wcIhx8UBx8uCUKIlp/UiPYBV5N+nE+BrkfuCClriEmBi4p
         JOX9z+dUIdz1YNmf1jFf+iyCHSl6Rj0fb0OzsuGW064N6t7TaHJJ+kn450nni7wkvWbE
         QO1fl4I0BtN7Ng4EKGiqoG+f0Gl2ROANMcFCeIa7NjNzEFw3ANgajyqebuz8lvYGIWsh
         eSOiGHUs1j/jTOSIAc+MCksgnq15oiGn1iAMKUrEddAVoxVfu2S5uHxtuMgurvpS+pgK
         lk6Q==
X-Gm-Message-State: AFqh2kojnZhGhzeSTk2Bsfvo9yUw3ynicXjGqnkz60KwkXEbpL4t9vmq
        lLZGmlwuM4miANE5UJF/LbG1sHrONqQbLiCaJW7fYGPOqxdyDkdXbQL9YU37UK3xvxEo4Tgdiug
        5HV3SBxEIFd1pJf6jUboZCog+CWvgW1+Y
X-Received: by 2002:a17:906:4988:b0:871:e963:1508 with SMTP id p8-20020a170906498800b00871e9631508mr6387501eju.185.1674783926241;
        Thu, 26 Jan 2023 17:45:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXva3WypSSBaBKAZ8gx6hfQFBdh/vpYS+eXqxUlJGBg3nC413yrNyWv3AUeYH79bSGCNfvdKeSu+jnXx5CS1ZYQ=
X-Received: by 2002:a17:906:4988:b0:871:e963:1508 with SMTP id
 p8-20020a170906498800b00871e9631508mr6387490eju.185.1674783926054; Thu, 26
 Jan 2023 17:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20230125102923.135465-1-miquel.raynal@bootlin.com>
In-Reply-To: <20230125102923.135465-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 26 Jan 2023 20:45:14 -0500
Message-ID: <CAK-6q+jN1bnP1FdneGrfDJuw3r3b=depEdEP49g_t3PKQ-F=Lw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
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

On Wed, Jan 25, 2023 at 5:31 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Scanning being now supported, we can eg. play with hwsim to verify
> everything works as soon as this series including beaconing support gets
> merged.
>
> Thanks,
> Miqu=C3=A8l
>
> Changes in v2:
> * Clearly state in the commit log llsec is not supported yet.
> * Do not use mlme transmission helpers because we don't really need to
>   stop the queue when sending a beacon, as we don't expect any feedback
>   from the PHY nor from the peers. However, we don't want to go through
>   the whole net stack either, so we bypass it calling the subif helper
>   directly.
>

Acked-by: Alexander Aring <aahringo@redhat.com>

- Alex

