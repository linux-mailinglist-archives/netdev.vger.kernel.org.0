Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D1A6E9262
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbjDTLZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbjDTLYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:24:47 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B24DE6
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0UsrL2RuSFUCAjL+hXaHsubcCpAg54k/zg8qtzu7pMUQbvottQ2DBVZTPLeeoX2G4FrgKn62T1CJ9KuBKjl1UbBgNt9SIUibiKVVX9If+YNe4EfGWmXsLcV01JXgke5H07CtNAvA0Cp8fgcnwWV4m0tX0ZWZOp3QbPdoRqQfz983GIbPjBa66UJjpNSYequ/+nat6yLVtI0fmnZZHDpV24MeGvmGP5hh2pzH3wwhLHuhqP+a7hr9PnWu+0xfNbwkql0NZLUyTeFbbZKyh79rkIxrm91P3Na6jT3G6UX5StRXbfksK2ztk1g9R4okuZBCikUMFy59tgVYcmUVRzgjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUSmGblMUOOolNGOr4m2xYCiQHdppNipN6EtfGWbsVU=;
 b=lhiRIhgVpCTg8HyNvye6RsQubwmcwLa5THx3orrplZlhnQ3C2u2rtnDiHHg2wZ9Dj4ljpKSv3Rw+XiN8s2IByKxcCvg15pymtHBLDw+nXMbU8NAHdxWsMs1dP6CLLkF+FoF7oBQvCnAGwqP7oIMCujXWBrnw1dYreXIIznitQurqKFl+94CmbFkaDrrODLhV9pKYa6ZNBcrewmKn0H1aYYMQLDBhfoinso/ZCZPIUHYleWdnqiObOn2gj89kxGR3iYXfmryX3YXhdXcZngnrDcI7DLGdKu25qdYXSiur8s757WVIpWAeK5fIu1DQ32zKIt/4dhDOLzr5vrmVnF6a2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUSmGblMUOOolNGOr4m2xYCiQHdppNipN6EtfGWbsVU=;
 b=lMEJbCnHdxTSV10KcAf5ZhKiE7cuLpXBrCKxlRmaIL3AJNC+1eXC2RnUPlF0bR7qXAojqrVIPT9ydU5O7RzUFRO8cy/Z8BcWNTJQaujO1wGBW7Fva3kgkjbJD3ir45VBKu1QzG0byt856E3o64dQ9Fqk3s1kyVSVZByNm7W7b8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3634.namprd13.prod.outlook.com (2603:10b6:a03:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:23:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 11:23:13 +0000
Date:   Thu, 20 Apr 2023 13:23:06 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 1/5] net/mlx5e: Fix FW error while setting IPsec
 policy block action
Message-ID: <ZEEgmpG1hYsGC7Yb@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <da613106043586ef68984b12ac557cc59020714c.1681976818.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da613106043586ef68984b12ac557cc59020714c.1681976818.git.leon@kernel.org>
X-ClientProxiedBy: AM8P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3634:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a585673-2cef-4dff-d0f2-08db4191a117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcQMgtw7AzUBQb5usCLHRf1RcPvuuE3JpdrB3JnPE9PhmML6RVI0UMYzdJax3TGwUb9HCI8sj/L03Xf3/R3BgXZfoA+M669l5tJUcfKBaNwCYMs2ZF8Vh1gHx+v1oL/MmhD4yU5c0RD7fvIu8GOBFff89M4a8XU+9oZXI0KRkO91FRW9UtakIHWSbTY3TGgJKKRbBXGYjQ2JE5EvT6qD04bZIm06svNGyPsQeC3jupimqm7asO6hvVzU8MotvfmZ0injWG5aQoKqNQwdIQ1OpwGpNWJfaWCLcwIt9UtpBWoUw95nxEZwreOIpEcuMhknaNrPwY37xsO9y/Yxroc/ArPUpgZBbAdeijO07gNzeYbCm8ClGmaisW6nmoyCX+VBikZE6p7477mlBfOr2rFm3Ps++QpNRy9N9P3JlnFAvpsnVKdLa60GVhVb1TsSA0qhm8zNJbyX9Xkqy9kxgKdop3dRmPeg0zA/xoKSSz8b2EbBF0fkDLtEumkE+1gVoIizbxaPmZltrlmjQSUCu6HVI5i8DEk+Pc3Q8WCfoNyhyVyIucl4r6Cm634q72rgCRSY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(346002)(396003)(39830400003)(451199021)(54906003)(83380400001)(478600001)(2616005)(6506007)(6486002)(6512007)(6666004)(66476007)(66556008)(6916009)(41300700001)(66946007)(4326008)(316002)(186003)(7416002)(5660300002)(44832011)(38100700002)(8676002)(2906002)(8936002)(4744005)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eoA2zESVwwGUuEpBulzKcFUnHmDQw3k8oQmCBjdxCagTjVRMEAT73TbFL0qO?=
 =?us-ascii?Q?LNMazugfm4tkglpqMHFw/7wGCPaIWY5bGvwDvigTzgmC3BcZXKqOsoFGeHqt?=
 =?us-ascii?Q?63NM/PKTl1wjKJseby0k6//it2f+jYnagM9gdUwLW/IDNP9oAjBzt+wN7sAE?=
 =?us-ascii?Q?qH0pvnYrr+/3BdmYJ5vxH2VumlPk5iNNIfwgyYQRUtIFIP89RL1I8RZGL6ao?=
 =?us-ascii?Q?YKj2aq/sqzfgWyQiuMz54isp9H0JyMXCx/Nze6EdQhSd/1rIINMbLaYmOjiO?=
 =?us-ascii?Q?sywv1EEsqwtz9mvtMHRxOWOslwIkg6M6vhzRlc2X1Wkav2aEJqLSRTTECl5q?=
 =?us-ascii?Q?YCpjNNdjEuLUocXl2zwN+BaUocG//M/z5x++NAGSncIrT+F4QXAUs5CpxhSk?=
 =?us-ascii?Q?+AMMVmTKaGg5imM99loqu5V/buE67A2UJ776qLhURiH//aXggNIgAFDh9Kaf?=
 =?us-ascii?Q?tsKBkl2uXq58zvcrjJvTcW0vypr/EcCrch9YJ4fSOa3V2ctm1da9HVXL2iRR?=
 =?us-ascii?Q?wb/s1FnJBJPsmt+2Klv4sGceJhZYmmtcRzuH/bZH60pv+prtwbi6/DSZnnVB?=
 =?us-ascii?Q?NaLFxfw6k24oxt2cqexMVOouQXDJb52D7Le5BvKjul2J9wXc8Hb3j5z7H7Wc?=
 =?us-ascii?Q?Q8oF+GCHeiGge4KZqTOFoFYKNxc1SUNRiow0KuBg4Qqu3lqzMmR+inA4njem?=
 =?us-ascii?Q?28YXM4uQbeqhuZcOvSZttjsO+A5VOLxqIvHkyLp7haGl9NDDnubPZgAqfwNr?=
 =?us-ascii?Q?th4/r5U24+474REAFv1YEnNyoUfKppIqJMyrxj/+jQwU9DswTySHvAE4bh3i?=
 =?us-ascii?Q?evhb/vLy7N6GbjYFnX5IEJ4/n6QnsgvJDyud+2mTm18rpYprzmjVDuldG5BL?=
 =?us-ascii?Q?5PWmzeYxx7WbhNNrSGnGFOfmDTbVXJWziXSdO4cRLSFG7z7gjnfzpR5XtJUP?=
 =?us-ascii?Q?2lTIsTH1VfO6J/c2nIKVBez1pGtC57Po9rgNjZfTW+eoSERc8kubbSFfLtfm?=
 =?us-ascii?Q?CcJvynDve/IjM/dBnNNREHzOz9PWXzQ/5K57Lr3wpZlYdL09z/D1mwBrcvZR?=
 =?us-ascii?Q?EMYpiiyqXRxyKrQ1iEWsvkOQ8JT/3TLjGMP/sF8N0WLErDRO3AYeguldDUds?=
 =?us-ascii?Q?zM2RLS2afCYx6paE7s57fwXxoTSzHWlA8qeQEsSVE2geiGMoS0X8Mz73tNdf?=
 =?us-ascii?Q?M8H0dUz7i2a/s8nKOlcm/l6DX4YgSvvvEhR5lI8MUZkWvxIKE1lBJ5Ebw2aR?=
 =?us-ascii?Q?lljnYPsZ/El3ouy71NHOybFtYpQivEhkMuzhamcJw1PlLilgsXyKd8fMYZP2?=
 =?us-ascii?Q?yvGh3M1E3mYfMaSuR/bxzUkCG1dHatPUiwHUtN524dz+NJk4r2IeXKT/uSEc?=
 =?us-ascii?Q?1Y/FrWtbeBUCp58Ivn+O78lhhHCbEwAYPNH0WleFbQK679ZOP1hT6aXzfBr6?=
 =?us-ascii?Q?BVAu4knM0UzBSbsN8xjTsNSDgNP7cfmKLGPGHlTmS8triR0wZKbIsviExLaW?=
 =?us-ascii?Q?2yiEw44OFwZkvQXCf0tVEflT3BCgm5BwsA5N+1Pcc1YMP3DuBa1ddWUjjJ+c?=
 =?us-ascii?Q?CKIlsZa72pIa7DYKgC7+WRReDm60yj2sfd4X9IIvZba9bD9OpCcaZL15YKfA?=
 =?us-ascii?Q?UGAwoYYHj7geyPaNlFtfW8MOn1IxPJ810z1wMdhlfQfDcSxifbw+yPef1Ah3?=
 =?us-ascii?Q?S17+Qw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a585673-2cef-4dff-d0f2-08db4191a117
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 11:23:13.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waRo21qKcDC188XUIpT7CG9uTXTUjClozcSbLJfh/lD1taY+dFmOdBTJAkfthWoucrlFjEZrkI3oXWSTam/9yopw4iJd5iBq4UHWAfm2X7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:02:47AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> When trying to set IPsec policy block action the following error is
> generated:
> 
>  mlx5_cmd_out_err:803:(pid 3426): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed,
> 	status bad parameter(0x3), syndrome (0x8708c3), err(-22)
> 
> This error means that drop action is not allowed when modify action is
> set, so update the code to skip modify header for XFRM_POLICY_BLOCK action.
> 
> Fixes: 6721239672fe ("net/mlx5e: Skip IPsec encryption for TX path without matching policy")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

