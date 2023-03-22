Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFE96C49BA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjCVLzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCVLzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:55:39 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392F550FB1
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:38 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id t19so8092211qta.12
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679486137;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5ww91BS0BsTBRfhDuq0L/dZ3gbj1JWcZ7Z1J95zKsT0=;
        b=NmjuJ84JWbJrWABsGO3X2w2jmXd+iP+pLsZYkJUq8IYeRd+R9m2QeOrPNtGlIcZbZ4
         7jy218wLkppZXYpeKxScMCPCJGBPX0ooODOwrxuR7JxPI3PUd+T8k8LFLlGaQtESOyrF
         nSAmmf9BlrjvleOt7MNHuxi0rh9v/MHsTMK9xcG1xOGWh3kgaEHpZfRaeAFbZiki0elr
         RFKRQpsWMm03BwcswHMGn+AG6CNjJHZpClsYs1VeTfhVM08jN0C0Nh5d0x3n3EfOzSyt
         LLJYvi37sNVwKhaAuM05oCzkpZdhGE/ndn+AhUH9/7S37+DO0vzCbOeX7MIyu0N3diIv
         w5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679486137;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ww91BS0BsTBRfhDuq0L/dZ3gbj1JWcZ7Z1J95zKsT0=;
        b=JfDvQNJja1c6UfcGhZKYx9wWOPueYTUcmdht+2wF9YMeezv7a5Q8AMwFXQg58jT7m0
         J28WiarJIWCOsgQ0IhwcN8tAW/gQwLWSbXjoFCcDqkAa4y+OF77zcK0UK9zolxEd86bk
         xlIcU0x1FHGQIi2wsL4a1rfYFodC4Gnz1ySeRZ2y8W3SN+bLGpEz/lsQP8oTHWxs+18f
         3GcrYkZvLmOEpB+sxDh70f7pOFXA8XDL4PIrg8vZqC0FD5DZK5nopkXl/8Y045P19r0y
         2eOMkVQQFR/FudVY5MqVE83wGnR88lfAkAol5ao5nbDatgzLO6o1lDhXXKhsO/J+D2KB
         lZuw==
X-Gm-Message-State: AO0yUKX6nE5ax7kPPkcOGCPKojaXvWYm4eVUw2XT00G3phDIRadLh+pW
        zr1VS92eT0v6p1YLUnIeEwg=
X-Google-Smtp-Source: AK7set9en6/1s4dXucYz+AW9uUsH88NHDSUqGyeAA4ygPSSQuzE16ekXI7/KpkaqB/b7AnP2z6jrPA==
X-Received: by 2002:ac8:4e42:0:b0:3bf:e415:5cc3 with SMTP id e2-20020ac84e42000000b003bfe4155cc3mr6184627qtw.58.1679486137248;
        Wed, 22 Mar 2023 04:55:37 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id 130-20020a370888000000b007467f7536d0sm6613968qki.99.2023.03.22.04.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:55:36 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 4/6] tools: ynl: Add struct attr decoding to
 ynl
In-Reply-To: <20230321223055.21def08d@kernel.org> (Jakub Kicinski's message of
        "Tue, 21 Mar 2023 22:30:55 -0700")
Date:   Wed, 22 Mar 2023 11:48:12 +0000
Message-ID: <m27cv9j9c3.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-5-donald.hunter@gmail.com>
        <20230321223055.21def08d@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sun, 19 Mar 2023 19:38:01 +0000 Donald Hunter wrote:
>>                  enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
>> -                        string, nest, array-nest, nest-type-value ]
>> +                        string, nest, array-nest, nest-type-value, struct ]
>
> I wonder if we should also only allow struct as a subtype of binary?
>
> Structs can technically grow with newer kernels (i.e. new members can
> be added at the end). So I think for languages like C we will still
> need to expose to the user the original length of the attribute.
> And binary comes with a length so codgen reuse fits nicely.
>
> Either way - docs need to be updated.

Yep, as I was replying to your previous comment, I started to think
about making struct a subtype of binary. That would make a struct attr
something like:

 -
   name: stats
   type: binary
   sub-type: struct
   struct: vport-stats

I originally chose 'struct' as the attr name, following the pattern that
'enum' is used for enum names but I'm not sure it's clear enough. Maybe
'sub-type-name' would be better?

I will update the documentation for this.
