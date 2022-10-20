Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2776E606C05
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJTXVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJTXVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:21:49 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2741D2B6D
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:21:48 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 92E81500593;
        Fri, 21 Oct 2022 02:17:38 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 92E81500593
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666307859; bh=BLYuz4cIa10HYclFlt+Z9L7PJTZSMCtgD1PJBXaTsOA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qzwGZLde2jVB7V3Xt2iXTFnRbP2Xm6mtZDK92O1Yx/rh0vc0Egm6cTeHesdER0pFc
         C4C+p7cBrKUxQjRiKTmcp/wiOH/rlGV9VQM1PpPHrKJH21L9ZQbFmQmnqB/FAw1rpg
         2V+mT1ET7oZ8BhNUJ25eX5sOZBDS1elcc4/zQtvg=
Message-ID: <20f0c5ee-2a09-7d5a-7b97-1405c2be6a82@novek.ru>
Date:   Fri, 21 Oct 2022 00:21:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v5 0/5] ptp: ocp: add support for Orolia ART-CARD
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20221020231247.7243-1-vfedorenko@novek.ru>
Content-Language: en-US
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20221020231247.7243-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.10.2022 00:12, Vadim Fedorenko wrote:
> Orolia company created alternative open source TimeCard. The hardware of
> the card provides similar to OCP's card functions, that's why the support
> is added to current driver.
> 
> The first patch in the series changes the way to store information about
> serial ports and is more like preparation.
> 
> The patches 2 to 4 introduces actual hardware support.
> 
> The last patch removes fallback from devlink flashing interface to protect
> against flashing wrong image. This became actual now as we have 2 different
> boards supported and wrong image can ruin hardware easily.
> 
> v2:
>    Address comments from Jonathan Lemon
> 
> v3:
>    Fix issue reported by kernel test robot <lkp@intel.com>
> 
> v4:
>    Fix clang build issue
> 
> v5:
>    Fix warnings and per-patch build errors
> 
> Vadim Fedorenko (5):
>    ptp: ocp: upgrade serial line information
>    ptp: ocp: add Orolia timecard support
>    ptp: ocp: add serial port of mRO50 MAC on ART card
>    ptp: ocp: expose config and temperature for ART card
>    ptp: ocp: remove flash image header check fallback
> 
>   drivers/ptp/ptp_ocp.c | 566 ++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 519 insertions(+), 47 deletions(-)
> 
Sorry for bothering, this series still has some style issues, v6 is coming.
