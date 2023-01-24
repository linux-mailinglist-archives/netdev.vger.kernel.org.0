Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AF167974B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjAXMHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjAXMHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:07:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49132330C
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:07:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDEGFbSDBcNsTg295ERffzKEUgxKdFc5ESvrjcdW/TpSHcl5CVes9zgjyaK7mW2qbfCWjHEJLHoOBrV/zqrl2O/8LMtCl4IIcAvqLkCuSvbcRfya5B5NibxBeJBCiHeqEJHU+JTFG1XB5SRjR+ecTGwnXuazuohSycHgODjiIGetLepWL6VmYDG0xBQAVY7z3kM7AfdRSu4ex9Pq68xWnmx84b4AS3Tr6cETEvevuZPT3EKy/mBbFcuc73c7vrUtebPXTi/jW4lrmV0342L7oM0GIU7xt6OOSjE6RLxiOkuHzEusfM5qiBgZ+FlcqV3ZuZjGoPGfPiy2a23vL5dtSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIdIDLP1DUIieWyc1oopuYj1L/b0Xquj+cAOa6uEQGA=;
 b=iyiXrC649ZOEK8sOA40cOLKghoqN4E5km/8yXMm4aeVNte/zrwfgcaCqF/D5R2AxWYX9ynrfswfvqIJdrHfsYwgJcSIvUKiSNdk2DG/hssfz3xn8fmMoj3+yxTNRmFiSZKwuF0yJH7IegWEQ9Dd/HpcQCfMotWKjkRYs+LrRgWehTX0Rlc0K3UmiOkBymX26LEqDlY/u5t6Vy5zGp3QftJInCWrrJOBLQbd/q/krOGINUaWygCGheu1d9i0ps6E+vneQjnHETjusf84Af5RzVxMdaPBIiO8jEeGXYi23192+jg1amGgqZ0aBNZ5bKPeUfGI+OBjM7OaqjlwvgGO5qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIdIDLP1DUIieWyc1oopuYj1L/b0Xquj+cAOa6uEQGA=;
 b=ZZN+WUbp7erIcOaygy0/ZJwS9Yb5rcHgHBiPdVBJ7Nu96Vdj0xc9Y+cGtTlmgRWfVNLwS6g9VfavqLgakCMMBPEtYl01EtBSV4qBtv20gzkLUGsBAUDf2Oni16QtC7HqvcgEyl32O6bbzFBbrCGiJ/qS5+zavscR7qIZKaALLdFSy4QENwcEmQOe7cKyUEaYWAIczM+BUBvAqkh5kRCyft2wz+mDwEFpuBRyYhYQF/xSkHNjYEiqi/z/ilVFslASBwWE5Hhqyq7iiqKTU7Tit9/knPfFvd+UaIBMSkZWFM/OCi1hRj9Bx8gTQTcsTvMNPFHrlS1u0ENDUJsyhqzT1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by LV2PR12MB5943.namprd12.prod.outlook.com (2603:10b6:408:170::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 12:07:17 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 12:07:17 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
In-Reply-To: <20230123143830.60f436ef@kernel.org>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
 <20230117153535.1945554-4-aaptel@nvidia.com>
 <20230119184147.161a8ff4@kernel.org>
 <253o7qprtcq.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
 <20230123143830.60f436ef@kernel.org>
Date:   Tue, 24 Jan 2023 14:07:12 +0200
Message-ID: <253o7qouoen.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|LV2PR12MB5943:EE_
X-MS-Office365-Filtering-Correlation-Id: 46ec43e1-346b-4e1f-8a2a-08dafe0389c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FMNpSaxigQWEKQTACHWhqL9QuPgoe7BxPP7sOE7LnLKak3/Fa2A2QDVNPZwqcWp/vACi7NWd0soKF6JL4O75NRzTrxu37453TpFOT2Vrd0cG8ACiOr4JwDweYOotjYdmONnNFnTL2U8eEe8FGGb9Fx4WAuGPmdcyHdLtjfJZvxkOI9eH/0d4V2F7E9E/n5z8WyvvGv0OLM/Rzb7W9AFvwHTf/bBEujtK5T2opsJnOgomNeVW7ULwLkLn00nvax6qE3jKA4PcRM2LR51duD5VymdVVCSg+SOmABTOOF+zX4A/MA4qIelp/sNRyFfwdE/fXn11jQ+QVC5YNoZbQMUIXSVzgPjZzIaPuEkQv6IstrmN/x6oKISLuClJPQfnPHKgT048WZcolDNm0X3YZppvUPUaStnrFjtV7sgMBfi9kcNsX2N48or+3IkVmUYlWP1ZXWj551qTrZkzw1p6WjRFsRHb2jwDtpf2wwzlLutosRX+iAvUHx4WNzRDRSxG4xXrbO2NgcWDJgcLwmiY3q3yDeInS9Lw2avplOWqFriLfYspnayZFcnFw54ZP+wlV3eJ0W4ZS+R5vYO9hMYieSDvXRI81bzn30q9236ImSAFZlkBtWwMSQ9Cy1Vu9gDlDv8TobC3LtD0ul27mgH/2dQGvr1j54PQpbUNMa6RVqf8LJfSPDvAtk2Ba3dwKkNor4aQFQeftqgTbVvvBzsAjtytHYwooXjNJ1yz6zY/18DhExAGCQrDBzf64ywi9ycyrzDV/aWhkjzur0k9/1As5eYsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199015)(38100700002)(83380400001)(7416002)(41300700001)(86362001)(2906002)(8936002)(5660300002)(4326008)(316002)(6512007)(26005)(9686003)(6916009)(6506007)(8676002)(186003)(6666004)(107886003)(66476007)(66556008)(478600001)(966005)(6486002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lIGsxWbXQPlo9InG6l2UCENBf1XPuZuS/3dD9ZAe9mkUzn/ruf6lZybKCvxT?=
 =?us-ascii?Q?Xk7WI+tKDkMoLht8fHtPSh0+DbadVYXIgUmFR9KdKosLAMOpPp0EbQVUO6PV?=
 =?us-ascii?Q?xm88ggc9pdb6wTBC71BuKg/cTy4yy0PxcpHZXt/3jWb4Igxuhnr2gj68u9Jc?=
 =?us-ascii?Q?ZqFxk68Y0hT6lGYDseekzxWEtJ6PWrp4aTmgPb5BeGhMzULG8krOsgo3P5da?=
 =?us-ascii?Q?UinD2h8dBoijeLq1gjasRBvT08gZlX0GWDkthsfrXvnCCx/uiq+SQ7xQMIdC?=
 =?us-ascii?Q?AfL2JZX2nqhCbbGe/oq4i0Hm/DhILPlr7LrSQpUYom9/ov0VIU1IVNN974yr?=
 =?us-ascii?Q?Y4PceIOnLM6t3res0Z6pDPLOUvU6z2nEpDcfryTq9HJgJuLswye7FvDCxQvo?=
 =?us-ascii?Q?fearfjyxAa18VkIj4bnpC27wnYDH7EHYipc/kaaWLsgj6Rlan1AOUpG68dGt?=
 =?us-ascii?Q?Bo03pOckghk5WNGO5/5oew7Uy2FlUO1zO/emzubg7Py5xf1M8nn8RJZzLZLE?=
 =?us-ascii?Q?+ORRQIYAsit6xjydo1fxcZ9NgOHlByV+IVXa4fCb/6TGRXG5JfGdHqCBtPzt?=
 =?us-ascii?Q?k7+GavwPKPXAb3h6V1Hr7DirQn6KYn0TZdBzguyGT+m4spNBNMQQ346gGKm1?=
 =?us-ascii?Q?yZH+g27o3tISgPI92IBzeynWtLXrop04/MqQi920iUpQ357JUGQHLKl69f8E?=
 =?us-ascii?Q?FMpxqVMFKQPJ1GGx9qq5mTG71UEispjtHr2NUtzh0tkwZUgAXvF1BAB2n0Fc?=
 =?us-ascii?Q?OmldQQcB7F7puWnn1Ggxsxxg6SX6XJNp0QUG5G6feybnrPjxYBoFoQpxagMl?=
 =?us-ascii?Q?hjXE6tl3TEMcMlG9D3RA0m1sfpny1C+dE80WPmf3FdtyheRHXDsSpbj688uK?=
 =?us-ascii?Q?/miN2yVl1arFAgrXIt890WB5FtJeUtRlugqKqfgMFG5CAmF80duG0Q6yoS5Q?=
 =?us-ascii?Q?VPXdp7RcfsbYXonhDq26HAOQa1nZxdRY18FEiQCcLUrQD0QAx/Tfd3eC5o9Z?=
 =?us-ascii?Q?AEdD+meWQkspVQgtjIwdTkGO7LL5ZLSpkory1WAWf06gt5ZuEXxDS8cqz4kZ?=
 =?us-ascii?Q?CO6VQ8X8a7R8cdwWo6Vcv64TqLw1NYbFMKgbY4tJ2ctNTp/fDEK47j9z+b2i?=
 =?us-ascii?Q?fYaRBi+ednYoC98tPsdh3251GgSShcToVhl8opB4rgpmaMrNvgw50IHF3DU+?=
 =?us-ascii?Q?7+cEsHlVESjyS9AgZAmDmP7AEV0fB60+Nu7avCVtHvT94K90+f5Qe1v8wPjB?=
 =?us-ascii?Q?BhETqz6la+u4SoAK1jj7cc/hQAd/7vNvXRSWKRX3TxdOMPrVNEBH665wq7h+?=
 =?us-ascii?Q?zPyVEiWsVWntIxpV5RDQDygZgxnxG1q3ogm8vdXyo+xqjfU0F4G76B8KHQg/?=
 =?us-ascii?Q?bH2tse4wD5XMbPPg9KRz9vr7/8o7KH6EpsQMsf70SavAN7muZl9akbtDQlV5?=
 =?us-ascii?Q?HPvH96TMRZu2TW3GC/vBPM7rYWufCVazlLYMSw9dfUD+tvyUk3yeNQR2i5wZ?=
 =?us-ascii?Q?NUp0tEWjs9QkPWbPIjUNU2vyjkOqr1yLKbYK2cFeTBq/aUmYz2YBXrN9yufm?=
 =?us-ascii?Q?ULziiai+Jsu2xLaA7dmIMPIO6Ohb6VRRXecF7kZD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ec43e1-346b-4e1f-8a2a-08dafe0389c6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 12:07:17.7599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMJTodarJzQE3t7WbUiXQPfzqbslXTf2/AXwtGFa4ttu3gFh5L8W7bX0JZEGyxOK8WlFbVY0jsdYKz5VcveLKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5943
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> But this is not how they should be carried.
>
> The string set is retrieved by a separate command, then you request
> a string based on the attribute ID (global_stringset() + get_string()
> in ethtool CLI code).
>
> That way long running code or code dumping muliple interfaces can load
> strings once and dumps are kept smaller.

As far as I understand, this is what our code is doing, it is aligned
with the feature bits implementation and its usage of bitsets.

Features use netlink bitsets which have a verbose (include literal
strings) and compact form (use stringset ID).

Similarly our stats have a verbose (literal strings) and compact
form (use implicit stringset ID).

In the compact form, since we always return the complete stats list the
string id is implicit: the first stat is string id 0, next one string id
1, and so on. We just return the complete stat array as a blob under
"COMPACT_VALUES".

In ethtool CLI we are using the compact form and calling
global_stringset() + get_string() as you suggested:

	stat_names = global_stringset(ETH_SS_ULP_DDP_STATS,
				      nlctx->ethnl2_socket);

Then later:

	for (i = 0; i < results.stat_count; i++) {
		const char *name = get_string(stat_names, i);
		printf("%s: %lu\n", name, results.stats[i]);
	}

See
https://github.com/aaptel/ethtool/blob/ulp-ddp-v9/netlink/ulp_ddp.c#L186-L189
https://github.com/aaptel/ethtool/blob/ulp-ddp-v9/netlink/ulp_ddp.c#L154-L157

Should we remove the verbose form?

> ethtool commands mostly talk to HW, note that the feature configuration
> (ethtool -k/-K) does not use ethtool ops either.

Ok, we will move all the ops to netdev->ulp_ddp_ops as suggested.

>> > Why does the ethtool API not expose limits?
>>
>> Originally, and before we started adding the netlink interface, we were
>> not planning to include the ability to modify the limits as part of this
>> series.  We do agree that it now makes sense, but we will add, some
>> limits reflect hardware limitations while other could be tweaked by
>> users.  Those limits will be per-device and per-protocol. We will
>> suggest how to design it.
>
> Alright, I was mostly curious, it's not a requirement for initial
> support.

Ok, thanks.
