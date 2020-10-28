Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E9629D59C
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbgJ1WFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729623AbgJ1WFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:05:35 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8D1C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:05:34 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m16so908923ljo.6
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=qoLyxvPE6zngznoSaKGn/AtBmivAy/fpGsC7RMh4ynk=;
        b=lErHjAX5j4TGwlXdBM4IlgufVu5zIO8wKhn+IWpB2HoTTH4AqIPG1KBKZcz5qXvwcK
         TjMeck42qi/dXhjyhvhU26UNbGTEkXkwDfbOGxBXmXLBzJ84KaoqotXE+71m9I3uDtap
         i5PXdCABUcTjARTxKaHKTQC0TY+hSMC/caaRX0pOs9HTSEroA20DUmmVwWxUjp9gG8jK
         kaHU2aQKYyYTBpX6ya0gVeiIqBeW5zwkEsviEls7xD82Qib6Sgs0YEJibx1OSlPoY00D
         sB6byZdeY5vZIShno5vg4Vt76WJR9RuU0VAXt9UeOJVDDf1NrJcY0ExgHT9Gt83ztaKf
         r6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=qoLyxvPE6zngznoSaKGn/AtBmivAy/fpGsC7RMh4ynk=;
        b=jxTVkRKW7nAiJPekwU3xdT1UDyuIL8O3c3NhmH8nJZ+zbofaw6XE0GNvwnLrLB99Zj
         efyjsOrGbd4XL0IGDU/BYO8iFJQsqBFobme+4v5glqv3gv5BIuSlU6zr8QFsdTUNZQSY
         YruR04NCVeK8NlnLohIN0loSEmDyWyttJvDlv/fSZVlw864YNOSv6I0X08DvEk5zOKv4
         +K7zCp7U2+/iI5sQrSqtXmHlwxyiTh+BGZcoQy1Hc+fEkmhHzbX4yV9k+wsflHXg8UZW
         OybwA+J4wyrWudzz7D5fTqxYGGLd5RDIgCLb/9fUCUe4/+xE+TAe7QrRGUVJbrUg8qfY
         AaFg==
X-Gm-Message-State: AOAM533tAInAhYnG1PTbktv9hZHLTq0xAFx3/wxI2+YNFfmnvWf9e8w3
        x5g/nAl9BRPS55rcMipnRQdOhWKzchg0BS2t
X-Google-Smtp-Source: ABdhPJzLSAmC1sXg8MYbdSydogcYZfJJrOsoMHahvrpcmC4y+AAlhYYBLlpme5CzZGQNDt721VuwBg==
X-Received: by 2002:a05:6512:360e:: with SMTP id f14mr2808293lfs.44.1603899158412;
        Wed, 28 Oct 2020 08:32:38 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id g15sm38278lfh.63.2020.10.28.08.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 08:32:37 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of
 packets from lag devices
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Date:   Wed, 28 Oct 2020 16:28:23 +0100
Message-Id: <C6OMPK3XEMGG.1243CP066VN7O@wkz-x280>
In-Reply-To: <20201028120515.gf4yco64qlcwoou2@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Oct 28, 2020 at 3:05 PM CET, Vladimir Oltean wrote:
> On one hand, I feel pretty yucky about this change.
> On the other hand, I wonder if it might be useful under some conditions
> for drivers with DSA_TAG_PROTO_NONE? For example, once the user bridges
> all slave interfaces, then that bridge will start being able to send and
> receive traffic, despite none of the individual switch ports being able
> to do that. Then, you could even go off and bridge a "foreign"
> interface,
> and that would again work properly. That use case is not supported
> today,
> but is very useful.
>
> Thoughts?

In a scenario like the one you describe, are you saying that you would
set skb->dev to the bridge's netdev in the rcv op?

On ingress I think that would work. On egress I guess you would be
getting duplicates for all multi-destination packets as there is no
way for the none-tagger to limit it, right? (Unless you have the
awesome tx-offloading we talked about yesterday of course :))

I think bridging to "foreign" interfaces still won't work, because on
ingress the packet would never be caught by the bridge's rx
handler. In order for something to be received by br_input.c, it has
to pass through an interface that is attached to it, no?  Everything
above the bridge (like VLAN interfaces) should still work though.
