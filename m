Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B1B4B41E6
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiBNGWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:22:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiBNGWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:22:23 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2254E389
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:22:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644819714; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=H/fgOajawYGQ4hrV726EtzM/rvnwIVLCPSDbxxycZ8gsKgVpKeglaXcz41abHs8D9S1cl0UTWaiQbSKHDVbv4vb0a6jko8j5wc/Ah5JiQRJBbH3xjXO2dg4qrq4RMLedDdK9qPNA5nuliLEy0QvlECA/sG7f55+V6MNZQSNLBpw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1644819714; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=GtUxy4lLQG9OlQtWhyQ9FZhb+h2aCKv1ZBWFLqkahsw=; 
        b=feH4m4oxDcZk8PtTbIRx4IH8RbIwRtX2LrjgkK6wIETzmn0e+V46vEeMuzFpxojsEbS286sk/IUh+Ml0MqVdtAAH+87ZqGW9Lk1DqkG/ugW7ULapH4sEhm6iCWC909aaNyAjxd2EHq2NZLbCtVPO1UcphxCP3Kh5D/jw+clX22w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644819714;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=GtUxy4lLQG9OlQtWhyQ9FZhb+h2aCKv1ZBWFLqkahsw=;
        b=NAtVhu55pcnAlGiRX70SLT1tKKZZstKUofSeTbwchOO4VFVw8zXJ6pgvtXvk2CC2
        WPQBOS5kKxFkKWgvSuHHGjE1WPjHCwQLLUnVUdF6BUtZJTukPElYajZomHYkng9SVuL
        m8c+vxpfTLqw+RMi4MakY26EuzAK+EkWimTojdTE=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1644819709237931.1376275419315; Sun, 13 Feb 2022 22:21:49 -0800 (PST)
Message-ID: <d0e6be61-4c1f-a660-07b6-8aa0a4586a05@arinc9.com>
Date:   Mon, 14 Feb 2022 09:21:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 1/2] net: dsa: realtek: realtek-smi: clean-up
 reset
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk
References: <20220214022012.14787-1-luizluca@gmail.com>
 <20220214022012.14787-2-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220214022012.14787-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2022 05:20, Luiz Angelo Daros de Luca wrote:
> When reset GPIO was missing, the driver was still printing an info
> message and still trying to assert the reset. Although gpiod_set_value()
> will silently ignore calls with NULL gpio_desc, it is better to make it
> clear the driver might allow gpio_desc to be NULL.
> 
> The initial value for the reset pin was changed to GPIOD_OUT_LOW,
> followed by a gpiod_set_value() asserting the reset. This way, it will
> be easier to spot if and where the reset really happens.
> 
> A new "asserted RESET" message was added just after the reset is
> asserted, similar to the existing "deasserted RESET" message. Both
> messages were demoted to dbg. The code comment is not needed anymore.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç
