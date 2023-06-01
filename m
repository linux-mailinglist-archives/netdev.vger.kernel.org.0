Return-Path: <netdev+bounces-7144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04FDA71EE7C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E4A01C20ACF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB58940790;
	Thu,  1 Jun 2023 16:15:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB74A22D77
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:15:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6012C;
	Thu,  1 Jun 2023 09:15:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4Qbe028520;
	Thu, 1 Jun 2023 16:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=47N0iO/K8kpEWk9ko9c7XKdPzcZMLSLzkGSeLddazH8=;
 b=QSUIWOEWCBAu7ArdlaXTn0TN7UcNqBRBKPDowV6cO4htd1xHuahZreCC63FCO38cKyrr
 BaJE9wsPBh7i+FUVNMOtwvUvox/aeKt1Ovhz7Alk8c7z9xPHgDMXHUARa3Y1QQZOgmqg
 7tvV/S4obu/60l1N2gZ6LEbeHRHFP+KfiOYzXvhNfRhtfng9Sz+/QfYFL4v8vZTAeuta
 zN5CvvKHHc2J+iOdq5/wTLxXlv3YGMgIEgD9AGT+x+XoE28kZtjxrKnikyaX88UOhL3I
 1Cyr9qbcEMLKLMItVjgHdKrgYkuzwgIo5KzE/DkYgYHcBFjl5iQ7q6q3q4IZCa9Ube2W jQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjks7mp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:15:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351GAVOB019721;
	Thu, 1 Jun 2023 16:15:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7nd76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:15:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJ/4uZP8t+Oj8DNpidVKZCmLD9ANQdC+pxpHfG3Dn8e377He699QFWmEEshtdHhF35ZB/gQfHWfahoZsfrZwcOoE7kU+JHEMhJ9YcDKss/NCn4416NGuf0gzT68NiyucJM39FQ9Pgoc1ftQ6sopRMZvlHda4DVMXfpUI81YletK0RiIwEmIqLYd8B+YL70Btdrb7AtOWkyorLXM0JdxsJvlfWCAsqkaxyH7AWwyqetxK91SK1Ww31mVNDpTSDbUUciYimXaeR1FhbxZ7pkuvHcqWEDe0F7Bc+0DNL6S1K6AgviHmWECCZd9cBJlzL+l2/YsuOt7zzpQyYLth6TEkDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47N0iO/K8kpEWk9ko9c7XKdPzcZMLSLzkGSeLddazH8=;
 b=WXCcRP6gEKidUFhbkZwxHSAq3z81iKGZR86OWDx6CXgHVIqeDJKnNTM/+QtzQ4DI15k7L1l5mLVz/wQwDYhh5q+7VS7kghTKN0cQfED5sjm+YWp+PFzGVd/BOKoTZv6ghAYJuhWFzxCu4WLfA9e59E33XRWIPrdtO6oT0tw5KizGRBqADeNITPrHYhwfipbA00igLyKP/Xq/uI/YPobk93ZSrJ99qwgbimQ+atirhOrkh5tFq10trYN58EHzqJhdjAsa40eQ2CeIKuJ1ew81darRSiyOUSf6SRuV0Z3+GfPbS+U8EuibuOsmq6wI1W4gxjgtzdl5qkZuBme6cnhiig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47N0iO/K8kpEWk9ko9c7XKdPzcZMLSLzkGSeLddazH8=;
 b=xEIbv0XLHEoy+rO3A0cF9Rr/SZK6CKOqgFjxvgObNPromKUe0K/q6UXWfnJ2bNzKhJn4zUOX197lUyaPgpXT1T0I6UPOdkgZcbU+d/Rx/L+6DB8uP787/khB/5tP6RmI48iqvzJfiDK4Yg+xq8Rh+K0KFIVuNoOAZZwSVmEBGzY=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by MN2PR10MB4176.namprd10.prod.outlook.com (2603:10b6:208:1da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 16:15:31 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 16:15:31 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org"
	<brauner@kernel.org>,
        "johannes@sipsolutions.net"
	<johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com"
	<ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net"
	<socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: 
 AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWAgALFEQCAJFpdAIABHiYAgBXwRACAIQQKAA==
Date: Thu, 1 Jun 2023 16:15:31 +0000
Message-ID: <BF7B6B37-10BF-41C0-BA77-F34C31ED886E@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
 <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
 <20230403135008.7f492aeb@kernel.org>
 <57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
 <20230427100304.1807bcde@kernel.org>
 <472D6877-F434-4537-A075-FE1AE0ED078A@oracle.com>
In-Reply-To: <472D6877-F434-4537-A075-FE1AE0ED078A@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|MN2PR10MB4176:EE_
x-ms-office365-filtering-correlation-id: aa8a966e-f661-4ffc-61b7-08db62bb6c2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 hAbPdCVkvyX8KveOtXDc64Xk7bn74qzbU3TFM2perez9mozW6Gc04mX6o4MLyiEub6AkejUQcMHPjdL3uFAfOcumM8lE7CWHP/DoyclQZ9WMcqk2cEawXdprqHp+0XUYBbgt4UnxXQkGttTstK3vuN5U1MSHB8VHD1AKdsMhtDZwp77by2tPFjLeIVdlQuAAqpwfh95t4IOxkbXY5P0VRkHwgXKtzQOxsrB0y7D4lXZnyZPKiz7Y/PInxAWtQFitcWMSo2oe2hx9r6imiDWkiT6MB0bdIkqNsJS4DR0wKosPjunwNkr88Y5UILMpkYkbzl1ttvfd3WR0N5lI8dadJQyF6S9W8NiGJrVq6K3DzlhYzAqKgGSUslQaDDtf+mG3jBHxwfhXDnz9uPitP+TfwFIxe9+9rH7bAAP2nRFkjFdu5W3WCgF1lVfdGkQ52WsjyhRUZIQxUPiAzptp/+xQPdU1D5Oh/De7SE8QK8XDRt0ogG21N9hLygSknz8TSBVKbennZLTClzTaUbtA0VHK1A4Lc19dDCZsuIRUeMWe5PbDnyQkM9P7EpE24NCFqQLfguG3VgbvKic1aOBzwjLMj4h9q2DBfITBTMgfYN/ZAz5P8Jy+K31I62kc1eSHRnMEX/tBBSnPapCAVx/3w1gU4Q==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(54906003)(8936002)(8676002)(4744005)(66446008)(66476007)(76116006)(66556008)(2906002)(4326008)(64756008)(66946007)(6916009)(91956017)(41300700001)(316002)(5660300002)(7416002)(478600001)(71200400001)(6486002)(33656002)(122000001)(6512007)(6506007)(53546011)(186003)(26005)(36756003)(38070700005)(86362001)(2616005)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?bXpGFUpMmpYnJJ6bLuHimWaFKrLmMcIYvlk7ixVm6G6AeGrHf+u4AWJ6ixdB?=
 =?us-ascii?Q?MTw0FMZFhdeu11duBkp3QC0RPI8DnOBRsmufuN/Pxedjz/w2mxnAF7O9YVKM?=
 =?us-ascii?Q?UGaG0wg45I4HnANFDrs3I2nbXzngic7ZYiW9fEMI0LI8v+m4/WqUME9jKlc4?=
 =?us-ascii?Q?NINNIKtid6OLk71siJSB/nOdT0pcKAoht+coAfnQSNY8L6DSRsrFqF8q52hy?=
 =?us-ascii?Q?FMVhae0GPl2lT8skkh1B4fxajXslf//TdEqpTLbzL5FeTb+Bo4RcHfURMpAC?=
 =?us-ascii?Q?XnpU2+Gs8YYAXZ2a6IVezH8OaMLdSotWRmVrQVM8ANnd9b/y9fWMuh7CDv1U?=
 =?us-ascii?Q?/X64Tr4uJBx2NtXlCttH7i0tdmh8gVA49W36R7FGRtQQJDIo2hHsjEsCtChH?=
 =?us-ascii?Q?APwRv+XIDlMxoDiE/IYtgy5zG6Q0lMGI+w9oHb7AYXobISbKBjpZ8XiqncPh?=
 =?us-ascii?Q?dqmSZCP5OIM6GrWDTdecU3jPbf7KTv/ZV9m+BUveDD2wFmodWwdTFWP2Lzd4?=
 =?us-ascii?Q?ooUr0YJr5z9katr4MS+rrvabvE8cI8Ly98bGGk47jbgDjrzX7JeSqwcnlJH+?=
 =?us-ascii?Q?l612v/9FhwgBGD52aE5IR+YpzU3+Jua1QVgbF4aF4aVQjVTq+XKHrPh5c+XD?=
 =?us-ascii?Q?AXj0I/MAWnSs9n+cH9GOSCjcM5Oi13i8tj9+TxPQpENgml++yCinalCspLuD?=
 =?us-ascii?Q?A+I27ak8OmCtJkT149JcQ+VkXtd17618DC3WTglXSgeXdGWP77jlYJFsAPIP?=
 =?us-ascii?Q?mwcOUqUlsxeq62IkGrukiyaDyTb0B/ZQW6RvVzRh7+dOmko/B0Aga7nTo/6+?=
 =?us-ascii?Q?LGOTfbDfq69pkWI2Zxn/bEQ36vl1cuD3JDaI8LC4foz3fQa+utzUAKngaaVz?=
 =?us-ascii?Q?AbN4qjcbGJvLS7Rl2dHujNJ6tC/J5s8SJABmen9HJBTEBAMeHTohsv9QS3AW?=
 =?us-ascii?Q?Xe/V9lT5ovbZE90yR56uCTbhie4P5m1rGvsDb0LCH+ctGP1SWDDKkW/gpSIc?=
 =?us-ascii?Q?PZx4RH1OGSgGl+bIQtZEKdnROFuyxflaTQlm58nCrr6Dy+SoCDeK30IrZ5Ab?=
 =?us-ascii?Q?vnKVEAOhoL674QSEw3L1oLRegmnOuowuVKai91ks775/1ZWLt0v250CWBlzJ?=
 =?us-ascii?Q?nSOIJpjJYq6OEWFqFZ7zXqOJr5rPbC2kUOktmUi5oSpxjNg6vzvZm81zRZaj?=
 =?us-ascii?Q?DsxXTvP6k7NwtA1QL0346uYmnMyNqx+O+Oz7OjlJhMg+Xw7AFd/iorK40wn0?=
 =?us-ascii?Q?Kdh7srLE4B0eKr5gmTuyduoWaWHYPPzL6FkmS9LkNVAdbaYlL4SXijDbWGZ2?=
 =?us-ascii?Q?qGbTlkyNcdSyTy982e4bc8cGQytyETzDvDuZtGftEnDB295mlMWuk5fa731b?=
 =?us-ascii?Q?gVS1Kb17DYTmeiHdRMy/HE8jVVksvH9mQmjhcZFGU6UTCQwDvZtGr4+6qoCK?=
 =?us-ascii?Q?KmTgMZVhQ03byqjsEJ3rulEB7PGWFsbJNTV6OGYiGCIbp/gYKGUyQ+sswKHt?=
 =?us-ascii?Q?9LTrUJkQ0C4aWv80jfRiKTXlB9HSUPEsEiUIIPf7FZTtWQzJepoXuIrQA1f5?=
 =?us-ascii?Q?J0m+OUkJ3QWE+2WjSM5JeA1qdDs1AedZPqXlU5CRUntuilGtqJ3/M32TnC8E?=
 =?us-ascii?Q?ZA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <428C00E8454E7E42A338E0A86451E53E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?3UM0HcOX5ljh3RJnhn/ZQtlryY1eQ6MMgaOa7zjDZMQTO47vMFTCenM3hXPU?=
 =?us-ascii?Q?EWsyin0p/pbyvH7FXfJSBw6hbQN26WMP+p8RZrWfS1t6AufG5sC20w3ODpGY?=
 =?us-ascii?Q?6aRS65fUdVUVWjS5ySqpBCQa4fsbPjnjEaA6f1OaYqpnpdCvDAy+GBhNoAVa?=
 =?us-ascii?Q?aoGCKbE7KLPczzLDRQzeFnXuk4GLWZfBxv16mzKjzlVRLXqF/3xqotUgRTh1?=
 =?us-ascii?Q?a3MNudcLJUkbJteI0KwUn9RL6PA2y69N3de5QExogWoJu7xuvXJnVPnjLgQs?=
 =?us-ascii?Q?oAwGo+kOiKXn8q5UZ26Kxq/k1mcqxzrhe0+2p3zAHTYxjgTnco4uitKDmMJL?=
 =?us-ascii?Q?Ka8iEym1okAx5ZqsZSnAHolLYQdDOS0n+/CFyPEwh3cN7bZ7HX+nNVbG+nGN?=
 =?us-ascii?Q?tGhdS3PeCZ/ZJGZDf5NCPZSnl3gsRPmJzfGsQfRgebuPHltarXgBAqcy9YVp?=
 =?us-ascii?Q?rGFVKtBFO0oN38luiUoxRUclsNP2KQpb9W5UM1u+sWqdX34ctTo/9YSA6Jjn?=
 =?us-ascii?Q?Bp01ioJmQWosMWsSTSNPxvSFRxWrqymwTSJWPCygme1EX742um+5ep3Nodam?=
 =?us-ascii?Q?zR1d8GvvS+c5SZNnqdpLyLZdPwHFpi+ibQaR1gEBl8l3LwBoXAM5JTX1DbwY?=
 =?us-ascii?Q?7miHnl+SEt2lzMKyZhqrgmJdGWbgQQ6eAS6bQXhN+WskhxJF41VucQ4klKSv?=
 =?us-ascii?Q?zmQ57HEZp9b9ItVjzpdlmaeyUR4Uesx1GzeAOIPyL1SdR1cGFbDH8bsN02NI?=
 =?us-ascii?Q?GA1HW6qZMkkzV43OqhbaVm0p2zPGzVJ+nX/gQ+paO3oLCOgn6XUd2rxjHiRh?=
 =?us-ascii?Q?LNh124IhoTKuEzJF1rK7x5gZT2ylLvcOqlAzF60JhHPCcz7nULlreeRCDYFd?=
 =?us-ascii?Q?ZwqyuU+ep5NEuepYiISmtNRnLnlJhozC4GCZaifwNOtOQNOTWmNborMz5iaN?=
 =?us-ascii?Q?k3lsari73UQ2I/mmxYYWN7An+2P12Hktk3tge2LLJbdbJk5w9cg1EAbmk3jG?=
 =?us-ascii?Q?1AAq/t+tuycVEx+g8LEDKd9jLiYcPOFiMtTDAD0LiafbHizVrq7OJuWzXcQ0?=
 =?us-ascii?Q?pCR/PnpCXIJLEMwCz0FOpdh4VOSE2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8a966e-f661-4ffc-61b7-08db62bb6c2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 16:15:31.5861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5UO0MyifsoPqmD9d1IK/zyW2Y36CMaXs7WKMbOo5vwvtMr57JBSHiqyWqotNmIOG0ADiCAQpt8QboF8qulcyyxw/e/+LQkGiPdz+upNm/00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010141
X-Proofpoint-ORIG-GUID: t99WNdSed58ZTYvg08uPL1ZaI5pYUsYt
X-Proofpoint-GUID: t99WNdSed58ZTYvg08uPL1ZaI5pYUsYt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 11, 2023, at 9:04 AM, Anjali Kulkarni <Anjali.K.Kulkarni@oracle.co=
m> wrote:
>=20
>=20
>=20
>> On Apr 27, 2023, at 10:03 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>>=20
>> On Wed, 26 Apr 2023 23:58:55 +0000 Anjali Kulkarni wrote:
>>> Jakub, could you please look into reviewing patches 3,4 & 5 as well?
>>> Patch 4 is just test code. Patch 3 is fixing bug fixes in current
>>> code so should be good to have - also it is not too connector
>>> specific. I can explain patch 5 in more detail if needed.
>>=20
>> I don't have sufficient knowledge to review that code, sorry :(
>=20
> Is there anyone who can please help review this code?=20
> Christian, could you please help take a look?
> Thanks
> Anjali
>=20

Gentle ping again - Christian could you please help review?
Anjali


