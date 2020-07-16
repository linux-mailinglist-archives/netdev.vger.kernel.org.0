Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6D2221B2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGPLte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:49:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10284 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbgGPLtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:49:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBnENs005129;
        Thu, 16 Jul 2020 04:49:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=fGa6LwtAu+Q29WATQLJQpSz9yiO8r5niblyGghNLZkY=;
 b=DAKYLKDTSCwlZaZHZT+dUJ0JfgKDq1/ubK6DhGWiyi9Up+85FFTd6rGoRZm8iHvx1+Iy
 QTiKAVnUf7huS0bLMDDb++TX4OEij5uy7EYybnFOqjQmA2eyH5wJtkgEzdiPCHYlidQ9
 ayvhAJXAvYbJWQLRYfDh64LcOrYP1k3FxkcRxHXDZfnT0w00Gz3D3q7AnL9HUYNhA/zX
 cpiEPeqS36q3maiqinO9PYdQVJGhiyc9BsbGnflAc8Tf8Q9zwDEZWSNrzeIFXRQExAJJ
 p3XTz5lWyY4lG5m7kckAwL+Ae6E8Fsxz0JGe6Q6ycPkXoT0bbD94AoGqR9zP6LtSHIgi Ew== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhyfbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:49:29 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:49:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 16 Jul 2020 04:49:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjE0ADSmAG6PTMZ4PSaR2T/SeEXwvSXXHG0Wz1Kyb9O7MZSxDMlfHUpGeKvZjmdmkjyFgOctaHz+/bR83g8NRaMCxRAKww+9xuNXoEKyGehJSBMHUeelWEjM9JLaXDQEU/GZ2uNdPkmsfm3LOCV/1kGK8DaZdxessugRERbgmuvXTZmiL0rfS51l5Lj7nzMaqYeCFOI/M2BymBMKFTnv+VmrzBEKZMfu7u9BFhrSkxDl5VgnehtPJcsMU6eUsb+F+KGZC4dUAZaa4vuOG+i4xiRATv3WI62T6Lyyb0zm4O69WK47BVXhlKsJ1FJwlOUqpQuaAjhc1I9IjeMRmnKtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGa6LwtAu+Q29WATQLJQpSz9yiO8r5niblyGghNLZkY=;
 b=k0oXsI5fL3LhIpPrMHAQf3SdBLw3Dhya/Yt0QsJXHUV9hQVDsTEqss6dHWlH3uWtqWU6WEWLpawRYgbDZ+EPEtf+YQwwkzSw9XXqb/KX28mQOPzTF2ZsIS/oFvXU/tUvxWJLHj5aM75BhNxqAm5ingGHT42hZcC1vLjD576VZ2OJWdKf1BKb/l+ga3/cPKYJ8ruVSjpPiU3IF9dj5wh19e4cPwKoUxODHsk1HOMNg27lFIvHfiA9slXgsxNsQC1tMQUpSV8CD20Bi9Hqs36o8VeCe9rmy2YI4NG/aAi7Pbog6rXsMZx8jkTeCaAZCoOhzGGNsA+RhjxyEND5ZwiRtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGa6LwtAu+Q29WATQLJQpSz9yiO8r5niblyGghNLZkY=;
 b=rHii9h1HLTNBQ5JCS1zqADfWkWvUmkhwWzgEB1RrbizYla7I0QqdbvnW6oRhP3UAo4C1uOsuGAF2LJwyUMA9sOGU2UdbHnaxDfZsptCMss1wofjASU/C+M+s+E090xnuNLOEoo6VL7AaG5dM8vv2qiDHaet70Bu4ko6JvMZK62I=
Received: from CH2PR18MB3238.namprd18.prod.outlook.com (2603:10b6:610:28::12)
 by CH2PR18MB3208.namprd18.prod.outlook.com (2603:10b6:610:15::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 16 Jul
 2020 11:49:25 +0000
Received: from CH2PR18MB3238.namprd18.prod.outlook.com
 ([fe80::8ac:a709:c804:631c]) by CH2PR18MB3238.namprd18.prod.outlook.com
 ([fe80::8ac:a709:c804:631c%6]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 11:49:25 +0000
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2 net-next 02/10] net: atlantic: additional
 per-queue stats
Thread-Topic: [EXT] Re: [PATCH v2 net-next 02/10] net: atlantic: additional
 per-queue stats
Thread-Index: AQHWWr95QE9f+pmAo0i36aaYnt/lB6kJTk4AgADJtWA=
Date:   Thu, 16 Jul 2020 11:49:25 +0000
Message-ID: <CH2PR18MB32389D98739CE4A126F2DDE0D37F0@CH2PR18MB3238.namprd18.prod.outlook.com>
References: <20200715154842.305-1-irusskikh@marvell.com>
        <20200715154842.305-3-irusskikh@marvell.com>
 <20200715164438.7cedb552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715164438.7cedb552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [95.161.223.64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b26bbe89-9587-4ec4-f1bd-08d8297e4a0a
x-ms-traffictypediagnostic: CH2PR18MB3208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB32081B30035DB5D5F52DA4A0D37F0@CH2PR18MB3208.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3a7/xlRSJ10wdDicprIARSjoJaRd9IqKJwpnvBxxNesaG+CIrpMXuOOG1oa9mlmE0an1+MBj+z/PZpG1R7wtxOukY6SymfbsGRQ8SZXt151HLtHino709LgY0NjidPpDD55vUfhdU3676Nx1/x1Xmc6WUzf2q4E8ZOLAz7Zld1dbcRC0oBvvzWvbM1sbrFhPoeL8yGtxdgNAtzv6wlb/SJn1mX9AjSy2RebqH5i2JNP0BooDHf02xWc02yy14OYMB8s4eTZkVsMvDkKA4JdRkVBp9jsmsFHsMYTAWWozikq/WWnMTbFaJbM10tB24yaI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR18MB3238.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(66476007)(76116006)(66556008)(55016002)(8676002)(186003)(64756008)(66946007)(4326008)(26005)(86362001)(66446008)(478600001)(9686003)(7696005)(316002)(83380400001)(52536014)(33656002)(2906002)(8936002)(71200400001)(54906003)(6916009)(107886003)(5660300002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pACPJBcSINs/JFSvx2hFnPifLT2ePUcdNVcPpfqmK718dbiZU8bN4TJKq6EQ4HIkYJB9KHMPMaMSzVlCLssb/5fGRHWcFY4KJ68/dimDOe1RSAmrwXkEKCMnqdkOfBo6/SbAEN/R+PvvnV6t6NgfAZcr8TwZg0iwmMn8I/hb5sYge+RlZ1YxjXx8VG+7isz7HeTGUlUV94owC4VaPbuFTU47MazeX6EUzSXTY2D0XtM/tIuozEEu0eCmd+fW78mtZXydfLQZdAjT0MjjrXcaau/TcgmMj/c0GjOrlac/a+j/uAtFCoX1C8mifKV/c9O+IBI8SxP0Taaseu76tmcc1NfjDX7kN/h2yWFnz2R1LEIk+uYoOL8UWPOo3bz8J4TMmSoUXwINakeIjkegfSpkphE/7KiImIoepKmjv7HiSMcnIHwd7Zfz5KiqInma/+ljtp0Jy19PPpJ8nK0aBEbDZTs0uQmuOx0cvn+I1IeMKhc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR18MB3238.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26bbe89-9587-4ec4-f1bd-08d8297e4a0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 11:49:25.5915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ibhdl+54Co3sFVRJ8TAfqhaAOGwiVjB527d0Tf8eDbJMdh/GJ9y2VCZjP0WdcKKvTzfmE3OZzUdV6orwcsVywuVG0MpdKbe3ZIDjIylc1qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3208
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> +int aq_nic_fill_stats_data(struct aq_ring_stats_rx_s *stats_rx,
>> +			   struct aq_ring_stats_tx_s *stats_tx,
>> +			   u64 *data,
>> +			   unsigned int *p_count)
>> +{
>> +	unsigned int count =3D 0U;
>> +	/* This data should mimic aq_ethtool_queue_stat_names structure
>> +	 */
>> +	data[count] +=3D stats_rx->packets;
>> +	data[++count] +=3D stats_tx->packets;
>> +	data[++count] +=3D stats_tx->queue_restarts;
>> +	data[++count] +=3D stats_rx->jumbo_packets;
>> +	data[++count] +=3D stats_rx->lro_packets;
>> +	data[++count] +=3D stats_rx->errors;
>> +	data[++count] +=3D stats_rx->alloc_fails;
>> +	data[++count] +=3D stats_rx->skb_alloc_fails;
>> +	data[++count] +=3D stats_rx->polls;
>> +
>> +	if (p_count)
>> +		*p_count =3D ++count;
>> +
>> +	return 0;
>> +}
>=20
> I don't see this function being taken care of in the following patch intr=
oducing
> the u64_stats_update_* use.

My bad, I totally missed this function somehow. Thanks for reporting.

> For review it'd be easier to get the existing problems fixed first.

> Also since this function always returns 0 please make it void.

Will do.

Best regards,
Mark.
