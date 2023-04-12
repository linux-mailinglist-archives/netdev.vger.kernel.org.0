Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A356E6DEBDC
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDLGgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDLGgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:36:25 -0400
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F633ABC;
        Tue, 11 Apr 2023 23:36:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681281325; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=NzNsS2/s3ggnwdPWs1LT1U+940QyJQEdBkHx0dCsnjPz1KBi7d4NTZAasmT3tLnPa+Am25P2OwTCyCAKqYe+YMlHPqVRLX61kNWdj+61YxabCcwQz1GsRUAYHW8Q4Hzb47Y+JeugfaNS0TgjKa1iLS0qw+I0w6/RcVfJxqyG8dY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681281325; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LEPnkj3K1wy0jHie1VObqUDSJC9LSEQ73vz8Z00XgD0=; 
        b=NFPMMlxwi55dTwuno7s0louUyiFElGrer1GCtOs4Z1b0v3l6RfLjXZ3HJx+igRLHwDDcpoqikt/4B8E2Llb7oFwMarCR/xkytcY+bisyF1+JSVwj0cOBkowX0tcaYulepKxcYPY/PlXf46OI9v9DdB2wpPpG51ZJYY1dZe+IWZ4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681281325;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=LEPnkj3K1wy0jHie1VObqUDSJC9LSEQ73vz8Z00XgD0=;
        b=NNUBrGUY6C7wCC+qOZuWYV6rK5n64CAhWSXych0nyGxMe8E5e8P78jdNgvtPnG2P
        5i5rRZTTVGzyNA3Iu4nLT02MLqYiGwSnGFecbKpRUnIMKCzLflx1FipEtnOjChH9jr4
        pUcT9O+5qiginxdpOjCjKPOcDFRhbXkJZLrRnueM=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681281322643174.6545830352395; Tue, 11 Apr 2023 23:35:22 -0700 (PDT)
Message-ID: <781d4288-f7c6-f3e6-a132-77bff41880c7@arinc9.com>
Date:   Wed, 12 Apr 2023 09:35:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v2 net-next 06/14] net: dsa: mt7530: do not set CPU
 port interfaces to PHY_INTERFACE_MODE_NA
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-7-arinc.unal@arinc9.com>
 <20230411145416.kovyu3wb3dhtgbl4@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230411145416.kovyu3wb3dhtgbl4@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.04.2023 17:54, Vladimir Oltean wrote:
> On Fri, Apr 07, 2023 at 04:46:18PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> There is no need to set priv->p5_interface and priv->p6_interface to
>> PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup().
>>
>> As Vladimir explained, in include/linux/phy.h we have:
>>
>> Therefore, do not put 0 into a variable containing 0.
> 
> The explanation is unnecessarily long. I only provided it to make sure
> you understand.

I don't see a problem with a bit of verbosity on the patch log. It 
should make the reader understand the code path better.

Arınç
