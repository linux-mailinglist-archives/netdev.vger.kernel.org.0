Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F8E6BB8DE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjCOQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjCOP7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:59:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485D9898E1;
        Wed, 15 Mar 2023 08:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0LENK6RYhXZtgNnAYRdQ6Zgox1+vs9Nr4I1l4Y7ulbrDCBzy+YknkQPrbVN9QMRFrz6lcSrF2kej4GSJhUBgacg4rFPjZ5em0Ja+4bgWadw5xdvdgqQ/eAt9aOyLHdly82O+3lwInjikwc4ZOw0Ef+ctHm/BmTrglRZtW9TUl0mRHf6Ot+6L4qcYua8Bqvt0jOTMYI5J3dP2junb5MfhsxZGEMUXbRQ5Lh9DSeM0mvDCbjYB49H3Zc/htqytYCEsY0tGELHPclkvPbVphNqrZ0FNBrLfwgc666b977V94oettdzjwZoIrYDlCouJMXoms/Pr9PNRIclzu4rFrIeVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h57UFzWqDi+19uHPNvWdPNul1EzqW1V+IAxBQHiR7WY=;
 b=ZIvZMvym5AdoHm6YDAZZYy8u2//mqqsyFBGKMDkPmbZzh5qZEA1YASlQJVLjSH7IYaA6ECGvzm/HF0wwtt7vyuOF3Y1q5+SGplWBueUNGNdDN5DDxMqUuCM25wBMkW6l7RW2HPa+uQrN4ojFlS5ciPHeUEemm6JPRB6pshQfAwgMjyC7sZu1Agj6rXwHsK5vaZ8UrmbFne983SPo+I1XF92wLsRhW4p11wWtFJ4B5UUFP7Tm7UQGqf1yYwGiDXYh92+3jvbOWJJwmteRU/lbVLB4ekRvqg67q21TE7njNCXkHVAHBZBc84xk9RpieVyCmN+M+qQJUv8Q0xOK8SXzXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h57UFzWqDi+19uHPNvWdPNul1EzqW1V+IAxBQHiR7WY=;
 b=PW1IC1WZuQxXitbyuqLpISEPja0EcxUkLqzl7/IlgPQ5YNi3tfl9UjQiJ5luM/Npi53FiH2gd9d6MF86lbwfQ6p/dM6GuMSFanQtZgznpY4gnKkPgY6cC+uX+Rx9QpUgcFQz/hlNT+BKox7wUcRbv/Niy9/kIFiYtdOsAm+StOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 15:58:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:58:54 +0000
Date:   Wed, 15 Mar 2023 16:58:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/9] net: sunhme: Remove residual polling code
Message-ID: <ZBHrOD8Wfr4GPx46@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-3-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-3-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR02CA0003.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: c59f30cf-9088-4778-043c-08db256e2da3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ppbG1ROXBjBUFUqSfd2o990ld0Hk7DgT4aXD3WvDXTixLOw6hHivbz3eeI5KNo7kD1Gwzb3tR3wUPYYEYojivCnfZW/5ab/cm5M7zw6LO2eq38QM6Ia+F6gEeDlBzK2N1h2tpI+keMjoaPcSY616j/5NTxk7LEtgo4bEvRu26RTpVuSV/BNZGSjN0Wh3azwqzBFQPmQ+AEN7Rj++IaCDsk6Y1uCi6H4pqiXclrqau7o3nUHKR9ptwaHUqFPUKv2cYGZFoUQEmE+ugTkNIO1IlFptX425Dmh+Ft58ft953lPEw34cZDU+CwMA2x+Jxo+exbbIQIkVDLTKwES609ezzYeFXW9p/K0eZMHXxhA39DZbaLAio8soZkgv5U5GVRafZetz+W75D9G8Jy5S0dntow2JBzkDOYbambJ+tI/CxFlTdn9l3xi7ulXgQwcmwQN3xoHJQLc2t3WF7aJsaX0hw/jt3V9yn6GTPC3xfHeBK8ad1xrJHT4tH6vaBKpcTG/LvtaqjOXL3YGGqAX5SYg8UVKJq83w1XBtza+R2yPuWxMUh4CepOKW0avS+kZB+MyCAwPiARBXVxEVfkRkJTfd4VV0p/QJgqoaDE8a54mLrhSkBC5SgapMFXB5cpoy8ZUX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39840400004)(451199018)(8676002)(6916009)(4326008)(66476007)(66556008)(41300700001)(2906002)(66946007)(38100700002)(8936002)(5660300002)(4744005)(44832011)(6666004)(966005)(6486002)(6506007)(6512007)(86362001)(186003)(36756003)(2616005)(316002)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EsPcGVdTlvWfzrDb/inGJjO05IZY12emVgJHeQA2quUAcQzOGt+YOVu11ZBe?=
 =?us-ascii?Q?eVufxGt2aJUAlZubYWuDJIK1nmVSLg1seDOUtfD2MrY4UZf9yjA5ljxVun9b?=
 =?us-ascii?Q?PZtofIzMF15a3z0VNO+soto3OpE9L+3L1GAzu2rQ9LGqE7Z6KC2C1JdbvEiu?=
 =?us-ascii?Q?gJiKuIFQXVpfFrawoePHiZozaTLSj0DCYvFLloHxIJUo4z7JDRMIR5g+lFAx?=
 =?us-ascii?Q?62RPysT8aNy27dYI0bm+ZjRwM1c+KEccZVAuMv9HfDEe9pK290H/BL43Bi8i?=
 =?us-ascii?Q?IvepWiBvteS+igM5aFrLLD7PVlbOxo71/jiwkokgdZa3sRqZcXFTilyvmGG8?=
 =?us-ascii?Q?qUiag+WPYgXr+MEZsH3Du6S3zJSrIogMq4Sl+mlDm4R98bp//gNYeE69/V3B?=
 =?us-ascii?Q?KPAW37eoUT2RhUD1YmiTXxKkYEWB7s7TBndWjtf0GnTTXRU/v76h1t1PzfJb?=
 =?us-ascii?Q?/ggE/zTzq2Y2vpMq42+ZKSnoeCcJAwjLGGJHCfNJvownMRX8pfXwWvrIVymN?=
 =?us-ascii?Q?HcJvBfG0Be24BPS0DU52dRkfY7bykTmlJEhYhoJWLY05UG6N6Tgkf4WghEM/?=
 =?us-ascii?Q?4lu3GaeGRVd455sk+GGJTYGCi3W6P5AlD/Uqn9moSkdssinWuNawYYnceNF0?=
 =?us-ascii?Q?StqL4LdmEOLEJDp9A6D8wjYnhJEWHwB3h5kpPfGQBcucIv8e2mTx6OwQ6YfQ?=
 =?us-ascii?Q?QlaVn1JW/+f8FyAmDkSzr2fOClDLedefYeRyMMrki6eFtEHJDJWJvzyZZ2fo?=
 =?us-ascii?Q?4XUv4rStKe/fDtWfFJxC9GQHPi2Mj34CzUq9ITxG0avgCg/0faSFMCYooCSI?=
 =?us-ascii?Q?MCXpkUjU0PY81E6/gNEM6gfiLCYmcxsG+ovxMISwaH1WSGIlEjI10qQ+YPDy?=
 =?us-ascii?Q?f2FauNgQDYmtXcVMVN2s4Isti5j0JU/jfcffj1APH/KFSIm3nqIiLQ9Iu/y/?=
 =?us-ascii?Q?oEfzxRdV/UU03iUEaHCNT1aKN1PbM/cBubwxKY70ffUskc8EqkmEG5subLBU?=
 =?us-ascii?Q?KAQUcYUb6h6BngWcVH5L7j6WLHZhAJKy00hwPJ5tpUv3ViDzrwL1gobk4IE+?=
 =?us-ascii?Q?JYp0YuqpFF5X4+7ksx/gM8xaDGfel5HNDhvu6EI3WcvQz7toKfH0ZgT5X4Sv?=
 =?us-ascii?Q?/45tSbhTQIFVaHQgGFA21aRkBfww6RRVoaCQ8vxGyOqD7OXxJyfvAb9clOrC?=
 =?us-ascii?Q?l27Sgcdp21ra4OWbzz8nx7rg/IVOkxOpxbFyfbuaM8tcUi5wv35cYCMO9PbI?=
 =?us-ascii?Q?B0vfjjm5AiHjs/MbGf7bxFnKvtf/wpC8wsHeCEQC8H5Dfe1IvVG4nlPZYGj1?=
 =?us-ascii?Q?yJKIevz5751xAfDrExEI6JhyzZEkkyiYQafkg7gO9U/b5e9xXqogueFZkUJc?=
 =?us-ascii?Q?Kh7VrJ2FuYYaM3+CBGcs804LNS8azMoP4QGXxBqGpi4h1Nq54rOLxxCnuBvv?=
 =?us-ascii?Q?V643SPF5oF0z2UUYa0tlyaNmhhas3p2o6VUiozEfo0KWO80IO4l2cskLnX23?=
 =?us-ascii?Q?4+6zqq+fxLBFEctw4FKAL+DgDySabaxuqAUA9oYSQp2/XHS3oZY2BD8tHrPr?=
 =?us-ascii?Q?Gq8qq24v/6WfQmGQTeH25MQQauvPk4lqYAJXHa+mTjEGdX1x6PjoifZAf0p+?=
 =?us-ascii?Q?2+rFTO1frSd2nZ+vJ5BzubPj2qo3Zq/ODwkaufVNaOBOv0kr0dBXCy9Arvod?=
 =?us-ascii?Q?wjFI1g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59f30cf-9088-4778-043c-08db256e2da3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:58:54.6907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eE9ptInp5kVnMvIbloRndPkgdHjKe7Kc2bDDUr8XR/N/7+6D1C78jlY3oGqCS6mYwObEyHaOpKi2jfCL2XqF/jtb7jdiq0KleUACE8+XETo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:06PM -0400, Sean Anderson wrote:
> The sunhme driver never used the hardware MII polling feature. Even the
> if-def'd out happy_meal_poll_start was removed by 2002 [1]. Remove the
> various places in the driver which needlessly guard against MII interrupts
> which will never be enabled.
> 
> [1] https://lwn.net/2002/0411/a/2.5.8-pre3.php3
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

