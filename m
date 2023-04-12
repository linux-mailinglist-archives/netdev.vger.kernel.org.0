Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265496DFBCC
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjDLQuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjDLQup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:50:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D65759ED;
        Wed, 12 Apr 2023 09:50:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tfw9SwvCcCB/qHFuA5VdINBb083Rq9wZoTlY9oeXnl+/zH7GmKCVRKNNjX4EUDyPhCEVrY9qK6samRpd6qGX8/GrEYLe++DH5y4wqOMz6sp1dM2HcMmRU18cN7vXtYmlXHKeLdF0UHGkTsAxuFNSOkPpoy+hlmtR/SrqBA0dolv8lCAu63Pulq1SxK2qm1HwaGN9wxVaHnXnw5z0O93TCWv622Ue7OziiGSfwIe1GDHJ0mHndFjnTGpDC1mg82620/ro7Bc41zhMmWxeff6KkTRv+AtJ75ntj8uBCR817FRC12mZTBCihh3zEC4L+J76wxPFi0PEeesxFOtL32zMew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLXSBSLsetB2YF3He7oC8MV6s4/DAZJyzaY3E+Qx+Xk=;
 b=Ea1bk/g9SeUVTgJmNh5Uqk7lkh4Tev0l+5yKHpprQGmNtx6/JwoGZUDCatucO1e2BB8KhbRitQNQUw1Ndw15Mr8NAAx+Ib3b9N5OLLm1OC0WAJr/IcDM0m8xiOZF4L8sxiZ4QG9tm2U0FfRhYM7p8pYK2O5DEfei1/HmxcPuc2DVLbe/GaIheRWEMggHCAN61CV/k13T7OdTGyJEfi22auIKmH2bNQx9281KC8fOKs4OTNmLijb8YI0n8rs6DPSpKPEX9AZ2OpuYAgnlIhshh7FQSpL1jYcabreDxorADqQhke0BCP2mgTTF/96zmLqSjoZF+w+gLBi9tO5OTvBkGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLXSBSLsetB2YF3He7oC8MV6s4/DAZJyzaY3E+Qx+Xk=;
 b=oq2oGS/kyAdoGQQm2BXSfMRl8rEnWlZrziT8HQXCq2giI0bc25eCiwyWr9OQMH4bjsy8HOnvfc7VIgKSNUg8MKPoyaVC7c0SkLIjlpyKprRyU+v4e/GXsEuua0OGDmDhkYFetEPX67f4WmyTRDuZ9yc8XeF7bOEN1Gi1Ia+GlFcgb6v39JFI4KDOfUpx8K5YErF7KIHBxBdqhkA3secsnh8TDlVKEumap4hJXOA4lawwXJbIshYZA1G+9eVf3xbUf8a5Uc7kVR4qo8vcSK2VuYJIzkax2+LosJCo6c8r3B2hlFjXZKJ37phHyP0qCY8RrVnVavxbN1Sp1Fbz85627A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 12 Apr
 2023 16:49:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 16:49:24 +0000
Date:   Wed, 12 Apr 2023 19:49:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bridge: switchdev: don't notify FDB entries
 with "master dynamic"
Message-ID: <ZDbhDUDs0RUWVZ4B@shredder>
References: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
 <ZDa856x2rhzNrrXa@shredder>
 <20230412142733.6jhxt7kjf3nwqzsy@skbuf>
 <ZDbVgqV9JT7Ru96j@shredder>
 <20230412162407.xk3okeiedylv6sqp@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412162407.xk3okeiedylv6sqp@skbuf>
X-ClientProxiedBy: MR2P264CA0173.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::12)
 To CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: d0501784-6b64-4937-05e9-08db3b75deb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fllFidht8ppFOzYJMLmLz5nvCMwkSeB+/lqJK+tb45JKB9dwMlG7AZGccWE3sP3pOhVZUZiFOjxOxvEaLx7NaidB5uE/gcYmxQT3ittMmeEpqlIbFCvovJ6nrsO9VTkEaPB3RefpP/x+ByP2JkD/1dEaCeXR7vXQrvh9KuNB5VtRPn+cF0kjylmGfj/DN7+aHepq1iF8BTvw0krk/N47P6oXjkDaXych8tBITValqM5tckCVjGI7UYELD74kSr1GXpuWZ5a0TKcTW3bDVgu5SX4lrD+0A2VrDaTxtJhe4XFOdU9myGDX1GMbottAQvWTYdKAnVHvR1iBeWu+3BgWfepr6FH+JUO9wr19ntr/YnLWEG5DIee4+PujqQb7SCohH9xZk5QKLd94YnZwLaEudv2HmzrI56E9OSsru1wtkYqsQ3GCb5Y86p/bqk0MLtVe2DXJnKvBE7iK4QuPfllyZNPwwHgcDPN3HbgMZnvZai34zgekyvp2rO49ydPuHXKh81z7HI65zmJutSJ/DMu3I01AldXsDX2baTErpjhuIYisHjnpm1+AfwKl5LsYI2go
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(5660300002)(4744005)(7416002)(54906003)(478600001)(6486002)(316002)(8936002)(41300700001)(9686003)(6506007)(6512007)(6666004)(26005)(6916009)(66556008)(4326008)(8676002)(66946007)(66476007)(186003)(2906002)(83380400001)(86362001)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dAQ14cdUMtTh64unHxvN4Kj5E3x/HThQoMs99AMp7JhU+o/+1zrSom+vVLJ+?=
 =?us-ascii?Q?Gtw8xEQoBGwwEOs20duCXsGOLk9Tbwjoa80LTDesYyRVBHO2uUduPKqSMQ6P?=
 =?us-ascii?Q?yqnstzjz3MqIshRJVLSFn6HthbKa5C+wQoSWBKCAWglZnzWDhrp/oLze9R8V?=
 =?us-ascii?Q?GWARd86EBMa4z7XoQ+ANpxEcMX8dzQi7XJAfQEZBi52ejIoyr82dTimaY+Fb?=
 =?us-ascii?Q?qB4kFS0OEmp+SceEC8JnPxtu9ltn5a8H8HujMeSAYxKl4imfLCJOr+dYk4+q?=
 =?us-ascii?Q?dqur6YHWeqsIxl98Poq3Xqbi3GD7UrubDKMgGgZmPgYWLx+ilkfo/YIqyDDU?=
 =?us-ascii?Q?8nT0eGqntevfNlH4wVjsivtFd6imAFtk8sYBWzEEAXter2nsCG8AtEw0HIkd?=
 =?us-ascii?Q?bTWORhFcEmR3To11F3qNzPqSDh2rJLK5Fdt244oNSXRkjsVGnGVdzXO6Lmo1?=
 =?us-ascii?Q?F6hICp3Kj3CtSwWvhY42wue7wqnTH/k3O/pE94mdpxOPwcUJkaCb0AY527fT?=
 =?us-ascii?Q?sqJxN4aNBR4DURJXPkq8HbZNwu3grWutxCsWZOBpRyUltcJoVNnvV9PnaC09?=
 =?us-ascii?Q?GrCnJI5eZ2LDgTH9JzLutnT2Cd3+uEmbrmuKqQxO0imDHgbVssgsvHjupcwt?=
 =?us-ascii?Q?hXTw18qfdpH6AQcKvRwn/JxqnYj9KKtFVItlDJ3y3RTCtFlN2PvceNpJhLDR?=
 =?us-ascii?Q?dCRNwG7LaOkvgWFlVOTGcuX/wQlLxXB0wt07VmgX2iezSE5EjQb1KRvWjLBV?=
 =?us-ascii?Q?EMlE39Ei18kY+qYq6G+KAH9lm2XqHWzS5gLDHPhTbU4jU31rJq0dZJnrUzkE?=
 =?us-ascii?Q?3fcLR8aefYLsLFK9i9PlepQlTnzadN6O67+T4kJ2CMwxv1e5HmdCw9l/Prtf?=
 =?us-ascii?Q?DCxcxDGFNdw19WVv/KQ6lKJTihD2SqlMGcjRvndOTDjZSLubgO0VZ4ZZ5wuc?=
 =?us-ascii?Q?g538Y1CI2WMQJrKEfSdUvFEyzWslTBBi4jz/9GFebsxzeUg347XaF9tMbrKZ?=
 =?us-ascii?Q?Zp3uRMdAo+35df7Fp088qv+FlHw6Tf/2YhTAtgMYCgtgA4/zkIj99z/kRA8B?=
 =?us-ascii?Q?MMtDYP54SuvCdE0TLKU5d5eMWf93BZ/VRbr3SQEVWOWz3ZOKIgUwqItPQxTP?=
 =?us-ascii?Q?EVyMBcgqbl9hxQGh6SKJA/4AgYGzquczdDNbxfUNT9k4WkvjgO3G0FuSZ1j3?=
 =?us-ascii?Q?30N3B3mN3eqmjoal6VrRxXxA/WspswJbZcNkK+aNzgPGx+YkfV07T+DN6hi4?=
 =?us-ascii?Q?6oT61Y2GBj3tuS/6O9qpbt3iZ5mCnWMUPRPXhnkXnXWkPs+NkL8WZDDeQMwf?=
 =?us-ascii?Q?h3jWB5krCKxSWvs5pqXXmBa+SZ9fNqLYzz/1tr94NHuQ8QqVropiIkxVheQi?=
 =?us-ascii?Q?Isg9A2BY4HVtMjtvZ3GmUVxKvqacSNmogtOoxEZX+N4lY6YBavCgK+8M8rQK?=
 =?us-ascii?Q?u8Q5PVmejDbdfvQxJ/+1hJ1Zn+Cg1/8hvRGsz2GardJe0JqouB1GUXTud/Hd?=
 =?us-ascii?Q?ayw20Hp6fUNwbieSo3z9G/jkpNZboG6ALFuJ0F40rLz/56aVxspsQXzwtGRE?=
 =?us-ascii?Q?73nO4pfPqwSLjFAXUmVqUYh4erptUlxJwKMDdM3t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0501784-6b64-4937-05e9-08db3b75deb3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 16:49:24.3064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsJ4d/PhsGY3fd/cDZlDZBHxF+VQg9VQCfAT/f/X9blWYo4m8MnIY4uFNr2O2RHnWHW3BGKpfLPWXkpiRHlg3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 07:24:07PM +0300, Vladimir Oltean wrote:
> I'll send v2 with BR_FDB_ADDED_BY_EXT_LEARN not prevented from being
> notified from switchdev.
> 
> Unless you have any objection, I won't send v2 like this:
> 
> 	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
> 	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
> 	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
> 		return;
> 
> but like this:
> 
> 	/* Entries with just the BR_FDB_ADDED_BY_USER flag set were created
> 	 * using 'bridge fdb add ... master dynamic'
> 	 */
> 	if (fdb->flags == BIT(BR_FDB_ADDED_BY_USER))
> 		return;

LGTM. Please copy me on v2 and I will run it through regression. Will
try to report results before tomorrow's PR.

Thanks!
