Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8419C496
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbgDBOod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:44:33 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:19071
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726927AbgDBOoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 10:44:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjTAHXXLstHMZRb7xdcf5AQRuTwron/973AMdHXlSleM7I6mmF6M7Vk/ggDIfRbNha+3W0V/qRdXYnGll08nSiLQwd2fH1WX85nGmLHmjj3j5jPgcFTxZXalqt5VwdIrM9orOVfR8Xr7iRs3bPLmJNZXlIfZFqt3tSluJ0eyCz1WXjlNbPmEt4GXcB09K4UjJO6p1b2URzPDl7P8EE9+7INisUwWGZJoB6VBrTTQEnJX6o3xbbDsONjPzLDFL01HQY1/u/Q4pEPckSAxPGTb9ax0kDIYiZKvrsEY6wYhj9ly8hN3NLqlAPChy9kEGxdtJxwnJL5cWhe+zRx2lkQ3vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwulQ/eypPEaHJOqvXIZmNw8VXJEFXb5KR+PxXrLmqE=;
 b=A0dAuG96ZWJXW2pltpI1+QhBu51YwVwUt0FltSAKD+YEKhIvON6jM+j8YCkhEifC4AmeEQ7Etr0xotYSjnckJAJNH7U7mQ5+Fl4jzp9B/4nPtPpeMVRcixkSwmbOh//TsV/p8E466H1pTOnc1bsmbNrKZCONM+SFV6Gx1OeTWXWGO/Uh0zHQ1pfWyNJ1XKLa6cDkDlvKltKnX2RPVQtsW/w8JyXAc66tKOJHNc1hd9DXTDc6aNd8X2TCwxEmWgXLIc01Z3NOEi1CfqiO9d1sp1M1jxQcwN1/RgQuC9c3JUXTLj0sjWPnMwHOFcxiyyXtnsmyJu/uVyC22hclI78C/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwulQ/eypPEaHJOqvXIZmNw8VXJEFXb5KR+PxXrLmqE=;
 b=jyo3dG6ufY7q2z0qkK+Rn5fyD0UdoPAiDydeP+N7MZM6mSr5HT6wZZzUkZQ6c4wxPhZJ+sVzkCgyQNAyBPKFJAIh6bgW6X/KyjRzdIZKiWdpakWJR+10gWlDei4LxSMRWb/IhJ01tPlerc/f0Sr5VDZ7XvF6fYiLAnchHI6khAQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4111.namprd11.prod.outlook.com (2603:10b6:208:138::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 2 Apr
 2020 14:44:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 14:44:28 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 08/32] staging: wfx: simplify hif_handle_tx_data()
Thread-Topic: [PATCH 08/32] staging: wfx: simplify hif_handle_tx_data()
Thread-Index: AQHWCBVUexyIf33Hc0Wntu9/9TuZnKhl0OGAgAAZXIA=
Date:   Thu, 2 Apr 2020 14:44:27 +0000
Message-ID: <2302785.6C7ODC2LYm@pc-42>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
 <20200401110405.80282-9-Jerome.Pouiller@silabs.com>
 <20200402131338.GS2001@kadam>
In-Reply-To: <20200402131338.GS2001@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [82.67.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c93d4cad-62e4-4a6d-7c7f-08d7d7145888
x-ms-traffictypediagnostic: MN2PR11MB4111:
x-microsoft-antispam-prvs: <MN2PR11MB4111168DF26CAD2705FBAC0693C60@MN2PR11MB4111.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(346002)(136003)(39850400004)(366004)(396003)(376002)(86362001)(9686003)(66574012)(64756008)(66556008)(316002)(8936002)(66946007)(6916009)(4326008)(6506007)(71200400001)(81166006)(478600001)(54906003)(91956017)(76116006)(66476007)(8676002)(33716001)(81156014)(2906002)(66446008)(26005)(186003)(5660300002)(6486002)(6512007)(39026012);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QsLfHr1tSgvLzEQL8s7gzPgqBN88QEuEmar/0C6/Zm/AfA94XE6gcFpEpJii6H24fHphFIllAptfo38ugkBvO4qYr06gaI6Qczi9CsYUjaEeCNF+e5GGQX71a1wTJ5RSO2LQ7+VPufOaPXao7Me/x/Ax+wWRpu0+rELbfouyFEIo47ZTGfcTCJqZOJZD2rXgT6RtEXPzwIKHyiZxdEVwIGIgl8LPsYsv2aj6kLx0Fc+Hvo1SpsPRXygr7k6GDngn5XrI38X+BPYbjplrX8gK9w1w47qltlbbCtTq1ivab5+OHj6SINEQ7S6y5KYEhP7DULbhLqz0nqpopcE1j9I2SIvIWulKBo34DgRdl8LC/EOgLZbOXBx8VDzLo6w31ylnPVqNItZdPsrrU80WryQ8cQajPA23HGAJRl4h5RC4rMJOFdKkobdVShHfUeLb0VfqZiCt7U9AAvrd8UkLNhBrhYj+lddZLzq/NOfAu3uCMNRicckII6HiVwmCO4H3r6CJ
x-ms-exchange-antispam-messagedata: IkXquhejaYXKoe8xG2HKfo0klBEr/1wLoKec7dre2WTMxcIFWmFM8I6sB13PcFpFNF6MJgEBbsZtnJen+oiZY2tf9u0P9xPKErAyLn3p0E1xpogMIF7O2h41xJkOiYxbLgWIGUQnC36K6grg+xVaSA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <E6DDB03D4B3FDC428B4A6E0D581CADF2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c93d4cad-62e4-4a6d-7c7f-08d7d7145888
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 14:44:27.9452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zc8MtgB8VyizDSKBT45y0FK5Jdj7b2IbftUlDGSZyoqe0bIG8kO5Jlf+Ejx4ZL2lltNZwweSClcIH0mmxd9h+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 2 April 2020 15:13:39 CEST Dan Carpenter wrote:
> On Wed, Apr 01, 2020 at 01:03:41PM +0200, Jerome Pouiller wrote:
[...]
> This is on the TX side so it's probably okay, but one problem I have
> noticed is that we do this on the RX side as well with checking that
>=20
>         if (skb->len < sizeof(struct hif_msg))
>                 return -EINVAL;
>=20
> So we could be reading beyond the end of the skb.  If we got really
> unlucky it could lead to an Oops.
>=20
> regards,
> dan carpenter
>=20
>=20
Hello Dan,

The function rx_helper() in bh.c already do some sanity checks received dat=
a:

    60          WARN(read_len < 4, "corrupted read");
    [...]
    92          } else {
    93                  computed_len =3D round_up(hif->len, 2);
    94          }
    95          if (computed_len !=3D read_len) {
    96                  dev_err(wdev->dev, "inconsistent message length: %z=
u !=3D %zu\n",
    97                          computed_len, read_len);
    98                  print_hex_dump(KERN_INFO, "hif: ", DUMP_PREFIX_OFFS=
ET, 16, 1,
    99                                 hif, read_len, true);
   100                  goto err;
   101          }


However, I can improve this code:
   - "4" should be replaced by "sizeof(struct hif_msg)" for readability=20
   - hif->len is tested through computed_len, but I am not sure to be able
     to prove that it covers all cases
   - rx_helper() should recover the error if read_len < 4

I add that on my TODO list.

--=20
J=E9r=F4me Pouiller

