Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5082866B56A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 02:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjAPB4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 20:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjAPB4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 20:56:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5EE7AB3
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 17:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673834056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3yuuE5ltojYLr+OPOc1s+CNoWdzLM+TuLPRU0pT3Ikg=;
        b=bVpGF+pNwfoUTgyMAwdlucL/7tJOEJ69E6bAa+tClcI/x1zVySynj6JjJM8Acwbm0qho+N
        RCAAuUO9EDIbLBsBiE6QZnCSAqr9/rNiYmuinH7Tl46rN+kshRVfTrgSy8zt6H2mFzjWxb
        TfrL/JO4Ogx0yP6aiI3ZJHDduw2y8as=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-519-EytiHkJiO8mXczE0pxqgqg-1; Sun, 15 Jan 2023 20:54:14 -0500
X-MC-Unique: EytiHkJiO8mXczE0pxqgqg-1
Received: by mail-ej1-f69.google.com with SMTP id oz11-20020a1709077d8b00b007c0dd8018b6so18591632ejc.17
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 17:54:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yuuE5ltojYLr+OPOc1s+CNoWdzLM+TuLPRU0pT3Ikg=;
        b=KsvoNzdXou8MQ5IsICTbu24IaHvoIc89JEZl+m91wG6KsmQFoJY1OIJmqyvRmf15s0
         pzgwOpeySe4lOBzqfWqno8eBRx4botpEPElENEBz8z5lGiJS5G4c+Woo+Qzziwvu7owh
         9auSifeBuKT5tQpik/aJriraamtsyAfRdKiVp3axywnRhX17WdXKReu1gbu5luuX75vs
         P2BWslAYpWw5uVeuLossyaspFAm3Q+wG42pJnQ+PHyVpZ/2n3pb/lMw+TX87KuZ9Glgo
         NkUW+Fkyr8tFJPkxVPJP7fuGH/wwKqlUzWVq86ndiqiAoJQBWWBonlXWBwb3g2E8aS7O
         AmtA==
X-Gm-Message-State: AFqh2kr2YIbuRH9Ak3QEobbn+4iCj2RS3DWc7XDdcndeoj6K6smVIuAO
        jG7J+Bc52P5gOUIx+MeVSziDFBRwVQ6E5/RlYUAp5goffouGk90+1TGET3ua+NHtVc63TDUmjn4
        7PJi4387SnmvoSGjBQghVh257k6NLkTmS
X-Received: by 2002:a17:906:a2c3:b0:839:74cf:7c4c with SMTP id by3-20020a170906a2c300b0083974cf7c4cmr9182715ejb.265.1673834053768;
        Sun, 15 Jan 2023 17:54:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsrda6ER7HiS8zFF+RznLSBWdkV9MwTjA4ki7ImoWRjl986SSltVk1zUjYFWZIWM4RrDzVrhDb0cRpTRcSINqU=
X-Received: by 2002:a17:906:a2c3:b0:839:74cf:7c4c with SMTP id
 by3-20020a170906a2c300b0083974cf7c4cmr9182708ejb.265.1673834053616; Sun, 15
 Jan 2023 17:54:13 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
In-Reply-To: <20230106113129.694750-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 15 Jan 2023 20:54:02 -0500
Message-ID: <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
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

On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Scanning being now supported, we can eg. play with hwsim to verify
> everything works as soon as this series including beaconing support gets
> merged.
>

I am not sure if a beacon send should be handled by an mlme helper
handling as this is a different use-case and the user does not trigger
an mac command and is waiting for some reply and a more complex
handling could be involved. There is also no need for hotpath xmit
handling is disabled during this time. It is just an async messaging
in some interval and just "try" to send it and don't care if it fails,
or? For mac802154 therefore I think we should use the dev_queue_xmit()
function to queue it up to send it through the hotpath?

I can ack those patches, it will work as well. But I think we should
switch at some point to dev_queue_xmit(). It should be simple to
switch it. Just want to mention there is a difference which will be
there in mac-cmds like association.

btw: what is about security handling... however I would declare this
feature as experimental anyway.

- Alex

