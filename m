Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FF457F3EF
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiGXIL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGXIL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:11:26 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2798B15FFA;
        Sun, 24 Jul 2022 01:11:25 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m17so11604687wrw.7;
        Sun, 24 Jul 2022 01:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4j2cZN1zYQwRk4mpzSYDT0FtltzsuIeHx0BCJeg+1MI=;
        b=FDC1RPQ342icpKEeFzetsAQN1Q1CFXtM5cASqyAfrvxxiF0Mi9rDkVLxxGPfS7UXJ+
         Q3096eUT8BRnrsCb1iY6+0aENWYYoP9qOg+K3yblDf62ndrmf/huBe8vHUeFwDB1nges
         xqpwsVcbZuRIKHOo9oMu3N2pcEkXHECcFHDaCYfHg8U4oxbeckCHueqb67SdxJdMxj3z
         wGkeSF/bcFcMQzvlLVdVJ4Gayv17AmSXKOCEqm8HY6VzWhVidZLl0ldUzmX11zvvy4dM
         chgw6+MRG4eYzqo6i4YV17MMFk+/v1VPkhLngGm8PBJdzOXdYwCQtAHn2ubDmGZiyaGJ
         2Kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4j2cZN1zYQwRk4mpzSYDT0FtltzsuIeHx0BCJeg+1MI=;
        b=l0gxzgmCYxHRAVIp5XxDGt1o/iSTc/MCkrBHp+Ap8emEozMZsc4UIafbByRZuK/+aI
         fEkh4ESR7tiK7y1N8LD8uk3P5Vuqdhyb+oBnL7/LiSDB5pqHlN6ZH3clf7g+HR8KR73h
         dowLBFHeGElvbZ0XouVMyZrfjzy4vo0ADdPg8mMi8PKjzl6fQU/nQonkfZP49zK1acBx
         IuDYAW24Vchk66b4DPB0yVoOUL9mJmJyv6K0Gcrfyd0WbrT2WTF7sEHiLUxtqQxjgyGo
         zvoGRqJXUaPyeZG+O5SoVv6gZzpExUFnZi5wE/29azPTRC0iSKwj87nr6iwIUtiv9XhA
         LU2A==
X-Gm-Message-State: AJIora9BOWD4MKgevDjND85idVpGVBqHPMS2V8M+SmcxxM6ueWSwTwel
        imLVLnck47kO6caa20Ln9VArPe9zmcnfSKoy/wA=
X-Google-Smtp-Source: AGRyM1tdv7lj8flnITHW2lunWgSsEX+G51gI971XJKu/diR64iG8Iwygok8RSeTQqFi6tcZnZuQKp/riuVo+gjUzxAo=
X-Received: by 2002:a5d:42c4:0:b0:21e:2cd4:a72e with SMTP id
 t4-20020a5d42c4000000b0021e2cd4a72emr4545412wrr.249.1658650283641; Sun, 24
 Jul 2022 01:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf> <20220717140325.p5ox5mhqedbyyiz4@skbuf>
 <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
 <20220717183852.oi6yg4tgc5vonorp@skbuf> <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
 <20220721114540.ovm22rtnwqs77nfb@skbuf>
In-Reply-To: <20220721114540.ovm22rtnwqs77nfb@skbuf>
From:   Hans S <schultz.hans@gmail.com>
Date:   Sun, 24 Jul 2022 10:09:11 +0200
Message-ID: <CAKUejP6xR81p1QeSCnDP_3uh9owafdYr1pifeCzekzUvU3_dPw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 1:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sun, Jul 17, 2022 at 09:20:57PM +0200, Hans S wrote:
>
> I'm only pointing out the obvious here, we need an opt in for MAB, and
> the implemented behavior I've seen here kind of points to mapping this
> to "+learning +locked", where the learning process creates locked FDB entries.

I can go with the reasoning for the opt in for MAB, but disabling link
local learning system wide I don't think is a good idea, unless
someone can ensure me that it does not impact something else.
In general locked ports should never learn from link local, which is a
problem if they do, which suggests to me that this patch should
eventually be accepted as the best solution.
