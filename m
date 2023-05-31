Return-Path: <netdev+bounces-6677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26845717684
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2EE7281315
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74E863B5;
	Wed, 31 May 2023 06:04:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93EB440C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:04:42 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E0C11C;
	Tue, 30 May 2023 23:04:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQxX5kawuGe44IcMDRIBYPo7W0W246K6uKDstrKj7nrOtM6g8ydwNGkCZcG2hF8t4XqMNOmvLAY07roaKYbFfamN9D5cUzwF1ZNRpMq0wBqtav1yQcGnHLkB9ZiyGOtm2Q1yWflBlXz0AgDzKY3LuZx81B61e4HBnxQRegfo2/CjrVDvnvyKWevChUqHeJpZE6GmuggEsIs0zqlALEj3fw0CbLJR6CtB64h/8G/KSPJf1PII/lFHueaGuBf0eNXMAAqs+/SpMRT6giTqQWrM6yo+HshPs19FgNd85HhkHIH1gfmt+aaFu1jK272WSmUGHEEypJvbWcvbIKHEvZzTGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QaWIZHF3q3GvbIKiZ4uiJEiADiaCqRpCeKSZdd4NLM=;
 b=L6Nc9s8JEE5i6XTdrlDcnZPtIWZT8BCRb2IZ/PfpbuUWd4FKsi/v2vPJ+amYxYMlct1UgxWoCQCGYyYnbSFe9ieuXzfDGYy6PRXaCUvzbty+UlQX5dgwKKW9twC6lc182+5dLbQ37nKTOVgvFy7aUPgtA1dycmR7Ib7bCXZWzJ5fYDmPQdEA12k8Qvyi2L6cUBtzYAIWg1N/ShJbhHnjD5kRcat8LBFbsWZ5waEf5nJAJqJGYHW01/2dO15tHpbh7PUQOFvQsshmtzzUavjui6+PAU2UDy4zR6typE0eLdsJIou2Z/I6Ni8n7uvjx5JgxPSVUzOOuasKSyrDBBrSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QaWIZHF3q3GvbIKiZ4uiJEiADiaCqRpCeKSZdd4NLM=;
 b=XRNuxzKEsaSRTDUmwVIomEEnG1geQBzhHDuVDUARqV0EuXhwoKkl+dTIiXEKZ6YDfAYe3K6YbGd26HirE+Jt4HFrId+AInJk2oeyBmxXGvcffl7IjtMlsb/SgGbwkFN+pVFmWKwT3kaWeV+FQcJ9a/AKP8Mq+1OUIZIpslZQiQ63oBS46BmqVGuvdR7nb2v8dS9I3QTgK9bSp62+14qmUraq1yiNXb60wqX8/Etyo4cr8fHUC1fApOJ3yBVwW8fHKrXg99dhxe6BFxmCa5CUgdfJs7dKu+Bk3sIvDPgugpGuNhlVuEWi+bfuKAaFUToOnwZ6weadAObqeojLSNrOfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB5619.namprd12.prod.outlook.com (2603:10b6:510:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 06:04:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 06:04:39 +0000
Date: Wed, 31 May 2023 09:04:32 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: David Ahern <dsahern@kernel.org>
Cc: Benjamin Poirier <bpoirier@nvidia.com>, netdev@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] nexthop: Do not return invalid nexthop
 object during multipath selection
Message-ID: <ZHbjcNZbz3dhY9qT@shredder>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
 <20230529201914.69828-4-bpoirier@nvidia.com>
 <eb6a1866-7c71-53c6-241f-0a38a4047f7e@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6a1866-7c71-53c6-241f-0a38a4047f7e@kernel.org>
X-ClientProxiedBy: VI1PR06CA0144.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: e2660f42-c313-42fc-fd05-08db619ceb2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SbJHfyauMScQJ9sVhknzrx6AP6wSNje402aKcNTE8CLx7jKQDkN7ogAnk68aF5hBVv4r82L3ND3UFAfTjPC638of0O8qeTPuoqPhLmf8zWmTIyos095SeOcSigCxSGYDhALfiyZYSIlhUgYaU6TYjw6fzaZRwMjicg/XcbQTe9R4ojJgQrfetH07wLCZP2RZVwwsnPOBgyn3eHFVI7AxthpgVc31my1sWxLWNhKz452OAafZeasD3W3NuKwAzjzUVzvWrmR4Y6D8CWgILpASBxrWx/HiS/UVr/HSYCmC3mBWwy1cxdX5JInW1fAeStJ8u+86DmvSNkvzEB/NwK+0lEx3hDWc4qvaj2dyyH66EVWh/JXCDTzMEqMMX9ZmZ8J24kFZGRPb+WexKdSoE1Oycwm9ozrQk8YG/Cn0OXidWlX6XkyjXsGArwdkxTvPUIActtFMVYuduoRa5dgq0vMI+vrGnXPcLM2u+ZP8z3VCFJYgWK8ZW1Kg496llsmaljkqeDNk6T/W84NViJE+WiyAyCfMhO1520JuQI7MvqIBOcCAR0vCMHjCjr0eFYNA9Smt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(186003)(41300700001)(5660300002)(316002)(53546011)(6512007)(9686003)(6506007)(8676002)(8936002)(26005)(66556008)(66476007)(66946007)(6916009)(4326008)(33716001)(54906003)(38100700002)(2906002)(6486002)(6666004)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QJ/iCMUzynKpPS8GRBYY4NfCPRm89nBwvvsNhFfPU8YrqfcYahA1jk1VHmtj?=
 =?us-ascii?Q?O2PgeXbYOXf0iteTeZTSl090QnKj96zxNtnRkRtYNTNLb/zHLNC570EutxT9?=
 =?us-ascii?Q?VIg1usXOfohv80sKWcfA59KLZs2HSntrtGyC8oAFqJVgyhLkM8xkT1jlJXt1?=
 =?us-ascii?Q?UEpBrkq+42qDNBLS+gmoAfsSA8KTFMHKiJ3ArIC2wt2ybGgU3rKXX4WXDnqa?=
 =?us-ascii?Q?yEXlnh+eKNjz2rWuLc3nOgbCxr8nA9OKHNDHoyD+GVsB66uflQyxlCiLXMGZ?=
 =?us-ascii?Q?Pxx4q/9UPPcHsLqw9Avar0FK2q+TwvD0nkI8tjz8f5ey/1ypp5zoLM/5yyat?=
 =?us-ascii?Q?vQLmszA4nTEaqxpYfjd42mGMNuiud7+xMEp90el7hfH8/nP4cflU+pmXMKlh?=
 =?us-ascii?Q?7JfSJekvq7pPQH1n8rwXv4oCnV+pgpLepYkRA36x+I6oNjvnCTJte2T2WqzC?=
 =?us-ascii?Q?EiHn7+lhTESwzftjRP0L7pw+xPvkYgBmlK9A/gjmTMtJ4SJ4KSoaqf9W7HEV?=
 =?us-ascii?Q?miSxIliFCPIsKD1+SrAeg56ELsq6l+8pqX212UBgmddTJVBEQn+EeQj5JivK?=
 =?us-ascii?Q?8NoZ60kWnnFwNKNHgZQ8i+trdOHc8WFEnMmOeELvk/btk6N58HCGY6whUAey?=
 =?us-ascii?Q?ZQfvuVX+0yvXTdCsHVd3yBjzmjanpm3Icld6VKDD0yMI3054bi2BS6+2oC6C?=
 =?us-ascii?Q?23j8u+DzF75K7ky95F0OjQJ2IAahbSgZiitwD+ZD/aNRF5fBqJqBZ3RENJlY?=
 =?us-ascii?Q?R4cCqt+/doyYfq6yd0oW4vHMA/1ZpYn/BZzW8BIH/AeUKJROvCe5mPtF83me?=
 =?us-ascii?Q?69QfITtCrr8TC5BeRLM+lM6mEnHyElBpA3emtxlwsNFYYFdTKpHx+LlXeBol?=
 =?us-ascii?Q?fFSH+Jv3ZNRsyqpIoswKwZDfhy++PmvDS8hzj1bHiP5ZDj5MyofR7m7npSSd?=
 =?us-ascii?Q?2bh4bYon3o52YNaa3q1bxXoGTyjmMFeFJ3lz/27MmUxBBwyWXE1tVPtugP2Q?=
 =?us-ascii?Q?fZCFGq/WZXXomvkg8XnyGnqPhhw6xhMBDJOJIJ/kinntO5uNQVYNHdcQnMPJ?=
 =?us-ascii?Q?5BUXgMXNcEg7m7ZvcxExzTrlifxl3/GhsKITpzl9Fa36q/faCwC6WOHJvN96?=
 =?us-ascii?Q?YIBwLnyLFtodicSmNTNkOoHSjjEU082JS0Vhw7mg8wIqdSoB/8Ifv/2khbpx?=
 =?us-ascii?Q?8dfN6o2iPAUa95fHhxfvAsM/WGQa4NzxdMXj+INVFeO/zw7rgi8cShzAc6Ea?=
 =?us-ascii?Q?8a7V0/kKULOzLGYQWszlHEIDyN/1ySHizrlCeT9pntnUp6AgfH9Y8t4X+wEx?=
 =?us-ascii?Q?zvKc0sNC4rKuMGGmigKIl4lIXhg5gtToJ2MEioa3FxfDlZs71LWx0UWIZMQv?=
 =?us-ascii?Q?0aNzOebXY3Ed0nqzfbc3U78X4nN+bdHc3E/45SmDvSOxrwFp1nFMW2a81GUe?=
 =?us-ascii?Q?+38LolYGBizBEZF7XaVPfqX6C2CYQp13XErCnjAn/TkoCIMtHOQK7keCKBYq?=
 =?us-ascii?Q?/BYmR6mZA4xoEL6ZCY/JJ5Rp/9mtT3cfQE1tzOa/AaMZzf/JyqM+kddDhOUr?=
 =?us-ascii?Q?t4DY7gFRIcFnSAymxOmd+wPWhX9CnQ/ClqNaKHC6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2660f42-c313-42fc-fd05-08db619ceb2e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 06:04:39.3857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7jMTR3zmW2f8l6wr17mdYdY4imBTn2TWc9bCNrIe+LPn9crnms+Y0VMG+7p8CB0q50H4SKVIyEtdQ3TshGISA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5619
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 09:08:01AM -0600, David Ahern wrote:
> On 5/29/23 2:19 PM, Benjamin Poirier wrote:
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index c12acbf39659..ca501ced04fb 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -1186,6 +1186,7 @@ static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
> >  static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
> >  {
> >  	struct nexthop *rc = NULL;
> > +	bool first = false;
> >  	int i;
> >  
> >  	if (nhg->fdb_nh)
> > @@ -1194,20 +1195,24 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
> >  	for (i = 0; i < nhg->num_nh; ++i) {
> >  		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
> >  
> > -		if (hash > atomic_read(&nhge->hthr.upper_bound))
> > -			continue;
> > -
> >  		/* nexthops always check if it is good and does
> >  		 * not rely on a sysctl for this behavior
> >  		 */
> > -		if (nexthop_is_good_nh(nhge->nh))
> > -			return nhge->nh;
> > +		if (!nexthop_is_good_nh(nhge->nh))
> > +			continue;
> >  
> > -		if (!rc)
> > +		if (!first) {
> 
> Setting 'first' and 'rc' are equivalent, so 'first' is not needed.

Yea, looking at it again not sure what I was thinking...

Thanks for the review!

> As I recall it was used in fib_select_multipath before the nexthop
> refactoring (eba618abacade) because nhsel == 0 is valid, so the loop
> could not rely on it.
> 
> 
> 
> >  			rc = nhge->nh;
> > +			first = true;
> > +		}
> > +
> > +		if (hash > atomic_read(&nhge->hthr.upper_bound))
> > +			continue;
> > +
> > +		return nhge->nh;
> >  	}
> >  
> > -	return rc;
> > +	return rc ? : nhg->nh_entries[0].nh;
> >  }
> >  
> >  static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)
> 
> 

