Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDED5ED717
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiI1IEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiI1IEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:04:53 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763BD1582F
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:04:49 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso652194wmq.4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+yuJiz4NW/IRqFC/oPunRj/eQAk29rUbGf4A56WWW1s=;
        b=ciJOCRTZgpHk8PsrUAyz1IzGLwt281jFEs/x9NuPZwpLDvio/YcTVfrzG3DzkIcxeb
         tldIzyZzacaX/t+/K7jX4CU1HgQpLJDCoP6OdEjrCiI53QZgxIrZGqvYcB0ycccVkAGy
         tAhwr6PWDBVjNMNF9p0KZn4D6Uq8dD7MCFPNx0LoZvfqQCln0PPcXS7TVlZ9FwZQwa3X
         rNTtP7n0THpQz6/UqNBg9oBdY5PjcJAxHWsngtn+WsYd4Tu+TuTp+tgeZz5tz9yIYSRF
         VKJTh0Va41tGGFQdNimt3PDFyc949yciF0+K+U9RrHnG0RTZmwNjLFLrNdm1APJM6RNo
         VasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+yuJiz4NW/IRqFC/oPunRj/eQAk29rUbGf4A56WWW1s=;
        b=f2K8/MmpBFm1bPe7JgWtzsEoMwtiRK/hZX19oC61nvnkBif1ZLG3uBigKw6QwCKoEM
         H7qbyEN6jvbnNnDn0uyV+aykqcNj7y0qPaNzSUr+Pectc8XBwA6UZD6XKyaCdjS67haf
         Bxve43dYdKKaV3afjcrNtB7q0JPwBYpcz8Jd4Y+GSvuF5HcVJ0w7VBIlYQ5j1pAHulE5
         ZjEUgPw3cpE8ebbcjXWv9DKZ704nXKxJbquk6Mmmj7bHhifPq91JVlDlB4pMowTCbmQT
         D7EJEJ1dqbthxrT1GcQI81ZWl+NNc7zxOq2UYJIupZPEkoTzPs0VnMsjUeGyijRQtjDD
         S1sQ==
X-Gm-Message-State: ACrzQf3byWT/JOPhLd86OXeSABbAETcmrZSxaaD0Ua8E0UMAGi19kgSv
        KxmDwWBrgxhkHeuPjIBWaR6DphEOh1bOsL0vQgEpB2zHDwtfF48ghqCs2OpaOO4x7UYzIH3wn+v
        P++gpH6zBrQ==
X-Google-Smtp-Source: AMsMyM5DgNR0S7/zHpVphv/ffU5DHBgjlewnJQmT5sWewWZarUCO7PysUstfE5FXtEeNH/z069GGJg==
X-Received: by 2002:a05:600c:3493:b0:3b4:9a0e:b691 with SMTP id a19-20020a05600c349300b003b49a0eb691mr5705679wmq.123.1664352287843;
        Wed, 28 Sep 2022 01:04:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:993:6ec0:600b:7e72:20dd:d263? ([2a01:e0a:993:6ec0:600b:7e72:20dd:d263])
        by smtp.gmail.com with ESMTPSA id p18-20020a05600c359200b003b47a99d928sm1051874wmq.18.2022.09.28.01.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 01:04:47 -0700 (PDT)
Message-ID: <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
Date:   Wed, 28 Sep 2022 10:04:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220927212306.823862-1-kuba@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

About NLM_F_EXCL, I'm not sure that my comment is relevant for your=20
intro.rst document, but it has another usage in ipset submodule. For=20
IPSET_CMD_DEL, setting NLM_F_EXCL means "raise an error if entry does=20
not exist before the delete".

For IPSET_CMD_ADD, setting NLM_F_EXCL will raises an error if it already=20
exists (that is fine with your documentation). But without the flag,=20
IPSET_CMD_ADD is more or less like a "replace" operation, since one can=20
update fields like counters values (IPSET_ATTR_PACKETS /=20
IPSET_ATTR_BYTES), without using NLM_F_REPLACE flag.

Best regards

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
