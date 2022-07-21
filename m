Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0410557C5CA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiGUIFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiGUIFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:05:00 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2057.outbound.protection.outlook.com [40.107.96.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D557D1CA
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtELN3d33nVA4hjDju7B8WoI4EcEBIdwSy1IMvIZ71dRFO8t/o7UNyOYXOdtBySNmVQJ8/JMcO0mw7cf8jewfbV7ELn1PEpBW6DN2AcFv21Xw8QCPg6J+UuPYLP1kDbAPBfLabR5XRHRsqdWqQnOfo6rh9FW/EC0zNgFM7v45GWC95d8l4mKtN9yyBqD9Mzz9GYQj3t9it5XPWDMbXyc7AXqQwbN4vXk7hf3ZoOEU0eWAnnTYG8mMYKnogLY2Kye0sLpnw0t5QZXkY7tLlpygfFpgxiblQUcfegh9/jbj/LXY3NSiXJgD2rnxyKTbf+URn66x7WX6zWHdb1IiGtQtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhaF8lOXLVoTZSceJpRDKHjHh9iDcXiFfCfPVQ/b86E=;
 b=K7uilbT/RrmrlEUZzOKUJ04U4WKuacVtFYi9641udWmzaVUMi2J2cZGFXbP76QBCjj9PudDWDHOd1ywEREkg9FttCyWS9iTFoPV4ZmKPkyL6jUaA7oAtFtcjU/4bQFOB2aC0qdVSd5UvJmxSWikrslgw2HiVecUQ9luvYZQJuz4afKLcG7T/NiIwHiwj15GvcwSxLR+8vrYq2F13C4hPkpEWs2uKSTFSl7CFnHI5khTtOjNO2mwuj0BqyGKY+nJGZGFJpeR5+zB+Qu67X2PPxERMoRQK+z/G27MV7DLdUcvVmuitdiAwqPDv9TLUja91HCgzlUX3iax+oSUPcWoxbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhaF8lOXLVoTZSceJpRDKHjHh9iDcXiFfCfPVQ/b86E=;
 b=Pzgak+qUsU+3WISB6Si9eyRY2V3lsqgNo9GxbBYOtH73nJ90p6iVvc12aOCXDh+JCs5y7EP8Mf/o2JHjIWvI+K0XENr56FrprXCjkb8UUpBCQcJG6kl2TV88BLNIsx2gFNFvTJQfI9dAhv8MgKjN4FIgj0j5TbuCRgaxuTI478xXknndFYm4nZJ5KhYmaHFGrZvBz66SAjmvpwYGDTSQqyzCwLjuWoHPWfmdZHV6w/mqUpTQZ/qOGwSPjBPpXnMKe1kujoMqliNQ1bbASQ0XfkWF+9dh3c2fFp2n14bI3pFupBm/oLvD7LgL0Z6vAD/avF1zyXFQTbQSO/+mWM8gug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6533.namprd12.prod.outlook.com (2603:10b6:8:c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Thu, 21 Jul
 2022 08:04:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 08:04:57 +0000
Date:   Thu, 21 Jul 2022 11:04:50 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 03/11] mlxsw: core_linecards: Introduce per
 line card auxiliary device
Message-ID: <YtkIorVqiYHt224f@shredder>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-4-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720151234.3873008-4-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR07CA0292.eurprd07.prod.outlook.com
 (2603:10a6:800:130::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83f5de8e-f798-407e-ed90-08da6aefb3a3
X-MS-TrafficTypeDiagnostic: DS0PR12MB6533:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRFFkcAmYXAzDOtdDUz683ogE61fbFRAG/ecpEQllrP1P1yoiG4PkYdbmpMer36qiGxyZidR/2A6K3tQf26VftAtx2vlrWevHK/UgK+wxARI4l/uSqM2Ew2ErnqDZjTe+LwadnLtDIwGa1MJH9sxNQwOR5a0/e56KidZZbQDMnP9Ll5aEav+cIN2/0TGazU9WvLCtiH+fWaImENdPBIH74E2PSYvooeeCeBikVskGShCITvODnIN2mL3tWPaYy2LLWqS6sPDHybYPiAkG9f6SlUF63xLYAsG3kSGRJPKmqR9CpYqck1H/rSQwQKC+HZXxmU9Hw6me0VxeV2pJOSsd5jOq+P2WgLC36unlpUZ8BQ/r2O1pHyXsFndF/hme9IIye6SxdgjAGUl4kyjYTMjIaUk8oRAFtvnrReYXnjcmw1u1q6cS3jRmRhuyR/dLku5CFDIKwGYHhvnwf68eAVFnR8eIwwK1KWsRJHfENg36UpK9buR1tI8W4xAozlFDRUOjU8ITulaV5BB6R/Xmd/hHfooGHcjNyFePSwCAqXjusp9jRBkiGQM+s0yhAwPmRf5WubQcnkwgeyG7SQc5rHvISpmh5yuB8fZrJ6dAwh9m8QZVyG68Z/5nnrjtMeKCTo7mZcjYVLNqGkyQTNyu/3QVt1P7QKaS0xodgKJujEeS2WsHRPG2dlGzQ3ZXoLISK5fC1dD2coL5iy/8dbGySDY4BQgW6t1BaB2P17YDyWAoY8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(6512007)(86362001)(9686003)(478600001)(186003)(6486002)(4744005)(6666004)(41300700001)(6506007)(38100700002)(5660300002)(6916009)(2906002)(33716001)(8936002)(26005)(66946007)(4326008)(83380400001)(8676002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NzKDVLB8AkASuRXtqz/XQSMh5g5YftcOIQUsiH2yZcvbMG1216lHL/e5qzUu?=
 =?us-ascii?Q?gC1McFtqVAH3CasGdLfDGu86pI6640nMinnOHy7nWCQ/UZ78RV+KSNxGi+40?=
 =?us-ascii?Q?VMq+EHP8N8rNHqjTEJLpIDtxv+UG/nVSRtZyhk+d80oygLV5qTmOuA3K8zQe?=
 =?us-ascii?Q?BvkM3afwhh5FfpAjSpF5be60wzpxh/42lnBewoTOpFBn2aiqzlYkBoLkOBpJ?=
 =?us-ascii?Q?FgtPlI8gsZpT924xuHGJSbY27nNkuxej4hVPAPJ5WU+Q8srxKfZqp796LmJI?=
 =?us-ascii?Q?idn94zQCzNfJLlrDo4A1DMycLwIzmp0qB0/ZXzvR+9/POGec/NVNoipNjcR6?=
 =?us-ascii?Q?KmFhIo8d3XrXvScD/37mozX+Nz5uOJ6sFi7cg4chO5MM8ep0ICpqEbYjo970?=
 =?us-ascii?Q?cwcZBOlMi7UaoDpsoLp0x6CJxrEFus4znI7NlZIWlJAjaFnt52A3jRPtuH1U?=
 =?us-ascii?Q?T2rkSs9ztf+noNX1wDeL3CllN/IYhZV5wp9ZSwWsvtSIUgni/+W57u8CTIFM?=
 =?us-ascii?Q?pJQRimgBR9YctppcobtFv+UJtYQRc/LFHleJix3Ks2Ub3wnoy/YhzZt+Ich3?=
 =?us-ascii?Q?wfPdmLwRmRo4WfwmX0xpw2GIVbEtv/otxzI+pPEgFkyzql0WVGj7u7JFS289?=
 =?us-ascii?Q?7KWsjZZrzc5qDN/lVKmFHNiW9QCTsqo+Idb9Yfokoc3eoGDXtwVDXW/aabII?=
 =?us-ascii?Q?GtF/9e/8iYytBJ0bSLrmhCZrU7in38QUXQ8rAU4qvKbJKKdkz2BudzqpBVGd?=
 =?us-ascii?Q?cd3ZohA7pzEFcnXuqwHlws6lu1cUXcby/FcsNa2Nu4ZFKGmg7Xj6JpYz3qsg?=
 =?us-ascii?Q?Nc6Jay/Mf5gdtAgYklLYh31/kweY0M/v6FGcSftqZ6hPsALPbe2cP2HkZNax?=
 =?us-ascii?Q?tzmGef1V+BjMklRgSv6YEM4hI/pDxeEwqRufyeXrhbJRoRdMaZctXBdcHhSZ?=
 =?us-ascii?Q?0X0bqtPLAHSxI/p2S/ma1DSPDHAdXPF8h3tD/TDpwcivdYwNbcIJgKaUWIAY?=
 =?us-ascii?Q?LXJZjuDK43QArZ6ORcdHVCevGlam/kjxLTeTXKEDBCG1a3ZYBowqnAHPZsWK?=
 =?us-ascii?Q?RGBIwvYXcVhjZuQu21hJFpWQKrysz7QkotySfyKBlQOLF+delTjxcHuEWAzT?=
 =?us-ascii?Q?w794m8xlpAxN9gCFgt9/HNU1bO9+EygH67KUYWCpjDna8FCx8MCOKicljnXT?=
 =?us-ascii?Q?HzWs3T5RjISgc3NAevU5zsT/K8xnUUWfob5YwAUWUruQYA1vWBiMIENJWnQ4?=
 =?us-ascii?Q?b1vkaJP+B41QmJQDQsItpFbpCsGpyae4nKFXl+Nh0CcHKYcFp6/5WWCDjhkh?=
 =?us-ascii?Q?vQf+qlqwAv0uipjYL+ZR2T6+XmMcObilitdhZMIHPHy4ACcrhGTIt8kXQafm?=
 =?us-ascii?Q?gmiPo3ukwSXuwrNxaozPHkcCuF6Y93f2h+xz1Junz56jCSA6PcGlFMozbExk?=
 =?us-ascii?Q?BgmjBN3uLxMdBtpcfRusFQ54IHiAIL2nImcw69AS5Cuf2hllnQPVad5md3Of?=
 =?us-ascii?Q?pshkPPmhs120BLANAkuQy7HXMo2i4hgc/vOTLEMj6ILFV3dzjKKm7mFpEtx1?=
 =?us-ascii?Q?/IwJSz1BvEL/4SEn66JHOFwObNZtIQxgJUFeoc/m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f5de8e-f798-407e-ed90-08da6aefb3a3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:04:57.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zT9/oiwcDDuogLSRE9/ZODBBkRzNuODlv2U+a+Id7m77u+BgpZcideb2WWRq4EXmofjzg9gEYRPNWslC12Io2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6533
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 05:12:26PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In order to be eventually able to expose line card gearbox version and
> possibility to flash FW, model the line card as a separate device on
> auxiliary bus.
> 
> Add the auxiliary device for provisioned line card in order to be able
> to expose provisioned line card info over devlink dev info. When the
> line card becomes active, there may be other additional info added to
> the output.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
