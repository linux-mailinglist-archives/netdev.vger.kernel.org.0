Return-Path: <netdev+bounces-4629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EFCD70D9D6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47D881C20CD5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664E31E53D;
	Tue, 23 May 2023 10:04:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533661E501
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:04:52 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2120.outbound.protection.outlook.com [40.107.237.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A4119;
	Tue, 23 May 2023 03:04:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnYJzrcsq/pwr9ovLPRr18nIP2Bf44TRAp9IWqkvjJSPD/MjryGj9+Fi6c6utXWx38VhiKW7sbvuVBA5FebWl8yjxPPEEt1Pdk9dPq9Ab4Dui2IlI/X+3UdCe/xrS77x8Cr85Z6f/iXFZAl7t5OzAzD7+UhW82Qi6K8a8xT/wmVdiKF9qt+pkyl+RmTXQCAICm2KfXQHysQcyEA4SmYH99A4M4BIXFqhmWDtmOWo/chKzyzcslwykp6xfcQbrVW6r+gzyqcZGhV1pATum0pDVq9x9qBnSe736GyD8qDlbxNn2BqrZaqX/Uzjjxa5YigjgC1yV7Ig3oecXfW9THwl3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJYBoVzgs6bTKAM+vc0SYbEmT4n8azIWzn4/e1LaoHE=;
 b=X5cK4iuBRSPboPQVGHgcqpq17+qLtneEavvo6TugsiJN54zDxbAMhY+DbfZAA0bgg87e7ptMasPEOHSCAI4eSavdL6HjYGjv3fpnZiazrQSKi4IlQ7m2RIjB8k694HvXE7FUcLdGNYPfHqIpWQjZT1YK88Edbqapzk0cUKRl1L6QvV0NbZzggDtDjgu9CmoZjYSaoi8K+Mj87EMyXpbRfTibMW1CC7ayFm5fIf/hPA+JvitYg8zq2XH4SRiE7y5ft47L/8LQ42wy6dxoK2+qHjkguJQnEptGioF79Hn1j2vFFzQm0ZyL73tG5bYT0s3fkgH2UPpWoY6w/p8ojGeC6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJYBoVzgs6bTKAM+vc0SYbEmT4n8azIWzn4/e1LaoHE=;
 b=AC5RlLZm02xeLIEK+prdLX7wt206aGWKOZ3j7FV5gsWnIUnrJpefq1O6YFIWrA8m5av/VC0nqdZX413URWjC6H/SgsYM39DJhCwkr2eEWrB5EzCAyZRME0u8+PeQR4LSr0WndwHxYnZ8E58RJ5oM+46cdDenqK3xqvI0D1icsdY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3652.namprd13.prod.outlook.com (2603:10b6:a03:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 10:04:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 10:04:45 +0000
Date: Tue, 23 May 2023 12:04:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ying Hsu <yinghsu@chromium.org>
Cc: linux-bluetooth@vger.kernel.org,
	chromeos-bluetooth-upstreaming@chromium.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] Bluetooth: Fix l2cap_disconnect_req deadlock
Message-ID: <ZGyPt1GYGV2C2RQZ@corigine.com>
References: <20230522234154.2924052-1-yinghsu@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522234154.2924052-1-yinghsu@chromium.org>
X-ClientProxiedBy: AS4P191CA0018.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3652:EE_
X-MS-Office365-Filtering-Correlation-Id: 1806417c-ddf1-4fd3-2bef-08db5b7522b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Tb+RnuQMP+SU6FnkRqeekZjvFPqHLIolbjmHOEuLhWDTYGtzjuPVoV6wxlfjFo1AsWud9OefXFFFKx4CtPFmJTHvxs4gK5LwZ+HiLlyvgbxdndCs8OZ9JsjuMRFcmMFfguGEY9y/8ObUx40XczvPQnP+Njdsmo7UUxUC8BhxHzw25cOfusbcJg3T9uEfipaD8oqP5DlYNptgUXKVzH9yp//uSZ6cq796HhS3Gmtp5JuDhodGmW2FBZJvVFZCDkHJsTo8uZC7NNq14dovxvZ3sScy5yaXyFMEYYd7TrRxH1IfcJ6NOFZKzHKquJrFIkOoShkPfJ/SLgVmqAf9vWU9MODE/ea6NizSBh9OTnqbIzq/dxgzKwlgt5yoPZYr0IlCOsuU4e+gIfs/U3LY7eAYzrkqL1keibs+GLGD8g5VXUOXQplSyyHKsQ+elF739uksrlyvPo1pO677BWjdsu9cAP2ucj9z5OLldKR7KRjsp8HCaBXYSJNkhyV6biG4LY82HKaOZRcwUkbrv/ubLFTnIqWNitsH9JprhDvwNgPZ/BsbYolLyIZIc1349GNOWsjT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(376002)(366004)(346002)(136003)(396003)(451199021)(41300700001)(66556008)(66476007)(66946007)(2906002)(186003)(44832011)(478600001)(6486002)(316002)(4326008)(6666004)(6916009)(5660300002)(54906003)(6512007)(7416002)(8936002)(8676002)(36756003)(2616005)(6506007)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QuHXy4h8+Wxdf8SW11T/dw7fqzVTFe4O6KkBmMXfQr9zCQCQ+Tr1VZNMkEHI?=
 =?us-ascii?Q?FnrGlAaGqpIGBrjTIJ9aGO9V9dKH7ck4x/2hI8oXUYdnvFqsOdsr0q5uPWlI?=
 =?us-ascii?Q?X8JOPfSKkzsMxCHP/kRW+qVxqakD92DNG0TjG2E/b7tNg0UlYv4Fea1jY9vE?=
 =?us-ascii?Q?ZhgQ3qHMCQ+UEXRUZQHb+GVxZY7wbgGL4i2hR9oh+sTruxgZPLXHMURcpvCy?=
 =?us-ascii?Q?ywPQT40jMJtbfLwEDSZ5Qwba1xp/44fWq4f5SmDWZwZnZEcMtezLXMHvC4Kv?=
 =?us-ascii?Q?cEz1RQ12C9kxB8oJCDFMKtLv5mEj94sRwklDJveQKqpHlQnaYXNooI87Pr84?=
 =?us-ascii?Q?8aXDPG31Zft0oIE+l5/wvmrtX5aW7RNExLUDqUvUqSB+k7dyv0I8lvfuAtlv?=
 =?us-ascii?Q?wnObv057VyPHQl/cZWEjGOolelLWb5FcQGlERIDGOyUcbX/i11ngUYXoi/Ks?=
 =?us-ascii?Q?WFfHP2EN6LMjslMRjszPxOETrNcFD5dY1FQxoug0ttg/0CVOfFZ4u3HsV9KM?=
 =?us-ascii?Q?KuVknA+YjEwRtiVbqux2vWO3lyMsCj7udeMCuDHtTPOC5n2ODpxSALOHWbSL?=
 =?us-ascii?Q?JVbOiYSY2zh2gtZHbK6bxzakJBSVuhR/iyWkFI//GGxT+AsutTVpAKdbPmF9?=
 =?us-ascii?Q?sykNUykggFzJvIiigaIzhWpUrFPE2dRCDCqeo97qaR0sbhNnQSuwx6QE02Hm?=
 =?us-ascii?Q?NglYWolWhevvy1WDvXo2jVN1c+VCQ8puH/OLxbvpcWUb/U9OnQT3NqMFTaFE?=
 =?us-ascii?Q?biNARQfAd6fNrJFEwlcYEXAQpPlyIPkMej68GbvgR5/qwFNp62Np1UdXFRNf?=
 =?us-ascii?Q?K77hQEyE73C5r3o2LgthG+GD126BPmu7m2cDIRhLH5082VTua6LryVoiI8a5?=
 =?us-ascii?Q?nyDLxkuAWgc0dvP11koByZtRWoUm4HhaAzB81JoTS9VED3XLsX82+tK1wW7G?=
 =?us-ascii?Q?VbvaaJgZWeiJu4PeQdKzwgNJ5KimeadMWJD3f3t1GYEwFW5olJKCKg7B436n?=
 =?us-ascii?Q?GB5YcPwXIKrsIts352SztyihiNsRaIWwOBueizbBOV8LZH/gJS06ex2h4hlw?=
 =?us-ascii?Q?p0Yhmr+t3d6vnHYChEK1AaClmRq3vhFEPm5wBWoBnVBv4rGzj0Hu41dmadNC?=
 =?us-ascii?Q?e+UukQav1v0yksnZEOrT8pbT2Ajo7iKgEODT9yC/DNpKVv9BQU0ksJ7Y2FI2?=
 =?us-ascii?Q?lstCvzC5W2fwOshTtzxErCPwqBXmO0Mi5IiihtkBc2rRQCPod2Mna2XRMGi9?=
 =?us-ascii?Q?Q+zhZvPdeM3iEGfIMU+qNdfbn/kPK8IapWUNRgizXOuN4LmnGaLQ0RfIGOmB?=
 =?us-ascii?Q?1ERD4kF762UBTcWzf4/ObNe0QQp2IlK82cOIy/0q6/2kKwos8r4wqcRk+pFn?=
 =?us-ascii?Q?GuG86o+k+WIEnCbia/5e9taPGJNxSw54jG/G4OUurXDBqzCA/BxCXrXcclqr?=
 =?us-ascii?Q?5ZPolM5BMLfh93lCLyPWwULP8yYOY3W95c647fOIpQOAVlT1xxG9tY1K8KIN?=
 =?us-ascii?Q?lFCyUw0UNB3PKd0K7tnd89r8u46dXQaj8w/1G1cLBOvkZnhFmnPUnNMnNRyz?=
 =?us-ascii?Q?l3q0FVi1VIYKui6fd11q2XrgepHGNIsF+IYLrPkmATAMH33BDRYhBoTd9bdP?=
 =?us-ascii?Q?wv0QKoburULmgg1QQCfyfemIglQoDEhRXbYPKSvsM75Eojqc72PiERFWHYe5?=
 =?us-ascii?Q?jWtgUA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1806417c-ddf1-4fd3-2bef-08db5b7522b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 10:04:45.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3ZK42vw9fY2OwPtq6hnzVSgsW3tFOIc8Yq6TBjVyH9T+ZsVs+Wz/LBgnozkojXtxB5tMjaJnCwOWJYcdQikLAlRc9ZPTOnTr1Jv1gLdVpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3652
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 11:41:51PM +0000, Ying Hsu wrote:
> L2CAP assumes that the locks conn->chan_lock and chan->lock are
> acquired in the order conn->chan_lock, chan->lock to avoid
> potential deadlock.
> For example, l2sock_shutdown acquires these locks in the order:
>   mutex_lock(&conn->chan_lock)
>   l2cap_chan_lock(chan)
> 
> However, l2cap_disconnect_req acquires chan->lock in
> l2cap_get_chan_by_scid first and then acquires conn->chan_lock
> before calling l2cap_chan_del. This means that these locks are
> acquired in unexpected order, which leads to potential deadlock:
>   l2cap_chan_lock(c)
>   mutex_lock(&conn->chan_lock)
> 
> This patch uses __l2cap_get_chan_by_scid to replace
> l2cap_get_chan_by_scid and adjusts the locking order to avoid the
> potential deadlock.
> 
> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> ---
> This commit has been tested on a Chromebook device.
> 
> Changes in v2:
> - Adding the prefix "Bluetooth:" to subject line.
> 
>  net/bluetooth/l2cap_core.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 376b523c7b26..8f08192b8fb1 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4651,8 +4651,16 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
>  
>  	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
>  
> -	chan = l2cap_get_chan_by_scid(conn, dcid);
> +	mutex_lock(&conn->chan_lock);
> +	chan = __l2cap_get_chan_by_scid(conn, dcid);
> +	if (chan) {
> +		chan = l2cap_chan_hold_unless_zero(chan);
> +		if (chan)
> +			l2cap_chan_lock(chan);
> +	}
> +
>  	if (!chan) {
> +		mutex_unlock(&conn->chan_lock);
>  		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
>  		return 0;
>  	}

Hi Ying,

The conditional setting of chan and calling l2cap_chan_lock()
is both non-trivial and repeated. It seems that it ought to be
in a helper.

Something like this (I'm sure a better function name can be chosen):

	chan = __l2cap_get_and_lock_chan_by_scid(conn, dcid);
	if (!chan) {
		...
	}

	...

