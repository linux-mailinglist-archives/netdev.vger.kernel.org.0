Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C9834D5C0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhC2RIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:40 -0400
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:42573
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229861AbhC2RI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:08:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJewiduDTuM+m11a4CyE9bURaQhNnrs5ZuyuxGiNuI7xQtgaYHo/X5HkdRR+8nqPS09Utd+AHRIOGci3gDikyyf7wTC92qkpIB+TirVzXLFJAsmIUPIg+7u+5SXKDsnkwWeGx1WEQ0Qjlpf6UwsEQ+/wkFiN8DPGYD4bXYZAtQpYnd4hULUZJljsp+OlLiNPoXYOdfMquIgaczxgIahyOOAsUCIq12cq/JqMcXlMJzYKohwqfb+pVTnfZ3ANmVm3wASwW2vTkVfFPTsQgnBr6pVvdv/RrJ31DCj+QFIwZLqVW5peHbjOHbghvJaeKRfLdpL3txZCqHlN55s7NqHjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtqidI23H82GJK2oparq50hfnvni1h9YKQIElCS9D2Y=;
 b=Ds0x6+c3Of+uQivQ4oF6JLranvBnRfXXQjK0rI9n57yFcjAC/VCbTSGRvSQ9HqCmGs2NzZ1EeLToODzg7TXiLUX2YyR32jlOKXjjI1t5wZDZHU75mjDAWSl5ZMeUqd2l3XgV2Eu8Af/6C91QB+ZdENpuiMt9I0XAwydPCIilLhG1YaovmBKN9rWK2NyuxtjT2UjoKKVnh6mDBdRtar1FKsWhwn7CWarolSTkD/Dy4nYCpoxk/Y+9DxWQRnaGRV6zO8iF9QXhyaizhr6XypGAJN1aP9/nVvogYfSDse5mOG1TqAGbDz5IRgO3GoNzonwk99ANLydjO9QQ1cnuGNAT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtqidI23H82GJK2oparq50hfnvni1h9YKQIElCS9D2Y=;
 b=pCFHYg5GQnSu46MMhOd8oS3bctF+xUkqvPhDpOVzharqnJjadNyBVavLaMlKgFkXcuR1UHaXeLPAATbHn3REWQJtBOqB/aNMMYNgHaHy20e9xabGinbBFdLFgmncu8kkXc2sc3FcoWItlr0aQNGjjfw5RYo2QRHgNthkGF9uOz0=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3620.eurprd04.prod.outlook.com (2603:10a6:208:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Mon, 29 Mar
 2021 17:08:24 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 17:08:24 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net v2] enetc: Avoid implicit sign extension
Thread-Topic: [PATCH net v2] enetc: Avoid implicit sign extension
Thread-Index: AQHXJKXlvXw8eFWduUG66oHlVlkCGaqbJqcAgAAIGFA=
Date:   Mon, 29 Mar 2021 17:08:23 +0000
Message-ID: <AM0PR04MB6754458AFCA2834FEAC852E4967E9@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210329141443.23245-1-claudiu.manoil@nxp.com>
 <20210329162421.k5ltz2tkufsueyds@skbuf>
In-Reply-To: <20210329162421.k5ltz2tkufsueyds@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.216.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c272972-0550-409a-05d5-08d8f2d5431c
x-ms-traffictypediagnostic: AM0PR0402MB3620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB36209DF5F24E6F6F242ED96D967E9@AM0PR0402MB3620.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oGZ+zX7jheUa/uQJ1L1zgwMXQEctzsXlBkSkI/CzsLuunnjHixEAtiKik9HfoLABhmeWdpUKYwHF1B+opO8bTOCoO/atyOav0z4zbBTcL/JgMp8tw6t/gNEuUupbpJOHLpg+/bCe6g8PMKuHowrBMwv5s4YK9bKjxVCiWhf/VYhhyRXIxF8UCx18tVLb9H3omV6crVBUk9XL6vWaV46I/uiYSG11KnrC6Ubi7Cl2mCw/zdbAyz39fer7T/pz5wrkbeQA7q0GLF6kMWQh5rSKGQrrk7l0cpSD/QkuNEfm/8JsxdcS8hrECDmWpO0CSK8UyhqXC3gQ7WAilFR5q5VRC9GcW8FXyNLIF6fJH5lHwkQandXurL6AGmvHvrfG4bel/+6Z2nDwAQCoDWvfvDteGsTIuGEupo9xcRU+TOK5ZnTGn4ReK4SEcW/YTz6Tav+ue2sXPCscMDPTsB7HhgzINmyD5nAnwzvnSdmcel+77seuv3n69ecsBQu7Dl1sf3Xo5gjdp7iYlpva936zC1i++QUwQeqBxPw+FkIvailObKVhneUIyzPLPbqlK8Q9OiqHtjsxaFpKB7dSaK5lJntPVfb0dOKRXxShOsQhDFCYfnmjjNQEaqBQEraJOD+YVeqK1yDa7iBk+4KVmVB3vW/QfxCnOnlHxvjGHXyhIbsnwfM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(44832011)(9686003)(6506007)(6636002)(5660300002)(71200400001)(186003)(26005)(4326008)(55016002)(316002)(52536014)(478600001)(7696005)(66946007)(8936002)(54906003)(2906002)(8676002)(66476007)(64756008)(83380400001)(33656002)(86362001)(66446008)(38100700001)(6862004)(66556008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4s3f1w/DQZf5JnN4jKFTLdkOWl+ybi0rRRFgb/uohBIQCshbSR9pf6xay2UH?=
 =?us-ascii?Q?2/00MHpa821f35hchs40HQQLPt7eIV4ybXPy2rgSqZsdhNJVfsHGvbeXU/9k?=
 =?us-ascii?Q?k61+6A9fcXWHNKUkjrNCUE2dG4nsdHCwUHVhJJW/7pqzi0IogXRHUgevcNDd?=
 =?us-ascii?Q?bLtji8DSUx34NerbKzUTUVRFo/ob2QHgLFqWI9phxp8eV9017auCk+YUApFx?=
 =?us-ascii?Q?vd8BfD5t6CMR04gXpyOcyavYRYQn4pF9BZGORAgOaXH4JQafCmrrVG9jmdAD?=
 =?us-ascii?Q?o4FiWfVNnJ3aqiLdFoFl0XouZH+mYZUO+M9XLtXjoQEmDzec53f2Vkw6KIDH?=
 =?us-ascii?Q?WHXVrO3uYNfn9SON/JZdO1Iid1ZPiVJ1YhFtdSjy0GqmdXbrIXvE3Dl4pWtv?=
 =?us-ascii?Q?uMmj7GsNSOj5sfEv/fcuFR0i6eiTgDzV/14Unijr9cO5Z+QXe6GOAMIXekQT?=
 =?us-ascii?Q?+M5eoGmxEeddWK+VgmcL23RyhsLRT0vSwPBje+288TTajiK7/xLpYjVjYkdZ?=
 =?us-ascii?Q?P9TPFyutiRdgNSNz+0JGY27WB23v0Nht79dWj0pYWB/3lPwE40j34ZCxMiMQ?=
 =?us-ascii?Q?asAtoNYFJSbXGnEZi75Vr72auAZ9ppbziTpjyJM+tZx3PQBSwKgww/kYr3+D?=
 =?us-ascii?Q?7Td2puWEGisuqyf3k5RlKb7DBU/FGYb67Yvrr4FzzIslfLPVpQQ4Hnncxnqb?=
 =?us-ascii?Q?iNsQqe73vzzCw5EIiRQF9KN310n8a/VD0x6Iz3AzKkpw0E2UXvR7Zrv1+/nC?=
 =?us-ascii?Q?VnGGZwz9isCjfgk7q7N0uPocBUfNlO8Jyj+Ti/xlpeSdeqWkBgjq4iGQslEG?=
 =?us-ascii?Q?ERcUnsF3ddYK3xLns3T9KLKf+hViQ/0vGa6uu3JrjVObq86u3tTtvD+fFgXu?=
 =?us-ascii?Q?iYcV+Kun912nJsdrv87IDIXk/94JuMWRddvjAAMVPNHSP4VIqD6QSPR6l7pc?=
 =?us-ascii?Q?kEdTokWstKQkabH9pwQ/reUbK+8EpC2x8zI5RvgaIDRVpzwDsHRurawLJu/c?=
 =?us-ascii?Q?YSNDKx6R8rzj1svbHRQq59qb53pShf4w3JhTOhXidPe8nFDhlmzTNzgGWiRU?=
 =?us-ascii?Q?irw78R3ZB/EhAFOaya7AHQd0hindiOkxvrWm9EZczGJl3n9n8Q4+xGyH5KNJ?=
 =?us-ascii?Q?26IAJs17zR36t5/PQqlt9V1GDdh3exxh1YJMA/apfOU0iWnQBL0kSn4T/O2s?=
 =?us-ascii?Q?0CEGesVcmLmXmldrm/+vL5pocLjJlHBB22rEUB27H87uXd6l8L6lbh9NZXiQ?=
 =?us-ascii?Q?lQgjS9H6fd6955rmx9Az3+nVFWYz7qeJzddG0ilxgnVhJlrI1RV4VBo0swWU?=
 =?us-ascii?Q?dqQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c272972-0550-409a-05d5-08d8f2d5431c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 17:08:23.9411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZhoJcI6c5Q+I/3WSuw+5rv8BVQ0+reZgiHIpLBKWNE+P0fSnYEQG0TuSeb3Mpr8pFlyQov0xLPsWV6G66CqhGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>Sent: Monday, March 29, 2021 7:24 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; David S .
>Miller <davem@davemloft.net>
>Subject: Re: [PATCH net v2] enetc: Avoid implicit sign extension
>
>On Mon, Mar 29, 2021 at 05:14:43PM +0300, Claudiu Manoil wrote:
>> Static analysis tool reports:
>> "Suspicious implicit sign extension - 'flags' with type u8 (8 bit,
>> unsigned) is promoted in 'flags' << 24 to type int (32 bits, signed),
>> then sign-extended to type unsigned long long (64 bits, unsigned).
>> If flags << 24 is greater than 0x7FFFFFFF, the upper bits of the result
>
>This is a backwards way of saying 'if flags & BIT(7) is set', no? But
>BIT(7) is ENETC_TXBD_FLAGS_F (the 'final BD' bit), and I've been testing
>SO_TXTIME with single BD frames, and haven't seen this problem.
>

Better be safe than sorry.

>> will all be 1."
>>
>> Use lower_32_bits() to avoid this scenario.
>>
>> Fixes: 82728b91f124 ("enetc: Remove Tx checksumming offload code")
>>
>> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
>> ---
>> v2 - added 'fixes' tag
>>
>>  drivers/net/ethernet/freescale/enetc/enetc_hw.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>> index 00938f7960a4..07e03df8af94 100644
>> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>> @@ -535,8 +535,8 @@ static inline __le32 enetc_txbd_set_tx_start(u64
>tx_start, u8 flags)
>>  {
>>  	u32 temp;
>>
>> -	temp =3D (tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
>> -	       (flags << ENETC_TXBD_FLAGS_OFFSET);
>> +	temp =3D lower_32_bits(tx_start >> 5 & ENETC_TXBD_TXSTART_MASK)
>|
>> +	       (u32)(flags << ENETC_TXBD_FLAGS_OFFSET);
>
>I don't actually understand why lower_32_bits called on the TX time
>helps, considering that the value is masked already.=20

Just want to ensure it's handled as u32 and not u64. I also think lower_32_=
bits()
is the cleanest way to convert from u64 to u32, in this case at least.

>The static analysis
>tool says that the right hand side of the "|" operator is what is
>sign-extended:
>
>	       (flags << ENETC_TXBD_FLAGS_OFFSET);
>
>Isn't it sufficient that you replace "u8 flags" in the function
>prototype with "u32 flags"?
>

I prefer to cast it to u32 after the shift. The 'flags' argument passed to =
this helper
function is always u8 as it matches the 8-bit field of the Tx BD DMA struct=
ure.


