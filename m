Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD3E446DFF
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 14:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhKFNG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 09:06:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32810 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230463AbhKFNG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 09:06:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A69tSrd002698;
        Sat, 6 Nov 2021 06:03:30 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3c5q2q8fdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 06:03:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nh1CSsDtMZmLze/TPY73Cw+O57g5nQZpmcv/Bn3MSTC2b6ioV5n2IU7jlFRtc9rY9ie6UzP7nTNDWSWT4V9hriW8Px3UpizXXolUoc2qhFrc6JSgwRRhyMFz6sISzC0zpn15a5Hpw56KKldcVaTikOzPM/MeAOsBGTto+f79fvbIlgYuISr+D0HGt/0eITX7BnqROxzPKAxeO4+O33PovcXNWg+R3as4PLfgx1vLRq9aOnEY0mDCC6ltrc6os2yu2lJJZf8UwX7JzHOmbLqIJ60K6E7oHFV3vGc0Fb654aAh5nywGs7Kv1dpEFn1vlx2FLMC6CAt10u8wwym2bLbzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25wgG9Q36SYCN8ZCldsMqeefcyTv5KIg+y75mvQt1v0=;
 b=ARr11hLt6M/SMY5hyP65o2ViHqvzcmpbofkIo71M0xx+NjRYCApJfQKjeWJocq/H/bAQqCxLCv1HifbFFFdRxhgjiVHBAibVnvU8h5FzwjXmkEK8rXzc0qlX16vzQyLQMNBRidZDL4OraJc4th2zkkaeLDBGMIg+Py6uoCoFE0lA8oEpmHGn1P64GGQZmlS+8NG09aOLzRjcXzYYWmR8IS8j2LoMRjgnm7kmqWaKSB44D7XTjrXlp5hvX6JXMEAhrTCt7ovyE/7a+FT3KaLWyBF/XDHuWHDvDCYGnn/6whW9dGQo0xXJ3LJUt7gPcbxVvLEj0iuq2r9TdIhtNIufPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25wgG9Q36SYCN8ZCldsMqeefcyTv5KIg+y75mvQt1v0=;
 b=qYPnkNRwZLHqaCRmFPOPL9+DL1tWXJ299Nc54bsL8IsKb+P0yxi8OfjwwwoNnvvwo5FJCPqFaxpogazIFvZmvCN1PFZhOs0smof8nI5RtBYr2j+J3JBW2DW1i7ujOZxTxoTEInKVNJnpI4ZItFF36mz7dCHFH48W1UKupF+D4uA=
Received: from PH0PR18MB4006.namprd18.prod.outlook.com (2603:10b6:510:2e::9)
 by PH0PR18MB3879.namprd18.prod.outlook.com (2603:10b6:510:24::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Sat, 6 Nov
 2021 13:03:28 +0000
Received: from PH0PR18MB4006.namprd18.prod.outlook.com
 ([fe80::140c:d08b:d2fc:5780]) by PH0PR18MB4006.namprd18.prod.outlook.com
 ([fe80::140c:d08b:d2fc:5780%7]) with mapi id 15.20.4669.013; Sat, 6 Nov 2021
 13:03:28 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Networking <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
Thread-Topic: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
Thread-Index: AQHX0w6xyCJOrLJ7hkyiigYWGFMFDw==
Date:   Sat, 6 Nov 2021 13:03:28 +0000
Message-ID: <SJ0PR18MB40090035998F6AA20C3058CAB28F9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1636031398-19867-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <CAK8P3a2nbEFGPRWKwjLYOz3wROLOk1SN-6Wd7-sNkaEuuid==w@mail.gmail.com>
 <SJ0PR18MB400959CE08EC6BFB397CAAB3B28D9@SJ0PR18MB4009.namprd18.prod.outlook.com>
 <CAK8P3a2zsuxZvt3ajzw4u6vpoDbei5xETiB-oCzx5FD4cq=oVQ@mail.gmail.com>
In-Reply-To: <CAK8P3a2zsuxZvt3ajzw4u6vpoDbei5xETiB-oCzx5FD4cq=oVQ@mail.gmail.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: a216500e-a294-84d8-76ae-f47d117a8f5b
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13441336-e234-4353-bd36-08d9a125d3a4
x-ms-traffictypediagnostic: PH0PR18MB3879:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <PH0PR18MB3879521ADC3E1F140300ADEBB28F9@PH0PR18MB3879.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U2vSSfRZvrKFUHcy5PYpdhVmaMOaxy3RiQbc1pXMNDHe1+nAPYwAOeTWL1PWnA/B4L3ty6pJjj+0PC4bJJ8Qev1c1RY2AXfjh+rRTFv09DDF6AaLyt5GsjvMaU2D0KJQfw+o23nWb+8LKtYSa/TMi/yIMMkHlkLmCZYlphx4AAdxXpEyBEi3MqDXCG0ZsYIpTeNRAIoMhsvzApmLcs9x5V3y0l177YyIf5jUSVss7ghytsdaXWHI2XjZVTiZ9mA4B6pQr3VNqTPXyTbs7Yc3OjsBesjXbErLumGdBxS7cQz1wIGRpX2CgMfvvF4FAOzI+C6K2J0EbG02qWSiF3bknyMaqCHFbo6VmCW/sfoD+nEM/IqnWUzg6a6BaUUIjRvgeJZ3iGJLBYuX01ij08F853IkOILbeghnfsOoiKeLafa8pyR68rzxcrMCrhCSB6yorX9bzPlHS05sfkvHIAopNaFq3R6axsu8qxDSaDT+qV31BCe6ShqNU725dI8kfo6cfd7XZIUe+tmCNhUgT64CMTQYP1PJfF4Aa3yeRuN3s+kqF/B0VJMuQd1hdRdkOwLX7Y5OJQQC66rTSOIX6x3exRoM4U9YHi05GSx+SB9HUqElInL/m+whuSQzNuQMHJvCHlrP2c8FP3Av0WVhvBcnUgJfek33I2H8CseIXj7SvhGwaGt5OanxY48YDpRoxOfQ/Ur6neQnagclFkqq5hm1gQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4006.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66946007)(76116006)(122000001)(6916009)(316002)(66556008)(33656002)(66476007)(86362001)(6486002)(64756008)(66446008)(9686003)(6512007)(26005)(7416002)(5660300002)(83380400001)(4326008)(8936002)(6506007)(508600001)(38070700005)(71200400001)(52536014)(54906003)(38100700002)(186003)(2906002)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jjZt6EKVQTDxbEIkID0d6SpjEgx1WGH21Tvpzj7+ktCT0S9zOXqmyzQA1D?=
 =?iso-8859-1?Q?O1b1gCN/c2N2IHV9oCk34n8Soo3YdmVtGEXTHOCh5m5qYSL9kTbfs/ek3j?=
 =?iso-8859-1?Q?w753nwTQDodHYT4m1bqftESHmAA6B5Tkbb5j6cnxAHOr8otsdBrhC6APVH?=
 =?iso-8859-1?Q?8jXifvyXKPgLzjj6th4bghuddglv1sQj6ZkehwRdo5tnTyKKxGs5B0W/5/?=
 =?iso-8859-1?Q?Eyk6kufsjtViqXB6XKdiUD9QVEJeA/3N6QjquK+SrGWmb0DHHojHLLCaqj?=
 =?iso-8859-1?Q?qR0vT1nWQjDSDrPnhSiEoNykDqgVUpzQkhS42w6xAw6vwmd7KRYmCKjbUg?=
 =?iso-8859-1?Q?eRRA+3wSz2cFMPunTmrYZcaFB4/rka57dp5TSV3EKn5p+eNPxPsYJhcOGB?=
 =?iso-8859-1?Q?/A/uv+WpxdcJU2fqg3KhgcJ5KxgdX+gbh1iQ+oJ04+NNm1is5ETtGP26oF?=
 =?iso-8859-1?Q?fgEs8YQRNR/SYaSDzQo0+XZRfnW1ihcpyzxt/pHsHNAd1/R+pCo4m25gTi?=
 =?iso-8859-1?Q?z/Oi+uUz0i/UMdyLv9mbjTe61MwkT9KqXjPObilPRIbx1PA2J2+CjaMUDq?=
 =?iso-8859-1?Q?mE6UECylO6TbbKpOGGj6TQ+tfWgzV/wUJdf4laUZVSU4o87N1tlTK+2lN/?=
 =?iso-8859-1?Q?LSno+vCKgncvIJYs9Wu6Mv5ZXrtt841Z5vP4Bk240edOcYmku+CwCF69IH?=
 =?iso-8859-1?Q?1JWdUUz2maZ4D8XaY5Tz3CXdDlLfXs/TOzK7aDI9h5wDNjcg9RT+Io6ZSQ?=
 =?iso-8859-1?Q?nT0sokjWKTgkVyXolYCv2ogwyi45xTaZcZESnA6TGvk7bYRvuLzXjQ9S4t?=
 =?iso-8859-1?Q?WVqYSZwoR6Qswv1z9stmoh1ggs6BYkL7lyNlNjLF3g1m3phkL91Ff6qjY8?=
 =?iso-8859-1?Q?x1KVYNIAC+Fs+Un4Yhlpb0OkTexnEOawcniIL1ssafQJSZa2pfVnpOtmwj?=
 =?iso-8859-1?Q?2+gsHTx3m3C7lRf64TrA9QrOVY4vnywLVwvzoLw91kMRKK8WTz93XLptHr?=
 =?iso-8859-1?Q?Tsa7Mj/jcA8a2KfLB93YHWi5PLU2Qfq0Uo6NZ0YLTNg6/M9iCvSJIs8p2T?=
 =?iso-8859-1?Q?4xtp8If4AU+ZyY19ZVL97mCmaq7VqKSd4XIayr1qE+Bc/ckuQSDsVeIWMe?=
 =?iso-8859-1?Q?aPfyZDFT/6FNESp/8bhxsYdW13iTZXuzLZWZ5H+mecUkWxjf/xdxqdH8c8?=
 =?iso-8859-1?Q?kKxKuKAYNBxCiY/kkDBLOe8eaicRVjztj4nDqFp/90TzBYt+LNwdOqww++?=
 =?iso-8859-1?Q?O0Yupf78wVDI1G4a9JtmLVFtXGgYqsnx8SBzZVRRPaTnSCGyMAHLVD0SI0?=
 =?iso-8859-1?Q?ZtozzKmCJfs4dZNFgGea+KBIgzVxeG+jeAhnrMaHeqmQ59mjEgXl4Z39BY?=
 =?iso-8859-1?Q?rNuvts/UfrMph0OSO8k695LuCo4k2b42XjdFIRzFmgLdYH4NCW+DlvSBLB?=
 =?iso-8859-1?Q?AV0hQ6c05xL3XNgnFEFThgGha3htfUXNGntpsZ97LLjbvLo4BRaV7kfRi1?=
 =?iso-8859-1?Q?P/C92YLbNEgjTdICkZduyjeVFthsJ502w0TrjoZFumEOganE5MzC8XucAb?=
 =?iso-8859-1?Q?mJD7P9ZdHDceBvcVLmSpYAQqGWH0HgfqyaB7uPy6jV7LpbTjwAgvACoV7u?=
 =?iso-8859-1?Q?Tck1OwxbtA6Mk7+X/I5rSGlctmwPAiyvqb44r+udSQHPTTLa075wYQkA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4006.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13441336-e234-4353-bd36-08d9a125d3a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2021 13:03:28.4404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kPUN0N8JgVuHnH7G1BY1MzmZ/hkoPyEeLcYFIIvs2m736iPnrkiltNCY5oS7YgTEflcJ4OFA8/hp+9C7Is2D1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3879
X-Proofpoint-ORIG-GUID: Zi3cD6QojYqTO2Z1rYExaSiRYp5bQeq2
X-Proofpoint-GUID: Zi3cD6QojYqTO2Z1rYExaSiRYp5bQeq2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-06_02,2021-11-03_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=0A=
> > >=0A=
> > > However, there is still this structure that lacks explicit padding:=
=0A=
> > >=0A=
> > > struct prestera_msg_acl_match {=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0 __le32 type;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0 /* there is a four-byte hole on most architec=
tures, but not on=0A=
> > > x86-32 or m68k */=0A=
> >=0A=
> > Checked holes on x86_64 with pahole, and there is no holes. Maybe on so=
me=0A=
> > other there will be. Will add 4byte member here to make sure. Thx.=0A=
> =0A=
> That is very strange, as the union has an __le64 member that should be=0A=
> 64-bit aligned on x86_64.=0A=
=0A=
This is what I get on x86_64 with pahole:=0A=
---=0A=
struct prestera_msg_acl_match {=0A=
        __le32                     type;                 /*     0     4 */=
=0A=
        union {=0A=
                struct {=0A=
                        u8         key;                  /*     4     1 */=
=0A=
                        u8         mask;                 /*     5     1 */=
=0A=
                } u8;                                    /*     4     2 */=
=0A=
                struct {=0A=
                        __le16     key;                  /*     4     2 */=
=0A=
                        __le16     mask;                 /*     6     2 */=
=0A=
                } u16;                                   /*     4     4 */=
=0A=
---=0A=
seems like the packed is added implicitly here. =0A=
=0A=
> > >=0A=
> > > struct prestera_msg_event_port_param {=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0 union {=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 __le32 mode;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 __le32 speed;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 oper;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 duplex;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 fc;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 fec;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } mac;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 __le64 lmode_bmap;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 mdix;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 fc;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 u8 __pad[2];=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } __packed phy;=0A=
> > >=A0=A0=A0=A0=A0=A0=A0=A0 } __packed;=0A=
> > > } __packed;=0A=
> > >=0A=
> > > There is no need to make the outer aggregates __packed, I would=0A=
> > > mark only the innermost ones here: mode, speed and lmode_bmap.=0A=
> > > Same for prestera_msg_port_cap_param and prestera_msg_port_param.=0A=
> > >=0A=
> >=0A=
> > Will add __packed only to innermost ones. Looks like only phy is requir=
ed to have __packed.=0A=
> =0A=
> I think you need it on both lmode_bmap and mode/speed=0A=
> to get a completely unaligned structure. If you mark phy as __packed,=0A=
> that will implicitly mark lmode_bmap as packed but leave the=0A=
> four-byte alignment on mode and speed, so the entire structure=0A=
> is still four-byte aligned.=0A=
> =0A=
> =A0=A0=A0=A0=A0=A0 Arnd=0A=
=0A=
Makes sence. Looks like I've updated the v4 too quickly. Do you want me to =
update the v5 now with the changes ?=0A=
=0A=
Thanks and Regards,=0A=
Volodymyr=
