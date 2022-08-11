Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AB858F732
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiHKFJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiHKFJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:09:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69EE83BEB;
        Wed, 10 Aug 2022 22:09:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p125so12043126pfp.2;
        Wed, 10 Aug 2022 22:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=DZrxMuUWLyOOGOzou+/YbJCnEI+s6JajXm/D/EndXY0=;
        b=A213iWRXguE8DZnpQIMCrIlREr6BNeY4UQGwFU3+PYimUNEcvxJJw745lEfZYjDOwC
         pJhyRN+HKo7MdLzRQ0VGBFR0DvPdMDYGxRvVe5d3srZwI7YG9GTpe2J2fgUgIJtqPZbU
         3Yy1Wng6CTobUIFcGP6KXOR0njOIjtvQJH2y6voZFeXExvMyEHCwSpzUY4wqFTPv1kBx
         RWpGI5dv6Ig07hVwydmV61S6Dmbf3EEVmlWl5sL04ETo7yiQdiTLeeReJoD/dtKFC73n
         zKAY2J4vX8Teg2OUP4Ty01m0cSBCh5Su788OlbfCe5tCgtpTqaYkkvkfNEDWIwexvhI/
         +x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=DZrxMuUWLyOOGOzou+/YbJCnEI+s6JajXm/D/EndXY0=;
        b=KdLGMdHjDFIL16Ah03x8KKzYU/LAOvCjtpp6b3bwuFxHAdNfBofMgrr8Luo4x3K/pR
         Yr/XCKCbau9aaIfj0v/pQg0/WUtUmb3biRbzs9mew0/Y3gyOYyGs10tZ2kVm2aeZN0jy
         4tn0URYu8y3MLrvUarAVxzPt5mpT3tDeYINGiMMqMzxurLbpUsMAjOXQOEu9UaiRm4xY
         5Fk2wpvh//eMfR7iovaMPhLxWtDpgaWlXYGVxaG3xNsGP0InFpQV3iPkqgzY7Z+vUp87
         /WIR/rgw0UKIXcAviytjM4/MXUXDsMTnZ6wy/uDY+oOxtGbsp+4GEgKvItjX/WJchnql
         oitw==
X-Gm-Message-State: ACgBeo1co8YabiFO+JsuygEMRfGVA6zuOaCSM6akEabbVUvXBJpXTAVW
        Ie2OXToX24pQGs5/0lwwmBY=
X-Google-Smtp-Source: AA6agR4CYIBep1Qc6b2rxtOzCLCWjyelWDv+c6Jn1ykqtKYdC0nWTbjGrVaVzqh2oca2PBbd0hVOCA==
X-Received: by 2002:a65:6556:0:b0:41c:9c36:98fa with SMTP id a22-20020a656556000000b0041c9c3698famr25928505pgw.491.1660194563312;
        Wed, 10 Aug 2022 22:09:23 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902e88300b0016be96e07d1sm14005662plg.121.2022.08.10.22.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 22:09:22 -0700 (PDT)
Date:   Thu, 11 Aug 2022 14:09:21 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/6] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <YvSPAatX80jGiS3x@d3>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220707152930.1789437-1-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-07 17:29 +0200, Hans Schultz wrote:
> This patch set extends the locked port feature for devices
> that are behind a locked port, but do not have the ability to
> authorize themselves as a supplicant using IEEE 802.1X.
> Such devices can be printers, meters or anything related to
> fixed installations. Instead of 802.1X authorization, devices
> can get access based on their MAC addresses being whitelisted.
                                                    ^

Please consider using the alternate vocabulary discussed in
Documentation/process/coding-style.rst §4.
