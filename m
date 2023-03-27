Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4621F6C9D5E
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjC0IOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjC0IOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:14:14 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECC340CE;
        Mon, 27 Mar 2023 01:14:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h17so7700913wrt.8;
        Mon, 27 Mar 2023 01:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679904849;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F4I7S9J20RS3ocdXoXA/pqrj7vFfddBgEtZo++pEPjM=;
        b=Nla22s3gOYHgVDQrMifz2zxxQkzk+IHf8SLh/ixPEAe/1r+F/ecsIf3leENntMRJO5
         HnlGrrOmlEUb1kZcXa07GEKtOOf2+c2FjAyHTSFfkeOzREdO1XBVy9Cd16pv0w1MdVZF
         ugVwaKZbQL31H6VueasUlduUXVdy3jgan2lCGtx7IZYSJo2b1hQFiZzp2FCuuudgjE8f
         LFXsf9PCd1+0Oi2AmhJL99I6L1cAYUzreed+ZusLUYRwY/X1lgcl5cW495H0neVWykdr
         hkGKtWZv0sB5lP+u6MLgoeyqgbfll/viGOlCHwZXDWpCVeyLf99r4SOJGi5ESndnHLuU
         RwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679904849;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4I7S9J20RS3ocdXoXA/pqrj7vFfddBgEtZo++pEPjM=;
        b=qeJzFHwr+Anwvqfz1ltADindVoj2iQD0KnJnNRAaHw5vWDX8OvPWrwWzemCQBDuHt5
         +wt4Y5atcHE9zZuWy6xIATmaI2GJ6PN8j3FvazE6vEiTLgy9LyFnTbJt4uV+R/PuQFiO
         iRKI3skNhavoirbUCRN4MOCf6l4MXSDRckg2w4HYT+TcfAru6wQVMgICPFw/YprxEcKU
         Vd7aGDcxZiOZLwlNsMP5SBneuCRTGePADtttQRhGgzEODhyri7/MjRYT3jC2kWeuS/pE
         5cUvwwio6k2+ArNQVPudXZQEtR7QxWgcHcGGjqMe+xLlBuO+O9sFJsW8EXW7w0VA+T10
         0MOA==
X-Gm-Message-State: AAQBX9eMQEwVq2dqA6oW7oAYGDDgmzJ2XwRQviqIgT1jY6/I3kTwdiXv
        0CEIioh/icNNr8kxa/e5dwQ=
X-Google-Smtp-Source: AKy350YsXpBfm4jk9ta5hfPAlAhbCsTsCRxPoSHAkTX/VvcCvNXVmZ/FgRRLCR+3qal7tXxNTJ1rpQ==
X-Received: by 2002:a05:6000:4f:b0:2c7:aed:b97b with SMTP id k15-20020a056000004f00b002c70aedb97bmr9091570wrx.62.1679904848834;
        Mon, 27 Mar 2023 01:14:08 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id j10-20020a5d464a000000b002cea8f07813sm24592021wrs.81.2023.03.27.01.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:14:08 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 6/7] docs: netlink: document struct support
 for genetlink-legacy
In-Reply-To: <20230324205224.18f31f14@kernel.org> (Jakub Kicinski's message of
        "Fri, 24 Mar 2023 20:52:24 -0700")
Date:   Mon, 27 Mar 2023 09:12:50 +0100
Message-ID: <m25yamipdp.fsf@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-7-donald.hunter@gmail.com>
        <20230324205224.18f31f14@kernel.org>
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

> On Fri, 24 Mar 2023 19:18:59 +0000 Donald Hunter wrote:
>>  Legacy families can define C structures both to be used as the contents
>> -of an attribute and as a fixed message header. The plan is to define
>> -the structs in ``definitions`` and link the appropriate attrs.
>> +of an attribute and as a fixed message header. Structs are defined
>> +in ``definitions`` and referenced in operations or attributes.
>
> We should call out that the structs in YAML are implicitly "packed"
> (in the C sense of the word), so struct { u8 a; u16 b; u8 c; } is 
> 4 bytes not 6 bytes.
>
> Any padding must be explicitly, C-like languages should infer the need
> for explicit packing from whether the members are naturally aligned.

I'll update the text to mention padding, with this example.

>> +.. code-block:: yaml
>> +
>> +  definitions:
>> +    -
>> +      name: message-header
>> +      type: struct
>> +      members:
>> +        -
>> +          name: a
>> +          type: u32
>> +        -
>> +          name: b
>> +          type: string
>
> Maybe not the most fortunate example :) cause I think that for
> string/binary we'll need an explicit length. Maybe not for
> last one if it's a flexible array... but that's rare in NL.

Ah, good point. I'll change the example to match the struct above.

> The rest LGTM, thanks!
