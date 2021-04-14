Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267CA35F778
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350383AbhDNPQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:16:57 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:54522
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350308AbhDNPQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:16:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZQLw7+FUTvGAoGwqPE0MpXHLrte2b0qlbQgCjKRlfsP40BXOEgV+Y3SoHcB0OL37I4fA4/tVGT2ss2FW8zcVCYJ+UecDnupQnuoX6m+1SvQubqUO+7xzlF7tringWziThCZq8Q56omgMAaPEAm+sQ3YwH69J5vip7BNtDtLAU3yGze+FJw9Yn7iKd+4cxpkWzu6r/kOOWavi/Zdj6ed/9J6h8NopN0u3w9BrEm3GraVV7sHX9upBikXyQWNKac5uLQ1yFwYlKb67Lp+l4DULP4b2TqA9aL3ph9g/jgetguh/WPbMdYzt5WiD2FBmgmQYHD3igZHGfA9wQtDpNjLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl4Vq+FM+XZa1GxKCUK4AeILhf2HcpKwnpbIFnCz4RA=;
 b=JbDXsToG/OrSsl/pYD+iIR1nYcNmLNFToEwdJ50MhxscZ+F9gzJuswPc1Q+C2tkVcbY+dBfkPTulhgLlt/IwKd3caKPE6Wnx0WlTrEjuI933QnTLwfYdk6NEdrqhTmRqzud4jnTcfq2Nw8ePVeJ1btPvZYKJCPXc/TASwNoendfOegu+T7OyTEOpNLPVqlBm0QsMyUpAobXuj+c0sDESklTTcoxcxLq6Nf+oq2W+I9b4H8tjYRN/vwKGrG3lE79OW6OhoJAkOJuWVo8ukoUrw/5x1eembGPJF9ogw/mct0isYKKoz+fb2PHzZ6eAaCfPg7PNllKJHJi22m8ozh0AfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl4Vq+FM+XZa1GxKCUK4AeILhf2HcpKwnpbIFnCz4RA=;
 b=jOeInLJStHivmspjD1FYnBo4ybUE1edOutbtZmZZ2fmg9srBCRum/vuPQG+XyXfhFKpAlfh5g9XPGV6uGag6i/OFRC0TZwGbks0JGVPEMmqzZi+PIV34MKUyrUJBUw/nlgD/HQnagxmFgKTMPQ+jkeNXuryh2+2vhuBy77Osj5h6TDqRaX2CDuTKCLjD6EPxQLq5EXNWMYMKjk1CPhNmfvG132+BHL4sbf4ouB/KTil7LU91qe2n+PNwnFcV8y5AXLDVowewUW4eZYe85WoCNH4ONlJT6Ag4wsTyKqpm7SnAGM7tOVlec7uTPXsj6OOlobrcDGExmFb5p+m6jxEluw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR1201MB0252.namprd12.prod.outlook.com (2603:10b6:4:5b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Wed, 14 Apr
 2021 15:16:16 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393%7]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 15:16:16 +0000
Subject: Re: [PATCH net-next] net: bridge: propagate error code and extack
 from br_mc_disabled_update
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210414143413.1786981-1-olteanv@gmail.com>
 <3fb316d9-8ba2-78d2-ac0c-1fab5de09da8@nvidia.com>
 <20210414151333.jvrhaesom43cwpcp@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3f27f154-c770-72bf-c76f-f7375089add8@nvidia.com>
Date:   Wed, 14 Apr 2021 18:16:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210414151333.jvrhaesom43cwpcp@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.177] (213.179.129.39) by ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 15:16:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f257ecd9-c42e-4cfa-cc37-08d8ff583f8d
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0252:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0252A987DD6E20AA119892EEDF4E9@DM5PR1201MB0252.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ppD8fqwgATqPxoKhUTDto2+dCykZVv3JyCT7pcJcEno+L00XWzemm/rE9s9BqCjpCcs70gq7B2jkq86aJT5uSlNaLqHYwZrtYRFvWYuJ/fgJCv9Td3zJt0NRTSNzyEs9WR+/Uck4pymGsJJHLxk2WuYajTMuwREHzNYOBIzqtYscvWcnTdjda3/BwT/YgVMEFo3D/poKRhHHWZ/XnRXd2BC+rMleyCRlZpxHOkRSK1sPGaX3p7quCzMa2HWtf/Tcc6xJcZfvgJflRIRsFdNnuTVM3qj0GUZCf570csGpgxDXmYkdL4JvQqijOLexE/OnbdI4v2desXr6+Wjxdz19fCBd49pW+BHJ4GR2vHihgBEfccvZjmi5ac4Hb0DnBbeTo345LFk39Bp4WXFi11O4okSawcLo3tOrB+UiVVWjqEQon+MsVmp+brick8PEU9IXONFJTn9m2frDuslCZE9JUfxODqr4ZUepsHlGxKF5Jtgw9OHObHMCdJrWUpQmkBbkCNktmpdrBJUT1Kuo7GkBNKgMFprs3/3eebKVDk+Uu9si2uKfXnkFG2o5ChMICafAlUJndU/U55VujUlG9jHoeXjiUHfA4lG4X4iS7yfK7JEg+poeWGhurbz6qfwPwGaUr8bysnHuT6Ll2tPHzfSDGJlqax94Au6/XKztnyLciEne7aJm8ZdwOninGiGKZpsK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(316002)(53546011)(31696002)(956004)(66556008)(6666004)(8676002)(31686004)(4326008)(2616005)(478600001)(6486002)(38100700002)(54906003)(16576012)(4744005)(186003)(8936002)(2906002)(86362001)(5660300002)(36756003)(6916009)(16526019)(26005)(66476007)(66946007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ODlZVksvUXVyR1pCTzMwZXBrKzN2NUpkb1VyZGNXOXozaG1rM0dIdWpIYmIz?=
 =?utf-8?B?bXpsUy9QdXFYazErQzdVTTFFK2JIMHM4OGwvSWhwdkJodUd5cXF5ellPS1Fl?=
 =?utf-8?B?RHFHMVdvQllBU1dYWG5RRjZzMmUvMzArbXUrTDNFTjEyVVYwZlhBLzI3SklH?=
 =?utf-8?B?Z1B6YjNTaWR2djRSc25oOW8vUzFYaFllWW14THlnV3UrM0UwOEJHYkNDZU5E?=
 =?utf-8?B?dEwzTmE4Q0c4ZGFCYnpwUjJiVzRXSGFOT2twbU8xOTJ0azRyNEpyRTlXN2Qx?=
 =?utf-8?B?Z1IrR1FrUk5UaHg0dDkyTWQzbW0vMHhOOXZ0RG5IYiszQis0bVk5LzR2V3k2?=
 =?utf-8?B?Y0VYNy81c3pPcU9DYWVPS3ljeW5ldzBOUnd4OFRPZFVVZU0zbDRyT3RRRzR1?=
 =?utf-8?B?OFVrS2t5U3lRcVp3SHAwNjFNOEJzVTB3Z29iangyL0pwSGQ1bFVVVDc0MlI5?=
 =?utf-8?B?RWJROXA0TmNIVGx2Z0NjRXhjazFKYm9EL0VsRlh3M0RmamdBMGdzNGJ5aE1r?=
 =?utf-8?B?Kzd1ZytXNmVQMk1lbWprMWt3UnFjb2pyUzV0UlBnRk5XUWdMZUlNaDNEVXNF?=
 =?utf-8?B?bkZSN2NZU0NleWx0N1FiVE81SHBheWR1R2x5eDlDZXlhckJtdVUyRGJKaGtl?=
 =?utf-8?B?RWJzYXFEb0kzT2xlUUhQQjRxOG1vdmthWmN2ejhiVkE5cU5XRVFyb3RaTnJP?=
 =?utf-8?B?eGV4V2hHY0xNdWF3UDRCenF3Zy9LYnZ3dmVFUWN1bmU4SExodklyMndsaEt2?=
 =?utf-8?B?L0NmRWlsUS9CcTE2djkzcVFxTDlmZDJWK3pLblRFNmpoOWRWcDdwRzQ5MEtq?=
 =?utf-8?B?TmFteGE4K2FoY05kV0RkVUt1SmZ4azBvVURGR2J2VmhCS0xDOTNtc1lYcDdk?=
 =?utf-8?B?YzBFL1pRbUZ6dFhlVjVMMUdoL2J6KzQ3ek9zYnZKbklVM25RMWJvMzV3OUt0?=
 =?utf-8?B?a3hHNjcxRHE3THR6MklFQzZoR2RaVk1PZnc0eVVVb3h4NjYwY21iTUZFWkJY?=
 =?utf-8?B?Y3Y2T0tBZHB4SUVDbkE2UllBcUVSdmhGUzZQRWtUT044cUdqYkI4NmFpdHhi?=
 =?utf-8?B?T09UTGRYRzFreUFGOWl4d1JNME12UVUzNE5TVmM5MDFHYmZXMllPM0h1Mjd6?=
 =?utf-8?B?K2NlaXlkSEs4eGRFRU12ZEVMRGRkZE9EaXkxdjJZcWFQN0xmS3pwWlBEUDlK?=
 =?utf-8?B?SURQMFFIMFRyRkorZWJ6YjFNUWRmRHJwYjhYUG9tMC9RQTNJZkVsZ1d2WThr?=
 =?utf-8?B?TTNKUDdkMnhaRmFmK3BBSWsvUEJhOVJoR1ByeDl5TUZwOFphS2x4ellrWksz?=
 =?utf-8?B?cmRzcXRCdXhmc09nRk9CSVo0OWlONkNEWnVpUnVvbEZoV2wzNWJlUnhrMU9F?=
 =?utf-8?B?UWlaZVJIa1BqS2Ird3BXTXZ6enhBaDAyeVBDblFubkc0MzNZWDZ3N2xDcEdG?=
 =?utf-8?B?cHRUOS9mQXFWRFVYcmxlWmZSeXBUTmJJc3o3RTdVSlI4RThTL2JjTlJRQm1D?=
 =?utf-8?B?VHhvV3dHTnVabGtMK054eUxVM3NvN2xKOTMyaWg3c1FielhoZE9ZUCs2bnI3?=
 =?utf-8?B?TUdaaC9vcUVuVjJFdXZtSWw2TStac3lUVmYrRUJDcnRxZVFYTk9FNzR4QUdv?=
 =?utf-8?B?UGpSaHpVVG5TaUUrUDZRUm15MlR4MFMzMUhaTVgzTWh0WlA5Ym1PaU85UHFK?=
 =?utf-8?B?VFZhZGpIbitwenFYSEhkbTBteU5ydnBRVjBWdisvaGVySjEyWEpjVW5RQWtv?=
 =?utf-8?Q?yIACmYl7WL+cktg3NhiscZjyJ99uxfhE7qTgSuv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f257ecd9-c42e-4cfa-cc37-08d8ff583f8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 15:16:16.2701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCkahxonVDXRU6tCoA6ZRrBpH8/GevZ3A/Sd34aownW6Adb38B6vpLjQxWGTpCXsG5GkCYDJBLIssuoSuJfaoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2021 18:13, Vladimir Oltean wrote:
> On Wed, Apr 14, 2021 at 05:58:04PM +0300, Nikolay Aleksandrov wrote:
>>> @@ -3607,7 +3619,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
>>>  			br_multicast_leave_snoopers(br);
>>>  	}
>>>  
>>> -	return 0;
>>> +	return err;
>>
>> Here won't you return EOPNOTSUPP even though everything above was successful ?
>> I mean if br_mc_disabled_update() returns -EOPNOTSUPP it will just be returned
>> and the caller would think there was an error.
>>
>> Did you try running the bridge selftests with this patch ?
>>
>> Thanks,
>>  Nik
> 
> Thanks, this is a good point. I think I should just do this instead:
> 	if (err == -EOPNOTSUPP)
> 		err = 0;
> 	if (err)
> 		...
> 
> And I haven't run the bridge selftests. You are talking about:
> tools/testing/selftests/net/forwarding/bridge_{igmp,mld}.sh
> right?
> 

Yeah, but it's nice to run all of the bridge selftests in there, sometimes
unexpected breakages can show up.
