Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0244857CB2E
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiGUNDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiGUNDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:03:05 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B7664E1F;
        Thu, 21 Jul 2022 06:02:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kL0HLVovDU+Xj/5piOhg+XVgbNUjQJZtYnH5pduqzrEP5rowuCcX3fF8iPUdXMxP7RUlv5dr12JbYQg5EJm2hjkkAM9EKgIdp7R6VkxX4UCw8BHhKcJk21S8rZhKV/q69uAjE37ocMtsk6xI5F1vFzINrm5dB+1uF+BFDzQhu7bjdlhCHUIQ2CX2HdloWqFkUAT08NRspF8OIK75Gr6hI2oSAjsKEXxKY0Hw6SELFMqgvuKnXspV0ULahgjmKpX4yg1G/oSXQna0AtpPbU0k4F6eH5OvC4nb/LYg1jcoCp47RQpkEw8Q47zx3zcf0o+mYVPMKTZ0IYv7Nly4yKl7HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jg+4YuK/SWrYQ6XNPf1cinOCCFFVU0jYgvh29CsWcGA=;
 b=dvK6pLVzSzzHjVHN8IhZNCQIjoZCzeMsJhqWCI9pCQMTH+2E4Tvpp+VoMHV5RVFdGbkn7NYUT1D0p3Er3Rn4eMRqF9ZXAIDotvOaoZqRAygf92iK5bgOInWK9arSHOu8E/6PfHiJfSkLJbNzsdvwLk8tjDsOUXLQq4bazFICslNQpRLX3uKVwe9YBBM52Yd2ZKlmGju2QXVIOQRACqIsb7NOcvlyCEYScSfZG2+/SC4/gDyKEylp3N0W1H936rD861yq9iWNYQrS71IV77MU2amAfIF19Ch4sxSBKd5ds9Rm+q9z1BjZWHRdTPZQYfGP0S4RMm2k8XeKztdkMKCduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jg+4YuK/SWrYQ6XNPf1cinOCCFFVU0jYgvh29CsWcGA=;
 b=AlIWBA00imc5B2H3YEfYWNkgi0E5fse50eYiYvRF50gxEA5IDyI8Oz80dCYHRJT/ZnaxNT1xXBOeh4FP+25n1+3tGTBL1QDJvoHmP/rUmFjz6SPWGGyWH0dw8LcUHxA9Vj2epC0F0ypecRm9T6LDkB/PWV1si8IFiigGY3MT7KrF+BXwd6gnyLeDUGvE+36eXzkdxOnp/Oz3z+iBDSHNq3H1b0YEDjU5GjQx1dcwMPbGaN36z9Nlw9CInbEWaQWH3uyEfhzc/YuaTfyAOPQyFsXxFLGRP3CdoF6TxM+opW+rqvuzDxrmAJ8z9M691xJuQah5uDf9m+URGCo6NEUXyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by PH7PR12MB5832.namprd12.prod.outlook.com (2603:10b6:510:1d7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 13:02:46 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Thu, 21 Jul 2022
 13:02:46 +0000
Date:   Thu, 21 Jul 2022 15:02:42 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v4 2/3] bnxt_en: refactor NVM APIs
Message-ID: <YtlOcl+xcxYvSsbl@nanopsycho>
References: <20220718062032.22426-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-3-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721072121.43648-3-vikas.gupta@broadcom.com>
X-ClientProxiedBy: FR3P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::18) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d70ec77-cc8c-45c5-616f-08da6b194e66
X-MS-TrafficTypeDiagnostic: PH7PR12MB5832:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DfCYNxVIm+erbnjbqyKiQ1fKC2cbjFaUK0UGtVHAb3Bj1BTIhnQYAcO8GovuXxcM7+aA2oURs/yaqBbJqNg/kGtbPDx90HVh4HugGYvycUp01u4AOaLg0svCZVIzg3WYSWfuHJC1i52fBkR4HkhmHC8pZppsAxU7DfojO2B1ToBiXThG0bmqGK9OEY6q2cfQbUWzSlL34gTGHttOIkdZ2qbzko9XUDrQ1Wh9NdkiE04RAZkL6eH6eFLxQN/ICyhNda6El7GF8W1+eFcbuuZLZ2/JWhdTxtjE9eShBGd089CB/4NSZ8hrTIQCo4Oux3xF4yjpELPxrX7nM4mL89KSBIOOepAZJiF3+QvG/ZQ+GLiRpnr4MsLfuzIqzGAq2PQ7uw6E7HXWuhj+o2O2EqsjeJDsIyN63BHhxR1UB3wKXZpZnZMhylPCwwaNyyKoRxVQAvG8UUZFKIQIfL2il5NlScKZGp4DlHUann00GBOMWyVXuaNA2hVCzgOms48A0TTgtJ2/OD+uAOKJC/q+oL8PsT2kXkcDs+8kD6l7USAC5D7X4rX0ONigG9hoGBYe1ZP+AMdhZv41CdTMMI78bMb1za36uoppS+R/tlaEqrOXIPPuIG5HgLsISYOuOTdTBvaa0lp2k0smMH7AL+EV5rmhKwFhPFRnl7NqnF1q9H95s1C2Ok/1/D0K8WhTY7h6l9P7fJzoOuachOQ75dXIVH9owJFSiz5hrPMI7ojT3OrMH9udph3UEjA5zZjYtQ//jh49wfx2CbaMUTSIHTdd4EhTZbzIgwRSsNqPMxlblMpVo8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(39860400002)(396003)(376002)(346002)(9686003)(6506007)(6512007)(26005)(186003)(8936002)(2906002)(5660300002)(7416002)(66556008)(86362001)(6916009)(8676002)(4326008)(6666004)(558084003)(38100700002)(6486002)(41300700001)(33716001)(478600001)(66946007)(316002)(66476007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7n6/FS7/8YPCNvfHwUvXfeE20Zrl3sv5zu+pmQUOzi9pFwNhEJoOto+HwIL7?=
 =?us-ascii?Q?xst3etmabCq44pm44YG7YbaKXzftzJSLGJrXO8QZypj67KLMmadH5Z0jMojN?=
 =?us-ascii?Q?iggddr2yYm7zD6iabWe9ImWeeG5RuRpBaT1e806A+MKrzaRSVGmeg6Ooaqaj?=
 =?us-ascii?Q?QANEFU7MXzx5YQWNIQztDGFd0SnkGC3Yvw2wNRiQB1G0dRAAU738/rhFOXui?=
 =?us-ascii?Q?EMnCcxxd/LzP0XIpoMR224pYbFf+vQWZrovtGHi2prgJFMjpUtukh470JHMp?=
 =?us-ascii?Q?NkDHab9VO8r6lNcufqmfNNMK2Essdz0waTunvX/bCwaL+lZruCD7vY5V9jeP?=
 =?us-ascii?Q?FDKWt/PDhmCj9OkTP7cUBK73UlLazlkS+7eQl07V5wDt/acR5NskOlAIDnG5?=
 =?us-ascii?Q?Thi18A3kPGS2YEy0lRDuTNuw0WQiR144ULEzYld5ybaGkmqxF95+bSZNNIm4?=
 =?us-ascii?Q?5gtIaiEmpqFwe3DZQe976pTSCc1q4DvMM21NfBpYn1BpdpUV4N0hGPytJBY5?=
 =?us-ascii?Q?eNz2O+lYnim6pxdvrVQUI0jIKqKA7664CPGORJr1jEZtuXLGEG7XFvjlIy3T?=
 =?us-ascii?Q?KQAHuzYGj4cfrM9HIAYyzJTTnPTnp7HG2bBYC5g/kvDclhXG4Cr7DnGSjQLx?=
 =?us-ascii?Q?7G12INWeHw97zcZllCNmtEZSNM8jr+GSmeZ/enZtVsa1zhF+q+Kqi4XIsI1d?=
 =?us-ascii?Q?Ks0/G1H7CVMxnlLegnb/hanCNpHZw9Ogvlxo4S3hkOXewxEoOeMQy6Jr8tV8?=
 =?us-ascii?Q?EntwXsY17O2Bn25FaWw/Kb6lg6ZEPvR0CDGvJEHAVIK9+LeoybSlqKTmwlh2?=
 =?us-ascii?Q?YmlNkHj5lwGvbR3zZQZnr4CVdRHx0SfqaGsTxJHP8z8hTpZRpaPmGvFltg7P?=
 =?us-ascii?Q?JAHRTwoxpFcWLbtM25UqDfUsO3xPvp17wJOcKnuZz/2s7GKXNK8bDjd4mJh9?=
 =?us-ascii?Q?7DyhUlJUSC1nM5eSd7QteXDxucWM1bdAy+YyjATecipAbFyIIo7sUonKe/oI?=
 =?us-ascii?Q?LEo+6E2fmewObuzOyXVWaVTWfSdfmR4fx3y+KO/evTEbb/QxX938Sjl9WL0H?=
 =?us-ascii?Q?1/rlc2IPbwBHkUrn4JwiKtvfO7prX1i/zILYfkers7NCZt70SUC1AycRraT+?=
 =?us-ascii?Q?J8HjXeFcz12k/+98LyswQXpGsh/IrNOmAdxRO138F31vEDxG8RfPLKYrXt8e?=
 =?us-ascii?Q?dru8I1/gdvHxFyP0AECPKMgkNHFxtKQRA0JETISN+uwTM47qn5dSPtna72+0?=
 =?us-ascii?Q?F/BEYaFf3BMajpaQfcDZjVMRnESx04bKeklK7lQZmUR+afTHb/FaDCJVC/TR?=
 =?us-ascii?Q?e3cTxlcQzHBJelLfEwl/NGrX1G0tZL4aoIdmut73ZQNxmz64wpMTs5SRN3xY?=
 =?us-ascii?Q?h6wlpyUcxsxKXTZIdiS1yf4cGJWoKJEJsRhSN6AD6LXHO3MtitQa9ruNHZEt?=
 =?us-ascii?Q?c1ZHXms4z9buGIM8ZvLbOYanKqTFmxkH+KkoLGcijfqXIBuuSdKn1jLkA2i9?=
 =?us-ascii?Q?nEwALEmZ8FOJ7afEYWmlkKEvL6QzzD45QNl845qS9rlf3oCo2wPaIZ7nhsYq?=
 =?us-ascii?Q?R1XL+CZZHMH0R/uWdZkzglYIKhCrNuLxnPI37i8B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d70ec77-cc8c-45c5-616f-08da6b194e66
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 13:02:46.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amXm+tbWZkNo+5Mtfq3iMKluZcUJWCO0FtPUhbvHH7jhQc7bvec8vlpagEdy0uPa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5832
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"bnxt_en: refactor NVM APIs" is very odd patch subject name. Please
change it to the summary of what the patch is aiming to do.
