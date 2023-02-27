Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249DC6A3E5A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjB0Jaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjB0Jat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:30:49 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A029EE0;
        Mon, 27 Feb 2023 01:30:47 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id f13so9936189vsg.6;
        Mon, 27 Feb 2023 01:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6nC/mfNKMWoB1dpOd/sE0PMhduJWN71ddJbcR3Nbko=;
        b=HlkJ7Nql/4LWvDw0s31J2GIrotG96fPFEToJNZu6QHe0GFAF0iUszUrolbLeFWo+4p
         HK5ZADJrxqkqIzYv1I06U3r/dvncnxHQol5Hzk4Cqn8xmp1lYW+vmzI69qtaJZNFTnNv
         RZMINF1DxrYY/eXv28NpzQtS7r/V21iGChbveaC0pDoKLiskV5YUh5QSv7MnLvZ6ItFG
         G3s7HoBZvOWuQHOMA8o+a8Yh9xfRZ4ARbMbsU6XAq52RbRdUSCmpUuF8OfaZmoH2RSdZ
         21c27DnjB0zRgZY9vhYva/raj3mRqiQ/aoIoEnv5QgCYVV6ukVcxcQm7wG5/fNBqu0ha
         OgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6nC/mfNKMWoB1dpOd/sE0PMhduJWN71ddJbcR3Nbko=;
        b=kWCrWaJgSh8UUGYcW6XDaSLOHVzPURQuoR6ZTVUH3jwuqHxjvIK3Oi2upmbGxn13yB
         DsZ64wvRHcxVKI8HkjEPlHxWj3uefI+kfi7W8Dph3vXiTAP0WvvzxaXPeuRY/xmN7n7Q
         ar7WmMwiP0Sj1jhe5LoyVndo5tCx91fZqPRMZyCkrIxwR9c2LR9CNVo7Od1RLxKYcZ3V
         1uHPemG7RqASXAjqPcDtEmNSvVagHYuOTEPvwLMYkTXbQoMO7afQYRzk3Zv/YQLZms6K
         +AbiQ7Xx2DZoyelEMzpxPqyJnSXiEMqInQis14RqOGZ0vA8YNtB6LB0pwchXao2YMFhN
         yvGg==
X-Gm-Message-State: AO0yUKX/D+ytzMrraFSBMkDyZZa8rOikJDLip2vjtXrw+pS/v4WDHMwc
        cyGVu6znHRtuFVz0zIJYnIDcZvjtYB1LyrSlI5w=
X-Google-Smtp-Source: AK7set+ROjFsGcad92rIu+oStwChXML4as5oWIghu15luSw3JLsqVTKaL1C6iBJRsPCtBcgzXQj6J5Dpr2Jql0Oye3E=
X-Received: by 2002:a05:6122:18b1:b0:401:a4bf:210d with SMTP id
 bi49-20020a05612218b100b00401a4bf210dmr6742561vkb.1.1677490246823; Mon, 27
 Feb 2023 01:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20230227074104.42153-1-josef@miegl.cz>
In-Reply-To: <20230227074104.42153-1-josef@miegl.cz>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 27 Feb 2023 11:30:34 +0200
Message-ID: <CAHsH6GtArNCyA3UAJbSYYD86fb2QxskbSoNQo2RVHQzKC643zg@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] net: geneve: accept every ethertype
To:     Josef Miegl <josef@miegl.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 27, 2023 at 10:19=E2=80=AFAM Josef Miegl <josef@miegl.cz> wrote=
:
>
> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> field, which states the Ethertype of the payload appearing after the
> Geneve header.
>
> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> use of other Ethertypes than Ethernet. However, for a reason not known
> to me, it imposed a restriction that prohibits receiving payloads other
> than IPv4, IPv6 and Ethernet.

FWIW I added support for IPv4/IPv6 because these are the use cases I had
and could validate. I don't know what problems could arise from supporting
all possible ethertypes and can't test that.

>
> This patch removes this restriction, making it possible to receive any
> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> set.

This seems like an addition not a bugfix so personally seems like it should
be targeting net-next (which is currently closed afaik).

Eyal.

>
> This is especially useful if one wants to encapsulate MPLS, because with
> this patch the control-plane traffic (IP, LLC) and the data-plane
> traffic (MPLS) can be encapsulated without an Ethernet frame, making
> lightweight overlay networks a possibility.
>
> Changes in v2:
>   - added a cover letter
>   - lines no longer exceed 80 columns
>
>
> Josef Miegl (1):
>   net: geneve: accept every ethertype
>
>  drivers/net/geneve.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
>
> --
> 2.37.1
>
