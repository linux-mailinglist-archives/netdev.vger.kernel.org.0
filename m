Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D8A3B6B96
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhF1X6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:58:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhF1X6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:58:40 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SNrrwJ014558;
        Mon, 28 Jun 2021 16:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=ZAHxCzrXzs712IqwwkuVyvetFu7OudzKV3S6+503xMU=;
 b=pzSPIYWOLAhBqTmMe7yQpNzpIz40LbVSdlIVpbAWT/+jAUcL8BWcBPNKxghxsJ436BN/
 cav7Ia/K/wWH7JauH+UXxGiO/mGg5posrZydH4HgmeDQta8p+bisfDtfYQ9RbTaJymCP
 ps1e9YGRTjVrfPlU+u4bnyQoRUUYfOhBVLI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39fg3aktdb-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Jun 2021 16:56:10 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 16:56:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S05An6nwU8rhmeKGOsD5w/ns58+zI+0eGdbn8g4itl0cYYMLT+1+HqZ8M/b4UZPuadrWCprKHmZDGitxfxWe6HjNIvhelKtAYpiI2ZyHD1FvcuvU5DEvJpRZsS8p96hO5/NngOQAZW6p3t9WGstS2Sk/3yrg9ZW5iMxbtdClQquQN7qKwKKxhlE2gdfYUDM+DeRLbZi0oYu6JAjhL8uYgYxPmlejsX50zkFsQdEGQiNoSZXedbcoApbtlsaPOrvnK4r/p2sdoVKKmJJ55dmNZMlTAJ2cluA1ucZJTjEX8im3lmXu7UPdU1m0kpENMHUbYTCErbspcAZr1cHYFqD1ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oKkL/v+q402gMdgH3wGZPdT6o9r+jV3gF19awLXcNY=;
 b=bu3mOOsF4pGTFMfi/U6T+MET8UJyI51cqQyFdsE2f4coRbzjnl3/xoMjGsfBohWDY4KYgmPsgcNtM+QF7NrBd+1W+OedmVtcngt+dTnb93QVYRp2NQz6bOEpp04t6Fn+xTs1nA9iOwyNbB+/kF6bAxr3xhSZgjjsfulkkoWIxnzZUskVuT2AEzBo+ccLyKnT9SwQMN2DM7QVdmuVRsCxAzvzN/cpHaJGz6gHpQK2/UL6ZJ5aBYv29hKiilNFDtU2d8fi+OiKCfu/btnwkQcB1G4yD4KqL44K51bGwcHMEXa8RPp7nFMihXUyc2wsmVTPziB0EPReV+g9onNJNS2bPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2094.namprd15.prod.outlook.com (2603:10b6:805:11::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Mon, 28 Jun
 2021 23:56:02 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 23:56:02 +0000
Date:   Mon, 28 Jun 2021 16:55:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next] bpf/devmap: convert remaining READ_ONCE() to
 rcu_dereference()
Message-ID: <20210628235559.sgq7txsjmz3s2zeb@kafai-mbp.dhcp.thefacebook.com>
References: <20210628230051.556099-1-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210628230051.556099-1-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:170c]
X-ClientProxiedBy: BY5PR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:a03:167::35) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:170c) by BY5PR17CA0058.namprd17.prod.outlook.com (2603:10b6:a03:167::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Mon, 28 Jun 2021 23:56:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cc03660-6c2a-4a1b-4f11-08d93a9048e4
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2094:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB209494407C2CF493BE2A3E82D5039@SN6PR1501MB2094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IN4F49NBSnuRIgojMU/VQ9AOKXu5VwlHvW6PXtmzFDns0Kg35CYWrrlsuL0sLvYvJ1h7lbUcfvaFXQxGBNY5L9rQWEhH6KpWxYUqEcLxsDTAj2On+Wkhr1e3yGAayx3obGMK5JcaUDy+nK2JfkKISKz+PV81Xishd1xTqNT8Xz9Bmubv5mY2z6GA71NU4SMz4Z3AHmi8j5YsfmCsrqbJ1MISfcOnIfyNoOielEmXZCsay/peV+TkDtK/m/ZQyjlbdvua8GNVNjEJ/xjlumzj2irWhfsA+bVQkERrky51UMaAJJo5ApA2ZwEZtA9WE6h7e0GkkMXZ15aONZeOGxuqN/A+uo945Af+eeSiSxlejvDoskRVWJOpc9gWCuI/ikyKq2ZQbes2l2qiENTD5I3AmgpdtWzC6iGk83GWw5PFw/0Gm60BKGUWwANnifE7OlvZ5iyEE8/v2yVlTDvQQQ+xArHteKDCqeBYP5qQyh1sC3+6SeEILUmDeokONMosVoY3wUQHi4Mu+IiU/j9465CgOPnY12YoER0sHmEu8yqqrpYRnrI+nELZf9LTI7dfv9pDAJRN9le2k/+D61QhEn+8L9ahly02S50MN1kI0xLisgoGdCt8bLHUCPApnm6IQfmw8nCKIJGWwuBcrqFgKDHVdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(1076003)(8936002)(8676002)(66946007)(186003)(83380400001)(5660300002)(66574015)(86362001)(54906003)(316002)(16526019)(55016002)(9686003)(4326008)(66556008)(38100700002)(66476007)(7696005)(6916009)(478600001)(52116002)(6506007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Jj1zMnWDVF/aefVwB9tChQx5FqW+enyNBNtq8LBdXRm//koDIa1NBLTHp3?=
 =?iso-8859-1?Q?nf3dKG6AavjEDrxnAtK8erctpgHYBnQTHyJ6pFAbLenH8B8idCvqgfKyCc?=
 =?iso-8859-1?Q?Ww5ot4ULJSfTGsnvbmk49Qu+m6x1HgKtajroH/vxi96Neyf9J/6r7hlgP0?=
 =?iso-8859-1?Q?NgbbjycFKWs9o6SZi3N9PQk7PTHSLFGHsOkQOigrjy9Nv2d/2jFBm79ur8?=
 =?iso-8859-1?Q?kso8rNuipiROhLVCaSGtGTNlllK/Y252+ql/GwDXHy8wQYh0bUbeCr+be5?=
 =?iso-8859-1?Q?aVR4skxDfwrf+uq/ZIr3ljX8Chs9v3zOs/yns/dORqNBzBqz/+myZDtFgc?=
 =?iso-8859-1?Q?IUSm0oCPQLMKA4O56Q/h7f60HBH5q6yJksuhaWAiHa1TX/FtdUpU4zZ079?=
 =?iso-8859-1?Q?IgVTwn3x6aFVVrmb71mVGJO6u13305+20++qLWjMFqKnABlUp9a7+heYoR?=
 =?iso-8859-1?Q?vM1imIAw858qbLq1cXa3bOlhIFge+dvwT29fvoJrzyodf4HkNR3QxuKpXN?=
 =?iso-8859-1?Q?kf2WYYiAB45nD1B+zsdePwArMEf/8+6V+ts9n15LoBpSpq8xjHi1ma/mHi?=
 =?iso-8859-1?Q?g1eouDGIZxSVghUbJBnt+WnFqVxgrUPGKr3+2kAmIC8NB3YmflWVt1gOJ+?=
 =?iso-8859-1?Q?sfVFJqTUlpspnBh5z32X4hEpEPG7fc3cjWsCZxidjgJ9EW4WGcL4vHP79C?=
 =?iso-8859-1?Q?0kg2beoFp16LzD2S6Z/ZK5aTFYem7mpCFHXeoaP4FVTCd3sNoq6qI7jrxx?=
 =?iso-8859-1?Q?T8m9WLjw9ec9aWzkTBJJJFo6hhDFyzNi86jncd1zPAiBRZGlQNsBLkXQIJ?=
 =?iso-8859-1?Q?GLP10Y+eC7MbjtGkIadUs1m2thq2wxjvLvoB8GhQGt1FStNFf2ZWwOA0S8?=
 =?iso-8859-1?Q?RTFyzg6ew/uloAJjrmqXacJIeRwZStX3pcY4ve34ZwATu3JqwCUi68gHY3?=
 =?iso-8859-1?Q?gjFmEda3ilAHHhXzoTc5cp73oCbNycTpznhtEcpjnwtaNODsSDYQTXjnFQ?=
 =?iso-8859-1?Q?BdI90BHze/biHo64lE/VMVqTOUthbTMkEpAusUhg+xzQqM5bWUC/gqv3x6?=
 =?iso-8859-1?Q?1rVv54J1q6MJKPZTlplLAJIO1GRa46ehmhR72fNE8UyIeRAr35CccNqy6W?=
 =?iso-8859-1?Q?I64RzT2gJTuxjqZlfsOWgeH37CPZKUmcEqj1rHUM7924AFDCLl07htiKGg?=
 =?iso-8859-1?Q?ijhj6O16NZUGYiTRKXj2EF3KK6dXKn8E6YIdN7nIAn00tkRgxh/a/AyXFD?=
 =?iso-8859-1?Q?yzBXhfxZWUYORJdScTkGVpoDP8391IlAhwUoqeF6ThHC+Idck0fHN4mBiP?=
 =?iso-8859-1?Q?BRfvavESp8fmZzJ2e4fmVJCCCfSFLLdWrA7k7KYnQBwrCmzsz7Hn25kr6s?=
 =?iso-8859-1?Q?W87EuCfuh7fzxyClS/RkTbHQyn7oOJPw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc03660-6c2a-4a1b-4f11-08d93a9048e4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 23:56:02.3454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUgR42Zu7RQSB8VM0hEh3m7LI37URtCQ5n9o1DGWIp5ZaHkRHnWTZSEk1WLyT3FT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2094
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Bl99kBGlPvvsGcUi-_B6PkrBgHoTULYT
X-Proofpoint-ORIG-GUID: Bl99kBGlPvvsGcUi-_B6PkrBgHoTULYT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106280155
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 01:00:51AM +0200, Toke Høiland-Jørgensen wrote:
> There were a couple of READ_ONCE()-invocations left-over by the devmap RCU
> conversion. Convert these to rcu_dereference() as well to avoid complaints
> from sparse.
> 
> Fixes: 782347b6bcad ("xdp: Add proper __rcu annotations to redirect map entries")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 2f6bd75cd682..7a0c008f751b 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -558,7 +558,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
>  
>  	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>  		for (i = 0; i < map->max_entries; i++) {
> -			dst = READ_ONCE(dtab->netdev_map[i]);
> +			dst = rcu_dereference(dtab->netdev_map[i]);
__dev_map_lookup_elem() uses rcu_dereference_check(dtab->netdev_map[key], rcu_read_lock_bh_held()).
It is not needed here?
