Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D810A585E3B
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 10:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbiGaIyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 04:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGaIyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 04:54:07 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA35AB1EF;
        Sun, 31 Jul 2022 01:54:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659257594; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=SwhoDV58nqvepP1FZQz3lBk58BugH67wtYS9Q533jp/uMQ95jx/de2mkaj+62SkIkjlgHeIiY+1xXVwbowtxMVQSMGIsLUPYArVtUwdofYo65L5mSbNliRl+N1c6lBRou/bwLNp/Ytm3XGj+hu8CzstSszG6zxYhvc7p9BAplD8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1659257594; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=e44jgZLP1HEmwyKrbQI6PjgpbbGNrnF9zlgtzzmI5E4=; 
        b=W/wQbvX1Ka30D8KO87ltRJuydbjYfjuTCwKDkTfz61x/+Bl7XNmO5VIe/ZPzFfp7gacNR4CwLADFlnl3G+TWqQ5FTuiI14dUv89nH0lXKqTYtL3wyUjnc0+9O2SPGwJNJAN6BBQr704g0DC0syC8PvXe+4JMLB8qnOgir+yQkEw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659257594;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=e44jgZLP1HEmwyKrbQI6PjgpbbGNrnF9zlgtzzmI5E4=;
        b=KjN7uqVX/myj83W3MyCfA25qyyvecseRVcrxkS1mx32RyHFQTbo8l9HQhAQFM/uO
        Yq5+jpJp0R+wLCCPeQNp9x+6pCVOz3ZvrpT7MH5fY6uz8yWp8S1pk6FQTyM/rF5JUo5
        IxTGXg/gzfU/JrU7Kwjzt3SF5UuUR/oCROgWLHRU=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1659257591946592.7858418300208; Sun, 31 Jul 2022 01:53:11 -0700 (PDT)
Message-ID: <6b29e16c-d4b8-93af-ce0f-84d308a88089@arinc9.com>
Date:   Sun, 31 Jul 2022 11:53:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] completely rework mediatek,mt7530 binding
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220730142627.29028-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is for net-next, I forgot to include it in the subject.

Arınç

On 30.07.2022 17:26, Arınç ÜNAL wrote:
> Hello.
> 
> This patch series brings complete rework of the mediatek,mt7530 binding.
> 
> The binding is checked with "make dt_binding_check
> DT_SCHEMA_FILES=mediatek,mt7530.yaml".
> 
> If anyone knows the GIC bit for interrupt for multi-chip module MT7530 in
> MT7623AI SoC, let me know. I'll add it to the examples.
> 
> If anyone got a Unielec U7623 or another MT7623AI board, please reach out.
> 
> Arınç ÜNAL (4):
>    dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
>    dt-bindings: net: dsa: mediatek,mt7530: update examples
>    dt-bindings: net: dsa: mediatek,mt7530: update binding description
>    dt-bindings: net: dsa: mediatek,mt7530: update json-schema
> 
>   .../bindings/net/dsa/mediatek,mt7530.yaml       | 1006 +++++++++++++-----
>   1 file changed, 764 insertions(+), 242 deletions(-)
> 
> 
