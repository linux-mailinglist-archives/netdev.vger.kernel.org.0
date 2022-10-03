Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE935F33EB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJCQyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJCQyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:54:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33606D128
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 09:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB2E2B811C3
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CA1C433C1;
        Mon,  3 Oct 2022 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664816080;
        bh=+v2jPWVEQ/TtazQe6m1HmphsmdFvLBLXMqWrk5tLdnI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=THTiY2eKegenbx1Le1mLA6hbj6/17iJrRkPRXUIhkLf69cXN7poaYD/adKZNzIFTz
         S1OlXxpjylDLEhRSizDKPVtJb3IxTQZVk5OuH60FUKxk9DxXuPRX3oxRHPN+J8EbzV
         bRwN2QLiZKzQmra8YrWyFEUvGFL1lHqgq35fqxe6M94gBvQU6zEM4gsniTnXJNQaHZ
         tpxPcjPKmP+uaWql8aAwOlb2djp/77tNDvhDjQovCfLsQ7VNw6fztSXwS4qr6y5gvK
         GVwsYP7oaTWfMweI3CH9WEXCCYmoy9mWh9ZmVA/M8c3wen9/GAcj8EhL6ulVPYhRMk
         HbqJTZWmt6w5Q==
Date:   Mon, 3 Oct 2022 09:54:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivek Thampi <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next v2 0/9] ptp: convert drivers to .adjfine
Message-ID: <20221003095438.404360f8@kernel.org>
In-Reply-To: <20220930204851.1910059-1-jacob.e.keller@intel.com>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 13:48:42 -0700 Jacob Keller wrote:
> Many drivers implementing PTP have not yet migrated to the new .adjfine
> frequency adjustment implementation.

On a scale of 1 to 10 - how much do you care about this being in v6.1?
