Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38DB628EC3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbiKOA4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiKOA4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:56:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0341C41E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E1CEB8163C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EAFC43470;
        Tue, 15 Nov 2022 00:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668473808;
        bh=G3eH9lS8et1QhtLznoav7B0T2IJCAtvgMUHZhCKn080=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oz/R1tZ19VBy9PbBX0DC8UNuJGpOHxKV52+0+Mae2aaQ3TnnmT7340Ov5EvzSQLr2
         hIBv6GSa1vy/jJeYXgZ4sd8U+EXZlcWTGajneeEUjLB773veBbiPvVz0JOgwGcTEoc
         GAYMMWBIb8Omws3WDP5PkpDBfrF2z+dTP7hI+cz+RBbrfuHsA2Z2VnaAYfrG35/lfa
         m1iRkYi4J34RVCoViVwSK2NXJIWcgacC/nUQQwD01lbdfDzz1kzZNdbXZ72ksLxQlE
         rzuquPHO1pBCcFN2nJO23f5r2SddJ2V+qS4f5VM5rbKFMGRmDVjWOgPyuuTDAV7tq1
         SZmJkXNfbmnJQ==
Date:   Mon, 14 Nov 2022 16:56:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <20221114165647.5d248c80@kernel.org>
In-Reply-To: <Y2/BeNsW4EH9v+Mv@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
        <20221109224752.17664-4-davthompson@nvidia.com>
        <Y2z9u4qCsLmx507g@lunn.ch>
        <20221111213418.6ad3b8e7@kernel.org>
        <Y29s74Qt6z56lcLB@x130.lan>
        <Y2/BeNsW4EH9v+Mv@lunn.ch>
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

On Sat, 12 Nov 2022 16:53:28 +0100 Andrew Lunn wrote:
> Do you think anybody other than your company has the ability to change
> these values? Is there useful documentation about what they do, even
> if it is under NDA? Why would somebody actually need to change them?
> 
> Is here functionally here which you don't support but the community
> might like to add?
> 
> Expressing the data in a developer friendly C structure only really
> make sense if there is a small collection of developers out there who
> have the skills, documentation and maybe equipment to actually make
> meaningful changes.

+1, even if the tables are not "FW as in compiled code" it's still 
"FW as in opaque blob". Plus if the format is well known and documented
modifying the files is not harder than changing the kernel.

I think the applicability would be much wider. I will definitely make
the WiFi people use this mechanism:

  drivers/net/wireless/realtek/rtw89/rtw8852a_table.c

ugh.

> I don't like making it harder to some clever people to hack new stuff
> into your drivers, but there are so few contributions from the
> community to your drivers that it might as well be black magic, and
> just load the values from a file.

