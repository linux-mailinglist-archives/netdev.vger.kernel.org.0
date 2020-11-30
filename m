Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25002C8535
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgK3NcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:32:23 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:54567 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3NcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:32:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606743141; x=1638279141;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kXuxm2SFFmakayAIpg4aqjkNFYDLoM8EqLjqA71TKWg=;
  b=cTKi7nLWCNocoN1LGiBmfS5UIy62ZsYDwunkulkz1ErP87JNlAyRgDyt
   3LMWMurjcAcZAQXZY9PVWoI0pwZuv5ohR7ASw6iqfu3Gt3A3bha0n+2XG
   /BfpzKAQkjxD5yShDJRarYgT9vLQ5Y3jO4lgx8M9KAEJkwHsbyqzIYbgX
   wvsuJzHngxtCgzE8UC2qG8t08E5lzLH7x0QqgU12Zq84vMrEwstgUv581
   RIoh/lKcuZa4Y0DpTHmLRkj8iKwctA5S3w1Go6w4cIo6XKOUPAZOHFDRn
   dXAmdZUMYP2g1AgWuX4+oji4efkAVB3jkOixMLzyVpMnBqp5wIMkKeO1M
   Q==;
IronPort-SDR: kVvkgijFzEzYWPdxlzGUfFjQ0x9KmdJsuefns7SvbWBLKeZVAZWjAd92TCD8pIjHQ08031Si0d
 PRDGDbjqC/DNvPkw2jMYJaLu3i7CEZ+En3zY71dO1eFpD3qnFXlds4Lk5iSgw3FuvffWK1LDdw
 GujkOYkvrtlYrQ1ZV9W5yk/+wBKvJruaPp3Hq2jmp3EoXV4RvmsfM5WhRSJ5XhUxAh3wN7nTbY
 1Texqpa64tY7b4uA0DiJAkOY9fsOxORxBKhHrK4KCQKmVlgcemVKv2wj8wTSU3YUkwM2YZ4ejf
 hyk=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="35429844"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 06:31:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 06:31:15 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 06:31:15 -0700
Date:   Mon, 30 Nov 2020 14:31:14 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130133114.ifjtn366yanj2z3c@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201129172607.GE2234159@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201129172607.GE2234159@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2020 18:26, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +static void sparx5_hw_lock(struct sparx5 *sparx5)
>> +{
>> +     mutex_lock(&sparx5->lock);
>> +}
>> +
>> +static void sparx5_hw_unlock(struct sparx5 *sparx5)
>> +{
>> +     mutex_unlock(&sparx5->lock);
>> +}
>
>Why is this mutex special and gets a wrapper where as the other two
>don't? If there is no reason for the wrapper, please remove it.
>
>       Andrew


Hi Andrew,

There is no need for any special treatment, so I will remove the
wrapper.

BR
Steen


---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
