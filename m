Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021E8665BB0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjAKMpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjAKMpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:45:39 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F3233
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:45:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m21so22170627edc.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=7WeeTEeqhgwU5qxo6P/iurPjG4E8uT02MpgGZ0Xs0P8=;
        b=oKG+jft829R84+Bpoc30xGt+pS1G0wjUVBJAznka+o0H9uXgVgBJhA53SItZDgIYHX
         cvuhxvjWtDY8Ss9necohkP8Q0fTPB0+cHw1U3zOGfzjTI3QH2mfqKfOfvTNKV4nFs0X/
         /+FqPlP//rk2b9BeuqL1GRwU45EqseQT81dno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WeeTEeqhgwU5qxo6P/iurPjG4E8uT02MpgGZ0Xs0P8=;
        b=1Yky/vt5St6a8oXkE2qyLWAlDWz18d2BI8MVdzDh7oe6eIdEmqWnNMkb25MixzjRo8
         AKq2lYsOnuRgCgfrxt8hwDqsuNJlHm7LXB99iMqVbd9mpSv/67xpQyzVZfBtJ4HHAuO+
         JsEbOjI/o482fXaJ8vWfBO6NjwFBXoZLsr/k/f4Wxsl62Yv8xFreS6mzWnoikeRuHLRw
         es53M/c7xsbzN8ddfQyojE/qycS4Yd+KR1c0eLVKUU0Qsvn5rJRxLZJYFTnJp2d5dqR+
         3ihaXWzvP3TQKy18BVqSFYTGlh9MqsPFc7RIikdsUOYyAQtodB+Cdu9ro2auTtp557wQ
         p7Qw==
X-Gm-Message-State: AFqh2kr1NhrFkONl4i32y6OQDHB4pSk9Vu1MJhbpTOLtvRjOwxTIDM4E
        0BmdDNNMBRwQqQfpdM+fl8+e4A==
X-Google-Smtp-Source: AMrXdXtMZTzIc659P/8mEWPhhbGonsr+ia5xX8hrdHIcV8RDcp9S92vhwdte8W6bEJu3IAcT/GR+/w==
X-Received: by 2002:a05:6402:380b:b0:480:f01b:a385 with SMTP id es11-20020a056402380b00b00480f01ba385mr66399495edb.4.1673441136848;
        Wed, 11 Jan 2023 04:45:36 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id i12-20020aa7dd0c000000b0047021294426sm5989239edv.90.2023.01.11.04.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 04:45:36 -0800 (PST)
References: <20221221-sockopt-port-range-v2-2-1d5f114bf627@cloudflare.com>
 <20230111012500.48018-1-kuniyu@amazon.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        kernel-team@cloudflare.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 2/2] selftests/net: Cover the
 IP_LOCAL_PORT_RANGE socket option
Date:   Wed, 11 Jan 2023 13:45:10 +0100
In-reply-to: <20230111012500.48018-1-kuniyu@amazon.com>
Message-ID: <87pmblck9c.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 10:25 AM +09, Kuniyuki Iwashima wrote:
> From:   Jakub Sitnicki <jakub@cloudflare.com>
> Date:   Tue, 10 Jan 2023 14:37:30 +0100
>> Exercise IP_LOCAL_PORT_RANGE socket option in various scenarios:
>> 
>> 1. pass invalid values to setsockopt
>> 2. pass a range outside of the per-netns port range
>> 3. configure a single-port range
>> 4. exhaust a configured multi-port range
>> 5. check interaction with late-bind (IP_BIND_ADDRESS_NO_PORT)
>> 6. set then get the per-socket port range
>> 
>> v1 -> v2:
>>  * selftests: Instead of iterating over socket families (ip4, ip6) and types
>>    (tcp, udp), generate tests for each combo from a template. This keeps the
>>    code indentation level down and makes tests more granular.
>
> We can use TEST_F(), FIXTURE_VARIANT() and FIXTURE_VARIANT_ADD() for
> such cases.
>
> e.g.) tools/testing/selftests/net/tls.c

Just what I need. Thank you for pointing me to it.
