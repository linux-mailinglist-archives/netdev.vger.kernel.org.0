Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD215640757
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiLBNBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiLBNBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:01:14 -0500
X-Greylist: delayed 2661 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 05:01:03 PST
Received: from fallback23.mail.ru (fallback23.m.smailru.net [94.100.187.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20D1C1BDB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=a4agLSq2nK+Bimy0uFUj1LWq/o2XHYIWzCneJinMJKQ=;
        t=1669986063;x=1670076063; 
        b=nrXhmDNBZ6mAR75DqulR9D8fW5m2ZgE0n01zyAstWZaXskz2//Fgf5QBk5yTeylycAetZ7783XzPqmb2TY5TwUaTU/KxbAG6FeDfDmbOjq9Nrog1w1W+yGeUsSR7KRbWyc+xmvO6Md70FFNs4kEZFTlAaIoKhERWVi9qhdNf3BVPQLoLeJU/uATy+Xmz+3PHCbD4hV+LF1jdUEPpuyyP0uxS/n2KAxFNTajuyZDBkBVGBUPj0wO5HBqLrJEEEQxG6otHsuyc8zrRAxbTEy5LE3iSbtHC9+S+Zz85Fa3oKKEfMrxMDUdcxaNw01ineHc6/MPF10F6I9m2kOuHx6yF4A==;
Received: from [10.161.55.49] (port=36912 helo=smtpng1.i.mail.ru)
        by fallback23.m.smailru.net with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1p14y8-00043R-C9; Fri, 02 Dec 2022 15:16:40 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=a4agLSq2nK+Bimy0uFUj1LWq/o2XHYIWzCneJinMJKQ=;
        t=1669983400;x=1670073400; 
        b=fODliZk2QTCU/t+XQAxiGhoSi42t6C0rIAKDdMnBUSp4XK0V9TpwH/k5XWsSAAa2irY/nKSsHNeZsU0y+mdjkjl9pDjFSsbDluafzYAZPYlPW5Ccni8l8Fz5IMGkLcQsxkEsl2Epxu7q6Lw075Rb10okRUE2P2gQg4/NGdnfRCywOIOGpIthlB354ZkX93BTLoj/IrbZPHIvQAQEMIASJsSzoxIqBl5twn+QRHdkNIDW/B2SKURp/EYfHzUhw0L7pCjQljrgu48PjINxj22JeD8Greye7NtHG/0S221QNHOjrYDFL0wDQPhTanOoMALCkr/+yxEupemodGO8c6KuDA==;
Received: by smtpng1.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1p14xr-00016t-El; Fri, 02 Dec 2022 15:16:24 +0300
Message-ID: <1edc2a6a-d827-91fc-0941-b8b8cbfdf76b@inbox.ru>
Date:   Fri, 2 Dec 2022 15:16:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>,
        Maxim Kiselev <bigunclemax@gmail.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Language: en-US
From:   Maxim Kochetkov <fido_max@inbox.ru>
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailru-Src: smtp
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD908190A22B884CF14AB7A44B281FF5933F63443C146D8F28F182A05F53808504000618ACF5AD4B194EC7AA3261833A1A40846E8131C64210EA7600C7AB265F163
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE73B44982FA5E78411EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637B5932F77F0041FFB8638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8FA4684A0A3D1ED9CF0DB8ED3B463F2F76F9789CCF6C18C3F8528715B7D10C86859CC434672EE6371117882F4460429724CE54428C33FAD305F5C1EE8F4F765FC60CDF180582EB8FBA471835C12D1D9774AD6D5ED66289B52BA9C0B312567BB23117882F44604297287769387670735207532CA1512B81981BDFBBEFFF4125B51D2E47CDBA5A96583BA9C0B312567BB231DD303D21008E29813377AFFFEAFD269A417C69337E82CC2E827F84554CEF50127C277FBC8AE2E8BA83251EDC214901ED5E8D9A59859A8B6705670C3ED6B4B0F089D37D7C0E48F6C5571747095F342E88FB05168BE4CE3AF
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D346C409ABC5F9C579B1CAD4C941656AEF2C82AA6CEA6DDC9B556650350C6D2B74CFC1EF768733904A81D7E09C32AA3244CAF2EDA455D3F04D68F80081CAD42F8DE250262A5EE9971B0F386C26F59188D24
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojdH6LJGuFcap6kYNX7PuZbw==
X-Mailru-Sender: 689FA8AB762F73933AF1F914F131DBF5320233F07347970D4759874A7AE2E6A198CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B43AA9A89F3DE39AFE7BE3AC8102694000CCF4A79C67A049F7049FFFDB7839CE9EBBAEE83B46D080CA46126CE3D395315EAF7312361A362F45010D11BF91AEF087
X-7FA49CB5: 0D63561A33F958A526EF95692E3EA414E0EC403CC7B06553007EBA8E515A9B27CACD7DF95DA8FC8BD5E8D9A59859A8B64071617579528AACCC7F00164DA146DAFE8445B8C89999728AA50765F79006370A2DD59B67EFEE27389733CBF5DBD5E9C8A9BA7A39EFB766F5D81C698A659EA7CC7F00164DA146DA9985D098DBDEAEC8D56D36E97F3F038CF6B57BC7E6449061A352F6E88A58FB86F5D81C698A659EA775ECD9A6C639B01B78DA827A17800CE78D1F1305E8F8D506731C566533BA786AA5CC5B56E945C8DA
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojdH6LJGuFcarTh69S3sYPCQ==
X-Mailru-MI: 800
X-Mras: Ok
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Please add Maxim Kiselev <bigunclemax@gmail.com> to the CC in next 
versions. Because I have no more access to T1040 SoC. Maxim can help 
with testing.

On 18.11.2022 03:01, Vladimir Oltean wrote:
> Problem statement
> ~~~~~~~~~~~~~~~~~
> 
> The on-board SERDES link between an NXP (Lynx) PCS and a PHY may not
> work, depending on whether U-Boot networking was used on that port or not.
> 
> There is no mechanism in Linux (with phylib/phylink, at least) to ensure
> that the MAC driver and the PHY driver have synchronized settings for
> in-band autoneg. It all depends on the 'managed = "in-band-status"'
> device tree property, which does not reflect a stable and unchanging
> reality, and furthermore, some (older) device trees may have this
> property missing when they shouldn't.
> 
