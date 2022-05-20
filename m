Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E451D52F3B6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353169AbiETTT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347963AbiETTT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:19:27 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22B217CC8A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:19:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w17-20020a17090a529100b001db302efed6so8603365pjh.4
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=sZCDKTVgneDIxzDry0m467r/lxyqae6S6IpOW/q5QjY=;
        b=s9df+Z2cfFFwAk1/h6d8nArIkMn1r8Vb8Avshcpt4G/juKUoo12pEW/2elO5yvp2u6
         lW+b3Iu32Tq40LUVsibLYdTOy68wQkybh5NpqPm6a4hP3YF6f/fmfpe+2wvgJlT7mF3S
         dUzlNC4RvuHDN0Xj8uWHUD6ZIt3TQ6NpME84n5k/dpGSmF+tyfW0MQQPbBxftcoCGrpd
         rx3prrwRyOK6j7k25eH4bHFm+e5clf6X6b1+zwBu70r/+GM3XsOgmk69efCr+8ZcO+Ob
         S4/i6SxoVYrhMQUlkIJ8iFUGwprnn8JUoQUQ4Ge8BOwG3sKWAYP59DWvfKHNj7c6to0E
         IYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=sZCDKTVgneDIxzDry0m467r/lxyqae6S6IpOW/q5QjY=;
        b=LhiMSrxOQPiUtqOqotFM9GOw6cgxRVzXTO+gTORu/jtsa4oHWPQ0qrc3EK2vB8vmzr
         0o21P/5F6nRyyYRxii9EfMk0Y/bksADxiE/iqrPd7P04LKu8pvpj7//KMbRO1KnXsOnc
         U1EVNj/LTC3gIxeXAYUezxI7grY8HB0v+MLbdF6TL1FeztwpZ/f0wcdT8s1chd6Y50Z6
         4UztHq4wEFjTrQbhYNerjzyP+sQodngPtoZJrrZRCMUmvCUrRzegGCfaoxJ4XMHkssw2
         qeIVcBuUKmquI9fkuRW0DdSee0cmlH3CN9DfAE6D2cD+DNKiPMds2W+tBOsnAZHShzjb
         F/oA==
X-Gm-Message-State: AOAM533HyNL639cjdSgLESYieubE/V/4cRqnrLSG6e8cwEmFOQAHP/NO
        ZL+LIEOnMfK9MnIHin+EsedEjw==
X-Google-Smtp-Source: ABdhPJyPbMYHHjZJwqXKcMhWN48PKIY1GN4ALTi4MRGGZvzox3nCPJhCqk2YGF36mqyHR0abzk1xrQ==
X-Received: by 2002:a17:902:ef8f:b0:161:e39c:2f15 with SMTP id iz15-20020a170902ef8f00b00161e39c2f15mr8007374plb.165.1653074365453;
        Fri, 20 May 2022 12:19:25 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id o66-20020a62cd45000000b0050dc76281b3sm2224929pfg.141.2022.05.20.12.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 12:19:24 -0700 (PDT)
Date:   Fri, 20 May 2022 12:19:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Warnings build iproute2 with gcc-12 in xfrm
Message-ID: <20220520121921.4b0f2a5d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iproute2 now gets warning in xfrm code with Gcc-12

In function =E2=80=98xfrm_algo_parse=E2=80=99,
    inlined from =E2=80=98xfrm_state_modify.constprop=E2=80=99 at xfrm_stat=
e.c:573:5:
xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstr=
ingop-overflow=3D]
  162 |                         buf[j] =3D val;
      |                         ~~~~~~~^~~~~


Fixing it properly would be hard since buf points to element in alg union w=
hich can be from xfrm.h.
I.e:

struct xfrm_algo {
	char		alg_name[64];
	unsigned int	alg_key_len;    /* in bits */
	char		alg_key[0];
};

Looks like use of legacy zero sized arrays in uapi is the underlying root c=
ause.

Any good suggestions on best fix here?

