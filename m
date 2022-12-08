Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41942646A7B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLHI2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLHI2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:28:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2B815730
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:28:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h43pWCnMV770jVV0N/fxDQKFDVnG2elqp/Qp2Fw7m3UAFGSrJgFg1TD6dcSI7h9py0oD58xMu+Q9XR2bU4Kv51L3LOVDtvQlWHIzUUG2lyZsvmveqhqc1N5DZCAprGxhp4ZW+o6qeqxJSm89Xipl4dfpydCcvbAYg5/JknAun4W1S2gwr8JbxitGczpI1lj17qts0HgQHmqQPWaL7fFdgyK8dy+q+I+i84Cl3a9mG8mrTKAWx6K2kShnQClU97H84+o9AuG84YnEeadSSIP0aFHv0W5JfNm5w64I/wLkn03/QQUoukNmDawslbF05V37bfgu36bzx4kUVqj0dCl9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQKx7IOyMUDu9aCfyDGAeL+t/iMK4qeszTkOmRgugQM=;
 b=N9SuDQbA3ZyeDKVDdOgOGdtf6PbkXMMYKGSOG0GXs0ks8vX3Y8UuhfYcTygdns5A57NwZZ0E3m140CAzsFDz4WUYjn5oQ8ZBDJkbw0g9bxT8ITi91lJq6p0C8/q/EGpADd0fBWPRWCmyu7PV+EMqilGJ50PCqkhnM26y1yeZk1mxDmYhz8FTETEI55I3wWVj0OoFBAS1BUZtnt2DWucNqhBfLLALiqvSEXO2F7vRpQzzfHGRbDy8AD+n54U8HDV9WnZMtyJi1Ma9cv6b+M92h4Ya3jytRI77hWaTBpDT4JTvXNFQJZLtUlC2PiWLc2CIDtGuKtK54wPkJn5PrhIFZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQKx7IOyMUDu9aCfyDGAeL+t/iMK4qeszTkOmRgugQM=;
 b=SPwAzojNB9D7aJ0OCDD4DELPYg0ZdRftVgffylvgf8glCm6LahUj03quGXqmZ0WNeGauetLsWvIP1vpzBIfpTds5ZsdEjfl3PTvb7B7z5LkJEFn2nBuA9RqQi2dSa4lqIPp0r3xUMvwzR153vF8ETdsw/pvks2nvHSF52E1uarJceITsHE+a58xJa/HG5XsAkyq3Ztwz9rqo5NY1lM4k60lA1dcpyQhYh+tSzI1lfNqHUaC4xbUstzy1SzOm7xyHxoSSp3hYJC4J6SwD0La+w9msUsrQ7D5I0jxpdoh8hrVmlN30Zir6/6p5lqu5Jb1w/zFp44SgS21IVwt5riaxRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 08:28:47 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::d133:4711:a0b8:17de]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::d133:4711:a0b8:17de%11]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 08:28:47 +0000
Date:   Thu, 8 Dec 2022 00:28:38 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <Y5GgNlYbZOiH3H6t@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
 <20221203221337.29267-15-saeed@kernel.org>
 <20221206203414.1eaf417b@kernel.org>
 <Y5AitsGhZdOdc/Fm@x130>
 <20221207092517.3320f4b4@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207092517.3320f4b4@kernel.org>
X-ClientProxiedBy: BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24)
 To DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: f48bdd8c-0bbc-4871-185e-08dad8f63915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkP8g2iyaCuMETO0+hk6+hHKNcpuRqgUHPkJY/pDfSG1lu0yHPgYhhQIAm/PnjngvseNM7WX0U3K5NEZnoY8r5inLtPUDMpmJgWiZzeHS102aLIOjosA72ygThgE73AcUpz5644bi11XfmhHGzJoMnl0NfMKzCCBp2v4C6w4VchoyT4h+ih2r5teWzWGXMxGoGgTF62hGJ08CJKgyKPul6b5gGoesN4fCu1zarUZo2Po8Dt6RoiJR/qaxKxJToQxREl6OI/fRMj1ydO+lDlyHidcOLUYhTkkCY1nkvH8rvjOiQMESAFVTW4eX1nPVf52OgTLOIuegVGNo3cA4Zchw5XnYi7YIWDPlRKSmUz0fpJPHdCrsEVTQww+sJJ0zRb84KtTjLSMVdKAO5p3SWJFAAIg0kVdGHW2zPUOFbYIlSKgjpf11ZhGmCIbLPdfcsvrdr4h5RoHA6ZjkSyU6e0zWa4s1KVM7HE7GK47W4aKVNuuKqnvNN65Ayb3J7eqLHncDYSlqJQMVXJF8UgbYEM37OmjkVZnPOyY5If8qqEGKlNMwolNd9Adr5zy2Xsy5/CKMfcGXuBAbW+VoVR07cnH7qhQcZAI2Pox5924yIHREJ9Veog5EXvbiCQRkxUJASgq9m6Zxn73ieBnPSfTXxnFfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199015)(8936002)(86362001)(41300700001)(4326008)(2906002)(5660300002)(83380400001)(54906003)(66476007)(6486002)(316002)(38100700002)(66946007)(8676002)(6916009)(66556008)(33716001)(478600001)(107886003)(186003)(6666004)(6512007)(26005)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IK4QzsjDWaqPDoYC4ZYrKoqeD0oNdQvJun0PHXrM30v4yDnjf7du8d2dKA8O?=
 =?us-ascii?Q?amuIkkijOAE1dEOTVCM3ruM2RL2WVT6E8D6hi8BwXCaOhlFidITTHJNMw9KV?=
 =?us-ascii?Q?gxWbqTxbdeO9Td6V89AmuGHlC9Rb+M5dXjaJRmhf6/RepDgjfLMoZOBYjD0D?=
 =?us-ascii?Q?Cdri9mF5/sPzpMoGxaC6Ts3vIpyG6LacaVnhSfYpmVGcLu+tQiu068ege9I3?=
 =?us-ascii?Q?U1+w9bioU5gY4TgVIt07UCuFC0P7lR04D5xnuNqifPp33Aa4IeVev7bx8+vL?=
 =?us-ascii?Q?dkOj3Q29sv8ihnoLniVzU91qdu17Qvk2ZIPBtvQP1zHw9LvDH9rsNXGsUNbD?=
 =?us-ascii?Q?OJQRz+zMQabUsFp9cegHhN5nhCpmKwgCzCLLXVbWuL/F2TRE4xG5+R66fh+u?=
 =?us-ascii?Q?7Ro55raMAwKOBrV27sQTkNApCUUlpDHyPP4l8O3+HHYretBXl+Ym3OHvNedU?=
 =?us-ascii?Q?fj31wL5XJwRTrNtjTp+WmnD6UbkVQyIVjCg86XnLCBBSybN+z/rbYGiEWy5h?=
 =?us-ascii?Q?k/BcV//zvY39Id54eQHB5O+IC3Vh4kUgLcMTQOoZg2VBADlDrx1fNm46ZnVE?=
 =?us-ascii?Q?5yx7lFxylrx7ed1ClrvQiLam00yxtDbt+XNtjgsvYEI+Yxi7ptg7d30xzFPP?=
 =?us-ascii?Q?exRF6EI3bEEkYwCKmUKBA3rNaoxEQT0Izi6rn81qLuODoSc5ZpX4avzOAeNZ?=
 =?us-ascii?Q?Expu3K1yWWeW3++4ntLmELFtGPbcOFdtonb/J271aFqq87s2zVNaoHeoG06b?=
 =?us-ascii?Q?1ye+uCDS4P0OIM3abConmcFXvzwalNyA3ca9hLDd5Srq63zBjWae28FRIOqB?=
 =?us-ascii?Q?fHM0YBXsnbGu70sfpvUq3wig9ueIWUgRdIqpu+Qx9MxhYlyt7HFKPlCQzDIZ?=
 =?us-ascii?Q?MZyuufhyqg/4PRT5FwxfJb22Ir+D1dvs9UTJtdGdNVpGv7Mo4VCElLguZxud?=
 =?us-ascii?Q?R4DZtl0VPVekIb26egsK8YrykNNY7FYbSQVS1qifWD030qMylDMsIoorsbS5?=
 =?us-ascii?Q?omWobb7GHgzp/gdbzPkd0umdJJ4lasGXF+aGeOxvFwK43lCoEUfngJuje2VR?=
 =?us-ascii?Q?ZGNYzY7dNgYtGgd3JRFYoIGjYpdmoXBkiXsVWk7GUmFYgAGyUqYJ3+KtgifO?=
 =?us-ascii?Q?aXDkRZaJObPTwyvOGCHlZNSx0vM3+z+kH6a5ddsiKmxtT2OSptacL5619Blc?=
 =?us-ascii?Q?WCOGufNUd6STmsi5PFsgOYvXZFjfCeIy1PloxPEFy5FDqo3xWOUfXaHwt0OS?=
 =?us-ascii?Q?GZjHTQYo3EvLu+Ocix6ajr7WZ2WhNy189mf4US17MtepB/jXE03w/AvNg9Av?=
 =?us-ascii?Q?s/QCSaWIs0mIkuSBWDzb7+jcvkjZN6i9ozNHcYHZ9R2evJv0jzzlHMvgijH4?=
 =?us-ascii?Q?5yGcrObVAdIL0JhSaGBvhXAywIX42IQ/T69O6S8td96tDmkzn23jhKxqbYIS?=
 =?us-ascii?Q?dowJh+wUVTAm8l/YHWnONQ8zE0r5GcW5fH8vJi9GFuJR1Adm/Mrtjjq1TBZh?=
 =?us-ascii?Q?0W8djFJt2qq9PQWgdNIujO6jRocTLi4X+Ri2rrZwlbJ7Om1MO/+nbLmC6UaQ?=
 =?us-ascii?Q?pHpjtEGLLwr4aGjdRKLfsMwmfUuzwi6Yx4NkvTRo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48bdd8c-0bbc-4871-185e-08dad8f63915
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 08:28:47.5552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8Q2a/S6hD7UE+SEXEyOog3Y+9oW6e/GikskcSPpIHXggH1y2noc5H6Slb/AGjaceL06mDMNG1Jrn/Gz54Y47A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 09:25, Jakub Kicinski wrote:
>On Tue, 6 Dec 2022 21:20:54 -0800 Saeed Mahameed wrote:
>>> I can't take this with clear conscience :( I started nacking any new use
>>> of the legacy VF NDOs. You already have bridging offload implemented,
>>> why can bridging be used?
>>
>> I really tried, many customers aren't ready to make this leap yet.
>>
>> I understand your point, my goal is to move as many customers to use
>> upstream and step away from out of tree drivers, if it makes it any
>> easier you can look at this as filling a small gap in mlx5 which will
>> help me bring more users to the upstream driver, after all the feature
>> is already implemented in mlx5, this is just a small gap we previously
>> missed to upstream.
>
>I recently nacked a new driver from AMD which was using legacy NDO, and
>they can be somewhat rightfully miffed that those who got there earlier
>can keep their support. If we let the older drivers also extend the
>support the fairness will suffer even more.
>
>We need to draw the line somewhere, so what do you propose as our
>policy? Assuming we want people to move to new APIs and be fair
>to new vs old drivers.

You put me in a tough spot ! 
You know where we stand at nVidia in all of this, we are advocating only
for switchdev mode, and we are 100% behind your decision to not extending
legacy support.

So if the part in this series of adding support for 802.1ad, falls under that
policy, then i must agree with you. I will drop it.

But another part in this series is fixing a critical bug were we drop VF tagged
packets when vst in ON, we will strip that part out and send it as a
bug fix, it is really critical, mlx5 vst basically doesn't work upstream for
tagged traffic.


