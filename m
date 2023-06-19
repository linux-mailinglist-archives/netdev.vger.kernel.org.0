Return-Path: <netdev+bounces-11903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E7D7350C4
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80156280A8F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BA8C150;
	Mon, 19 Jun 2023 09:46:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7252CC2D5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:46:37 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FF1128;
	Mon, 19 Jun 2023 02:46:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfueB8mcGAzxo1iTQgdhdyXQldTGuPzCB1Y4ZmI4a38JtvhRUDmsrSmWIOUNl81l5GYz4cROmQosHK8xPZTMujrLOIv7g47Oe/ebIigzLrNd/IXUYN7NHKAME6DbWrsttIQNmQ8oeDz2xgGgLJXRi+Wg9MSW5OZXKW3v/tGw8jmD3mJY+nA9xHCmgEJFB4QKPhLwk/wdTUDcaX36/UKKkfOn+2+TegDjZlmF0Syp9+3lFdI1n1P6z6nhYvH9Oy/NM1ZFH9kLQI2Ugozw04ISE1vh4hohPwhusITwVmd9Ueoz8R9dClPID8sfwQGPDAYR95fll83LFLrTLrqih0Dyhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGjfvrO8GC3msj0A7Bd9OWov8WlRnpKoXJuFYRoQGJo=;
 b=RJyp74+37D4yWGBa99yaEOh/5z7W9NqtzMn3bQ9dpe/SL2MHMk36WNv6yNp2+6LdbH95ZPyNRq1F97/Fm0qsN23Yt9wYpNVstFgmhteATWDDr7PdJ1W0Y+fwAOIBtX+mt8FJleKI+Z7UVWS5ejKRsHULwsLDvGYQjZ7qQV6HAB8YQkH1wdPYprHTljxGa9THohUy5HIdZM/eDYtk4yUzfyiS6QKkGMVcap/q2t/iH1kTtUBdYnbaTEbSd2QLLQubu2KKoCATj7t+wVtCG6ztrkXA749b59dNdYYKLv7sr2qLzrL2S63rsKoMJNqYUk8N5YcsTBBx/5I58tkOwHmDGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGjfvrO8GC3msj0A7Bd9OWov8WlRnpKoXJuFYRoQGJo=;
 b=egZBm0dOfRmTbtduBjBm9pfcUAgo8NhLVCgwVf+zinp5NCRRJ43F2EIqfgl8aCCVd6BYD/5QiFVhbCRJUuPS5M8K6a4rJkIAtNbhBm3fXsiE2JNX9TOAar+YwV6fvCT0HteBPc7axDUrG40UK5gmJ8+j0qgPMSWlxO2QIIyGeW8=
Received: from BN7PR12MB2835.namprd12.prod.outlook.com (2603:10b6:408:30::31)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:46:33 +0000
Received: from BN7PR12MB2835.namprd12.prod.outlook.com
 ([fe80::d277:e70c:5a24:45b6]) by BN7PR12MB2835.namprd12.prod.outlook.com
 ([fe80::d277:e70c:5a24:45b6%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:46:33 +0000
From: "Maftei, Alex" <alex.maftei@amd.com>
To: "richardcochran@gmail.com" <richardcochran@gmail.com>, "shuah@kernel.org"
	<shuah@kernel.org>
CC: "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] selftests/ptp: Add -x option for testing
 PTP_SYS_OFFSET_EXTENDED
Thread-Topic: [PATCH net 1/2] selftests/ptp: Add -x option for testing
 PTP_SYS_OFFSET_EXTENDED
Thread-Index: AQHZoKTa8WeRAYs9nkac9J649TkaHa+R4+xM
Date: Mon, 19 Jun 2023 09:46:33 +0000
Message-ID:
 <BN7PR12MB2835AE60CC3164A47FD21C8BF15FA@BN7PR12MB2835.namprd12.prod.outlook.com>
References: <cover.1686955631.git.alex.maftei@amd.com>
 <e3e14166f0e92065d08a024159e29160b815d2bf.1686955631.git.alex.maftei@amd.com>
In-Reply-To:
 <e3e14166f0e92065d08a024159e29160b815d2bf.1686955631.git.alex.maftei@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR12MB2835:EE_|IA1PR12MB6044:EE_
x-ms-office365-filtering-correlation-id: 72148c45-7b51-4448-4323-08db70aa10eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 i793gj2YwuqEviZ7m9CrEQCRvQMIHUHyvSf0HpKetd9Zm0OSNR7wWjrliC1qXGLagxtz2dRFxxE3bvKqj17d63eVNZenJVfuP+88OZF3pJd4ZOV/K6ux3ATkO/FwQipTGFSCpvjF8GrktS7UYTDl6JHni7zW6nXlcYg8BY9yCVFE3l0DAPHmteYB6T6akAzNzI28OtNKsaI50GDTrq7Yd/3ig07HB3tZsH6aJmY14DEguYGnRs1A8wGbl+fejEZ0WwcHoy6jRoQkz3ZQuumP2KGT2PZvszgHhA6M1Gfb2U+QiKePOH/LVmjKiYRWCmyxDlRWJdSsUq0ZWllycx3HQPQ1oOwg2jup7zDQfleZQA1kfuNCsxoquNfWRMJG6IgFRE+L+vvil7fRNBSW948tYHNLXrdTd7/UBQPjrnBGv0xA9y1tlhbKZP5T8vpiRfxq2ZTpwcZ+Sc3QzvL1TYbQjlF6DK2uWVKFOOnR2nSMvg3ya5GQPpE7GV2mviUx8HNztLI1oLVVsokbyUN31seo27L9tmioSZp93Yz8IKwmHBofbwFw4paImUGlVhc644Viy6szo15sGQUeyseo06q/5DImBzLCU/EvkE1FIP13dTriXwm8RMzkqAdNHojXzujq
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR12MB2835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(66946007)(8936002)(8676002)(66556008)(64756008)(76116006)(66446008)(66476007)(38070700005)(26005)(186003)(6506007)(9686003)(83380400001)(41300700001)(38100700002)(91956017)(5660300002)(4326008)(316002)(52536014)(54906003)(7696005)(55016003)(478600001)(2906002)(4744005)(33656002)(122000001)(71200400001)(86362001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?PVGsiUh15CKpYEqwAkSK2TaUarQJ7JURXecWUdwz/T4NC0Rcc7VsurOw2Q?=
 =?iso-8859-1?Q?JZ4lc28QXilRcso2ecgI3UQp/unfcG0MlsRyGpunnRi0CYmQjyItB9TzFS?=
 =?iso-8859-1?Q?lG3H9xjugLaz052HgE45ht/xiK8uM7Iw80TMx5PVlpliOg07fBIAMwCrF6?=
 =?iso-8859-1?Q?W7q1TlxxIN4i74iP//61lJw5h45y76GEI4C/yE4iTMraSTP3TOg2P/O4FR?=
 =?iso-8859-1?Q?9w5vkSlp4rDLgokMg14K/dDnjMcPvn7wc4BB3M/15w3XlybBz6WQpeckZu?=
 =?iso-8859-1?Q?7eAUSsgKjzNvxC1ozpJNRthtBlubjJA9ubgex4AZCm0qMcqm1rijBx9iTS?=
 =?iso-8859-1?Q?TT9Y0rGeXPI9SA7buBknR1KHc6kMAlhgr1H+MM5lkBpTvf58R2Ru633Ifp?=
 =?iso-8859-1?Q?K99tfMytnEzA1iISZrUSvPYCiUqMBno8PBDJOGff+2IdXyWhoGE4nN/GHY?=
 =?iso-8859-1?Q?VqlNIbxMns8Vn1Fv2A0dl+pdcG1IV99fS3XhgKpVNebXYZyaGfFLYaoQzH?=
 =?iso-8859-1?Q?66rmZSUj9lOLigs8a4Lzgo1WlmaxkxBe+0fVvB7QlkwgBANNEfIlgWC8qZ?=
 =?iso-8859-1?Q?IQarpmsifbl2bFCYXTabudTnGKcLyrL2qECd+y8mupxUyElk2qpbwWn47w?=
 =?iso-8859-1?Q?kCjtAaGAA2DLJ5wzV9Me/9v1FkHx2ZH57QaV5x4s6/IBR/bQHNCdDuZZ5W?=
 =?iso-8859-1?Q?2PVy6HDfz+b4UfDqc3K7uWpFOtjRxhqSIozd1oga/u3RZfKE6wkWvLEA/U?=
 =?iso-8859-1?Q?FrUFE7v61s+iVdzkYkYg/sJB7BX7zuzCG1DUhArLePA4zg3V1pSJqz0l1i?=
 =?iso-8859-1?Q?3V+Ad7/WJSAgSAx2tV1USsqAdiB0xEEV50CqsOwA6xsRmCMTHnt3TXCFy/?=
 =?iso-8859-1?Q?ijfCCBE9hSjxL9yDYKkuXOtROynrnu08/aAxMt0zSe9RnIIPCQ6axF7w+4?=
 =?iso-8859-1?Q?wOnimNMXdbyx1Dr4+nDdjDCZ9OHsHiqJ38k5cS3LQdUjOxSdodLhINl+zZ?=
 =?iso-8859-1?Q?DB42tnT4m0l9+fJMrVIwNfbY7E5ONVNCeYNOqZZd3Q9q7wk66E/CGsK25M?=
 =?iso-8859-1?Q?sMEfdMWR3bU+yzCyq3kLlOgba/u+o0TG7mHdtgfq4ob/lRYb7UwsjB6KSk?=
 =?iso-8859-1?Q?pyekH/z67eAWpO2USXxDR0JZ/fiIHHR3O6Z9g32tgc++ENkIFLobInOIKS?=
 =?iso-8859-1?Q?vR7E1GU+S+j4zIMXyhvtOhZ8XtZhDGNiolo95x8F4X4WFpsNTHwndsZf1g?=
 =?iso-8859-1?Q?HtHPSTHeKHmFxh7IZVPCKkbXFjMmB+GUJnqh6bogeW4tTtGo+uai2JfkeS?=
 =?iso-8859-1?Q?dyGPv2kmb5EZE5RJT/MAn6aeg4gkLi69t0cr4nPnOSsCxYb4zlYOduK9tP?=
 =?iso-8859-1?Q?HC6+ewH5OUh+zU1KdLrqQf4aSmS46si/u6V48Krn+RWHWXQFp2HV0iNjL5?=
 =?iso-8859-1?Q?+qwIGhpl365LPBijMNhguTkWhMHX/aFfPYH6rTVx1YmWi6IyZphKTMSZsC?=
 =?iso-8859-1?Q?GQ7SA56is/WIYO4+e60EggfJDj/PENowWSBM4oPH1ONi+tn3HrP7WIRB2r?=
 =?iso-8859-1?Q?N82X6TfkZwY8ghg8c7VLwESmVt15C0MN5267AMddRzfnX3UCINKUzBRX/f?=
 =?iso-8859-1?Q?/HYj4eA4kNa14=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR12MB2835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72148c45-7b51-4448-4323-08db70aa10eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:46:33.3628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hSqzzmd6ykaH3d+28T5PcVebF4cHyWMAL1jF0A9YyAGflv5Po2Lo3NH2xEcqAWcW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I see I've accidentally sent an older revision of the patch series, before =
I've rebased properly and before I used checkpatch.=0A=
I will send the fixed one (and to the correct tree this time) in a v2 serie=
s.=0A=
Replying to the first patch because the cover letter did not land in my inb=
ox, somehow.=0A=
I hope this is the right thing to add:=0A=
--=0A=
pw-bot: cr=0A=

