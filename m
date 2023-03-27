Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63376C9D5F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjC0IOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjC0IOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:14:15 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F316D40DA;
        Mon, 27 Mar 2023 01:14:11 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso4592311wmo.0;
        Mon, 27 Mar 2023 01:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679904850;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWU4G3nKFJcBbrSVmK0Own01xR4ae0P4k4/h0MM+GzE=;
        b=KQGJj6dsuUQ+Zl7n6a37xTVq1RO/BfFYnBTArjdVgRRWXB9dMZHj1ursHNDhpL2tYs
         N0hc5RVx8DgW9F8M4uX24pr92zYd5awkOHRmO7DuvfBTSc9vyIWrEwwnVcU1AUeIqhFh
         yP14trTflIgA3p1Pi7CCQfSMLZMjB0JxWjMUVYEghakl0S4m0L2binTjjtmNkB2ID44k
         s9gqc9t09/lCb4wBj7vwzJxbUM26opsXZO0vZ/5Rj+R80Isg8K0xco0ZtEhuyF5mzS+P
         z3ievDVZtRn9bthVJH2Ag77X0MLKm1p7yyMNO0Edn6nwyTwaEuhNxGyyfX/7oZQgZ9Di
         mvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679904850;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZWU4G3nKFJcBbrSVmK0Own01xR4ae0P4k4/h0MM+GzE=;
        b=ucIULS3cCa+Zyq5a6C/1c4jjTL+VYjRQvqVb8O4GQMAtNMYU1+KkVDmLNOk7rkJ/kN
         6+Cd3506CH23bK8T9gb4BQxDKKZISGo5QUgWcxrELb/2GghQw+21SS7EBAp7RCEGtYea
         AGYovtO5QDqlGY/eGSMqqsvZS5iG9DWEAURgaG6k6FEU4bMBh7coldqCd58iDoy1KTj5
         mCzHFVIFFRcJbi+zxzITGUkdjNu+JfRixbXylVKcZFSqpzVJ3sVDzut+Maco5aU6aJZJ
         1mH+8C6ABoQXQmcZzwutyCJSWSJCP/hhmBvd47tdZgji346jfIq2OFmVEIkRsuO0WqAv
         qqig==
X-Gm-Message-State: AO0yUKUFTfT+lOq655njS3ASxBLSXq+CLU2P0DNYwoVnRYgSQmFxFBWu
        l6Zjg9Zzqwjo8RiO/GIxcs0=
X-Google-Smtp-Source: AK7set8q8GIalrvcrZOzwAv3vgdgJxNohUpv65uLaGUfEw+KycAKX6N7VldDa27dtV/KXg9GYRVI1A==
X-Received: by 2002:a05:600c:22d4:b0:3ed:b56c:9496 with SMTP id 20-20020a05600c22d400b003edb56c9496mr8551103wmg.31.1679904850535;
        Mon, 27 Mar 2023 01:14:10 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id s2-20020a5d5102000000b002c71b4d476asm24344663wrt.106.2023.03.27.01.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:14:09 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 7/7] docs: netlink: document the sub-type
 attribute property
In-Reply-To: <20230324205722.7b6a9e70@kernel.org> (Jakub Kicinski's message of
        "Fri, 24 Mar 2023 20:57:22 -0700")
Date:   Mon, 27 Mar 2023 09:13:41 +0100
Message-ID: <m21qlaipca.fsf@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-8-donald.hunter@gmail.com>
        <20230324205722.7b6a9e70@kernel.org>
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

> On Fri, 24 Mar 2023 19:19:00 +0000 Donald Hunter wrote:
>> +sub-type
>> +~~~~~~~~
>> +
>> +Attributes can have a ``sub-type`` that is interpreted in a ``type``
>> +specific way. For example, an attribute with ``type: binary`` can have
>> +``sub-type: u32`` which says to interpret the binary blob as an array of
>> +``u32``. Binary types are described in more detail in
>> +:doc:`genetlink-legacy`.
>
> I think sub-type is only used for arrays? How about:
>
>  Legacy families have special ways of expressing arrays. ``sub-type``
>  can be used to define the type of array members in case array members
>  are not fully defined as attributes (in a bona fide attribute space).
>  For instance a C array of u32 values can be specified with 
>  ``type: binary`` and ``sub-type: u32``. Binary types and legacy array
>  formats are described in more detail in :doc:`genetlink-legacy`.

I'll use this text verbatim. Thanks.
