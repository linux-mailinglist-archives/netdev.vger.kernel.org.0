Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515B25B5593
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiILHy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiILHyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:54:25 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E95220C5;
        Mon, 12 Sep 2022 00:54:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id wc11so3647302ejb.4;
        Mon, 12 Sep 2022 00:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=SKzjbw9lRJgBcel5ZxP+EuDqjzgPYYKLm1vp+TeEmao=;
        b=n+4YDeyora0QTIWMZOdeMAMixt9nmvLKpDxfVeUUkBvF4Ex9zyX41DuUAglc2eltdf
         LWLE0hEE/8Rs81gOvk9UAzCiZvBys0amYrLicqrFiq7hDJajaf45axUmUMcnbO5BqrHw
         lOJl3Iw/dmztLB0bE3zWt6lg12WzgEpFLNGz4YaeGfpHpblvap+WZyGlFOvhldZGCkmu
         fKC/3/I2muEK9Za+KRGNZ8LzYQb6RZRe2PULuWJ8/Jt2ysgxZnQ6Vt6G2t1w0HMw/JKu
         96yUeJqgAyogw9CBKBQsahfgdBWqNoaCW4q3bz7uJo6d9F8DBcYEadpPaPvZwPX+Bnt2
         NI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SKzjbw9lRJgBcel5ZxP+EuDqjzgPYYKLm1vp+TeEmao=;
        b=sMhpKczLUSc5RvN6WUUGrP5P2INQwcCcCnVDUlbjWtwoITynnln1VCeVbNEAmunvbC
         lzYDrPlcgGOLHXYKrIhhmNLAGAIwPzY9r5LOPa5RUHybxWuHrK/FW8Zo/lfk1a1dDsjg
         5H1LA6N4a/rgVL5sSsNZx0FQj9doH8h9aERINSo2tp0+DqGwDBiUwpL8rK4munRWvpX8
         yNGqUdw07lQQRmmLrH05SJd9ihiajlRQvHvdEWTZm/zw4J4uuFcc/8UM5RoXtU6GsSU2
         A6+B3AWIStb/D1BjXy5u5ilOKog9BtuSUPpd05uuMWipPzH5GvIlbZZkUinhn6eIYSUs
         valA==
X-Gm-Message-State: ACgBeo2qU4PWAL1xcZivFDQmnclg2E5eU87BmnT4eyxEiuLU3LnzeVti
        vCfcuh7FmMr88nNbYeFg3U4=
X-Google-Smtp-Source: AA6agR7gMSwOQYP5VpYpYYXjbopehskWuSprT2EJjXvJiS/M74ODUvx6J/6HlC3OTPnt33bw3Arcsw==
X-Received: by 2002:a17:906:dc93:b0:742:133b:42c3 with SMTP id cs19-20020a170906dc9300b00742133b42c3mr18127101ejc.502.1662969262925;
        Mon, 12 Sep 2022 00:54:22 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id md10-20020a170906ae8a00b0073d753759fasm4052753ejb.172.2022.09.12.00.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 00:54:22 -0700 (PDT)
Date:   Sun, 11 Sep 2022 13:54:52 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 3/4] net-next: frags: add inetpeer frag_mem tracking
Message-ID: <20220911115447.GA101734@debian>
References: <20220829114648.GA2409@debian>
 <CANn89iLkfMUK8n5w00naST9J+KrLaAqqg2r0X9Sd-L0XzpLzSQ@mail.gmail.com>
 <20220901150115.GB31767@debian>
 <CANn89iKMe7WZS-Q4rzqEUUD+ANL6Fmb6BnFo8TvX7y_EVi=HOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKMe7WZS-Q4rzqEUUD+ANL6Fmb6BnFo8TvX7y_EVi=HOw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 09:06:59AM -0700, Eric Dumazet wrote:
> It can be disabled if needed, by changing ipfrag_max_dist sysctl.

I understand your reluctance to add another dependency on inetpeer.

> Quite frankly IPv4 reassembly unit is a toy, I am always surprised
> some applications are still relying on IP fragments.

Do you think there's any room for improvement in IP fragments? I
believe that it is possible to make frags less fragile and prone
to overload in real-world scenarios.
