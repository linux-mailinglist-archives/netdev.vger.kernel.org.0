Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5275257D2F3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiGUSDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUSDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:03:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811088C3F1;
        Thu, 21 Jul 2022 11:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iyd/kjRwlNznSb2cpBOw7PJY3lIrRHnOoI6dy+Q2MM6mpUU45dYsx69YvsyY37oarn944/OkceduJDaI3raVBNIoRT8zJOgG6Sw21Q1b0qJy2S+tJiOBfZFcDBe2fXOS4DcIXlcJQN/APyxxccE5n5g5RZEvk+wLBasTgcAtjdMOKj5RHc+g6ZA8AmCY5fuuXL3+wXflzuhvTHQ/unI3KkdWiqLOfMhTCFRrERKWm3hZG5GderwdvpbmJ+r2s5Ot7j3UTArMDP8wJ0NdsyNpUDHj1KyL3RRyCfhYm1Dlu39wilqvs1peVUK7sszBh198qtKHs4uwM7w31UDyXOPCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJeg10E5HTj9Ow7RKLO41MrVwFOL+C4YPVLconI94As=;
 b=WhTinZMJRnZa2L6EOOECfINReiPLyGgiqY6kcWsfknVOeIiDNnyGKbichpOWv2Cb8kDTC33nubfrqLPuKMGRGK0Qv3l4iOan5y3y3/K0275BQFy2AYMVSdPneuF9SuwEoOwtWcRxsgN17kx+NlB3QbN4XCm58RVCOSL3NWLE8ijerzRGDJYCyl/jGEnqEaBfPesOssACrMas9A7N19acM/zS9vPaP4T2sRd5G+m86iVF7rbBzb6j4lHfOJnb2VdbTUxPOkdb78/nW2JfE/mQHrxq/CdPRoo95OZ0EcVA3w26dcVFH0S7FYygViRo2bJk8VSgVbik0tPxcwjbXL2IcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJeg10E5HTj9Ow7RKLO41MrVwFOL+C4YPVLconI94As=;
 b=me4cyB/DenNgh6nAxWF618TMGpQp7IqKdqrjjxmRzCjtQ/3cHYeCBJJVWBffDAOq21gsYE4TsIVZDsCCOD5IDTwWC0OSY/uXjQQdd/cGSsBP3WJBbcoNbaRdIAGUf6zfn3YA4ojRiMM7OGIjq6yJ0Hb32RstcZHkk5J64WdlHbK0bM3OxOewaaHlv9yXRX41mY6k8nm8q1fKTBMzfZm6ql4IMjLEXWToRrHSjYCNQgaXL+DeeJVA/O85FQjPXqO2CRlC3m0TcNBMOqtkoK57Iu/RkJK/dnXlR7skmBqdhxsb4BabFd4WRHsx1w4XH3YtYX5fDnPFSyj+oHxLFg4+Pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5225.namprd12.prod.outlook.com (2603:10b6:408:11e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 18:03:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 18:03:49 +0000
Date:   Thu, 21 Jul 2022 21:03:43 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, tchornyi@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] mlxsw: use netif_is_any_bridge_port()
 instead of open code
Message-ID: <YtmU//3wdPm28LPl@shredder>
References: <20220721102648.2455-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721102648.2455-1-claudiajkang@gmail.com>
X-ClientProxiedBy: VI1PR0401CA0018.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74b0564f-67b9-434b-5a9b-08da6b435ca7
X-MS-TrafficTypeDiagnostic: BN9PR12MB5225:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lMFR+2BqRuU8q5WwjbQVdnzOvoLee/cyWnp0IizKT4T36R7caNuMt4pmBCKJGJxWE/idMU+HcIwdT53PnUoWxeG3z4RKUtXuA9/OjRiC4+MIvrZjpqbpEXG878C3s1fwM8VLF4n9jc0XsU4VXy+nPIhhbKZLCeKRZmEVeegc3B03nnQBSO2ze09E2QLV+O2jqz8qIMAexVh5Qa1UcM1GUApsI2Hzf0/RGoFiOUhEgRGrsDgS/uEymIh21q0l4pkgFzsEXH31kRmTrce/h76F2DT/xMseIYh3bALeufpyxXdJQ/jGDVg8j2/IeqGolHnAkIVkRRhTRsgvPXRklcQ2CBT6r/NdD5JT2MSYp8NWhV5sCFVv2xa0z4DCXYGnsuE8GJO8RWYO3syEZvW13Twb9a/WUPTJ4A3V64Rawj48UtRupKCJ1YJl4jQw6NCiZAjVk+k2LdCKFQ688X2urDc94W1CnE6Etj1N7F836MOaxQ7E58c86CdjUlducygueBa3EQSlrdV76fxLhde8jJQyUeHZOn7s3EbVa8sVU+9w0OISSn/TNmckfjRe1mH/5LBm9aWyTl9FtyRsI1/YS6la6yD3LonC/ECVkFxQqaoK+S+rRFigh5nTGEbGXaBR2rUXqrysdtT4DeShyLIUQymhBkypIzWwYUWjDZd7ak6wfUFQkxy+MIelkouqc7KeNPk1g8ftLLKV2j5GDAHv4dYBM+u4oUh7z7botSyaJj1qRphUyrpsES6q0jMQVkwagZ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(376002)(136003)(396003)(346002)(39860400002)(9686003)(6916009)(38100700002)(186003)(6512007)(86362001)(6666004)(6506007)(5660300002)(66556008)(8676002)(66946007)(26005)(66476007)(8936002)(33716001)(4326008)(41300700001)(2906002)(478600001)(316002)(4744005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JIyRzNfOW5q/ZeG5wQ/ER9eEJV9krfcC8+d0C7y3rBsXmN3h6/Rtzimj+3c3?=
 =?us-ascii?Q?z0DlH5u7AyZYKQs1ZuwwaHNWKXR0kCB8eX/G2GLTwJTvN26r6i8jaaHPppBj?=
 =?us-ascii?Q?R0WPgv/6mmkUhQTlBhxKUjaCIm9AvWDxysFj9Q03AflLGA+S/Erk2O661WH1?=
 =?us-ascii?Q?8f9NYP71hOgUkEl2Ba11deO7qmihe8uFrXHmdcXrU2JnvHDSiiuYGtlmvijQ?=
 =?us-ascii?Q?eDgcgnU4WafjkKjP48DVnS8PcwcIthMLAJW6zha54ovxp4mRoPpHShSYuiqG?=
 =?us-ascii?Q?oG1dsUbr/6BlXCPxUa8m99Vg/JE6+UC9FCYbQbftttiatrfStK6uNs9Q45tg?=
 =?us-ascii?Q?Kr0oF4XZ5lnhriaWthgI8kBTXUvSCHty4XKB+Ic8ovIvrAsU3LGVL9WJRESX?=
 =?us-ascii?Q?Cz2qYfJEVH/MXncIB4zY8/GyStpLK/y9lZs3iQ7RCG0y0sXFHr27TcaUGaUK?=
 =?us-ascii?Q?WXpd11Mmok28EEZSrjEI1CN06fEztzgiR+WMOmmNjOAg1cWtzTCApzO25dMF?=
 =?us-ascii?Q?BdAFBt7nGS0VWtXP+YTNeXeyzNP+NxgdFf0/9Ue7pnZiIssfUiCoRkWcHngf?=
 =?us-ascii?Q?iuIuekYIztY7WXm4LkT8Prq9fR5rbqDAvi1x67TDtHLdyfZtjg2wRmIOq8va?=
 =?us-ascii?Q?1GIctHR2T/yqjRCkx8Monv0DaRMgGZsSY2cnFiH0AxfASUKs+/zN2wGiak+O?=
 =?us-ascii?Q?CERMaICPdQBuLfPByQmA0+/ViO++PULNNoiAx2xaPmO7RBJTPHv9NgEhdgRT?=
 =?us-ascii?Q?Co73t0uxtiWa6ZqoJUB1H/+JfFNiYibP2I8Fj32d7Z0eIVaOiVA08ggCRMR+?=
 =?us-ascii?Q?5TSZD4HdUZQhA+ugrO2fZW8eMVgibKXTy0maC5JfasQJ/Q7Uo9oIOlZuHX+V?=
 =?us-ascii?Q?f/ML/huUM5Dq3YL/fFU8i3Q77cLPgOi6f7ZVzB0GaCmSKdkdeoqv2alg4n04?=
 =?us-ascii?Q?nK701nXLphuSf23ZAH4yEDqqpISNiHUlbkVye27JoijOcY4IkS+PpQtz4jlG?=
 =?us-ascii?Q?nGHlXaR7I8sg0tPV+1uby0CNFYNjHXYKphazmERZ0lasLNtIeuO+kVX/q+IB?=
 =?us-ascii?Q?WzS0PW76NHKAWEHZ2Qo8PfVyhQRItSMC6nbpEN2aKWftuUn38QF3Exw7Hcey?=
 =?us-ascii?Q?sLWUD46Bj9E5oDPKkBX59DSxpexyjtGpCvJ2M4EYvaFAb/vggqWFc++PMUeE?=
 =?us-ascii?Q?fElSuw81fCMi8tMaVRQBQPY1Hf3/ZMkCjWVIbWL+MCZLfMBll2E2O1kBm9qb?=
 =?us-ascii?Q?Nd6kXqNYM2WWwqkNLVnqrrVWr5CBCd2CuA075dwp8rgOb8ZTyGyaoRcJcvKX?=
 =?us-ascii?Q?tXCY25pz5OIu+Kh0aIvdAr4a0aNFwOx4M+AJg4ho8vteOFXkQeczTFTq8ofV?=
 =?us-ascii?Q?ydjc5AqKQ2H9L+d4i0sIg3eCGSrU12NwGdTi5m1B1AIIGYKqJjYMWFTLCbNm?=
 =?us-ascii?Q?NSW57Fu8f5ZjQu19dMSTsaQuG1XCw55GvTJ/POA8phGEIcIYUB0aztO2rA/C?=
 =?us-ascii?Q?wQL0Qz+3+2J5RGgR0p7Vyyic4G6QszsbajXY93DOTEsCZKr5GLbf7HXV3QLJ?=
 =?us-ascii?Q?pxZYOOxQE5J/7G/xQ9fl2K/clZsuxNNlPsPNzmT+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b0564f-67b9-434b-5a9b-08da6b435ca7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 18:03:48.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDi4nwPEJev831t2Yej314H+BZBDjv4nEWMkvMcqNxoBit122nacZFSPsmYdouU08DBl7hsAtIW0tPQm5uCjrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5225
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 07:26:47PM +0900, Juhee Kang wrote:
> The open code which is netif_is_bridge_port() || netif_is_ovs_port() is
> defined as a new helper function on netdev.h like netif_is_any_bridge_port
> that can check both IFF flags in 1 go. So use netif_is_any_bridge_port()
> function instead of open code. This patch doesn't change logic.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
