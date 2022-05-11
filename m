Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C91D522BC8
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 07:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiEKFfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 01:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiEKFfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 01:35:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443E5244F2A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 22:35:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJsAlk2o92CLY1ZA8Hn1Sts3Mk0BjmjTazj51PEUwmfU/p2VFzs6hQE7hPRuf5Nfk9sBaWPtcuZ4lYYdw3yIsCxTWtU7nuh8D2cuF0Sb3v2r3Siguhl4hmmKvw9hddIuRfk4lGXmRyamth8gSAzUN3g+KKxxXpTRTQm8SJk+j5Rtm2VV3n+3lEqqjxUBl43aNJoFE4cr3dtllQECn2G1+gksrssmseDQ4fkP9NmfdFnhlGSr8hygx6kQteLjbrbGlCiO9hl8XhMqUmOuAmVv25GoZ93PzzF8WLtiAKDMaZX+is9QeuTVHUia/NS1ZRxr7pbiED9OfXfgjTscJwaQBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiiqK3t+Sger7jSPUSvlkpZycyQvAUjBhnLo5cUj/A8=;
 b=lr7SVMpKOmGXif64Z16XadRa03zuM8wH/FNzYUdaqS6gJe3d7QLDPR7E9C6iOjtU7Dr/wZk4tqLiBAeySy6Fo9PRrY++Ai7yHxHALNy/u3vzmM1VZJ9zkv0kiuvf8bWizmLh8KUP7Sw+Wt5RaQwMu6eCQUcQRFfwzqmpfchZZM9RL4UXU/zDrWHaPEYymR2cVVoZygv+INHs7XeQ6MSd4JkJPJhFw+K61S0fn3Kbpg13QS0NS/qaVnFrs6zZUoRb3bn9UzduNtGR9BGWr5jdT1uoKcjGRWsDbZwCY3Dn87BX2A9trZ5hUjTi5VXeQLVDPc/CEVZ25cXnkasaPRE8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiiqK3t+Sger7jSPUSvlkpZycyQvAUjBhnLo5cUj/A8=;
 b=qIW7OQsKgrmsGXkt0GzHIC0WcSfTvOADIkhrE6l3ilqtMFg6n1eLSWvure2wlLTRPs32WWnLwkveFsOofq1fjARIiw1nc2L98/4xTP4lbW4UaJGCRK7/smIVNxgwotcoCTYluKz+ePFy/mBYKZ2iekuogjvUKwf5icvZG+Z/b/M=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 MN2PR20MB3527.namprd20.prod.outlook.com (2603:10b6:208:260::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 05:35:21 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::5047:44a3:6942:3ff4]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::5047:44a3:6942:3ff4%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 05:35:21 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>
Subject: Re: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYX4JgQ9a90BuNG0u1i9lIsMx3tq0PTj0AgABUASSAAATiAIAABLMNgAAA62OAAM6lgIAFpSXGgACMzoCAAoLOeIAAAiff
Date:   Wed, 11 May 2022 05:35:21 +0000
Message-ID: <DM5PR20MB2055B826355ED50BFCF602C8AEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504223100.GA2968@u2004-local>
        <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504204908.025d798c@hermes.local>
        <DM5PR20MB20556090A88575E4F55F1EDAAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <DM5PR20MB2055F01D55F6F7307B50182EAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220505092851.79d3375a@hermes.local>
        <DM5PR20MB2055542FB35F8CA770178F9AAEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220509080511.1893a939@hermes.local>
 <DM5PR20MB2055EBCA16DFB527A7E9A32FAEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
In-Reply-To: <DM5PR20MB2055EBCA16DFB527A7E9A32FAEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98b0fb16-8342-4305-ac53-08da33100aa0
x-ms-traffictypediagnostic: MN2PR20MB3527:EE_
x-microsoft-antispam-prvs: <MN2PR20MB3527DBB1C4D6EA1B67FA8E5FAEC89@MN2PR20MB3527.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eXD7fvHgzOeQKWTdxnwQOjs68sXH+5LvI1j5ApbTFhuCSA2CSXCY/7I5YCvqMUMIAJa8oWk52mI3mv/K0M/vyXvSHVMWmdArIwzzbqx/jlua7MMWgOOrUaAFltoSPym0OU3K17c8QtjEg0j+w4MnS697uKKQtsFwThgEDrvFl9iuPJnfA9P5jrs+bFocJNIh23iy0vDUvwVJqrYBtfVkPED2SPHANadO5o9nCpEBdgM+riraFdkuug+OqaSRKf+uwW45trjT9dvHJk/Hq0RbhRbj890BWBrX28nVmfOZ7XFxnbsgWM5SgYF476Tb4L43s9JiyjgMm17AddB/WuAWtBCg/5eLSLIbycotFNyqoCY9MJXDSxiBGl1DVjDuyJRbWFSOSF8/c2ozPHPiRoaJrdDBmhjuUQnek496UuEIPVSOnsqioI8vLH/pZEvhcnINIW2TFxGP8uK6nUUKQYTkg4+YmsKVIaI6ARkHXZjnVDdegb/VEEEcrO0cW6TgCUpAd5tX9Zq9hN8gczavoEdN03/q0YZb5CAQAwzJnUs9knwOA6GioabROmaTDntkDLEwSAgfzTlDk8zzoQv1PKFx3BLpsdD4j1a46rIHBN78kAMMiS1G5YJmtZVzBKxCvVQF5MxEeOyZQ/orotRvtxe19/AUZqKTFtS4n0NzV3jMB7Oq6+0kgG1Mf2aiwsMwAucSZk2rr1DZ+Rwmv43085krrMOcEWHnlc+mjto/A66yUtYM6c2M11iJCI2EHMJN3bLcGUBGg8Y6cn0IOeYYyXX/1wn1J4WsoeEDb4Pt3meV30Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(376002)(39830400003)(396003)(366004)(186003)(83380400001)(33656002)(2906002)(9686003)(508600001)(2940100002)(26005)(15650500001)(55016003)(7696005)(966005)(86362001)(38070700005)(38100700002)(8936002)(71200400001)(122000001)(5660300002)(66476007)(64756008)(66556008)(66446008)(66946007)(91956017)(76116006)(8676002)(4326008)(52536014)(6506007)(53546011)(316002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?GQ10bi2V3k5NrJHi9eYP2WOz7BfxSgE+mn9pyDJrf+20lAmicqdt/Ea7Jz?=
 =?iso-8859-1?Q?bjWY+sv1MZrAiZlJtNsRh8xRo5aTSfkgP3blDc5KJGtWSq3KNcB3qfaD+b?=
 =?iso-8859-1?Q?Pz3NWXqGzlHpa76kF41NJjus8YnG9RNNa/289i5AoHE5IocjDd6TnvSK59?=
 =?iso-8859-1?Q?S8yKZkxMVLK2WU55FnbyHG7eIfOsf6uH+dZ1QtsFgi+Wfa3p+DGWlGEP2W?=
 =?iso-8859-1?Q?Fh7Vz8he5R8+nD2uqovy/h6bVWtge6QIJOplxZffa3k77ecgvvEjXF9TrK?=
 =?iso-8859-1?Q?phVJrUxmNonFbLGWI7MEeFnnQ90xU7yto8XgAwSTUJomx+NxD9ZeigeOF5?=
 =?iso-8859-1?Q?wRTbDeml6OK5d1l6YgMOIhyL6URTiYDBXnSIulgH3c0AgQcxzbQcxvD4EY?=
 =?iso-8859-1?Q?hFvWGwy8qdKk8EXEzeODrxPXUBGCQBNsJZmKNUPpvYlU//rmyDPaFVktSD?=
 =?iso-8859-1?Q?2HJbpgx1RCEelRsh2PXxkJSqOOFu6tbgD5KQUuOAMf0TQFTZ6fgPRbdkUi?=
 =?iso-8859-1?Q?Zdsw94yIo+hP9NBUo3mqKT8ANHoxatT1q6PEBXUNb8ANldBlk88otg52v2?=
 =?iso-8859-1?Q?0+H7yogp0HEU+ZyyH0XohmVQMMij1jJ206GxHRVVyo78sKAcazGZ4y4uRA?=
 =?iso-8859-1?Q?YZxpdtslTc08xZQWF8ts9x6ZJTAwCyKyOQN7H7+bTpvhhHY4ylLrycm+ZM?=
 =?iso-8859-1?Q?SDIpDkN9Kgfuq12s/4xtoeAvOYEEF3yFiGvpJRB6Cn5MF1a4AxBPgXPGml?=
 =?iso-8859-1?Q?ezRzMsQvE+F3hb96l1Y4GDLtAgB+IYHht4xtqy0CPTtZd9gBjXNA0j99wU?=
 =?iso-8859-1?Q?7PVUkbUXRNQWlSv5y9ZnZOj2YYW+8YzWty9zzmkFllBDGYou8L76ciKx4K?=
 =?iso-8859-1?Q?pNUTKUXjhYYlstkKC8xF3mUWZU5giW0YATKohG0oKo1bhEOrH6T/t45KXs?=
 =?iso-8859-1?Q?yFKFhbhQEhp3s4vTqwRCO01uobRZEHy9iRSFf5Ow9K2lmdcFXyTlaYFqjB?=
 =?iso-8859-1?Q?RlOi/PWV+gorOHr/XR2jmcNPTLR5oz5P2uLbSBFO8p4qOUsUvBxnGwzrVP?=
 =?iso-8859-1?Q?Yp8dhBLpX/Lu0d1NODfr1QeFrOWnY7sGtojVQLe7py8lBNu0Yz5LdmGhIP?=
 =?iso-8859-1?Q?uPmpgotF0qYNfQ+ONaf9m/Mw7npUBNmqEVhl/vcxEgJPXll2s7wxMUy/kv?=
 =?iso-8859-1?Q?ljSKKSfNmV7u7j6rjhymX9pvJjy049bjZV4amArCtUeduNrjkndG2i7xb9?=
 =?iso-8859-1?Q?7bIM0mED1AZsIaphbmj9etKkvHkuCbxz1mdJRIze4FuqbXY0XZ66tE52+A?=
 =?iso-8859-1?Q?iCvbP1QW4SDXnLODk3EZBS6y/57nGabc2roMMYQnzhf3zsS3wQIMgkGOaR?=
 =?iso-8859-1?Q?B3GSWDMZP+efrtQt0FSzQHeY+NbBLVkQvX6S10cSQSf6rHlAXqQIyFwtIS?=
 =?iso-8859-1?Q?P5TqjtW9hGb8Etjz3ymk0HQj/gXtjDGRv00iQoJ8/ynMitT+EpZoPmRBJ7?=
 =?iso-8859-1?Q?fWkD6wwn0D0fNRakvUMUuTiuy3dh1nkHxDo9hVEVVyY7/l0HmPWccUXcXv?=
 =?iso-8859-1?Q?kicGpVwrxCrOOlvREfYL7raErDRd8iMd2UpudVBdYYMo4YUdItOHXvzKB1?=
 =?iso-8859-1?Q?wvkB+y3GUL+HK+nhDNbdpnW/TKmI1/cmZR9Rk2tIfgjJqrugLB5c+S8HLj?=
 =?iso-8859-1?Q?9OlJUqO5U/fyB5yj44y/y9yIxwjUutDhzTYR92hqI0BhG0qZd7ouhp898X?=
 =?iso-8859-1?Q?3nFX6m9VNOEtvJIAVX+u+hVoqzgLuoobqELSjJmdkdw5yuvX8d7kM4NM8K?=
 =?iso-8859-1?Q?a4rifrcCqw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b0fb16-8342-4305-ac53-08da33100aa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 05:35:21.6829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E/+pUx3aq1iIsoqapx/vcYB4b6w1LuqsWXOHcAZ+UaQ2m0mT4ioVbayjW+nCBa8Jza3R5SxZjp/5StujNU1sAaeRSh2tUhNoxAvJd4teGdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3527
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=A0=0A=
Hi Steve/Dave=0A=
=A0=0A=
Could you please confirm that VPP during synchronization of routing table w=
ith Linux kernel in case of dual gateway ECMP configuration gets only singl=
e route in the netlink message is a known bug ?? =0A=
=A0=0A=
I am using VPP 21.06 version.=0A=
=A0=0A=
Regards=0A=
Magesh =0A=
=A0=0A=
=A0=0A=
=A0=A0=0A=
From: Stephen Hemminger=0A=
Sent: 09 May 2022 20:35=0A=
To: Magesh M P=0A=
Cc: David Ahern=0A=
Subject: Re: gateway field missing in netlink message=0A=
=A0=0A=
On Mon, 9 May 2022 06:55:46 +0000=0A=
"Magesh=A0 M P" <magesh@digitizethings.com> wrote:=0A=
=0A=
> Hi Steve/Dave,=0A=
> =0A=
> Thank you very much for great support and sharing the knowledge.=0A=
> =0A=
> Dave referred me the file iproute.c but this contains the flow from user =
space to kernel.=0A=
> =0A=
> In my problematic scenario, the use case is from Linux kernel to VPP kern=
el and this is where my parser at vpp kernel is not doing its work properly=
. The VPP stack tries to synchronize the routing table information from Lin=
ux kernel through netlink messages.=0A=
> =0A=
> My file netns.c looks like the following:=0A=
> vpp-netlink/netns.c at master =B7 Oryon/vpp-netlink =B7 GitHub<https://gi=
thub.com/Oryon/vpp-netlink/blob/master/librtnl/netns.c>=0A=
> =0A=
> I tried to implement the parser logic as shown in the following link but =
that did not help.=0A=
> Parsing the RTA_MULTIPATH attribute from Rtnetlink | Eder L. Fernandes (e=
derlf.website)<https://ederlf.website/post/netlink-multipath/>=0A=
> =0A=
> I see only one gateway in parsing the RTA_MULTIPATH attribute inspite whe=
n I had configured dual gateways.=0A=
> =0A=
> The existing code in netns.c works fine for single gateway ip route confi=
guration and it fails in dual gateway ECMP case.=0A=
> =0A=
> Your help is greatly appreciated.=0A=
> =0A=
> Best regards=0A=
> Magesh=0A=
> =0A=
> =0A=
> Sent from Mail<https://go.microsoft.com/fwlink/?LinkId=3D550986> for Wind=
ows=0A=
> =0A=
> From: Stephen Hemminger<mailto:stephen@networkplumber.org>=0A=
> Sent: 05 May 2022 21:58=0A=
> To: Magesh M P<mailto:magesh@digitizethings.com>=0A=
> Cc: David Ahern<mailto:dsahern@gmail.com>=0A=
> Subject: Re: gateway field missing in netlink message=0A=
> =0A=
> Have you considered using libmnl it is good way to handle the=0A=
> low level parts of netlink parsing.=0A=
> =0A=
> https://www.netfilter.org/projects/libmnl/=0A=
=0A=
=0A=
Have you looked at other routing projects that handle multipath like:=0A=
=0A=
https://github.com/FRRouting/frr/blob/master/zebra/rt_netlink.c=0A=
=0A=
=A0=
