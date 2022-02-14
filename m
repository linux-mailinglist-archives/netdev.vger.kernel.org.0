Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5E24B41ED
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiBNGWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:22:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiBNGWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:22:41 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA524F9D6
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:22:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644819740; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=DFr+pck5VB7U5jhh9llguR394gtY/8NWYMqMgn9FeQfQL12UEmXCZZWVitHOolvwhMdNsepQtzqNKvjHFH1TnfMw6iZitH19EN0hTCUYtIoCa8TSFkaBM+ICIjDT2BaLX3jZO14OenoB1opSQiXeKsD9cpBd4OFSQzUPWDAVgoA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1644819740; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=G04wLdeNJv5F+n2CHRtwL2OIVyz62Ect7sQFJNBCv90=; 
        b=I7IxEbUoVmxaj7KUlHL1MMFBcSwoQ2nZbFXbZNDunsfbHGfkVr+Rq1IARvSSL4TmHrfaXv+7aoKSfb1XvWkYrvpLAzPit27UD/x6bLAHx+NQUewAVsd4ABkwMREmUB9WZkIdthmUBozD5w3XROwIaICcu9UiueOJ7jTtCmKGPH4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644819740;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=G04wLdeNJv5F+n2CHRtwL2OIVyz62Ect7sQFJNBCv90=;
        b=NYSV0a9Xcm7pcr8UpJygGmeHe9t55Tpkk2PWIg0OCeYa2KyMt/hgmkVjwxi7+Ucf
        bmSptVu7PrJGLjo0AXMrd8KnjkmDEWDzk58V2LVbf1rQieKjuzTthi9JidBb4ToAP1h
        LdWHnC1aMGevAKkJK8roThhnyH+e5eymgb+j4Ebo=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1644819739649958.126611774819; Sun, 13 Feb 2022 22:22:19 -0800 (PST)
Message-ID: <442ca461-1c15-b97a-efba-6c3a18420331@arinc9.com>
Date:   Mon, 14 Feb 2022 09:22:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 2/2] net: dsa: realtek: realtek-mdio: reset
 before setup
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk,
        Frank Wunderlich <frank-w@public-files.de>
References: <20220214022012.14787-1-luizluca@gmail.com>
 <20220214022012.14787-3-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220214022012.14787-3-luizluca@gmail.com>
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
> Some devices, like the switch in Banana Pi BPI R64 only starts to answer
> after a HW reset. It is the same reset code from realtek-smi.
> 
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç
