Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678F16C5943
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 23:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCVWHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 18:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCVWHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 18:07:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8692819C7C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679522794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aeGjMJc3lZolnNTgrKZu8ch1xzFM6tg4UYR9OpgatEA=;
        b=Yk2Z7VBZyFKKg7mqEBBaipUKH9tPb11RJ8jjOg6x+zXW4MfSJFDnyITohcLLbzbLj487Or
        gCbos7jHeQgyUf2V2EIx6cE0PE47vynJazdRStbbc3/FBJ1Wyj/DlWD0ewpoOHTm7BDsg2
        ZfEqy2clp8j/txjIrfRh0CrG67s1tM0=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-16ng8JixM5ms9FnaVZahGw-1; Wed, 22 Mar 2023 18:06:33 -0400
X-MC-Unique: 16ng8JixM5ms9FnaVZahGw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-54476ef9caeso200944577b3.6
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679522792;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aeGjMJc3lZolnNTgrKZu8ch1xzFM6tg4UYR9OpgatEA=;
        b=jqEAhz2Mg+GHtpQqzI/agpTqgxWuMl9dGZKy0ZjYDL23+rzWIltzFPWaqmrbVo1nJG
         aGEYpn0AR45u9H3ABywXUD3YHqdrv8X1ToZkADZiwbmS9F24K0EHuZgqMD5ajZXNYAlF
         aJfB3d3GWlSiEQiYIHpqHDTC2VAX5OUZGhcb6qZB3A0tB+wqa97xYLFgno0WYKqyNFtm
         5B9WfLdmLjrGvTUeavu2s46jReXnJ3sxOgeHhRw6o1z+yfGWrSrQXie8dz3dpPIx7Ecc
         VsJrHugBaWJMK5mrQvQh70vh2mDQn/QknXfAAJNHqPXLLCDWwU4OBaBRLk9zC9ehBjBU
         t9kw==
X-Gm-Message-State: AAQBX9fMJdfT09vHffHZVjhaRQk8pTL08ArdwatdBOFIXrJId9tHkyX7
        qhlGvsUiDvIAQ1fYwZGkiJvmXDm85G8hiXSohMm+gvENwcnesWqx5kruS2g+7v7+yU2uUMoKx8d
        Ep4Q2jfFBqAfCPsJ9LzQ0C5GnrVzhEA8Yl8h0+6+t
X-Received: by 2002:a05:6902:1025:b0:a58:7139:cf85 with SMTP id x5-20020a056902102500b00a587139cf85mr849471ybt.13.1679522792656;
        Wed, 22 Mar 2023 15:06:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350aWoCef85pn20twQNfoh+cletX7ndngwTroAB8lyt9g38EKO7Vxs/HzTL119NW8uqIZF7sQnloCkLv9RcOun6s=
X-Received: by 2002:a05:6902:1025:b0:a58:7139:cf85 with SMTP id
 x5-20020a056902102500b00a587139cf85mr849445ybt.13.1679522792440; Wed, 22 Mar
 2023 15:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230319193803.97453-1-donald.hunter@gmail.com>
 <20230319193803.97453-5-donald.hunter@gmail.com> <20230321223055.21def08d@kernel.org>
 <m27cv9j9c3.fsf@gmail.com> <20230322113759.71d44e97@kernel.org>
In-Reply-To: <20230322113759.71d44e97@kernel.org>
From:   Donald Hunter <donald.hunter@redhat.com>
Date:   Wed, 22 Mar 2023 22:06:21 +0000
Message-ID: <CAAf2ycnTGqMOojeZ2UWe03zR2G9PAMCQQjpEKDJJeSEEiCXs5A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/6] tools: ynl: Add struct attr decoding to ynl
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 at 18:38, Jakub Kicinski <kuba@kernel.org> wrote:
>
> Maybe to avoid saying struct twice we should go the enum way and
> actually ditch the sub-type for structs? Presence of struct: abc
> implies it's a struct, only use sub-type for scalar types?
>
>   -
>     name: stats
>     type: binary
>     struct: vport-stats

Yep, this looks good. I'll add this to the docs too.

>   -
>     name: another
>     type: binary
>     sub-type: u32
>     enum: enums-name

