Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322A96E79F5
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjDSMuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDSMt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:49:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B97C163;
        Wed, 19 Apr 2023 05:49:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dL1i3Htem2ZIeSpyp186f4lcpr4PtblzTJHCjl351sVkf5fz79qBfVRQ+ly7G9c3takk3cn/goy5jDBWA/KRo0F3jcaORLSJqH5bD3AT2rE9aEG3Ro5UVFZ4XFzi3xEe7wE02LzlYXHbctloz/pW15eu5k5ySyVfORdSdsc2QYehtfyokP9RDXJ1aHPfm1CqGeI7qsk6zFeBKtFas7dqtzmAI1a4j4FPJpVPQ8ywoNh2npY7/r3Ut6lT71dO5fnnGPMfwc9xon3JK1MhYw9Y1LOZDHSFqgDUPwMFpHnhTJ9hbO0aWbEEBpOoGSY3MckJx3nZHJV/bfclKYuGdxQ0og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idQAA3su+OjiYiO4q6bH1uj+J+94UC8KjOQwOLnM8q4=;
 b=lyDXcrOULwYDANajTI+QzdewhNCKnRM3X8eh38O1ctOBglkxzybvjg5OpTQ28dyDObMm7Dcc3jO1u5s3yXzLuNtf3MFi3rHQEq/IIVb323s9rKBshzeoqseTzT1QG6cr+v2Dj4vc4jLtvyZdaE+bIUb30i34w6r1+RPSpdnMf/fufnh7f958mI0hYYF8zkhc1XzafUSKK39jcOpi5hn2aiEJatI0n87EtY4agkNmKWX3UE6cpFEmJLSuD5g3FN3CMZBqqWmIkkgxkcbk6PBwgBu2e972TPqv+JB5Bc1JSuyWPRmyeLGIST3JlMG2Iy0JoD2bIWE5A+1j23BAAWrMqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idQAA3su+OjiYiO4q6bH1uj+J+94UC8KjOQwOLnM8q4=;
 b=qiZPqYbAf/xyR7k2sZ8pXfy1JYHj3nKwWteMhG5cM2TZBhI9DrWTsN+rrx9Ufdj0PE/4p5Y6nWr/fCKN4PHVfSsDgFGEUXb/J6n69yfcDevZSXf9YO5qoRLk1uY414n+vmsW+H4PVmgqnItgQ6PJZNJeA9IGfbK2JkTVDnzcjJWURpg+hWlX8aBh7DgB7Dz0HSRVqp8hR1i8cy84mmGp+Wyfd5zz2CzjQZm8lQGuqYuNcT1Y14ZzHz2EHmxSjeRXa2RJuUq9QWHeFsA26vvVvFZR4PSMInGGQ3WPfPWQfixd2n8SRWKo9hyJ80wQDbrf+F1ou8vzA6UagB4f8sb6/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB7835.namprd12.prod.outlook.com (2603:10b6:806:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 12:49:52 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 12:49:52 +0000
Date:   Wed, 19 Apr 2023 15:49:44 +0300
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: bridge: switchdev: don't notify FDB entries
 with "master dynamic"
Message-ID: <ZD/jaASktd2cBlnI@shredder>
References: <20230418155902.898627-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418155902.898627-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0202CA0015.eurprd02.prod.outlook.com
 (2603:10a6:803:14::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB7835:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b604d04-f8c8-4568-01f5-08db40d4916a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDfj+gKEJ5yBgXSY5D1SwOolcRqH82e1Di/78nG8KWlSQ7vPIzeg6rAuCR/2U69z+WL8i9KuZB+hP86OU+w8qSCeBSzU/jog3TrgXmkOj6dUQMc4Dbr8gx5YC/lnV+eRg+WdHruc8ZzlyapXxMZlORiKjwb7i21nz8jdJnWu0PJQ1tAAx8b4fjvc5opkV8xxzZ7hwAgX5zjK+Saqoml1sbV1EcGGX2NSNerZC9ccTUbZaHDgKBqizNvXDjJlrn3UfyDu59jkE3dk2sPtVhfa1PYCs7gHhj3kLCHc9VtCKa5ckezBE2+LqKdt09Mp5JoI25zaN0rTua5NpnlZeJHm9bDSde7B0UfYawATZFfyYC1jhHivv5V4f6RWzTswoto6k/u9yq/fQeH/Qe538OqfvPNiB92ZlWJ1x5b+cFchk9KCBvVtOp6UsflQ/4sK/106ngOzU09AJYz8WchPnxEP1Vgg+wksEeWaPLNot+ofQYpH8XALjMd3u6IEaTaC6dnp56vDPPsSPUCy49GNHT7UjNC4NxM3Z19MRhc8aGAunNNzaQvf184LGfkww/W2B+2l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199021)(26005)(186003)(9686003)(41300700001)(6506007)(6512007)(54906003)(6916009)(86362001)(83380400001)(66899021)(316002)(4326008)(66946007)(66556008)(66476007)(2906002)(8676002)(7416002)(8936002)(6666004)(6486002)(38100700002)(33716001)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Szv2TJjo9HYHZS1wEvTQjPFKkixZtbRfm5lddE9NVyiH9Zazn7YzFSWcYMH+?=
 =?us-ascii?Q?vYzfR3fGKVF2fIAqrfslqZyygO/LkMgHFZlDHKx/brqSb4waKHcwkcok2cn2?=
 =?us-ascii?Q?GdRQeTzYamPa9KXvOqDYORQvZvMscA7cxoLy2ujbarl5jysH2qH16a7ye36n?=
 =?us-ascii?Q?djiYLDLqeGfF6jaLRFCdzaFOyV8NVMJFkx8c00TrofXuXEgicpvwMGa/VrY4?=
 =?us-ascii?Q?vOFV2YsNmlvD8aqG5x28mgy47qWG8+1Z+uULmcWVntc9gt6KGCdkopWX/Xqg?=
 =?us-ascii?Q?KIY9pXEyOir7NjWLr1m6lapN9lmP0rEhf+1eu+b/W6HoNLXGQxzSXj8JHryY?=
 =?us-ascii?Q?sVOsBXvshgeYDX54Xg6xDDMUhj+P2OQY2EmLehpH4GyCz7vlwDFNmOdy1gtv?=
 =?us-ascii?Q?0GxPET4MWefOPR1Djdt/GIhhBq6rNINt9Aoa//m/7KHbZ9Qki1StuaxtqFE8?=
 =?us-ascii?Q?a5EvHelmfjtFWwXAx4NbWzGhn9akzTEHJKelHeV/zrwUnAoaxklt5RAKHKie?=
 =?us-ascii?Q?m90o/4qwqYBgeeEmymi9g5MJZO0PkHs2Ms7/hn9eRpcdzvQmk3pVkLyzzro9?=
 =?us-ascii?Q?kBSDMhg3XugEyRsVnH/I+hkuCmxFGJQUTmh6zu8QvmCM8WaVueVB5A4Ix6vw?=
 =?us-ascii?Q?2SWwfgMjTF4rYYYDuO9tH/RCtRXd7jxcukVXsIy1564ku7QpqLX/qj4Musfk?=
 =?us-ascii?Q?Wfm7fdryKIx9mh9o3PsMR8IwDWTvcTRffa/CZedSMRYGRMcR9z0uu+AybXp4?=
 =?us-ascii?Q?mzUaGbls8y29LwYOKoQci4GLxXAQCFhl4NZ4Sdu/Ima0ka5QNr3WYjTvpqjU?=
 =?us-ascii?Q?BAxhYbSSzSMgIcQdeMgBQkkaBPvUFd9IBw+TsW0TmUELm+iyXS12vPNQCCvZ?=
 =?us-ascii?Q?8chpLp3us1KmjtqSUCWXwwLYVp0voD2tg6H/AMGsCI81SN3G1p73rzoRO/nZ?=
 =?us-ascii?Q?UqNqaA7ISQcsoQhSAG8UCYgHexV9ihQaiAP4QEBlRVgGSwGxxJt6JKPg8Hye?=
 =?us-ascii?Q?+XKElMQo6PfNU4/GCQ6f+Q8+oTQOrJWraQFM7AgZcVl2PDKP0hGD/pmei0ds?=
 =?us-ascii?Q?Aq4AkTWLbNMyDaSOWleiWCF49SGMFPcWnDmK8gzDl98Py7yrH4qdMtHEgPHy?=
 =?us-ascii?Q?CijE4trWqc8mKjhikT2dkaQbTIS8LcdYYmQKh6CwLVEDRTzAKknSsw8OroZv?=
 =?us-ascii?Q?jcYLcG8RaISmXORpwc2k3VPnr+X/u7XeeGjTloJ6aCIEvbTHMbOyzKH6WFi6?=
 =?us-ascii?Q?JavUVrBjrV3IeWV1r4toeDnjhuNnJUq2GA1ael/NdcbALeKcg07eaPFaU4ao?=
 =?us-ascii?Q?Gotmsyjf6hzJ3kJTAhqkLCTxI5aITccNYOF/9i7SgRYgUEQcWV7NSEjDa3rO?=
 =?us-ascii?Q?LgF9+Ei2zYE+Mw39a1uu4rgbIEuoI1rWHsIgfFvFXDuI41y8QZoW3fiKf4BY?=
 =?us-ascii?Q?ivNjnQhFz4zXC2WaiwMjhVZFT8+HksJ3wlx1/dZenDY85l6HjcXfNwcHuDaJ?=
 =?us-ascii?Q?z4g/pb1moxbjkta5h7KfHyC+uJxxCXDjKh4BrksPZy+05S/jzWK49F2toWsP?=
 =?us-ascii?Q?3N/T4nvlxPwHEbo7CukDys+mtKLCuDLDL71G374f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b604d04-f8c8-4568-01f5-08db40d4916a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 12:49:52.2983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbH3YO2xEU14cGttEv3yINThYs0iRJ5oUjLY52Tq16BZHj1UfVlIOUWRacQSbGHPmd7hRtbS/7yIc62Rvym3tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7835
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 06:59:02PM +0300, Vladimir Oltean wrote:
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index de18e9c1d7a7..ba95c4d74a60 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -148,6 +148,17 @@ br_switchdev_fdb_notify(struct net_bridge *br,
>  	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
>  		return;

Thanks for the patch. Ran a few tests and looks fine. Will report full
results tomorrow morning.

>  
> +	/* Entries with these flags were created using ndm_state == NUD_REACHABLE,
> +	 * ndm_flags == NTF_MASTER( | NTF_STICKY), ext_flags == 0 by something
> +	 * equivalent to 'bridge fdb add ... master dynamic (sticky)'.
> +	 * Drivers don't know how to deal with these, so don't notify them to
> +	 * avoid confusing them.
> +	 */
> +	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
> +	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
> +	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
> +		return;
> +
>  	br_switchdev_fdb_populate(br, &item, fdb, NULL);
>  
>  	switch (type) {
> -- 
> 2.34.1
> 
