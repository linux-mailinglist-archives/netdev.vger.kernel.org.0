Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413E36E60CF
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDRMMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjDRMLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:11:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A3E1BB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:11:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNxR9yinJOIDxaVofqYmHFUBGu5J1lAdUsphHZUKJnp08PJgiDhMxE6R3gxoJElyvd+sdo4Gl0BTKK8D0U0nnz0T++P8a0XPIHyXiI1V8sw01fLVz0X1dsPqpZ7aUFI7lgHQCr2FJAa6X2augfwHxwzokTQr2bU/osJoyA53h9mzF9QUwidCHKm+4WSfXPUBj5Bof3gCNAOkNn1192kO3jZK63Heu0XMz+ZDbzYFha/Z5+0aONOjPhhDEIjHENqBuquvL6sb1nTsgNQF1mgpNNqIighlOMz0hLz6hygu0WZSg3A1M2H4QLLtCbUJt44shXboWj8LWloUhgRkFbeWDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BOXX7qSCtB1BO7gbUAuevFBuF3Jht6wpyuz88BV41k=;
 b=FNY4GiBiNxhh7Anq0sPgCKBulx23qjI0vIxe2/GspsBkQivG3qmRRfg0DAdKp04F9QfjdmXe9HpOyX87jZpC2FXjR/oP6GU4Vqa4qZTffWVe7RQMNBQ31+J0OvRLlE123gj/cmTtjtepLG2DqeJAOwI6KbkROpwaZcNkZNJFdv+i8sYiab2k0wPOXq+gkD6FNWNwNWGIr5FSS4017iBg+hqSsWfDqPBa6WxYAu9eBKH3NUbtQmHfL7oxpIOPXZMHohwX3wIJPggBT4quYMRmR5Laf6zvO0KF4mhHC4mRKaBvsMjHhK1HfVxdBB7MV5/NnxZoQPzOknhqMHlBk48hMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BOXX7qSCtB1BO7gbUAuevFBuF3Jht6wpyuz88BV41k=;
 b=MD2Zv6MGFf/qaW01O1lDYiDH5WG/GMai+3hoT8w+BHTtAOlfEmzOyUxo4gUm5zobU/0ZCLOc8i5lJ637VVgrlHO/TBt9qeLSSbKcRqNcabKPyRpll3QR/lbRhs1ZCmLZcaQGM2IOlFYKRAjXx6IheZX3zF52Y119QGCaCOdeOxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5023.namprd13.prod.outlook.com (2603:10b6:806:189::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:11:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:11:39 +0000
Date:   Tue, 18 Apr 2023 14:11:33 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     William Tu <u9012063@gmail.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
        maciej.fijalkowski@intel.com, witu@nvidia.com,
        horatiu.vultur@microchip.com, error27@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH RFC net-next v20] vmxnet3: Add XDP support.
Message-ID: <ZD6I9eTJWS1KWL3R@corigine.com>
References: <20230412234434.91819-1-witu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412234434.91819-1-witu@nvidia.com>
X-ClientProxiedBy: AS4P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5023:EE_
X-MS-Office365-Filtering-Correlation-Id: d8be8110-e3d7-4d32-0825-08db4006105a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LF5gwSlFPgA0iwMOvlnzspRIUXwIK/73MvgccxfyxR2OfU9nPCeS3uOsel5DPi8+BZPrzQtG5I3LmyXkUm6TbIFZsTaGSHmcDAsKL2Aiwsg4vfw+RFixN70hgBXHPOV/yU08ZlrF7eB3QuADJlXgXPHCk/drsYD+N1frdsJk8t7G9QGalWm0ruqMAA4bN+2ljeuwmpJaWEqEM2ymtteKs2yyUjcBg7ezhF2AIrfrRQYNOQ7x1FCBqJYfBxCThyfGRY6SJ28gMB8DaR/ly5gWTq61bg/r3I8ZIClKQPs9fPyP5Act2YRAXeE5jvJUK/gfl409R9vthlyJ1T7X0cxTbA427v34AE1TQjfTqnGeG/XUexZMmYvJZh7UzdBzdoVygCnqd9n4zekyoX8F9AZQUZdPWN2qLpC95Zjj83UDZEuajqhSLlyZq4fk0iqD0H1rEcItAgvS/swEdGjQwMx5c2WJ+gGiPKWLxR1dn1F38rldTF+pdkRxpcPE3IHbwi7IpETvqdarY4G2T6yuV6Sy65aXe7YNUs1HMrKEAMKmNdnRM5dbREg92ukFdxZ/huNV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39840400004)(366004)(136003)(451199021)(4326008)(6916009)(316002)(66946007)(66556008)(66476007)(6486002)(8936002)(6666004)(5660300002)(41300700001)(8676002)(478600001)(7416002)(44832011)(86362001)(2906002)(36756003)(38100700002)(2616005)(186003)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oKKSyPo++Sy4qTb5oThXu15mckdDoAB2WgHabW4v/YBaPSL4CpXQM6iKOxg6?=
 =?us-ascii?Q?es9dUmy3HUIOmQwX3jMhvvtWhcVm6C2CytIvURwZV3SYNLwG7MFlmCUfB4FL?=
 =?us-ascii?Q?cs07J697wa+vzKihfzeXGDAjdCpV3ClFm6YCGvTqwcoSBwWq1KHC9yIq+dNr?=
 =?us-ascii?Q?yAweTc4WpjIYo6lFdpI2MBY87urLj3wIyyzRAgKhx4S3mrcU1gir5TrqZOuW?=
 =?us-ascii?Q?NyUuEG/vIjYy4GUxzqcuDBAOXvPQ+iKtlTcCv6vIEUhk5CI7rIC37b8WhY29?=
 =?us-ascii?Q?AopddQMNpuUCRSUSeIKUFzyzjbGQww430tz0DxT5wAJ8GGIkb7tzPRn6aBhR?=
 =?us-ascii?Q?kUR9WJXOyRakkd7h8OSOlPdaUhuzJ5duQvSnuSi9FIEgoKi3p++6CVtyuIns?=
 =?us-ascii?Q?hpTl+JcWMiL+uEMSdbUcXyynLk3fVtVYlKhkjArC8jiUkrZ+ATcKQV8UHIXQ?=
 =?us-ascii?Q?Bdlh1LUic0/nR3aeuSRrHcW02MTJNfSlNtC7/RU1aDzXkP20V2QlKIdpqDvN?=
 =?us-ascii?Q?cbuvixvPc3L8O3fUFVRibFn35ikHe8KoASjjRiQjKvsJiylYMi+EIFk+1bqk?=
 =?us-ascii?Q?0aWFSroSWg6rBjgl9I20lyFh16FN3cj7Sl7QHFKp4frGVj7lcqvZZB2HuV9t?=
 =?us-ascii?Q?SLUfj2KN6K///2aq+9NG90pAaVZ5YPEltmAp7AnjFQVCj3kgFRUUZD3dp7eS?=
 =?us-ascii?Q?1dwBnFOENsyt0TT4lr6mSi80BBSHjyyELHNaOO+VTnhXIBOYsplR0rBbuGui?=
 =?us-ascii?Q?nGltQ9UfZzw4c45Pea581R/GDOeExnFqw+FpIWGj3Nwyc7rXcwjzruKf/Y7E?=
 =?us-ascii?Q?f967XEyGxb9MNGeA91Z36LKEnsRHKN0V2W15MhqUW7RH0MdY1L/2w7+awndN?=
 =?us-ascii?Q?KybJjaBSN859Fb0r/hLaFNGIhxh7QNfc4tiYv/xg70srvmSzVLUtN4GBT0gU?=
 =?us-ascii?Q?lA4W11RpPMVGE4u6Vzd9CGgkbY10aT0nbX1mEhTDvoIt7sm8INNyXBpCTDGx?=
 =?us-ascii?Q?Q8wXTGdZl7rEh9TxqdK8hPnhcml7l7ENGfETiSFe+JtrUONCzfAwpXYEMWSd?=
 =?us-ascii?Q?1kITxCyqg+rlwR8yM5yRF5xLnIr1sk04HeWIT2ez1814ZZu0LqAfmfbp7sm6?=
 =?us-ascii?Q?xOH3BxPbEWj9kuYk7utQN8u30aT+Oap1y2PxbRLJLBhDcmh3bWm9s5eHpwar?=
 =?us-ascii?Q?7HK4dD03GlySmhMTsGijYOnGQJ40BB7yone48jqQaCni+kcYa98BD0cTVSb2?=
 =?us-ascii?Q?IbbLWbgmP985GM2V+4d+X7/EaMz6IVVG+2iZUVwSg1sikplbXi8rpYfkBm9R?=
 =?us-ascii?Q?0aHoPaerTYhjDB3GjgDuXg+z7xpCzpbEw04i0cm+mAciXJOhA8zKpal9KXOh?=
 =?us-ascii?Q?0Q5QCYErR0N2Za2aH9jdZL3dPbUObhn8+usEAaAUtTqi2NTzAm5OBxBKY/rS?=
 =?us-ascii?Q?tZ8zl4pJlPHK01CcfusKzmNf8/srCV7mN1igiD4rHeKhRnssU46UIm3DN7WO?=
 =?us-ascii?Q?+fek/08SawBbXobpU7g4ZfkWOWvatVyV5JGGv5mnZAcMgsH0jxtOTHkse/mf?=
 =?us-ascii?Q?FDw0mNzLNTApiGlTCIRICEm4FxncAB/6EfpcCIYpSpLOrXStYBeOLyPokLfh?=
 =?us-ascii?Q?xhPaFzPZEN17u8hb9hL1UBHDgCemQ76vcNOUu9aPkEJ5+7QiEsHcRGbmmgqr?=
 =?us-ascii?Q?BhF+OA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8be8110-e3d7-4d32-0825-08db4006105a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:11:39.3780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1iwYnQID0LBtivzY9IIyM7j2B/78OEy7bgONEOxDO1w76RJV0Uw9L2hp2zKvS907BMqOwmuDaNjumeu4VobUB+xwrL5qyc7JoetPgaQDOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5023
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 04:44:34PM -0700, William Tu wrote:
> From: William Tu <u9012063@gmail.com>
> 
> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

...

> +/* ndo_xdp_xmit */
> +int
> +vmxnet3_xdp_xmit(struct net_device *dev,
> +		 int n, struct xdp_frame **frames, u32 flags)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(dev);
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int i;
> +
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> +		return -ENETDOWN;
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> +		return -EINVAL;
> +
> +	tq = vmxnet3_xdp_get_tq(adapter);
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);

Hi William,

gcc-12 with W=1 tells me that:

 drivers/net/vmxnet3/vmxnet3_xdp.c:228:23: warning: variable 'nq' set but not used [-Wunused-but-set-variable]
         struct netdev_queue *nq;

> +
> +	for (i = 0; i < n; i++) {
> +		if (vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true)) {
> +			tq->stats.xdp_xmit_err++;
> +			break;
> +		}
> +	}
> +	tq->stats.xdp_xmit += i;
> +
> +	return i;
> +}

...
