Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9564C44C
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbiLNHP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLNHPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:15:23 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE5E20369;
        Tue, 13 Dec 2022 23:15:23 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE6UbYA013706;
        Tue, 13 Dec 2022 23:15:08 -0800
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj0qxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 23:15:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmMo7p2jPMr1XAbuRS6Oa508JsW8ZBX2u7TH5CBroRyCDof6Yz+4OFoKKS0si5G7/g1gjwPRxeBwGX9CLQ6VYA7tvgrv/8CvgyDlyX1rV3J07JeN768qUwUVDwhEE+uVZwi5uOx64GquMG297EoQqZXYh/lD5Y3a5lEVVADrLlgeryEEenDGHCYSOwB41GSMwlkillClolx10yNN4oOAJwG5TQ3YoN/0iLfRSW22ND9oIHSeyy7J7UbIO3Q3ADRX8PcnuhuwWQ/CWBKAybQve2boZQ8MH93MvGI7h6vfgk1vpF5wJ2aK3KkxRxSd7Ony9oqCz3wmd6lYURaZ+H+Iww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3si2CNNqOMkrwEhvNwpbSYHK1e3AlyHWQNTerzEmFk=;
 b=UaOGw8Ajd9t0e/g3YGydNVG5BfWuK6yuQhVgY/XenSUW0KyxkG6M7uuqq8X5ulGC2CWkcNK+o6iHzR8ZCCVd6H6SCaWAt9NtLOw2Ly8fqOGMYSFtx3FpweZowl4go7yb9cfd3d/pZsqDsaED2ksU14ncBp0+v8ub0u7AyssWdrQMZ7iZiT9WKL+UvCP4kyPzBHIdqLKupgIuAhiD75HwQ8OOfisdlF5RtQeHeuY+dcPgHCQdXWsuK1Yb26XFeBE5dn4l7I1893W2JUfCy9zaPz3TSCnqIv73GDuteYTacSigHmIO50yYNGeLYsBk+mxdTE+0gyu5mA8HyI/lBUVaDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3si2CNNqOMkrwEhvNwpbSYHK1e3AlyHWQNTerzEmFk=;
 b=MS36MmOXfrdIFsi/A3k+25swLBc2fC7le9IWfPD3sp62TaLndPWqdXuZKfr1fw7eY2X2AFBHlOjX8cOIkrNiPqj3bL1bxKQuVocD+OdNWMwEtT3gi71gkA39WcbsjrLA72ipix0OEnK7gx4HJygkPXcdJmaJPHBvEbbD7+l+j5c=
Received: from MN2PR18MB2430.namprd18.prod.outlook.com (2603:10b6:208:109::23)
 by SN4PR18MB4966.namprd18.prod.outlook.com (2603:10b6:806:219::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Wed, 14 Dec
 2022 07:15:04 +0000
Received: from MN2PR18MB2430.namprd18.prod.outlook.com
 ([fe80::293c:2f48:397d:ac6]) by MN2PR18MB2430.namprd18.prod.outlook.com
 ([fe80::293c:2f48:397d:ac6%3]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 07:15:04 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Topic: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Index: AQHZA/PZs+9RX6z1+0m5ZGIy8eBWva5XNNSAgABoFsCAARQmAIACoOYQgAOoOwCAAQ3cAIAAkfKAgACNHgCAABTMEIAAcicAgAAy6jCAAYrHAIAAAm2ggAAKLoCACQTnAA==
Date:   Wed, 14 Dec 2022 07:15:04 +0000
Message-ID: <MN2PR18MB24305B80B53123F80C2A953ACCE09@MN2PR18MB2430.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
        <20221129130933.25231-3-vburru@marvell.com>     <Y4cirWdJipOxmNaT@unreal>
        <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y4hhpFVsENaM45Ho@unreal>
        <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y42nerLmNeAIn5w9@unreal>       <20221205161626.088e383f@kernel.org>
        <Y48ERxYICkG9lQc1@unreal>       <20221206092352.7a86a744@kernel.org>
        <BYAPR18MB24234E1E6566B47FCA609BF8CC1B9@BYAPR18MB2423.namprd18.prod.outlook.com>
        <20221206172652.34ed158a@kernel.org>
        <BYAPR18MB24234AE72EF29F506E0B7480CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
        <20221207200204.6819575a@kernel.org>
        <BYAPR18MB24231B717F9FF380623E74F4CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
 <20221207204711.6599d8ba@kernel.org>
In-Reply-To: <20221207204711.6599d8ba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMDUzNjNjMjgtN2I3Zi0xMWVkLTgzNzMtZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XDA1MzYzYzI5LTdiN2YtMTFlZC04MzczLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMTQxNiIgdD0iMTMzMTU0NzU3MDE0OTEy?=
 =?us-ascii?Q?MjMzIiBoPSJEM04wQlRDTDdMWDZHTHdPbDRzYm9LM3NKUW89IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQURw?=
 =?us-ascii?Q?L0FiSWl3L1pBZG5uaTlndlFYdEsyZWVMMkM5QmUwb01BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFCb0J3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTNUekZBQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQURRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR18MB2430:EE_|SN4PR18MB4966:EE_
x-ms-office365-filtering-correlation-id: 809e98e0-64d8-485f-2772-08dadda2ec2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vxEJbIL0866DTzd5kRT87aUcAiY4vzBzLvkqH7ZCpm1mUPZnHL74bSOFVnThJ5fpbvjzhBtRk5LjDYM9kmdwBBhnWrbhyIf9FQmFDus7EmnxqGQ05Dvvb9O2jR9VmnYqZ6s7KB/FAhSFOIdqjD/ockZYjSbyuxBK8h9RFOhaZV9IdHBQsQwtmFLvB7ZzaR1Iu8wvCzHkVP94CJnlRX3nGmkrtxgR7H/APn13GbBeyrDfkrHA/Q+fGvkCt53ZjwOFynhuU8cVCOp1vTeYhsZVcmRafg8sPZYmdF+z4CdTx+vvObvEhEfMh77oiC++8Gy5HEMj+oMWU7l/B7XuwDo3hUQfIf+oUbSH/eRJS5mEZbPhM22oV9jW1jZjSqA12HjTjJtIEYnN4+jSt+M3acv5eHLOBtA73PKDIGG4R5fhH3/bJI3pS/3TU3KryZ0XfYRz1nCyCYSPRuDqSC2TzZaeTpz8hxapYWnfpQfXUNmwE89Po+qZVPVW5wsYJmD9WDLgioj9IWZUHVCpsa73dWd3uCvRM6xzLRmQLG0G0c2L1oz2rkwNyUsIAQ8EDTuiAcKNglZrgnsLsVE/wJXSgyWtcGCiMVaG2aaFnlh2OO9zxE3CKyVweCjdCRKn7MQA3xvaOEMMiFWvLJaSSQT67fcM5JQRADFZHj7txxUfdDQb4kDCVxsMttyUqsViyRTGNb23qfMYU0YgcvnVD+1qGsMAs3Ytp6YG+SDVnQgA+N+mwfc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2430.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(66946007)(76116006)(316002)(122000001)(83380400001)(41300700001)(38100700002)(8676002)(8936002)(38070700005)(478600001)(54906003)(66476007)(66556008)(52536014)(66446008)(64756008)(4326008)(2906002)(15650500001)(71200400001)(5660300002)(6916009)(26005)(9686003)(53546011)(55016003)(7696005)(6506007)(33656002)(186003)(86362001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RH23Osz6Kr3c5HE6X3zd6TXaBL3gJbKAzD79YjitsD4hw9rpNhUKwPHAMr6y?=
 =?us-ascii?Q?IpbcDYva2s+Z3zaEfoVI95f8xOXWISfaKXroOhWfrtrR5LrgJmXpsou1J3Er?=
 =?us-ascii?Q?+sndgawJMeNWWUD5p9QyfNurFzITBgznrwHdvq/Z/YBWe7eHWb+Eb5nOt0wJ?=
 =?us-ascii?Q?ezONZbvFGN4IzHKh0d79Z/gu4j4AtL5rJOUmea7+hLUYIKMUpDjFg2BONJl4?=
 =?us-ascii?Q?AGwwjI99dDYZJKOGpM5CR5UPyaKcO1pMLs+Y1hl3vIh2UpPMG249HKoWc1Bw?=
 =?us-ascii?Q?9CQqk6wK0IdRKS2+MFWZLq06bpE0EZL8g0WIsXyub+c+xxJbUMjqSSRRSD/k?=
 =?us-ascii?Q?ePaqFpMdGB1d1uQj86IbYR7KGNFB0V4T28i6VgwhmoRwwHE6hZ6e5vnoVHeE?=
 =?us-ascii?Q?PB+AS4XhGgE/Np6femNb0gRj6LfsZYnSMa0FrUxUgDDpGn/BqvoUfHiwE36g?=
 =?us-ascii?Q?W4KZvA9n7Nxf3BWPl+1kC7wiTx37Hr7mxcP2mOFVCxeA9w6RkrKy6HIyYby7?=
 =?us-ascii?Q?zNjt0pcUFsl7N1KjaqpnhxQsCNZwdexK+25UKQKueitSD9qNXRDUPYEZ2fjJ?=
 =?us-ascii?Q?51jLc5kdhOoTMH0DBETbjU/AVLtDvoQFMyMvZjSCxGCJ0A8iC+TsSpoGDaCZ?=
 =?us-ascii?Q?TyqHHUGiNYeOkBf5/AmMB8QASqta0ZLd48tYeXzmX8oVGjjBCMiOXvFoGpCn?=
 =?us-ascii?Q?MpIl/7tPUI9IO62qEZ4Gyh/V2Lj048pwMkcGSBud+mR4JRKedFZZwD4ysSfU?=
 =?us-ascii?Q?l28UDotql/HdkycsWrtxQEogg+smP3ZhCfaSok8TwP1hsl7gu/E8S5NbWxVb?=
 =?us-ascii?Q?uGW1N/o1rjV/4yblXKGVJRKvVDeW8xrnJeCG0Lxav4FG87S8syjKjccwpq7S?=
 =?us-ascii?Q?kT2udVTuHE7PFT78CJc3Mg3ZwfePQ71MdOMM0BD6cRD/Jgs0bI4KlLiHGKET?=
 =?us-ascii?Q?VFf72JFxX7KeyT1RN271WLUqj+mh007OFh4kjc3ofFWvfoGmfFSKreec+qWJ?=
 =?us-ascii?Q?E3Gva6XSb6bhRRqXS2KIgtw60Hdyds+8kx/1Cx/SDwTJ2MrjSqGPaTFNHwp7?=
 =?us-ascii?Q?fQyM2B/eQH3qivpUWt3sVMmVzGi6Rc9I91QLHDQ19x3naSwIixKefieKLZzv?=
 =?us-ascii?Q?La3mgWY6iquvA8dvBWezCA3j7o1kjGQrBqGBdgZTNHTFKNF8xbDActYtZ2vC?=
 =?us-ascii?Q?TgG+8N57n3xQasuWhWNU/ibS2XoQnKqvykTsN29Lt5tcWrNeACml7jHYJca5?=
 =?us-ascii?Q?ypSWaaVFqbdZyBx1Sg+k+7NUovPbus/IEXSNT6KqJv9f1vsvKpqlc0AICLVc?=
 =?us-ascii?Q?iXqThbjwqR/7nhVFBchKPEcWBoCnEnczFXf1uMp1JmylpkM+/jF/1JBNgECB?=
 =?us-ascii?Q?nbvEBKAOC4dvpIe/6ITfftxwLiWveAni4m4rnIY2x3NDNwwLVu58T3YpaDHz?=
 =?us-ascii?Q?jTliJ5Jtm64rg2D63QnyoHa8nKM5PNaOhoRITKAnLHULPnThJS/Y0vtkAEpT?=
 =?us-ascii?Q?6RmQDw9+HpQG25zAeuLrndHoWEREc6pQtvoaRs71blKk65jO/vl3/zet0f/b?=
 =?us-ascii?Q?qA3AscgyL4Dhf0YSQ1Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB2430.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809e98e0-64d8-485f-2772-08dadda2ec2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 07:15:04.2700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WXpoO+Uf1rjS1AVw+AjjJXeNyzcOEBc8upVDS2++XPbMnCibORV+6JWaKK7Xfd4cHT1Jm8fTCgxgKHpXmGpGuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR18MB4966
X-Proofpoint-ORIG-GUID: Au35Nd-yIOjpbO-HPdJNIkt1Wb8TfZm7
X-Proofpoint-GUID: Au35Nd-yIOjpbO-HPdJNIkt1Wb8TfZm7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_03,2022-12-13_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 7, 2022 8:47 PM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: Leon Romanovsky <leon@kernel.org>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Paolo
> Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Liron Himi <lironh@marvell.com>; Abhijit Ayarekar
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org
> Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for contro=
l
> messages
>=20
> On Thu, 8 Dec 2022 04:41:56 +0000 Veerasenareddy Burru wrote:
> > > On Thu, 8 Dec 2022 03:17:33 +0000 Veerasenareddy Burru wrote:
> > > > We have a follow up patch after this series implementing
> > > > ndo_get_vf_xxx() and ndo_set_vf_xxx().
> > >
> > > We don't accept new drivers which use those interfaces.
> >
> > Kindly suggest the acceptable interface.
>=20
> Kindly make the minimal effort to follow the list :/
>=20
> Perhaps others have the time to explain things to you, I believe my time =
is
> best spent elsewhere.

I see the new drivers have to implement VF representors.
Will resubmit the patchset with representor support.
