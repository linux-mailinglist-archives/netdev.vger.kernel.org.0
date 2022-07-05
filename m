Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C9056721E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiGEPJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiGEPJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:09:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634CD1A046;
        Tue,  5 Jul 2022 08:06:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v14so17983854wra.5;
        Tue, 05 Jul 2022 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgLijbGiv7w5WcB394gTGKOAZY0RuPs+Rksu0EAHhP0=;
        b=PoKHZYvWz8UNSDm7/4be0e1yTfsfKdrINSRSDucpfsLdJhGiMe4Dy8Fn79y/ZFH8ed
         EtXbgx7l8oqOdp8GQsG/GP9cnFhttUWrNJAqgGdnx+vhlqmVU8TA4ygdTMptBJjhOgmd
         lDDnH/VhLQVViWoTa4CfM3Lr9AhmExeui8ZeEV+P105VN7GEQQID9i7OV7a3YKX7ki6m
         ZjUPEkHwwBJguriMDYvvbafm4iqlpbwT+zv9w3M+YviR6xccU7wADVRHY9qF40xSwXhR
         arbZHnCKSdVkhy+d2Y33ulgxl9QDO/zinDGBVgYW7DogjO8frZpZ8JYSFDMtHLsLhDfj
         5Pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgLijbGiv7w5WcB394gTGKOAZY0RuPs+Rksu0EAHhP0=;
        b=502npEQpOXO2jP6gcrrWd76hRSvAZhvSw7CudMJhveaLGRpUjcK4a6hNRzDSZYsGgT
         k4Ea6vhS/R6S+kaxu4/KhRU9NsocgJfXcGf50IN16qm/Xq9MqtJzQp7G/55Kq5S2Du5M
         wR+Di0ibXs3z7WwnxnrXWit6erqU94oGm+dvkjpXxiNi7XtI5Rga6EXik+p0NIhw4fLl
         MFihPArUX9D0Eermvr1CrKIXDTxMmZpn2YUjitiG+V8+V6ln0zJ+y9DbSeEOIlL+djdR
         yKgFHjYjqBDL6qzpb3b8V2G2ShPjtx8yxaGJK0hoc7T7CZNdYR7gpKf7rIKdjTseDs13
         cG2g==
X-Gm-Message-State: AJIora/BBchM9r9t5OBtJCLBkvp7B2kCeaHuc1h2pDSCLvkd7Iai8xZH
        gRG5gQ15q1vt7SjsQW6GLp3vQaS0SwZujOfxyXI=
X-Google-Smtp-Source: AGRyM1tMCOqLTke6TsDXgHYxIwD9oqUmgJVOT1lWwBK5iPyT9H0GTNI4QtbhuM0kJD8N/fGbNKEtr6lSsyuVHIklGYA=
X-Received: by 2002:a5d:4304:0:b0:21b:9b2c:be34 with SMTP id
 h4-20020a5d4304000000b0021b9b2cbe34mr34682824wrq.577.1657033563457; Tue, 05
 Jul 2022 08:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com> <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
In-Reply-To: <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
From:   Hans S <schultz.hans@gmail.com>
Date:   Tue, 5 Jul 2022 17:05:52 +0200
Message-ID: <CAKUejP5u9rrH8tODODG0a1PLXfLhk7NLe5LUYkefkbs15uU=BQ@mail.gmail.com>
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

Hi, does anybody know what it going on with this variable?
struct dsa_port *dp ->ageing_time;

I experience that it changes value like a factor ~10 at times.
