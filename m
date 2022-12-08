Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D979764684D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLHEmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHEmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:42:07 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0AD2A413;
        Wed,  7 Dec 2022 20:42:05 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B80hoD4002479;
        Wed, 7 Dec 2022 20:41:59 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m86usj6ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 20:41:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJe4RgFA8gzKop0rw5Hbw3PHWTKPwBp6XA4sONS8UadQbci3Y/9OilCfcmyXM8mZlXQ87qGAqUZYGm9P9A7XPdsFtTMFPsXIfyw4Nk+DStmYdIAs8Nw0NeFqazMHk/QtVY82JY07ZLmBGUQFs8Yh/2EMiVynqif8Ny+1k60MWw3u9SFZt027CqfvIKQOLVH0vPlSg0uJCbi5kuvc6mi0H4ea0rJ8Kp5FTem7MQM5FhWh8mQN43Xv2YfPOFZN2bdA66etYcs7R6yxoMV1q5b98/dut8PpwoO+Ss8WOlGnvmwLEuuXVucPhOmhaVcFhLugMmQobDwfIHWDsx+ic9RCvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiWZJzdfTRXMorKVCcK9sJiemItykXRZqq94QDAx3RY=;
 b=DlS9coWX5aLeiHOfJyZD8a6lCflAEo3hkg+Tubz2VtyOX5ybMxfDyRz/jeynBGZTwugR5t9Wim60sAh5fOkRhHdqaay8doQDS1nGROr38sOVH8579fvyL+t7bvrxy/jwnYXnL21HPtxRsblug4jGHuIYIETyJqlgV5SbpyXMEqOwS+LzxKBl7SUpOGUv+IiFxCdExXCRqJyHOZeSPKpTTHk66fK7x7F5lUJjTPPsRRmIhG0GIQ1fK+kHndUpA7J35b1/e3sFJpyX1qzqVpSnw5tMGPUFnHexqv4P2WE0uaTEVJ7/O3ACbYTQR6+HuFGFIM/oSD7P2PHebIYaKvI/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiWZJzdfTRXMorKVCcK9sJiemItykXRZqq94QDAx3RY=;
 b=WZHpn12TuHHVjwFM1BVNQA4lXezU9mca3+Ylki/z8jvNmoESR3wmLC8DdPb0DI3pbCVPHtJbMa0HyJqpuZN+50irbZfoPWIuyIUZlDPARfmC0G5RbhhzW8S3WsLMSCedLULj2hLethXfGSUptfbmuxU0AoC7dNN4NOQFTOpqhwc=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by SJ0PR18MB5236.namprd18.prod.outlook.com (2603:10b6:a03:43a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 04:41:57 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 04:41:57 +0000
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
Thread-Index: AQHZA/PZs+9RX6z1+0m5ZGIy8eBWva5XNNSAgABoFsCAARQmAIACoOYQgAOoOwCAAQ3cAIAAkfKAgACNHgCAABTMEIAAcicAgAAy6jCAAYrHAIAAAm2g
Date:   Thu, 8 Dec 2022 04:41:56 +0000
Message-ID: <BYAPR18MB24231B717F9FF380623E74F4CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
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
In-Reply-To: <20221207200204.6819575a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYTM1ZjkyYTYtNzZiMi0xMWVkLTgzNzMtZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGEzNWY5MmE3LTc2YjItMTFlZC04MzczLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMTA1NCIgdD0iMTMzMTQ5NDgxMTUwODg4?=
 =?us-ascii?Q?MjcwIiBoPSJpK0RZZTFZV2Q3WmdMbHhzYmFzcVl1Rk9hZTg9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUJP?=
 =?us-ascii?Q?dVFabXZ3clpBVEhXTHNoL3dTUUZNZFl1eUgvQkpBVU1BQUFBQUFBQUFBQUFB?=
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
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|SJ0PR18MB5236:EE_
x-ms-office365-filtering-correlation-id: 12cb54b3-3e80-41ad-4479-08dad8d68993
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u4QFOF/Y10xazFmOt1fvcSoC83WhpUJrpr0YMx1RW5BBCKZZl2j68b6TVVCZbc5pohEuL5Sh6uUbYc9ObO3gD8wftSfXTCJyRO3rTIzm283zhkmPHjDcRDoJyGmBgaczhHpUlYp4PYDN9IGFj3fte86D/8T5wqW6LH2Y1nO2IcruFabW8XEd5V4laNv18zd486iJ3tp6J18SAWPh8VEtoUNl9SPAqdixcnY0xVOw0ReIcurrEMG6dwSXng4DicsHbVvzOx3OINK3v5xbLzVp22mQMLH55XdfXHlmI0oNviTw9QVCEYTrTifEv91ta46cAFXfwuKXI3QAsukfmBLklDwWLmK9jtxkqyTQjl0fXILiQIwjb1GBvCia8Rp2G2G4pEcERj/rFxw+qd4ksolaFgHnKXrsVReEoWXUXO3Kh3GjjntBa3n7H6EZYMv/3XnQs1zAQfdEPWWvOnEs9lMtgkpiF97YgPeG7OZoj06ww5oPF9N34xuDWw4mBjztwUzat0G6Kr5V2VYspcCB9tkSNRe9x4ygTWGGCYW1o1SHJPaTJYri29GmDnNchbT37NaZV2bSnckd4xfOqADeKtcOTWWt3E/MECFq2Z2NZ0edLCmkS/vYbZwDtejYnubu/0rX+ZdqUbGB0oL7paL+UKheSfWkBQAX4duK2p6yb7qygE362IKqIafeXblwSkQZtGmE/fQ64gzRQhyyVYc2D7gw+OnkVEFzhupjlIdvLxIDnPI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199015)(83380400001)(38100700002)(15650500001)(122000001)(33656002)(8676002)(86362001)(4326008)(76116006)(4744005)(64756008)(2906002)(66556008)(8936002)(66476007)(66446008)(41300700001)(38070700005)(55016003)(66946007)(5660300002)(53546011)(7696005)(26005)(6506007)(186003)(9686003)(71200400001)(316002)(478600001)(6916009)(52536014)(54906003)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0ksshopHruE9ThmSF+mE7FkqhPzRR53ArGOccK9m4F246XE50NXAcY1tCfIO?=
 =?us-ascii?Q?MivLeLr8wTiQJd7BNvohQJw4Dcn4hMVO4I730HvKRlg5yD3QATK/krGAvbSB?=
 =?us-ascii?Q?oiu389oGOHxttL6BnDRuoiBd37Z2w3LQ3CHP3U1y37eUXyptacYaiXN7AW0x?=
 =?us-ascii?Q?1KQOMwj0pO2Y6FZkDv/2txZj4j9gljSYvg7QDDQ49j7b/L4hnz1SGzLBh+Hj?=
 =?us-ascii?Q?sAWIr5EXN4l9LCwAyMgrOaKZR/WwdjcWxKxMeAY6jCfVOS9GljfgdxA83daq?=
 =?us-ascii?Q?bFcLG3T/hbSU8mXJvWsoubI1xCDU5p2BzTg3W+E8bbw2LUJFZrTe1GmqcqdL?=
 =?us-ascii?Q?KL8rlfAaKkyUIDTXaZs/+aRtR5MeNdf26W4t8iDE6ogaJPSRFdIGh4xsQNo8?=
 =?us-ascii?Q?JEJEUX2h0vIbuUDbANsQ6PgHFMcl5KqetfbFWnSUHW1BGKqX/BkfRVdCVxfi?=
 =?us-ascii?Q?uRjDetF8UYwZx/5UtLtYihvHRcL2llag4sALg5CJ0ObdKxtp+oZRO9m3mYbB?=
 =?us-ascii?Q?tvCTGENtc5ti5ohx/r2SyEAzofUNSBX7/qWx79bp++6Xgj5/OQlSkSs8gw4E?=
 =?us-ascii?Q?Do8XktuO8ZvnHsAw1kehNtZ/gceI/fMHnVSJ1q5cIXRKFYKizWOeouNZlLtW?=
 =?us-ascii?Q?RB4blGhSIf2YlvbPKfYwRB5rtPduqfEyTmSi6wjsF+ZxGq+Dvv0GqSHAiBNN?=
 =?us-ascii?Q?K4KT7GIhr3KjczKCUWh7A43+qr1Qml3XJRjvWBggW/WuQWceIKfnQMPeQ3cn?=
 =?us-ascii?Q?F6r1wB1TLr0YCr5mraH7n4z0IEQYBQt3k9kPE6ayirlzapXi+KxbiJB5fBag?=
 =?us-ascii?Q?1blZWF5l2u/uhntbTj9M9GPQ1px2cNCweFmP21cq2crrKvZFowfAYz0joeVV?=
 =?us-ascii?Q?uT9P4R0mqNzbBbHAV2D7SppTq4A/Q86NY3/L7pPywlbeQcHLdGndZ7Pa+EOw?=
 =?us-ascii?Q?mbfl1WK5w8A2jcw+9NbbHrZwFRI0GzcFe3UaORemK3JuXwHFAW8zVsY+pKXA?=
 =?us-ascii?Q?qxYyTBFEsb6tWauuZ/Jinp1kXnkXxcNSQPYck5y1/B/rolc88Try9OhD6MGB?=
 =?us-ascii?Q?yTFcWdbqEsVX79zGCM+iABs9BlZSHDYfyD27/HNR5ZSpyBq2kZexuNWSt4j8?=
 =?us-ascii?Q?JsqSlv37OOoZmNPpaqRilyJWWI1bNRfRoTZop6taO2FCNggJc+zCDHy2lKZc?=
 =?us-ascii?Q?W7szZ8m/e1ZbKz358evsa1xU12H2K1Ctsmw3+juKY0rTAwKVI/6n1n7+2BhE?=
 =?us-ascii?Q?muWIBia7tzVsIo7kxki7Uy4Vy7PF7mmPmo/sXr9OkoJnsLmZeVR1pUBX7VZK?=
 =?us-ascii?Q?G/XfIeCx3mMUfQfwVKFleGdGQBoGwNXe4j6rjHnFmsjKR9xzi4ozuITE/8yq?=
 =?us-ascii?Q?4zsGksiIL4kRyDtRc/MUjMoun1hfyDjKkAzSbUqFZ23pgS76hC/fd5ZXB4hv?=
 =?us-ascii?Q?/BMri2UoY34ufVbA3gbdwDUjexcUs5bBfUjW9dLpD+NUSR0nIubzZ5hq03Cj?=
 =?us-ascii?Q?1sbD55mfjo/wpZryHdNXAcCiMv4K4gxlcNpSFEn1STkp9y1Hvm87YlG1+USc?=
 =?us-ascii?Q?bXZ6XA2khP3EuIzqbExBtIAbns9qIOrmIx98Gj5z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12cb54b3-3e80-41ad-4479-08dad8d68993
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 04:41:56.8608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EAOPIp0S4oRQwaRYDsdHQKXWXfIRiAnaGQV2R+MUAYijPjNztl/9z5k1XgGrcOF5ks+8rbftrFKNYgGBAz51wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB5236
X-Proofpoint-GUID: NbF7BDU4NBCTFaYg--YyKwN2H44o9lMd
X-Proofpoint-ORIG-GUID: NbF7BDU4NBCTFaYg--YyKwN2H44o9lMd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_02,2022-12-07_01,2022-06-22_01
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
> Sent: Wednesday, December 7, 2022 8:02 PM
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
> On Thu, 8 Dec 2022 03:17:33 +0000 Veerasenareddy Burru wrote:
> > We have a follow up patch after this series implementing
> > ndo_get_vf_xxx() and ndo_set_vf_xxx().
>=20
> We don't accept new drivers which use those interfaces.

Kindly suggest the acceptable interface.

Thanks.
