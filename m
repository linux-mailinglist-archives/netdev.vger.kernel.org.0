Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5E763D9E2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiK3Pu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiK3Pu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:50:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275C784DD7;
        Wed, 30 Nov 2022 07:50:23 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUCSqo6021177;
        Wed, 30 Nov 2022 07:50:16 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6wg9k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 07:50:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfGvcRU309fNN93O6ZIQXRAVMnkKoD4izJHvVDPDyGhRnuv+uxdDBkTjA1CbF/Fajb7yDPc4dqNJ15F//1TsXgr2z9GYI7kp70TqnFqX+qciSojsjdKh6IqlZ11PrC0odwOPtKuhbQoBtM/4TRnckYDx8HGSxJ9bMKTzgrl370TW8EHF7BrDXYmma7jJAWOQcqntkSSL72P1jIlLg3gIfTwKUOByvyUeF0xwVTOWGqskYSQooyxZTMmwnIpn7izP3ds393rK9rusJUFh8lpsStR9GTBRkJirkzvbljLrsW3hI4c/7JXjxuuztNaxYysfNd3L0Y78CKwHxzCqrl61SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSkRl/kj/y81p7xDw1gVdRMM9SgtTdZHFjF2/JYIbJk=;
 b=J9+XNRjexLA2KJquCd8tDiXe3RWUaHlGjvXNfr2od0T5MN77Ryzds+oUZb1AUHtbDgdLazXBGCG72n8685m5M8B453YBRn+bERfQLYFoOtWW5jFm4PxLRUn2hS8hk+A5ey2LBV55/1l1fO95als+RKZXiE/t+Az1c15nYV8oCG5KdU3M5DPlgs+DltMrga+PZGQoYOb5+xCjdWGL4/vM7IYB6m6veFdf7AMidHA887Hu6xJb2O+bWj43IYz2NeNTh8NlCxTdGyzpV612EG+JNVsyMniQX7U/fET133sQvBqKgrPKsK7qmpdh4v9r0ZCjZbeFQ/SKz8b4IpLgwLIOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSkRl/kj/y81p7xDw1gVdRMM9SgtTdZHFjF2/JYIbJk=;
 b=XE2IZV/xtqsVPHGBAa64NvY8JwrbLNblICUhi3dJqZgOczWWV/h2kQ0gFOOCcdQCehG4ctJSajD+6Hs+V5743vW9Tv19ui/oRqno+lkRAstoypqtt1wcVhkHi0NpptOUO0AHLxrJ82eReXG8120Km5xiDRFka6kqHLJX7e9RVak=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by MW3PR18MB3610.namprd18.prod.outlook.com (2603:10b6:303:52::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Wed, 30 Nov
 2022 15:50:11 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 15:50:11 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v2 1/9] octeon_ep: defer probe if
 firmware not ready
Thread-Topic: [EXT] Re: [PATCH net-next v2 1/9] octeon_ep: defer probe if
 firmware not ready
Thread-Index: AQHZA/PZ82bWA4Tya0WGfhTwd2BjbK5XM0GAgABqSSA=
Date:   Wed, 30 Nov 2022 15:50:11 +0000
Message-ID: <BYAPR18MB242303FCE6E42D1467E4F420CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-2-vburru@marvell.com> <Y4chWyR6qTlptkTE@unreal>
In-Reply-To: <Y4chWyR6qTlptkTE@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYWE5YTlhZjMtNzBjNi0xMWVkLTgzNzItZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGFhOWE5YWY1LTcwYzYtMTFlZC04MzcyLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzkwMSIgdD0iMTMzMTQyOTcwMDk2NTMz?=
 =?us-ascii?Q?MzUwIiBoPSJMQktab1lZaHVQMXA1NG5YazkvbndqSmhOYW89IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFQNEZBQUJt?=
 =?us-ascii?Q?di9GczB3VFpBVnE1Mzk4UnZTUmxXcm5mM3hHOUpHVUpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFDT0JRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQStSRzhlZ0FBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1FB?=
 =?us-ascii?Q?YkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpRQnpB?=
 =?us-ascii?Q?SE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFHd0FZ?=
 =?us-ascii?Q?UUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4QWJn?=
 =?us-ascii?Q?QmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?VUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3?=
 =?us-ascii?Q?QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|MW3PR18MB3610:EE_
x-ms-office365-filtering-correlation-id: b94b3929-ccb7-42a0-6a37-08dad2ea908b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWSaz9ik7LsatGqum2xUYPonA/sXv8V8pgktsTAS4S4r11QqU6C6uERK+wbEg7xydv30F8wQ70MGP8fwszZu+csN9ASb+zTjK7PA0TQzs2tLp3F6kX3zjhqAt23mFHhAyDnknl5cH2XB0Qfvs0E7/wWkiKgjJqsXDb6v49WYGl6P/RDsbb5qWQoGC4wIBMP8La4ZyHUJDm0tOkielA24rDDLLJCJVZPjC3BRTERv/sTSQ2b1QRY6Yonqg2gHnaLQaixESDRPbxKnjofLdHRJy5vnCj2DwET7vut1l1ywH3z63vHvq17DL1HOjH//7NVJW5VaBkDKzQdVxdEhdVwGtnffiQ0QxXJMuiWDs/JtFghViw/gyFk4hD79UG+/uOmLRwydgXGRoDsYIXc/Pe4E0sasMCVH+8Xb7L+s3sAXu5cdryNOdr4buLKJHKubIZEAR7IC4rdrV6np5FCe5zlfHq9+nWy3sWS5aqcDFurM3dvYyvs1SBF85/YwmzpdLpMwKf6t6RDY6iQaUys6nlDAF9CiON7kbAsaG3pydRf2YqwD6lMpKRk/CM8xQJJBJh3qJezVibgH3igatFxrYRNfAhsyMOdk1QXbYjJI0i1YyFdFIAe54unN35JBgGygOpRFQiXGDwfc+QmvEJ/YJtj7XmD7/xLgrl5XpEv2JQ/xED3LSDqYb0SOVW3LEAeG+IRAJWXqN7ADV4TQsCqb+Vvnxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199015)(2906002)(5660300002)(41300700001)(66556008)(66946007)(64756008)(4326008)(52536014)(76116006)(66476007)(71200400001)(33656002)(66446008)(6916009)(54906003)(8676002)(8936002)(86362001)(9686003)(26005)(478600001)(6506007)(316002)(53546011)(186003)(7696005)(38100700002)(55016003)(83380400001)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Lc3vHUcReCZ8tPBQJ8PrMRTQdunVKHSZ4niXscWY+9Kwq/jUArImrt81WRJi?=
 =?us-ascii?Q?33nTrivM+Q4lbafSwMCowAqXvSXxB0X5e5rKzfKYSfRHitJNE/IeURoo5bKS?=
 =?us-ascii?Q?5fHoBBPvenroUtBu595oFLr1odsyMi7Oy9XwUofkWxcu2ZN9cQ4Ol51KXMf8?=
 =?us-ascii?Q?x2rb2NOPS+7DqbtwWBuz5WpXysZ6n2w2zkokKzFQQWiafTvTzWz9AEz+fz/w?=
 =?us-ascii?Q?mpRpAiAGNemGhii0erzw5vT+BsttU71aGWxMjR4UCdctUhBaO9c2o8PmwKFE?=
 =?us-ascii?Q?egdexD0mfG6pdWwLFNgqg1TBzGiMHc9QPORfzcnUU+V2hF0LGMfWGn4tVVM4?=
 =?us-ascii?Q?9H3QyImu4CPzCcLjv14fQn45CzsDuh1CAF21CA4ct4x1RfweHnNLumCzgwC+?=
 =?us-ascii?Q?qix/ADqUarY/FM+/mCgl5Kewhu59zbn/xIZNqbAGhfv2iUtFv16oW6PAPrCt?=
 =?us-ascii?Q?vQVlBK7xCbKiv8XMZ8Hyb0s3KuEdt4pCXwvq529O9TzSjP5CswEbkasToRF5?=
 =?us-ascii?Q?SdkpyeOtRhIvfNa7NP+++mLRAbaiWAcvCVWAbXF3jB57pGmvSvSd8ekEu8gK?=
 =?us-ascii?Q?sKP6VYRAJaCgKZStNy2gmgAnLdBR3gYpsx1FpJcbWQk3OR6zRmjK6taSW69c?=
 =?us-ascii?Q?7JDX50bgu5f835RxBFowfx2b41Yg4m3BKqvELWhw7ysuehfo8znXGPc8OBFP?=
 =?us-ascii?Q?aSZVso+XAGCUU+VpNSRBOgv+UdBNBN7Degv+ONDXXnCSyKwv2jLzc/ImqB9X?=
 =?us-ascii?Q?3jdjpTZxq8BYfUqTLa7/jYE5ztU6OJHW9IgimWi7bj75wZ88lF7RBKl1mCn2?=
 =?us-ascii?Q?Uz8uxNdYt5Z47VX4e5VZxSnRIwLtg+wCoEVNzfZiCmbAx1/eXqbehpU6LvTy?=
 =?us-ascii?Q?1Hqg1y/sGEzVi/+9K/NGcv2g1MRN4H45wDwjlQdoKmtidfeC/+V5INhd9ZiF?=
 =?us-ascii?Q?dDgkGvmeqxMDC5wfcmpulNgVn2JTJGT8D9leLCnQwrCCuwHgJOedw/EKvu+3?=
 =?us-ascii?Q?vVp6rS16zyRjUTFPaHyeeOWkw+v/8428yGlw5SAKhlMUKe59l2t0nyKqmR9j?=
 =?us-ascii?Q?89AUhUlROGytRm7wveJbkna6IQsr5aAGDpZUIZvaY1+J5t7nnkev9u+ERb32?=
 =?us-ascii?Q?Q1cxJgiq9qyTMC82B0vqsuPhVLt4WbLKDUnlI/nf/I9LMHLj5MgnkrCMUJKQ?=
 =?us-ascii?Q?urkNIHL3WMV7Jhfp9Y/M9JAMLO4qzjz63l6uQ+yN/wlrVYzJnrWc3iyzatDV?=
 =?us-ascii?Q?0sRhPcnRe3WxZ/b159XNPQEphK6X08vKwkFC/DNEE2VumU3boGkxrRfyxEtS?=
 =?us-ascii?Q?xAGheszJzjGIlEVj82PLI/7z/GkR0AwhIy9IPBBwEc/OywogBSZ2Boy9dPXr?=
 =?us-ascii?Q?S98hq1FC40x9rGrKclfvSSHfVuKiYcOuqIZIPrV6dztW9R/Q39pRAW4mJ/rt?=
 =?us-ascii?Q?jKRuUSvxRy9ecE5PaTdWKnMP409j2rApqr2X14arRouKKi0t/NL02AC9Fqtz?=
 =?us-ascii?Q?16fBheKyx0JKJoSzjztQhw7DKPWgRJRrxMxCBKQ1Z1dbQsyj83BDXFsnUkOg?=
 =?us-ascii?Q?e9haQhqu9gCCkTLRoqQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b94b3929-ccb7-42a0-6a37-08dad2ea908b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 15:50:11.5269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UxT9vHOeCYq9wdMARTEHbjQoKrhHHucex4aPJ5zkLQG4qAO3hwY7wxyG0ONZgvw/pLlEeLyIlSUEQ5xl0wYOzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3610
X-Proofpoint-GUID: ZClyKQvoCaf8D7af26UI9AJWmqQpgfZ2
X-Proofpoint-ORIG-GUID: ZClyKQvoCaf8D7af26UI9AJWmqQpgfZ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, November 30, 2022 1:25 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v2 1/9] octeon_ep: defer probe if
> firmware not ready
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Nov 29, 2022 at 05:09:24AM -0800, Veerasenareddy Burru wrote:
> > Defer probe if firmware is not ready for device usage.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > Signed-off-by: Satananda Burla <sburla@marvell.com>
> > ---
> > v1 -> v2:
> >  * was scheduling workqueue task to wait for firmware ready,
> >    to probe/initialize the device.
> >  * now, removed the workqueue task; the probe returns EPROBE_DEFER,
> >    if firmware is not ready.
> >  * removed device status oct->status, as it is not required with the
> >    modified implementation.
> >
> >  .../ethernet/marvell/octeon_ep/octep_main.c   | 26
> +++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > index 5a898fb88e37..aa7d0ced9807 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > @@ -1017,6 +1017,25 @@ static void octep_device_cleanup(struct
> octep_device *oct)
> >  	oct->conf =3D NULL;
> >  }
> >
> > +static u8 get_fw_ready_status(struct pci_dev *pdev)
>=20
> Please change this function to return bool, you are not interested in sta=
tus.
>=20
Yes, we can just return bool; Thanks for the suggestion. Will implement thi=
s.
> > +{
> > +	u32 pos =3D 0;
> > +	u16 vsec_id;
> > +	u8 status;
> > +
> > +	while ((pos =3D pci_find_next_ext_capability(pdev, pos,
> > +						   PCI_EXT_CAP_ID_VNDR))) {
> > +		pci_read_config_word(pdev, pos + 4, &vsec_id); #define
> > +FW_STATUS_VSEC_ID  0xA3
> > +		if (vsec_id =3D=3D FW_STATUS_VSEC_ID) {
>=20
> Success oriented flow, plase
> if (vsec_id !=3D FW_STATUS_VSEC_ID)
>  cotitnue;
>=20
> ....
>=20
Sure, will change this.
> > +			pci_read_config_byte(pdev, (pos + 8), &status);
> > +			dev_info(&pdev->dev, "Firmware ready %u\n",
> status);
> > +			return status;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> >  /**
> >   * octep_probe() - Octeon PCI device probe handler.
> >   *
> > @@ -1053,6 +1072,13 @@ static int octep_probe(struct pci_dev *pdev,
> const struct pci_device_id *ent)
> >  	pci_enable_pcie_error_reporting(pdev);
> >  	pci_set_master(pdev);
> >
> > +#define FW_STATUS_READY    1
> > +	if (get_fw_ready_status(pdev) !=3D FW_STATUS_READY) {
>=20
> No need to this new define if you change get_fw_ready_status() to return
> true/false.
We will change this to true/false.
>=20
> And I think that you can put this check earlier in octep_probe().
We will check and move this to earlier point in octep_probe().

Thanks
>=20
> Thanks
>=20
> > +		dev_notice(&pdev->dev, "Firmware not ready; defer
> probe.\n");
> > +		err =3D -EPROBE_DEFER;
> > +		goto err_alloc_netdev;
> > +	}
> > +
> >  	netdev =3D alloc_etherdev_mq(sizeof(struct octep_device),
> >  				   OCTEP_MAX_QUEUES);
> >  	if (!netdev) {
> > --
> > 2.36.0
> >
