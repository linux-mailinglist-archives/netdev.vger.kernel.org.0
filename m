Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE52E5B1B44
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiIHLVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiIHLVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:21:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15E13F15;
        Thu,  8 Sep 2022 04:20:52 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 29so18734221edv.2;
        Thu, 08 Sep 2022 04:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=G8ZnoARtuecckP3hweHke5GOybQ4Tx8AFkQAdpOiTb4=;
        b=o3CYbDyCbEVhWcKDUNyemWRpDB/jalwhB9aKwfAiQiAAIycxvO3x8vNjM2BbbmGETQ
         qmYVGwNejRe0ZiGsWxi1PC8OdZqDIWoZb6HYHGpLUxXu7Om1xnQ034XpYv4zMiLlLX2h
         sg4C2k2Xv+IX34PF6zos9eS3dY/zY+vCALN73udNDncKWjxals7NZRLSiXB42Q2fNGPw
         co3sk3l0aMsDyc4fy+12gj1OOrSw+NB0qHRKLgqxrc3+6GvPnmIf7NdGZtkt+84PR2n1
         pzz0uWK02TyFNkFyV46Dr3F5EA1HbcwnOnOGQ4r60egXvGebPdNn6mZrsBtgihpNyO8R
         N1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=G8ZnoARtuecckP3hweHke5GOybQ4Tx8AFkQAdpOiTb4=;
        b=ST93VHhV17NS3A+BNIEw7O/tqSiUoj1jB+2IMz8lkdEZ4tO/Cb9EknuznNttEaVh5V
         cPPs3vQkEg7tfaoFyooMcrbpxzr/JzyupJGStTfJNQwFUuKD01PZXdyRbwOjFnYFtBRw
         tazGzeXJOr/hw91QuHD+8fTMs29s/hRL2Ktbq69+BnTgvH5AvwN2/pFDw6CvLrKfpbk7
         72XrwnnN7kkQ02xgQ0MgZ1KSLN7FAu9lY25iEUTINRXhThYDymMTwIeKiYLOdpD1/lmo
         rVRaO+IkwVnkJbU+mtTo64ofji2GCPVm7oF/dDhI7AjrpgaQFjAl2NlXJkui3tlLs29+
         x/nQ==
X-Gm-Message-State: ACgBeo0WZePBM3LFEaRGE3huGb0PyCkujDh10U++0I2+AMxr+768G2fC
        7ir+NxtEeILImjXoLp6RHxI=
X-Google-Smtp-Source: AA6agR5FVS+CRHX7ZNRp3l6+bfFEe/zLpbi+VIWGy2rLmJ3mU9ZkunVXWhrZz/JnhHHr46WP0K1dVQ==
X-Received: by 2002:aa7:d703:0:b0:44e:a7b9:d5bd with SMTP id t3-20020aa7d703000000b0044ea7b9d5bdmr6773436edq.425.1662636051345;
        Thu, 08 Sep 2022 04:20:51 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id lr23-20020a170906fb9700b0077077c62cadsm1120329ejb.31.2022.09.08.04.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:20:49 -0700 (PDT)
Date:   Thu, 8 Sep 2022 14:20:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <20220908112044.czjh3xkzb4r27ohq@skbuf>
References: <Ywyj1VF1wlYqlHb6@shredder>
 <9e1a9eb218bbaa0d36cb98ff5d4b97d7@kapio-technology.com>
 <YwzPJ2oCYJQHOsXD@shredder>
 <69db7606896c77924c11a6c175c4b1a6@kapio-technology.com>
 <YwzjPcQjfLPk3q/k@shredder>
 <f1a17512266ac8b61444e7f0e568aca7@kapio-technology.com>
 <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 01:14:59PM +0200, netdev@kapio-technology.com wrote:
> On 2022-09-08 09:59, Ido Schimmel wrote:
> > On Wed, Sep 07, 2022 at 11:10:07PM +0200, netdev@kapio-technology.com wrote:
> > > I am at the blackhole driver implementation now, as I suppose that the
> > > iproute2 command should work with the mv88e6xxx driver when adding blackhole
> > > entries (with a added selftest)?
> > > I decided to add the blackhole feature as new ops for drivers with functions
> > > blackhole_fdb_add() and blackhole_fdb_del(). Do you agree with that approach?
> > 
> > I assume you are talking about extending 'dsa_switch_ops'?
> 
> Yes, that is the idea.
> 
> > If so, it's up to the DSA maintainers to decide.

What will be the usefulness of adding a blackhole FDB entry from user space?
