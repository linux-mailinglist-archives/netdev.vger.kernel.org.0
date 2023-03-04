Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D636AA958
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 12:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCDLvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 06:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDLvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 06:51:42 -0500
X-Greylist: delayed 378 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 04 Mar 2023 03:51:41 PST
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E49E1F499
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 03:51:41 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5b2e8d56.dip0.t-ipconnect.de [91.46.141.86])
        by mail.itouring.de (Postfix) with ESMTPSA id E69F5CF1AAC;
        Sat,  4 Mar 2023 12:45:19 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 84357F01619;
        Sat,  4 Mar 2023 12:45:19 +0100 (CET)
Subject: Re: [PATCH RFC 0/6] r8169: disable ASPM during NAPI poll
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <409f580b-bf0c-e3a3-0e91-76cb499e1fcb@applied-asynchrony.com>
Date:   Sat, 4 Mar 2023 12:45:19 +0100
MIME-Version: 1.0
In-Reply-To: <af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-25 22:43, Heiner Kallweit wrote:
> This is a rework of ideas from Kai-Heng on how to avoid the known
> ASPM issues whilst still allowing for a maximum of ASPM-related power
> savings. As a prerequisite some locking is added first.
> 
> This change affects a bigger number of supported chip versions,
> therefore this series comes as RFC first for further testing.
> 
> Heiner Kallweit (6):
>    r8169: use spinlock to protect mac ocp register access
>    r8169: use spinlock to protect access to registers Config2 and Config5
>    r8169: enable cfg9346 config register access in atomic context
>    r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
>    r8169: disable ASPM during NAPI poll
>    r8169: remove ASPM restrictions now that ASPM is disabled during NAPI
>      poll
> 
>   drivers/net/ethernet/realtek/r8169_main.c | 145 +++++++++++++++-------
>   1 file changed, 100 insertions(+), 45 deletions(-)
> 

I've been running this 24/7 for a few days now without any problems, so for
the whole series:

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks!
Holger
