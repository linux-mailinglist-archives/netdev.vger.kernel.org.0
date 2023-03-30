Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD026D0603
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjC3NKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjC3NKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:10:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DF59EF8;
        Thu, 30 Mar 2023 06:09:58 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id kc4so17990500plb.10;
        Thu, 30 Mar 2023 06:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680181798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WCALfOMUCA+7cbkFzE5ClFTbOlYcV+OCvi/3vd2QpzI=;
        b=q8EbuTS0Rvsdu2umDVcsX21gG7WlwBzQRSqG+glphuDbA68bBDGtsvmT3P4wfKGP/6
         ksI2QycwJ29BgXgpZszGd2yR0nsJiBoy7uSSOYvh85ySy/olqUxqsPlXQM4MEH0ETDj/
         Uw+uVa11ka9CvyYadaY/ppOZQYZTFMDLdAOO/4yfQZY4Lci9qlzLc7ZQUKcH8hD1kDq0
         eADo2mZ+huDKbIocDnksJPdZc3Kjj+S+j7v6iNX5qjWpz1lIj74uGkJ7fjiupJtogC0T
         szUgAORRQQJsjzinKN0/7PImycWiK1SPZlTDYgNbUpsEVOWW+wIMqJScJUQ5IMBbm+WY
         Vo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680181798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCALfOMUCA+7cbkFzE5ClFTbOlYcV+OCvi/3vd2QpzI=;
        b=7MyKOIpSAAmOsLOYdHgUrXwMgOWdDxJdK5lbIG+Br+aswK9ISaGnJd28YTGwMvs0ds
         gSDAcj6wjs6nZKqU4zccovWYk/7BGzRnTmXmmSVAiAkvqKdQNGkRtLHpDn0tL2OAiwBv
         QL49vpA2Tie34AoS3zBWX9vCzttlaiS6/Q8SVPFa0ObMqSICYEcQyJoL6OvaOUhagYIT
         LrN0lbr3HqXUGO8aoQSsSl7aKLmyLsgWpGh2vkb62ujKnRKli7eP+RRa8jGS8QkuT5Yg
         2WH1Ab/HsZAiSQnISWyFYoUu1StjapQw+dUVWY1Rsqp6icEqV6iUeN0y5Bz/+cj/EJoL
         4nmA==
X-Gm-Message-State: AAQBX9fdXeEQjxd3+xeWpA5H6phbb8DrcnlTd7xUKpfKPm+FUSNu0KFl
        LwtIqhCHiMC3ra3VD9VYuog=
X-Google-Smtp-Source: AKy350ZW/GFX58WiadMJbKuotQrVNunP5H2QYeW0YokOfcetmboxpxgezstrTiQ7wxDpKxZnD/BZWw==
X-Received: by 2002:a17:902:ce8e:b0:19e:2fb0:a5d9 with SMTP id f14-20020a170902ce8e00b0019e2fb0a5d9mr6584147plg.32.1680181798039;
        Thu, 30 Mar 2023 06:09:58 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w22-20020a170902a71600b001992e74d055sm8707635plq.12.2023.03.30.06.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 06:09:57 -0700 (PDT)
Date:   Thu, 30 Mar 2023 16:09:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230330130936.hxme34qrqwolvpsh@skbuf>
References: <20230327115206.jk5q5l753aoelwus@skbuf>
 <87355qb48h.fsf@kapio-technology.com>
 <20230327160009.bdswnalizdv2u77z@skbuf>
 <87pm8tooe1.fsf@kapio-technology.com>
 <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
 <20230328114943.4mibmn2icutcio4m@skbuf>
 <87cz4slkx5.fsf@kapio-technology.com>
 <20230330124326.v5mqg7do25tz6izk@skbuf>
 <87wn2yxunb.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wn2yxunb.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:59:04PM +0200, Hans Schultz wrote:
> On Thu, Mar 30, 2023 at 15:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 28, 2023 at 09:45:26PM +0200, Hans Schultz wrote:
> >> So the solution would be to not let the DSA layer send the
> >> SWITCHDEV_FDB_OFFLOADED event in the case when the new dynamic flag is
> >> set?
> >
> > I have never said that.
> 
> No, I was just thinking of a solution based on your previous comment
> that dynamic fdb entries with the offloaded flag set should not be aged
> out by the bridge as they are now.

If you were a user of those other drivers, and you ran the command:
"bridge fdb add ... master dynamic"
would you be ok with the behavior: "I don't have dynamic FDB entries,
but here's a static one for you"?
