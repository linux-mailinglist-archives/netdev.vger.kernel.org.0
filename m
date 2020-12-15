Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CC72DAF77
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgLOOsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:48:46 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:56952 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729769AbgLOOs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:48:28 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFEcEcZ023382;
        Tue, 15 Dec 2020 09:47:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=58N8cPMp8cl8k2GUCU4ClDSScdD6UkyKHbA9tyCf+Cc=;
 b=wRrhr/gfLKxSsUvCtCsQwaiibpM6xiNwQo30Jp9VvxReRsogcsheXONjP7gJ0aJ1eWkr
 4I3d4uZopQDEtWHe5JvIxeBwrnYqi7BxAsHKW1XEoblFgSZMpOxV8bzqUzpMLDDR+UXV
 E9dVVyHOF4KuSzEYb++CG05V9sFOUFZEAKi9Nyk3INVSNlVsa+qrt9WWZ0PGug2bWn7C
 LivdpQ8DLEmS+XQcW8D3tg7Kt5dWDx31g307ya47NV8QowSa8jl7A/jPKMg9zQ5GMbEA
 SS7qFxqMLhxkk7C8AkY1Y7fNdYFUP/gLPcaQ+PisZ8bOigYtHlOkyt3jToWdX7XGuoqA xg== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 35ct2pt663-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 09:47:36 -0500
Received: from pps.filterd (m0144104.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFEhCoq174913;
        Tue, 15 Dec 2020 09:47:35 -0500
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0b-00154901.pphosted.com with ESMTP id 35exwmgdac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 09:47:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6s7ndgYBe9tehJaWwaMxpPugiWLUfllQUQD28eAxmQa74K/YXuAyGf1RCayYDC+IPAY88x1DjXo2PHBeLd7DU/qWkbgPFdSA7LxHtcg+2hl1XWd+baNLX0cg4kCMSIlQX/5MMiXtBzhwJ9V+tKbt0fgbKbXM+rWD6lC7yTIID6AX95w3Fg99tQuHEOHil/3M6JJKxuf18vY8Jr3U7LWbxkACsatG7cvWw6pAmzcIBTm5VFaz9S1deqEx9iTPK+Ct67PR7Z73hjzmEZdkU5N/JpWODtCffWYaGIAGQY7yCWUlYhjYSxeoTxuQjqoYPPQhICIhK8B/mkD1OlmOxppLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58N8cPMp8cl8k2GUCU4ClDSScdD6UkyKHbA9tyCf+Cc=;
 b=MroVtSRMvMQugAA5mkoeQ8Y9KxL1lM6AvgV3NJMecFvkbn8aKIu5lFZpJmTOXDCI/m35chso/BydlaTFUHm9gZgR9i1TQyCWoBREDRT1XmV6EaAiee/kZBleXDK/FIiCxtvpS/ry2fxl+poUXqhzpxDYAqYmzZSxIF94mV0eEgqfy/Hzn5a/PqlYlk0fr0jPC1MEUbpPWyetkYH9gC08HpdbcS8KCXEeh3gCGq2Nk2y72wlc6IgOHPFK7hvMup1pxV3d7Gl2+fDrr4dQfhx30ytuAoNfJ+hetCRImqLyryOY/02hLBFcttuouvnZwlMSZSLqH5+r3d0m7uWQcuHoRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58N8cPMp8cl8k2GUCU4ClDSScdD6UkyKHbA9tyCf+Cc=;
 b=j9GqoCIA6y2Wp8Q4qZbKNCi+xYdcfR/vv8C2n6mc2n8TUR/Ow4v3eAkGIU3ZO+12y5VUhXNMMWTI/2cshpHHKdNRT35RgFNJJ7lxXf292JIkcbUT2+vmYPxWWsnodoQtmNHXC6SESIuf3vNUAX4PQYltmhFEEV8GzRFltRKyWY0=
Received: from SJ0PR19MB4463.namprd19.prod.outlook.com (2603:10b6:a03:282::9)
 by BY5PR19MB3953.namprd19.prod.outlook.com (2603:10b6:a03:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 14:47:32 +0000
Received: from SJ0PR19MB4463.namprd19.prod.outlook.com
 ([fe80::6d3e:acc:b93c:11ef]) by SJ0PR19MB4463.namprd19.prod.outlook.com
 ([fe80::6d3e:acc:b93c:11ef%9]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 14:47:32 +0000
From:   "Shen, Yijun" <Yijun.Shen@dell.com>
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: RE: [PATCH v5 4/4] e1000e: Export S0ix flags to ethtool
Thread-Topic: [PATCH v5 4/4] e1000e: Export S0ix flags to ethtool
Thread-Index: AQHW0k9/eLrkML0uOkKfZqEThExTwqn4PTjA
Date:   Tue, 15 Dec 2020 14:47:32 +0000
Message-ID: <SJ0PR19MB4463F48834736D724D357A6E9AC60@SJ0PR19MB4463.namprd19.prod.outlook.com>
References: <20201214192935.895174-1-mario.limonciello@dell.com>
 <20201214192935.895174-5-mario.limonciello@dell.com>
In-Reply-To: <20201214192935.895174-5-mario.limonciello@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: Dell.com; dkim=none (message not signed)
 header.d=none;Dell.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [101.86.22.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9725b162-8cb4-4eab-98fc-08d8a1085aae
x-ms-traffictypediagnostic: BY5PR19MB3953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR19MB3953570178DE62CF059D88089AC60@BY5PR19MB3953.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TvWxHk4IDnSopxX+cozybbV+//MLK56/vkaNojgx/cSTP+n4qXKd82AQpsISt1B0sinepaNB0u7XYFRjEIcsHYxdgnUQtdINSm2Q0YGbRs2i4RIamwG1NHX9f5HPbqckCNcWUAlA4eojYrZSg+tfz1jBdfiGRw9xxJcPV/wSmOFUYZiYq52eElF32HeKovk28JyVbFXEQrGGpPc8xIT/r4X51/gHsTciQEkclK8d2NO5063GQUbMPtxAxtj4E4ZB3L2Ynw2U726pNobXbw8ngJehJTHQUzpDk1Bk1HEPuk5dz5P/IUVVLGV/QDUk39FaxP7nuRCdui1NtHGIP09ULuq+l72qKZE9MPsULwaULAlU6+wEYjED8BKV0TZhNykk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB4463.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(66556008)(186003)(86362001)(66446008)(83380400001)(64756008)(66946007)(66476007)(53546011)(71200400001)(2906002)(7696005)(5660300002)(508600001)(33656002)(6506007)(786003)(8936002)(8676002)(7416002)(54906003)(52536014)(110136005)(55016002)(9686003)(76116006)(4326008)(26005)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qeyIsNJ8snBdrLsjZMeLhqoioQnkN6EG3nTj6aPigSRdRBXDdY9Wd0up6NqZ?=
 =?us-ascii?Q?HKcFGN0GuyXhf4kiGYPD3EvwmgXml1+r9h6ygEFiB6NEomz3Khc/SLfvv8MC?=
 =?us-ascii?Q?z/sNTA8ZUWfPkHABmDpADYSa+86VhNC9VdyPTb5qpZKhRjzDk5y3KTGO3uP9?=
 =?us-ascii?Q?B4oeU7Du47O33QWBhVT+QxDQo+ZbQpJdOrJO3qavdKqHq2dt2XdeZGWpw26/?=
 =?us-ascii?Q?0KwJwQ9kCHrQcaj3AB51GTn6GCRYHqOa3HjcHJOQ8O4ZStWy84aL1IpoAxbL?=
 =?us-ascii?Q?EIpaA0kB0TP1e5LYdwQYeishYyDSP5iOHo3uRXc9yCFerFsnvL0ssGomSx12?=
 =?us-ascii?Q?i9rXAPPeyGrcSXLyO0ESW9rfWxSG/cACjVkFinq4yTxu5ziZDHjw9RKi1rQc?=
 =?us-ascii?Q?XlV4dMO9EZUjyHpM3R0+D0+lVtAFe0x4Evwg1BIb1BaVTr1Uch3SjZcx9iup?=
 =?us-ascii?Q?EbBeEJKyGovcGBJvGei0Ea/pwaQUBvWs5GE+E2+dVZUaIvgBGAjxjgmGvWoK?=
 =?us-ascii?Q?lzFyXKrg7r3w2lKLmqGoANly+7jjFyzAA2TV8tAs9RJu1h5lNckki0mPRV6e?=
 =?us-ascii?Q?WoR9wzID+yZ917AKWNNupIzzEMe7B/LGiMKTHcOyEaqP9UlTfzp/UL5VGA/8?=
 =?us-ascii?Q?iCmByEZhS6vl08ms0GA/nKFLxPqvbqBAOEC2vDuUZi6/6P+ogNQ95MnfWAvT?=
 =?us-ascii?Q?vCAIv2l/zvaQDSe02n9DO1+sWFkkstYOYSDzLvzNPkiKFilvPq2Syb0VDmkO?=
 =?us-ascii?Q?cwwPpe6o7aNc72I/0IVmTHrMoPaGRZoOmllz8tfup/dJhhoyGpRwJYubLaKI?=
 =?us-ascii?Q?tzWs67hi1Pn1BAYVh6c/WCSBMA2gVbqwZ4lcQ6K6eOHRnn7dEokvUNai2k4e?=
 =?us-ascii?Q?ds+t8Nvz/ENw/qDTEyfx7QcFayD0XcKYddNq50p+NyOQ3pGNQuNfPdkViQWh?=
 =?us-ascii?Q?BAS2qjkiW+TWvd1WksIMI7PlHECO9FggiaDKcsqZwpk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB4463.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9725b162-8cb4-4eab-98fc-08d8a1085aae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 14:47:32.5211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wiZbgx3pTER2dULIZBXkQVKyymj/UlFvEhUByf8ITjam9TYdffN3/XPmoMDRy0itLfBztez0QGrli1V9s85j7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3953
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150105
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Limonciello, Mario <Mario_Limonciello@Dell.com>
> Sent: Tuesday, December 15, 2020 3:30 AM
> To: Jeff Kirsher; Tony Nguyen; intel-wired-lan@lists.osuosl.org
> Cc: linux-kernel@vger.kernel.org; Netdev; Alexander Duyck; Jakub Kicinski=
;
> Sasha Netfin; Aaron Brown; Stefan Assmann; David Miller;
> darcari@redhat.com; Shen, Yijun; Yuan, Perry;
> anthony.wong@canonical.com; Hans de Goede; Limonciello, Mario
> Subject: [PATCH v5 4/4] e1000e: Export S0ix flags to ethtool
>=20
> This flag can be used by an end user to disable S0ix flows on a buggy sys=
tem
> or by an OEM for development purposes.
>=20
> If you need this flag to be persisted across reboots, it's suggested to u=
se a
> udev rule to call adjust it until the kernel could have your configuratio=
n in a
> disallow list.
>=20
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>

Verified this series patches with Dell Systems.

Tested-By: Yijun Shen <Yijun.shen@dell.com>

> ---
>  drivers/net/ethernet/intel/e1000e/e1000.h   |  1 +
>  drivers/net/ethernet/intel/e1000e/ethtool.c | 46 +++++++++++++++++++++
> drivers/net/ethernet/intel/e1000e/netdev.c  |  9 ++--
>  3 files changed, 52 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h
> b/drivers/net/ethernet/intel/e1000e/e1000.h
> index ba7a0f8f6937..5b2143f4b1f8 100644
> --- a/drivers/net/ethernet/intel/e1000e/e1000.h
> +++ b/drivers/net/ethernet/intel/e1000e/e1000.h
> @@ -436,6 +436,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter
> *adapter, u32 *timinca);
>  #define FLAG2_DFLT_CRC_STRIPPING          BIT(12)
>  #define FLAG2_CHECK_RX_HWTSTAMP           BIT(13)
>  #define FLAG2_CHECK_SYSTIM_OVERFLOW       BIT(14)
> +#define FLAG2_ENABLE_S0IX_FLOWS           BIT(15)
>=20
>  #define E1000_RX_DESC_PS(R, i)	    \
>  	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i])) diff --git
> a/drivers/net/ethernet/intel/e1000e/ethtool.c
> b/drivers/net/ethernet/intel/e1000e/ethtool.c
> index 03215b0aee4b..06442e6bef73 100644
> --- a/drivers/net/ethernet/intel/e1000e/ethtool.c
> +++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
> @@ -23,6 +23,13 @@ struct e1000_stats {
>  	int stat_offset;
>  };
>=20
> +static const char e1000e_priv_flags_strings[][ETH_GSTRING_LEN] =3D {
> +#define E1000E_PRIV_FLAGS_S0IX_ENABLED	BIT(0)
> +	"s0ix-enabled",
> +};
> +
> +#define E1000E_PRIV_FLAGS_STR_LEN
> ARRAY_SIZE(e1000e_priv_flags_strings)
> +
>  #define E1000_STAT(str, m) { \
>  		.stat_string =3D str, \
>  		.type =3D E1000_STATS, \
> @@ -1776,6 +1783,8 @@ static int e1000e_get_sset_count(struct net_device
> __always_unused *netdev,
>  		return E1000_TEST_LEN;
>  	case ETH_SS_STATS:
>  		return E1000_STATS_LEN;
> +	case ETH_SS_PRIV_FLAGS:
> +		return E1000E_PRIV_FLAGS_STR_LEN;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -2097,6 +2106,10 @@ static void e1000_get_strings(struct net_device
> __always_unused *netdev,
>  			p +=3D ETH_GSTRING_LEN;
>  		}
>  		break;
> +	case ETH_SS_PRIV_FLAGS:
> +		memcpy(data, e1000e_priv_flags_strings,
> +		       E1000E_PRIV_FLAGS_STR_LEN * ETH_GSTRING_LEN);
> +		break;
>  	}
>  }
>=20
> @@ -2305,6 +2318,37 @@ static int e1000e_get_ts_info(struct net_device
> *netdev,
>  	return 0;
>  }
>=20
> +static u32 e1000e_get_priv_flags(struct net_device *netdev) {
> +	struct e1000_adapter *adapter =3D netdev_priv(netdev);
> +	u32 priv_flags =3D 0;
> +
> +	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
> +		priv_flags |=3D E1000E_PRIV_FLAGS_S0IX_ENABLED;
> +
> +	return priv_flags;
> +}
> +
> +static int e1000e_set_priv_flags(struct net_device *netdev, u32
> +priv_flags) {
> +	struct e1000_adapter *adapter =3D netdev_priv(netdev);
> +	unsigned int flags2 =3D adapter->flags2;
> +
> +	flags2 &=3D ~FLAG2_ENABLE_S0IX_FLOWS;
> +	if (priv_flags & E1000E_PRIV_FLAGS_S0IX_ENABLED) {
> +		struct e1000_hw *hw =3D &adapter->hw;
> +
> +		if (hw->mac.type < e1000_pch_cnp)
> +			return -EINVAL;
> +		flags2 |=3D FLAG2_ENABLE_S0IX_FLOWS;
> +	}
> +
> +	if (flags2 !=3D adapter->flags2)
> +		adapter->flags2 =3D flags2;
> +
> +	return 0;
> +}
> +
>  static const struct ethtool_ops e1000_ethtool_ops =3D {
>  	.supported_coalesce_params =3D ETHTOOL_COALESCE_RX_USECS,
>  	.get_drvinfo		=3D e1000_get_drvinfo,
> @@ -2336,6 +2380,8 @@ static const struct ethtool_ops e1000_ethtool_ops
> =3D {
>  	.set_eee		=3D e1000e_set_eee,
>  	.get_link_ksettings	=3D e1000_get_link_ksettings,
>  	.set_link_ksettings	=3D e1000_set_link_ksettings,
> +	.get_priv_flags		=3D e1000e_get_priv_flags,
> +	.set_priv_flags		=3D e1000e_set_priv_flags,
>  };
>=20
>  void e1000e_set_ethtool_ops(struct net_device *netdev) diff --git
> a/drivers/net/ethernet/intel/e1000e/netdev.c
> b/drivers/net/ethernet/intel/e1000e/netdev.c
> index b9800ba2006c..e9b82c209c2d 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6923,7 +6923,6 @@ static __maybe_unused int
> e1000e_pm_suspend(struct device *dev)
>  	struct net_device *netdev =3D pci_get_drvdata(to_pci_dev(dev));
>  	struct e1000_adapter *adapter =3D netdev_priv(netdev);
>  	struct pci_dev *pdev =3D to_pci_dev(dev);
> -	struct e1000_hw *hw =3D &adapter->hw;
>  	int rc;
>=20
>  	e1000e_flush_lpic(pdev);
> @@ -6935,7 +6934,7 @@ static __maybe_unused int
> e1000e_pm_suspend(struct device *dev)
>  		e1000e_pm_thaw(dev);
>  	} else {
>  		/* Introduce S0ix implementation */
> -		if (hw->mac.type >=3D e1000_pch_cnp)
> +		if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
>  			e1000e_s0ix_entry_flow(adapter);
>  	}
>=20
> @@ -6947,11 +6946,10 @@ static __maybe_unused int
> e1000e_pm_resume(struct device *dev)
>  	struct net_device *netdev =3D pci_get_drvdata(to_pci_dev(dev));
>  	struct e1000_adapter *adapter =3D netdev_priv(netdev);
>  	struct pci_dev *pdev =3D to_pci_dev(dev);
> -	struct e1000_hw *hw =3D &adapter->hw;
>  	int rc;
>=20
>  	/* Introduce S0ix implementation */
> -	if (hw->mac.type >=3D e1000_pch_cnp)
> +	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
>  		e1000e_s0ix_exit_flow(adapter);
>=20
>  	rc =3D __e1000_resume(pdev);
> @@ -7615,6 +7613,9 @@ static int e1000_probe(struct pci_dev *pdev, const
> struct pci_device_id *ent)
>  	if (!(adapter->flags & FLAG_HAS_AMT))
>  		e1000e_get_hw_control(adapter);
>=20
> +	if (hw->mac.type >=3D e1000_pch_cnp)
> +		adapter->flags2 |=3D FLAG2_ENABLE_S0IX_FLOWS;
> +
>  	strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
>  	err =3D register_netdev(netdev);
>  	if (err)
> --
> 2.25.1

