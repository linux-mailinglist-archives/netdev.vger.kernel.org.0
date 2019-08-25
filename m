Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E8B9C318
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 13:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfHYLlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 07:41:50 -0400
Received: from mx.0dd.nl ([5.2.79.48]:37930 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfHYLlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 07:41:50 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1028F5FA49;
        Sun, 25 Aug 2019 13:41:49 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="k2ujcvjx";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id C3E2C1D8CF55;
        Sun, 25 Aug 2019 13:41:48 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com C3E2C1D8CF55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566733308;
        bh=nsy8i4SCb+0PbdWowmCp7cLFbW2VLegD4UK2dhPrFDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2ujcvjx/ALRN/ixzonsCgb1tzx7N7jKGX6BmUUKe9+JBnV34DinBqys+Ri+okn96
         vnF8VeFKnCeEF1z5Dtw0eIYUVz+9hYCWufDSvqf1IbGhqlRX0vOqN+TtxFr0nCKzAg
         qbP+RCyQGeWXmNHcoTOAchZ5lDZSTlgMgAWmNqiieuUgQI59bqVXzQVrP4a4ZzPmv9
         tm1QgQTxH5TRiYaPgUKzYew4dNeGDF4UmrcuwM2qhUgU7CGWh2mcLeTHvHinCJE6x+
         Jhu8gb3pBLmWzKa6rHV8bgPyaRZkUuXEtN//8aPrs2SVcKzCSrFi7Nc08GUE0/q14l
         t+0Zw09R5xNSQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sun, 25 Aug 2019 11:41:48 +0000
Date:   Sun, 25 Aug 2019 11:41:48 +0000
Message-ID: <20190825114148.Horde.Eep_u3-9rhj5i9Itx7gh4x4@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: mediatek: Re-add support
 SGMII
References: <20190823134516.27559-1-opensource@vdorst.com>
 <20190823134516.27559-3-opensource@vdorst.com>
 <20190824092156.GD13294@shell.armlinux.org.uk>
 <20190824131117.Horde.vSCF_CQ5jCMHcSTWkh7Woxm@www.vdorst.com>
 <20190824133225.GE13294@shell.armlinux.org.uk>
In-Reply-To: <20190824133225.GE13294@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> Hi René,
>
> On Sat, Aug 24, 2019 at 01:11:17PM +0000, René van Dorst wrote:
>> Hi Russell,
>>
>> Mediatek calls it Turbo RGMII. It is a overclock version of RGMII mode.
>> It is used between first GMAC and port 6 of the mt7530 switch. Can be used
>> with
>> an internal and an external mt7530 switch.
>>
>> TRGMII speed are:
>> * mt7621: 1200Mbit
>> * mt7623: 2000Mbit and 2600Mbit.
>>
>> I think that TRGMII is only used in a fixed-link situation in combination
>> with a
>> mt7530 switch and running and maximum speed/full duplex. So reporting
>> 1000baseT_Full seems to me the right option.
>
> I think we can ignore this one for the purposes of merging this patch
> set, since this seems to be specific to this setup.  Neither 1000BaseT
> nor 1000BaseX fit very well, but we have to choose something.
>
>> PHY_INTERFACE_MODE_GMII:
>> 	  10baseT_Half
>> 	  10baseT_Full
>> 	 100baseT_Half
>> 	 100baseT_Full
>> 	1000baseT_Half
>> 	1000baseT_Full
>
> I think GMII can be connected to a PHY that can convert to 1000BaseX, so
> should probably include that here too.
>

Thanks for reviewing.
I shall add that too.

I send v4 today.

Greats,

René


> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



