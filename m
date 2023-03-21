Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B7E6C2E5E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCUKEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjCUKEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:04:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0426722C93
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:04:43 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso10747466wmb.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679393081;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JhDXO8A3pDsSG3k7CHJLzDC7aqe7h6tFXzoDreIrtA0=;
        b=Ln4Z4PhDy91XLjNVJse3f3zd3rqmIS8kDjyUEvrkN06I80XiQ6Qpq/cM2gmmu0ipOB
         yi9YpOsC1yt/44Gkhd/mmMg3Ybi2EDodW8URqTF7J0gvMaX5fOMCZkBJVqbyS5NqiAOh
         DvrPVf8HYgAmxEym/xkvggtUjHfSjW2KpN6tpMnWA6+4ts9UbusNv1XxOzlYx/f68KBx
         YrYOjlgxSz82msRWnT3w9PQW/Bu2SVBWDOVLEQqBIPMpSpRYKfNrb0jIiLtcgrFsUWwf
         4lQbyAO8/5M+HnCBehX2ZF350gsMqizk56Mkv85BJX7nKEZL4n0Po5XxWXQtL6fG9rIt
         s4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679393081;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhDXO8A3pDsSG3k7CHJLzDC7aqe7h6tFXzoDreIrtA0=;
        b=EKeinRK30LzRzZYn63CN0NE/4Cp1iQpQh1kJSMPVf1fst9nf5mulaAmQMAs/LuTiys
         bHw5mzCsBAV6aDH7QkKEb3PIIpARE4HrlVo9HHrXXXo0XD3zcX91KGZC7O3CqvsLtiAV
         mKN0sEsQw4GJDC0DyWQDsWmBRhDFiV0hPMzyL6RoFuDXvH/VURbhBMKieWR21oThHYIp
         c3lMwU9Tq9Kd0l6Sn3q2NvJsQPWfTjvDthmW2FH6qSKVH8VqpGJJPqbvVnOzD8C+dBa5
         sMzADIUowM7y8xMrJgEH4HF8hKdQB1k56LmBQVZ1mNfOLRIfxbsEGc+m34eXIW60/MRW
         qXeg==
X-Gm-Message-State: AO0yUKVpCUtg0w7/sQQWs1WpQEAdhf9JuGxoy8VrVPPy0fWoTWM18APc
        mxlDkQSji5+hQygJq3dEMQ/5Wjog/CiBhA==
X-Google-Smtp-Source: AK7set/lDx/M0hN6fH39wC3Z1othyL7kNMMUHujvpDg4J1PtnAs0ySnT4WFWONMihxy8SJbc1Kkwiw==
X-Received: by 2002:a05:600c:2114:b0:3ed:290b:dc68 with SMTP id u20-20020a05600c211400b003ed290bdc68mr1915240wml.12.1679393081329;
        Tue, 21 Mar 2023 03:04:41 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id s12-20020a05600c45cc00b003ee0eb4b45csm3983062wmo.24.2023.03.21.03.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 03:04:40 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1] rtnetlink: Return error when message too short
In-Reply-To: <20230320201808.6cc362b2@kernel.org> (Jakub Kicinski's message of
        "Mon, 20 Mar 2023 20:18:08 -0700")
Date:   Tue, 21 Mar 2023 10:04:01 +0000
Message-ID: <m2o7omju9a.fsf@gmail.com>
References: <20230320231834.66273-1-donald.hunter@gmail.com>
        <20230320201808.6cc362b2@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 20 Mar 2023 23:18:34 +0000 Donald Hunter wrote:
>> rtnetlink_rcv_msg currently returns 0 when the message length is too
>> short. This leads to either no response at all, or an ack response
>> if NLM_F_ACK was set in the request.
>>
>> Change rtnetlink_rcv_msg to return -EINVAL which tells af_netlink to
>> generate a proper error response.
>
> It's a touch risky to start returning an error now.
> Some application could possibly have been passing an empty netlink
> message just because.

It seemed harmless enough to me, but you make a good point.

> We should give the user a heads up (pr_warn_once() with the name+pid
> of current process). Or continue returning a 0 but add a warning via
> the extack. The latter is cleaner but will not help old / sloppy apps,
> your call.

A pr_warn_once() should be enough to help the next person and also to
give visibility of any sloppy apps.

I was considering pr_warn_once() for the nlmsghdr length check in
netlink_rcv_skb since there's nowhere to reply to when the header is
malformed. 

>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> We can't put a Fixes tag on it. It could break uAPI, we don't want
> it backported for sure.
