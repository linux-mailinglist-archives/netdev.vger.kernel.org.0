Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912E85065A2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 09:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349270AbiDSHYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 03:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349263AbiDSHYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 03:24:04 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DDD3122E
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 00:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650352881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bxkUi6cAZQFwnf5Jfcf1w3hcvJRQ51wPDfq/5Fq6Cn8=;
        b=K9+5qlI4Y0VWPKkdLDgHs4vZ3p8e2ktFZJ2QFndTZpnnHDpchTuRJnzDXNWPaeMSI7+GPw
        RksC2xsuVQ0wr/z+NxN5RMRG+2/M8U7oI7TB2L5E5fHwbqZlGseXN0DZKTIGxFXUriRv+x
        ZkywPDOWicL2RpWF2ngNEQ20Q8mVfhk=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2055.outbound.protection.outlook.com [104.47.4.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-35-W0a-PhDSNma_zPv_o4gDkg-1; Tue, 19 Apr 2022 09:21:12 +0200
X-MC-Unique: W0a-PhDSNma_zPv_o4gDkg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSiaeb2ePfT4Ql2gppoPOfF0fqDcgydFnXcP7an/hUbVdMNbx2YXjLJB9mZdM4eq695qOIuboT7kjz88c68lGGxHAIg5QCboX2qNyqtYhGD7DlwHojNBYRg+wm5LhnQ3oltr5PlV6MvFoXDFRLy+c/0dzZl828PrIgz7ZR/e5fp8LBJ7VvJQS8aryEJaVfE+n25EFsDsSy5YG5Gp1jfu9sfa/5ey6aQaQUeX6cduDES7S49t1PDeGWD+t0herDZMSIvfqfjs0CF2O/i2D/lcD3dC9or0oL8fkPvJ7HWmB+XjPfyDGT7yTTvt53CT/KszNAXR5HYNwquuNWi1ogx2Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxkUi6cAZQFwnf5Jfcf1w3hcvJRQ51wPDfq/5Fq6Cn8=;
 b=a1v7RwZLheb1geq9SihpMqqJNRLsb72BBpiuOOL1V4A4fXAcrype7tWbeUiBc4o4HAImahX9lLEmnXP3BPI8S3JTXvOwHhbwf81ABgXdcwM+nEPMdvsrrJLoPhYT35Hlx/CfYBGEgcPjOHZRu19+ztaxVt6ywetu595BswIXzTm9NlNVI9DJHJoxkbu3Ll0puWmeqHeS/OO2knPzcl8WyjCHYXE1j3OWITM47a8sY6ZveFIqxeukOrpgLXpXsMFq7kWNBfUj78Y2LVj6nQ9V+mGE85bcIbZ5u4SeOaLi8V4DxBL4C9Eiz7wJ4K7oppDHp9QuRA58H7m/PjFywe7LYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM0PR04MB5091.eurprd04.prod.outlook.com
 (2603:10a6:208:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 07:21:11 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 07:21:10 +0000
Message-ID: <25c1d514-360e-3031-2138-8c6db7761192@suse.com>
Date:   Tue, 19 Apr 2022 09:21:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: cdc-ncm: Move spin_lock_bh() to spin_lock()
Content-Language: en-US
To:     Yunbo Yu <yuyunbo519@gmail.com>, oliver@neukum.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220418141812.1241307-1-yuyunbo519@gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220418141812.1241307-1-yuyunbo519@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0062.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::39) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69e8a85f-ae4d-4233-cf10-08da21d52d9e
X-MS-TrafficTypeDiagnostic: AM0PR04MB5091:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB509122BCDC6756256F116961C7F29@AM0PR04MB5091.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNibpf7cuxULBFmAxU+/189jwzoSYSamBtTyuUBpb30YEdQ0ET3siFcDcdkiharVuJLdAW6IUbU8RSeZ5JJJxlaZLwHa2ZZqOv3SvtW8u87DKWIycp9JBW8psENTNkkzq3Ds2d4dtlMysL6CXdBa48WZmY1bIfKEEe5pgeCltS+Fz60kUUJn4WTMUFKnJCWVqQNen8camJxhZudLsz7oWNk1MJFAS+FkBMWULD6qyiuVbKJvNMcRLACgFZC3JhL6s1svi7aPo0nmdEDfw0aV6DHx5FUHvJtY65qV6/KsUSTXy+I7SXdyWUnlEjshRs2gaL2FrhPafrHOQcFzHQuRGOtvSjvVIidTCIJYaNJ6zHJNn4hGl+zrljG7wCONeILVXV88IDG5xOKZAjNDFcGb2Zmo+rX6TtW60lVM18gLnay4bhjBfzm6ArZCr5aZpai9l8ee3oKl05zUiiKvMNzXug3p2OW6bRNO9ZH3K73ngxmzXOj1aI+2QUjt6EugIhm4u9p4JuEI/6f9t9GEiulImQ2yKMBkkvi4rXJYwihgipOnDYC9H1iHBcPbB+sog6Oa2PbkdoE1Vz+nWDCqzr3OCDjeIORjlWfP2AYTPJdqCunx0mmqBNEjjwZozyLJajn5Fr1SP374sp9skTPmTZmNnzHg6VabS6BioWD6II1XZPUcyoH7yaEvSS5t2k46wQc2303yGXi3CXOhPyH90gAt9NjyZy1ssM2z9uSxYu1LV80=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(83380400001)(508600001)(8676002)(31696002)(86362001)(558084003)(6486002)(36756003)(6512007)(186003)(66476007)(66556008)(66946007)(38100700002)(2616005)(4326008)(5660300002)(6666004)(31686004)(316002)(8936002)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1FyTXU3cGRleTJIeGwrbHo5emhBSE4xNHErM1JuSitaUlg4cVA3M2VuYXhi?=
 =?utf-8?B?UGdlUGg0Q1lQVlZ6dTFCbG9QSlBFMjdFUVMyRjBEcS85TWxRNXQ1Uk9UM3U2?=
 =?utf-8?B?czE1YVRoOG0xTTJlYURaOGtGRmVuWCs5aExiRnJhTmN6YmFZamNMaXArVlNp?=
 =?utf-8?B?Q0dWcVVYTWxiei9IM1FKb2NTaTBFaVJBSStaNHVYWm1Ma3NSZkRneFR0cExS?=
 =?utf-8?B?TTJNTnZCNE5HU050UEdmdnM1azFqQmwwZTB3TnRhVnpQVGxDakNQWG5nZ29q?=
 =?utf-8?B?c0w0SVAzd0dwcEpialFkZlBUSi8vU04xWUhCMCtQTjJQaFRsU3VWVEQ2bnNT?=
 =?utf-8?B?d3VnTkJGSFg1RFM2TlUrVllQcmk5cEs3Y3FwVEtmTmYvZ0pITDlOTVc5WWRs?=
 =?utf-8?B?eE9oS05LMk9ZTndQKzZWNStFNDUyWE5uYUdnbi81M0RHWlhVQ2J6R3VZN0ZP?=
 =?utf-8?B?RVBHQlVlWXdpdnFHMTZjOUV4TWNLeXJ4SFIwVXR5Tjl0d2xhbmRDN2Jnc2cy?=
 =?utf-8?B?QmVOeU1YQkhGbVFPYU1GakpISGFXTlBkbU9iQ0QxM0JRRTVhMHN5OWVmbExO?=
 =?utf-8?B?OE82MDZvcnpGcUVCb3NuOUt4SDRkcWlMVE1QUVFMSk9aTS8rVW5iZXZ2V08z?=
 =?utf-8?B?QzFVaUJFSCtoZTQxaHdQNlZBc0JkeHRxNis0VGVmaTMyMERwalM5WERRL0ll?=
 =?utf-8?B?czhvNkhCTHlQbUsxUS92bVF6ZVRoWHRNTVd5VnVRQk5RL212c3MwTTBhMlhi?=
 =?utf-8?B?SFk0M1FWZm9sZEV5dkRURmhjelRPbGJJYUgvMTY5WFRhVU1XcXpjOU5xNFVL?=
 =?utf-8?B?YlR4QzVnbk9pcG42Yno4YXI2K1ZtWDUyK1M0ZDJGS1dETXczcmd4TUduMzU4?=
 =?utf-8?B?b2h0NWNFQytxVi9teTBZelIrWUVEdlIrd05YZHBOQjhLZlBTUDR0NDA1WGhJ?=
 =?utf-8?B?b1BHSzN2c3FvcmxzUTl2bTJPcDA5UXU0VytZck1EVmpoNVc5QkcvdzNxOHBz?=
 =?utf-8?B?eXpZMmoyNGRjaGFaczFOZ01LV3ZaY1VESzhSMzV1dERYSk16ZDVMaEl1d09M?=
 =?utf-8?B?clY0VTJmaW5ZSW1HZnB0S3lnNm8yMmVxcnBrd045bjZtTHBycklyTW51Q1RI?=
 =?utf-8?B?UnRFZVhHZzdQenpwQ3docC96UnlqWHl1MnAwc293bHFuTlFYMzJOenE2MjhX?=
 =?utf-8?B?SU55NnQvQ1VmU2pHS1ZoT0x4elRWSk02d29BWXk5dmRUTjV3alN4bVh0OG1y?=
 =?utf-8?B?UXR4eDlTREdvbms4RTRsTVMxa01DYmZvSTFEbnAwL1M5akxRR2NJWjg5dHYx?=
 =?utf-8?B?WXdRV1RjaW41Ym5qdVlvajBSNTRNK1dFQWNnSGdOQ3JqVXk3a2FWb2JRbVNj?=
 =?utf-8?B?dWwwc00zLzRYUmJkKzBpQmVKYXV4b3pZakh6SnlFSnZSMXp1eTF4M2xjRkNj?=
 =?utf-8?B?TW9iYmFLays5Q1Bwang0MFFsbTh4aU13aWczMzZudEI4MzZ6VWNHQjJLYWc2?=
 =?utf-8?B?UnpuUkNFcHhzdmZJUkprQnJlaWo5NEhIRzkwSHYycGV3cUI0eDViMllIbjFN?=
 =?utf-8?B?U24xMXZHREQvNWo4djJOT1BEL094dHhlK0lDWVk4dGlRS0RyMzU5d21OQjRT?=
 =?utf-8?B?UjZKK3NSaHpJTWRyRmZyZ29oWFE3RGdVOWduc2tEdTNZUE9sYm5TV0pFdkcw?=
 =?utf-8?B?VHdRQlV0NXYyQ1ovUXJHSGFMQUFJSEgzTjFTY0wzTjFiVDZUM3VDQ1VRZmoy?=
 =?utf-8?B?Z1B2MjBvL1J6RVM4ZHJkT2NyWkZwaDdGcGlDRlFSZ3cxWkxzb3BZbng5bkhI?=
 =?utf-8?B?ZGZ1YTZUQUNoK1NWeGlmMmtqT3lRNDM3TjRvUlRDa2VFNHR3L0Z6cGpBVDRT?=
 =?utf-8?B?S3llZ0htUi8rdSt6OXhGYWc1VDlOMXJxa3MrL09ndExSWGtlZnY2bnJOSmVw?=
 =?utf-8?B?bWphZ244Rk9QVGNRQnZvVlpBVWo4NDdoS2xvMUowRkRodEQwL2ZYMnExbVla?=
 =?utf-8?B?aHdHT0I5RFJZU2xFR1hjNW4xdW55eVNDbE1NaEFyNktRbDFjNXl4TnA4Mmtq?=
 =?utf-8?B?TkZDbEZ5Q0ErRUNLeW1JNnVha202STN1ZE1MRWU5OEhnM0ZsN3ZTWU1sOWth?=
 =?utf-8?B?VWRXdndWS3dSUjQrQmFsQ09TeUhLME9oc0hucHpMMThhWS85d2ZvOEVoZWd0?=
 =?utf-8?B?bzdWbmc1TjQyelc4bVpISVIwSFJnQXR0VzI3K2NDbVVvN0xaU0ZkYjRZSVNT?=
 =?utf-8?B?MElaR3hYWHF0QlhNQmZQb2owQm9jZG5rd2x5Q281OFY2aGo1WGJrQnB3cEhT?=
 =?utf-8?B?YW5ITFdvazNoSk1VRzJrSUo0TnA2aHYwWkFrT21UR2JqZkFlZWJBUm1jWG1L?=
 =?utf-8?Q?+ednBVuOa7WLqK/vq+cWxlJP839Xgjs5ba9IPj0UAmYyV?=
X-MS-Exchange-AntiSpam-MessageData-1: hgUVHm6+ah8SgA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e8a85f-ae4d-4233-cf10-08da21d52d9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 07:21:10.6604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igMbDUsZOrFMIq4kpIfz18eDLutwSIYs826VxkYbsqW+EhbjgEUjwBPlnyH7tbbXIYZScJvarou1RWBvgQ5RWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5091
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.04.22 16:18, Yunbo Yu wrote:
> It is unnecessary to call spin_lock_bh() for you are already in a tasklet.
>
> Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>
>
Acked-by: Oliver Neukum <oneukum@suse.com>

