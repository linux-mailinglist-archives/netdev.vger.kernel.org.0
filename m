Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3860D1A7
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiJYQbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 12:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiJYQbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 12:31:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607CF645EC
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 09:31:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvEth/JGM3El5NfqVTAbjgvjaS9V7Pjb+eNYqPmd+y4GhQl4jdwObknNSzJ8Z0S3ZN0SG4U/a4wqboX79vDUiigoLij8/SnCmuzvCCR7N0lNspeGPoeneF6cTnUVH6SldlV9M1AAtm8W95pazm6NAe+tcOVyX+iqE4EY1ZbHG6/1R9TTOXJ+N3lqNOnHVb0BPIIkx43t7IsvZEswaXQtmqLs6TCnE0IfZGPP/aTUXdMs5tuK8coNmqfvitTPqsXYTlPxWmUEbKqgIKxugRDOOHqHldKxmykdqiHFekc/aIYCYbmN5Oo1OgREobPrAq+lNKEolVNRaYyz+n37KhJ5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lw7edey1ooQ18s0JAJ/gq7SKlRhoQ+8ES6ZKnaTVJUs=;
 b=ZYsZSKzRF5SIXWf81IcQrvTH137V4hv3K6kWpF6Ok0vvjIN2MAQQdN/GhSpuo9zl/0ehN1FhaYFfGIoNUz8tkan11eMAKDfMBDBJltYC34RSmVt/DkZbGZHjtsVXofXL9bZNnBA74YNimqJO9plXphjle6EOE7mRbn+AaCo8gqHxHFhoNRcpinzgxxyoStDnAT3KS/ljqSqZ4547J3ghT6UDKhcdaYRaWsGXyV1QEjx2O2VvWzCtcFdn4vSImkaHvWwEMm1SCSy6C0Jts26ZioNOF4mAfRBDw6zkNMuskTkT7RF9deluexoj3YgX+XI87ZFUwa7j2W5C+VdRM/DB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lw7edey1ooQ18s0JAJ/gq7SKlRhoQ+8ES6ZKnaTVJUs=;
 b=PC1KyiHnFw0CLrFlLHfZwIU80CzrKD3hiJ2ePAZ9e7o0lsZlmwJ10UDI/YRHuJlVVHzJUbgupLgN4WSJRdKN8Uk0xxJ30HU4QaymJw6BUtjUmkqbOJaMDRqQ7iI4AIwt8wa1HendmHlrzBKpR1fyP111BJs3ZEQyGrCxmdNO7VAh1KtQa7xSsvkN6aX/7+EQPlRJpWFRs/EHlRdHErvNscB9Um8nkTtskMA0api60FAdkcrao8pY7iOjJGt4LWdCkOnI4LyGw5RfpyIimMMSkY1NszCQtdYJWs66nGDrenuC8myPhSe9yyRoSL3sudIzWr14/4ELXs8ckBM32hhbiw==
Received: from DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) by
 CO6PR12MB5394.namprd12.prod.outlook.com (2603:10b6:5:35f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Tue, 25 Oct 2022 16:31:03 +0000
Received: from DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::4ce4:f7c3:6bf0:7eb4]) by DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::4ce4:f7c3:6bf0:7eb4%4]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 16:31:03 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cai.huoqing@linux.dev" <cai.huoqing@linux.dev>,
        "brgl@bgdev.pl" <brgl@bgdev.pl>, Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net v1] mlxbf_gige: fix receive packet race condition
Thread-Topic: [PATCH net v1] mlxbf_gige: fix receive packet race condition
Thread-Index: AQHYw8GlItJNiC2c50SWIeOSY6X4bK3nUvcAgDhAndA=
Date:   Tue, 25 Oct 2022 16:31:03 +0000
Message-ID: <DM6PR12MB553493BE18AF0F9378AABC7CC7319@DM6PR12MB5534.namprd12.prod.outlook.com>
References: <20220908202853.21725-1-davthompson@nvidia.com>
 <20220919141736.53155bb2@kernel.org>
In-Reply-To: <20220919141736.53155bb2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5534:EE_|CO6PR12MB5394:EE_
x-ms-office365-filtering-correlation-id: b63d2cc1-38b5-4ad9-81c6-08dab6a64eeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZXzJm1n/icSmC9Ve+ItIpCRo3f4L0YJVyvSSvjv6dL4aKrN6BErKVZIunwYJ+Gt0j0arn2MwoHGaKaMqEi3LjzMKCMxHAmhGcETnyasrZNJcPple7DuOcmYyU0KU3omKRHqjErPdzWi6g1cCaTYLJR0MHRYhickJVZhCGv/ULLBJDdmaqhIFEDPQJSZd+RAeLpNf18CTgwXrUFXIMnqbm/LvVo2poqw0lWjadOpwrNdBInbl/tVhP1wKEP5qKW++icOaSESz7cjAK02ELWrbejnNws1mNpYGTyYMULkimTnVzFfsIFkRfHHURlGd+ZOsFBSl1Z4KxYtjpPxl2ea3KGppKWDj4KbA6XiBn4+n52GVPMogsLed1lITBo8OohYBlPvbIEWN1/YexjgwpL/7gEYZiiQQdSbifaV+Bfy17Jp7SB2f1sSKYbLeNH4NbtKMz47uN430YKn542DWVq1nsIFsuumfN9K4ftiX5wbm0u/wI55Svg8obbHJXdEbGHraQAEigfSwIKV+hTct7gppj3+/4GD2WkVjiUVPb93j03xEhSH+0uFbwd23uUYNFosA8T64FZdSjBl4wRU9n1JdATDKsMTA+DOz84rnJ4eI8ilv7Q5Rh2g9ZOzzvjItie9c65RQEdIQwvcRzTkKPyAdZUUNoLpmCSyy9viwpYMpxuxwTkfFXR5HYL68MQC77h7RfHzoH0wRgaHKqE8oXcfu1WCUXVea3+wXlGbw9PJntlOQJd/mOQyFg2XTJ/k2V3DyEtZ6KN7AzA86dt6821fRjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5534.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(9686003)(41300700001)(107886003)(53546011)(6506007)(7696005)(38100700002)(52536014)(5660300002)(6916009)(8936002)(66446008)(54906003)(55016003)(66946007)(66476007)(478600001)(8676002)(316002)(76116006)(64756008)(71200400001)(4326008)(66556008)(33656002)(38070700005)(86362001)(83380400001)(122000001)(2906002)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K4i/4VufROdo7CqDjJ4UUR2xH4tGWOdL5atZDxBi6sP253TH7GSzrwEFUSYE?=
 =?us-ascii?Q?+EM7V3VJ3A1rtGMA6AIZdVWnXRetePz4hpM1t5vNjkFMB60mBI768sEP8L5Q?=
 =?us-ascii?Q?mo10rJwlN6FYQIdziebrdmGq1t/nkp5wyg28492E6O8fgrMYP+GvcuNnctxe?=
 =?us-ascii?Q?UpsGreodetGyopXw+uXh6utyKXjVG65qmr0wyvD71rMs+aYTUJncgx003D41?=
 =?us-ascii?Q?q6wtjVARHOKwp0yVxPlFDDax3jiEpyx1CvFCVHnNaLsKMgK+e39J6tQwMk3S?=
 =?us-ascii?Q?2nnSqyZTdUawKK7i7BncfcwjasEihwFJD6ueRU0wN7BA6C55P6T8Q3brcE7E?=
 =?us-ascii?Q?LwZxyUWLS/r8kte3U26kroINTin2U3PkQp499nLetUaWLozwqWRyfhIocVBd?=
 =?us-ascii?Q?PT2/vSem4rCcOdRFjmpin80vWbRTxtGhasW5/VnO5keyq0Ze91pGPUZNUl8t?=
 =?us-ascii?Q?3cD8C+j5yqkxvWeKOaNn9yTxti7HyCb6X/q4Vr1+3lrJxs1DyudkWTYiZ8Xh?=
 =?us-ascii?Q?2NjnJBylffrrK+rF/+Tjyvpmugek2WeNt977G6cPqA0fMgRnSifIPwG+Tv3J?=
 =?us-ascii?Q?uu/x3oHnm9OV41savuZMJm1nxcowZINK73O5oNtMrJQQ9kJMTFuCpBOrBnoK?=
 =?us-ascii?Q?1jeP2rKY6Kxtw+iGsEkuLAv7Dm+2++PDFr9oIIBWT4AB+15BnKyAYNiC5QFe?=
 =?us-ascii?Q?uAk5UOYs+/qXEqdnenlwewsIrBmCrHrdYxCgqd9zjbTFVw45KmS0ZYnNzJ3x?=
 =?us-ascii?Q?lT1FEyDiqk6LyoPQ2TAe26wlZb3Mtj1snW6uPvLoVprXvLSOQM5wtpf7Ddgl?=
 =?us-ascii?Q?CNusTVI+QNC96lcR7ZTeNDO2YsyI2Nudz+qTxwxdxQjUNc7TptOTLqf6J1jV?=
 =?us-ascii?Q?9KveePlKaHrE6Rsp9kjUHmEK2zd5Y97+TAmkkljOKFU9EtI01VrN0dHzUQ9Z?=
 =?us-ascii?Q?ibrwv5BO44XSheZiRUm3YJaDaMaAvuFo8Na+R8JqUqHdxnNWelGLSLaaP7ab?=
 =?us-ascii?Q?Oe+RhViemNnpOWQZgeeUG43/A96o45s/QGR8Hd7p3zRVgC2puLMlt6cQVf5A?=
 =?us-ascii?Q?fOm8CgP0NREQ/acM9b1/OIBPt7zNfLolwEUWtVRWh1L1npwaEhhQh5Rt247I?=
 =?us-ascii?Q?ivT4mXfcNvEeXtx/hoaWIXMtmZpi8rSI5lO13dVDByy0TBBZGlyt+LYcbt71?=
 =?us-ascii?Q?/Gl+QzEMD49XoOwiFRovlPDrD7Fp2wPDPUgrKN/IP1KqPwRrPBSpJoU5oiJr?=
 =?us-ascii?Q?Cllwlsvm5Ddz3Fvu6yQiwNeP7V/WYdigG2v4l9FmiDgfl6PUhhAEsOLs9Vgp?=
 =?us-ascii?Q?PNRqk4CrQ/Yr44NK+fAmPRzP+gtX25A44wFdx9r5XDtX0pf3jG3A2TaqDlU0?=
 =?us-ascii?Q?JC2iOHxwIoEoM7PitZx/PSoYoQy93UrXNoQbzZVr3Exz66pPU1DRC3y/K6h/?=
 =?us-ascii?Q?/LDwV4Fi12t4jIyCm8hljqAX+JyYCsVitWvfOVm/JgT7+aiuZfRliZk8Lrnp?=
 =?us-ascii?Q?8vKvZP5dTwOL4vzFnZe1OlmnpG3SLUe9kBtncWe2Zd5GHtN8osh/9k4jocEN?=
 =?us-ascii?Q?9MmEIBCyK6hFrYzar8pi2LMwUqzgYjHCozE1JAb5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5534.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63d2cc1-38b5-4ad9-81c6-08dab6a64eeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 16:31:03.0918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oryJ9fLubW+GNXKjT0Lh/WCcpWigIp1eQieEoFreOcLRrG7sGSFq5HovCW3QAOR/1GuF4stEPlcJDkbW4N59Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5394
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, September 19, 2022 5:18 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> netdev@vger.kernel.org; cai.huoqing@linux.dev; brgl@bgdev.pl; Liming Sun
> <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net v1] mlxbf_gige: fix receive packet race condition
>=20
> On Thu, 8 Sep 2022 16:28:53 -0400 David Thompson wrote:
> > Under heavy traffic, the BF2 Gigabit interface can become unresponsive
> > for periods of time (several minutes) before eventually recovering.
> > This is due to a possible race condition in the mlxbf_gige_rx_packet
> > function, where the function exits with producer and consumer indices
> > equal but there are remaining packet(s) to be processed. In order to
> > prevent this situation, disable receive DMA during the processing of
> > received packets.
>=20
> Pausing Rx DMA seems a little drastic, is the capacity of the NIC buffer =
large enough to sink the
> traffic while the stack drains the ring?
>=20
> Could you provide a little more detail on what the HW issue is?
> There is no less intrusive way we can fix it?

Thank you for your insight Jakub.  I will review this patch and see if
it can be solved without pausing of the DMA process.

FYI, a little background on the DMA operation in hardware:

The pausing of RX DMA prevents writing new packets to memory.
New packets will be written to a 20KB buffer (but won't get forwarded to me=
mory and no consumer index update). Once this buffer is full, packets will =
get dropped. =20

Thanks, Dave
