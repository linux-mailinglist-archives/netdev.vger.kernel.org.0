Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2448B5858F5
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 09:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiG3HYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 03:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiG3HYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 03:24:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3D722B30
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 00:24:45 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26U4du1d028607;
        Sat, 30 Jul 2022 00:24:38 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hmk4htax3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 Jul 2022 00:24:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYhETU2UO2DYR+8kQGhFk6gTBUQpCyRCFFcGhI15TWaipZ7LPewkiLfngZXm5P4kzMOODdjJcV6lSMaU+Asz1qrr9E1mEfmQ4qw7f5/vo7K1ayh/kLHA/ZScn6d+ueDW7bYdpdaw/f/xovxNSM1n9vJJZtvgCENUZXdvB82HndlvVyvK1RmSk5b41EajFJCKjQ/iCGk4WRxzS4p7bSJDvPa0/9wX0I/aJU6w8SZWk45raJRbsXu0th4IUPg8Vm+Xtti1hTBTj4RtSN1WScd/zec3/NX3MS7vFw3cI1oaIlJMOZpbBr3mBhEbplKg2BEeYOCY2phb9LdQULBk8X+66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GXr+n36gjNY8r1n9BFPp+fP+sEBXyQNgg0vm4Uuerc=;
 b=DHWUCW12z2sIz53RtkDYOHC5O8OToaCBxRhlM9U4TGl88oMGlovW7mAZDx2h+aCpu+1fdA2hdtyS1l9ad8mNVyKUmgAroC5LnrtsBQVIUT6zOR3daYxugRt4wiEP1q8Ir4jIRDalzmWoC+1EMJyUlyq6/7dhuFHqqb/F4UUMJw2Hq0DTi/n/5EuwKvYnqOypDxKK6Gd3g2PSn0V7xslwyK7Pw/bNeJdI5O0XV9Kcu7flbV5zEQImH34RURTbZXiUtVV5YcOQqCsPSmBBLR7VdqCB2KeMvCDJ97b3/qfZm1HZ2kNLjI3fbsAgHNSQLJqG0r8q4/pVPKu1kbwua/sKSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GXr+n36gjNY8r1n9BFPp+fP+sEBXyQNgg0vm4Uuerc=;
 b=LI++oi1JHfdmUnV4bPEQY2y+krbNrNUXWslVtrNdmr1Ec2EFerYX2UAzM3AMVUeVkMgQuA3+wqfy4TUb5gkt9m5JkME4/6h0FzcYsCBuaohEbQK6TMoRVAalIRm0aqPFgHdYGf4ddURRI26lgBIikGo9vKBkeFTwSuPT5aBaCy8=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by MN2PR18MB3231.namprd18.prod.outlook.com (2603:10b6:208:169::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Sat, 30 Jul
 2022 07:24:35 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::f17d:2241:467a:eeb]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::f17d:2241:467a:eeb%7]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 07:24:35 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net v3 PATCH 3/5] octeontx2-af: Allow mkex profiles without
 dmac.
Thread-Topic: [net v3 PATCH 3/5] octeontx2-af: Allow mkex profiles without
 dmac.
Thread-Index: AQHYo+VrekpmGAtQSUaiD23twDuTzg==
Date:   Sat, 30 Jul 2022 07:24:35 +0000
Message-ID: <CO1PR18MB4666E41E016F652322D898F3A1989@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
        <1659109430-31748-4-git-send-email-sbhatta@marvell.com>
 <20220729212004.7ca3f250@kernel.org>
In-Reply-To: <20220729212004.7ca3f250@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a58205a-ef0f-4ac3-5815-08da71fc8e12
x-ms-traffictypediagnostic: MN2PR18MB3231:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYMctxuFFJ6NkSg0tOBo7jzfYfP8UZimldlYUpp+agT66PgR2ZsYcWsBqOTLLVBBChdCudgSdeshgajzIFXXAG7DAscqphtRFtA1z+vq552lk6L8+B82EwkQkqfp/papjMOn4tCjMB/mgJd+gol26EFFDSDk3h7YJsS0+o+Q/V6QrWTtpdY77vjfkaiPhVIYc82Cbl/ZcWOWQftcMTNg9SAs0m0lRtsQ7Y8uayI3XHT21qNps1U9O1TOAS/XHbL2hLkPIFvcgM5pZslBFCamx9oUq5yOzLp1/B1aBt78bM24TydAJxs/xbmJkYjhjvhlPJiXsBIvCkN31oSC1Mj4VBSRTY9GGta3K047ixRQs1wnhujkfxM6pPWLFXQY1Ih/0uGdFFnqWmskQAD3skB5XbJFaXwpSVJjbEvFQOtAjrFE4cwsRwXLR4w3D+Z0ahdaeVunTPWPUy9rRDLT/3pyuLbzVFoLtAaMVXwntz5ODITZ69RITebGOSVnR8hP6e22DebhvjFV8tH8JH4tkhX/vcil2jgwqnS+Z+sCj2N10HU3hRxZHf3haMb8nnj4JqXUj0sa0MlOlRBwkyurxRegylwYaPOOvvlRrM9RyB3C/uRrr578Kw722xXIHi8IufsVxKiEiqzSZQe2tOt6b4vWof/ZzxtkrvVEASoI6IHCFzZF3gPL3DcldRSYLUZiNoN3VJP0HRtblp643btkwfuoiGzTxdjvhKmx3eolsUKtJBAX2m+7GAwOKBn+eiYIaf6MyuUiJF8iUHaFedun2ZKa/6v/naaaJGdC9ek5YNA1fFA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(6916009)(54906003)(6506007)(7696005)(107886003)(53546011)(5660300002)(186003)(91956017)(33656002)(55016003)(86362001)(9686003)(26005)(2906002)(52536014)(66946007)(38070700005)(122000001)(41300700001)(38100700002)(66556008)(8676002)(64756008)(66446008)(66476007)(4326008)(76116006)(316002)(8936002)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kVYOmL6F9HHZghgd9aFKj1KebAG6uBGVnxeq6kp6Z0uHCJeMLY0YbGyH/b?=
 =?iso-8859-1?Q?5/4dFn4ZhtMdx/YQjukAlHFM+mMtR6BrnololjqbFOXXjBWMSSG3705/Br?=
 =?iso-8859-1?Q?EvaTh6MCHAiC9SASn2kwvj57nmGENt+/JfaiuVkE4vRLMf5SVtM6lMSRI+?=
 =?iso-8859-1?Q?o/0k/f7LxNjGkrG+f7MimE7eMOdDeIW4AFoaJgJiczM9IFxHpqusJUnWpf?=
 =?iso-8859-1?Q?wwMYlyMAufg3uMYyerkKTUQ1LlAJuaaWfruoirS2BPGwl30Gve9WEXz//Q?=
 =?iso-8859-1?Q?0Z99Om7BRiUkrduYEw/SEigDkKVNj1jZ7WZ0g9/UIC3yQEcPCPkT3/CqPg?=
 =?iso-8859-1?Q?2T2jg3KQfTC1VCzvZSCRayCNHqpPl6cCvbFHeZaLSWBAmwokgbihOBQvXb?=
 =?iso-8859-1?Q?A69SrP6zno9HXdWdg5mMCBKrZjNlJAYDQHl0WSbIAGA6eXP3KXMTotr5PT?=
 =?iso-8859-1?Q?HdBbB3HtOkUjJqU8NBqGAhjm1+311dPs8Pb4/VebiCH3819ub7ZHqyh1wr?=
 =?iso-8859-1?Q?l33YUoYGfz4VIZcozdV07A60f8hANZzyfinJC7EpIXLpW2qOQa66+8ppuD?=
 =?iso-8859-1?Q?CcKXRpTIgUnMVliYXrbx6eJy7SQ/byB05p8ShmfYycbND/J6IaR6W0mmAk?=
 =?iso-8859-1?Q?VQhs5na0ThE3tzBsj+udQDsfDfPClwQVS+339Nc3xphzLk7yS5r8P0z8Ac?=
 =?iso-8859-1?Q?eL8KPmaD7ynvfIuY7mRjQbwctt/uuaIoEbnSDp3xYNCxFPyLC5H/iPcK0X?=
 =?iso-8859-1?Q?QH9wWtXgqqpXuu1ziVnfDIHw3wwRaqz86ujQW3XmEnKhNrVAKsrXnuDEd2?=
 =?iso-8859-1?Q?ICYY55f+SCGScG947uPbT4lg/K4KkNROrjlC/y/sXbv5eRYuJ1eddfzYTK?=
 =?iso-8859-1?Q?hUgW3TIGMyltbbPoeimia0EI0GPsiAB1NSAyddRKWwc+OtlLM15ek85ay1?=
 =?iso-8859-1?Q?kFbLLC5S1tf5nn2S3QpBqrd6ZQdJ6JVlWfzXNrxaJygDBbrzDTWTibfeqC?=
 =?iso-8859-1?Q?m0csjMHwmEdn0MJs6hmXcwVW5O7epdn/CGTSKmWcePYpuauNIcXfVFpBot?=
 =?iso-8859-1?Q?6h8v9aYbA4M9iuqUyMCIJD5l9jrbvSu7n5vhBXEcnbzFdzDezg721858Xc?=
 =?iso-8859-1?Q?mjb0TrdOHQ8LIj9O0kIcts6x6WKibn2mpxLQe26bRP6VoajeUr6aw0Qqct?=
 =?iso-8859-1?Q?2eBONIZ4WycNCSfNNmfrhR3ws6Woe5+WIfvKwqQ7lSHnHJCkdokPzxKD3J?=
 =?iso-8859-1?Q?b8z5y1uaNoOF90U/owPdQUjsFHgO45K0oKw49g/NVYmdp4ggWmLGsvxbUk?=
 =?iso-8859-1?Q?rU5AlC1oEgM4tEE6xBz7hr/C/VRmqlF5W3jSI6RkymD3USMjpnoqcU9iM+?=
 =?iso-8859-1?Q?BsQrXO5WTfZgfOxTgn7apvFCs8PXsx0L3YH841mUhGD3/QP4m5hBy3t5Yr?=
 =?iso-8859-1?Q?ODn4BaP+V/Gw0bovusjymn6b9bVoldL2vk3RC92ZL+SsQ1ZptuFO1UmKVS?=
 =?iso-8859-1?Q?8Kly6w0IG+5ZltRuFdNXZsXRfqmFGVpIMmZDSHDkN81dUZafmPhDCgsFND?=
 =?iso-8859-1?Q?MJrTLZoDJXSLdxg38kCwDdv+NTAIp6KsZNd1a9PIxS4W5Ey8SntJKP5Foj?=
 =?iso-8859-1?Q?vV/ILwlt8lDmtNAHxaCqe9/5PBtZQjhEmv?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a58205a-ef0f-4ac3-5815-08da71fc8e12
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2022 07:24:35.4985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qApF1SnQof28IUX+TIUeahJY1iI5OR8gIRH+dkNzVetY3LxcGXcNZ7uCb64S7vyOmXaQxRPvNUvJz12FxHMmeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3231
X-Proofpoint-GUID: 3QlR0wSI7ngYDLu9oLZxhcyNx-gxpyBT
X-Proofpoint-ORIG-GUID: 3QlR0wSI7ngYDLu9oLZxhcyNx-gxpyBT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-30_03,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,=0A=
=0A=
________________________________________=0A=
From: Jakub Kicinski <kuba@kernel.org>=0A=
Sent: Saturday, July 30, 2022 9:50 AM=0A=
To: Subbaraya Sundeep Bhatta=0A=
Cc: davem@davemloft.net; pabeni@redhat.com; edumazet@google.com; Sunil Kovv=
uri Goutham; netdev@vger.kernel.org; Suman Ghosh=0A=
Subject: Re: [net v3 PATCH 3/5] octeontx2-af: Allow mkex profiles without d=
mac.=0A=
=0A=
----------------------------------------------------------------------=0A=
On Fri, 29 Jul 2022 21:13:48 +0530 Subbaraya Sundeep wrote:=0A=
> It is possible to have custom mkex profiles which do not extract=0A=
> DMAC into the key to free up space in the key and use it for L3=0A=
> or L4 packet fields. Current code bails out if DMAC extraction is=0A=
> not present in the key. This patch fixes it by allowing profiles=0A=
> without DMAC and also supports installing rules based on L2MB bit=0A=
> set by hardware for multicast and broadcast packets.=0A=
>=0A=
> This patch also adds debugging prints needed to identify profiles=0A=
> with wrong configuration.=0A=
=0A=
I had some questions about whether this is regression fix or new=0A=
feature and the size of this patch - which do not seem to have been=0A=
addressed.=0A=
=0A=
My bad, I totally missed looking your comment regd. feature or fix in v2.=
=0A=
You are right this should go as feature. I will drop this patch and send ne=
xt spin.=0A=
I will send this patch alone later to net-next as a feature.=0A=
=0A=
Thanks,=0A=
Sundeep=
