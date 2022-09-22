Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DEF5E6032
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIVKwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiIVKwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:52:42 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1250D12CF
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:52:40 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id t4so2572752wmj.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Bikfu9VF8lWtDAMU0VV7sUZO7vHVZQkJiPwe7kwtQlM=;
        b=J3gbvk/RkCgohmBDUoBlLUC4QpRAR3oSgXCBzwVRp28JD5KMJcqjZu4S3Xd8twj8ss
         eFsxMJOV2NwITrebvrKkUxU0PPqhOdQVO4aJkqLTua981Van3zp5bdIgSyePsBykE45/
         HfHEqCJgw0/gn34Tzz+bz3pLqsrNFlSm2ce72SIffNQF56SbRibv8jCa3nDo7duDTkJS
         kDb1+SWBuzHEsEFWNvukext1GXlbwi8pLuMZHchGMVGQNtkA5Tgc0Uhn5SCw62O9kVWC
         phB/uSwCxvbToQvIOE89iEYsBpw9eYgx1mcV7+39/gk+KHcRq6WtjTgayEdPaztBCp8i
         hl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Bikfu9VF8lWtDAMU0VV7sUZO7vHVZQkJiPwe7kwtQlM=;
        b=zxAAG6mYkXloOiwbfZXrxE0XSmzs3KFVq6CiTh/lJwBuu9I6kStSesIsojwWV8Ekep
         6XhEpmuroY6L+iGvi+L/Z7Dif6AuNHHHify/FFhLUPA9VexGnRoY8yV1FptBnr0aoOrY
         bD37/lBTsU61ph7b/RLmN4aW8jGhG8b95v22hT0kmZw3pLRfw1E8sxDaZcNiSU+I59o/
         vDmzMNvkKzHDZMS0iV11SeAeNQcd3Yc04oThUywJytyu8OPKwgpqn846lsfQXHoa+g4C
         QxKUo68utiubviQD4aZ8BhqIzXcCCkmluecwFGNXyFVVbphZOzmirK2uUPYyP2MlmFtD
         xofg==
X-Gm-Message-State: ACrzQf3Z5k6U3Rvh80B2otuyA2cFD2uWaBMj4UUZMB1P1uCbyD3dLDUc
        0vKuJx6iQ/ni5TLsmeQv4H6voV029klIBrvrXILdQa8BQkWpbRZnu/nbw/YgSND8RJk9NTFTO73
        p97I9vF/QYA==
X-Google-Smtp-Source: AMsMyM4NFnSUuOyhPxz7mtyjvjE2L6akVarxtra69+Eusy/0jUrgd/ayIrQzD/Nr9diqHmrewPYVGA==
X-Received: by 2002:a05:600c:2608:b0:3b4:8dac:342a with SMTP id h8-20020a05600c260800b003b48dac342amr1875242wma.102.1663843959506;
        Thu, 22 Sep 2022 03:52:39 -0700 (PDT)
Received: from ?IPV6:2001:861:8c83:2890:1620:611f:b978:32ad? ([2001:861:8c83:2890:1620:611f:b978:32ad])
        by smtp.gmail.com with ESMTPSA id n185-20020a1ca4c2000000b003a682354f63sm5468276wme.11.2022.09.22.03.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 03:52:39 -0700 (PDT)
Message-ID: <5047a4c0-ee4c-4ccc-f764-a94d609be7db@wifirst.fr>
Date:   Thu, 22 Sep 2022 12:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
To:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org> <20220921161409.GA11793@debian.home>
 <20220921155640.1f3dce59@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220921155640.1f3dce59@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 22/09/2022 00:56, Jakub Kicinski wrote:
> NEWLINK should have
> reported the allocated handle / ifindex from the start


Could we not return ifindex as a COOKIE when extended ACK is enabled?

However, I'm note sure that it will helps to simplify API. COOKIE are=20
not well defined at the best of my knowledge (and very rarely used).

--=20
Florent.

--=20
*Ce message et toutes les pi=C3=A8ces jointes (ci-apr=C3=A8s le "message") =
sont=20
=C3=A9tablis =C3=A0 l=E2=80=99intention exclusive des destinataires d=C3=A9=
sign=C3=A9s. Il contient des=20
informations confidentielles et pouvant =C3=AAtre prot=C3=A9g=C3=A9 par le =
secret=20
professionnel. Si vous recevez ce message par erreur, merci d'en avertir=20
imm=C3=A9diatement l'exp=C3=A9diteur et de d=C3=A9truire le message. Toute =
utilisation de=20
ce message non conforme =C3=A0 sa destination, toute diffusion ou toute=20
publication, totale ou partielle, est interdite, sauf autorisation expresse=
=20
de l'=C3=A9metteur*
