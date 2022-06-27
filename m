Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18D855CFAA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiF0M7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiF0M6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:58:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657D310541;
        Mon, 27 Jun 2022 05:58:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k129so3968775wme.0;
        Mon, 27 Jun 2022 05:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JMkhE15DqUuUYsqdeVw0YV5US1cbKTxDmN+AZSpDcP0=;
        b=h0RUdzs/T1fLlIR1/zIfcZGTBTOxi0NalXvCnyBA3PGTv2E7elyVjIS0kcS62w7C9w
         kdGiI6r4eCjtXJcrM3R8GaNCejm6jR3xF/0YbyuR7hgwhhYbFxlKfl6qs6JQpV6/zT54
         nAKGvxumCU2NoVQn9kpTtB8CCDUCHlzQQvvtLOHvk63ZigC9CbUFSxdui5ZR7BL7hy1n
         Qi0H15xrkblODPN/Nx5fwtrO+ikBEKHoMCTKgDuDJrLL2HgUiPP85P19d6arDE65G/tL
         UqPyRYAtkryAZe99Mf98zV+2YvRoTCF15jc48N8OMDFVmtoHJZu2YS2UMdifPdRKr1ru
         JWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JMkhE15DqUuUYsqdeVw0YV5US1cbKTxDmN+AZSpDcP0=;
        b=MAKjOn8bFg2VL3Snmoe5cwdDZPfdUahk0bgC0epKoCuW93oekHxrHKk5Uz2XYIxX3k
         89d8SE+fy5owPO/TbT3fgX6IpmzPxUPDo4k4nFjCYBwyhftM5Acp/xjY+/92gWjW0B26
         BQJhCTL7pZ+K6DBZ1rQlx9k+hzvXrflC05/PtHJpEJ5Kek6W7IZv85rEbBTS6A9l58GR
         6O6Mh6TW9oFGd+u2DvzGEWlHMfVci1WkCVFauuupm/4bAJCuvl0r8u+bCdclBJ6nrFjY
         Ct0djpJDjx8M6oD1zwTsWoJsw71+cnV94fqCgT8CpyQyimtf4RECWrP8HHLhjRSv/BYW
         FIPA==
X-Gm-Message-State: AJIora8FoUet1SgzNXsmHTOB6ubzgvz+/JMRW8b1ieILn/kWiSvtPTzl
        FNQuV7mTOHO5CSC+/V2tCR59m9mP0jLFPgNvsfM=
X-Google-Smtp-Source: AGRyM1vjPE5hZwDXlzx8IvGj9TaZn/xlyGJ8rqNUB+DR5A3YYTBJAKlAN4COeaY6depDsGtZbnoGdALGOzVDvpJyCQE=
X-Received: by 2002:a7b:c20d:0:b0:3a0:39e4:19e8 with SMTP id
 x13-20020a7bc20d000000b003a039e419e8mr20413223wmi.166.1656334704704; Mon, 27
 Jun 2022 05:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com> <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
In-Reply-To: <20220524152144.40527-4-schultz.hans+netdev@gmail.com>
From:   Hans S <schultz.hans@gmail.com>
Date:   Mon, 27 Jun 2022 14:58:13 +0200
Message-ID: <CAKUejP7xPByVP2Qe0fFCxhU_vX84qp2i_7RFnL9ZYMVr0xH=jw@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB implementation
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
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
maybe you have missed my upstreaming of this patch set...

According to our earlier discussions I have now implemented the
feature, so that the ATU locked entries are owned by the driver, so to
make the entries dynamic I add the entries to a list and use kernel
timers to age out the entries as they should be 'dynamic'. See
mv88e6xxx_switchdev.c.

Hans

On Tue, May 24, 2022 at 5:22 PM Hans Schultz <schultz.hans@gmail.com> wrote:
>
> This implementation for the Marvell mv88e6xxx chip series, is
> based on handling ATU miss violations occurring when packets
> ingress on a port that is locked. The mac address triggering
> the ATU miss violation is communicated through switchdev to
> the bridge module, which adds a fdb entry with the fdb locked
> flag set. The entry is kept according to the bridges ageing
> time, thus simulating a dynamic entry.
>
> Note: The locked port must have learning enabled for the ATU
> miss violation to occur.
>
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c              |  40 ++-
>  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +
>  drivers/net/dsa/mv88e6xxx/global1.h           |   1 +
>  drivers/net/dsa/mv88e6xxx/global1_atu.c       |  35 ++-
>  .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 249 ++++++++++++++++++
>  .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   |  40 +++
>  drivers/net/dsa/mv88e6xxx/port.c              |  32 ++-
>  drivers/net/dsa/mv88e6xxx/port.h              |   2 +
>  9 files changed, 389 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
>
