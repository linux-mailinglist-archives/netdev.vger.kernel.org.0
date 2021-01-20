Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DD92FD0B8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbhATMuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:50:39 -0500
Received: from esa19.fujitsucc.c3s2.iphmx.com ([216.71.158.62]:11111 "EHLO
        esa19.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388142AbhATLnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 06:43:23 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2021 06:43:20 EST
IronPort-SDR: 3vOmwnfqYghykBEl0QPALWkkECE3KncNKTqTEC8tAcKGPSYtzmsKGvHhs4eG5vxIpx4VdBvNnA
 raHUaE4NXAFQSROdu8R3bp0QUa297P+A9tsJ/EAiN2Mn0BvHRdS0y86vwU4OuKOR/MCrEzVIL8
 QhnxAnPH9/+tM+FgqlxHRawWcKzTxpzEHx5CXO1x57F6+vWYhgKfriKoG4tE5bCVAb1vX66iQE
 QoqZdUARsiP0l7bXACYIkEhiKpjxiLWDZvbXgY/38PIxqbmvmXTnJV7bBr5PSxRwLUfWkHC1rv
 dQc=
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="24462664"
X-IronPort-AV: E=Sophos;i="5.79,361,1602514800"; 
   d="scan'208";a="24462664"
Received: from mail-os2jpn01lp2054.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.54])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 20:33:02 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaG0hqIzL7oDHzL621Xod9lVBsypC7rLOiVByEozyqs/3Hboh4uWCSR3jLFHOV0bV4XAN1pzOCkX3462bqCzkoVq9CFFXG6TkU9vPzSQIbdU103UE37QaV07Rl95I5TGtfMDYZ5ugHmdiVqfE8RWvwrD23hMjj4lxGm4DDH54WhAvFyWBb0M52IQRuXtZjyd9kzaWeOgefGngLqB9ihGwoXBsggdPcxbBZuWovdQh4gYKkv2kmpZF5bpiXrn8g3a/jUimu+PzQbU9t93z7/JqYSZCGi3eKsYnHp3CGiMBxrMnzAKuKCcOkM4zakZ8vRE+IitSWRmnEBrLAyHU+ZDZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuDNAG2SNID/Gf32oFDZgOSRSGbBMbJaWl6GU4k6etE=;
 b=VqV4QFPSIuWusYuGvfuoLSAVBM8H9lfEFd3Z8irbLT4KN9xc02fYlAPfauCX5UzMdXgzTAMPBwDOH+3DY1PIakw72QFtViBTGEJ7XiOQwyI+sxBExrBmNHdliGa/BjAwZd5QmWUO2Dfuwss5JnVsMpH3NvVwC/u5A5R3785cRYDYH0rZ5BOXI6HI7H8LmP3NoYmxGhfdlBC9ukkNVD6h7EzLbUYLph4RVQYFdtWE91F+kC9hISFDmxL/Ke7nEqG6rOBsq8ItgETa9DSEGgAuHEFb5D11K8FSspR/qxdyRWyml5XaSB7yRvxckjWezV3AKEBIQinJufudIAvaAhd+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuDNAG2SNID/Gf32oFDZgOSRSGbBMbJaWl6GU4k6etE=;
 b=VY0YZz6KZdgWJKVHBzs+yPLbXieAO8JgPu98wYv1d73NhXz2sJbNJQJ2VXYK8b+nYCdpE/g4Z5+yWZu/XP4f4QgjgzStyNdOjxXFR4bDZwxAKB+JAKuqzXZ6U0IquzHjc56QbqxNMnZpNqzwQwK6hBfH0ET6LDTrV66xkS4OniI=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSAPR01MB3842.jpnprd01.prod.outlook.com (2603:1096:604:52::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 20 Jan
 2021 11:32:59 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd%3]) with mapi id 15.20.3784.012; Wed, 20 Jan 2021
 11:32:59 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Andrew Lunn' <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: RE: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Topic: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Index: AQHW5y31ARgi0NV/wE25+9nETrMkFKohCyYAgAXFg4CAAPQjgIAADo6QgAdSwACAAUiG4A==
Date:   Wed, 20 Jan 2021 11:32:59 +0000
Message-ID: <OSAPR01MB3844ECB7B38EBDFF6F27E9FCDFA20@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
 <OSAPR01MB38441EE1695CCAD1FE3476DEDFA80@OSAPR01MB3844.jpnprd01.prod.outlook.com>
 <YADN77NvrpnZYUVo@lunn.ch>
 <OSAPR01MB3844F07254AB8B1164086D7FDFA40@OSAPR01MB3844.jpnprd01.prod.outlook.com>
 <YAb+zI71+d67mlwz@lunn.ch>
In-Reply-To: <YAb+zI71+d67mlwz@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 539223316d37414fa5b07729036270ca
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [218.44.52.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f56dcc54-ab8d-4934-709f-08d8bd3723d3
x-ms-traffictypediagnostic: OSAPR01MB3842:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB38428CB81AD6F54816E5EB3EDFA20@OSAPR01MB3842.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o+7bndWIvrN6VX7BLVO3TdNTKzMEa2aca3GaP06p8j+oi7jgab/aJSML7w/G0wWcz/ivu84gm7anFyOB7Jyqyuzn4jOTp4R+c8/zACRS2WDYEz7UvgNxarVR2JpnqhLVN9kWi42jH7L9A8NpQuyWXs4OnEw4DdAOdvCGKxBjkZwNp6AFQqEWtXftmxCkN9krJBn1I6E1SQ6AJrNO6jVIh07oT4rZvzrqoqbxdbZg11TgrGj2k7gU6BG5FB8mVLOJF/Aqfk3vfwNL4bGmZT7EeQY/OPVv6fEzXwrEaqR7abUzMlv0on5H1n4tnS5oeCjrX3FeWMX/bEoWF8U4p/GjO5AnihiBMPt8V++obCrreoQf4vQMzpiPsaS1UeTw1LkgGJvNQHenMTPxEAcPh7hFHRF/Fs+CGyowXK/BA25fDtG/CI6i4DvDPk4yydIdn+S4/nYpJGV9PYVa6ZaxwYIeRdIB8pIxdUCTfeLQ/m2Ti39pUEXYrAWFBwDJzjpQbvpV8Rndmh1Mq6WrztEJLpfoKoq+/O1yRKOMcH2GaQIp+ZMUcmC0LCEmVB+bZgfoabY+UQk18TusAAAsvYA3yRWQlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(64756008)(52536014)(478600001)(76116006)(6916009)(86362001)(8936002)(6506007)(55016002)(71200400001)(4326008)(7696005)(316002)(66476007)(66446008)(186003)(66946007)(5660300002)(9686003)(107886003)(85182001)(26005)(54906003)(2906002)(33656002)(8676002)(66556008)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?ZXI4WTNreGxVWHdWRXhFTnczU2tPL2lSTjV2NDA2ZGF2amczWmMzdXRN?=
 =?iso-2022-jp?B?Z0VzMHdTaWw2cGpRUEgxNWpIL2tNeXJlT1RhWG00ZVRwKythdWxqQk94?=
 =?iso-2022-jp?B?dFNmdlJoMzErYkpPRXNsWTY1R2sxNHhkRzRoY2NvWGJWRWdiaS90dS9Y?=
 =?iso-2022-jp?B?TlZEcGRlK1RhRCtSZ1NTOEdYdjAzbGg5bmd3aWs0eDJEcWpoUkRvZS9F?=
 =?iso-2022-jp?B?b2xlaUdUREFQZ0hBRkREUFFHUXU3b1ljKzRqN01XTUlJWDZFWkFxTHRB?=
 =?iso-2022-jp?B?SmhxSkJDeXpvTXJMSnEyak9FY2hJYXFkZVF6bXBIS2FtUWJSUXRreTZO?=
 =?iso-2022-jp?B?c3JzYVY4bmVHV1d5Kyt2MzZaUk1RWFplNGorYmRHVzBGR0FwMnpNYTRr?=
 =?iso-2022-jp?B?Y1BvT3ZSOVV0NzVvaENqYUNyRXJiS0FCUGM1ODlEZ1NNN0FiVTZLS2da?=
 =?iso-2022-jp?B?bTh3U1dJOXV0Ukg1S0ZiTXJsa1VCd1UxZmpmMmxiUXZYaFIxU3RnMUhB?=
 =?iso-2022-jp?B?TitqanZyQytSR3piS21DaWFIWndmeUhOdUVYVk9NOXVyWTM3T0Y3TTl1?=
 =?iso-2022-jp?B?ZUhyZkpXZURNM0VGQ2QyUzJyQ1ovVkR4ckhhYkl1aVgyY3BOTzA0cnI2?=
 =?iso-2022-jp?B?SmtrSlBMWVpMV0FyTTN1aG50Um9pMlJkbWhmTHg1eTF3U1FPNXNZVFdH?=
 =?iso-2022-jp?B?YlFiMWxXVWVsYXF1d0V2ZU9QZWExclJsYzk1ZXZRdXE0b0EzbU53a2l1?=
 =?iso-2022-jp?B?d0FRWHc4ejRDWERSbkp3a2M2R1BuWlRHQkxtd21FQXdLOTQyTjRVYkpL?=
 =?iso-2022-jp?B?TEdTSzVQS0RaY0RVZ0Y2bWx2S1dZNXMxWHZtR1YyblVlNDQzeVVKcTFG?=
 =?iso-2022-jp?B?NG1yQVRjNVhobWk0b3NMN3A3bFg0RmhpNThGSHliMHJ1Rk1jaW1mbnp5?=
 =?iso-2022-jp?B?dDkxdTRGL05HYjdWZUx0T2dpai9mSGNsdm40Q0dqUnhaMDRkVnpvemJn?=
 =?iso-2022-jp?B?dnJPeXBjb1A4MVNCZ2JDRjlqaUQvVnhQWkIxV0J1Nkl3bXNyaTNmWDYw?=
 =?iso-2022-jp?B?Zjc5YnlLbG1RN2g3MHhpT1k0Q3E4WmxCNFc4ekY1aE4zN1B1M2svNHhV?=
 =?iso-2022-jp?B?QzNJYUNOcnVTZ29VQUdaeENCQitzblFwN0d0UlBRdHk2YjltMlhEa01y?=
 =?iso-2022-jp?B?c21hTHFwdWxRb2hhLzhSVTVOdWR3aVJ4a0lFdk9pZ2dNaExRN1hrODll?=
 =?iso-2022-jp?B?WllpVm9rT2lsWmRkWEtHLzlEWDJvby9aaDZxczNWOGwreXFqWG9QNlBm?=
 =?iso-2022-jp?B?ZXRJSVBteUN4ZGtuUVY1ZllRMDlEbEZkSUNiMUtvRStWZ1E5N0lEaW41?=
 =?iso-2022-jp?B?alIwaG5oUnBoaTVwTk1hNzMxQS9KQ3lML3dwQXZGNjkrZ1J0cz0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56dcc54-ab8d-4934-709f-08d8bd3723d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 11:32:59.4415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iZRv4Y0Tdf5UwID3NxDp5hl4njYye9Jp1kVGX14buCC6wXJ1saN941i0Rj/5H7KInwIUmxZALq9Zsl06XrfTOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3842
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

> The parameter is called 'forced-slave'. See the man page:

Umm...
# ./ethtool --help
        ethtool [ FLAGS ] -s|--change DEVNAME   Change generic options
                [ speed %d ]
                [ duplex half|full ]
                [ port tp|aui|bnc|mii|fibre|da ]
                [ mdix auto|on|off ]
                [ autoneg on|off ]
                [ advertise %x[/%x] | mode on|off ... [--] ]
                [ phyad %d ]
                [ xcvr internal|external ]
                [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]
                [ sopass %x:%x:%x:%x:%x:%x ]
                [ msglvl %d[/%d] | type on|off ... [--] ]
                [ master-slave master-preferred|slave-preferred|master-forc=
e|slave-force ]
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^
The help for the ethtool command seems to be wrong...

> sudo ethtool -s eth10 master-slave forced-master
> netlink error: master/slave configuration not supported by device
> (offset 36)
> netlink error: Operation not supported

It seems to work. Thanks!

# ./ethtool -s eth1 master-slave forced-slave
[36173.937680] rtl9000a_config_aneg: master_slave_set=3D5
[36173.942891] rtl9000a_config_aneg: phy_modify_changed()=3D1
[36174.008502] libphy: genphy_setup_forced: speed=3D100, duplex=3D1
[36174.014283] rtl9000a_config_aneg: ret=3D0
[36174.018513] rtl9000a_read_status: PHYCR=3D0x0000
[36174.023074] rtl9000a_read_status: PHYSR1=3D0x0000
[36174.027653] ravb e6800000.ethernet eth1: Link is Down
[36174.033116] rtl9000a_read_status: PHYCR=3D0x0000
[36174.037702] rtl9000a_read_status: PHYSR1=3D0x0000

I will test it for a while, and if there is no problem, I will post the 3rd=
 patch.
