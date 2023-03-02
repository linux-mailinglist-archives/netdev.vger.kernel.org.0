Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688EF6A7FE3
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCBKVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCBKVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:21:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCA3298E0
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677752433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjrL2EXhz6JO0AkbHS6QYk5+IhLOU9nymJnzUdVn1xs=;
        b=VAkd69Gs2JGdo6jSejXeDScf6u2CE1plj86WUwRxuC6Z1DvD1NTlVLk5vJogjVazIGSPR6
        jnqRxlBAeyn5qMn8sTvGj85rnWrxnBNkCfwUHr86xvv5wyx+CQy0+9p7cOxPZgkQQ5NE1M
        6qLxebsOzpMjwgK3KRxeXrpgjO6cfpM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-8Hyksm1DMpyYXrroI5u-wg-1; Thu, 02 Mar 2023 05:20:32 -0500
X-MC-Unique: 8Hyksm1DMpyYXrroI5u-wg-1
Received: by mail-qt1-f199.google.com with SMTP id l17-20020ac84cd1000000b003bfbae42753so8123099qtv.12
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 02:20:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjrL2EXhz6JO0AkbHS6QYk5+IhLOU9nymJnzUdVn1xs=;
        b=Ow3hzqmgO1ZCFczDgmLE+M3Hxo3EwKMaEo9d/6BViav3Zw/sBbPa64Sa3lgQs6JL0Z
         1JVVwJvCl2fGZMnmhHoIE9Gm5dYxIlO0oXP+C4FewpO6rugaG6A7k9F0EB4cc15f5pYQ
         oVuRcBse37QLkL/fSGTidEJkPjClm3VF0mo6E7hapd4bw1SW6hqeeOcTJHeUvK8U5iaD
         3QUMBTwqtoNVVCyD/vO96anS4ls2dVM4V1e7xKxyyRUcJF6YG+Uxfi9u0iSiFALILknq
         qIkfvH1/8E9/YWMzh7cS0croFJ630wSLtz6NFuf+PjOUOwKSpLwV6v4ru60fO/Wt3Ks1
         eesw==
X-Gm-Message-State: AO0yUKV5g2SU5+EtC4UC5a6guVTkvhaPmxv4zJXTqeYs6VNV+SdFrY1F
        q5hBAoPf6fOkJQR//HkW3wdHZx6ccVIy/BsAd3LlvpASOZvaDrCkZuGtrWsPePi1nyore60pBCT
        R5E2jVVWutTLyquQ4
X-Received: by 2002:a0c:9a0d:0:b0:56e:a69a:730 with SMTP id p13-20020a0c9a0d000000b0056ea69a0730mr14035352qvd.1.1677752431457;
        Thu, 02 Mar 2023 02:20:31 -0800 (PST)
X-Google-Smtp-Source: AK7set8QkPFQKK3jKhNe0n2G/KTJFzY1FXdoKaqbHMxgqBoWOUVkxwZcGtqZie9s4/8iajizaG9J5w==
X-Received: by 2002:a0c:9a0d:0:b0:56e:a69a:730 with SMTP id p13-20020a0c9a0d000000b0056ea69a0730mr14035330qvd.1.1677752431130;
        Thu, 02 Mar 2023 02:20:31 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id e15-20020a05620a014f00b0074281812276sm10765098qkn.97.2023.03.02.02.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 02:20:30 -0800 (PST)
Message-ID: <ac92a5f3e553e35a50119918ea0f2a833c124333.camel@redhat.com>
Subject: Re: [PATCH net] ieee802154: Prevent user from crashing the host
From:   Paolo Abeni <pabeni@redhat.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Date:   Thu, 02 Mar 2023 11:20:26 +0100
In-Reply-To: <20230302094848.206f35ae@xps-13>
References: <20230301154450.547716-1-miquel.raynal@bootlin.com>
         <20230302094848.206f35ae@xps-13>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
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

On Thu, 2023-03-02 at 09:48 +0100, Miquel Raynal wrote:
> miquel.raynal@bootlin.com wrote on Wed,  1 Mar 2023 16:44:50 +0100:
>=20
> > Avoid crashing the machine by checking
> > info->attrs[NL802154_ATTR_SCAN_TYPE] presence before de-referencing it,
> > which was the primary intend of the blamed patch.
>=20
> Subject should have been wpan instead of net, sorry for the confusion.

I read the above as you intend this patch to go through
Alexander/Stefan tree, thus dropping from netdev PW.

LMK if you prefer otherwise, thanks!

Paolo

