Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E304A4F46
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359347AbiAaTRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiAaTRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:17:19 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72859C061714;
        Mon, 31 Jan 2022 11:17:19 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s16so13023945pgs.13;
        Mon, 31 Jan 2022 11:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7wtjFpATqKxdnDVdQqBB52ek5BkdZ1ljUXCnQMzA+YE=;
        b=X8YBNplQcnUZETMeJkil7YzspkzyBjdzevD8S5EhCJDlexq9s5syiK29gaXExTCG9x
         cBTU4EIAqxFlGcVOy9dLDJTNSr8PAc4KzWn9FXQJCMazJQ14zhMbaFZmdKsT3ySvFcC5
         +r3lQiYQjSJ1Bqpk0g5MKjOK+eUXoYnoOQAyFGhH3u1XL9W7Xvaold+XHeW+20yzb+l/
         HhmEKhdp51lSJjNPWNl/R7wrixvFWjSroT2+z5gRPJ8Qp0ZGv6Dn+lVgXj1OCWm+Sm0V
         TO33xQ1scBCqlq/eQbn3dfG86QcgRdVDfAVm0dM/1ATO/ZU/p9KluVFrM9Y+mm2Oq9/E
         aRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7wtjFpATqKxdnDVdQqBB52ek5BkdZ1ljUXCnQMzA+YE=;
        b=fIEC1jlyvQdTabSvzlXa3c0L9Sicx1tHfdmczk71MXHZc/9Y46QuRppdADd7skzu72
         LnJ9yemMUcOtrcJAQ2sfvTARV2nSdPqWkCdwI02kJ8sw5dQ5Bu5q9H8Xi0kQbQhE8DuP
         Q0UgDUhn3/UZJa38fJnIEnLOZUhqhuEnU+3Uch+yLBWnnsgHCTiEt9F2MkZcmHjkWfEl
         GvIg+ycnpetaEgg3wcOJdpDwUHF/ncMN2V2bp2CBbvSTpwuBRgFTCVgDMjSbE2qxnXDL
         DHQKXB2QynRkqI0nprXCTbyQhbOCGjY+p3LRz3xpKwAR87n6aVQFrERVpA9Xq02AyL+2
         gO3w==
X-Gm-Message-State: AOAM5319m+Mc8bMSK2506V2cKPvr/PruKHh8TrnrC7ws0nqBxCKBr7O2
        n7mMX8StPBmXgHiUQtCnrZ4=
X-Google-Smtp-Source: ABdhPJw11SX7kE9IxFaA0cpVmnKqPcCpGWxwTpOmHd3nspKT1jSnGEI0CQL4NBBvb5g7vvfFUUbwng==
X-Received: by 2002:a63:1d4a:: with SMTP id d10mr18068276pgm.92.1643656638979;
        Mon, 31 Jan 2022 11:17:18 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j18sm19961074pfj.13.2022.01.31.11.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 11:17:18 -0800 (PST)
Date:   Mon, 31 Jan 2022 11:17:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220131191706.GB24296@hoboy.vegasvil.org>
References: <20220131172450.4905-1-saeed@kernel.org>
 <20220131095905.08722670@hermes.local>
 <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
 <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 10:40:38AM -0800, Florian Fainelli wrote:

> Maybe the rule should go like this: any new driver vendor defaults to n, and
> existing ones remain set to y, until we deprecate doing that and switching
> them all off to n by 5.18?

+1

Actually, I wouldn't mind breaking old configs.  Why?  Because never
once have MY configs ever survived a kernel upgrade.  Manual fix ups
are always needed.

Nobody cares about my configs, so why should I care about theirs?

Thanks,
Richard
