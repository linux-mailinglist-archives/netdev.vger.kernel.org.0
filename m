Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208E36E9C4C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 21:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDTTMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 15:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDTTMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 15:12:14 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4E626A5
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:12:13 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-325f728402cso526925ab.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682017933; x=1684609933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqEIN4SMIZsuH9HdaZLd1IND3gRSRfJn3rsfbWSMaiU=;
        b=yhBCb+Sr7WQA0BtuqZ+RwThUCCAF9SNoQpe26/kRwW5y9sLLtbnAn9tUB4iejYbsKj
         GEn4qXGckxj+VieaA1BOOpcz65xZ8E36dx7BHiPA2YVHcvb83IVyHmLIg7DaGJqA/VM/
         iKDG5ZgUAf2sO41mDZrOXwWxAoY/naG0Al8R82L44fbxS1eowAsTzkVo2+A4Wy6NHX9E
         jvYBx+bpJxb5xGsTMlnfl8aj55CIzTd3LGospLURDsilcs27+jWyhJxrVRnJn15KlXVP
         0hOHvmhQNpOG/sCjDDznCC0x5nhDRIn8HmiLKSRTE7tS0jSFxns+OdSZWdGsbufo0IUS
         pAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682017933; x=1684609933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oqEIN4SMIZsuH9HdaZLd1IND3gRSRfJn3rsfbWSMaiU=;
        b=F79mrs5Dc2774Q8pJFAoNbULRE6s/EHmWsG5OTUAQmD5RuXpzvMcfFoJAn6S+v+9Qe
         obV377WTvpnfKMZ9lJdlMJ1yvJiA5rBstZ6+nX/bBlY30kbFQfG3wfwsCva6PhdiXIMl
         SNbAqqXPPHsO3pK5pDdk6IHkBoHARgRJqoEDZUCffz1NUxpmJuxlMqUxvwaD/83uthV7
         Zstio4wMtg2apTx/ly21vDsuqHbIgrQdssJaZT7uF5ODiqHxBIrs9EqnwW3OTCGZzNAj
         Bt1RMtdSxYyqtv59uo/Nf8bigmJNvdOqnOQ+kNe4JcBJhKxlZrh9rpV7Hkl1QCJDnNR4
         aWEA==
X-Gm-Message-State: AAQBX9c3qpzL60Wo41fKndPZkQeZDOXQzYdICVlNnAYoEa/OyRRzMo1L
        Z540jMP5VMpYwt/s0lPYddd4/wqrpUY0C4oCuljuIw==
X-Google-Smtp-Source: AKy350YopqB+b8sKwBoJVUYzrKicU1q5lqHRZc+vzJz74Un3jiCs1r9Y4mQTVCKcjv6J3dBFqTP0DIydoLOW7rl8fO0=
X-Received: by 2002:a05:6e02:180a:b0:32a:9305:5d90 with SMTP id
 a10-20020a056e02180a00b0032a93055d90mr22310ilv.11.1682017932596; Thu, 20 Apr
 2023 12:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230419013238.2691167-1-maheshb@google.com> <0097c9fc-2047-fce3-7fc1-b045f58226d8@kernel.org>
In-Reply-To: <0097c9fc-2047-fce3-7fc1-b045f58226d8@kernel.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 20 Apr 2023 21:12:00 +0200
Message-ID: <CANP3RGc1+XGjh3b=hT0qZHiJfLwoLctVgbEBd3f-9CYe9od6EQ@mail.gmail.com>
Subject: Re: [PATCHv2 next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
To:     David Ahern <dsahern@kernel.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>

Though I am wondering if it would make more sense to put the check
inside ipv6_anycast_destination()
'treat_anycast_as_unicast' or something.

On Thu, Apr 20, 2023 at 8:55=E2=80=AFPM David Ahern <dsahern@kernel.org> wr=
ote:
>
> On 4/18/23 7:32 PM, Mahesh Bandewar wrote:
> > ICMPv6 error packets are not sent to the anycast destinations and this
> > prevents things like traceroute from working. So create a setting simil=
ar
> > to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).
> >
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > CC: Maciej =C5=BBenczykowski <maze@google.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst |  7 +++++++
> >  include/net/netns/ipv6.h               |  1 +
> >  net/ipv6/af_inet6.c                    |  1 +
> >  net/ipv6/icmp.c                        | 15 +++++++++++++--
> >  4 files changed, 22 insertions(+), 2 deletions(-)
> >
>
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>
