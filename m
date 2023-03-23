Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BDD6C700D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjCWSO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjCWSOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:14:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C55061AE;
        Thu, 23 Mar 2023 11:14:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NIDPrd011084;
        Thu, 23 Mar 2023 11:14:14 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pg9urd2b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 11:14:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjL2Yo5VhpKLoYC3lLrugq5QqAUfnaCrNbfrHmLxbRqJWEQ69ZkOWK+3MW4N18a+4YkbgQclIcKdoXYLLC/GhxMV3CB+pOSZ9LoymiCYdt5MOh2acKnLVn249tD/DN5k5UOuF6GFD9khWUOiy+3kUQx5VrvCWqEzpRTmkmak1wWlmA8sAhPG0uz4pRsGzbP8ZkFHX32y4H0xVsJlVtpYZz3x0B7qMJ9TVx9SrXOnKy2O0J+midBj9ioVEex0R1im7ijeh7cP05QLtZtYE+X7P1eBJBlpp0dMJvoeHSU26sKlq1CsHPWHAjw1ngD4gI7KOwTpn1EwDk6OmhXx+wCPWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPzPohzwuSuQ617K2vQ4QtNdEWPo5FdL9HuHBM1pVUQ=;
 b=Sm81IGF2m8DqqyyGAqWmsTjrfyH/LVhXDkn1t4rXMaoaeK1rjAiZ4Dd0ApSag0hHzS1Bt520nYo5wVD8BUpajZgqVdA3FACYhqQm3hC+FVc8jgSPoJOkkzYWYKwBWtxk/ktNli/JgbyMiOiz//88LGG64Y9JoHZ1qGwiEKIeDPE7tGgeONLRXm71OnWyktCLDFXA2PdvdqLgg2D3/4R4aBWhTW4w3d0pVqMRqMPR3JzVNbVoXlMYfh9IQvoXOcJopHuPiGoA39UESYOQQb2f5C2/bpjx/bCFeJbfsgewGgbF33g4llSgxPTy77MDtU7qEcTi89vnEMYGL0ADD5M+qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPzPohzwuSuQ617K2vQ4QtNdEWPo5FdL9HuHBM1pVUQ=;
 b=qRcGiaUwFTQqIHZFLHPnFkoYeo0t15OkLqb1MR9/IAXxWgV8YFUZHgduuMCgvHGwbX14+nfz8BVc1P2+ahR4SRhp5Mnk1hkDZUO9jjAx1Kip53hyJYlxpfj22Lg8gFn9E3+I0Pdliw/chvYYsO3j0jqwv/vtWr73B0PRsCoAZWg=
Received: from MN2PR18MB2430.namprd18.prod.outlook.com (2603:10b6:208:109::23)
 by CH3PR18MB5509.namprd18.prod.outlook.com (2603:10b6:610:15a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 18:14:11 +0000
Received: from MN2PR18MB2430.namprd18.prod.outlook.com
 ([fe80::f5bd:9166:1a02:cbe7]) by MN2PR18MB2430.namprd18.prod.outlook.com
 ([fe80::f5bd:9166:1a02:cbe7%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 18:14:10 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v4 8/8] octeon_ep: add heartbeat
 monitor
Thread-Topic: [EXT] Re: [PATCH net-next v4 8/8] octeon_ep: add heartbeat
 monitor
Thread-Index: AQHZXJ+Obnch9ZyMr0Oq65l2Y6Ll4q8IMFuAgAB8JPA=
Date:   Thu, 23 Mar 2023 18:14:10 +0000
Message-ID: <MN2PR18MB2430F4C6F2EE41D650C3651DCC879@MN2PR18MB2430.namprd18.prod.outlook.com>
References: <20230322091958.13103-1-vburru@marvell.com>
 <20230322091958.13103-9-vburru@marvell.com> <20230323104703.GD36557@unreal>
In-Reply-To: <20230323104703.GD36557@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctN2Y4MzE1NjgtYzlhNi0xMWVkLTgzNzctZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XDdmODMxNTZhLWM5YTYtMTFlZC04Mzc3LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iODcxOCIgdD0iMTMzMjQwNjg4NDY5NDMx?=
 =?us-ascii?Q?MzA1IiBoPSJxRVR1V3ZDdWFHZEZJaTFud0x4NjZDUThCeFk9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUFK?=
 =?us-ascii?Q?Vk5sQnMxM1pBVUVGL0FLMHhqVThRUVg4QXJUR05Ud05BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR18MB2430:EE_|CH3PR18MB5509:EE_
x-ms-office365-filtering-correlation-id: 026132de-f0c6-45be-548f-08db2bca66a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uqjwSLsjrpKK5pXFUn4acnv6SJEo5kdVJ2Rc80d5e42E2GLbDp2mRl5E97AQq6d6wSwnCqGNwzj+wdIGc7bGc9k4YRB3c0BycVCcZPwumNSG8QwJegunxzCJCvB6iqSqtVJ2k7UAltryaOhmcRT1LqiRdHKIsx2P1a2FG8LdqyND9o+Y969zcs85cSiQui82jEIZ7nv/W0XRuKfB62bMzxQ3ZnHug6mRwlSxgiAtsP3qzc65oMPxmRf1Il1eFqfPtb7mqZ6HrVPVSHX0Y0FNUF2zLzd41I8kSobGjyOL9hIIzY3aNzwvs6KSl2zdg7pldSiPgZZO3sr/5lc8KDHqe/3+i5fJcT1hAjPzrclYYV/ie4wn21EakGiFk15c79ohxJ3aZVrKQjAJ7L594drMa4O3+XV/0hnd3l6HpNYzo3kWDSTzlAkyzJJ8+4gnmDO4CQGHTQ2tjwp3dpDeUXGIYih4d/TZXf+W71GS6nJFtcCn+D+0aJ1DZcXbrr8758mLgbnpBMbArJsZ943x5uvUd7BsEkXOFA183oFZhdZWekg4YXgDxW4y9lb64mcOUGeok+/9lnjL+w8MrpDe6YS7KWv5dYVFS64qaTXTFFE0ql7mrUE/MaRifKEmBJza+7LPjzQrdLNsfQjtlRbC22+xo7ihnlsoOqa3jnfvjwNE7ruEYLuPANjE0PN7w0B8HEeV2HGc+CBWrL/UdAly3eDIhJ3tHIEL4A5zRJAy67MIVWA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2430.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199018)(6506007)(38100700002)(122000001)(53546011)(26005)(55016003)(83380400001)(186003)(9686003)(5660300002)(8936002)(52536014)(38070700005)(71200400001)(33656002)(54906003)(86362001)(478600001)(41300700001)(316002)(2906002)(64756008)(7696005)(66556008)(66446008)(66476007)(8676002)(4326008)(6916009)(66946007)(76116006)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JK2djFO8H1CrBcprW7t2nwXOyqPl4sw/ByeiVsgVvnkp6F0q6CpMNWCXrruF?=
 =?us-ascii?Q?W5lSW+pQyjYtv+QPkap+/cSixZAz4Mb2muSQbUqKRNMdDnGgmvaBu/Oh+Rt2?=
 =?us-ascii?Q?wHtHIiOFKgHe8eT/1FAhrBx48np4l6fzHrOYHXz71RiK+8yIe6+0rswcGQ92?=
 =?us-ascii?Q?rycUrtmt3XaXIL6iSWCuHPASUjA21pQxEN64r02x6jdw05VaVd5h/FFpyZgA?=
 =?us-ascii?Q?f1sycDqYp3SfSOgWZhpxVjt+Nq3T2E6uDS0/OOM1buQnRps1Un0qFHoPGfDu?=
 =?us-ascii?Q?WO7ws2oUTJ88h270iI54UdXzipaSQkhsUymogU7WY40KKjzmntbfN2Mt47fU?=
 =?us-ascii?Q?7mp9N3g70TG3mpiFZmHX5HiYLZ1QAKxXFNOYBgUcsWOwIq5xY+MkI0DQfBhz?=
 =?us-ascii?Q?gIGwpSV1c/l5vZR0bZKD9vbV5bd5+Rf0W/gtq/zrqZ1BrQOeQJ2GGFN/YclP?=
 =?us-ascii?Q?dI5z6lTAYJh6Z+gPUEbH+Yv3oMjR4t2SxZmraYy1NpFTIlLgVx2SVdQPlt+G?=
 =?us-ascii?Q?pNZeTM1i6Vschqxc9KXcuGp2wb4gboznWwmuJS4rZl/ifHhAXPbWs5GbCtCZ?=
 =?us-ascii?Q?6oB229eaCIxzhA0/z+HS4m8LrA4pSh1XMwUBOJFTAP4H2bpxiSDwgJMjaP/V?=
 =?us-ascii?Q?VfME/9Z+u7dFhwfXMGhv3G+1OOUCZQQK9cjQRr8RROX+y0SEYuzw3VjTTV6z?=
 =?us-ascii?Q?JqvdWEJB80gftlp+XOr1LzzRbagKwWZCjHmfMV8kp+qv7r+NxmoGypOdiEnf?=
 =?us-ascii?Q?mDJs75CzvjYrEs9DaqsonatPLUuuetO5145u4wf+g3krhn/5k53SFgCsSaBL?=
 =?us-ascii?Q?j+9RYfG4pTDmIWpfD4X9qiiX+IjbxigJ5KQ4JtTVuskg4cIaR77lLOt6Ja7m?=
 =?us-ascii?Q?+7/rF+T0TgA75hn//D34GpJCWnfJ1zXgbcKe7OQbw01WxYeCoE+8IYfSSsTd?=
 =?us-ascii?Q?Y8WvIa+9S2xVNTHKg4qazx5ons6Tx4RiOAxvIBcHL0CGovHsvOmfoOu6nK7H?=
 =?us-ascii?Q?UJiBCuCOtROAXWycWumv/An+ZEocSD+oeNpIqHr1N/jOGSbRzco5ePQHBgnw?=
 =?us-ascii?Q?hEC3Yba3H53TQtGiyCmoIhHW41djdRJIc26wM+XQu7GOjkUMRI45y9gqis/3?=
 =?us-ascii?Q?o8Fd8MRf09+twaWwhGVQDUDnv8n5Qfzqk16JkviD/lfi5TRW+DXSZGmA13NR?=
 =?us-ascii?Q?m8L+YEb9FGOWr/IBpyZB9lZqquT36tj06ITHIPojvNNMZ+Y5NSIIHy/0ancN?=
 =?us-ascii?Q?gTEiA8Tn28qZZxgXHq0APJOxudRuW6yWajWY2v3JhQo7J06CrnGKYYrbVyM0?=
 =?us-ascii?Q?BjXLt34DA8pERZk1bUPvij8NhF1rX4rOOYsn1f6oOqNbbgcDj2BBFsuDfypW?=
 =?us-ascii?Q?floVM3jDvnACH5JMoGrRfYK1wXRGYFLHqCkSr4abzyqDUWQzSE6hdMqRp88f?=
 =?us-ascii?Q?uF4+F1/n18ak/K+gUsLbVOeAW3bRD03xJkw7TvUzDMpEfGHOWqYezvqOpW+K?=
 =?us-ascii?Q?VocKLNBfACforDsM6eUwfgL6xwe/ypPy8ixEp7kD40YsHKz8bPR0k5VwXpHS?=
 =?us-ascii?Q?9reseeYisyKj3KK0IeSSD7T5wYPEXnF9AEzl8GT/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB2430.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026132de-f0c6-45be-548f-08db2bca66a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 18:14:10.8128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SloYjlE8yHhfhN6Iu2qJRkgQhX9VMVJ7xYBnhnA0mpGo1BWW4TlaQyls8223wfCaHE65ResbsmVushJG5GAocg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR18MB5509
X-Proofpoint-GUID: m6n1LVnjoSwoZsUfzd0ZKaMEV8Yw7TEu
X-Proofpoint-ORIG-GUID: m6n1LVnjoSwoZsUfzd0ZKaMEV8Yw7TEu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-23_02,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, March 23, 2023 3:47 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v4 8/8] octeon_ep: add heartbeat
> monitor
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, Mar 22, 2023 at 02:19:57AM -0700, Veerasenareddy Burru wrote:
> > Monitor periodic heartbeat messages from device firmware.
> > Presence of heartbeat indicates the device is active and running.
> > If the heartbeat is missed for configured interval indicates firmware
> > has crashed and device is unusable; in this case, PF driver stops and
> > uninitialize the device.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > ---
> > v3 -> v4:
> >  * 0007-xxx.patch in v3 is 0008-xxx.patch in v4.
> >
> > v2 -> v3:
> >  * 0009-xxx.patch in v2 is now 0007-xxx.patch in v3 due to
> >    0007 and 0008.patch from v2 are removed in v3.
> >
> > v1 -> v2:
> >  * no change
> >
> >  .../marvell/octeon_ep/octep_cn9k_pf.c         |  9 ++++
> >  .../ethernet/marvell/octeon_ep/octep_config.h |  6 +++
> >  .../ethernet/marvell/octeon_ep/octep_main.c   | 45
> ++++++++++++++++++-
> >  .../ethernet/marvell/octeon_ep/octep_main.h   |  7 +++
> >  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  2 +
> >  5 files changed, 67 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > index e2503c9bc8a1..90c3a419932d 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > @@ -16,6 +16,9 @@
> >  #define CTRL_MBOX_MAX_PF	128
> >  #define CTRL_MBOX_SZ		((size_t)(0x400000 /
> CTRL_MBOX_MAX_PF))
> >
> > +#define FW_HB_INTERVAL_IN_SECS		1
> > +#define FW_HB_MISS_COUNT		10
> > +
> >  /* Names of Hardware non-queue generic interrupts */  static char
> > *cn93_non_ioq_msix_names[] =3D {
> >  	"epf_ire_rint",
> > @@ -249,6 +252,10 @@ static void octep_init_config_cn93_pf(struct
> octep_device *oct)
> >  	conf->ctrl_mbox_cfg.barmem_addr =3D (void __iomem *)oct-
> >mmio[2].hw_addr +
> >  					   (0x400000ull * 7) +
> >  					   (link * CTRL_MBOX_SZ);
> > +
> > +	conf->hb_interval =3D FW_HB_INTERVAL_IN_SECS;
> > +	conf->max_hb_miss_cnt =3D FW_HB_MISS_COUNT;
> > +
> >  }
> >
> >  /* Setup registers for a hardware Tx Queue  */ @@ -383,6 +390,8 @@
> > static bool octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device
> *oct)
> >  		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg0);
> >  		if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX)
> >  			queue_work(octep_wq, &oct->ctrl_mbox_task);
> > +		else if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_HBEAT)
> > +			atomic_set(&oct->hb_miss_cnt, 0);
> >
> >  		handled =3D true;
> >  	}
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> > index f208f3f9a447..df7cd39d9fce 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
> > @@ -200,5 +200,11 @@ struct octep_config {
> >
> >  	/* ctrl mbox config */
> >  	struct octep_ctrl_mbox_config ctrl_mbox_cfg;
> > +
> > +	/* Configured maximum heartbeat miss count */
> > +	u32 max_hb_miss_cnt;
> > +
> > +	/* Configured firmware heartbeat interval in secs */
> > +	u32 hb_interval;
> >  };
> >  #endif /* _OCTEP_CONFIG_H_ */
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > index ba0d5fe3081d..415dd06ff344 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > @@ -901,6 +901,38 @@ static void octep_intr_poll_task(struct work_struc=
t
> *work)
> >
> msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
> >  }
> >
> > +/**
> > + * octep_hb_timeout_task - work queue task to check firmware
> heartbeat.
> > + *
> > + * @work: pointer to hb work_struct
> > + *
> > + * Check for heartbeat miss count. Uninitialize oct device if miss
> > +count
> > + * exceeds configured max heartbeat miss count.
> > + *
> > + **/
> > +static void octep_hb_timeout_task(struct work_struct *work) {
> > +	struct octep_device *oct =3D container_of(work, struct octep_device,
> > +						hb_task.work);
> > +
> > +	int miss_cnt;
> > +
> > +	atomic_inc(&oct->hb_miss_cnt);
> > +	miss_cnt =3D atomic_read(&oct->hb_miss_cnt);
>=20
> miss_cnt =3D atomic_inc_return(&oct->hb_miss_cnt);
>=20

Thanks for the feedback. Will fix it.

> > +	if (miss_cnt < oct->conf->max_hb_miss_cnt) {
>=20
> How is this heartbeat working? You increment on every entry to
> octep_hb_timeout_task(), After max_hb_miss_cnt invocations, you will stop
> your device.
>=20
> Thanks
>=20

Yes, device will be stopped after max_hb_miss_cnt heartbeats are missed.

> > +		queue_delayed_work(octep_wq, &oct->hb_task,
> > +				   msecs_to_jiffies(oct->conf->hb_interval *
> 1000));
> > +		return;
> > +	}
> > +
> > +	dev_err(&oct->pdev->dev, "Missed %u heartbeats. Uninitializing\n",
> > +		miss_cnt);
> > +	rtnl_lock();
> > +	if (netif_running(oct->netdev))
> > +		octep_stop(oct->netdev);
> > +	rtnl_unlock();
> > +}
> > +
> >  /**
> >   * octep_ctrl_mbox_task - work queue task to handle ctrl mbox messages=
.
> >   *
> > @@ -938,7 +970,7 @@ static const char *octep_devid_to_str(struct
> > octep_device *oct)  int octep_device_setup(struct octep_device *oct)
> > {
> >  	struct pci_dev *pdev =3D oct->pdev;
> > -	int i;
> > +	int i, ret;
> >
> >  	/* allocate memory for oct->conf */
> >  	oct->conf =3D kzalloc(sizeof(*oct->conf), GFP_KERNEL); @@ -973,7
> > +1005,15 @@ int octep_device_setup(struct octep_device *oct)
> >
> >  	oct->pkind =3D CFG_GET_IQ_PKIND(oct->conf);
> >
> > -	return octep_ctrl_net_init(oct);
> > +	ret =3D octep_ctrl_net_init(oct);
> > +	if (ret)
> > +		return ret;
> > +
> > +	atomic_set(&oct->hb_miss_cnt, 0);
> > +	INIT_DELAYED_WORK(&oct->hb_task, octep_hb_timeout_task);
> > +	queue_delayed_work(octep_wq, &oct->hb_task,
> > +			   msecs_to_jiffies(oct->conf->hb_interval * 1000));
> > +	return 0;
> >
> >  unsupported_dev:
> >  	for (i =3D 0; i < OCTEP_MMIO_REGIONS; i++) @@ -1002,6 +1042,7 @@
> > static void octep_device_cleanup(struct octep_device *oct)
> >  	}
> >
> >  	octep_ctrl_net_uninit(oct);
> > +	cancel_delayed_work_sync(&oct->hb_task);
> >
> >  	oct->hw_ops.soft_reset(oct);
> >  	for (i =3D 0; i < OCTEP_MMIO_REGIONS; i++) { diff --git
> > a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> > index 836d990ba3fa..e0907a719133 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> > @@ -280,6 +280,13 @@ struct octep_device {
> >  	bool poll_non_ioq_intr;
> >  	/* Work entry to poll non-ioq interrupts */
> >  	struct delayed_work intr_poll_task;
> > +
> > +	/* Firmware heartbeat timer */
> > +	struct timer_list hb_timer;
> > +	/* Firmware heartbeat miss count tracked by timer */
> > +	atomic_t hb_miss_cnt;
> > +	/* Task to reset device on heartbeat miss */
> > +	struct delayed_work hb_task;
> >  };
> >
> >  static inline u16 OCTEP_MAJOR_REV(struct octep_device *oct) diff
> > --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> > index 0466fd9a002d..b25c3093dc7b 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
> > @@ -367,5 +367,7 @@
> >
> >  /* bit 0 for control mbox interrupt */
> >  #define CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX	BIT_ULL(0)
> > +/* bit 1 for firmware heartbeat interrupt */
> > +#define CN93_SDP_EPF_OEI_RINT_DATA_BIT_HBEAT	BIT_ULL(1)
> >
> >  #endif /* _OCTEP_REGS_CN9K_PF_H_ */
> > --
> > 2.36.0
> >
