Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16217550DF1
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 02:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiFTAeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 20:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiFTAeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 20:34:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BBE1AE4C
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655685249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLvRWiqvttcJ70cIxaLiRA+Z6S11BSewzDX1E+bhW2o=;
        b=agUh7qIVMEoSf50rdVqi9dl/4s5ArMocru+lf0XWhanjsQzWs3zBFW6Fs7GAGJCc4kaaVV
        E3gOrQXyoa00QXfzpZNDqm/XW1U+gZDr40/zN8ZDOdGUTsivqWe+MjHXjPTyDPBm+uhhvr
        uFP9UOveT7u7s/5qE5l+LEu8RGJJk98=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-u1tgPCESNiCY7JVENn02Wg-1; Sun, 19 Jun 2022 20:34:05 -0400
X-MC-Unique: u1tgPCESNiCY7JVENn02Wg-1
Received: by mail-qk1-f197.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso11541563qkb.0
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yLvRWiqvttcJ70cIxaLiRA+Z6S11BSewzDX1E+bhW2o=;
        b=nj0L9Y0zYHhUvZ4wST7RJ2tfxb9QXtHlxW4sHI/eeHli+fNmczaaF2KcBHPKE21NFq
         1MEdk6rETqEJwxcYGNL/0byAqQ2E9z7ugkI95bdnO+WcSpae+3GjNrQ61QKp2BUQWu/c
         wnH7YDXGmP2eqeJAGTEsFx/7zvkFE5AgIfcNEvIMHl4VAsxbbMIig/Efs8OVPQ3hSG+z
         Gi3invkUiSdSxKRHoFH8FKanQQEc+Mw/HevVdpnpXRiH2lbwuIomyufXtn21DvzrOvsX
         RLam5RV/He1vr99d1wjY1q1q+CStWvgof/TySOF5LgZs8t35GEbjVQzUDYKtBwDJS6c7
         0MCQ==
X-Gm-Message-State: AJIora+K15wTgoKvQ4EgYrxufan4JPkCDzLuadTQnKiJtzQ4aoRBW11c
        JhePXyenj+zaKi+TdyK0Vlhr7af0m9sqBzkeH3KkEohPYfj7V4dG9M8I8mQGe4NAazMqJ+clTJ/
        O2NMAmd52TpuoM5hHgQTnHZHVUNJUMIG0
X-Received: by 2002:a05:622a:1314:b0:306:657d:5f72 with SMTP id v20-20020a05622a131400b00306657d5f72mr17677659qtk.339.1655685245164;
        Sun, 19 Jun 2022 17:34:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t02QXdaDD1J1SA/EW3B555acqF6J/I7nIsuu4+BzkvN3ehUZL0D+tP3P3NoixruSITQe5hcbah894VBaVSTYs=
X-Received: by 2002:a05:622a:1314:b0:306:657d:5f72 with SMTP id
 v20-20020a05622a131400b00306657d5f72mr17677653qtk.339.1655685244975; Sun, 19
 Jun 2022 17:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220617192914.1275611-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220617192914.1275611-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 19 Jun 2022 20:33:54 -0400
Message-ID: <CAK-6q+h3u-ReBJux4SUJ8ww4NkafrnaAqwGcXnJvm5xnXUge9Q@mail.gmail.com>
Subject: Re: [PATCH] net: mac802154: Fix a Tx warning check
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 17, 2022 at 3:30 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The purpose of the netif_is_down() helper was to ensure that the network
> interface used was still up when performing the transmission. What it
> actually did was to check if _all_ interfaces were up. This was not
> noticed at that time because I did not use interfaces at all before
> discussing with Alexander Aring about how to handle coordinators
> properly.
>
> Drop the helper and call netif_running() on the right sub interface
> object directly.
>
> Fixes: 4f790184139b ("net: mac802154: Add a warning in the slow path")

Acked-by: Alexander Aring <aahringo@redhat.com>

- Alex

