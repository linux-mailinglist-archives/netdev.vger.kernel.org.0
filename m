Return-Path: <netdev+bounces-11959-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D827F735706
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C10B61C2083B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8D4C2F8;
	Mon, 19 Jun 2023 12:41:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D536BE7D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:41:15 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E2A91
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 05:41:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPqIj61rB2zxbi4VfhH/oLrvWMJbtVxkYpiJSQR8HMlUiAElXQW/2d1+ufS2zMHUcmTnJlb8EafLiifT2OqMMHx9lUyQLsaAFCynueWftNZqtOwgaOYooJ3uI582zzVwbfE/k0P4P4BLPBiIyphFifa1n3dYWcJb/oKJ3wqxDF18byuy9R/bUPWpVpqTiQzBWEyTWLQmbFUQXymb1xNcEdoCJ2vKWvURZEs9zcX2+PQtOKl13FI1o3mVFfyWjX9t9vwQV/4ednCPIJJMG7E8mlHL4qecU6hiyZgp9IF5aRzgrXr4/tGOsZdo63Iz95BqzdmfFAKyeyCK/Z9onI3PUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSp7xx68+qZUoSFu7pz8ov9o8qV3o3397zYRdgXFhXY=;
 b=drePPHI7jjFDMRujj1m6tpC/Ovd1snG5yY9+EUWp05r5lTTUgVEGWavJIoucTPtuhonrfR8W465GOVtKB+fOOry7EQRagrZUT71zFl1nhWuhI26Fz18vviVxPllhd7WQVkUwzRGkz+40uLhGQBVOMBe+/mqO8i0J39omoceSN+KQCDxGq9ksBo4a08rbDbSM89zYaRueEy7/afRStngXvc8DlTZZdI8oQinh87gZgQIlhwWMCsH8eOc5EUUbkldy8QKcB/QfYXSbmSIwWHBvDFCXH5Jk10LOVyx+dxCkFGF58gqtUSvzJabZkXzD62gQdEjghQwZY1oWwuFxXo6duQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSp7xx68+qZUoSFu7pz8ov9o8qV3o3397zYRdgXFhXY=;
 b=YR/CQhpJNsdUhBoNvEgDABGM/FYzQwVnonOKUbWuEsdKAD7It+Czng4YEdVjaLK5jw2S0AjBk0y/kzmdNIA2Xq9RVTkLptweRuNkllFq9O/GSKXV0hrfnrUmAx/FiKHB8AOr5FbdZmxsNJZyw47ZHnaXgAceX29L0k+w114Xc25YuewIlAbOBaC570+ZiusXJI5uTLj+XiGvzYYH9c8HSbaE2p0Dw8pKvnJjl8GGN2lIE5ff+MW1rDw7/QeSgiKTvh/cZKMgoYQLiA8JchJ2B0EYPnqI+9Uw6d3iGRWqOJFO3T7loeod27eg+mp7PZ1rVRF+tvqwW1kPqwZtxcYpoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SJ0PR12MB5663.namprd12.prod.outlook.com (2603:10b6:a03:42a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 12:41:06 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 12:41:04 +0000
Message-ID: <e39bf2a7-0eb4-7c93-5a98-3a57df860fbc@nvidia.com>
Date: Mon, 19 Jun 2023 15:40:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH iproute2-next] iplink: filter stats using
 RTEXT_FILTER_SKIP_STATS
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
 Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
 Edwin Peer <edwin.peer@broadcom.com>, Edwin Peer <espeer@gmail.com>
References: <20230611105738.122706-1-gal@nvidia.com>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230611105738.122706-1-gal@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::20) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SJ0PR12MB5663:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3203bc-93f8-428a-7eb7-08db70c27241
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Yv2er+7Gp4TS3u+m8TC1gEPkybQWBRgD+u54u91nSTNt+R5m54mZLkqR/yB+6n28VZ54YVMG/gcGHpQUBjY53hx09H5WHyzne7omQWrLdjesWk1Ilau9BFLlDeASkAnOVv8yRHCYWUai5+LIfbpYRp+DQ8ob4EeywVLLsl2b/e//0Is27gkp/vkGLomFB4aQePvihcYXSk4UDdvCWwFq9uixFjmk4Zsx17/xvzuIlmKV0iDiWFcrkdbVZt+7EMnpFOeNKmdozCoSay2ZpjIaA6us1griQuinIDwxjRSBnXcobJtsVDPRObM3SloavOAt8WP4RLZla96zhYqya5qoGmmBPsBMk+8uYGqbjk53cj4cNn0PotrXcy2O9BE7IaBziqHAfdYj2dT6F67bdBkPRU7ZsTGT8SK4IZkDSbujjEFBF8m+wszcspemtuJkv3i3kHBMTqOfzdXqKGIBy96X0m5zhHOSI6O8kFrAY6d6xJ0fEJDD4SI2kGcdPKqcDYCDMW1X+lhmHvkRSY+X4x63j+QUM+UYmZgq7G4umRlTnd05/q2xHPIqC64CK0k4rNKiOMwaoio/XZgMErf2ZLpaYsPtfsQ3Iw7+cO/rfow93gAr3kK7Wdp0j+D6APV+exndkuVzBLC+X6mgsCl4zkkNSyifU6d09dreBPeqyLFAajV/Vva3b5OfN3QfPI8TKOV8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(4326008)(54906003)(478600001)(110136005)(6506007)(53546011)(6512007)(26005)(6486002)(186003)(966005)(6666004)(36756003)(4744005)(2906002)(8676002)(41300700001)(8936002)(66946007)(66556008)(66476007)(316002)(5660300002)(31696002)(83380400001)(38100700002)(86362001)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0pnbTdBRGo2UHJxRnFNSC80Y2FkSUliZmpTeWRPWnJCOVZIdFl4TEx2Yk5U?=
 =?utf-8?B?ajc4amY5K281a1owTE5TQm5kaHRFcXBNV2JhRStMS0FWV0JnTVNkMVN0ZlV0?=
 =?utf-8?B?bW5ZUEczbXlrNWlRcGR0a0JORlJjb2xIMFVDejlDK1Z4aG9Ub3dzNGhKNGRN?=
 =?utf-8?B?Z3ppenJuSjhndkM4UER4dm9aRHErU3I4NkgzZmJ5MklrZTkwVE5rOVF6UXNq?=
 =?utf-8?B?WUhDd29WU0JQR01xNHhlWHVzdGlwajFQVlAwcG1EMzdrOXNUN3ltRG1JQUJG?=
 =?utf-8?B?cEpwOTBZeWRJSm9IK0VZcnFpSTliM2tMNHNyWHdJOHR3eCtHYWsza2xiNGFn?=
 =?utf-8?B?TVlVZjBsOERhWHZGMm5MNjRKQUQrQk9GSWJlbmFlYklUVFc1ODhraExjdGhh?=
 =?utf-8?B?T0ZIK2lJVnpub1lTSjVHSWJRNEV4d2h2L0QxUmpZa09rdHFDd3QvMmd4RHNV?=
 =?utf-8?B?MitpRmdkQkNIcWtlMDhDUCsrcUhUSCsyVzJCdHQyNDlaZ2JOTWNWRWNxaVdC?=
 =?utf-8?B?YjJqekJsdTBCUkRXdXk3cnFYUVFxSko4cDZQYjJnRGVQQ2pmOXE2SHJLcjhN?=
 =?utf-8?B?d2x1Mm56NkRuWGRYMEtHMkwxcTg0VjdKM2dJNmZtZEt6Zng2ei9EQlhkM2E5?=
 =?utf-8?B?bER0b1MyMHhMZjdiK1p3WDc1UUNNd082S1NVdHV4VVhvRjU2WTJ0ajNPekUw?=
 =?utf-8?B?ZXBVekU2VVRvTysxeDlFbWNsNzI0Z2xqRjVOL1ZxamdaeGd5ekQybkpOaTVC?=
 =?utf-8?B?cFBYTlBHN0hnQWhaU1E5NnIxcHgvaDN0S1N0Mkp1WVBNRHo2QkJUNzNhTmEy?=
 =?utf-8?B?MVJiNlh6OExHNStBcjhFUitLdnlTR2VCN2hRd0U1QUkvM2h2d0RnVlBPZ1FS?=
 =?utf-8?B?L2FSNUplZzVMOHJhU0lSWWpkZkI4RWd2K3UwUFE4dk9RcVVWWURHd0dIeVlx?=
 =?utf-8?B?dHJIT05BYy92MDhqcktoOUlwd0E4b0k0MkZwWGF6R01WTEZ2eHhqbHNNRGlF?=
 =?utf-8?B?TE80MHRXSDdlMXUxMkdBemVjRE5nak5DNWJWS2crR1RlVm9FdW9LNmpFQUJk?=
 =?utf-8?B?SWxzWmtSTnc5RHRXZWVyWW1ZL3ZCY0ROc3Zmbk1aR0JZZzZORXJYMDY5a20y?=
 =?utf-8?B?MU1acE1XUnNIK0tnYXcrZ0UzaUtGVXNGeEtjdzdHRXlPbzNIUE1oelZzemZS?=
 =?utf-8?B?MDl2YVk3RGwxc1Exd1NRZ3EwRFdadDdaZ3d4cmFNTFc4a2VYL2ZHMytTbmZ2?=
 =?utf-8?B?R3pEMFUzaVVDR0NSdXNENndKdzNLa0VZZWlIOFdncVJUanVzSEcrZ0FtclUx?=
 =?utf-8?B?WUh0eFFKLzJhZElUaU44bzdXT29lMlQ2empnZWlsdVNBSHJEczZMbWZkMWZF?=
 =?utf-8?B?TmlnTDhxbmV0elpFT1RkS2ZNYmRhMHVINDFVK0dXTFppWnp4eUY2Smg4NzFR?=
 =?utf-8?B?ZGQwM0VpMUwwTGRENnpmelZQUy9hZEhUdnY0WDMrUzlWK1NlaXZwOWlnVnhm?=
 =?utf-8?B?N2wvemkxSWhvdVdTYXdDSEw2dmYxU2d4VSt4TlZ4UHEzRG1jWnZtNkhsOTJP?=
 =?utf-8?B?ZGpLLzlobXpqTVh5RUxSWGtoei9oMGVuUysxdzVPUzlKUU1RVmk2SDMxR3Bp?=
 =?utf-8?B?V3lFZWtoU3pnUVVVWTRpMURtaDkzSDErV29Hc1NNdUdlSFB1elVhNEdncGx2?=
 =?utf-8?B?YTlzdXdtWFA4c3N6dDRYc2tuOVQ3R1VrY21QTnk5ZkVja095a2dRS1lna0Jv?=
 =?utf-8?B?c3lUYW5ZUDJJVzN2Z0ExQ285dm9ZUjR3TVY2aWwyRWsvR3RtL2JySXU5elg4?=
 =?utf-8?B?OS9ITlVMWk1EK0lTWTNFeUVMWndDemxoMDF1QSttd1o3VDhLRjBXTjhuTGsr?=
 =?utf-8?B?dmk5aEk3OE1mMFBka2REaGgybEoyNUlGT0FNRDBNdnNaUUs5WlFiMksrMVF5?=
 =?utf-8?B?eXpSQ2hBR1dackxzMlVQOUJaUTBKaW1Ca0tMbzlUa2xjZGNzL1QvdkRhS05M?=
 =?utf-8?B?WjFyOTY4VjZOMVlONDlXS1c0ZUJqVmN0K2ZXVS9Da0UwWGRQUkRaZ2xTZ2FK?=
 =?utf-8?B?Qkpieko1MVozQ01CWHR2RERmeGFWQ3BsTU1GZGk2OFlCWVNjYVhnMW1zaVRh?=
 =?utf-8?Q?Z+g/IVJ+ZgwuF45dGuo+snMeY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3203bc-93f8-428a-7eb7-08db70c27241
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:41:04.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rzAXpxwE/bfbvcqIA0Xmk1loJOHB/iy45tVaoye0hpWHEgQ0OUIUUGmed4bxS7w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5663
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/06/2023 13:57, Gal Pressman wrote:
> From: Edwin Peer <edwin.peer@broadcom.com>
> 
> Don't request statistics we do not intend to render. This avoids the
> possibility of a truncated IFLA_VFINFO_LIST when statistics are not
> requested as well as the fetching of unnecessary data.
> 
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Cc: Edwin Peer <espeer@gmail.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
> Userspace side for kernel submission:
> https://lore.kernel.org/all/20230611105108.122586-1-gal@nvidia.com/
> 
> It is only a partial "fix", but increases the number of VFs presented
> before the truncation occurs.

Kernel side was applied.

