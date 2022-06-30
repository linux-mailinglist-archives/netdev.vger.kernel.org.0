Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1F561883
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiF3Kp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiF3KpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:45:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30472F3;
        Thu, 30 Jun 2022 03:45:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGQ9n5X0S/Hamcx0WMqDBSTTqL+GGjMWmF1Y8XUtVaij6HVA0SEDAoSiLk9Ccmg5civtnMcgZ210+bRjQIUEIr8kEte88ZDa9u69M2pqSIx61exDh55RLcDHjUO4++5JEBo7PJBVrbHhU5uAt5FhlLF0Z9BmTm0pb9YbCd25WuiS2bxGxNnPhW5XnjE+mXn895YAj0PuL1tY82AgwSELWgBWwXxooc0cIJOeEmDrhZ0XPjYJc6yIGIb+aChKPKslBzLuut0be6V91gi+pkOuYK6mVV0BuvLYLQPiW2GUwtc1hXY/2T01l1jtx8yJ56rjqV7hc2RRRFjXsP8ALQCYug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRpb4aI4SpSXkUnh+R74//jzdl9jtp8G6AcwQtwqlvk=;
 b=PoKzWTJ00ZznAU3E0+uaZffIZrBlk/mY1IiFwvOcDjryLvCc0xZDvivADYgBwVsYFaZlga9o2OYHlbTPO4eaXFwfzTv6gSxBItPaftz8GYpt/cH78XpS0iCnUzOxXF0rokVVhuLgAWzaENHI9GJgcAEwPozgH5aln+c/KVyvM4TrigpCRBWWj4t9idZdOyjUFN5XIH6UGfLdkcnwCECRNQ1UgSz4ksxfQCrcPSIucX8hU2dV5olXIg7PoKa6RAZcERxxFDe0NKRrAhAlMP5aQFXqkJPelzWGYSFELnE8hlu+13VeRCxScSxevKhYqdj/zdtgmLZ0egL47lScixr9og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRpb4aI4SpSXkUnh+R74//jzdl9jtp8G6AcwQtwqlvk=;
 b=OlOQUO9NYJqYft4MG7wbEVbFGuP8s2jwXlUS0+gMjYpoX8Z8BsBLOzDITpOvX7WBkcPLHxrS0HtRc8eEGslK1BVshdp3sdEIXj0430JJcdo2b9kIrlRU2isVRjt3bpCcKyou+oDqYpHhTV7lySQdjPHTa2x9IksI7L0ZT1V3wyEitFrs86xBP7iN0pFWdcWOhZhLUCXW3DmpZD0IcTJqWgIgYLt44WZzqefjopUXqqoRPXOVD4c1AbSpunVI319v2qA2FOIs95XJqRq3elzYDKk8eF+wACyDdjDgifNjQI2JsmMwvJ9VFHzIodq4YFEtw2W4vLgK9/2TofoIAdxOPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL3PR12MB6572.namprd12.prod.outlook.com (2603:10b6:208:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 10:45:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 10:45:23 +0000
Date:   Thu, 30 Jun 2022 13:45:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mellanox/mlxsw: fix repeated words in comments
Message-ID: <Yr1+vaAxzRgr6I5h@shredder>
References: <20220630074221.63148-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630074221.63148-1-yuanjilin@cdjrlc.com>
X-ClientProxiedBy: VI1PR09CA0175.eurprd09.prod.outlook.com
 (2603:10a6:800:120::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5016056c-a382-4bd0-afc5-08da5a85a269
X-MS-TrafficTypeDiagnostic: BL3PR12MB6572:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGLdfQN2WQZOEn9hTEjj9VlA7ysVRyZCEcCK34k4FOlfr4DFNnc6d/pcccOhO3s8XnDUbgG5owhoxxb/2K0gky1PaMM3ebDSI/uNHcSfo8rnwL1mD+SuCz/Emny+H/ta/8Z2g1MqA+f+PWVTDuUp779q+Egmrkf6SJNOWovM9LMAPUJtMaJORyUOfzBQKmvBdV7L++QpHLcErU+xqqYR+HcXoF1Aw08OZKDmFKkkKkfnF2eTXVTd6mtikm2IZp8jMCF7ylDA+8gunprePWTrmyeM0uuroamP7Kr941/1w2on+ScHQrffT5cAPNg4Rf3auGskrzOt62FbzEHN/A2Tuo6Y6tA/cUuDHFjgDMwrNn45EciV9ctpoRKmYcuoIdLhpOgCjib9i4xwUE76Mkv/1lEXuo4YfaCQTOFtaV6ZCYpG1lWp6TSGyUFZJeCcnSfIbUg+Jhz3skjGhjUREQrY60YYOSbN264Ys2mFo3MMZOrEAwPQInq6J+sATfhSNOU/kYzHPxv7PzNduWjgPE/19h968JPzd13ldhDV1HowiTu64I79es59Bk7POPtpIPhPg1+EtcZjfAfCQWHjP0sBwXqfTKETpCq+7MzOUTDPrL1CFlzWB9WGAXb72ZxovNd9Orej6ThR8q6MeSVorpx1NVwJzH1ySaBVwBoQa2A+4F2Z+V7aIo5/uyIz1cyI9Y2q3/iSxrPfoLBf4LzkHryayaRRsTlF/FFQAXPcdMZBg9ZA/EVf1+KplNkPhv+nesVj7uOZcGiMKUbw3GC+l0uvUpMsDUXqQptlwO4bN4DDfEqblqrztg3QaRSg1W15Fkj0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(396003)(39860400002)(376002)(366004)(66476007)(8936002)(5660300002)(83380400001)(26005)(6486002)(8676002)(186003)(9686003)(478600001)(4326008)(558084003)(66556008)(6506007)(41300700001)(6512007)(316002)(2906002)(66946007)(86362001)(6916009)(33716001)(38100700002)(6666004)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H9lrqjAveYzADw/arY3byiB4dcyFtmjdk6sgvDfRd0Gv35IavwNKsC2UoQSx?=
 =?us-ascii?Q?yWPeiK3qBmKaXi76u09K8T1+GXK0JGfmJdAl3t862zGbu7GuJOWncQDSc7F5?=
 =?us-ascii?Q?MRGzR0RIr0X5iRH1Ln6VIT1oHN+1DrXMitxEiJrYUrLCu1znZvn7gZCmkXHa?=
 =?us-ascii?Q?MrEHsliOkeXSzUVMnC2y3B7BoOtO8CM+8XKS69sK2Dn+4uIFrQlK+OsJrzcN?=
 =?us-ascii?Q?lDmsDS2yCJ1GXGgZQyelicAAZ8ChMNcnTHUZDxPqEh0B9Z7ziT3qx/Gc7wWU?=
 =?us-ascii?Q?fKgweuAqiep/MOOSrNymt0uCmaUTH54qX+JPpHRA1NIh0iuX9kLZXLSuoNBj?=
 =?us-ascii?Q?BQPtLlq8JbbKMBpV9coGHcamrz85p/FUHVFA4ewtYUvEAOcCquZ5zKgT71mT?=
 =?us-ascii?Q?phIjyU3VQW4QlwQhp+52iD62vKDMxin0PWGHlEPf5o4+wC0l/4FlTpJtlFYX?=
 =?us-ascii?Q?xcht8f7gjiBnmXwONSzTDzb2d9gzSxV+EU0DriZNLulguBpVEcwfpA+hTKYk?=
 =?us-ascii?Q?35fVhQEowH0cCrcYHRpCg5vdslHzeLl9nUbJk1GZCZd3O+D+rB8QaJjxKCFz?=
 =?us-ascii?Q?mCmJe5krcJAldF3S4gM1FgbwLlrgBzpDLkSGFAqVNU/3XeIbcjGGzNiHd4ES?=
 =?us-ascii?Q?to6pCYxgRAguZLqANEhu7eqBXX3Pa9zEgkwWqiIlpg4vveXddplO5wRw/DMO?=
 =?us-ascii?Q?Yaj3iafWIzYuVZWgVJ5SCpBZVkNz9h3GWLJMQk4BuVgCEkJxWUJYILjXPyqT?=
 =?us-ascii?Q?n3hliMPWS/5VCht2quE/9S5wPTngxZEV2yEFVCioje65caIgxJFPD3/KhfZQ?=
 =?us-ascii?Q?EMjquKqO2YikrGqc+dDiQea3c34tPIbZiE1jlIvluSNBUDyqK7UCoeI8CY1K?=
 =?us-ascii?Q?DfOsBkg0ZVYDO+m9PEMgGRHRNLWj2lprpKMSRohbqf2JRKctYPwNptigsq3Y?=
 =?us-ascii?Q?wAGg/qf+46i3Zjcc+TbFzcOCa2Wk/5UkYZh5HzZs6FcQnsr3JIrduVvde1ba?=
 =?us-ascii?Q?wRoBmDuM99QHnTNrz87J45knullUDidwF4jmNhtYF8gQNkxGF0wzHX8OvhSu?=
 =?us-ascii?Q?GPC7J1BvFvUdHEh1+69zbHaWFaQ94EfgX8ulbo6Wmhv6QdhC18ckLoCkm4f9?=
 =?us-ascii?Q?1t6xZLJoglN90FuFsaGRcRb694oYQsLuGcI2QbpJw6kPHypyfhHYvVG79izO?=
 =?us-ascii?Q?W6430FD6z82TN1QxT26lzHynzQAsqT59miobyrB47Xn8fB19tDOg41zyjZgL?=
 =?us-ascii?Q?z5Hi83ErB9yEy14+/NKPf+XzilRmNTDyUzQSa6x1IBwa194v4c3ODEg8XNH+?=
 =?us-ascii?Q?qPH7B4wQO5VXA62HaGwRCufVdpmEOqNNE835cXNGe0cgJ+7klsisnTfIeWQN?=
 =?us-ascii?Q?UGISzCG5sLstEC9qScgQ5czHFbfCOmSmnNCKzEt9Y9LkvBALrubDJvCHXbul?=
 =?us-ascii?Q?7ONuxoRy5pXA8fEYvlAt8qTWDwGleUyp++eMvq2pjGmoIdeeIKjhFuTM2q8G?=
 =?us-ascii?Q?W2Er36n5JEN2fbhjJyCVl8CHY4xH3c8Zo5oikStS46VEXQMOqKcMpFW3HM6M?=
 =?us-ascii?Q?HpV2/Tsc9f9925ONu92S1qt2okEro5HO0Qv2K7s3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5016056c-a382-4bd0-afc5-08da5a85a269
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:45:22.9425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7JvyNLFep8BdQBf2/sTQn4Cnn6qjos0TknVDxr2HtPSElxFX6pMPLc+7/gw7VAvCUQc3zVv/QhbsCOuKwfHNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6572
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 03:42:21PM +0800, Jilin Yuan wrote:
> Delete the redundant word 'action'.
> Delete the redundant word 'refer'.
> Delete the redundant word 'for'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

For net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
