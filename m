Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66227634F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIWVs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:48:58 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:52241
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgIWVs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 17:48:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGk6F4i/efly3mi+H58D6N/jUHAgtp4UXVrgfEVaYMjlqmskqaxusL5ElTr6FKf39hAhedNfdHMok+Tg+LzcP+d8Rf9XxJNKeDplyrsi+TiKIl0QFNvvn7ff2I/4gobJYisTm42Zq4AdCJKw4K/zfCwAPOb92yeLZILyKjh6/RnP7PxvG/XNzXolDTj2UWpsbNYIVdYnh+rucFs+oQfElY+oCKTLEoo+ug5KQXUhcI9yGSbX0JgoownELzvusWQjMn6AmVsLYsemIxbwmBWqeAqIBcEaY83HC6s9viHUOlF4A+j0XvA4wD+fT2f9HtaTtA73DWI5DYwlTh5QuCmGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7Rf9wJ/u9yicnoJozD3UOOaVlemLcJeWt9zstcZJ5Q=;
 b=i6KCnCP3yxUvrQzWjEVWUo0l5jd5oMOilTtgw1CmiOFwaQvudox/NLn9fiSm2dNbHBCMa3mC6ep6SqBA0raP8qyXc84Jg3M0CNaExr+ESkyveqQqC5FTB+sQWoEgDCeq600SLP1QLJhs7DiXD08UgPJ1JYBoy6BFyLloO6P+WX69pacgloY2lmbWqn9I7sdgrMUi+ibfGFVmjLEvHVaclTx1Nj8DDHuc7nChm5VxeM6ghAX8mnE/T1VAhxbCezInosj55ncJ6eL8UUiMixfDhKvZoVajwPAgfTs9liirSKutmZClbgxVt0o0cQmb3AVtSllGGImO7DmuYuQtmW/KRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7Rf9wJ/u9yicnoJozD3UOOaVlemLcJeWt9zstcZJ5Q=;
 b=fPx/SlnVLvng8vPAX0xM/3LQReKfXPnvO+j2cz0wnwOUQVnRwxUrwsQ4R4bH+pUqFW9jvvB29qFpXcfFIOQPs9o3GcPJrzKllnU3SK9hPAW0dPUsKhqJ4KDIzUXrToFcrjqf/Ej6Q42UnynAnEof2px9EppCdC7aAne4aKLENhI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4815.eurprd04.prod.outlook.com (2603:10a6:803:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Wed, 23 Sep
 2020 21:48:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 21:48:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Topic: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Index: AQHWkfI49n/dW6yWhUaSsyNzEyjVval2wsIA
Date:   Wed, 23 Sep 2020 21:48:53 +0000
Message-ID: <20200923214852.x2z5gb6pzaphpfvv@skbuf>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
In-Reply-To: <20200923214038.3671566-2-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e8b2325-394f-4498-4498-08d8600a772d
x-ms-traffictypediagnostic: VI1PR04MB4815:
x-microsoft-antispam-prvs: <VI1PR04MB4815C0DA64B7FA48C4B6C7A9E0380@VI1PR04MB4815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MnxhTEl25rpGOLu1eDess8kYgq8ZdGjX3nGVF9uGVFQPUGxogyiJqHi9lJ8xED3ScBcuDKZ99A+5CpWlWSmCpnFl73qeMH69FUIxGC06bLnh6tT4vyeo0NYPO1NOmDuibTjaeXG401VVhQsgDtfKjC2XizACUd0rDUurGgxag343u0yrF5uJAioXhQ8P2L6tP9WQlDUD9tO3GsXGDAkra9LlfrrTecLSwpsSEx7sYHl8xkqBQKeSHLCUf8nG3twWrEGre/WdRy7y23g2Bw6iOxbyGXl/goGjGeP50hM5ndLTBYtg/H4rk20egJWq92Dq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(366004)(39860400002)(136003)(396003)(76116006)(66446008)(64756008)(66556008)(91956017)(66946007)(6916009)(186003)(71200400001)(86362001)(44832011)(2906002)(8936002)(6486002)(5660300002)(33716001)(1076003)(9686003)(66476007)(6512007)(316002)(6506007)(26005)(4326008)(54906003)(8676002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Z40lRxGN7O4Ye3CmCiqGOJ0bnURgC5zeGeHJxYyD6faCMUqPh3br2vkUiQFK4A0ib9/jdUY001PHH1NvRdO62mGfhhcjYVbUExxEfsmu8DKN56RvfwnS83ZdY3altIoykRymvHKyiiDZ1IP9bONCa8nKUu91p0A2iP/1+qAhDb5avyLDGJXqPrpukD63uSxD5f38zWUQQ2MKJMA3f16kgmNewG5xTlBVMW9VbkAFHFBiSLJXUksgyX/6fBKDSw6NJWGJi+/j5S0MCTHQ7LYOVmjyjg4FwPrsLNsaIOwlfG0czPQJcYqP+N3UlYBAHISr02Pb4NeSPnEibrFE62UN52WA/WrTXMFyMlN2BwQ3RtQldROFXdSQ7IrWDcRJu5XdlzCTLmH7HocV8r+uYdVF6XygK/KHhuOGYa7Ybz0shqOto3psnN53S73SfPybGMRNHR9hLBB0aqE4yc26u7StFbAg02UEXTG2e/cwISXFCG1kOiIHHI/T3ZYCfcN1HQQQ5nJnfWODaYYZJgDLDijXl0g6xTxvKEIudmu0BY9WsxPAkrq4EmQsQ6sBTiO3Zak+3MFqizTeqhmQxXRLxNk2scM45V4YDWRQ7khQXPRjs2U3StEjWwMDLY6aDIwlEgPc/oTSXN+3fa4TYbYJ5zf2Ug==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2FC9259F1F94540A8635D51D808CAB1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8b2325-394f-4498-4498-08d8600a772d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 21:48:53.6890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePZ66szs6xzjmiELNOmRPNfaRJ+I2LF7NRcVzkzM+FWRERtQx5k2ox7ukaD0O5DH/aEoO7SXNbjEJgez0O8pgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:40:37PM -0700, Florian Fainelli wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> +	/* The sad part about attempting to untag from DSA is that we
> +	 * don't know, unless we check, if the skb will end up in
> +	 * the bridge's data path - br_allowed_ingress() - or not.
> +	 * For example, there might be an 8021q upper for the
> +	 * default_pvid of the bridge, which will steal VLAN-tagged traffic
> +	 * from the bridge's data path. This is a configuration that DSA
> +	 * supports because vlan_filtering is 0. In that case, we should
> +	 * definitely keep the tag, to make sure it keeps working.
> +	 */
> +	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
> +		if (!is_vlan_dev(upper_dev))
> +			continue;
> +
> +		if (vid =3D=3D vlan_dev_vlan_id(upper_dev))
> +			return skb;
> +	}

Argh...
So I wanted to ask you how's performance with a few 8021q uppers, then I
remembered that vlan_do_receive() probably does something more efficient
here than a complete lookup, like hashing or something, then I found the
vlan_find_dev() helper function.... Sorry for not noticing it in the
first place.=
