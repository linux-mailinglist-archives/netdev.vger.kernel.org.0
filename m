Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460FE460FE6
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 09:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhK2IUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 03:20:45 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243230AbhK2ISn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 03:18:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AT7ZNOU009054;
        Mon, 29 Nov 2021 00:15:16 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cmtkpg3hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 00:15:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNT+b7+BlGkSOQCLbQsLjhFnSdDMMJFO9LQGABvmwEQuj+Wgi5N1J0SUawSkMlYb/lBzcvopUyAUyMWKuzN4dy1b9cANzKpJYDOHz7Pj64LT+8+qntuXwBWFsDmGUbtuOzCvX5Kv7MeNUkG4EuEQ7+jTAcpjuEqvB2vR9IGGUbC9co9sGn71XLZmRyTv8rzGuqI9FLXDciLgoqZ7DFUQAtAEXRtyRpADvNMxO1I+TW6c+PI8HJx8XoZjVhajJ71tQJLQIFquG301njS55cuWGvovKSTJRjnHucuOJKu4SfhUaXrgebBuXPCdLRscfAElHxJyz+4hFpe3bgOpDctDhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6x1Wez+ZHf7bGOvhDhvhhEj9PlvuyC89JnVGVPAlW4=;
 b=ROcl67xcQ2MlUB3hR6TeUQ2FAwzafLik6FJLDcaDgyZFg/GDOLLKWxhQ7yBRk0xdylSg7INpH39f/9qbXpxFmKrRD+nIzp7XCkOGqdgfmTXXRgAqEKruq6Z/LVkHN6OfJtpgGYazdX8ZIzG9R1P7vMr9XHgdDWrYpPEqrVrk88mZp4kRL1PliA41U0vV9nRXAI5nAcWt7uOc+KBu7lt1MHxVjMKmo/wOsp2+f9T443sTEyd6R0HQKUvP8CjmjDJkQiWyYoMbWzS5f1ascbRJmOU6HF1w2rt523BYpM1qdddnW19gdoe3+nYreWL+VU+jMzBeRyLqvnZy+Gg7kPsOAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6x1Wez+ZHf7bGOvhDhvhhEj9PlvuyC89JnVGVPAlW4=;
 b=WB46bJDOPBNnD3mrS/Yw39u8yoOPMCcWQLg7LRSgIlRMn2WLQN/19ywLY84QDiMHKTqYL0KV7VIPrJLBWEvcS9cNPlxexFmLGJLPQkGu5Fak+hNcmfVsQ+XXg9SVot97QPg3PDGM9Q0PluFwCA2GfvnOhp01DHXJbXtSmRh5WF0=
Received: from PH0PR18MB4425.namprd18.prod.outlook.com (2603:10b6:510:ef::13)
 by PH0PR18MB4654.namprd18.prod.outlook.com (2603:10b6:510:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 08:15:15 +0000
Received: from PH0PR18MB4425.namprd18.prod.outlook.com
 ([fe80::5c78:e692:5a86:19e8]) by PH0PR18MB4425.namprd18.prod.outlook.com
 ([fe80::5c78:e692:5a86:19e8%9]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:15:15 +0000
From:   Shijith Thotton <sthotton@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] octeontx2-af: cn10k: devlink params to configure
 TIM
Thread-Topic: [PATCH net-next] octeontx2-af: cn10k: devlink params to
 configure TIM
Thread-Index: Adfk9BQJhYExM27hTtiDlBdKmIPIQQ==
Date:   Mon, 29 Nov 2021 08:15:14 +0000
Message-ID: <PH0PR18MB44259826C271BCDF11BBB86CD9669@PH0PR18MB4425.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8f3ddbd-a868-45ff-1544-08d9b3105f5f
x-ms-traffictypediagnostic: PH0PR18MB4654:
x-microsoft-antispam-prvs: <PH0PR18MB465436D656D458FCB3BF9970D9669@PH0PR18MB4654.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HLjrvEll+jwFTwjchXTj3k5j/ofbFVxG6qYT5pJIw1E35GfhY0Mt9cbqyPwvsezwvMqxRUVXociUdayVwpvw9PiRF+NCzxL8jG1YWB+N6F7M5EjHcN5skPMJJ50vsnqEcvVvabvyY3ZxA6Uqtps8An4WNKe9FZPSnUGCPgdE6e5kRJgbNIKokbBPv/jfy4TcTFAVDJ2Bg4N3Gmf77TaciF1E2C3Uuy3btldeaW8uN2/QfyRG6L5nacvFf2mW6vNhk6nrdZ7wHVuSTHixyx7kD1DnVCXOptKXlhwsftxDqO7xwu5O1QhNHndU8eo1XgeU/CQXZrshtV1jlaEJa7N482Saiqz3zE2u+OjI9Z2ImDDnRARbOCGhH0g+xFi2lQWeOp5F+8DzAmWLzHedQUgXJkH5REVw01bqdySthRfoLMLFEqrsapBKpJsB71mB4s1LhQKIpR4kAcuQk7xQEgXdI6j6R7TraxEUDGViCtLk1L646gvK+FXkUWKnRUb+dsu4JThYEKbj9fmxc1P5gzcUs5/MoXh1lPwwbE5YSXb5idnx2tm6ZUrTXqqm07vH0f5w8GqhO9TfvNmbMs7bp9nv8KgppsSyPsj9ZQgzM5/p2wkXLMMifhHArodzCn1dAVy46H8RfNu/aTOmGaxMjgu9nU6Sx7dTAjoEZKKSDt9OHqEAf4njPfZPhWdjPcBigvYbArJgJyqZRqyCmS99aPM4QA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4425.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(4326008)(55016003)(83380400001)(8936002)(316002)(71200400001)(86362001)(508600001)(26005)(54906003)(8676002)(2906002)(66476007)(5660300002)(66946007)(76116006)(52536014)(9686003)(66556008)(6916009)(7696005)(66446008)(64756008)(6506007)(33656002)(186003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gD1rFefg6B9j4pb0u3SmdJI5T7O1ur2MuwKuxF6AXSRNJHi7Kx74wSzE7S3F?=
 =?us-ascii?Q?LaVVhqNFBEHHWYNVsjm6LuluBx3i+rd0yvS6xCEFUNkcx3Xb2HWx6RNBHIAw?=
 =?us-ascii?Q?dyh3CM97Y22iaHNcMCVcA0vuKDVWvK/aooOauQzXm2Xa5+XUVv22YIORdcaP?=
 =?us-ascii?Q?O/Tme7pFqswOv6czEZWhUTVKbXzJcGnKqPb35Acy56BOZ1CsPucK6eiRLIUM?=
 =?us-ascii?Q?HzR+M+M7Mqa6GNM7XuI7TOTaU5/q0nJqif66MfhDPV5jNZjf8qu8bJGSjVN1?=
 =?us-ascii?Q?UhY/uDBmxKbNd3KvgYSwld/qWJA9s5Am2WrSTY7AagPLwkHkfHAnimT/NqCE?=
 =?us-ascii?Q?MFatyUbg92GeRKN0eyKkPLhwD+anIEbuW3BFzIDYlsMQ48OWPOcJsfdo2xlN?=
 =?us-ascii?Q?SHixauybpgdwEGQn2ZzB5PuVHro5z0aJAzYpXbn1JhjaHDE3TTQeqfL47dVo?=
 =?us-ascii?Q?fQORYoK38yREExaeeY5A6iC6gZBZiTg1DtHPJskkL65MqVZo63Htmwv7GqGD?=
 =?us-ascii?Q?KU2Ug+254ueWdmgu7FHzzI1uTQYFVdO6DeiW+0z12tz5q4L1yPr6ZONpkPWF?=
 =?us-ascii?Q?TCBu9fn3mZR2bPl1GlJ8rrlD3RhYf7RmbUw1HS0TN1L/Njo1tSccNhYC1HON?=
 =?us-ascii?Q?3WW73w5cBjM3vx1UQgrODJ2CVI3WHFJ7yfhhpn5h1uEWDmpP8S32+0jS6Vol?=
 =?us-ascii?Q?bgN7dHTaccQTe6/j6sq33GzIqtQvtwCeHJfc+M9g+qJg899GMpyUnR8Mbmj0?=
 =?us-ascii?Q?0ZUe5a/H0Ix+zIHX0uWcz+/3VTgCukYVAqWhlmB++AzZjimEPSqkTVgGSU9H?=
 =?us-ascii?Q?WMEM5gZJOw7gr6NwWHMIbH8TXngzBMFNP2qz3+dAVGfW9Jwc1zTrFVQYvPsY?=
 =?us-ascii?Q?Dqr7hFASD5B9wuNEcfmANbeTrvRA9NaLF7i8UvjjsjOBf5w0+x96vnskcMEb?=
 =?us-ascii?Q?9N+RcYHnBLiPxbTMU+Td7eUrDhIrakaWpaUmVETgITu1IpTGfrquB1g3/LYi?=
 =?us-ascii?Q?cyFFF/uJPfkgG4l4nKOpksbMoXEO3wr+I9PE+VNTEch+VKRJRDKCOCrBVOGr?=
 =?us-ascii?Q?FSc7z7jaGRduXpRP5is/Wvu1/ErKhNOAl+TQQpWHVxFXOnYzDi5uFuVpn2fx?=
 =?us-ascii?Q?md0Uwyn0GueTc7y/RTcE4opQwdbxrX9Cmazx01zwutGunPfO3gatUG1HkaF/?=
 =?us-ascii?Q?S2Xvc4fCnKKMufh+33ZvU3q9Ed87fEIWE7294O5V6Ru84nbMeziSt1JQvbTn?=
 =?us-ascii?Q?nUMeFCDs/KdgFnAJt+Mcblhp3o+ltwO7lPitHD6MbNpf2DN/ZrSo8lxLco1O?=
 =?us-ascii?Q?W5UzDq+GeB5ulC47tHRqwkoW9/kCoVY5ICzb4ATVbbnMmJah0V6lKP5DSHXb?=
 =?us-ascii?Q?otmZk882nZEpqAihrO5sqOlreVcbKhTiOfUDcEZmIvN5sX3egpPjF0HdbjwI?=
 =?us-ascii?Q?RuPrR4+6OItx3lkJriHhD1BjIY+7omD12IwtJ9689uyn/bVmikokVYJJjKDQ?=
 =?us-ascii?Q?rj0QrnWViYeE3PGWZC91qighe9VkB6rL8B9hhYJvUNnMb7woDgVi9wAGvu85?=
 =?us-ascii?Q?g8SwLiDInWoDitoYkJRTe3ZsNlcNLLApLIs2cXE22DIa4woXosfGx05AuuXD?=
 =?us-ascii?Q?xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4425.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f3ddbd-a868-45ff-1544-08d9b3105f5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:15:14.9426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ElOnMwpbSBDwp86TzHGgfJlnrMLqfAFH+3I7HZ1u3c+m3TbNeIPYbqm/hLupmGfyftBb/9B4/rT/gG7Kf8fF/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4654
X-Proofpoint-GUID: 6vrOxAdcpNK_zBbRX5nwzp55TSExfYRb
X-Proofpoint-ORIG-GUID: 6vrOxAdcpNK_zBbRX5nwzp55TSExfYRb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_02,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Added devlink parameters to configure the source clock of TIM block.
>> Supported clocks are TENNS, GPIOS, GTI, PTP, SYNC, BTS, EXT_MIO and
>> EXT_GTI.
>>
>> To adjust a given clock, the required delta can be written to the
>> corresponding tim_adjust_<clock> parameter and tim_adjust_timers
>> parameter can be used to trigger the adjustment. tim_capture_<clock>
>> parameter can be used to verify the adjusted values for a clock.
>>
>> Example using tenns clock source:
>> To adjust a clock source
>>  # devlink dev param set pci/0002:01:00.0 name tim_adjust_tenns \
>>         value "1000" cmode runtime
>>
>> To trigger adjustment
>>  # devlink dev param set pci/0002:01:00.0 name tim_adjust_timers \
>>         value 1 cmode runtime
>
>PTP subsystem exists.

TIM is a hardware block in Octeon TX2 DPU, which is used to generate events
like timeout (used in packet processing). TIM input needs to be configured =
with a
clock source for its working, but TIM does not act as a clock source. Suppo=
rted
clocks for input are TENNS, GPIOS, GTI, PTP, SYNC, BTS and MIO. Devlink
parameters added in this patch are to configure TIM and won't be changing t=
he
clock sources.=20

We won't be able to use PTP subsystem here as the changes are specific to T=
IM.
