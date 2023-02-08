Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F8A68EE13
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBHLho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjBHLhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:37:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20713.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::713])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D6145F6F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:37:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfEKsv/whhV5QyS0u9kH+4uonISXP5bFNQP2viZ10EowXEDNdRrvC+u75q+KvdSy+ahvh15l8DwD6iivMFyNN7cxh/IrJThBarMajpLm3/IXtQXGpjdtcpFhv2gDWPGdnyy1nAq4nj9mwraqdIF7xASrr8TeWM1zw7hi1oDqtpYCN/KTJxE+3WuPfxAJHq1iIUr5Kn+tsTmFK+bHwRArVBZq2NK2e6Dv1UBtVv2PACzIwkrKPLans8GEQXOEHtZFs1IghFc2UnM7EKPtn4Z5wV3V/Yt4DG86ow2kFdS1x9XA6/ZTe6TuAVIf7U/um9iYqSFs6gPtIee6uw1U7N8p9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZaa/9nRGoJus3YmHk+hyP8rDiw5ZBDwR8A9UvK2dQw=;
 b=JpzaQSLK0ZANDzIGT1F8/VvfjFq6oR96jBV407pc9eTFma9CNeTxZ/e3GKtuJSemZUJDj/7kb7boE9c+rMmibOCz8zGScWEUQ+/JWUaQBDE+JRJZITeqCZMplc9b5VvYdy26W8OTTrn4Ujd+TfRyLfHfKiKWoAIoWRZJ8/5ikkqXe4vhr1o7ngoqv7vBHk9voVFiLtONXMtmcDsqh3X6XRxn7eVbabuKr86CfC0QchTzueZCXzy5fcxfwF8P3l1/IA40+fy2RksukHfr66sbw+7WWGGljQVz1w5PdXZvx1fCW0v8PA/aSWWXMR/GxyGUCP1PmVA5g24qceVgt0s36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZaa/9nRGoJus3YmHk+hyP8rDiw5ZBDwR8A9UvK2dQw=;
 b=KmyPzgChfE9VNjALP6MJ9SU8DI/cM/Riau39o7cU9P70iaeuHLnqqlJrAwCF2Gej5Q/XKrrG/hqnO873sxhrLdi3DS2ez9yz3E8irCWM+/UAPOu1kxHtEl35rFRwLmp2Oz3mwNrRX8ZqUtGth5SQYPoEsKKXwskLgA+AiuYTJQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 11:37:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:37:38 +0000
Date:   Wed, 8 Feb 2023 12:37:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v4 net-next 1/4] net-sysctl: factor out cpumask parsing
 helper
Message-ID: <Y+OJeyIey9DvsKcy@corigine.com>
References: <cover.1675789134.git.pabeni@redhat.com>
 <8e69455b0e3bc339ca6c00f04fe86660e2aad58b.1675789134.git.pabeni@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e69455b0e3bc339ca6c00f04fe86660e2aad58b.1675789134.git.pabeni@redhat.com>
X-ClientProxiedBy: AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aefaf24-7715-4495-0e79-08db09c8e10e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGzEDArLc7qiXWtVg52fbgOyY+Hqx9SX5wMGhcDTj4BSeBAXRCGQsnfB7bACfIbh8G3YPD9fmjrF+GEcINdeor4e0usVSehPSYsDs0BgVhV5ST7gCztvGia+aY5cdWKDjlpcBtM0mXAMiyk8YG+52s3hse4TWrtV0lbuArpE6OFYecuDxBJc+vXjaFDQHLcNrI3X/2HCGRT9R3pydcvdNXdnE52LF82zNruNhpr1ohFB5RzunJ2CLuOl3LSwl1Mbn4OnZhNHEqj0xj1ep5VhznghD2wIBRwAPLe2gwQXdD/O7eI8PBq9TsR+wc8NS7ajSAW2nJ1oJNmUa2o9nQi7ejPBXnOpzrn0ZVG2128OtvU3IzE+3ROhJzoaaMQqix7yC3d4mvm9hk98mSC1msYpEu1wl8nMglHC6auLwgoKq+wFqAsIHAHH5VfLiaVleGIgJEs7EvmSrV98IjM1ZQaleZibn68xvr1aBsyhnSo8TspwEAbg4nDHV/Z4S8WmVz84iGiOJBI4dgiI6D6FxcJOneA+z+rhD6R8LIJLYfPBNnMrzWANRNXxCtEp+TJWlwMx1XNga76DHEwBPrpL/MirUjLTqV7Da+RpNNeILbSZmPSePNq6Hd234dJPnrA6YbwjRHX6ue8PmNzBHmq92JEZH459G8GaI49E59bREfWv4aKxA0Kl/mXyWtV32hKtVO2G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199018)(38100700002)(6506007)(41300700001)(6512007)(186003)(8936002)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(2616005)(5660300002)(44832011)(36756003)(4744005)(316002)(86362001)(54906003)(6666004)(478600001)(6486002)(83380400001)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UQc8Ramidt0OUBADmh6gtW+86lfcimiE9SzQZoFvhigst2oGnVfwiyzX+EFZ?=
 =?us-ascii?Q?ek73dutxFU+UsvxTWqewQTcijWrg+5mwOXzR+E03js7wfBBVVbYYUIIWfRMW?=
 =?us-ascii?Q?SFEDq5DTstwTJSfmRZM+lhTFmzQk7sNVIRRmHAPviFks5MRYltkUq0Um9XDp?=
 =?us-ascii?Q?T2ap5BSzOSY4t14+s19Eeyoz3LS4m8ZlS+iIFEEmjcVzHQofO6pHUsPmjDau?=
 =?us-ascii?Q?2+umY6vj3oC+nB2eO/8zSjMLnisFEd3wBg6PpOjqsaPbCzVlxWUv90OuDW6Q?=
 =?us-ascii?Q?AWsKxIlKNxHg9afotn84sNi4ZnkPOPYhbUiiQgqLMdP6x4IQ0MbpmAA0EO/2?=
 =?us-ascii?Q?U6iuWW8eNEgfzDWWHQ6sps3q8bllOADt0TIsgbNq04s0QSlWo+zJP4VY/W08?=
 =?us-ascii?Q?VOfq1ZFY/yurw61d7ujCpnK98DWuBqLrfOuykJf5ypB5NqwMc7hasvXxfN9P?=
 =?us-ascii?Q?0kCPFPCQW7+PtIdmlZ9FP1btVldWG6LFByZerGj9uhgkpWUIIIyd53/mn4df?=
 =?us-ascii?Q?KgtA1ZCKyhrDNmfIh5+lnUW8kXBVqP93YLRZDBEnom+z3nNBG58N9fshdF0T?=
 =?us-ascii?Q?VyJGt2vSiuS69fRa5+unPFa0gtU1Yw0xFlz4Q8SMrpwDGzVsTA6OtnMFV2Eg?=
 =?us-ascii?Q?VLaQcX8YshY0pv5qnfUe7Y8Hi2SOxkXxYvN8MsJ2VapirxZ0lwZ4r3MGYgg7?=
 =?us-ascii?Q?God7N5/SrdMlRXT39kFI6PfIpgld/s64x/g11DHieS2GINBiESTwlgRHyu2S?=
 =?us-ascii?Q?l7ahqtKHAX8oAfvxizx8oEo7JpGNbLrmyxjs26r/mdBH7eDqyhI8B1v95asA?=
 =?us-ascii?Q?AmHQQ5WqWAgySQzhN4H8rNLn5Z44oUw0Ien92Qlk4+t/fi/zw1+FFaKZoqq1?=
 =?us-ascii?Q?Xbi6l3kMh3cg6/mseLt5vPwibPf6KouyWOYDPYru1HbrXYJrXNyCm/YV3d+u?=
 =?us-ascii?Q?UmGmpLFpjtOnPn2QVDkRu3kAqp6F6NhnHWoMbeQqMo7EO5HqV+r8ePgf4rcg?=
 =?us-ascii?Q?MzdelzCSUfivSY/jyl06OUPnyBP8tyOyhsjA1sxFhYAb9URX3DI/2pT+QgWJ?=
 =?us-ascii?Q?TTn8jQDMNZnQDE/Y4qvIruHIRUYODd2QFaQNuP0IQymqeeyDss/r+Bh9f0i2?=
 =?us-ascii?Q?djSAsa5G0xKnOTQ3DJmGJoSvNHhKLtO+WfbuMs0J6zVHR4DaUeW/zAVGBCfQ?=
 =?us-ascii?Q?rMIKcp1mwf2QQpHLeRRICcRcDS7dbSwrigpYZdsrymBTPD3F78TvS2M3xSXL?=
 =?us-ascii?Q?DFwNIFCSkcVJQtfnrijNpmsR9+CVRwLls27OMtUt9b5A5M2++nk9yuL1hKT/?=
 =?us-ascii?Q?9lI83JXybKMmSGVrisaZXps02EE3OsHUtPeqBSVfeJishp/t+VGMo5JlCehC?=
 =?us-ascii?Q?wiB/HD0isD2FDIn2nUS6xnFvLqaMrYdNFwAXoEvAUi+FsP8ATN1cxaDfsapx?=
 =?us-ascii?Q?siak8IEnI25V7N1WlsuwlWxtxFyljBvtPbQ1KdkVWDVoV1+Mf7GY1sbB7AQ2?=
 =?us-ascii?Q?o71B6H7Msl0NERh0FNsc9Fui5w3RtglWKPweq/I1fESzs2BPg7CTNiu606yY?=
 =?us-ascii?Q?xfjVlFNu/SwwA2E4mfzpzfS88lvuZ0YfMxuRCJlMA6/WlOadcSZEAHvmbB2b?=
 =?us-ascii?Q?IdQHipjCNQklel402ffFQGjCkTPbXz5zqfWTfCrGEXrs3nLZqDaZK/X+paDi?=
 =?us-ascii?Q?CKIhbw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aefaf24-7715-4495-0e79-08db09c8e10e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:37:37.8971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QT/TRrtViggA7O/Q+92D5XeNur7UeUAWhNZIkoRCHtr3DgemVpyF/NHtnlJktZmcXEDtqPFpNMvsu259Y/SxxdeM51lmjWNb5A509bp2+mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 07:44:55PM +0100, Paolo Abeni wrote:
> Will be used by the following patch to avoid code
> duplication. No functional changes intended.
> 
> The only difference is that now flow_limit_cpu_sysctl() will
> always compute the flow limit mask on each read operation,
> even when read() will not return any byte to user-space.
> 
> Note that the new helper is placed under a new #ifdef at
> the file start to better fit the usage in the later patch
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

