Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B79C6D0519
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjC3Mnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjC3Mnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:43:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D55191;
        Thu, 30 Mar 2023 05:43:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h8so75934664ede.8;
        Thu, 30 Mar 2023 05:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680180209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n/8td5sRl3oLpjvJWr+SauyjMW5J+/af8DNO0aQQsj4=;
        b=R6I/30BG5UPA5FkYjKVUOSk8ON+L56EIBLONKVcUcG66As/OewLwhMJOEZ7pH/CLIF
         lw5Ldo93TyCnbouWW7sn6r3X1q4G9eBsDkqM7EGHS++EvGHXZ1BPDKRnhCkRnHpH3k7W
         toyOaQ8AdiCXYmHXxTqfMSFBKgw1bzxE4IuGtB3xQgGZ5fyVGYpbDHx/jTc/43Plix+k
         TfXLtwH042/qHJ2RMlQ5OwK2exvA5LqhC/2Bcjao6WLpg3vfRYD38I+FcWic3HWgUBY4
         0OuxkiVp/bNVDNwReIudGNhx0j7PVxoWzHj4bgO+e68KZRf4WBgjXUwtpjuoIHRN3Bwa
         nxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680180209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/8td5sRl3oLpjvJWr+SauyjMW5J+/af8DNO0aQQsj4=;
        b=HsAYBc8E7hOiKEWqL0JQAimJWb5p0rSsnvOZESP7nFcnFLu4lgd60lTErPp9XGT/ni
         Tmmip6TMJ/gPtlbLoPWbksUIZ4BWYy5094mk3NoUmH5+FI7fQw+x+KrCTXDj/uJIm5Ei
         I0eAMstzM0c7H5ZUp3UBjuCKhwaIJ9TaBEsT2UM8+5dUXeN85BSrOcyDGyu0HTqczY4/
         x6WpA4CrGsLkgVQ7U5qFvS5YDW5KV3LrBLtrLDq56smC8Yde60dIH05UrC8ifbPP7RmD
         nR5E1+NobuG4R2kcN7Tcf+c7e/3TCrcX98eogNiEnbc4XRaiXmPf6Ug2PVjFV8ySa5uZ
         JnjA==
X-Gm-Message-State: AAQBX9dXktRk2c2zrTasGjTmaDh3f5uPa8kxTbrC/lj2HoMLgpBK4orY
        Q+UDhbNGu+BcLIFxKunUbqo=
X-Google-Smtp-Source: AKy350YI2msvuHetohhT7eQ5t1xlC1RudA+4E9BCOndXuD6L8J5sWGjktS0WAdrtvGBAhM/oS9ONAg==
X-Received: by 2002:aa7:cf19:0:b0:501:dc02:1956 with SMTP id a25-20020aa7cf19000000b00501dc021956mr24516457edy.29.1680180209442;
        Thu, 30 Mar 2023 05:43:29 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q30-20020a50aa9e000000b004fadc041e13sm18202433edc.42.2023.03.30.05.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 05:43:29 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:43:26 +0300
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
Message-ID: <20230330124326.v5mqg7do25tz6izk@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-3-netdev@kapio-technology.com>
 <20230327115206.jk5q5l753aoelwus@skbuf>
 <87355qb48h.fsf@kapio-technology.com>
 <20230327160009.bdswnalizdv2u77z@skbuf>
 <87pm8tooe1.fsf@kapio-technology.com>
 <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
 <20230328114943.4mibmn2icutcio4m@skbuf>
 <87cz4slkx5.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz4slkx5.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 09:45:26PM +0200, Hans Schultz wrote:
> So the solution would be to not let the DSA layer send the
> SWITCHDEV_FDB_OFFLOADED event in the case when the new dynamic flag is
> set?

I have never said that.
