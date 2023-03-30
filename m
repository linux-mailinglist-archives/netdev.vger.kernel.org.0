Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B036D0A42
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjC3PpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbjC3PpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:45:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96037E19F;
        Thu, 30 Mar 2023 08:44:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so20059141pjt.5;
        Thu, 30 Mar 2023 08:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680191092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lU9JCkTye6Fj+qGS5BcJ6TDCunaP0ev1Z3VOnL6O7u8=;
        b=ARXUEmqMaQiFvA623fC9h/1bTtbZu+9APT25M51Fyzal5QyyBhpNOKenjrxHC9tNvl
         S5qRlO9XoSCMeMsGUxdNgy5JziINi0lqiObnEMVskhrUlgY/Nx4DIG0QNEQsDohNNwVI
         ZjpV6n4C/vseZe/Yaal+huKNBxLZRFnxa87dsmJ+XNyIozRshatOv7uSBF+5zoQgGC9u
         APpkQ7cgiCA7P+a0ITBi0t+ePzbvRC6ZSQ8PNQFlEV5Nkz3BPNiKrW3feDlfatNMu8VV
         ylQbTLsNnGSA8P3WnQGfjLEZ3+xacpPhY8gzVJGbk7L8KERA9bNGO7XypeGYZuS4b7+c
         MaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680191092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lU9JCkTye6Fj+qGS5BcJ6TDCunaP0ev1Z3VOnL6O7u8=;
        b=Gwhpp1CH3ATa+s2l6hpaB3nP5joifaqa6K3nft1d7wcbwEMWA4r+AZi7qphPWyHCs2
         Nog49W4S7XEBlsjWJ7ivtghFM549D/hExVrN9l77iUxRgb62zZiGmjU3RGe+sfHx5BWH
         MjeXQBRrRxHDGxGONxkNBYLPSkgGoQoLWliNxu6h+Ow/zg2seXaYhD2MYg+rCyuNsPz1
         khOqw8dykb2G0SdzWsXcMDO68s9Fj7jQ5ofzEDynphVZYldHcv5Spr3jUIksMhfJwZHs
         ppWqlUeFfro/WON8v7egFR+rE+vaEHNGw3dmtqBvW4RduHZYgtbGXqdeFV3iK2K+vTce
         hdyA==
X-Gm-Message-State: AAQBX9cXZQznOvKBR8LKDUkXTdw0N1D0vB5soaf4NfchGEZcU0Eq7idB
        TXbsRkRTUsVjDnpsQ1ZMMnk=
X-Google-Smtp-Source: AKy350an4aqBBaa4AoyKQMK/eGaMNqvVN6MWoVbuOKTA1coVugM8BSX93rzwnm0ye04pw2RvKavoAQ==
X-Received: by 2002:a17:903:244e:b0:1a1:bbcd:917e with SMTP id l14-20020a170903244e00b001a1bbcd917emr26930417pls.10.1680191091900;
        Thu, 30 Mar 2023 08:44:51 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902bf4100b001a1faeac240sm352484pls.186.2023.03.30.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:44:51 -0700 (PDT)
Date:   Thu, 30 Mar 2023 18:44:31 +0300
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
Message-ID: <20230330154431.vii5llyqgiymievp@skbuf>
References: <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
 <20230328114943.4mibmn2icutcio4m@skbuf>
 <87cz4slkx5.fsf@kapio-technology.com>
 <20230330124326.v5mqg7do25tz6izk@skbuf>
 <87wn2yxunb.fsf@kapio-technology.com>
 <20230330130936.hxme34qrqwolvpsh@skbuf>
 <875yaimgro.fsf@kapio-technology.com>
 <20230330150752.gdquw5kudtrqgzyz@skbuf>
 <877cuy6ynf.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cuy6ynf.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 05:34:44PM +0200, Hans Schultz wrote:
> On Thu, Mar 30, 2023 at 18:07, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Then, make DSA decide whether to handle the "added_by_user && !is_static"
> > combination or not, based on the presence of the DSA_FDB_FLAG_DYNAMIC
> > flag, which will be set in ds->supported_fdb_flags only for the mv88e6xxx
> > driver.
> 
> Okay, so this will require a new function in the DSA layer that sets
> which flags are supported and that the driver will call on
> initialization.
> 
> Where (in the DSA layer) should such a function be placed and what
> should it be called?

Don't overthink it, no new function. It's okay to just set
ds->supported_fdb_flags = DSA_FDB_FLAG_DYNAMIC in
mv88e6xxx_register_switch(), near the place where it currently sets
ds->num_lag_ids. Either before dsa_register_switch(), or within the
ds->ops->setup(). Both are fine, since the user network interfaces
haven't been allocated just yet by dsa_slave_create() and so, the
switchdev code path is inaccessible.

Existing drivers will have ds->supported_fdb_flags = 0 by default, since
they allocate the struct dsa_switch with kzalloc(), and DSA will have to
do something sane with that.
