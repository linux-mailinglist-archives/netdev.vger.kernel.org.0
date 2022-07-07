Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A88569ACC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 08:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbiGGGzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 02:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiGGGzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 02:55:11 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC542CDFC;
        Wed,  6 Jul 2022 23:55:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so10141302wmb.3;
        Wed, 06 Jul 2022 23:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tle9jlf1XL+CuKZZCKk8/9Xh9QpHZZM5Qn39ORyOqj4=;
        b=f06mxs48qNo4rSKbN9MgCRF0G3k3lDnx3IsusDP4IZ7GASvreoRNWd3xTCTmWoPeoU
         /gZ7vU45VNaeCyHoSim28POqn2+9UMEejuJXE2rDpoO3BBZnenj6N8Ch1TN1a9KTzHrq
         WLQSdADneb+yfI4Bry0BKQ3UOj/Xvb5DunTMwTyevS9B9mBTjBisvr6EzjwfmOt8rgE1
         t3zOfArQqKVYOGF3UhyKhYebeDPefM4ihtSYKH7+HlKdExdm+L3JhgNqdTmBkf+oNSHN
         1UyMtjFYDD5m0JaREqHui5mbcpxVsEpuM6XarcPfuA6oc64XqrG2Gw6JuN+glp+ajAFx
         OQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tle9jlf1XL+CuKZZCKk8/9Xh9QpHZZM5Qn39ORyOqj4=;
        b=rCvUdL8vD6sye7Z+HO16fDPuwhJHaWYsKhSzt/nPHgc//23eEMBaS8UcUYONOJFwje
         4CoEPom6ML1c8gFhsyWfNaL0vkpmd7Fouj4SE40a1sXME4F/dWlzzhwf+QTF4QRjTRR+
         m5bV3kc8VVg6uFWitA4ORFLFudtJGy/6YQj1P+p9hUn9n237Rg+uogb0wUvV0boeTJFb
         w1V4G6eRwtvrs+ITqVvRV93WSSayIbTa4Bl5glDaubcvIW5cBPQFSH6mQ0WHvcsCvW5t
         9NcZt2XeukKe132nnN/dwZSUGPCaAuTpXjLhawKrUcW14j/7MwK8ERlDbm/NwYUdia4G
         8WdA==
X-Gm-Message-State: AJIora/2uCser8MEMVjGalZjYPUtf5kDwn3fc6kdogV2STEyQVCWNnjZ
        ZNGv3CT8XY4MVpUUdI+XQcbgsKJeIB3+NfptQ20=
X-Google-Smtp-Source: AGRyM1sE385x8pSeDePRC1UDcReakr6re7xVegD6h3qSltBTzx62KnIdv332ZfbwfOBmKHgg5eZkenKZJ6LL77BrVCo=
X-Received: by 2002:a05:600c:154a:b0:3a1:70dd:9a12 with SMTP id
 f10-20020a05600c154a00b003a170dd9a12mr2736421wmg.70.1657176908726; Wed, 06
 Jul 2022 23:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com> <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
 <20220706085559.oyvzijcikivemfkg@skbuf> <CAKUejP7gmULyrjqd3b3PiWwi7TJzF4HNuEbmAf25Cqh3w7a1mw@mail.gmail.com>
 <20220706143339.iuwi23ktk53ihhb6@skbuf> <CAKUejP6NG_X-Bh_xeA2y4Wru2=pxgHaRMdsvMu8NATNxPVeQ7A@mail.gmail.com>
In-Reply-To: <CAKUejP6NG_X-Bh_xeA2y4Wru2=pxgHaRMdsvMu8NATNxPVeQ7A@mail.gmail.com>
From:   Hans S <schultz.hans@gmail.com>
Date:   Thu, 7 Jul 2022 08:54:57 +0200
Message-ID: <CAKUejP6wfcCE9n=_i2vroNX+v1YdGJzOH0bev06nrUCOsRPdwQ@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB implementation
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

BTW, I have sent the patch to read the FID as you requested. You
should have received it yesterday (6th July) at around 12:25 UTC.

Hans
