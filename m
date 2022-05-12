Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F63D52533F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356851AbiELRJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356865AbiELRJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:09:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B46A269EE4;
        Thu, 12 May 2022 10:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gz/A5Ssbi+9UWA0a7krov4Bq1oj3NY7e4E6E7agB9qtOmfJTTzI88zSeFjQTv989N/zMwXAmSt5gbx9nnbtog5ZhrT7V93XkxprqB5WCSaNeoaYoEpUAgVB/a+tJJdqDGbKp3KFGYEmui0TpOjN1jHormhQ7iAVYpGO+fvWxZ8sb0c2sjhfO1HZVHEI/BjflaV1o+uKFIPf+wYeQMUYmlehTpNdV8myfH3dAXZh5pjuEgFpUlWcmxdz93SLpPO3EmKAZwEvceKcdDoDjkRwCxLlUdiXtUt2JNPqBTfHuKzyydidK8iTZOYbK2X4R0hhlRrS1DCGBYHNWfgzAwaJz0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPiHoppaWb8Di43zGcNRE8f7x7yiSykH5iwKW1pV568=;
 b=gHwAwnHxjI4I52XYjg6IA86wqNix7rzXVnmdgL3PbYilDOUPFVL/iikXzEBw8bDHVhwP+0taEMEruaNIR9Y3XMeKgidnon20B7TNf/XWhzt+/0gb3K3c+mb/KWNm1ic1TseDs5uuMrG9JaY5qASIiXGU4x3M2ggcxReBymSm3XmPp2A0doglotGpLzpLNToFmgV+js7fUXGYRXrz+RXtReHOj1zqdifwjlRBxH1VJTCQwsANeUhcdbqde+u8vJi2lt31Qe4aKXeCEoiy4pWppiYMlV4Ln4lFmimSMARhWcmc3Mcnh07vo4+aRtykntVJ8ukBz0Ho1ZJIlItdfGt4Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPiHoppaWb8Di43zGcNRE8f7x7yiSykH5iwKW1pV568=;
 b=n4k/I2ht5eQlw2VuafUEonkl0+plAVi8Nr7JKisoYIsZlFjPFmxiOUj0dQS5s2Xq5OOzMj92YAIKyaqTUQOxYMH/vqXCAs8S95lHVWADUjNh1t8evUUUl+La9Xzon1I5bt6Rh/g8eafP24jiA1phRHAeIgfrtAZmJksXRCq7IQg=
Received: from BL3PR02MB8187.namprd02.prod.outlook.com (2603:10b6:208:33a::24)
 by SJ0PR02MB8547.namprd02.prod.outlook.com (2603:10b6:a03:3fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 17:09:18 +0000
Received: from BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::3840:41ad:9ff6:39f5]) by BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::3840:41ad:9ff6:39f5%4]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 17:09:18 +0000
From:   Harini Katakam <harinik@xilinx.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "dumazet@google.com" <dumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Radhey Shyam Pandey <radheys@xilinx.com>
Subject: RE: [PATCH v2] net: macb: Disable macb pad and fcs for fragmented
 packets
Thread-Topic: [PATCH v2] net: macb: Disable macb pad and fcs for fragmented
 packets
Thread-Index: AQHYZIr0vNg2sBJUv0KMwbhvwvZp1K0aRx4AgACKioCAAJPTAIAAEzJA
Date:   Thu, 12 May 2022 17:09:17 +0000
Message-ID: <BL3PR02MB81874EDDEB16BFEE8E3C8405C9CB9@BL3PR02MB8187.namprd02.prod.outlook.com>
References: <20220510162809.5511-1-harini.katakam@xilinx.com>
        <20220511154024.5e231704@kernel.org>
        <CAFcVECK2gARjppHjALg4w2v94FPgo6BvqNrZvCY-4x_mJbh7oQ@mail.gmail.com>
 <20220512084520.0cdb9dd1@kernel.org>
In-Reply-To: <20220512084520.0cdb9dd1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d8aa907-bb7c-4d8f-99ce-08da343a261e
x-ms-traffictypediagnostic: SJ0PR02MB8547:EE_
x-microsoft-antispam-prvs: <SJ0PR02MB854713B94CC849C141F5C57FC9CB9@SJ0PR02MB8547.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 89HOoIW+Mb2fNF38Do/5q5opRgYwj/c6mqI5HplSJL3PoGnBGjfqGBxEH9S5A2bFtCcImx+76DlwS2LQZ1pDTQPf0RfDVFWOu1Al4iLV/x/mXjF+LKfzPFrbB4Yi8lrQrWtHry1lqAl6RRKg+KBEOdcHa7xoBK0tk9WIj3Q4s55gbCgJ4GOeNziO8O9y/2YhQFCBHg49AFh4ecWDb8CfWp4DrDU16sHd3qT1+9kptitEjiNzhEuOCFYAlg1BIOQmK03mmJUeT1a4VDfJXB8UXm/TeY79ZMht8v1YPZS0ol+GYOmPZO+GhPvtwHpgb+v4S0Giu1FUAVGcd0Gp3l1xWL7n03cMl3uVf/v1+5X8glRs1gF4+vvHIuFuqi4uCbswYJXK+C3A3Gp8hlv5rElzaklY/Ru6mL96ljgoMbnJ7hWRNE2iMa8usgogYGrR0sxUISZ0QzLrflGSyFTHkEicCoNZS9x901dIKOnQ46lda2a2zpmCOgAPTDjexbIBbd3A1g4Pu2Y+e6S1/olTg0uMosHH3vSjS6raUiI14UVMYd/6qjg3Lusd5sDHLOITX65mjQkA0YMh0Bq2pEzDoTc3TTEQdHT0OgZkn8ZyFQSeDVBxPqJeIwJObrwqwEYfNxV1/J45By9f1QTGh5UcIK2aplp9aQLZhRQsg1nATRlD4yZSEdZEjYJIOsi+iX/HRKu6EtZfk3Ce8MlET6Ra5Af34BItTUmT6KJR09dIXFChGn9U+iVrU7EF4aSuNMxrJ7omlBEMfvVCyS2x5hpa+TtWyt/Ho/mgc3MG2XNMAeSEyi0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR02MB8187.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(7696005)(6506007)(122000001)(55016003)(53546011)(508600001)(33656002)(966005)(38100700002)(38070700005)(2906002)(6916009)(26005)(8936002)(52536014)(54906003)(76116006)(66946007)(5660300002)(71200400001)(186003)(66476007)(4326008)(8676002)(64756008)(83380400001)(316002)(66556008)(66446008)(107886003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DxSDGhWiCVIISw1wEKotx6pXx6uFs5fkUVURRfRoEBkCE0tXzURbRpXSGSBO?=
 =?us-ascii?Q?Yrr7UPlIcSVzMA91SFCo/HdjT5aU2IYRPPOaU1osNPCvJJoXv5sm6Ft//yoS?=
 =?us-ascii?Q?janNotVBd2iI/pNqRByyj29qkiI+6WI9PegIGMfILje9cVfxBWQlm8IGUHON?=
 =?us-ascii?Q?mDrkRbkSuZMHZDFHMMcAd3fLEAFcqT1KEtOtrPVVlYpYz1jrETJRyzH9gM4n?=
 =?us-ascii?Q?urra4q1lLWsS1zNZ2sa+obbZsEL9ZSHBN9Om/7DefTCwUU6Kh9+qVq9nYYDQ?=
 =?us-ascii?Q?UuAiax12cfX1x9Y4f21gTMIYHt46RIZbqWkhdthh8fMb2A7yTEsfBxIf/e3B?=
 =?us-ascii?Q?jC/mr19JUMnrrdp/+rF7B0u92+cxxROm8MtyLhtfDXXSjUCjKnrh2laowQiE?=
 =?us-ascii?Q?sxZx850J7BGJ1B2XL5rLF1fuDgy5il5xqb4gRQTViQT8nUBOm+qNPMI+w7EE?=
 =?us-ascii?Q?91oSUP0eibjsd5prUZDPhjiDgKPEXkXJvYd2OM9tTO1mVm17Gmh4wccVm/6/?=
 =?us-ascii?Q?3CBJf2JOIYqctPjZjrwb9dP/TvmxfgFfygq8Ev1lhd8R2OXDMO+e8YBMTror?=
 =?us-ascii?Q?0gutVIfREm1bC63uxr3cDlatCeoF/dW4Sh5C9Y82GoKNqj+mCmdq4qGUNAZ4?=
 =?us-ascii?Q?VNme6ycY64CYPAZHg5rS6P2U+iqm5BbeGVTS27OYvmkho3dUSgbyGcV6KOsh?=
 =?us-ascii?Q?Yox1FzvaOa4qHFCEgqkwjdpTZwvLcom2/0v7hyp4MEE2LxtXHJ4xc9VJ7bjb?=
 =?us-ascii?Q?KDaKhqYqDcanYhp4lMZ1eu75NzByFmzdjQeKWRXkbVfhJzMlBga+DYTABMpB?=
 =?us-ascii?Q?TcLmH8iMBLqz76bbG8FBIcU49kwCYhe7RwgihDOemRO7tew+ZNmCEOJWoix4?=
 =?us-ascii?Q?BEoeMGqvDssc9sQJ+utbtFHUz8UcmTg3SF65JmXj69y2SqfFTkfXMNRFQhXK?=
 =?us-ascii?Q?xGUzz+TSWRtjj+J5rMij0d4AaOWjwGsjtqgO/5Im8CQJ5euubG7C9ivD8wbS?=
 =?us-ascii?Q?mHH0Jgttork56c2o3TkAWS0JsdPZeuXdH1XXLtxdG8E7Ky5Bfq4neFvFag4C?=
 =?us-ascii?Q?z3wRKDdttV4gq+kFX2i/LmnsPEo/0EzQ0SMUHVTOocvWhTU3/0E+4sKbOQzX?=
 =?us-ascii?Q?1iStT76en7G622PvaHFdsbbOCdWVCtCjc4PpvINzL8pNNQepsRgTeRieTpEW?=
 =?us-ascii?Q?w+ibY6fcCml11a5Xc0oRbbKVmt6F5DFxGvcneiBKGB5Ym15696Hlw1NW+vyV?=
 =?us-ascii?Q?58z3oUdjsFmBY4NFTaixmj15V5+/ur3tYE5325dP98rhli9934M+XgRISYXq?=
 =?us-ascii?Q?+60WlJgLBDBVM/YVc6zbjLGIrE4UAjdOrWe9BlEJVSdkNcmpuOMjeM+6mM34?=
 =?us-ascii?Q?FJ4YUpnStcMDw+O0AVnMwO4HAZbVfNDQcX+ieseuYQlb5zUTsMVuLw9g9f0e?=
 =?us-ascii?Q?uCu6c4Dp/D+RNi5fnXw5HS2sdy58kpgqsIifVEBCCrb/eYlHnZ4+aW5KIqE9?=
 =?us-ascii?Q?0sJYFeE+C5IQ7dMTgUFKDBiJXsy9bJOJgrUJZ71iAxW7DK3L25s4G4k8ToOZ?=
 =?us-ascii?Q?OLHnbkfUyr/zzMrcOZL/ef/kefLmKIR/JdwyYW25Sfqk2tTTbaXEN+Uh1tMi?=
 =?us-ascii?Q?jx1DQ8lt6p3o8Mh7U1B3axV+rd9djTbz7fLgBP5gHtdhCs6C9U6g+nedTL9R?=
 =?us-ascii?Q?CTX15ID8+1Sj65rrvDigNfh9RTRW8j6wNT+/vh71d6uOjczZoyXdFGvdJ7l2?=
 =?us-ascii?Q?9dJUfXKGvA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR02MB8187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8aa907-bb7c-4d8f-99ce-08da343a261e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 17:09:17.7852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sDJBmAp/XpZPM9rOvaYq2Zx2ZzR6EyV4NCPAkbOIZJ79xy3SjCQYRTkvZ3B0MyqY7r0mAmNQkGpAm3u0O7HA1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8547
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, May 12, 2022 9:15 PM
> To: Harini Katakam <harinik@xilinx.com>
> Cc: Harini Katakam <harinik@xilinx.com>; Nicolas Ferre
> <nicolas.ferre@microchip.com>; David Miller <davem@davemloft.net>;
> Claudiu Beznea <claudiu.beznea@microchip.com>; dumazet@google.com;
> Paolo Abeni <pabeni@redhat.com>; netdev <netdev@vger.kernel.org>;
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Michal Simek
> <michals@xilinx.com>; Radhey Shyam Pandey <radheys@xilinx.com>
> Subject: Re: [PATCH v2] net: macb: Disable macb pad and fcs for fragmente=
d
> packets
>=20
> On Thu, 12 May 2022 12:26:15 +0530 Harini Katakam wrote:
> > On Thu, May 12, 2022 at 4:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 10 May 2022 21:58:09 +0530 Harini Katakam wrote:
> > > > data_len in skbuff represents bytes resident in fragment lists or
> > > > unmapped page buffers. For such packets, when data_len is
> > > > non-zero, skb_put cannot be used - this will throw a kernel bug.
> > > > Hence do not use macb_pad_and_fcs for such fragments.
> > > >
> > > > Fixes: 653e92a9175e ("net: macb: add support for padding and fcs
> > > > computation")
> > > > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > > > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > > > Signed-off-by: Radhey Shyam Pandey
> > > > <radhey.shyam.pandey@xilinx.com>
> > > > Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> > >
> > > I'm confused. When do we *have to* compute the FCS?
> > >
> > > This commit seems to indicate that we can't put the FCS so it's okay
> > > to ask the HW to do it. But that's backwards. We should ask the HW
> > > to compute the FCS whenever possible, to save the CPU cycles.
> > >
> > > Is there an unstated HW limitation here?
> >
> > Thanks for the review. The top level summary is that there CSUM
> > offload is enabled by via NETIF_F_HW_CSUM (and universally in IP
> > registers) and then selectively disabled for certain packets (using
> > NOCRC bit in buffer descriptors) where the application intentionally
> > performs CSUM and HW should not replace it, for ex. forwarding usecases=
.
> > I'm modifying this list of exceptions with this patch.
> >
> > This was due to HW limitation (see
> > https://www.spinics.net/lists/netdev/msg505065.html).
> > Further to this, Claudiu added macb_pad_and_fcs support. Please see
> > comment starting with "It was reported in" below:
> > https://lists.openwall.net/netdev/2018/10/30/76
> >
> > Hope this helps.
> > I'll fix the nit and send another version.
>=20
> So the NOCRC bit controls both ethernet and transport protocol checksums?
> The CRC in the name is a little confusing.

Yes

>=20
> Are you sure commit 403dc16796f5 ("cadence: force nonlinear buffers to be
> cloned") does not fix the case you're trying to address?

Thanks for this pointer. Yes, this patch already addresses the bug on linea=
r skb buffers
and solves the issue I was hitting.

Apologies for the inconvenience. Please ignore this patch.

I had to unfortunately work on an tightly coupled older kernel and app to r=
eproduce this
particular issue and hence could only verify whether my patch *works* on 5.=
18, not whether
it was *needed*. I backported 403dc16796f5 ("cadence: force nonlinear buffe=
rs to be cloned")
and it works as expected.

Regards,
Harini
