Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FF42C0349
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgKWK2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:28:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727724AbgKWK2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:28:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANALemh013114;
        Mon, 23 Nov 2020 02:28:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=3MfMD9u7Vj4KWqTMVxM6HQmflUSQVFSMzTZlLqi1vb8=;
 b=d0cQHdcWJ4MjxaTU4/7JuJJOSPhJVRmq4/XjOUuzeRAMwAnLh9NP+83T0LcawWnhGnIf
 yMCJP+fJBbxiaJX9t1swTVnJ8uPIg6lFoavSJL4aWqfX7nDrXwsBhYw2e8cHq346t/6p
 p1mtJaHCG+I+pcxOET+YaBZr8Y1fLjCDsx7BVUWSNkfejrKi4tUY5DdGAjlnLTKNUS8r
 MPJdHJpcTssWWb7V7rss9cGpWi4SGOSPndMo0siJYI0aQ6ocD/srQZuxTLzRF93dugCt
 +lOpi7zoYxrN2hai8Go5MVIZ4xcFvN1KwK+H3jhK9ugsp2ZzLyEcj7ygH0/GvmPjFJCq pw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u5bna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 02:28:30 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 02:28:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 02:28:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAuS2+YpCTMnzKxR8OVAyI6a6nAfmveqKv7QZPxLHQlxwfXPLzMYraldJEFjU2Q+/wr6HP9qmfs76puw1F7GZFg2HWhalQhxu/teoWmj0tEx8Ro2Z6nSaaRhOav8j1NNDHUMbhRhrfa6csYy7OB7PMr64wxfInKUnmMcbL6ACZj4V2bg6AOcV4NnqnsUYdoK36q+xX1OzQX/c/NPlra18Hgo6d3jKHRFdd4hcoqKFDYsfugQc+oHpNdk+Eb7jXx6j6ONLX0tuuWmOdtTgOU6VC6VqbItI5unu71jGAmJ7mQ+taBE2YQDRhuvMxqFJULuN6fkkPIbsRVRjh5615D11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MfMD9u7Vj4KWqTMVxM6HQmflUSQVFSMzTZlLqi1vb8=;
 b=hjaeQk849FXlNV0O+rsHDB94I26g8RcZsrCI4noZhVnhUSP3t9+HFTtvNBMC0F4aFR4lha7oPNYYkMQxBrlVGawXYrth+o8GTxjs5Px2ffPi6JkuE7fOkUbv9ajhJKIxN4BCMxMcSzDYgqYlnKGoVlFCbSe3EDQaxVUwFWpaGwOptXbfM5NRXJSBuouuSj1nmXACApOI+XAbb+HV9fTzk7iirwFCSLrWS0sCYAhvxoDJPuCKkICHIPxvlMqwayVvE0BUN7ZpQqJ/GoFoDaDnoVEqc9Vkav05JO7LeeS59LzqsReVgC2hbjxKBH8dhTuG3AtFZZ/5syOJogExmu8Irg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MfMD9u7Vj4KWqTMVxM6HQmflUSQVFSMzTZlLqi1vb8=;
 b=c/6GWepVHXa2lCeW2nxr31UGKioqEnN7P77aATN/aX31vFp747GSnmbQuRaGNU5EuhimMAUuFOIh8Z0UWGGhaRJrudtadWmvCwEveXZgn+ma1ms/S6uBLMCJuQJpNcyxAJcQYDzeIh+A+jPxRpRcO0D2L4nZTJ9ItPbl9Ky0kos=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BY5PR18MB3203.namprd18.prod.outlook.com (2603:10b6:a03:1a8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.28; Mon, 23 Nov
 2020 10:28:28 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3589.030; Mon, 23 Nov 2020
 10:28:28 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>
Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Thread-Index: AdbBgtkKm18yCRXgRqiiXzaQQP+M+A==
Date:   Mon, 23 Nov 2020 10:28:28 +0000
Message-ID: <BYAPR18MB2679CFF7446F9EDA8A95FA1BC5FC0@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.68.99.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 702ccc4a-cb5c-43dd-748d-08d88f9a84d5
x-ms-traffictypediagnostic: BY5PR18MB3203:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32037A839681C721F1D0D21AC5FC0@BY5PR18MB3203.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SPmZ6+eOoHiY6m3cNdpObxXk2zqZc6km7TGgYXPYRMiHnhkNDSaaH2VHOoatheNDJ/ByZ/JRf/TTL0iKGfsXDZtT/27No/MVjjTpDlF7UmTmVpdI1c7h/T9Y1LaEqb5nhPBJu543U7pCYWdbkP9tI49p4bLuKaQKsBJbjxw89puSW5qbEdspUbi5p0AjnWBnNbISAvuPkSbHCQ/tIag4zz36wtrV7sLSRXTjzaCWUk43W1b2ZikA2rerfS0iqvY3k4APZhg7jT7KSOHy4oTkq/p0+0WtkeQn0WrGlMGVkqDSoSiEO898T8u4WO0BYF0tu3MwgstJh29k2sUVJ4wwS6JmjR+IOi5dTCIejK3VEQiSF2sfLLPvG3PUkh3Fj4VcbzGJ0iaRt4QfD1PCIMHb8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(136003)(366004)(346002)(9686003)(4326008)(66946007)(316002)(186003)(64756008)(86362001)(71200400001)(54906003)(66476007)(83380400001)(6916009)(33656002)(66556008)(66446008)(6506007)(53546011)(8676002)(8936002)(2906002)(55016002)(5660300002)(26005)(55236004)(52536014)(478600001)(76116006)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gJiQz7lk3U8P4zHiUtTsPOvuOZxk7Uf2a+9a2115iWzjemJjacKhvpE9OxqNB/q89ybb68mv1F9O/r6QoIHfPb5BTzdpJkZ+nsZZwd91uLzeCPuysSOtcRSiNL5goTxK+JUpzFZoNFn/rrM4/C33CVdg08BtcW1n++4u82+SsKSGKQe6a6YvWjhzvW96YcBKUaFYy3SPIcHDwFb2I3TbNDZdzSjR/w+53gFQDTgRtH1nJnTIlhSEYzDE6zAkIj1VSSsYQEojYq2uJulQh1AFwiP63PiuUF/lVTq0yvEbzQPp00AMS+I09ehQBfhXZzPdfPi2EhVLLbkr12hjwMtuLvllJiO12VMqhA+tsLu6Z1ZcNmJSmRPUHzPdEEbXBmMShexJpoLI2uYqlqBLSW2vVxR3Z6R9hdDqmCqKZQKAwXkTagn1uUUwwmGAdoOlSpvShRpnp4EKlq9jPfUl0iqLctEgeLsxVV286RivbteWLHqd89nm5tsetx/76tPE9XyI57yZiAws+7NTCP3qqvDVAsgBc6mDsOwwWBCspPyJLdwe0KlDGbjkMeNrs7x72l2KeM1YTdJjdLKStsaF5+3lUuupTDFMg6UyGth7PWFqkvquXPbmA+OjpfU6dhbCWLFAQATwwR8xg22anpdlXyLv999OAqGZuyzQTzk9/3s7GgEUApKP5fc64DWe/BU81gkEiMkqQBAmjHpASKzI3fp8eT65X53/hLC7Akeu76ZMTMDK15ggCf4OjU3ZywKaotc0L4/P1w0gfphfwlV3nQpLVCR6PnIhwx28PN6sZQ/kLs39uefeTj65DTWGPUthLYT0BI+qpq0pIdpR5MB6l2P0Z6vmsAkR4mOp4RkdtOXLfAV46AeuhcJTsQEjaXsBqfqg11NJJXsVDdUqmKjhnmgjCg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702ccc4a-cb5c-43dd-748d-08d88f9a84d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 10:28:28.7613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q4Dzd4eX4kohhSXieXOZNIcKMqMuXNgWhIgokLnaIGUwktUI9vbbBeLGorqY3976dic6aafzwD5oIbNOULKejg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3203
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_02:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Monday, November 23, 2020 3:52 PM
> To: George Cherian <gcherian@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
> willemdebruijn.kernel@gmail.com; saeed@kernel.org
> Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
> reporters for NPA
>=20
> Mon, Nov 23, 2020 at 03:49:06AM CET, gcherian@marvell.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Saturday, November 21, 2020 7:44 PM
> >> To: George Cherian <gcherian@marvell.com>
> >> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
> >> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> >> Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
> >> willemdebruijn.kernel@gmail.com; saeed@kernel.org
> >> Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
> >> reporters for NPA
> >>
> >> Sat, Nov 21, 2020 at 05:02:00AM CET, george.cherian@marvell.com wrote:
> >> >Add health reporters for RVU NPA block.
> >> >NPA Health reporters handle following HW event groups
> >> > - GENERAL events
> >> > - ERROR events
> >> > - RAS events
> >> > - RVU event
> >> >An event counter per event is maintained in SW.
> >> >
> >> >Output:
> >> > # devlink health
> >> > pci/0002:01:00.0:
> >> >   reporter npa
> >> >     state healthy error 0 recover 0  # devlink  health dump show
> >> >pci/0002:01:00.0 reporter npa
> >> > NPA_AF_GENERAL:
> >> >        Unmap PF Error: 0
> >> >        Free Disabled for NIX0 RX: 0
> >> >        Free Disabled for NIX0 TX: 0
> >> >        Free Disabled for NIX1 RX: 0
> >> >        Free Disabled for NIX1 TX: 0
> >>
> >> This is for 2 ports if I'm not mistaken. Then you need to have this
> >> reporter per-port. Register ports and have reporter for each.
> >>
> >No, these are not port specific reports.
> >NIX is the Network Interface Controller co-processor block.
> >There are (max of) 2 such co-processor blocks per SoC.
>=20
> Ah. I see. In that case, could you please structure the json differently.=
 Don't
> concatenate the number with the string. Instead of that, please have 2
> subtrees, one for each NIX.
>=20
NPA_AF_GENERAL:
        Unmap PF Error: 0
        Free Disabled for NIX0=20
		RX: 0
       		TX: 0
        Free Disabled for NIX1
		RX: 0
        		TX: 0

Something like this?

Regards,
-George
>=20
> >
> >Moreover, this is an NPA (Network Pool/Buffer Allocator co- processor)
> reporter.
> >This tells whether a free or alloc operation is skipped due to the
> >configurations set by other co-processor blocks (NIX,SSO,TIM etc).
> >
> >https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__www.kernel.org_doc
> >_html_latest_networking_device-
> 5Fdrivers_ethernet_marvell_octeontx2.htm
> >l&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DnpgTSgHrUSLmXpBZJKVhk0
> lE_XNvtVDl8
> >ZA2zBvBqPw&m=3DFNPm6lB8fRvGYvMqQWer6S9WI6rZIlMmDCqbM8xrnxM
> &s=3DB47zBTfDlIdM
> >xUmK0hmQkuoZnsGZYSzkvbZUloevT0A&e=3D
> >> NAK.

