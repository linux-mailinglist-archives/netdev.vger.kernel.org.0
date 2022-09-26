Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2B05EB26A
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiIZUlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiIZUkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:40:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CADAB432;
        Mon, 26 Sep 2022 13:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB68B8111B;
        Mon, 26 Sep 2022 20:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1929AC433D6;
        Mon, 26 Sep 2022 20:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664224827;
        bh=seglhfOiNMrFtc/ni/J5+ETY9FK/ht2gFC/YZWLxHZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PbSei11B61mV/PgvFyJSKsXf4YV/P1/Ost3I4y+1GWEKuzFebR8BJVL65E6y+kDoh
         pgaU/naJjvS8En8kklC0OYzxOjvYj4T7epxxXb1w3hHaON2Y3HEYrmFOHwsHRCZOJ1
         LPUwr2sJal9u+EPfd9CeSTlLGP8C7y4ZrQRqp3lmIm3PWFSphtjm6VhBH9zZz/4Yk2
         tB7GhijyTGl04kkxICmK+9E8aOZZnDdrxb94aJPFt71vStkor2i+K6yI+J8uUXzzhw
         CAAtBRtaF+XnjTkZWc2GF3PIce1yNkHT+6tf3TYUamasnYdcm1tEMBGDwGWX934eGb
         IitbYJ6kFPEQQ==
Date:   Mon, 26 Sep 2022 13:40:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to
 per-tc max SDU
Message-ID: <20220926134025.5c438a76@kernel.org>
In-Reply-To: <20220923163310.3192733-3-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
        <20220923163310.3192733-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Sep 2022 19:33:00 +0300 Vladimir Oltean wrote:
> Since the driver does not act upon the max_sdu argument, deny any other
> values except the default all-zeroes, which means that all traffic
> classes should use the same MTU as the port itself.

Don't all the driver patches make you wanna turn this into an opt-in?
What are the chances we'll catch all drivers missing the validation 
in review?
