Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE84D4300C3
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbhJPHQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:16:16 -0400
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:26209
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236688AbhJPHQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 03:16:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arkKu1nyB2qdgXU06aICSNMWy1e/a5y8D/FdHkNyKqxZCukFI3BZD1ZqrFsCovnCjpnEzfUJrSLtHCcIUSQeQhxRmBtG3Zg/48kw3rTLgsKjLWiFoJDd3pdxsbsHxfOuDjz5ND94m7AkafiCg9weMn4PxU0hEsLEWdG4u3nQA8pfKTkbARAnSWO+DaXtB4sxL/hK+8bExGZ13nCTsBBzitsuq42g7WB+wlGKxXq9WxuhMfi5WVhBA5MgQe4xgZIk1MZUn1lWWvbvpqJSIUCbG0cgOtGnrL6pbC2FSm6p2HtHZ92Ncf5rhgUp3YHRyoJcU7cByOQSiwTsAiOA0+u1Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0XDKH7659+gQarKx9cTolz8KbUCTq2i75o0R40msoo=;
 b=N2YLv0KOabH6lbLyDkeLpTd7wM0mQp0JZRtXbT4ftbTTXQFpZNpaq43l4R0M0YRg3FUgbB1TrUrvxox+uzExx0FCWcEP11iq74tQD1yaJQbffOD514RRCZNCvTaJRYPilxSZR384pS5PrslQqccU/hVOVsjixzNk1JCCAS1GLmF566S4QijdAdLFKTEp47VpDPWtFapBlRxSpcpn35TehfbjiWzbX3tnR7D9PvIg7TUtYJjWSFFMgjm9vqmgNtT8DdXdh332ZjbE8c6ZWGUQko37waOG8tntZcW+fMYpUYZ6To2x8PvyyCfqtLHww/IIKG6TUvy9esDGHNGerkzvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0XDKH7659+gQarKx9cTolz8KbUCTq2i75o0R40msoo=;
 b=urUDJilW1o915Td4wcO7orScUk2KIu6h5kyc6tXHdDSjA0uA399Y7v9AF4M2F+V/hNoF4dj5YepGgZivP+b2FHdWgP1g61okuXJmpbm9qn5LVZ7eYVq+x/kDZGmsWHo/b5XtWlPsk69l9h/u/Ei0STbayXtT/iSwN0TKnfT2JLDztM0qhF+wZE6VX5I/S+qGVQRN8AWxC4Cz8wmA1GEoq6D1mmN2pfEoo5rIBUhtg8fHGbcw4CoiRe4Ti/p2BeuQ5SThDvlPl4XgvdeEC3g9G+vcj+Olfwrz3hAmpbEVL4uFX5UHV93aUkD65efrbrtybe0lrWvR2ho2mGrWltQTPA==
Received: from MW4P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::17)
 by BL0PR12MB2420.namprd12.prod.outlook.com (2603:10b6:207:4c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sat, 16 Oct
 2021 07:14:07 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::82) by MW4P223CA0012.outlook.office365.com
 (2603:10b6:303:80::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Sat, 16 Oct 2021 07:14:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Sat, 16 Oct 2021 07:14:06 +0000
Received: from [172.27.0.87] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 16 Oct
 2021 07:14:03 +0000
Subject: Re: [PATCH iproute2-next v1 2/3] rdma: Add stat "mode" support
To:     David Ahern <dsahern@gmail.com>, Mark Zhang <markzhang@nvidia.com>,
        <jgg@nvidia.com>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>
References: <20211014075358.239708-1-markzhang@nvidia.com>
 <20211014075358.239708-3-markzhang@nvidia.com>
 <a01a1b0e-90a4-c14f-fa5f-35a698d5b730@gmail.com>
From:   Maor Gottlieb <maorg@nvidia.com>
Message-ID: <500bd7ed-4d49-5426-321f-158b55b4138c@nvidia.com>
Date:   Sat, 16 Oct 2021 10:14:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a01a1b0e-90a4-c14f-fa5f-35a698d5b730@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1443ebaa-0249-4618-758d-08d990748a81
X-MS-TrafficTypeDiagnostic: BL0PR12MB2420:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2420AAA164284E5FED0CF19FDEBA9@BL0PR12MB2420.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:133;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HixvKBthzArIzb3V+w2aLL9Esf/VrmS9CPHFMgp/SzXXRPxqKSE16uwjQiAZiYlTFxz8yqMorHObHPrDmcKZUFhEOH2DszLaODmesnNpbcsqvl8mVgkmi7gHOiKdz6PZkT79XbHq3J6kVVd7HzCveyxB+yFXlEvZ8s89c0ZScgW6mQ7pSJiuAWuB3oGNXcwkT64Krsz2GRtQXf/ZQLauR+FxDaY1MFHlJOS7t0ohYzJRqCpsWW478eZ67BwjlLR/hwuFmXO8ysDgaET8fAinRtbfD9T61hLw+Yu4tHYv7MzZPJAyH19zT8+mDLsVWeF03hku4mEouo9Z9h/maOLDsCe3bNp7ClFTSk2BazZ5IXh2baLlzp8JIuoWKf5M4rNtv65PKwrtl62aHDtK+ewA1o4p/6LLODjFrN2jkrH3UWZiweL/qv8O+AgPPz9WCVE0AQJy+Nl8hI4R2Sq/fl3ZMIITAe9cG2rp7ppuVrJR+CXUYhmrOoQufcIkdMsnydtHRkVMOxi+Tczmvzrk2xMUqz0XrjyPMxl6IfviZwPPz0fGoI+PAR00pd2bhSjD3QhltXhb/pXCqQ4VEtKngNyEjiuGSWzf7j6xNJsvTiC9XiI0eyBdGXeBthPS1kyLcurLnxAOAdwo9Oxvdsx0d8pZ7GnqPy7DxCUg5ygyvtuulMrs85myeXSUIq+GdL3USQDnPSIi+KFKxZfgvC5AhZZuReXH1WpTRfHUf4XTNjs4LLc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(47076005)(8676002)(110136005)(36756003)(2906002)(31686004)(336012)(186003)(83380400001)(82310400003)(107886003)(2616005)(6666004)(26005)(356005)(36860700001)(16526019)(508600001)(8936002)(31696002)(5660300002)(7636003)(70206006)(70586007)(53546011)(316002)(86362001)(4326008)(16576012)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2021 07:14:06.1273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1443ebaa-0249-4618-758d-08d990748a81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/16/2021 2:56 AM, David Ahern wrote:
> On 10/14/21 1:53 AM, Mark Zhang wrote:
>> +static int do_stat_mode_parse_cb(const struct nlmsghdr *nlh, void *data,
>> +				 bool supported)
>> +{
>> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
>> +	struct nlattr *nla_entry;
>> +	const char *dev, *name;
>> +	struct rd *rd = data;
>> +	int enabled, err = 0;
>> +	bool isfirst = true;
>> +	uint32_t port;
>> +
>> +	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
>> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
>> +	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] ||
>> +	    !tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS])
>> +		return MNL_CB_ERROR;
>> +
>> +	dev = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
>> +	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
>> +
>> +	mnl_attr_for_each_nested(nla_entry,
>> +				 tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
>> +		struct nlattr *cnt[RDMA_NLDEV_ATTR_MAX] = {};
>> +
>> +		err  = mnl_attr_parse_nested(nla_entry, rd_attr_cb, cnt);
>> +		if ((err != MNL_CB_OK) ||
>> +		    (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]))
>> +			return -EINVAL;
>> +
>> +		if (!cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
>> +			continue;
>> +
>> +		enabled = mnl_attr_get_u8(cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC]);
>> +		name = mnl_attr_get_str(cnt[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
>> +		if (supported || enabled) {
>> +			if (isfirst) {
>> +				open_json_object(NULL);
> I don't see the close_json_object(). Did you verify json output is proper?

I verified it, the json output is proper.
Anyway, close_json_object() is called in newline(), few lines below.
>
>
>> +				print_color_string(PRINT_ANY, COLOR_NONE,
>> +						   "ifname", "link %s/", dev);
>> +				print_color_uint(PRINT_ANY, COLOR_NONE, "port",
>> +						 "%u ", port);
>> +				if (supported)
>> +					open_json_array(PRINT_ANY,
>> +						"supported optional-counters");
>> +				else
>> +					open_json_array(PRINT_ANY,
>> +							"optional-counters");
>> +				print_color_string(PRINT_FP, COLOR_NONE, NULL,
>> +						   " ", NULL);
>> +				isfirst = false;
>> +			} else {
>> +				print_color_string(PRINT_FP, COLOR_NONE, NULL,
>> +						   ",", NULL);
>> +			}
>> +			if (rd->pretty_output && !rd->json_output)
>> +				newline_indent(rd);
>> +
>> +			print_color_string(PRINT_ANY, COLOR_NONE, NULL, "%s",
>> +					   name);
>> +		}
>> +	}
>> +
>> +	if (!isfirst) {
>> +		close_json_array(PRINT_JSON, NULL);
>> +		newline(rd);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>
