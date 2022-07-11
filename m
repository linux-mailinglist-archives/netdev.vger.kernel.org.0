Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239C356D285
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiGKBaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiGKBaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:30:03 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B666F646D;
        Sun, 10 Jul 2022 18:30:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIhCckIEuo882b7sIcnMMKSSQ1DurMjh0s4nDiFKPE08OvFn3HLuSagmeRnKT1AmT5bl5t8Y+XnL6zgQWIY86dogRFewspPJADP3y66tLYsgXuwQX2UxJZHod0w8ktt45E5AZVgNBDFPF+I1EawwuIs9oGPlkB9hqHdaQxX6YUP0M+b7UyzyaccSI7Yf6VAw/ZT5YSRwLnjz286Alx1hgGxpr0SEzMxx+0iqeNjWq/u8S85MJFDa5sgPlF9VOUUK4ayR7PSeIMrkfYPYaWbRYf/ajln+pIO+HIuIHseh8UmSMad7CfLusFG6ll1MInSzaICuMhvssikqa/l7EH9FrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKDFVQacE8K9KmklC4hYqrpANb5xBeEym9Hi0q6HNWw=;
 b=WM/0jBgNyJV48TGGneBc3fphvsGwPm9D12AfWBKuhQ98rtNiWZRzvfaHoDV2wZfxC+rhFNsMF6fBSMxLvZzJ11DqhjSMfG6G+IhT6sOoHWS8bP57g/JDtyQWCtdna/j6mFpX/dsylewPVQ8M9vQSy6zDUFr0pYpP3RlH66qr4h42DYjeDG+F3XbTWXOI0ptnymTH1sWqcCZLuODVc0MWcB5/96w9+4NsRPpEnX4UsJmAtCHjQIaA0Lm9lED2NmfQ0c7BUI92I3Tec/Qj32BTOI01fe9T1INRdFvsXHM62ZtLiU+5GMdoGvqc+Qk02b+XO1cyg30UEg1m9KgUh5H2dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKDFVQacE8K9KmklC4hYqrpANb5xBeEym9Hi0q6HNWw=;
 b=P1PwZlY6RT0J4AaoGOzrk9TNYyTxU/NBRrv9909IMiSddC4mjrJftbmdTiik4MLKONVWi2xlr9JkD8iUrMUOdS70k6lWciO9uyARLf6bBWiiAV/8noDldLdlOoPXBRUaNlXJWu6FaHTU63Ad04x3IA5EtXhDiuXdBqUxQ2zEdyk=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SJ0PR21MB1886.namprd21.prod.outlook.com
 (2603:10b6:a03:299::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Mon, 11 Jul
 2022 01:14:09 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:14:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 05/12] net: mana: Set the DMA device max segment size
Thread-Topic: [Patch v4 05/12] net: mana: Set the DMA device max segment size
Thread-Index: AQHYgSXZYMrx24u81kKJp7vYJYUL5K121q5Q
Date:   Mon, 11 Jul 2022 01:14:09 +0000
Message-ID: <SN6PR2101MB1327D402FCCB24994DAB8D8FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-6-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-6-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=705c6180-2949-44c0-997d-5dad64f269da;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T23:34:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db456cb6-b00d-40e4-0886-08da62daa888
x-ms-traffictypediagnostic: SJ0PR21MB1886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 59ddHbvQbx51Vn/vzdW5JzghcMcTEw3ea7gN//ANTPt2n+Wp1SQBN/qfdh0F6KlW5A5CmmOBZ2dwzDFgjmwbIYfYstFpyK74rJiu46NCtKDyDoGbkswHjmz798rv8SD97I/tTShNTr4riEbN9ykg5abevmf3KoGYWJx6fDxFoVeeFPajVgS8qBmBzB4YhhbvaRZpugqVsUzfvLCjbhh5ArGeJp+u/ajP3xzXoK/waKX1KmzrqJfBoKwfPjrNH8EkG+JB2W6Q3cFPK8wJ1Gz/mkg2ExNydGScAReZwJ4mjRs6rOiP6jP90+eX0p45rNyPl2f6UcPv0laGpHXJ+hYCKqWBNfqPr2SBCYD+8h4wyJoZYDfQ4k1HjCbboRSNYknj2H3AIBUFLn0XONhITvGe4r+ZZTxdRx17PVk0tv+0kBKhoSgEwA7YN5h4FIu80+0gG0CT8HML8+6ESD3Lq1paAC5fMW+Y4wURv4K75Rc9EMTArNuAUVUMKNflRaeEAqQlasMIJYOXLqfyDjy9R0g74POsutPsy5Dwu9x8w7z6e2BG5s14mavK3EENFTp3Op79Yufcm+Kzqyy+8GKomxaARTV6aBaH0FAdB9kdX+layWIEny3di4+no0712B+zvmwl1ti6dKL0M/7gwEMYVeB3o6TicORyUsb9QTDanrBJG1M0UcG5pdN1vOfmc2bkJ93YWnEFQgJkNEWyItfDFE2tHWuTe0Dg4FvY11wyqqfB8zCI1a0tW9ct11SdsMVuQtkqcw3t0eogI/l2ZkEa4leSWYaP0PXdn1Afs10Jo8qAKHPHZJ2nFgPy+Xsvw/LQsd85TrqNexGGXm1Vi1aVDX/lwTjiR4nHSe6vD8NE2m/LwlZblAafdAJ9oPxlg3CuN3jV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199009)(33656002)(186003)(26005)(7696005)(6506007)(9686003)(8990500004)(82950400001)(38100700002)(38070700005)(122000001)(86362001)(921005)(82960400001)(55016003)(558084003)(54906003)(110136005)(6636002)(478600001)(8936002)(52536014)(316002)(7416002)(66556008)(66946007)(66476007)(76116006)(66446008)(64756008)(4326008)(8676002)(2906002)(41300700001)(5660300002)(71200400001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?umNkx8jmiQRL4hr/Js04044E9nUDBWxJdatSz8mCbgSwWdxBOI/eHrYbr8cz?=
 =?us-ascii?Q?B8uIDWxaPgCz6kAVtBKJGiFdysR2RXSXOGawcDrzBrxxM9Fkef5A+Ozu4A90?=
 =?us-ascii?Q?66et6bvvG4mZ6wYQIuEtWvafJgHTgYbmT6cp27ffohEWV+T0q3+LkDxwbiFR?=
 =?us-ascii?Q?NZ92cevNXe1ARr1Bt76530n9QZp5dohz+hM1kzxQKfokvW1S6Yl0fk+I1r2V?=
 =?us-ascii?Q?LuxcpqOfkTbiGEhcDT6s8RuRe1KUe3L+6BhJfAnnHRnNcrrYnuSM1+B9AILz?=
 =?us-ascii?Q?XrEKw9iwharoHgKqxTcdzDYe4y9PecrYYbGe/wJH3p6rhMbyBgNTQKEeDZ7v?=
 =?us-ascii?Q?Xn65UDTVxluvwS2x8lQj1+j5I+a/hcs7WUFlX/8xGsWu/d3VzmBFk3fjAju9?=
 =?us-ascii?Q?PahSsR3tlHqgVaYc/Vx1wkROt22ll218F1g0TbiloBSlQnwss1SUndLVHKm+?=
 =?us-ascii?Q?UfKEHQiN9slfxxUzu2LvQ0gm728tO18ahWlxT4tp4L+ucJonsugBMqUu2kFT?=
 =?us-ascii?Q?ZcQHnEuUFtg2qoGvI1cj688PiJTeUntB1ZRQoUL3H+Terru0t91h3gX0Ixwu?=
 =?us-ascii?Q?GQlac73ovlAAv0iI/YVbcltCwQtRUuRb43j6UBGnTFxM2UoQ04gyEMWZ3rab?=
 =?us-ascii?Q?+r8txJ49ErCKW9Yt5qt/mAh2iUG0qE8/63CBQxjp10jR4i6+rWBDmAAWfxti?=
 =?us-ascii?Q?gjdEFG3dS5y33qJKch6EitoFShOpWYKLeQVW7L8d4++qMyY+amAi4T8k+Q6w?=
 =?us-ascii?Q?je7IuLLCFK+i3Iz2qTCpZbhGQRgk3p7CxqFNLnARs/0+rrtl0vK2ludEqQH+?=
 =?us-ascii?Q?DQQIAoVPc8+Takjq8rxNSeg8m3YH0KoVnDVAr4PU8knYmvtF99uvADy40Esy?=
 =?us-ascii?Q?MfpKO+KyphCGJVyqxMz6V/tCzVEG3jzeOuot6XVAFO31hbbVGwRQGXJedzys?=
 =?us-ascii?Q?CTS7/Hhd38vqyki+w0GfwAmamQyiHww5tzE1F4fKRTOSJvtA7tvTGguDpqOW?=
 =?us-ascii?Q?/4oVdmV4zrEDgBKzTYwbIFWnv1IE7eHZlM9a70Bt5u3/AnufYviihsLh2Vpp?=
 =?us-ascii?Q?ycH1znwrtgm5d5S1Y9Oi4KbMZ8A34Kh9j0KE3XmhaFGmC5hUbmxzP8JIBvJZ?=
 =?us-ascii?Q?bZIwAtKvaU/HuHAeSZweOBbiErXao2nqs6793kL5TMYMmJU4bxN9WjEnVSqL?=
 =?us-ascii?Q?zGMvf82suUAHlB4/bM4YsCZ/tc8xE+sXoTMNMIytM7mJgy9R3kg1bcYpHxVM?=
 =?us-ascii?Q?QJKHkDXLFbDYK/zDf3WsYXuhHeaGfp3DTuA114XMxcfmkN3+gNxWG40M1o01?=
 =?us-ascii?Q?2jmBT5l9hDhqbcvHasE2ME6JofzTVF5MCvTlzGaIOLf2Yql6/iicLUAOpoMA?=
 =?us-ascii?Q?dcXwBXri06o/d2IiP86GwELYrHFGHlZEAhT0m/9IF5qMUckav27McfDbvORe?=
 =?us-ascii?Q?1EfiQ64G7uT4JSXUwbDPHSMkLBEf2rGzmpi92FjSyXOo+Xb2UTtbQ7xYGKmx?=
 =?us-ascii?Q?OTyC545xcXCoF1WXZ40Ae7uDWyX5SM/EgGh6R0tW3ekc8rhZevqVd6T8sUCv?=
 =?us-ascii?Q?c7XnwCpXNXtxr9r458aGzSK/oo9mRLh6jWWsZ2Ip?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db456cb6-b00d-40e4-0886-08da62daa888
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:14:09.5913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNYKgQHmMWhUrzWxJB9xKRSSarYtVcRdsPzRpWIG+HnukI1Uv6AoUlBbdMGjBcVuPu3v5g+SMENHvSe02izfyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1886
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> ...
> From: Ajay Sharma <sharmaajay@microsoft.com>
>=20
> MANA hardware doesn't have any restrictions on the DMA segment size, set =
it
> to the max allowed value.
>=20
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
