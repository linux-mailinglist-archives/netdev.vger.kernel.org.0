Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0BB56A0FF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiGGLUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiGGLUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:20:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DA81EEF6
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgwttGtM/ZdgkrfAnZuQJc/WjbhXoVALDOv8wUSiSTGcArUdCbfB3dk4P95dGDEAnRlHJBAX2TY6AZ/dMIB/Ckt9Hstc9UTScusXqlLlsT61kkWC9mm0NWd0M9iWwpaaqq2pnyk15xHkXBRi8jxs1IB4aZei9STmhFWvxyBPyF9M+C1D6qb0y8cSHDvbTjZQcEDz4VuVJkpoLmkYXUJ1NkSj80yYB6Ltv1R6Ab+kwaAx5odVXFj/gO1IovvWbyIK5DI/RmADVz43nVSU2BtJjPZs60NTdWeWhK2tG/0x2UrDSWOP/6AVw4pCyMFij9ITmdS+me3TbUFBR2cuMo6EkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spOUcVoO6cgKNop3O5Qhdb9Efgd+CjwMPRqvl1ni6dU=;
 b=E+MxXOHJj00ZBH32KNCTYQJA7ISx0aZP1P8/dNcdYb3MpeAP//bbW7DGbxlVCquLo+NjIre/waCNmZolueORsORnopzzmQhNMK63ZUIaLPmvHM7Z41IybsQE6JvLRwxASGiMEPxO3ift6t6JHTgSV9k0dFGoy1jllOLegv792HltxLFC0BmgVpVJy6T/hLpb/VjNh7QMOrbqXTWyf6OjWYo+hFVodB1uCQf2Ak0eHUJYpmA6ZFyxVyOU8grWkkCPMsofNFltie+PsJhGoL/z1YQd/1oBmJKAgeQD2nOmqV/EKHZZSwSTeHwoA/3D1AS81dmD9OkQ40Vdp4m5ZhlzLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spOUcVoO6cgKNop3O5Qhdb9Efgd+CjwMPRqvl1ni6dU=;
 b=jPhJ7CeIf0hI9XgbJxFZqlVy00qMV99ghVP5179K3liwyqrPL2eHaurXuF60y/8CrEcDZpb9k3CjwkYrzWy4kKcatTGRfLXMTLXxdboxFCkWhBTWjBM13mSQL+8JGTbrNBTI21VXXZv4TyzaH054YyWrLRijzFSls/7IopwbUw1M7Tv/3wLR9ugevZ1CbsJT+bTtxPF2Kc2msOR7e1swm3/neFnUqQSMEwi1gFXJdDht35pcIqYm+6orbmvmsArloCJYeyvkHBs8FMooEN8eWgKoJuIqDheZDiBQPmqbvjPRekTAVHf2AukJnmoJ/Zyj6NlDPAlIATNBg0YwPAvB+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BN6PR1201MB0228.namprd12.prod.outlook.com (2603:10b6:405:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Thu, 7 Jul
 2022 11:20:16 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 11:20:16 +0000
Date:   Thu, 7 Jul 2022 13:20:12 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <YsbBbBt+DNvBIU2E@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
 <20220620130426.00818cbf@kernel.org>
 <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
 <20220630111327.3a951e3b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630111327.3a951e3b@kernel.org>
X-ClientProxiedBy: FR0P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::7) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c14e240e-dbd1-4ae4-b426-08da600aab51
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0228:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1miCPa6p/VUftAobpKdlzu1NbYD0boov1tzDaTFkfXRwWpOxwHDEMT4yMK/GsGPqwe97ki8NjKStsaWjqBJIrPMaKrnaBNIEbY4pD+LSKYBFMxz+KqMNu5eXnyCuT/5APWv47xl+7cjbOfpIoB4J6azxktQesQ1dcv9FwaFmiKMn4CYzPda1jQNpqZhBVWUciRHkV+fuojZ/3pqHS9nm0KIdPke5cVPzn9SCq6cohxKh1cW2P8lGPOqSGOjAV8yBw3Xf5NiWpnSUcbFRf3e3mJPYScB8WEOMkbxTy4SewGf5QnQZd50+QYVGQRkWETZ8U/zCgXf6RNE7GZC6oOPUnWWZgjrityHia7d1/49YfoQ/MAO3KkD8vECAja4AMZvW1yMYSpAvCBq7YGhOf4H/W1KAeKGVX2+ubPnsEnROBHJPiJjxt2oZXkMiyDR8sNS3Kt3RnH1C3M34BKvpiqPWaYCmp0WG80XkMju7Lqdg16yM+Lk4898XUujB7GFehif5+v0EpIjyrPQYugJNd85Vw+Tnxc5q7XJcYYN4x+XGYzZHSwRbXXV5oFlKBArIQHjhY3NsORk6B+jdUuC0jfom0MOGDY0DH8qA87na1sXMSc9xvW1IQKVwN2s7ex1tPcQSUWVNtQ/qxUocssdKjL2Xk808MqAn3Zm/oR4ELNFBwN4IxIzcQhrJk7hj2ZPdMQgnKK+Ryr1YfCrRyKrmIfVCZZUiAPK+QzNuSNDSx0VeGCLMzEcRPWcXe0MPv5IC0IZHEy6sRLi2FxsDrSQNHEtF+/5yggihjMMmm2lAXLO4VR1VjESV012CMEjd7uCF636
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(346002)(366004)(39860400002)(136003)(8936002)(8676002)(38100700002)(6512007)(2906002)(9686003)(66946007)(66476007)(478600001)(33716001)(66556008)(6486002)(5660300002)(86362001)(4326008)(186003)(316002)(26005)(6916009)(83380400001)(6666004)(6506007)(41300700001)(54906003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?igFBGZK1P9HSzrmX2Li+WcRwhsOo6ZS5AG6iiYF+exUfHbovAdT2SoMya1ae?=
 =?us-ascii?Q?b3ehvW3Azfd9AAi51YOhsZ7Z2EcnshNNhUcSbjLkLtvoYme4XSwJb25pa2hG?=
 =?us-ascii?Q?hZlmcUSuUOMSJnlQwNsHQvDbRQErvdUnSF26LGkerw42VFW1wlvJ9BM7Zopt?=
 =?us-ascii?Q?cPa2RUDWZDhNvR1TUd4aFZOxpOk3HjE43wirK2Dyqr0fn5Uu/I1jWVan8AQj?=
 =?us-ascii?Q?aixvQ3l8BEMGSKVshBj07PGoCp8zfTpP8POIKN229KSLuflSbjEJXWLp7GVN?=
 =?us-ascii?Q?ixefbmDJx3MCSRxZZqJRhx3lhxWNsKdjPoMvshSS3zqVoS7THwokRfqHmSPb?=
 =?us-ascii?Q?D55tcpVcV3g0vLHMelgCs9qKK5WT1aBYo7wS1JRNdUcVDzoOl8WrozEqKHPA?=
 =?us-ascii?Q?BL/+eM9yzL7K2lvVsGT+t05mazeHuqcg7GHjBanSL2rQUxm86BQY+mvuIWwa?=
 =?us-ascii?Q?h1JUT591vgoOC04ljdraxdfWJJKzuSyj3qIVoPm5oAhS/RGVzuNdO1WU7bVc?=
 =?us-ascii?Q?EKQTEir66imNohZybOcCPQGlvg+7oepVEU0XPWQF9YCPayP8pHjOapfXsKzH?=
 =?us-ascii?Q?s8fR1vJYewi8BSYHRvjHn1KsO0AUqvo97VsXJx5coVWXcvj9Afe5lePsSTTG?=
 =?us-ascii?Q?cubMInk12VsXcPiLgn1kA1svJfpCZnU/CB4XlUfv6x7nH0KdPnmRP+wYwB7M?=
 =?us-ascii?Q?SKf7CLRwfbkA0AWXIPjD0Kcj1EqfgnpKwJXsUoZZIfg21vVtrs2ct9/1xqLA?=
 =?us-ascii?Q?1EwiqYEdmonz9dV0rR0h9adAJrHr+hrNBwc/utIo8YA6KCzY1lxIc39V3vN1?=
 =?us-ascii?Q?fKBS1GuEDOgDtEV3awntTCtmSGxupccm7DKOltbx/EwpBmo7dzjY6qRMpuLq?=
 =?us-ascii?Q?UxKB/Jq5vc7ccxbfhjNY9LqN3OOUGQMQrjfKSg6SRbdlzraOu2i3dXruW1r5?=
 =?us-ascii?Q?HzTEFZ8WygbV7h+raogkrnTjlUzTfyfWqeTDgQZJKAtEt8nnY1k2VyfFLaLW?=
 =?us-ascii?Q?HitkLJlf6QebE2oErNatOYr4YHuGDGn2e6LJFH42VRNzZlw3ZgPekib2c1rQ?=
 =?us-ascii?Q?eB+X35euMGHYaXwQQP3ab8coA07AIDAQ2/CSeaIHR07VlRf+v0jJNYrMURZO?=
 =?us-ascii?Q?kzWDF0aDnjhvJ51uzv9w3+j4pyik3fFUUX7RJP7zL1J8xB6c23BPsgQZkFN5?=
 =?us-ascii?Q?+a4nXQI+28yIdAkcDRp8QWAnVl7rizxhDl44bGpfeMXoc5bf7aTzBZUyR5pM?=
 =?us-ascii?Q?FkJADPzMvOfiE2J8jkeUNWneZ/apkNuBSwfoKHn35sMs1jXu5wTTFFXVv5nM?=
 =?us-ascii?Q?nH8/eSTJz7KwsKXmrAhdFFI1QgjDxApWVUYFsQJxC7M3EidsIBHXlQ5GOA4p?=
 =?us-ascii?Q?cuhObnqmES94FxWcNrH0dMT3irx5ahAygcSn3RHChcNyuMCUxU4bUpBouBb0?=
 =?us-ascii?Q?ZmWCNjElAmNTAX+uUv9ytpG1sC4N45k6zWEuXY4mbz105Bh6VGFgwm7mdXZu?=
 =?us-ascii?Q?Qyrr5Pkq1P+d0QWjsj15WB+CFpSsnkSUcHC/dg2zns92zNQ5TMWoAQOMFb0f?=
 =?us-ascii?Q?jacextJ6LuXEimuT2Xc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c14e240e-dbd1-4ae4-b426-08da600aab51
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 11:20:16.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hnTb5coPLzLCgLXYQKmAokrOYLfIzNzmRHSa4d9NwAkYBniYUm+MuYhfTsQvSrv8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0228
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 30, 2022 at 08:13:27PM CEST, kuba@kernel.org wrote:
>On Thu, 30 Jun 2022 17:27:08 +0200 Dima Chumak wrote:
>> I've re-read more carefully the cover letter of the original 'devlink:
>> rate objects API' series by Dmytro Linkin, off of which I based my
>> patches, though my understanding still might be incomplete/incorrect
>> here.
>> 
>> It seems that TC, being ingress only, doesn't cover the full spectrum of
>> rate-limiting that's possible to achieve with devlink. TC works only
>> with representors and doesn't allow to configure "the other side of the
>> wire", where devlink port function seems to be a better match as it
>> connects directly to a VF.
>
>Right, but you are adding Rx and Tx now, IIUC, so you're venturing into
>the same "side of the wire" where tc lives.

Wait. Lets draw the basic picture of "the wire":

--------------------------+                +--------------------------
eswitch representor netdev|=====thewire====|function (vf/sf/whatever
--------------------------+                +-------------------------

Now the rate setting Dima is talking about, it is the configuration of
the "function" side. Setting the rate is limitting the "function" TX/RX
Note that this function could be of any type - netdev, rdma, vdpa, nvme.
Configuring the TX/RX rate (including groupping) applies to all of
these.

Putting the configuration on the eswitch representor does not fit:
1) it is configuring the other side of the wire, the configuration
   should be of the eswitch port. Configuring the other side is
   confusing and misleading. For the purpose of configuring the
   "function" side, we introduced "port function" object in devlink.
2) it is confuguring netdev/ethernet however the confuguration applies
   to all queues of the function.


>
>> Also, for the existing devlink-rate mechanism of VF grouping, it would be
>> challenging to achieve similar functionality with TC flows, as groups don't
>> have a net device instance where flows can be attached.
>
>You can share actions in TC. The hierarchical aspects may be more
>limited, not sure.
>
>> I want to apologize in case my proposed changes have come across as
>> being bluntly ignoring some of the pre-established agreements and
>> understandings of TC / devlink responsibility separation, it wasn't
>> intentional.
>
>Apologies, TBH I thought you're the same person I was arguing with last
>time.
>
>My objective is to avoid having multiple user space interfaces which 
>drivers have to (a) support and (b) reconcile. We already have the VF 
>rate limits in ip link, and in TC (which I believe is used by OvS
>offload). 
>
>I presume you have a mlx5 implementation ready, so how do you reconcile
>those 3 APIs?
