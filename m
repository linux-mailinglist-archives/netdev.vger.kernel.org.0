Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD780562732
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 01:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiF3Xjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 19:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiF3Xjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 19:39:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2644348817
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656632390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b9GVsLYDNIjnA5AzRP3UDciaV6BcKEPUnpIHk/sNuEM=;
        b=IZjCB/fpb1ho8LGHkfGi7P3QCDmnTuUbmK7N9cgjnAz7l8+Z9fbm0y4/zhx9t9GOkXucPj
        qq5gWb5Ju4C0aO3NCmUGR/eCfJEickqdSB28fzjTsncabVdfWAUBqD8dp3wftxtmzLZ+Cq
        fkqfcBVwHovG8C37BGgSm7Ji4OcGh5s=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-t84po7nXPKC8rHacn0GkBg-1; Thu, 30 Jun 2022 19:39:48 -0400
X-MC-Unique: t84po7nXPKC8rHacn0GkBg-1
Received: by mail-qv1-f70.google.com with SMTP id kj4-20020a056214528400b0044399a9bb4cso1034575qvb.15
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9GVsLYDNIjnA5AzRP3UDciaV6BcKEPUnpIHk/sNuEM=;
        b=YIE3D8IB0ObR7HB4lDYrwHKhDmrf3eYkEcr8jCP9Fv6NMIs21fT0PwLScsxz9sz8w8
         KZMKQlJ1KLyxmuNUHRWKvfu7e4gHvpsHOyy4lP5LPRE2ps5o5zMXfctwdt0+MZseFgRW
         HlKXZFAOwSfHvfq1FzHTIIxbpumHaJnNvechuyg4oihJFKMqzmLlIL0m8CSIlUZTcIjj
         j1pxOwAE0B1hOQPITA5WD+Du+WttlQfQJMYfFUfApb4IISymHrHMCeh3kFkdly0Dxy9/
         YvTvQhl4rScYGMnzIug4Q4nmoeqHazN7tI62Qpom6l0E5q8BjqYQS5WdN960xcVjiOMR
         sVFg==
X-Gm-Message-State: AJIora/640SLaAxs2PBC8Na+6nLRiSITXcdQC6T77xPo2b6BceOHbZGL
        Yq3oztOYzHc+B45fCVz2lV7SRZq6SXXYFXcNK7coeXPKj5nGjq33ewH84ch2Klm/1/9xaCybw9L
        tseX3PhRL/iTgel5HJ8RZDoP8J8KhQWwL
X-Received: by 2002:a05:622a:90a:b0:31b:899:3070 with SMTP id bx10-20020a05622a090a00b0031b08993070mr10244069qtb.470.1656632388499;
        Thu, 30 Jun 2022 16:39:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v+2gxM//Gl1DZFl6EN2ARpld2eu3hEMQxpCI5Q3r1GZUtr7fZAogE+1KHvIXzDa0sfDQsYXVT6ti1sU0OHBY8=
X-Received: by 2002:a05:622a:90a:b0:31b:899:3070 with SMTP id
 bx10-20020a05622a090a00b0031b08993070mr10244044qtb.470.1656632388282; Thu, 30
 Jun 2022 16:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
 <20220620134018.62414-3-miquel.raynal@bootlin.com> <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
 <20220627104303.5392c7f6@xps-13> <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
 <20220628095821.36811c5c@xps-13> <CAK-6q+g=Bbj7gS5a+fSqCsB9n=xrZK-z0-Rg9dn9yFK5xpZsvw@mail.gmail.com>
 <20220630101416.4dc42f29@xps-13> <CAK-6q+gR-+9K2LtwwVQQMmMcmmkG399jUgyd-X3Nj8xh0y+jBQ@mail.gmail.com>
In-Reply-To: <CAK-6q+gR-+9K2LtwwVQQMmMcmmkG399jUgyd-X3Nj8xh0y+jBQ@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 30 Jun 2022 19:39:37 -0400
Message-ID: <CAK-6q+hh39keuvKxfYMKknUFQMP0jkfxknp5q=VWAJrLZnzgXQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 2/4] net: ieee802154: Add support for inter
 PAN management
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
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 30, 2022 at 7:27 PM Alexander Aring <aahringo@redhat.com> wrote:
...
>
> Why not move this decision to the user as well? The kernel will wait
> for the reason? This isn't required to be fast and the decision may
> depend on the current pan management...

to be clear here, that this will then and on some coordinator only use
a user space daemon which manages whatever is needed for assoc/deassoc
management e.g. how short-addresses are allocated, etc. That should
also not be part of the kernel, if so then same strategy as we have a
user space replacement for it?

- Alex

