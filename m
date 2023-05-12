Return-Path: <netdev+bounces-2250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E46700E06
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72FC21C2133A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58883200D9;
	Fri, 12 May 2023 17:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6F8200B7
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:39:54 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAFE1718
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:39:47 -0700 (PDT)
Received: from 104.47.7.171_.trendmicro.com (unknown [172.21.174.129])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 85DF4100004DE;
	Fri, 12 May 2023 17:39:46 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1683913184.231000
X-TM-MAIL-UUID: 407906a3-865b-4d18-a173-771e0b4d1c58
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.171])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 38935100018B9;
	Fri, 12 May 2023 17:39:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY4ZqrXD6jgG8mbnMe+MK6Fwim60W6qRiqmyLzWSuSJgCcvSe9hMVcY65bk80quyzdx+ZVtU/IBY9/efnRG2d4jvgOPnd3t9wCIGZiLV13UDr6B/aVhYhWy4JK/UcTROkHHS2deY82jxpMx/OpIElyaUvG4/gCEq7kWgMRp1YHtRxh9KtUWgu42j52bBcvR8tr/R0FdYm3fcD6AYbdyyKntPE0h1vINy2wjlW586F6P1Ul176RVh97NrKhsq41Vqyq3BE6asf1H0Xsw7C5HVTGLs2pnAS3gHouaLxIyNFdNL6T/FOUiQsYdddvOimDxtpXBiugwxOgR8CSt5jA0+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwWmuYUed6P4es7oUHiLUqmxFza6lxjPPfcn2Lz/RUY=;
 b=mrQhEVLeiV8YthFTsMB6JfPxHg+48u4uGvKIKyi8r3xAX+28lrQuZLsURh3JU9xygOZPtT+pFCKlZVtjxM2d/Vq3RZmhI4cW4zXYRaBmNi13QgBhaKeDJLixSl+3CuEMSZfE4qISCsrI9ByeIAXyAKRdjU1+xR39A/qrEb9r1I3+1HblFfgQWlFINFef7rwoNnj+i5PuWElDpkouzY9YYJn/46UPFcWLET4Qv9SfgZqc8vdd0mzoKv1EOHus3PHu2Gi1MGFjd9YWLu4xG5FPNNboeClM/6R7Tb4AT1kTZxnrcmWUMU0f5hFzJRCLYlMIjAKR58tuq7vBDUgWWqBo+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <a83e29fd-09d0-64b4-ce56-c7f7a5e44f66@opensynergy.com>
Date: Fri, 12 May 2023 19:39:40 +0200
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
Content-Language: en-US
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
 Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
 <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com>
From: Harald Mommer <harald.mommer@opensynergy.com>
In-Reply-To: <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0295.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8a::18) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|FR2P281MB0172:EE_
X-MS-Office365-Filtering-Correlation-Id: d01e8fe3-0dd6-470b-b1a9-08db530fde0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xrbeL4TslyjPb5Yx1DHYfcwjh32tR9jgOh6nQTI4wjDa4LSG2OuB+T9WEtXRBhL5CWAHvIALvNKQHETwFqEYBi6aVjAkB37nM585JYtJOdVLyVl7NuumbXQJ3WR+xJ06Oysdmg7JiyRm5jmy438mnV7YOdTehxjKyvp+I2pR1U9T9IMz8I1vn4kUqx6dBP1Iilh/4mPl+hyYvEIjICOQW3kZexLpZ2sFHKIm2I5slgTMuXYyBBZVbN23PnQFlqhl7s0knbZT82iEF1zcCfBwP1wEWT2jEHjQtjoZyhRHASuzShw2lNsytt+WZTf09Cd+JO3Wzln2UEuqNtSxWQNCyBRAKp/ZnnA9VS/egu4iWiZ6d1uVmtQwsKqrIBYqsPvh1cwMs5wqs9EwPcZ5r2sgHJ8krXF8pSZXi1honpYBiiqZtk+PXpJqWQbm1nWZEZkUl4zdWEO1Gp/c0zNlTMN1Fd5ISuwD7+WmDMJCYLoBwAf6Phx7bIq5n4TN2wwrs/FSnFvtgWcYMsPTtFOOg/fqmbNe8T7laWdFQlvE2OeEgQJhjnFJ+eqHKq4/KeGEFIZCNUgJBHhD551ug0QWaPcOKA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39830400003)(396003)(366004)(376002)(451199021)(66899021)(31686004)(966005)(66476007)(66946007)(4326008)(66556008)(42186006)(18074004)(316002)(54906003)(110136005)(478600001)(86362001)(36756003)(31696002)(41300700001)(186003)(83380400001)(26005)(107886003)(2616005)(53546011)(8936002)(44832011)(7416002)(2906002)(38100700002)(30864003)(8676002)(5660300002)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3lYcUxLRk9sUnIrbjUwdW9YQmRjVGZqR25ZbWYyYWV4cklkT3g3MHVpVWRj?=
 =?utf-8?B?WjkyenE5MGdGcEo1Zk5mdTAycU01dmxLOHgwL2RDRHRqSWk5cDNPK0F1M2w0?=
 =?utf-8?B?cll5STFiZHZGVndnNE53aWtKMlNHbnl2cjFwNHdtTmR0MzNXaERrODErN0pJ?=
 =?utf-8?B?Y2YxSTFRRTF0ajVDd2Q5T1VadzYyMEhJUjcxM0lETVd4ME80N3RwSXJmY1RV?=
 =?utf-8?B?cUt2S3FOUVdicE5JYVIrYmlYR0Q3dVFxTXlwOG5vV1o2QWUyRkFLVUZaQ2Zu?=
 =?utf-8?B?Z2hQZm9xd21sNGhieEtub3I4ekQwRkpnQmUwcVFrR1RDMHNQMXZhM0tCYm5v?=
 =?utf-8?B?UHF6ZVZvbldOQytKamRScnJRK2RIc2lSSzEydUkxcTk5bWo0b3NpU1M4enJk?=
 =?utf-8?B?MDBpQUdVTjRlWG5JTE1qMTFTTEsxa1FHSEhPVkNLek56S25FZzFvNm1DVk9W?=
 =?utf-8?B?OVF0Y3RqcG0xVVRudm43NmMwemw5b1lyUU94ZjVKa1ZsdnQ2UzlMbXQrK1B6?=
 =?utf-8?B?K2xlZ3p0cUY3Z2tmTmNOaEtzanM3NmhJOUVuTzZSQUxMU3g2OTg2NU9UeXow?=
 =?utf-8?B?NUgySWk3NU03VklHZEJHTGwwVkFIUk5BUEF3VGg1OXpHUkZxNXNEbFZWejZU?=
 =?utf-8?B?blBmMkdtKy96KyswYlp0NjFWOHJIOFhmcW9KYnVOaTFaWm1KMHEvWnMrUWIx?=
 =?utf-8?B?cTArdzNlUmREU2VONVc1UFFYL0N1Wlh3cjBZWjQzYzVGT2xpWjBLTDRheTBP?=
 =?utf-8?B?YTJ0ZFNDWW13NHBWVWxZb05DK3VjaXo4ZFJYL3BDQnVrRnYwaGxRTFI4eUpt?=
 =?utf-8?B?dVJOYlczc3Y2MGV0MjNCRkZDWUdHbUtHNFFLcmFjeUpxQTB0YWM1WUhnSUtl?=
 =?utf-8?B?MWh0KzRIWFE3OWNXWGpVemtFZG11NmpqMlg4R3haVUsyMEYxZXI2MHZrVWQz?=
 =?utf-8?B?VHBqb1F4ejRxZnpNYWxyK2duYmtnVWN0OUZ1SElsVTYxN1crb0haRzR0ZmdP?=
 =?utf-8?B?OFhGdHJBR0JySzFETml3Q0dCMko2OW13d1hHTVBUYzgwc2pra291OGVHNllt?=
 =?utf-8?B?VEMzaVdFUllpSW13Tk1pTEl0KzRSOXNVUHI4eUJycEdRMUJwaTZPTFlJc0xu?=
 =?utf-8?B?OTdUUk4xRUU4REd0eksyUytnZmtrVlF6UEpFSjVjRmpRQUYxTk9RU0xVWjZP?=
 =?utf-8?B?YWZBUC9vMUxDTEwxOSs3ZTBzaWdsREdreHJkdmFpWXN1VXlqNXpGc1N6QzF3?=
 =?utf-8?B?T2VEeE9OSUdrS2cxVkx5alZHQmVVRGlGVmdyQjh5SjdTZWJXUVNrOG11dFVY?=
 =?utf-8?B?MVVTanNabU1mRkFhK210MHVxNlh5blRRVHFPbUhZVktTWWhKeEpwdElsQ0s3?=
 =?utf-8?B?Rm15K1hkUHNnaWR4REpCN0ViNk8zZjdoc1J2NHJpeFo0QnBsV2xCekdsQXQr?=
 =?utf-8?B?YlV3Q1cvWjhlRmgxMFA4ZC9WY0JMeW42MDlYVzZjdTA0bVZXTGRBWFIwendq?=
 =?utf-8?B?Nmd3YXZocXVIaW84cUlrSzFlcFVRNktsRXJwUGJlSHE2K1JQcDFBVk1YdHA5?=
 =?utf-8?B?RCtPTEN5ckdKS2VBOVFuK2ZnaSt4MGk3WDB0NU5YQ3BjZnNnTENPcVBPU3Qx?=
 =?utf-8?B?WDNEdDNFczJQb3BYMXFjYytPS3RxdlR2QlFydGZjRTZBc2gyNWZBanRhcjFw?=
 =?utf-8?B?Unp1WTVNZnhOcjduemtxMm5MOGtHcUVmaVZSVUZEMEhrNmNKYlpjZFE1SDNn?=
 =?utf-8?B?VFdCTWIyNGJnY1VCQnFkRkUzTXZEVDc5ekd0OFlNRjNIT01SdEFoNkxINlFB?=
 =?utf-8?B?MW9reTVXT1VnQXFZZFBsOU9HZTdCWFUvcXNjbDlpSVkwYVJRcHA4TDdzRUZm?=
 =?utf-8?B?Ymd3V2pWeEh5TS91VUFMOTNnZGRvWDJGOEdqKzFXWHEzMXozTXlFeGs3YkI3?=
 =?utf-8?B?bnVNd0tpNzRiSXZ2dW5uTEVTa01wczNSamFWOHhpRzlzUEE1bWRhVVdFZU1H?=
 =?utf-8?B?U01nQWpDcXBZYldrbUo0WGY5SEFKMElDamNtSEt5V0tPUjFuMXR5ZDZWVlVy?=
 =?utf-8?B?NW83L1NBeWRQeTBCN0N4OWVCbjA3VnEvNTRPT0VQL3ZjVGJTMTBheElhcWIw?=
 =?utf-8?Q?0qn8FsZ0pa+7BXN746NaNaDfQ?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01e8fe3-0dd6-470b-b1a9-08db530fde0e
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 17:39:41.9807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DArj3bZ9elxnvYQSZvWRV2jBMDsIpAahifnYA2hQka5i1iZQTrW2z0DbHjWB76hkTGaBdmWX1yzoqa2zyK4AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB0172
X-TM-AS-ERS: 104.47.7.171-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27622.001
X-TMASE-Result: 10--29.676300-4.000000
X-TMASE-MatchedRID: IeZYkn8zfFqwzFuyya2WsOsLOhZcNxRi9mojSc/N3Qfio3l0QpWvqVLt
	xulXGyZGLoD4tn9vWJIsBVjXz6daRRLmJd2F/yFuR/j040fRFpJGmC2qcPUEPoSYKZ0hL1JchEz
	I3+mkzidvR+YJYdGScTblGqhdTCq7vUxpsK1XD0vN+qWlu2ZxaIXM008Nzq6YoS4fXu6r0iI9UY
	NUDN4YfN0atarVue7j5LNY6bwvaUi075YIOXPrccTlzYkfXAhXCZa9cSpBObm+f7ap9DJaDb8FH
	rw7frlutWo4T7nm7hjfQQLUEQSyKV1xEBEuVNyP9Ib/6w+1lWT/1JLsM3tGxss3mdBBdiYSBOCy
	MglQlkgwH5gPcpNPxmtF9sTtzaRRAjYpwtGfdBHGL//8mlodA4GzTdEevOMz7oADBC2c5PkJfh8
	gHD4nuzmtoki1u/CnL/8yUNGojyZRPwES1RXV2gQKUmCPOmOoTQyUKUDoVJ0ZbsAUeZcRz48DhF
	kqBuzaHE4/Xd9+Q94yegCNS0OoHEj50wU+Eco0wCGU3q1ZqNOW0X7Fb7OFSIc5XWJfryopepMqt
	PiQJGmC9g3+dE2CCxhye5tLsv5PVoG8mkAKgzwIoUOTWQl7EjRgv1Ik+59fNWO9z3c712TSw1VG
	nZ8HDIBs6iHlIlslwSQ07XmRy7bRRKRvpdGsefhmLfH/1YU7N6i7v/DQHPzcRlVxRCnt1kswgej
	8gTmB0Gg1DtiaAKUX+rqnHY0z+TuJHAPJI7M/zr16YOzjZ11OGffsUU/kDV/8lGqVstJXhENgDE
	my0hILIwnqU0mbQxBLu4HBju7GWViv3bGKIdV+yskgwrfsC30tCKdnhB581B0Hk1Q1KyIjhwkML
	kSVS42j49Ftap9EkGUtrowrXLg=
X-TMASE-XGENCLOUD: bc55fc5f-6e76-4937-ace2-9598f806b4ac-0-0-200-0
X-TM-Deliver-Signature: 109F497905F5059A415E15629C462223
X-TM-Addin-Auth: fFVN3VMyfZ+2QO9S7GM3IZyGCUlt5t/phoiuRF/IDDYiZXGlirhIAbFQNdL
	u8TzhrHUVIYd6HnG4c6DOXYSt0ZpY0vaKz9z2MHtbeFf5nI/k2qxm9wymo4PkaFbR6AZNpr1eVc
	mAReE74Y8zIW+iZ9SQ9x7yk8JBvBg869TBzrmpgUh8uXshuY4P+Qgye/QFL9YzH0iytGt6gWACc
	Z73SsS144ucY3RQfJVyfs+RqC2XGAezbcZdxaHip67ZnsFp3lvB8f9oCvRqgDkruN6SDAoqhpJM
	2eP8vbawIZaWzQM=.ac+oLDxGhRuEtMCS/JcDZyXhVMy1cHKn0PgwI7vVuUIchYTcpCTczZyJrO
	YsU1CxzbhczhveZ3Uy4XqkLPo3e9o2enpJwFP9aYcKyRa5X5KMF0ZGCcXEmiVwNRwI+dS3lSOTu
	qipDyAHesFY2/pzajJnC8XmIPHU17+GtuBdcOU+gvapcCPCNaUuArMBNjA4qWIQy5i57IoEAg6p
	shz+NLI0FxmjmCxL6/lI+qQBxkcHRXmGP/1zrJgqy5Y7bU3x/BThqPst9MkbXcbJQ+rPaZRE6/F
	RfQIA4wk7vXfrtHYkRKq2AIUTSgl6IXRxLQRijBmUWzHmwAH5IdIVeWi1ew==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1683913186;
	bh=Y927uqzxiqZ8QUQ4ycbGF790eRS+ttXKMrL8u7axfNQ=; l=53327;
	h=Date:To:From;
	b=B8NcIbuFmYgfj+JaGCSAVT4c0M/Qjl9sDTarNR0x4uWjOjkekzgneDervYIWNQUeu
	 ERbWgK6mQJbedq409Wv2Ssa63LZA8spqxATJy7z3+a4HcfcncdRnoG4iw72BaR9nFp
	 Y5g6AlMsJmq41FOpE5FdAIcfzcezgbLdGRbwDjd02OdVfccjnS1bBtkewjZhvzJmAc
	 Nnx1i27iDF/TuURoVqfV6fQdS76LazPQSrN6F9IlfHGrIFX52Zqi7V2a9n5kkOMN07
	 ngzvAmrGiqC3m8m12Osu5KFMxnFCjFSbG645slA78oXxCoE6+2aBB+N7EAcymaLnpI
	 2IK2pb6DMHzJQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vincent,

(Marc, you are now in the "To" as I have a direct question to you.)

On 12.05.23 11:53, Vincent MAILHOL wrote:
> Hi Mikhail,
>
> Thanks for your patch. Do you have any plans for CAN error reporting
> aside from the bus off? (e.g. can error-active, can error-passive, bit
> errors...)
>
> On Fri. 12 May 2023 at 00:18, Mikhail Golubev-Ciuchea
> <Mikhail.Golubev-Ciuchea@opensynergy.com> wrote:
>> From: Harald Mommer <harald.mommer@opensynergy.com>
>>
>> - CAN Control
>>
>>    - "ip link set up can0" starts the virtual CAN controller,
>>    - "ip link set up can0" stops the virtual CAN controller
>>
>> - CAN RX
>>
>>    Receive CAN frames. CAN frames can be standard or extended, classic or
>>    CAN FD. Classic CAN RTR frames are supported.
>>
>> - CAN TX
>>
>>    Send CAN frames. CAN frames can be standard or extended, classic or
>>    CAN FD. Classic CAN RTR frames are supported.
>>
>> - CAN BusOff indication
>>
>>    CAN BusOff is handled by a bit in the configuration space.
>>
>> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
>> Signed-off-by: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
>> Co-developed-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
>> ---
>>
>> V3:
>> * Incorporate patch "[PATCH] can: virtio-can: cleanups" from
>>    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2flore.kernel.org%2fall%2f20230424%2dfootwear%2ddaily%2d9339bd0ec428%2dmkl%40pengutronix.de%2f&umid=9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-17d3c64a4691a4e8987f693a9c0d91fa09fb4a4f
>> * Add missing can_free_echo_skb()
>> * Replace home-brewed ID allocator with the standard one from kernel
>> * Simplify flow control
>> * Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec-rfc-v3
>>
>> V2:
>> * Remove the event indication queue and use the config space instead, to
>>    indicate a bus off condition
>> * Rework RX and TX messages having a length field and some more fields for CAN
>>    EXT
>> * Fix CAN_EFF_MASK comparison
>> * Remove MISRA style code (e.g. '! = 0u')
>> * Remove priorities leftovers
>> * Remove BUGONs
>> * Based on virtio can spec RFCv3
>> * Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec-rfc-v3
>>
>>   MAINTAINERS                     |    7 +
>>   drivers/net/can/Kconfig         |   12 +
>>   drivers/net/can/Makefile        |    3 +-
>>   drivers/net/can/virtio_can.c    | 1000 +++++++++++++++++++++++++++++++
>>   include/uapi/linux/virtio_can.h |   71 +++
>>   5 files changed, 1092 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/net/can/virtio_can.c
>>   create mode 100644 include/uapi/linux/virtio_can.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7e0b87d5aa2e..ca45950c8364 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -22246,6 +22246,13 @@ F:     drivers/vhost/scsi.c
>>   F:     include/uapi/linux/virtio_blk.h
>>   F:     include/uapi/linux/virtio_scsi.h
>>
>> +VIRTIO CAN DRIVER
>> +M:     "Harald Mommer" <harald.mommer@opensynergy.com>
>> +L:     linux-can@vger.kernel.org
>> +S:     Maintained
>> +F:     drivers/net/can/virtio_can.c
>> +F:     include/uapi/linux/virtio_can.h
>> +
>>   VIRTIO CONSOLE DRIVER
>>   M:     Amit Shah <amit@kernel.org>
>>   L:     virtualization@lists.linux-foundation.org
>> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
>> index 3ceccafd701b..ee47fdff2252 100644
>> --- a/drivers/net/can/Kconfig
>> +++ b/drivers/net/can/Kconfig
>> @@ -210,6 +210,18 @@ config CAN_XILINXCAN
>>            Xilinx CAN driver. This driver supports both soft AXI CAN IP and
>>            Zynq CANPS IP.
>>
>> +config CAN_VIRTIO_CAN
>> +       depends on VIRTIO
>> +       tristate "Virtio CAN device support"
>> +       default n
>> +       help
>> +         Say Y here if you want to support for Virtio CAN.
> Broken grammar.
>
> Do either
>
>           Say Y here if you want to add support for Virtio CAN.
Add "add".
>
> or:
>
>           Say Y here if you want to support Virtio CAN devices.
>
>> +
>> +         To compile this driver as a module, choose M here: the
>> +         module will be called virtio-can.
>> +
>> +         If unsure, say N.
>> +
>>   source "drivers/net/can/c_can/Kconfig"
>>   source "drivers/net/can/cc770/Kconfig"
>>   source "drivers/net/can/ctucanfd/Kconfig"
>> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
>> index ff8f76295d13..19314adaff59 100644
>> --- a/drivers/net/can/Makefile
>> +++ b/drivers/net/can/Makefile
>> @@ -17,8 +17,8 @@ obj-$(CONFIG_CAN_AT91)                += at91_can.o
>>   obj-$(CONFIG_CAN_BXCAN)                += bxcan.o
>>   obj-$(CONFIG_CAN_CAN327)       += can327.o
>>   obj-$(CONFIG_CAN_CC770)                += cc770/
>> -obj-$(CONFIG_CAN_C_CAN)                += c_can/
>>   obj-$(CONFIG_CAN_CTUCANFD)     += ctucanfd/
>> +obj-$(CONFIG_CAN_C_CAN)                += c_can/
> This reordering is unrelated to this patch goal. Please send it as a
> separate patch.

@Marc Kleine-Budde: We got this reordering change from you. How to 
proceed? We can split this in 2 commits, reordering and on top adding 
virtio CAN. No issue, a question of minutes and done. Fine. But here the 
word "patch" was used, not the word "commit". Sending a separate patch 
to somewhere? Maybe Mikhail does this fight to get this in (unlikely), I 
personally would prefer to run away. Or we don't reorder at all, wrong 
ordering remains and we will not make only you unhappy.

>>   obj-$(CONFIG_CAN_FLEXCAN)      += flexcan/
>>   obj-$(CONFIG_CAN_GRCAN)                += grcan.o
>>   obj-$(CONFIG_CAN_IFI_CANFD)    += ifi_canfd/
>> @@ -30,6 +30,7 @@ obj-$(CONFIG_CAN_PEAK_PCIEFD) += peak_canfd/
>>   obj-$(CONFIG_CAN_SJA1000)      += sja1000/
>>   obj-$(CONFIG_CAN_SUN4I)                += sun4i_can.o
>>   obj-$(CONFIG_CAN_TI_HECC)      += ti_hecc.o
>> +obj-$(CONFIG_CAN_VIRTIO_CAN)   += virtio_can.o
>>   obj-$(CONFIG_CAN_XILINXCAN)    += xilinx_can.o
>>
>>   subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
>> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
>> new file mode 100644
>> index 000000000000..ebc3394276d6
>> --- /dev/null
>> +++ b/drivers/net/can/virtio_can.c
>> @@ -0,0 +1,1000 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * CAN bus driver for the Virtio CAN controller
>> + * Copyright (C) 2021-2023 OpenSynergy GmbH
>> + */
>> +
>> +#include <linux/atomic.h>
>> +#include <linux/idr.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/stddef.h>
>> +#include <linux/can/dev.h>
>> +#include <linux/virtio.h>
>> +#include <linux/virtio_ring.h>
>> +#include <linux/virtio_can.h>
>> +
>> +/* CAN device queues */
>> +#define VIRTIO_CAN_QUEUE_TX 0 /* Driver side view! The device receives here */
>> +#define VIRTIO_CAN_QUEUE_RX 1 /* Driver side view! The device transmits here */
>> +#define VIRTIO_CAN_QUEUE_CONTROL 2
>> +#define VIRTIO_CAN_QUEUE_COUNT 3
>> +
>> +#define CAN_KNOWN_FLAGS \
>> +       (VIRTIO_CAN_FLAGS_EXTENDED |\
>> +        VIRTIO_CAN_FLAGS_FD |\
>> +        VIRTIO_CAN_FLAGS_RTR)
>> +
>> +/* Max. number of in flight TX messages */
>> +#define VIRTIO_CAN_ECHO_SKB_MAX 128
>> +
>> +struct virtio_can_tx {
>> +       struct list_head list;
>> +       unsigned int putidx;
>> +       struct virtio_can_tx_out tx_out;
>> +       struct virtio_can_tx_in tx_in;
> I am still waiting for your answer on my previous comment here:
>
>    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2flore.kernel.org%2flinux%2dcan%2fCAMZ6Rq%2bRjOHaGx%2d7GLsj%2dPNAcHd%3dnGd%3dJERddqw4FWbNN3sAXA%40mail.gmail.com%2f&umid=9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-54198265295ed52b35ce48cd250b88611e8f8ccc
Done now on the original mail which was found somewhere after some 
searching.
>> +};
>> +
>> +/* virtio_can private data structure */
>> +struct virtio_can_priv {
>> +       struct can_priv can;    /* must be the first member */
>> +       /* NAPI for RX messages */
>> +       struct napi_struct napi;
>> +       /* NAPI for TX messages */
>> +       struct napi_struct napi_tx;
>> +       /* The network device we're associated with */
>> +       struct net_device *dev;
>> +       /* The virtio device we're associated with */
>> +       struct virtio_device *vdev;
>> +       /* The virtqueues */
>> +       struct virtqueue *vqs[VIRTIO_CAN_QUEUE_COUNT];
>> +       /* I/O callback function pointers for the virtqueues */
>> +       vq_callback_t *io_callbacks[VIRTIO_CAN_QUEUE_COUNT];
>> +       /* Lock for TX operations */
>> +       spinlock_t tx_lock;
>> +       /* Control queue lock. Defensive programming, may be not needed */
>> +       struct mutex ctrl_lock;
>> +       /* Wait for control queue processing without polling */
>> +       struct completion ctrl_done;
>> +       /* List of virtio CAN TX message */
>> +       struct list_head tx_list;
>> +       /* Array of receive queue messages */
>> +       struct virtio_can_rx rpkt[128];
>> +       /* Those control queue messages cannot live on the stack! */
>> +       struct virtio_can_control_out cpkt_out;
>> +       struct virtio_can_control_in cpkt_in;
>> +       /* Data to get and maintain the putidx for local TX echo */
>> +       struct ida tx_putidx_ida;
>> +       /* In flight TX messages */
>> +       atomic_t tx_inflight;
>> +       /* BusOff pending. Reset after successful indication to upper layer */
>> +       bool busoff_pending;
>> +};
>> +
>> +/* Function copied from virtio_net.c */
>> +static void virtqueue_napi_schedule(struct napi_struct *napi,
>> +                                   struct virtqueue *vq)
>> +{
>> +       if (napi_schedule_prep(napi)) {
>> +               virtqueue_disable_cb(vq);
>> +               __napi_schedule(napi);
>> +       }
>> +}
>> +
>> +/* Function copied from virtio_net.c */
>> +static void virtqueue_napi_complete(struct napi_struct *napi,
>> +                                   struct virtqueue *vq, int processed)
>> +{
>> +       int opaque;
>> +
>> +       opaque = virtqueue_enable_cb_prepare(vq);
>> +       if (napi_complete_done(napi, processed)) {
>> +               if (unlikely(virtqueue_poll(vq, opaque)))
>> +                       virtqueue_napi_schedule(napi, vq);
>> +       } else {
>> +               virtqueue_disable_cb(vq);
>> +       }
>> +}
>> +
>> +static void virtio_can_free_candev(struct net_device *ndev)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(ndev);
>> +
>> +       ida_destroy(&priv->tx_putidx_ida);
>> +       free_candev(ndev);
>> +}
>> +
>> +static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv)
>> +{
>> +       int tx_idx;
>> +
>> +       tx_idx = ida_alloc_range(&priv->tx_putidx_ida, 0,
>> +                                priv->can.echo_skb_max - 1, GFP_KERNEL);
>> +       if (tx_idx >= 0)
>> +               atomic_add(1, &priv->tx_inflight);
>> +
>> +       return tx_idx;
>> +}
>> +
>> +static void virtio_can_free_tx_idx(struct virtio_can_priv *priv,
>> +                                  unsigned int idx)
>> +{
>> +       ida_free(&priv->tx_putidx_ida, idx);
>> +       atomic_sub(1, &priv->tx_inflight);
>> +}
>> +
>> +/* Create a scatter-gather list representing our input buffer and put
>> + * it in the queue.
>> + *
>> + * Callers should take appropriate locks.
>> + */
>> +static int virtio_can_add_inbuf(struct virtqueue *vq, void *buf,
>> +                               unsigned int size)
>> +{
>> +       struct scatterlist sg[1];
>> +       int ret;
>> +
>> +       sg_init_one(sg, buf, size);
>> +
>> +       ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
>> +       virtqueue_kick(vq);
>> +       if (ret == 0)
>> +               ret = vq->num_free;
>> +       return ret;
>> +}
>> +
>> +/* Send a control message with message type either
>> + *
>> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
>> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
>> + *
>> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requirement
>> + * for this Linux driver to have an asynchronous implementation of the mode
>> + * setting function so in order to keep things simple the function is
>> + * implemented as synchronous function. Design pattern is
>> + * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_command().
>> + */
>> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(ndev);
>> +       struct device *dev = &priv->vdev->dev;
>> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
>> +       struct scatterlist sg_out[1];
>> +       struct scatterlist sg_in[1];
>> +       struct scatterlist *sgs[2];
>> +       int err;
>> +       unsigned int len;
>> +
>> +       /* The function may be serialized by rtnl lock. Not sure.
>> +        * Better safe than sorry.
>> +        */
>> +       mutex_lock(&priv->ctrl_lock);
>> +
>> +       priv->cpkt_out.msg_type = cpu_to_le16(msg_type);
>> +       sg_init_one(&sg_out[0], &priv->cpkt_out, sizeof(priv->cpkt_out));
>> +       sg_init_one(&sg_in[0], &priv->cpkt_in, sizeof(priv->cpkt_in));
>> +       sgs[0] = sg_out;
>> +       sgs[1] = sg_in;
>> +
>> +       err = virtqueue_add_sgs(vq, sgs, 1u, 1u, priv, GFP_ATOMIC);
>> +       if (err != 0) {
>            if (err) {

Opened Eclipse, searched for "if (err != 0)" in the kernel code. 290 
matches. For "if (ret != 0)" I found now 1970 matches.

>> +               /* Not expected to happen */
>> +               dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", __func__);
>> +       }
>> +
>> +       if (!virtqueue_kick(vq)) {
>> +               /* Not expected to happen */
>> +               dev_err(dev, "%s(): Kick failed\n", __func__);
>> +       }
>> +
>> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
>> +               wait_for_completion(&priv->ctrl_done);
>> +
>> +       mutex_unlock(&priv->ctrl_lock);
>> +
>> +       return priv->cpkt_in.result;
>> +}
>> +
>> +static void virtio_can_start(struct net_device *ndev)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(ndev);
>> +       u8 result;
>> +
>> +       result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_START);
>> +       if (result != VIRTIO_CAN_RESULT_OK) {
>> +               /* Not expected to happen */
>> +               netdev_err(ndev, "CAN controller start failed\n");
>> +       }
>> +
>> +       priv->busoff_pending = false;
>> +       priv->can.state = CAN_STATE_ERROR_ACTIVE;
>> +
>> +       /* Switch carrier on if device was not connected to the bus */
>> +       if (!netif_carrier_ok(ndev))
>> +               netif_carrier_on(ndev);
>> +}
>> +
>> +/* See also m_can.c/m_can_set_mode()
>> + *
>> + * It is interesting that not only the M-CAN implementation but also all other
>> + * implementations I looked into only support CAN_MODE_START.
>> + * That CAN_MODE_SLEEP is frequently not found to be supported anywhere did not
>> + * come not as surprise but that CAN_MODE_STOP is also never supported was one.
>> + * The function is accessible via the method pointer do_set_mode in
>> + * struct can_priv. As usual no documentation there.
>> + * May not play any role as grepping through the code did not reveal any place
>> + * from where the method is actually called.
>> + */
>> +static int virtio_can_set_mode(struct net_device *dev, enum can_mode mode)
>> +{
>> +       switch (mode) {
>> +       case CAN_MODE_START:
>> +               virtio_can_start(dev);
>> +               netif_wake_queue(dev);
>> +               break;
>> +       default:
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/* Called by issuing "ip link set up can0" */
>> +static int virtio_can_open(struct net_device *dev)
>> +{
>> +       /* start the virtio_can controller */
>> +       virtio_can_start(dev);
>> +
>> +       /* RX and TX napi were already enabled in virtio_can_probe() */
>> +       netif_start_queue(dev);
>> +
>> +       return 0;
>> +}
>> +
>> +static void virtio_can_stop(struct net_device *ndev)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(ndev);
>> +       struct device *dev = &priv->vdev->dev;
>> +       u8 result;
>> +
>> +       result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_STOP);
>> +       if (result != VIRTIO_CAN_RESULT_OK)
>> +               dev_err(dev, "CAN controller stop failed\n");
>> +
>> +       priv->busoff_pending = false;
>> +       priv->can.state = CAN_STATE_STOPPED;
>> +
>> +       /* Switch carrier off if device was connected to the bus */
>> +       if (netif_carrier_ok(ndev))
>> +               netif_carrier_off(ndev);
>> +}
>> +
>> +static int virtio_can_close(struct net_device *dev)
>> +{
>> +       netif_stop_queue(dev);
>> +       /* Keep RX napi active to allow dropping of pending RX CAN messages,
>> +        * keep TX napi active to allow processing of cancelled CAN messages
>> +        */
>> +       virtio_can_stop(dev);
>> +       close_candev(dev);
>> +
>> +       return 0;
>> +}
>> +
>> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>> +                                        struct net_device *dev)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(dev);
>> +       struct canfd_frame *cf = (struct canfd_frame *)skb->data;
>> +       struct virtio_can_tx *can_tx_msg;
>> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +       struct scatterlist sg_out[1];
>> +       struct scatterlist sg_in[1];
>> +       struct scatterlist *sgs[2];
> Instead declaring two times an array of 1, can we do:
>
>          struct scatterlist sgs[2];
>
> and then use sgs[0] for out and sgs[1] for in?
>
> Or, if you really want to keep sg_out and sg_in, at least do:
>
>            struct scatterlist sg_out, sg_in;
>            struct scatterlist *sgs[] = {&sg_out, &sg_in};
>
> N.B. The same comment also applies to the other places where you are
> doing some sg[1] declarations.

Makes thing worse. I'm not even sure whether this is a null change only 
or introduces a problem.

virtio strictly separates devices readable and device writeable data. 
Therefore I want really to have here 2 separate definitions. The one is 
data to the device, the other is data from the device.

If this had any advantage, I could separate the data further. For 
example I could separate the payload from the preceding data. In this 
case I had  struct scatterlist sg_out[2]. As long as the payload is 
small the memcpy for the payload can be justified and [1] is good. In 
fact, those are still arrays even if by coincident now the number of 
elements is 1.

>> +       unsigned long flags;
>> +       u32 can_flags;
>> +       int err;
>> +       int putidx;
>> +       netdev_tx_t xmit_ret = NETDEV_TX_OK;
>> +       const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
>> +
>> +       if (can_dev_dropped_skb(dev, skb))
>> +               goto kick; /* No way to return NET_XMIT_DROP here */
>> +
>> +       /* No local check for CAN_RTR_FLAG or FD frame against negotiated
>> +        * features. The device will reject those anyway if not supported.
>> +        */
>> +
>> +       can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
>> +       if (!can_tx_msg)
>> +               goto kick; /* No way to return NET_XMIT_DROP here */
>> +
>> +       can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
>> +       can_flags = 0;
>> +
>> +       if (cf->can_id & CAN_EFF_FLAG) {
>> +               can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
>> +               can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
>> +       } else {
>> +               can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
>> +       }
>> +       if (cf->can_id & CAN_RTR_FLAG)
>> +               can_flags |= VIRTIO_CAN_FLAGS_RTR;
>> +       else
>> +               memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
>> +       if (can_is_canfd_skb(skb))
>> +               can_flags |= VIRTIO_CAN_FLAGS_FD;
>> +
>> +       can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
>> +       can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
>> +
>> +       /* Prepare sending of virtio message */
>> +       sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
>> +       sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
>> +       sgs[0] = sg_out;
>> +       sgs[1] = sg_in;
>> +
>> +       putidx = virtio_can_alloc_tx_idx(priv);
>> +
>> +       if (unlikely(putidx < 0)) {
>> +               netif_stop_queue(dev);
>> +               kfree(can_tx_msg);
>> +               netdev_warn(dev, "TX: Stop queue, no putidx available\n");
> ida_alloc_range() can also return -ENOMEM. So the error is not
> necessarily because of no putidx available. Maybe better to print the
> error message (with %pe to show the mnemotechnic).
%pe does not do that. It works for an error coded in a pointer. I have 
here an int.
>
>> +               xmit_ret = NETDEV_TX_BUSY;
>> +               goto kick;
>> +       }
>> +
>> +       can_tx_msg->putidx = (unsigned int)putidx;
>> +
>> +       /* Protect list operation */
>> +       spin_lock_irqsave(&priv->tx_lock, flags);
>> +       list_add_tail(&can_tx_msg->list, &priv->tx_list);
>> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +       /* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
>> +       can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
>> +
>> +       /* Protect queue and list operations */
>> +       spin_lock_irqsave(&priv->tx_lock, flags);
>> +       err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
>> +       if (err != 0) { /* unlikely when vq->num_free was considered */
>> +               list_del(&can_tx_msg->list);
>> +               can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
>> +               virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
>> +               spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +               netif_stop_queue(dev);
>> +               kfree(can_tx_msg);
>> +               if (err == -ENOSPC)
>> +                       netdev_dbg(dev, "TX: Stop queue, no space left\n");
>> +               else
>> +                       netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
>> +               xmit_ret = NETDEV_TX_BUSY;
>> +               goto kick;
>> +       }
>> +
>> +       /* Normal queue stop when no transmission slots are left */
>> +       if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max ||
>> +           vq->num_free == 0 || (vq->num_free < 2 &&
> Replace the Magic number 2 with a #define.

Normally I would do this because I also don't like magic constants. But 
here there is no good speaking name to ease understanding so this brings 
nothing. If someone does not understand the 2 a lengthy comment was 
needed to explain the 2.

And this here (seen made by people being tortured by managers with 
tools) I won't do also to make a tool happy:

#define TWO 2

>> +           !virtio_has_feature(vq->vdev, VIRTIO_RING_F_INDIRECT_DESC))) {
>> +               netif_stop_queue(dev);
>> +               netdev_dbg(dev, "TX: Normal stop queue\n");
>> +       }
>> +
>> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +
>> +kick:
>> +       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
>> +               if (!virtqueue_kick(vq))
>> +                       netdev_err(dev, "%s(): Kick failed\n", __func__);
>> +       }
>> +
>> +       return xmit_ret;
>> +}
>> +
>> +static const struct net_device_ops virtio_can_netdev_ops = {
>> +       .ndo_open = virtio_can_open,
>> +       .ndo_stop = virtio_can_close,
>> +       .ndo_start_xmit = virtio_can_start_xmit,
>> +       .ndo_change_mtu = can_change_mtu,
>> +};
>> +
>> +static int register_virtio_can_dev(struct net_device *dev)
>> +{
>> +       dev->flags |= IFF_ECHO; /* we support local echo */
>> +       dev->netdev_ops = &virtio_can_netdev_ops;
>> +
>> +       return register_candev(dev);
>> +}
>> +
>> +/* Compare with m_can.c/m_can_echo_tx_event() */
>> +static int virtio_can_read_tx_queue(struct virtqueue *vq)
>> +{
>> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +       struct net_device *dev = can_priv->dev;
>> +       struct net_device_stats *stats = &dev->stats;
>> +       struct virtio_can_tx *can_tx_msg;
>> +       unsigned long flags;
>> +       unsigned int len;
>> +       u8 result;
>> +
>> +       /* Protect list and virtio queue operations */
>> +       spin_lock_irqsave(&can_priv->tx_lock, flags);
>> +
>> +       can_tx_msg = virtqueue_get_buf(vq, &len);
>> +       if (!can_tx_msg) {
>> +               spin_unlock_irqrestore(&can_priv->tx_lock, flags);
>> +               return 0; /* No more data */
>> +       }
>> +
>> +       if (unlikely(len < sizeof(struct virtio_can_tx_in))) {
>> +               netdev_err(dev, "TX ACK: Device sent no result code\n");
>> +               result = VIRTIO_CAN_RESULT_NOT_OK; /* Keep things going */
>> +       } else {
>> +               result = can_tx_msg->tx_in.result;
>> +       }
>> +
>> +       if (can_priv->can.state < CAN_STATE_BUS_OFF) {
>> +               /* Here also frames with result != VIRTIO_CAN_RESULT_OK are
>> +                * echoed. Intentional to bring a waiting process in an upper
>> +                * layer to an end.
>> +                * TODO: Any better means to indicate a problem here?
>> +                */
>> +               if (result != VIRTIO_CAN_RESULT_OK)
>> +                       netdev_warn(dev, "TX ACK: Result = %u\n", result);
>> +
>> +               stats->tx_bytes += can_get_echo_skb(dev, can_tx_msg->putidx,
>> +                                                   NULL);
>> +               stats->tx_packets++;
>> +       } else {
>> +               netdev_dbg(dev, "TX ACK: Controller inactive, drop echo\n");
>> +               can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
>> +       }
>> +
>> +       list_del(&can_tx_msg->list);
>> +       virtio_can_free_tx_idx(can_priv, can_tx_msg->putidx);
>> +
>> +       spin_unlock_irqrestore(&can_priv->tx_lock, flags);
>> +
>> +       kfree(can_tx_msg);
>> +
>> +       /* Flow control */
>> +       if (netif_queue_stopped(dev)) {
>> +               netdev_dbg(dev, "TX ACK: Wake up stopped queue\n");
>> +               netif_wake_queue(dev);
>> +       }
>> +
>> +       return 1; /* Queue was not empty so there may be more data */
>> +}
>> +
>> +/* Poll TX used queue for sent CAN messages
>> + * See https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2fwiki.linuxfoundation.org%2fnetworking%2fnapi&umid=9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-75f50331f3967f0d9a7aa44c85d0281167f4b56c function
>> + * int (*poll)(struct napi_struct *napi, int budget);
>> + */
>> +static int virtio_can_tx_poll(struct napi_struct *napi, int quota)
>> +{
>> +       struct net_device *dev = napi->dev;
>> +       struct virtio_can_priv *priv = netdev_priv(dev);
>> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +       int work_done = 0;
>> +
>> +       while (work_done < quota && virtio_can_read_tx_queue(vq) != 0)
>> +               work_done++;
>> +
>> +       if (work_done < quota)
>> +               virtqueue_napi_complete(napi, vq, work_done);
>> +
>> +       return work_done;
>> +}
>> +
>> +static void virtio_can_tx_intr(struct virtqueue *vq)
>> +{
>> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +
>> +       virtqueue_disable_cb(vq);
>> +       napi_schedule(&can_priv->napi_tx);
>> +}
>> +
>> +/* This function is the NAPI RX poll function and NAPI guarantees that this
>> + * function is not invoked simultaneously on multiple processors.
>> + * Read a RX message from the used queue and sends it to the upper layer.
>> + * (See also m_can.c / m_can_read_fifo()).
>> + */
>> +static int virtio_can_read_rx_queue(struct virtqueue *vq)
>> +{
>> +       struct virtio_can_priv *priv = vq->vdev->priv;
>> +       struct net_device *dev = priv->dev;
>> +       struct net_device_stats *stats = &dev->stats;
>> +       struct virtio_can_rx *can_rx;
>> +       struct canfd_frame *cf;
>> +       struct sk_buff *skb;
>> +       unsigned int transport_len;
>> +       unsigned int len;
>> +       const unsigned int header_size = offsetof(struct virtio_can_rx, sdu);
>> +       u16 msg_type;
>> +       u32 can_flags;
>> +       u32 can_id;
>> +
>> +       can_rx = virtqueue_get_buf(vq, &transport_len);
>> +       if (!can_rx)
>> +               return 0; /* No more data */
>> +
>> +       if (transport_len < header_size) {
>> +               netdev_warn(dev, "RX: Message too small\n");
>> +               goto putback;
>> +       }
>> +
>> +       if (priv->can.state >= CAN_STATE_ERROR_PASSIVE) {
>> +               netdev_dbg(dev, "%s(): Controller not active\n", __func__);
>> +               goto putback;
>> +       }
>> +
>> +       msg_type = le16_to_cpu(can_rx->msg_type);
>> +       if (msg_type != VIRTIO_CAN_RX) {
>> +               netdev_warn(dev, "RX: Got unknown msg_type %04x\n", msg_type);
>> +               goto putback;
>> +       }
>> +
>> +       len = le16_to_cpu(can_rx->length);
>> +       can_flags = le32_to_cpu(can_rx->flags);
>> +       can_id = le32_to_cpu(can_rx->can_id);
>> +
>> +       if (can_flags & ~CAN_KNOWN_FLAGS) {
>> +               stats->rx_dropped++;
>> +               netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%x\n",
>> +                           can_id, can_flags);
>> +               goto putback;
>> +       }
>> +
>> +       if (can_flags & VIRTIO_CAN_FLAGS_EXTENDED) {
>> +               can_id &= CAN_EFF_MASK;
>> +               can_id |= CAN_EFF_FLAG;
>> +       } else {
>> +               can_id &= CAN_SFF_MASK;
>> +       }
>> +
>> +       if (can_flags & VIRTIO_CAN_FLAGS_RTR) {
>> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRAMES)) {
>> +                       stats->rx_dropped++;
>> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not negotiated\n",
>> +                                   can_id);
>> +                       goto putback;
>> +               }
>> +               if (can_flags & VIRTIO_CAN_FLAGS_FD) {
>> +                       stats->rx_dropped++;
>> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD not possible\n",
>> +                                   can_id);
>> +                       goto putback;
>> +               }
>> +
>> +               if (len > 0xF) {
>> +                       stats->rx_dropped++;
>> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with DLC > 0xF\n",
>> +                                   can_id);
>> +                       goto putback;
>> +               }
>> +
>> +               if (len > 0x8)
>> +                       len = 0x8;
>> +
>> +               can_id |= CAN_RTR_FLAG;
>> +       }
>> +
>> +       if (transport_len < header_size + len) {
>> +               netdev_warn(dev, "RX: Message too small for payload\n");
>> +               goto putback;
>> +       }
>> +
>> +       if (can_flags & VIRTIO_CAN_FLAGS_FD) {
>> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
>> +                       stats->rx_dropped++;
>> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: FD not negotiated\n",
>> +                                   can_id);
>> +                       goto putback;
>> +               }
>> +
>> +               if (len > CANFD_MAX_DLEN)
>> +                       len = CANFD_MAX_DLEN;
>> +
>> +               skb = alloc_canfd_skb(priv->dev, &cf);
>> +       } else {
>> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLASSIC)) {
>> +                       stats->rx_dropped++;
>> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: classic not negotiated\n",
>> +                                   can_id);
>> +                       goto putback;
>> +               }
>> +
>> +               if (len > CAN_MAX_DLEN)
>> +                       len = CAN_MAX_DLEN;
>> +
>> +               skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
>> +       }
>> +       if (!skb) {
>> +               stats->rx_dropped++;
>> +               netdev_warn(dev, "RX: No skb available\n");
>> +               goto putback;
>> +       }
>> +
>> +       cf->can_id = can_id;
>> +       cf->len = len;
>> +       if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
>> +               /* RTR frames have a DLC but no payload */
>> +               memcpy(cf->data, can_rx->sdu, len);
>> +       }
>> +
>> +       if (netif_receive_skb(skb) == NET_RX_SUCCESS) {
>> +               stats->rx_packets++;
>> +               if (!(can_flags & VIRTIO_CAN_FLAGS_RTR))
>> +                       stats->rx_bytes += cf->len;
>> +       }
>> +
>> +putback:
>> +       /* Put processed RX buffer back into avail queue */
>> +       virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
>> +
>> +       return 1; /* Queue was not empty so there may be more data */
>> +}
>> +
>> +/* See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_change() */
>> +static int virtio_can_handle_busoff(struct net_device *dev)
>> +{
>> +       struct virtio_can_priv *priv = netdev_priv(dev);
>> +       struct can_frame *cf;
>> +       struct sk_buff *skb;
>> +
>> +       if (!priv->busoff_pending)
>> +               return 0;
>> +
>> +       if (priv->can.state < CAN_STATE_BUS_OFF) {
>> +               netdev_dbg(dev, "entered error bus off state\n");
>> +
>> +               /* bus-off state */
>> +               priv->can.state = CAN_STATE_BUS_OFF;
>> +               priv->can.can_stats.bus_off++;
>> +               can_bus_off(dev);
>> +       }
>> +
>> +       /* propagate the error condition to the CAN stack */
>> +       skb = alloc_can_err_skb(dev, &cf);
>> +       if (unlikely(!skb))
>> +               return 0;
>> +
>> +       /* bus-off state */
>> +       cf->can_id |= CAN_ERR_BUSOFF;
>> +
>> +       /* Ensure that the BusOff indication does not get lost */
>> +       if (netif_receive_skb(skb) == NET_RX_SUCCESS)
>> +               priv->busoff_pending = false;
>> +
>> +       return 1;
>> +}
>> +
>> +/* Poll RX used queue for received CAN messages
>> + * See https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2fwiki.linuxfoundation.org%2fnetworking%2fnapi&umid=9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-75f50331f3967f0d9a7aa44c85d0281167f4b56c function
>> + * int (*poll)(struct napi_struct *napi, int budget);
>> + * Important: "The networking subsystem promises that poll() will not be
>> + * invoked simultaneously (for the same napi_struct) on multiple processors"
>> + */
>> +static int virtio_can_rx_poll(struct napi_struct *napi, int quota)
>> +{
>> +       struct net_device *dev = napi->dev;
>> +       struct virtio_can_priv *priv = netdev_priv(dev);
>> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>> +       int work_done = 0;
>> +
>> +       work_done += virtio_can_handle_busoff(dev);
>> +
>> +       while (work_done < quota && virtio_can_read_rx_queue(vq) != 0)
>> +               work_done++;
>> +
>> +       if (work_done < quota)
>> +               virtqueue_napi_complete(napi, vq, work_done);
>> +
>> +       return work_done;
>> +}
>> +
>> +static void virtio_can_rx_intr(struct virtqueue *vq)
>> +{
>> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +
>> +       virtqueue_disable_cb(vq);
>> +       napi_schedule(&can_priv->napi);
>> +}
>> +
>> +static void virtio_can_control_intr(struct virtqueue *vq)
>> +{
>> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
>> +
>> +       complete(&can_priv->ctrl_done);
>> +}
>> +
>> +static void virtio_can_config_changed(struct virtio_device *vdev)
>> +{
>> +       struct virtio_can_priv *can_priv = vdev->priv;
>> +       u16 status;
>> +
>> +       status = virtio_cread16(vdev, offsetof(struct virtio_can_config,
>> +                                              status));
>> +
>> +       if (!(status & VIRTIO_CAN_S_CTRL_BUSOFF))
>> +               return;
>> +
>> +       if (!can_priv->busoff_pending &&
>> +           can_priv->can.state < CAN_STATE_BUS_OFF) {
>> +               can_priv->busoff_pending = true;
>> +               napi_schedule(&can_priv->napi);
>> +       }
>> +}
>> +
>> +static void virtio_can_populate_vqs(struct virtio_device *vdev)
>> +
>> +{
>> +       struct virtio_can_priv *priv = vdev->priv;
>> +       struct virtqueue *vq;
>> +       unsigned int idx;
>> +       int ret;
>> +
>> +       /* Fill RX queue */
>> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>> +       for (idx = 0; idx < ARRAY_SIZE(priv->rpkt); idx++) {
>> +               ret = virtio_can_add_inbuf(vq, &priv->rpkt[idx],
>> +                                          sizeof(struct virtio_can_rx));
>> +               if (ret < 0) {
>> +                       dev_dbg(&vdev->dev, "rpkt fill: ret=%d, idx=%u\n",
>> +                               ret, idx);
>> +                       break;
>> +               }
>> +       }
>> +       dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
>> +}
>> +
>> +static int virtio_can_find_vqs(struct virtio_can_priv *priv)
>> +{
>> +       /* The order of RX and TX is exactly the opposite as in console and
>> +        * network. Does not play any role but is a bad trap.
>> +        */
>> +       static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] = {
>> +               "can-tx",
>> +               "can-rx",
>> +               "can-state-ctrl"
>> +       };
>> +
>> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] = virtio_can_tx_intr;
>> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] = virtio_can_rx_intr;
>> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] = virtio_can_control_intr;
>> +
>> +       /* Find the queues. */
>> +       return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, priv->vqs,
>> +                              priv->io_callbacks, io_names, NULL);
>> +}
>> +
>> +/* Function must not be called before virtio_can_find_vqs() has been run */
>> +static void virtio_can_del_vq(struct virtio_device *vdev)
>> +{
>> +       struct virtio_can_priv *priv = vdev->priv;
>> +       struct list_head *cursor, *next;
>> +       struct virtqueue *vq;
>> +
>> +       /* Reset the device */
>> +       if (vdev->config->reset)
>> +               vdev->config->reset(vdev);
>> +
>> +       /* From here we have dead silence from the device side so no locks
>> +        * are needed to protect against device side events.
>> +        */
>> +
>> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
>> +       while (virtqueue_detach_unused_buf(vq))
>> +               ; /* Do nothing, content allocated statically */
>> +
>> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>> +       while (virtqueue_detach_unused_buf(vq))
>> +               ; /* Do nothing, content allocated statically */
>> +
>> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
>> +       while (virtqueue_detach_unused_buf(vq))
>> +               ; /* Do nothing, content to be de-allocated separately */
>> +
>> +       /* Is keeping track of allocated elements by an own linked list
>> +        * really necessary or may this be optimized using only
>> +        * virtqueue_detach_unused_buf()?
>> +        */
>> +       list_for_each_safe(cursor, next, &priv->tx_list) {
>> +               struct virtio_can_tx *can_tx;
>> +
>> +               can_tx = list_entry(cursor, struct virtio_can_tx, list);
>> +               list_del(cursor);
>> +               kfree(can_tx);
>> +       }
>> +
>> +       if (vdev->config->del_vqs)
>> +               vdev->config->del_vqs(vdev);
>> +}
>> +
>> +/* See virtio_net.c/virtnet_remove() and also m_can.c/m_can_plat_remove() */
>> +static void virtio_can_remove(struct virtio_device *vdev)
>> +{
>> +       struct virtio_can_priv *priv = vdev->priv;
>> +       struct net_device *dev = priv->dev;
>> +
>> +       unregister_candev(dev);
>> +
>> +       /* No calls of netif_napi_del() needed as free_candev() will do this */
>> +
>> +       virtio_can_del_vq(vdev);
>> +
>> +       virtio_can_free_candev(dev);
>> +}
>> +
>> +static int virtio_can_validate(struct virtio_device *vdev)
>> +{
>> +       /* CAN needs always access to the config space.
>> +        * Check that the driver can access the config space
>> +        */
>> +       if (!vdev->config->get) {
>> +               dev_err(&vdev->dev, "%s failure: config access disabled\n",
>> +                       __func__);
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
>> +               dev_err(&vdev->dev,
>> +                       "device does not comply with spec version 1.x\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int virtio_can_probe(struct virtio_device *vdev)
>> +{
>> +       struct net_device *dev;
>> +       struct virtio_can_priv *priv;
>> +       int err;
>> +
>> +       dev = alloc_candev(sizeof(struct virtio_can_priv),
>> +                          VIRTIO_CAN_ECHO_SKB_MAX);
>> +       if (!dev)
>> +               return -ENOMEM;
>> +
>> +       priv = netdev_priv(dev);
>> +
>> +       ida_init(&priv->tx_putidx_ida);
>> +
>> +       netif_napi_add(dev, &priv->napi, virtio_can_rx_poll);
>> +       netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll);
>> +
>> +       SET_NETDEV_DEV(dev, &vdev->dev);
>> +
>> +       priv->dev = dev;
>> +       priv->vdev = vdev;
>> +       vdev->priv = priv;
>> +
>> +       priv->can.do_set_mode = virtio_can_set_mode;
>> +       /* Set Virtio CAN supported operations */
>> +       priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
>> +       if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
>> +               err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
>> +               if (err != 0)
>> +                       goto on_failure;
>> +       }
>> +
>> +       /* Initialize virtqueues */
>> +       err = virtio_can_find_vqs(priv);
>> +       if (err != 0)
>> +               goto on_failure;
>> +
>> +       INIT_LIST_HEAD(&priv->tx_list);
>> +
>> +       spin_lock_init(&priv->tx_lock);
>> +       mutex_init(&priv->ctrl_lock);
>> +
>> +       init_completion(&priv->ctrl_done);
>> +
>> +       virtio_can_populate_vqs(vdev);
>> +
>> +       register_virtio_can_dev(dev);
>> +
>> +       napi_enable(&priv->napi);
>> +       napi_enable(&priv->napi_tx);
>> +
>> +       /* Request device going live */
>> +       virtio_device_ready(vdev); /* Optionally done by virtio_dev_probe() */
>> +
>> +       return 0;
>> +
>> +on_failure:
>> +       virtio_can_free_candev(dev);
>> +       return err;
>> +}
>> +
>> +/* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
>> + * virtio_card.c/virtsnd_freeze()
>> + */
>> +static int __maybe_unused virtio_can_freeze(struct virtio_device *vdev)
>> +{
>> +       struct virtio_can_priv *priv = vdev->priv;
>> +       struct net_device *ndev = priv->dev;
>> +
>> +       napi_disable(&priv->napi);
>> +       napi_disable(&priv->napi_tx);
>> +
>> +       if (netif_running(ndev)) {
>> +               netif_stop_queue(ndev);
>> +               netif_device_detach(ndev);
>> +               virtio_can_stop(ndev);
>> +       }
>> +
>> +       priv->can.state = CAN_STATE_SLEEPING;
>> +
>> +       virtio_can_del_vq(vdev);
>> +
>> +       return 0;
>> +}
>> +
>> +/* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
>> + * virtio_card.c/virtsnd_restore()
>> + */
>> +static int __maybe_unused virtio_can_restore(struct virtio_device *vdev)
>> +{
>> +       struct virtio_can_priv *priv = vdev->priv;
>> +       struct net_device *ndev = priv->dev;
>> +       int err;
>> +
>> +       err = virtio_can_find_vqs(priv);
>> +       if (err != 0)
>> +               return err;
>> +       virtio_can_populate_vqs(vdev);
>> +
>> +       priv->can.state = CAN_STATE_ERROR_ACTIVE;
>> +
>> +       if (netif_running(ndev)) {
>> +               virtio_can_start(ndev);
>> +               netif_device_attach(ndev);
>> +               netif_start_queue(ndev);
>> +       }
>> +
>> +       napi_enable(&priv->napi);
>> +       napi_enable(&priv->napi_tx);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct virtio_device_id virtio_can_id_table[] = {
>> +       { VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
>> +       { 0 },
>> +};
>> +
>> +static unsigned int features[] = {
>> +       VIRTIO_CAN_F_CAN_CLASSIC,
>> +       VIRTIO_CAN_F_CAN_FD,
>> +       VIRTIO_CAN_F_LATE_TX_ACK,
>> +       VIRTIO_CAN_F_RTR_FRAMES,
>> +};
>> +
>> +static struct virtio_driver virtio_can_driver = {
>> +       .feature_table = features,
>> +       .feature_table_size = ARRAY_SIZE(features),
>> +       .driver.name = KBUILD_MODNAME,
>> +       .driver.owner = THIS_MODULE,
>> +       .id_table = virtio_can_id_table,
>> +       .validate = virtio_can_validate,
>> +       .probe = virtio_can_probe,
>> +       .remove = virtio_can_remove,
>> +       .config_changed = virtio_can_config_changed,
>> +#ifdef CONFIG_PM_SLEEP
>> +       .freeze = virtio_can_freeze,
>> +       .restore = virtio_can_restore,
>> +#endif
>> +};
>> +
>> +module_virtio_driver(virtio_can_driver);
>> +MODULE_DEVICE_TABLE(virtio, virtio_can_id_table);
>> +
>> +MODULE_AUTHOR("OpenSynergy GmbH");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
>> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
>> new file mode 100644
>> index 000000000000..f59a2ca6ebd1
>> --- /dev/null
>> +++ b/include/uapi/linux/virtio_can.h
>> @@ -0,0 +1,71 @@
>> +/* SPDX-License-Identifier: BSD-3-Clause */
>> +/*
>> + * Copyright (C) 2021-2023 OpenSynergy GmbH
>> + */
>> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
>> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/virtio_types.h>
>> +#include <linux/virtio_ids.h>
>> +#include <linux/virtio_config.h>
>> +
>> +/* Feature bit numbers */
>> +#define VIRTIO_CAN_F_CAN_CLASSIC        0
>> +#define VIRTIO_CAN_F_CAN_FD             1
>> +#define VIRTIO_CAN_F_LATE_TX_ACK        2
>> +#define VIRTIO_CAN_F_RTR_FRAMES         3
> Why do we need both VIRTIO_CAN_F_RTR_FRAMES VIRTIO_CAN_FLAGS_RTR?
>
> Is it to manage devices not able to sent remote frames? If so, we may
> also need to add a CAN_CTRLMODE_RTR in linux/can/netlink.h?

VIRTIO_CAN_F_RTR_FRAMES is a feature flag. RTR frames may or may not be 
supported. AUTOSAR CAN drivers do not know anything about RTR frames. So 
if someone wants to build a virtio CAN device on top of an AUTOSAR CAN 
driver with the additional requirement not to change the existing 
AUTOSAR CAN driver RTR frames cannot be supported and the feature flag 
won't be offered by the virtio device.

VIRTIO_CAN_FLAGS_RTR is a bit to indicate a frame type in a CAN message. 
Used internally in an Linux SocketCAN interface.

>> +
>> +/* CAN Result Types */
>> +#define VIRTIO_CAN_RESULT_OK            0
>> +#define VIRTIO_CAN_RESULT_NOT_OK        1
> Silly question, but what is the rationale of not using the error code
> from errno.h?
Looked into the AUTOSAR_SWS_StandardTypes.pdf  Std_ReturnType:

E_OK = 0

E_NOT_OK = 1

other are "Available for user specific errors" like CAN_BUSY.

Linux is only one operating system. An important one but there are 
others. AUTOSAR people may ask you "What is errno.h?" (and also "What is 
malloc?"). Our internal client is interested in a Virtio AUTOSAR CAN 
driver. So there were reasons to look first into AUTOSAR.

There is also a CAN_BUSY for the AUTOSAR Can_Write() to be returned but 
this is not needed at this interface as a virtio AUTOSAR CAN driver was 
busy when there are no sufficient messages available in the virtqueue, 
so for this condition we need no defined error code to be used in a 
virtio message.

Virtio block defines VIRTIO_BLK_S_OK 0, VIRTIO_BLK_S_IOERR 1, 
VIRTIO_BLK_S_UNSUPP 2.

> I do see that some other virtio devices do the same:
>
>    https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2felixir.bootlin.com%2flinux%2fv4.6%2fsource%2finclude%2fuapi%2flinux%2fvirtio%5fnet.h%23L140&umid=9bd91fe2-cd6c-4f97-823b-3f938eb06afa&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-92b14ac1d1eb12690206c7a0e34d2f211c4c3e06
>
> But I am genuinely curious to understand why virtio do not use more
> standard error codes.

I cannot speak for virtio. errno.h is ANSI C and POSIX but virtio does 
not only address those environments. It is a more general specification.

For the virtio RPMB device the result codes in the virtio specification 
come for example directly from an JEDEC specification for eMMC. Which 
has some connection to a JEDEC UFS specification, same result codes 
there. Makes a lot of sense to use those result codes in this context.

As virtio is more general, I have for this also my doubts whether it 
really was a good idea to take over the CAN RX and CAN TX message 
definitions 1:1 from Linux (if this is possible). Someone proposed but 
I've my doubts.

>> +/* CAN flags to determine type of CAN Id */
>> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000
>> +#define VIRTIO_CAN_FLAGS_FD             0x4000
>> +#define VIRTIO_CAN_FLAGS_RTR            0x2000
>> +
>> +struct virtio_can_config {
>> +#define VIRTIO_CAN_S_CTRL_BUSOFF (1u << 0) /* Controller BusOff */
>> +       /* CAN controller status */
>> +       __le16 status;
>> +};
>> +
>> +/* TX queue message types */
>> +struct virtio_can_tx_out {
>> +#define VIRTIO_CAN_TX                   0x0001
>> +       __le16 msg_type;
>> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
>> +       __le32 reserved; /* May be needed in part for CAN XL priority */
>> +       __le32 flags;
>> +       __le32 can_id;
>> +       __u8 sdu[64];
>> +};
>> +
>> +struct virtio_can_tx_in {
>> +       __u8 result;
>> +};
>> +
>> +/* RX queue message types */
>> +struct virtio_can_rx {
>> +#define VIRTIO_CAN_RX                   0x0101
>> +       __le16 msg_type;
>> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
>> +       __le32 reserved; /* May be needed in part for CAN XL priority */
> Can we use this field to report the classical CAN DLC greater than 8?
> If also needed by CAN XL, the field can be turned into a union.

Classical CAN cannot have a DLC > 8. CAN FD has a length up to 64 bytes.

Length is is already __le16 to be able to put the 12 bits of 2048 for 
CAN XL into it.

But for CAN XL we need anyway a more critical look from CAN XL experts 
on the list. Here in the house there is already only fewer experience 
with CAN FD in comparison with classic CAN but none at all with CAN XL. 
Too new. If something is done in a stupid way we can define in the 
future completely new messages as we have the msg_type. But if no 
mistake is made now we can avoid this and enhancing things will be more 
simple later. The RX and TX messages are really critical. Some bugs in 
the software can be fixed easily. But if we define here something not 
future proof this can only be addressed later in the spec with some more 
effort.

>> +       __le32 flags;
>> +       __le32 can_id;
>> +       __u8 sdu[64];
>> +};
>> +
>> +/* Control queue message types */
>> +struct virtio_can_control_out {
>> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201
>> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202
>> +       __le16 msg_type;
>> +};
>> +
>> +struct virtio_can_control_in {
>> +       __u8 result;
>> +};
>> +
>> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
>> --
>> 2.34.1
> >


