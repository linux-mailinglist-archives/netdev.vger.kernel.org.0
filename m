Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C542FF04D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbhAUQ37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:29:59 -0500
Received: from mail-dm6nam11on2100.outbound.protection.outlook.com ([40.107.223.100]:40024
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387607AbhAUQDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 11:03:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KR5fE5fW68qskEGgwMUccUjqcUvsTXTZpkUwWSyeY8YxY5GtzjHE6pJGyzmSuG9LokEf1WmJTOLdihq9lYYhuneQ9QhplCdeN9+r/9qgn7dhunaremJpyV6Qhk0TBEaZ+iHIDeEn/RYVxdzVkqM3R5Rl/z2YEqFHmqa1hT9BEU+HMd/C3iPO3CHm1I4ynw0/HFbrTt9GYtx9vouA/ymtkkTfm/CQIPfqg5sp8HUk1rePoxXzohgEFwgk9hHC9tX+r4SwgX2kJAd0aPHAh/Ca+4Muq7eSIDG3dCMEM9e3HvKqPW2G6238LTwqaTCyEt/tT1RBosz/+sjdqhdRXfyoSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHBt7kRea/PdS3JGFUFtoB8vopUCxYnyVcO6pXPhchg=;
 b=GhnwH3HeGMpufJO76FpGvO5LKRs7mjm46GQjaeLb7Rvavwvm6R/ZAr29Kz+vez1qyST988OEBwXdQXVndrHlI4V6k3mlhPSlUAOWcGeMGj5KWMpdYBU808v3S+N1peN56drrkxE09tcJOgyJSrL9gxJGjTHExhibB+DqkQBSTCV1tciHBbL8MHzPmEgFacIbWjWMtfAMsvuLlRYsHo/LZsEPDHJGYnxqQ5coFef+Fc3DYrSZ4DiN4ARBeHCRJj/Y+JzIVND+nvkrdqrxIhKxdllOy3fNFfuB8BvU0SK4d6lDR6BbiuIuL1CsUA1WdWB0UP0ngr6cKL9sGJNsGnRu3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHBt7kRea/PdS3JGFUFtoB8vopUCxYnyVcO6pXPhchg=;
 b=F1tfjlZTe7YBMmWJoBB+VXj//zXr7fgBegEs4SBl0oNx0agndNoF+OBzr3uKWM94J+qD+wDepT8foBBLD1Ph5ohATgfvUnN3i/BMxFLuRpfQ96bUwVsN9SjQdTlMHJ9wxBbMW5Vnbf9VPLLZvJb9Njvsa8vHsHxqW5lqo2P/JWA=
Received: from (2603:10b6:207:30::18) by
 BL0PR2101MB1092.namprd21.prod.outlook.com (2603:10b6:207:37::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.1; Thu, 21 Jan
 2021 16:02:17 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::5148:e9c:f912:a799]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::5148:e9c:f912:a799%3]) with mapi id 15.20.3805.006; Thu, 21 Jan 2021
 16:02:16 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andrea Parri <parri.andrea@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated guests
Thread-Topic: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Thread-Index: AQHW7ozTJyADPmDtnEe0lsr5e3G6Fqow4pmAgACVmQCAAMDHoA==
Date:   Thu, 21 Jan 2021 16:02:16 +0000
Message-ID: <BL0PR2101MB0930698DBF66828F4EE4CDA8CAA19@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210119175841.22248-1-parri.andrea@gmail.com>
 <20210119175841.22248-5-parri.andrea@gmail.com>
 <BL0PR2101MB0930CF4297121B1BB904AA7DCAA29@BL0PR2101MB0930.namprd21.prod.outlook.com>
 <20210121040526.GA264889@anparri>
In-Reply-To: <20210121040526.GA264889@anparri>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1a21c132-8c28-4486-aec6-897eecaca316;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-21T15:35:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8a897cf-6fe7-472a-efea-08d8be25ecdb
x-ms-traffictypediagnostic: BL0PR2101MB1092:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB10923758620B14D464525370CAA19@BL0PR2101MB1092.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0s+ov1Xg49V6Yrxq4TmutU99MSbDAavB+PdpjYtEPaZhp4m2lpuxODjg+xZ4Kr7UOOVBBryncw4CI8PS+mfwFcsQqJP4vUV4YvpQBtWyXKamHuLYQXJsyD5KB/SZI0hKKMxIhfpkQOA17kA8CtLOvK20TDX9p6tJPqdJWKBcLftdpq4XMDoDcsvKAI/ykWDiAHvIAcY5G2kUMnWrd1NIyTc5qV1G/BgJWhwX8hDx9BkNavy3ac0oj9k4Se+n1BLwaWvSxcc1GfHW/wuMFVFP/grH95Z3gSorHyD8QVpBQjP/Vte+mL/snFJNsjDXtmaeebBtYQwiHBQjYianhkBdexDSNxMYsRV370vfSIiDpYiIvrLMx1y3r+iEDfqegmDfhKUilyQnv656eAHHVQPgdqzSkO0WP9fOT2ZOzMhYk18ZJKa17nIp3UwvV6cz5LMx+V+Bv0tqximQwa3V+ieHK1JVLTfzEyB8k/KGIVYnMpcKYBkaPfhjOAknnhlx/3pXmWcAsVhRqkqbcW22/1SRJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(71200400001)(82950400001)(83380400001)(64756008)(6916009)(76116006)(54906003)(86362001)(53546011)(66476007)(66556008)(6506007)(66446008)(7696005)(8676002)(186003)(33656002)(478600001)(10290500003)(26005)(82960400001)(2906002)(8936002)(66946007)(55016002)(316002)(4326008)(52536014)(9686003)(5660300002)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JzvOEI95b5SNVZHWK4NkWN97AyhsYpeTt/mQt4i/JFF/5VJAPrVK554Q17tV?=
 =?us-ascii?Q?LLu4B+Tgo9pcdAkej/wmLEEkeeo5Sqtu6PTZL4/Wfl9OoqZ3lAMrMp0djbJK?=
 =?us-ascii?Q?hFESqFJgOhDZi2ArfKWk6QiF1Ut7y1q5XBZ0sFKLWXaDdUcoI3sh648pqRId?=
 =?us-ascii?Q?PTQR0eLOgMJ4sJnB0bDa7iu5LVMILAP84y56oCg7I9lGtGUH8t/gJAJwTlWI?=
 =?us-ascii?Q?d0khuJs2JqN17cTsvaOnMc8u8keZXP5OXNJoMBiu6iRRNWPYmQvccqfmUrzR?=
 =?us-ascii?Q?XOHYRn4aQtx28505Sy+ytj74otXtdgGCWxzzwYjwZlsb8BwDF1SELRNpWf0L?=
 =?us-ascii?Q?70ru85U0pE8Mlnd0NcY6mxPYuY9LBEAewqx06eM8PRjMRtdN//8kXbGoL1EH?=
 =?us-ascii?Q?++NTso+kPYEnYjxwLvwR+FAbPLpqN75xH+TDE2BgC3I4DRvHfNT3YfoJCs83?=
 =?us-ascii?Q?e52CeUZEs0aWNt+KWaBwC+EwdaNQvZsN4W1IOz8CKIEfqqgDSBJqXl3OSo0S?=
 =?us-ascii?Q?h9yna8X60sS6jjpCY3ic4sbrsSlHhTZ5jbM/BHFuu8YtNIqJRXQQ5IU7j6ag?=
 =?us-ascii?Q?pBTolvbp4ojOsNB8QR3WKOUAOvMr32s/mzLdd1VjENxWZFBT1knJLJ+HYwhY?=
 =?us-ascii?Q?hDMSz7S8xfe4ud/5G9nKr4/cpZ7pvI4PQnHoOg9sokm3Pmy8+shwH+VF0xe5?=
 =?us-ascii?Q?XeT44O0iznM8ecs2J3v6gx0FtTaVz+phYQE53zPNDT/vzwfzApVgTstMUzts?=
 =?us-ascii?Q?yjdmcLfuhZBCn57FUz2l0Yicsl+JAQYARw+DZyihPDITxPNX+jOl4Oq6H3B7?=
 =?us-ascii?Q?KKuUrtbS2a8t35XQA2W5xlsfi/NNBLHxJlBv+o78/cYuirv31wqRUgH7HgAB?=
 =?us-ascii?Q?eKvSj3loqQ8sBlNJcWq78UxpLQ4LpkONSvlqhaN+4sfYxKGWUEndaCUyMzMM?=
 =?us-ascii?Q?d/k+JLccTJTJyBmcuJW3aASVNqu6yWKGCr5OMC+r4LHbkm/p/obeDtb5WEVb?=
 =?us-ascii?Q?jrSE4+d3wGgHV8R793AXKtiM3/l3WrIIFHciGEGf+wGSldRU8pjOeTXMjzVe?=
 =?us-ascii?Q?r+a/bhto?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a897cf-6fe7-472a-efea-08d8be25ecdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 16:02:16.9269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZUI57baqJg1KmA4bzBRtNrVwVWhLtGOl6G+sZA5cFG7e8EHFIZpa6DJ4uW3uXXj9ZH/QLeohweGRmkOPmS22Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Parri <parri.andrea@gmail.com>
> Sent: Wednesday, January 20, 2021 11:05 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-kernel@vger.kernel.org; KY Srinivasan <kys@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; Wei Liu
> <wei.liu@kernel.org>; Michael Kelley <mikelley@microsoft.com>; Tianyu Lan
> <Tianyu.Lan@microsoft.com>; Saruhan Karademir
> <skarade@microsoft.com>; Juan Vazquez <juvazq@microsoft.com>; linux-
> hyperv@vger.kernel.org; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: Re: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated
> guests
>=20
> > > @@ -544,7 +545,8 @@ static int negotiate_nvsp_ver(struct hv_device
> > > *device,
> > >  	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q =3D 1=
;
> > >
> > >  	if (nvsp_ver >=3D NVSP_PROTOCOL_VERSION_5) {
> > > -		init_packet->msg.v2_msg.send_ndis_config.capability.sriov =3D
> > > 1;
> > > +		if (!hv_is_isolation_supported())
> > > +			init_packet-
> > > >msg.v2_msg.send_ndis_config.capability.sriov =3D 1;
> >
> > Please also add a log there stating we don't support sriov in this case=
.
> Otherwise,
> > customers will ask why vf not showing up.
>=20
> IIUC, you're suggesting that I append something like:
>=20
> +		else
> +			netdev_info(ndev, "SR-IOV not advertised: isolation
> supported\n");
>=20
> I've added this locally; please let me know if you had something else
> /better in mind.

This message explains the failure reason better:
  "SR-IOV not advertised by guests on the host supporting isolation"

>=20
>=20
> > > @@ -563,6 +565,13 @@ static int negotiate_nvsp_ver(struct hv_device
> > > *device,
> > >  	return ret;
> > >  }
> > >
> > > +static bool nvsp_is_valid_version(u32 version)
> > > +{
> > > +       if (hv_is_isolation_supported())
> > > +               return version >=3D NVSP_PROTOCOL_VERSION_61;
> > > +       return true;
> > Hosts support isolation should run nvsp 6.1+. This error is not expecte=
d.
> > Instead of fail silently, we should log an error to explain why it's fa=
iled, and
> the current version and expected version.
>=20
> Please see my next comment below.
>=20
>=20
> > > +}
> > > +
> > >  static int netvsc_connect_vsp(struct hv_device *device,
> > >  			      struct netvsc_device *net_device,
> > >  			      const struct netvsc_device_info *device_info)
> > > @@ -579,12 +588,17 @@ static int netvsc_connect_vsp(struct hv_device
> > > *device,
> > >  	init_packet =3D &net_device->channel_init_pkt;
> > >
> > >  	/* Negotiate the latest NVSP protocol supported */
> > > -	for (i =3D ARRAY_SIZE(ver_list) - 1; i >=3D 0; i--)
> > > +	for (i =3D ARRAY_SIZE(ver_list) - 1; i >=3D 0; i--) {
> > > +		if (!nvsp_is_valid_version(ver_list[i])) {
> > > +			ret =3D -EPROTO;
> > > +			goto cleanup;
> > > +		}
> >
> > This code can catch the invalid, but cannot get the current host nvsp
> version.
> > I'd suggest move this check after version negotiation is done. So we ca=
n log
> what's
> > the current host nvsp version, and why we fail it (the expected nvsp ve=
r).
>=20
> Mmh, invalid versions are not negotiated.  How about I simply add the
> following logging right before the above 'ret =3D -EPROTO' say?
>=20
> +			netdev_err(ndev, "Invalid NVSP version %x
> (expected >=3D %x): isolation supported\n",
> +				   ver_list[i], NVSP_PROTOCOL_VERSION_61);
>=20
> (or something along these lines)

The negotiation process runs from the latest to oldest. If the host is 5, y=
our code=20
will fail before trying v6.0, and log:
	"Invalid NVSP version 60000  (expected >=3D 60001): isolation supported"
This will make user think the NVSP version is 6.0.

Since you will let the NIC fail and cleanup, there is no harm to check the =
version=20
after negotiation. And this case is unexpected from a "normal" host. So I s=
uggest=20
move the check after negotiation is done, then we know the actual host nvsp=
=20
version that causing this issue. And we can bring the accurate info to host=
 team=20
for better diagnosability.

Please point out this invalid version is caused by the host side, like this=
:
	"Invalid NVSP version 0x50000  (expected >=3D 0x60001) from the host with =
isolation support"
Also please use "0x%x" for hexadecimal numbers.

>=20
>=20
> > > @@ -1357,7 +1371,8 @@ static void netvsc_receive_inband(struct
> > > net_device *ndev,
> > >  		break;
> > >
> > >  	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> > > -		netvsc_send_vf(ndev, nvmsg, msglen);
> > > +		if (!hv_is_isolation_supported())
> > > +			netvsc_send_vf(ndev, nvmsg, msglen);
> >
> > When the driver doesn't advertise SRIOV, this message is not expected.
> > Instead of ignore silently, we should log an error.
>=20
> I've appended:
>=20
> +		else
> +			netdev_err(ndev, "Unexpected VF message:
> isolation supported\n");

Please log the msg type:
  "Ignore VF_ASSOCIATION msg from the host supporting isolation"

Thanks,
- Haiyang
