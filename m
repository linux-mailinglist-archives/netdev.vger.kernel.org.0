Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B5D51FED5
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiEINvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbiEINvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:51:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA51B5481
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 06:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652104073; x=1683640073;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I7TernJRSQuyDz/xnUYLbLy6TEvPO3yvjjiB1MTelyI=;
  b=dcpVFFwft2rhkS3grKlN4+lWEfri+6LYNDiPWQB5pMUsFwMALntl8u3F
   efRcJ/EW4oA4Sdoc9hgzZeW9sKbB0zRCT56ivraV7y9QcxZqA+JQjOAUw
   JWAEULmp12siaW8declUzdownrdjOpa5TzjnMQQMP8oaeRsTVCZlX/WaQ
   Q98di6RZetIks2Qgbr4ip/+nalDwfmaVAI+nV1xN8vBo2btqXcVn7fhtC
   UdPV0ltdc8t4Q6tkT7z2BcKhtQwWCC+ipkEnPUTKB8Zv3CVcOnbv1LpMX
   Mar656mr22/bS5YS23NK+u0tbxmAYWBHIYQxNdSW3/cXvtAP/N0vNxs69
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="162852430"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2022 06:47:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 9 May 2022 06:47:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 9 May 2022 06:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hN0B07Pt4jeT/6IwgauNK4tXGc3n5k9OBP5MhX0nwoH2L3aIdV+So8HV44/OR1PypGePNcWhpCzNnTSwuWacGEDv7fiYO5XjIROCCwal8ZMuT4khhntj0FMbBaFBJuNXj7CiOJgc5TzVpQBROaA48/hfb5R3rXuPS94vHBc4FCkhE488Kof8xlmLDy0breVqVmjbwEnUZuS+llCXZOBttL3usDY0oniTYnosC8UheE9GZ88+JE+7vjcl64kf0NrH6UJ6D2Qr4ZWodgDj04w8yBmPXBmS7kEd7/gLganEMj8o0l9UJ9cMz6gfWAH8DCMm9277Jsbs7X+2/ShFNNwxVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzULWLhad/EhAT+dS8IP/LrFO6BgEExEB+9eboo+EaY=;
 b=PeZNeUia50N+FQPkHDhPczocFuXfHhaJLQEgDHhQtIZNkeRzYHvc/kLfHnqXXXDCX693EaV26K4jiwCAAfMgOB49DUqw5Zb+2vqYnp2kn3k7V11SikpvG89YktUWJNN0QNVfgkGk3aSiYmnfaJuy9Ox06m5mTp4jM6KdWwyI5mjzy4wndDtLWHHeUrs+m+KyZfQdHiQqqN+HHM2U6evOxDNCfzoxTEYJaZW3UTVGpAwOOSfp6lNEMPjPWOV+3WX05iofZ3l3o5n2EER1ctAzH3ItzfJ1h/QZUsoZaeoe/rpV2J32eFt1k/AF1a32/FYCKePiKt2qTDgSSEhEPM+uFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzULWLhad/EhAT+dS8IP/LrFO6BgEExEB+9eboo+EaY=;
 b=lnq8Wx3oeGOVb2Iu1lBr0OAEkcY2uknk3gj5tp41eu1kenQdva3MUzlFN/aEx0u9OTpp6VAxSVlf4YBka4SOc9LABZXManVzDrAiqNN1H3U83wrsTibiwbWgL/UeA8SYGDx8dKWVP/kQT9algiLmeC1SJmNz3jcqsvjKYy7ivRY=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by DM6PR11MB2876.namprd11.prod.outlook.com (2603:10b6:5:c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 13:47:39 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 13:47:39 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>, <kuba@kernel.org>
CC:     <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Ravi.Hegde@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Thread-Topic: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Thread-Index: AQHYYKvOScev42KTZkuZEw3AktpFnK0Qq3WAgAHJGICAAPxuAIADI7Tw
Date:   Mon, 9 May 2022 13:47:39 +0000
Message-ID: <CH0PR11MB5561FF8274E9D5771D472C0F8EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
 <20220505181252.32196-3-yuiko.oshino@microchip.com>
 <YnQlicxRi3XXGhCG@lunn.ch> <20220506154513.48f16e24@kernel.org>
 <YnZ4uqB688uAeamL@lunn.ch>
In-Reply-To: <YnZ4uqB688uAeamL@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e3e592c-55c1-43f3-ccec-08da31c27b8b
x-ms-traffictypediagnostic: DM6PR11MB2876:EE_
x-microsoft-antispam-prvs: <DM6PR11MB28760690768F012ABCF1B3F28EC69@DM6PR11MB2876.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Neesd5w38cTMwEGr8djDvS614ocH5aMrE1YPP1RolbYpr0kcPr/U5Y4gXa9J89wzFyR6pGKyUGky83UpwQwk7iMhltZEdPL1TZa0bHv23c8b9N+OW3nAXaPmH05Je3oD+FzfQsTdeOSPWi0QUzuZbysRYPFAnmG8q6eQXWfH3kyg0cj7WeV98zWJBFPybHd+I1hoT1kVi2JcJdjkwBOwjGy8pLY7rK8Mc8ltUsFomK6Pmg4ljMCsR6mq0Cdh+5A2XEXvaVRwkIed3tbrvC5p+yN1awC2fjEC1cgy687mDOqYt4GRp10Et6lwXzlcLHMcYE/mepKD5uqi3clWA/Is/xZps8qZokRAsiUtorzsarKO+M7uyLZD4PhyqFubdIGCsnMKn37377YoLdHO8sp0SRBThO06ZNIpcECu/AgAVP3Xqflz+GZE3X8dihSeEzR0U9FhPyY5CRzAhVENViMiPn6HPo+FFTOetXwklqDJrSzIPLau3zUYF67QCVI3jbXFRhVXpCFFTY4MJMRUN9TsWzmfwbgPJnr9Zu5/ORO5N9KJ9nR2xi+N73bQOjdcNzn1htnDlln1rH5RT1Ho1eIGPbQr9xLv2mdMFNh7v8KskrO6sSlcYhFApaHIYrofxzt4dvJ445BfNVmiFtehvOhQuY5yrNkfvFU8GpvPLoKicAs/P6OiPnRexW+nRcHgPBTd0xh2OcH3ke47jSIT0VCycQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(2906002)(38100700002)(38070700005)(55016003)(186003)(83380400001)(5660300002)(316002)(107886003)(8676002)(86362001)(4326008)(66556008)(54906003)(8936002)(66946007)(110136005)(76116006)(66476007)(52536014)(66446008)(64756008)(7696005)(26005)(6506007)(508600001)(71200400001)(122000001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bYJUJpmJSCxtXhJMT1vAnaJfqRLB3MwDF4JvDXj2+pQcPAxvk0SRodyyAU1q?=
 =?us-ascii?Q?5QVWIs/oTmnsnbgVb9E+Z2wcWc9tfPeGR6vcs1kHroAPozWEy3ohrKkkztUS?=
 =?us-ascii?Q?pK9CCzridP7ByWvM0VWaPmsgzORGoD2+vPmrs/tsukATOiKJkxiwli1g9VjL?=
 =?us-ascii?Q?El3M+Ch9bogLqDmHRqUNHVdTY5ownDMPwoDVHtDc06EGho4+wY4w6JXS4K6K?=
 =?us-ascii?Q?wZhCh3kEzzshumkflKzaPZ2i+9pr/0o1A1zcqjB7Zy6MOOteLMuHhQTzabRG?=
 =?us-ascii?Q?nuPI++E87CmmNZUoC+fqXx5QLblsLE0CEjkDSbAwBnvOTr32oIe6iCf7D5+g?=
 =?us-ascii?Q?TZWcGdUVLclvE7/WrYVtARH+M1jplzv6bzUwiqEsrFgpuVtOWHnxNI/bZKmf?=
 =?us-ascii?Q?RFvkdA8be2h4U5jBqhWP88LwK28rIdnPPdbfhADErof0rAjkyUpqqptA4yyw?=
 =?us-ascii?Q?3R/74kienvyXH5xRD2UZf6LE4jMFr5yuujaCRs4lCORbLLvOWFRU2vYhBDAW?=
 =?us-ascii?Q?yTFCwh7Ul72N3T7ah8Zrm5n5ZbQXJ7fJ0TlAL2wm5b+E6dFeBoKnWO9eeaD2?=
 =?us-ascii?Q?Vj/hEqgYEa2GaK3e5+wwL3r0XrS0LCuANxwxBzknI0Vxr2WoNpc2FR/np6I3?=
 =?us-ascii?Q?RqWZabnllVGEUqNW8t+w4CRmU+u7FTN3Brym6XCB8IGGeZz8oo3tZDGGilL/?=
 =?us-ascii?Q?7mlVrJi1vK5FfvqMNy1s/xA9Q2VYPSlzh15Xh4nHVwdEHb8IWvxbMRZ/Lpd2?=
 =?us-ascii?Q?IPVowygEhqjpybJ2SmHOUcH4v12WM7BWFt7FgokpbUCncwISko2ES2r0MSIO?=
 =?us-ascii?Q?UznGVDwHx4EewnE7pPLJJZanEyTa7c1EZDVaSHY0pNUbtLmqt1xkEjbqC4rD?=
 =?us-ascii?Q?crqo/fd1nSzla0i10udpHI0Dz2tERwmvpRrEQcbvlcakaudS1UYRyN8lmYFz?=
 =?us-ascii?Q?RrlqFRTpoNlBM7jg3Y8EqCelaMfu4BzaDWu11+LD4QczQDtkyA+wvQUDT5nE?=
 =?us-ascii?Q?t58hBQee43sKLxRxUWAslIbkjcW4tKy1hYIM+/G7LFu0PZEG+ytN+haKKJ6b?=
 =?us-ascii?Q?O0ty5+9BYOUSwjU7Xf3tQZKvy3IgKhm72sLc1blFem6a5MAzzNWEVBnhVmxd?=
 =?us-ascii?Q?b6evXO6PQ7PsuFyCmlildaXARD0D09qpVep9yxnBxaVBGXx2ASKlui/ZUzMz?=
 =?us-ascii?Q?yC/PQmpCd+HhBAKhKQEQ4IzJ7tR6bqBZQEUvWZPqjAjNQfHbJ3tGkPNisMH7?=
 =?us-ascii?Q?rI1jDY9dqovCi1wI38DrYrdlMqBI+8lVwqRgA+XE0WRfFkzYcZTpN9j1Ofs5?=
 =?us-ascii?Q?5KYR1xPbTIk4/hy5nEGO/gtX2gcKDD9h/Aa8egreGMJG9MUM6X4rJuQrRF3R?=
 =?us-ascii?Q?zyodOph9/4flF8JQjNPP8WNpyiJfJ8F0XzadIA4qq3SRsxc2Xxmzlk2SJm+P?=
 =?us-ascii?Q?lpU1KC4ES7TOhrWbc+MBg4BotNwYJKkxBQrU3wLnoDcDe1DVaXReGWL2hDCP?=
 =?us-ascii?Q?IhApD18E6tttsPWZ25PvjwQeX50D02cvD0g0S7kAPonwEK0nbbR3g8VjQHmu?=
 =?us-ascii?Q?LYbLYjzfUGNE0LITbYRTMCI2bxRoeuYM23raTY+ooiqkEvuYsN5Ayp/0RWTI?=
 =?us-ascii?Q?9GOEoMx3XtHy3GPv4W6/SxQFhoa2yc5ZQjtF4DimQMDXaTTUJGJII7HZztyh?=
 =?us-ascii?Q?F7/A/pZwxRBLVGiey3ZkbXguzbGVozJ+JKZY/YMA01oDMN4JXZqYGNol7SZD?=
 =?us-ascii?Q?0MQ5gSqwIRNPP/fKszw0y9sgFg64Ed4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3e592c-55c1-43f3-ccec-08da31c27b8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 13:47:39.2053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9JzD+PIu4SBrFmoI0rVpVT/ZVTI9Cjfrll0zaaJ0uHeh/AFdUNGbsnV0ov4ThbWxgWDZsomdTuOCjz4S9txsG+f0wD8f1ulEv/3A0kJLWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2876
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Saturday, May 7, 2022 9:49 AM
>To: Jakub Kicinski <kuba@kernel.org>
>Cc: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>; Woojung Huh - C216=
99
><Woojung.Huh@microchip.com>; davem@davemloft.net; netdev@vger.kernel.org; =
Ravi
>Hegde - C21689 <Ravi.Hegde@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy suppo=
rt.
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the=
 content is
>safe
>
>On Fri, May 06, 2022 at 03:45:13PM -0700, Jakub Kicinski wrote:
>> On Thu, 5 May 2022 21:29:13 +0200 Andrew Lunn wrote:
>> > On Thu, May 05, 2022 at 11:12:52AM -0700, Yuiko Oshino wrote:
>> > > The current phy IDs on the available hardware.
>> > >         LAN8742 0x0007C130, 0x0007C131
>> > >
>> > > Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>> >
>> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>
>> The comments which I think were requested in the review of v2 and
>> appeared in v3 are now gone, again. Is that okay?
>
>Ah, i had not noticed. Thanks for pointing it out.
>
>Those comments are important, since these mask are odd, somebody is either=
 going to
>ask about them, or try to 'fix' them. Some robot will fall over them, etc.
>
>     Andrew

Hi Andrew and Jakub,
I see that the patches are already applied to net-next?
So should I create a new series with the missing comments only rather than =
doing v5?
Please let me know.
Thank you.
Yuiko
