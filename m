Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8E5BADD7
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiIPNKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiIPNKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:10:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E9A14087;
        Fri, 16 Sep 2022 06:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663333800; x=1694869800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MHDkilMZBahsC0iu+4XnzrUwjVCOqdGN/PrWjn8K/7M=;
  b=EKrpx+XsYtydePs0Xk8NwEJ1JK8ipAmrhpoDm584h0/jDD2LIkzMf16d
   ZVwB6Q7hEPdHQkdYvuyjO1D5kC8r0clfkIca9bSzvKRZdp1wB5C+zCkfP
   N9z0dvuz52aHMgoOeyAqeNTa6Wplu0Yyq+c/16t9bVbp6Eb2kx24MfxtQ
   Es43dqEVuF3T7YtdPFw/CHfhghCd4CFlRgkkHtxfauTqScm3oNuL6W1/d
   OdeMSOJFAkziSnqveZ0Gqt49CZgBugERQVvgRe9KPq1mg+sjaVgd1g4Rb
   49gyAgzRwX1Tap8odzoMhDkaZnMhbIbVhptWznPiSrQgCwXny/+ceqP0w
   A==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="180804273"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 06:09:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 06:09:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 16 Sep 2022 06:09:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScZbFw9BBAK9z0gk7L0V/mlmROkjcqTcpB5AI8/JQ/jE4dUrCbKmvNkrQ5dYsx3tvSlbBVYFCcw1l4AUfAstclMCZX8vluT/UtLWU/1w5CdfzsXFVbPSPrejtIUxPWeN5rxUlIdnqWa8CDVZGv5GAXrmyHZ/5As9RD0LadszttWoEVb9MfOWpB6x8StgB53ptf/pxAOkRUidCJnvzArpbJpLH/kK7kBHbdhmz0kSicIlGeaS7+/v641RlkPwwKWEUFd1bdaYsNy/DT+ZPP3HSq/vebUwYSlfxy2Q5oKJMsJleuo7Njaw2+yP5qBp3htFhx7spXekN+ucJR76tOPlOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lo/en7Of7SCIkHpdbhrOhvjwT2Extmtyg7yMOX/RUJs=;
 b=iNsuzUrV84x+nboTJfWP5ZerrVnQ5Joxequkwqibd8Ju/W1mlx3EPCuj1Ar2i25rivCKqr45G06OfeRJAAzh1SVNYbSuyRDA8iejFjjPuPLMOmQUNvnaNhQInSwTOvJ3eZ1DbAvi2F+6fxPwyXnYA8YvrgzeiXyYSEqvEyjAYYtEY80lPYiTOxgZGf6GWwUZkBxh1gmPB25eAyVt1TbV1HYZsSJUrR14jSY4Aq8oUHptcTCid9oUQ1aZXGFoZ4dn2YqgAPi28exK+NFq8simjzriOlpuo0JdCaSBlvk2d68SGxz4t8ciOpc8AbDzrkATNDgMyc3G/uJFUGhQSPPZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lo/en7Of7SCIkHpdbhrOhvjwT2Extmtyg7yMOX/RUJs=;
 b=ktynIaWGZ89+aEon0ylp1w9RgEMgpmpoV2zsdbuOdkT5RAUy3bgwSk4mk5ARjfduKj+Dne5tX6gioWmYnkifFv5s9VjvYN945NtPu/qxh7GptFPIyE0K5qCes9xpoxaIWFLJmvfMN5180ghzFMy0fBwEqgFdtNpyhv2gcc1PNpo=
Received: from BYAPR11MB3366.namprd11.prod.outlook.com (2603:10b6:a03:7f::20)
 by LV2PR11MB5998.namprd11.prod.outlook.com (2603:10b6:408:17e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 13:09:29 +0000
Received: from BYAPR11MB3366.namprd11.prod.outlook.com
 ([fe80::1529:627b:6c3f:175a]) by BYAPR11MB3366.namprd11.prod.outlook.com
 ([fe80::1529:627b:6c3f:175a%4]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 13:09:29 +0000
From:   <Raju.Lakkaraju@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: RE: [PATCH net-next 2/2] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Thread-Topic: [PATCH net-next 2/2] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Thread-Index: AQHYyaW1cMOGxr+iYUuWfbARJxPCXK3h+YMAgAANUBA=
Date:   Fri, 16 Sep 2022 13:09:29 +0000
Message-ID: <BYAPR11MB3366118DE832C411F463368F9F489@BYAPR11MB3366.namprd11.prod.outlook.com>
References: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
 <20220916082327.370579-3-Raju.Lakkaraju@microchip.com>
 <YyRpij7ahB0cqWyy@lunn.ch>
In-Reply-To: <YyRpij7ahB0cqWyy@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3366:EE_|LV2PR11MB5998:EE_
x-ms-office365-filtering-correlation-id: 206b14b7-09e5-4181-aaab-08da97e4b085
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CJie1q/Kwct3v81iNrbKrl2hBoh1cwMqP3RM3D86FD5b9ZcLK+kQdpoV4LRALH27emI3Biudyak/Rce4hgYj/RVTAoESkC7wCYieuAwaf4jQNWqgRPZsFUvFPF3YZq+x2/OUWqlPorb3FyRnkBWiNRVgXeaMZeXvK5QAMzWdWvS1iFHL1Oto0dughN5UfGMnqMm54cNcLYI79Cjg/DMA8jQUThqQWXABlOzsVLi+e8Fe7eaDzFeBJreq0SnVlcmk9Oi71E6DKAb+DfFym4dmuSiWMblhQCCLit0wPqkz3i390qpFQ3eSIR8Ze0Jywuq9Osz03YLQirWI3N6cOeZxhJpdBYieXqrXmnHGv0EnbkJ4TSZ+Pl4oLwAZNGSMfBtQFg1UaxdVMExSR2tED3LONDTVwrxDWtTVF0Sk+g6Ex8o89fRhU8/iNeyUWqDgN1Bw4cYq219ZdVaCPyNAus7y86qD/jA6JC9wSWxWkuTKFZUQdWMnYi3Gvp4mwyhdqrxHr2dWQ2hKSkq57wyre0IboGTY4FDww6Z4Id13i48Ixk+1sQFN4bERqIXQUjvRRXb9Xi1ag7I1mVMyxc0fZcOABidQ4JQzb2BXZRdvPztFjn0YMwh8ReW9YeXODywLI4h7jg4TgsW8QVoNsGtsUqkW4R2WrL9hraziB1qhyg+a9WEPiVNOMfrnKHkdpYRo3DDXDBOoykX9MoZcwAbsPTfhWWk3jf7+XoBDPVbf4HWJLtR8/nLfYQlBaNRaQE5g2gnfQUn6x990DqH2aEMNnX7vEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199015)(4326008)(52536014)(55016003)(26005)(76116006)(122000001)(54906003)(107886003)(86362001)(66446008)(66556008)(5660300002)(8676002)(316002)(66476007)(478600001)(38070700005)(7696005)(8936002)(53546011)(64756008)(6506007)(186003)(83380400001)(66946007)(9686003)(41300700001)(71200400001)(6916009)(38100700002)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ntck9L8WU/LFdC6rmuk70PO4Yh6LK+8vBJwBFcuHLejGZwdipeVKkrE2sId3?=
 =?us-ascii?Q?cBTjwL7HahfbYRTsaWoYqk8JgqDf/Y+yTi6xZPYHbykqgOMUXbAUAxxeThf8?=
 =?us-ascii?Q?yvyLFId+N1poyo76SooKri198oQV1aOOjNYpB6MTZCXctXbRGnK4DBRuO3S9?=
 =?us-ascii?Q?GbkILRQRqn7wWuOonVuX8qWCf8NHacOUHp4T1k2sJdQ+yOedDBO1Mp7lA613?=
 =?us-ascii?Q?q1IsSMs9u5W4GKRsfLPEZSuKZu3Ig0QfcJph1nJFvLa4JAtz2k488TJR1Xol?=
 =?us-ascii?Q?pi9fRCEmCqDgErJZvgOjk51lgLMV70rGfftfvKCTD8auRRry4oAFUa+sWRcr?=
 =?us-ascii?Q?gOJ3ervXeBT0oAXGMB00kby93KC4PNauMVT5NpKn7KWI+BgHeWSWy0MULrrB?=
 =?us-ascii?Q?+030pkQlq+K5wIVmNewNfwFy0pj1C4n1vXCfG84JSTnNZL5aSG3woRAwn2x+?=
 =?us-ascii?Q?y3WDNeer9ozq6VAiwpQxcWlq/rvKGMrc0Av9baB6Sl5Ebl0wfc46xC/2zzTu?=
 =?us-ascii?Q?1ivcOJCFBejd90wSVPhbEEWI0maq4ucKBFC+Q2C+S1G4XqCs6/x2OzTVmksy?=
 =?us-ascii?Q?FsUSTqbaKyoPltgmgBu6o+s9jpYIKOYhU4W0TRXgTQ2CzmRaIUL/B5JqL6Mp?=
 =?us-ascii?Q?kFK/LsWUodYe1+RebkJmZm0xeo2UZU57g/yillVy7eeGJDR2+NDiUaMcvKwN?=
 =?us-ascii?Q?Y8ACDnF+qQI1tcUmA5/l6Pf5EslGSiIBqr33lZ9PYPUSyNRv3alvGdoz6UGS?=
 =?us-ascii?Q?lCgSfeugkfsa1vrIAR0M+yZngd/tE84/tmmAqJ/9o7zrVY7rZrjQz47DM9qD?=
 =?us-ascii?Q?CcWecgjbZE3T0ECmNR1OZib8nHjW7NwgA5I4OZLmVqoHOHTAYJLDfKdpJ1Mq?=
 =?us-ascii?Q?ZCQozrDbAMhEf3mSF7BSOHEX10zbLF38bGAPcDERzylCe8UVLJcYG+g8UI6j?=
 =?us-ascii?Q?YaStWgdiEKXuVuDCsjKdMarsnhL1IXD8/6Zv1eUuBuw95JsApCeqrkZON5lH?=
 =?us-ascii?Q?6K922lcOGvki1B+V+0pbOUA3guC3Bpo5+vRuhWwT+a7QRNOZIW+spl8ZY1iM?=
 =?us-ascii?Q?5hQdAWy/7jD+B2oPdKhl/7JPXExL3HtgGYlmhQxfGgo/zMmcq+cRgYtHN3T5?=
 =?us-ascii?Q?IHYE9uoM/gsP/ZdC3+tnhlxRXJwPeG7MT9JEX2jIT+0j3J9qAr05uGg1D4Bx?=
 =?us-ascii?Q?M+CHN/CPr6umbU6RIbRdZP2wXKGtsY3oc72Nn65iJCgo8Jc4RpvgVwEKEHmh?=
 =?us-ascii?Q?IRyYk9XufzII8OxCU+EhYu6PhCIqMOtu+3f0Sma5F4CXaeWORWstj81JqypD?=
 =?us-ascii?Q?RY2Rgx0bbSl1oYY8aCrzykOiDBRzxvhIaiV0ocePnFgOBPCT8w2i08eCGj0s?=
 =?us-ascii?Q?1fcLF6A06dxi21vhpcoDXXWGtsFRqY/vXrjsQMiGO6cOyGp9kWu/ndYIkxS+?=
 =?us-ascii?Q?BSgHb0XOh2QZiP7S5Cnh9l+n6f7Q8T5CZbruAObgy2oN0v39H+61tWttGKuD?=
 =?us-ascii?Q?aX+ysCCJq0OfKDLxdyRskUB2GDKJGdF3O5qt7kOrVhi/w2mmyavdnVAiPUGq?=
 =?us-ascii?Q?gPDnSskmCPN1YdgMSd5d2vgroB2MvM3oerYIIQPYjZQdXOPiSOQ7UDXt60cq?=
 =?us-ascii?Q?Yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206b14b7-09e5-4181-aaab-08da97e4b085
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 13:09:29.5609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fSLl+IFWQjUH6kg4N/O41Z76yw3xpWqM4jgZmM9gz+fgyagDUSFX5QWQxKrPIuVCWms9Nzb1HUsWiU6h10ODLsO4MfC9p+t5aCQy5owVhPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5998
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for quick review comments.
By mistake I sent the wrong file.

Already V1 patch posted with fix.
i.e
[PATCH net-next V1 2/2] net: lan743x: Add support to SGMII register dump fo=
r PCI11010/PCI11414 chips

Thanks,
Raju

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: 16 September 2022 05:48 PM
To: Raju Lakkaraju - I30499 <Raju.Lakkaraju@microchip.com>
Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; linux-ker=
nel@vger.kernel.org; Bryan Whitehead - C21958 <Bryan.Whitehead@microchip.co=
m>; lxu@maxlinear.com; richardcochran@gmail.com; UNGLinuxDriver <UNGLinuxDr=
iver@microchip.com>; Ian Saturley - M21209 <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: lan743x: Add support to SGMII regist=
er dump for PCI11010/PCI11414 chips

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On Fri, Sep 16, 2022 at 01:53:27PM +0530, Raju Lakkaraju wrote:
> Add support to SGMII register dump

> +static void lan743x_get_pauseparam(struct net_device *dev,
> +                                struct ethtool_pauseparam *pause) {
> +     struct lan743x_adapter *adapter =3D netdev_priv(dev);
> +
> +//   pause->autoneg =3D adapter->pause_autoneg;
> +     pause->tx_pause =3D adapter->pause_tx;
> +     pause->rx_pause =3D adapter->pause_rx; }
> +
> +static int lan743x_set_pauseparam(struct net_device *dev,
> +                               struct ethtool_pauseparam *pause) {
> +     struct lan743x_adapter *adapter =3D netdev_priv(dev);
> +     struct phy_device *phydev =3D dev->phydev;
> +
> +     if (pause->autoneg)
> +             return -EINVAL;
> +
> +     if (!phydev)
> +             return -EINVAL;
> +
> +     if (!phy_validate_pause(phydev, pause))
> +             return -EINVAL;
> +
> +     //adapter->pause_auto =3D pause->autoneg;
> +     adapter->pause_rx   =3D pause->rx_pause;
> +     adapter->pause_tx   =3D pause->tx_pause;
> +
> +     phy_set_asym_pause(phydev, pause->rx_pause, pause->tx_pause);
> +
> +     return 0;
>  }

This is not part of register dumping...

> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -25,6 +25,22 @@
>  #define PCS_POWER_STATE_DOWN 0x6
>  #define PCS_POWER_STATE_UP   0x4
>
> +static int lan743x_sgmii_read(struct lan743x_adapter *adapter,
> +                           u8 mmd, u16 addr); int=20
> +lan743x_sgmii_dump_read(struct lan743x_adapter *adapter,
> +                         u8 dev, u16 adr) {
> +     int ret;
> +
> +     ret =3D lan743x_sgmii_read(adapter, dev, adr);
> +     if (ret < 0) {
> +             pr_warn("SGMII read fail\n");

Better to use netdev_warn(), so we know which devices has read problems.

        Andrew
