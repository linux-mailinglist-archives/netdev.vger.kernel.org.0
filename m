Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD0F61E853
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 02:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKGBhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 20:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiKGBha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 20:37:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5B3BC19
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 17:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667784994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/3uI754LLZNATMly5kau/BPm2HAT37g06wdUxjM84Yo=;
        b=aO6A0e4l7roi8hFWMLCfsIwO5CBC+2bjOUT3OTWXnTJsupV3fd7Lb3PSocgQgsv0wbBrzB
        P+o1O4I5WVawwHtu/mh4tDYE98dwXoeKf4uy8UJ3nX1HnKWqru2FDCgkor51JDj7Q7x65o
        A9KYx+JOMbirjWAtFuYvmKcRNBW/C/I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-XivkiVxVO92m8Yby3Z6g-A-1; Sun, 06 Nov 2022 20:36:33 -0500
X-MC-Unique: XivkiVxVO92m8Yby3Z6g-A-1
Received: by mail-ed1-f69.google.com with SMTP id l18-20020a056402255200b004633509768bso7174588edb.12
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 17:36:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3uI754LLZNATMly5kau/BPm2HAT37g06wdUxjM84Yo=;
        b=8IuwQsuRKx1+kTtYQeoYtNWv4AkTN6dZhHtFBzod9ssM/qEY+G8jn7qPJkwmBlzpm3
         EmPVag+6/sDdvd/UJxskO05GBzko38Dn7uZxdhIsWzU6apZlzK8hm08UYnduL45NrFQZ
         cBNpe3gLXuWLe6yJjCcYe+KShvmQmpqGT4oR92OWqKZzv10tsUaw/AR11hJTpDJQ6Ia+
         +iEuLg3ztgdNL4jKqEJOZiL2Y8yvY5SQPj0BRp6lVtX52k4XYsSAnez6BXfPmsxDFeb2
         sABSbKuD9uL8a+j9GPkG88t13kHLEaCm0IdQWnS8vxi8wRT0iLUsHM81YR3CyjpYC0ic
         N3Jg==
X-Gm-Message-State: ACrzQf18GX6BjEfOv1AbyEu7MRdV+wZAlnIMV8j1SIVzL8J6BoeWnDmv
        0Wx6vIUo6v0vy7l5BH0IlxJxORawRQ5S8bsvtkhcUdHw9rbdl7+ktVURTuGuB9X7Irqc4IyK+4h
        7jhBeyM7YI/hCvo80S3XKxnW7ZQSjNnlA
X-Received: by 2002:a17:907:8b94:b0:7ae:5884:b344 with SMTP id tb20-20020a1709078b9400b007ae5884b344mr7198823ejc.373.1667784992610;
        Sun, 06 Nov 2022 17:36:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5xIcdB+Li+bISH9qIgQvy44nYhhFhuxp4d1wBKUOAQbwDNACPnMm7hgmLMNl6TcyETEF794G2M6FQwu2iWeeY=
X-Received: by 2002:a17:907:8b94:b0:7ae:5884:b344 with SMTP id
 tb20-20020a1709078b9400b007ae5884b344mr7198805ejc.373.1667784992429; Sun, 06
 Nov 2022 17:36:32 -0800 (PST)
MIME-Version: 1.0
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com> <20221102151915.1007815-4-miquel.raynal@bootlin.com>
In-Reply-To: <20221102151915.1007815-4-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 6 Nov 2022 20:36:21 -0500
Message-ID: <CAK-6q+jDFGr2xhAKLLitZXA2Q2dWgeZjgBXHubHvOvzX-xeB-w@mail.gmail.com>
Subject: Re: [PATCH wpan-next 3/3] ieee802154: Trace the registration of new PANs
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Nov 2, 2022 at 11:20 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> From: David Girault <david.girault@qorvo.com>
>
> Add an internal trace when new PANs get discovered.

I guess this will not be the API for the user that there is a PAN
discovered? Is it only for debugging purposes? There will be an
nl802154 event for this? As we discussed previously with additional
commands for start, discovered, etc.?

I am sorry, maybe I can read that somewhere on your previous patch
series, just want to be sure.

- Alex

