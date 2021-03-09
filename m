Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BC5332198
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCIJHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:07:55 -0500
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:28700 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229639AbhCIJHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 04:07:46 -0500
X-Greylist: delayed 5381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 04:07:46 EST
Received: from pps.filterd (m0108160.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1297TMFb007113;
        Mon, 8 Mar 2021 23:37:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=jOifBasssjS2uUrhWD0DIcvMWhKwU8zgtfOzD0tfnes=;
 b=CuFsiip/1lpvVpyW/iVVrqTlGkWLWcNwpFKf2lkJCzSbmKDEhMb/wsyok7v2d3GpUIqX
 SKxkb8LYkOcG47RvjQBvFGJoPfLs7yx1s9eBDyEHKsP8ce9PcpnZz5STsHkF6jBwXSZK
 eK9SEqD6K2Vm1C29RV0lyv2ti/M6noYNPb5bFIUqnwtd0zRzSp2vUJjDc03lZ64pzhUH
 d24xZL7C600yphVjdykD/vQiRgkWud/06Nf+hgrJ4I+ClNBZg3W1r42XAhSlqChvpEgi
 Pjkqbw9t1z7Yap9EcbVxgY7FGzay0E49X5s0udxrzdR54JOwIlTM9e/F+s7gvVCqm6Xs 1w== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0b-00273201.pphosted.com with ESMTP id 3748hq4ebs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 23:37:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8wmaTDS1VOAXsAUd7p5/mzM4xAG1TAnL1b90byD72xe+0fY32tI0eGGKMofvzfTEkQM/wu9utHb0o51FB+YX/R1+Ixr+yhTU2+cEVmOvuD3be9yawzAQ97/aMpqgumKuINdhHxJtDgyzAIakx8PIS3wHtB5W/AUq7thwX0uLkDIbyXL1xbLAbgj7IHLL4WtHoQ04pCnCiQ+9JODGf9sL6koqw562M4ESRYqjbeFek7pi7Wy4TqJqJt+k7nXkpmzSymr6HDe3gZEkLe1vkRwXg5c+wfXOF2Qv/tvOQzR1LOE5V4g8RdqLvi5E23opKuwkHqqPbEFRLsfFMB2ET+CnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOifBasssjS2uUrhWD0DIcvMWhKwU8zgtfOzD0tfnes=;
 b=mRNhgDFOOGBTIlUi5KleX4jZopUBZXLDWiYuwrOM5NSz8A+1MBlHhce7ZtYRm+zCYMUXukLG9bmcXCfbA+XIYQJB3gsbAW0iyhCxwK/djxmkppchAHV8Ibz3495gj4ajkBrZeuWkH0iijzl6c/vqeLwVgIl0kG5EUExNZfXSUMB1PrxtBUTCZeDc7Y8p9RFOd64XVt3SvyG+1BGw2zLuGVWQE8bg2lqFmoAfhdTbv0jR09EakKBkLIUdQlJ+OZF7lVXeBIOTgeMD3aS4r1VCfhx0EbKZdneT6wHvFsXpwV4pMM8HOg7COPLKz36avHzGv94Wh/00Z8/O1TWvnzktXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOifBasssjS2uUrhWD0DIcvMWhKwU8zgtfOzD0tfnes=;
 b=SVPI4gjLojy8i568ODuiGjxGwMYaZDMYYpN5bMNzzwcXYIkxgMqYAUkzzWDKLn/DvBbACLXnBudQWfJvSpGTA5lnPfIz8PfVhNiBuqMkJ/N3wtbERRyhmfhlXY5//R/i4wK4rbL1Ix6qoq86eYl18HhT9ajFI5rf3M9aA/aW9Zc=
Received: from PH0PR05MB7557.namprd05.prod.outlook.com (2603:10b6:510:29::5)
 by PH0PR05MB8123.namprd05.prod.outlook.com (2603:10b6:510:7b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.14; Tue, 9 Mar
 2021 07:37:52 +0000
Received: from PH0PR05MB7557.namprd05.prod.outlook.com
 ([fe80::78e1:dd76:d044:cc77]) by PH0PR05MB7557.namprd05.prod.outlook.com
 ([fe80::78e1:dd76:d044:cc77%4]) with mapi id 15.20.3933.029; Tue, 9 Mar 2021
 07:37:52 +0000
From:   Girish Kumar S <girik@juniper.net>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@gmail.com>
CC:     Yogesh Ankolekar <ayogesh@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Linux Ipv6 stats support
Thread-Topic: Linux Ipv6 stats support
Thread-Index: Adbwgr8u4N5xFmsnTxSVI8od1o1wugCgDrtgAAJ2n4AAPA4JAAgodQYAAAXpUhA=
Date:   Tue, 9 Mar 2021 07:37:52 +0000
Message-ID: <PH0PR05MB75578E6D221043E4D8B16FC6AA929@PH0PR05MB7557.namprd05.prod.outlook.com>
References: <PH0PR05MB7557A2136390919FB11B6714AAA09@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB755758D4F271A5DB8897864AAABD9@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB77013792D0D90212B1AA0D9EBABD9@PH0PR05MB7701.namprd05.prod.outlook.com>
 <a1c21b7c-c345-0f05-2db1-3f94a2ad4f6a@gmail.com>
 <20210309044424.GA11084@ICIPI.localdomain>
In-Reply-To: <20210309044424.GA11084@ICIPI.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2021-03-09T07:37:50Z;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=0633b888-ae0d-4341-a75f-06e04137d755;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ActionId=7a6f6905-3bbd-466d-9668-0a6e46c4a514;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=2
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=juniper.net;
x-originating-ip: [116.197.184.14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21b10e89-fbbf-4a5e-c1c6-08d8e2ce3f47
x-ms-traffictypediagnostic: PH0PR05MB8123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR05MB81232ABA0AD9659210C846E7AA929@PH0PR05MB8123.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sid6EVsg3TRI0FclKU67tVbEctHv0V7dI36GkOkkGBdxUVINcyOBgOVZc2dOPLGgRYrqNLzZV7dJBoF3CQOb3nMVsgiC9FQtFoF6PF8fhVE4Qqeft/2rxaPnUUNhXIqoti/EXcH8V8ZRPLbCMLc4VGsOuzEFYQCTv4JGvgDY6YHlazyLHnvTdp8Wn6Ex1pBWKYCM9iLzs8HKe9TM817ZgrzmM5cyNzwAImPYuBjeXYydMs6+lOdnaF32zV56q/IMGLuesNriHfp8oCqKiqzOb8M6vNMv7bPX12JL2YDD1zvFjowc/ve6PXv/yyaRoZCDhpvXY2k8KdVonNMJDkQUXC+THv+/Hjz0p5rOsAsXLx6kbyWbVF2KQXeYpPKmXzd3S5SacEdtri9iK2oCMoYJwrlr/XZAJ80FqPCvv2mDwjvhQZIdIOqops6Zr1tCjIKBW1grBvpp9p+zczRGXJQW59a7SALooktg2js9YeeN8AJLSw144aKyhFmeFwApp1oGuwu1pZ+ZpRgxLLrKlSqFoLaMvR0/TD03eIv9UX9jRQjy3gXzrJQFxrTgFP/iGRko
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB7557.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(76116006)(4326008)(186003)(5660300002)(110136005)(52536014)(64756008)(66446008)(19627235002)(66476007)(26005)(71200400001)(86362001)(33656002)(66556008)(66946007)(478600001)(9686003)(6506007)(53546011)(55016002)(2906002)(7696005)(83380400001)(8676002)(8936002)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ohnvpE6DRGGqB6ElmzcQk1NjVddok2AEKjvBXm/3L6M8Nx+25tNjB+H25aiP?=
 =?us-ascii?Q?A7U8aStd6p3Ihbd2XDTlPb1/uqoXFu/3NXXyqKgrZLM362MOQnK2bgj3yNc/?=
 =?us-ascii?Q?AUlIha0mjnjpk5ir/ZZOq+6aKbTHZ5PhOza6BvxCOAURZzW5RGxMyhU1VN6G?=
 =?us-ascii?Q?RB/NfagjUoWq51WgJONZ8zy1wGfSY8ZztP4A1e9YPiZCN25rQAVdx1WxDF9R?=
 =?us-ascii?Q?2XXUetZ1NjKhAN89vxeioAcLfJFpwTgV1vkc7g70IWJVw5zdLHSzfFWA11vl?=
 =?us-ascii?Q?SHkzrcT6hn0lgAu+VUMlOtTM5ByZ+ZLmMCnvj3ZYOg08NL7ZfemDArVoSGmZ?=
 =?us-ascii?Q?7L2O8jRXgZS5htTFx/sBrq2K2ck0MqrYGv31947ztaQ2e53clqC8APGN9s+Z?=
 =?us-ascii?Q?FOYeMmjD3A3InDMBcKujqhtkW3/FprqZyGGmnDdrhNuUwfZpQBc0JlPjFBf2?=
 =?us-ascii?Q?2PHWw0XoJN4MJAuShhhb7xsOGeTpwbS4tqMW+wmqW6jUM5hDlQKUeND7s/AJ?=
 =?us-ascii?Q?uLsqCj+puT+zTlWZtmc1A+nzPQKwIJk3WXD41a9za0+FcfNk/bqZJE1esV4F?=
 =?us-ascii?Q?YBmmXH+tjKF1wjjawOMbD4JWETUHk8t/XC1DdN7LvcMD3eNiqMGTwImGtQUo?=
 =?us-ascii?Q?9P9Fskdi/nCjD4/2q4fZuFjOLROSq8HY9puYMbPH21TgoUMXMGgOkb3mNkI7?=
 =?us-ascii?Q?73CHp+pvhyHMMO4mDYBcBPicHx7sKIloQmdIO/rEI4sjHDT/F5Ch364vmz5D?=
 =?us-ascii?Q?T0N0l9fuj5+oTTc2POslLH5B/fPHzvTyON2OnUfaflJcqc56kTAh/F07ML/9?=
 =?us-ascii?Q?BS3RDbZudK8Z9gFumV0IJS6UL6wnTjGFghmt7+wyTOjEh7E2EUt7Lu9Hvt0S?=
 =?us-ascii?Q?jQxd7GZdAhjxWM+NUETc4zxx5BaW5UHVjc82/YG7ATrll7wIv7CfpVsRFBJ4?=
 =?us-ascii?Q?CloRNCW5jO0D9GmmVx4p7kGr0u9HBVDM7+qIrVkeQrJWSbRbzp6LmWFb0CcB?=
 =?us-ascii?Q?cY57w4kdydg8INtfGA3X0rkONz6LiUQGX0r4H5ftPfMukVDSy+lH01iCmo9m?=
 =?us-ascii?Q?sCz2KuL2pRJ050FYQUQfnxZmxiTD8iJlnXUXCUzGQ4eNBVoGHdoyaLuE2fpt?=
 =?us-ascii?Q?UdyxFKSaRBfFdsnDt4IUNzfEZEz5G8d8UNci5M/ig/gGao5+72RWmcrP1NV+?=
 =?us-ascii?Q?y1a90gPsMlDrH6+W35IPUz9S5sYwIXyXofO4jLaBaU8QOcVIFubRR4wuHtQo?=
 =?us-ascii?Q?UKzsP5goU7y/5CSPMJwa5/b57hoU2tVC6Vc0esi03xCkDENhtFdTY65LcNyE?=
 =?us-ascii?Q?Xr/dvyMUwhBPCSoS2mHg1K6O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB7557.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b10e89-fbbf-4a5e-c1c6-08d8e2ce3f47
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 07:37:52.4757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sR9PiLsUo6I0OLR+Y0SF0qybiDJQAOL5K0QhKteKF6yIyWIZ++/MLw9mzZ8+sNwFGhIsEEyUj4jxz7t+2cQTjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB8123
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_06:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1011 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103090036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Stephen for replying.=20

   We are looking for below IPv6 stats support in linux and currently these=
 are not supported. Will these stats supported in future releases ?. Please=
 guide.=20


jnxIpv6StatsFragOverFlows
jnxIpv6StatsInHopByHops                =20
jnxIpv6StatsInIcmps                    =20
jnxIpv6StatsInIgmps
jnxIpv6StatsInIps
jnxIpv6StatsInTcps
jnxIpv6StatsInUdps
jnxIpv6StatsInIdps
jnxIpv6StatsInTps
jnxIpv6StatsInIpv6s
jnxIpv6StatsInRoutings
jnxIpv6StatsInFrags
jnxIpv6StatsInEsps
jnxIpv6StatsInAhs
jnxIpv6StatsInIcmpv6s                  =20
jnxIpv6StatsInNoNhs                                 =20
jnxIpv6StatsInDestOpts                 =20
jnxIpv6StatsInIsoIps                   =20
jnxIpv6StatsInOspfs
jnxIpv6StatsInEths
jnxIpv6StatsInPims

Regards,
Girish kumar S



Juniper Business Use Only

-----Original Message-----
From: Stephen Suryaputra <ssuryaextr@gmail.com>=20
Sent: Tuesday, March 9, 2021 10:14 AM
To: David Ahern <dsahern@gmail.com>
Cc: Yogesh Ankolekar <ayogesh@juniper.net>; Girish Kumar S <girik@juniper.n=
et>; netdev@vger.kernel.org
Subject: Re: Linux Ipv6 stats support

[External Email. Be cautious of content]


On Tue, Jan 26, 2021 at 09:05:22AM -0700, David Ahern wrote:
> On 1/25/21 4:26 AM, Yogesh Ankolekar wrote:
> >
> >    We are looking for below IPv6 stats support in linux. Looks below=20
> > stats are not supported. Will these stats will be supported in=20
> > future or it is already supported in some version. Please guide.
>
> I am not aware of anyone working on adding more stats for IPv6.=20
> Stephen Suryaputra attempted to add stats a few years back as I=20
> believe the resistance was around memory and cpu usage for stats in the h=
ot path.

Sorry that I missed this. At that time it was IPv4 ifstats. I'm missing the=
 rest of the context here. Which IPv6 stats are being discussed here?

For my company, we have been doing the v4 stats using the implementation th=
at I brought up to netdev then. It is useful to debug forwarding errors but=
 it is an overhead having the out of tree patch everytime kernel upgrade is=
 needed, esp on upgrade to a major version.

Thank you,

Stephen.
