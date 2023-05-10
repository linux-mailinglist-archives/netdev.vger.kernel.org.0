Return-Path: <netdev+bounces-1551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6076FE479
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DBCF2814C6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D807C174FB;
	Wed, 10 May 2023 19:25:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37AE174E8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:25:52 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CDD1BB;
	Wed, 10 May 2023 12:25:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ADwpn1005079;
	Wed, 10 May 2023 19:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=az50lt+ldPW0wmeqnfaQj47l45iFhFVzMISNuXek0Yk=;
 b=gMLOB7ZYA/z7fC8G3I7ZiOS+7/pSOCJeMx9D4jY46sA/Lkw/9qEphHHQfxHXnWJb0Y/U
 SUohNb8t3pg65ABA9G6lSr0HuIXUWGqpALnULodsqj43PC5tacQMyRagn+p3dh108EYj
 seyUo0PHe6URzEkcKqJlPMIBTOKp6T165x78p2poBgmPV3LrZvSN5dItsoV3BQ6Zn/Sf
 3jfmo5KBkcSnHyxjERK1IZTJedYDJky+CVORbiUvBZCYKdMYJhcEeQiTy4moPfzfNex1
 YrAL9VSEDvsSi8D53peLqD5PlfDZRBNyqvUH3D8XsIZgietr/Rw1fWB/Anuh5A9lVdhK 1w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7775ega-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 19:25:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34AIR3VS018136;
	Wed, 10 May 2023 19:25:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qf77htah9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 19:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzoJ/891y8emqYiZt86BFgRcRrarawn7H9JVvc7zk2UdlpBZ1Or0B5J9IqnYW5kKcrfvX0iL3Ojdn7uj5Nlp27Ksir+69FKXpopRHQ04gXC4+MOFAoYP75ZQBKq+tSXnic1xymiuEEtZaQOhobYqBjogPUNexiJu2iBrZvecEuLmayeE/6sj7fOt9Tq96pA8Z4jw1rlzunAB4kXC1DOM7WmRJ7015f4/Xzk2OSw8BHHzSjY1z6mP92DveuJzl/OFICpYS8hyVH0ojAMk8KjSxZiglwKPYvuO/dwb7OOcemBv7wZFhps+UK6iNwXHHY1/4QDPxjZivFwOWl0v/9KsQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=az50lt+ldPW0wmeqnfaQj47l45iFhFVzMISNuXek0Yk=;
 b=WZKOeGzKQWt1GVvszRs2E4df44x0KUmpgzwYnZQHPZkwLbhCHVOqfFpnqX3SBOsC01PuTyNl/SPm5UvyrXfd65AFwcWEfUGCOgC3nEhuqdfNmc6xLexLT/yP8HuMuEKgTgKbUtEDsw6HSO5yugJeRBcBu9ZY1qa1A2dZKj3I5lguxakr1fGjG38w3Vuo4WtV3wKrh8jURa1I/5rPspB3LKSp3HJfo4P91Z4zXPEILPLEUaW+7rd7AYhpBYlMM9bMH+F1Hm59pQ4c8roPXBQ/sCKa4iW6xAhdOQPz7A9XMiLs6cGOOv0DEhbPFfQGfhthT0SA5vK08N+YW4OPAK/hqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az50lt+ldPW0wmeqnfaQj47l45iFhFVzMISNuXek0Yk=;
 b=nK3ZFUnna5TkbgNd/4/lLaWhi+gMbpnYvTwDmOS4lWG/3bpMoUKX05ZfYlIrlezWSe9fbp/BkNJ5a2XrMuMbSJJdw0mSFLWpfu5WrV5sHBxspy0LJoqCRbzOuMrv1Gdviou+zQZr34WwXu607KU+dI3NjOubtFz0gcgVMYjWA7Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20; Wed, 10 May 2023 19:25:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6387.020; Wed, 10 May
 2023 19:25:43 +0000
Message-ID: <7435f1b2-a5d6-4189-6153-0c18889e9440@oracle.com>
Date: Wed, 10 May 2023 12:25:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH 10/11] iscsi: make session and connection lists per-net
Content-Language: en-US
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
References: <20230506232930.195451-1-cleech@redhat.com>
 <20230506232930.195451-11-cleech@redhat.com>
From: michael.christie@oracle.com
In-Reply-To: <20230506232930.195451-11-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 554b2779-2535-44f1-5652-08db518c5887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bsD7a6vyusuCdl4oh1DAu/L5DHoxv/EdUq56APMCkjUlPfHYdSw3za7cGZj2kB6B5NM7IaTzTQ/6wOqCNgusNkEUVNN6FFuXKUN+5MYTQMLgsdZwjrFQCey25NE/RsJ8tkYkfkmBXyzf2gjqjxWpBvN0Hw0jS0+gDmMuZzjTZw4a7mRzbja4Sp39WRYsrZL3WReWJVYx608XcX1aFWivRLAJ8iJpKoNeHaVhjomm6UOfGuTRN7YOAxHLacQqtVre0j1DRh17Fvc6lJ1VkPcuvonEeJ1Vmdebow2JamNdxgGmTzAfddJ5W8rQ92HaZwZtB9Xfsc1gu4iIQSCd75DiQxrZgv5YVTmM6l1dhdQt0uDtpy8GR61apZpepIiOsjr4DQ0MpL0awt6wTrZTqbON0W6jR64Pp76hsZ0uTR/IB8LVnoPcUoCNn0kk3lOhODSQsp5r1j43a3WlHKFgsZLqPme2GDcndUxGgUZypyOXOFWHXQMK2akT6KU1M41IBMFrZSx2yeqt9HWAV6uiKbkdW4zJIR2PJtnylnzS9R1Ffl1ib03Y310vx2rlrEXI6PGj2Y96SyMVy7qObNDSch/uCTQsb9MU6C3TEhk8n9SFpRWl+ojMXbcHoqk5Akw06KwA
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199021)(478600001)(31686004)(8676002)(110136005)(86362001)(6666004)(6486002)(316002)(31696002)(66556008)(66476007)(66946007)(83380400001)(36756003)(2616005)(41300700001)(8936002)(38100700002)(2906002)(4744005)(26005)(6506007)(186003)(5660300002)(9686003)(6512007)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TjJnY3hoenlpbUF3dnhPNllmajJVY3Jaa2hXVk1LY1Y1SWpEQzh1THFxYnQ2?=
 =?utf-8?B?ZXo3aWYrVktCU0ZzVUc1R0JwRERQcldrMVMxSXQ3TjM3Mzhzdm1tblRjN0Mz?=
 =?utf-8?B?SmExK29acmR4MDZqdVJ2TGpZU2lMcG5rb3M4Z3NpQnY4S1Y1eVlPQTJEWGRN?=
 =?utf-8?B?L3FSeCtPdEx1VXg0MjF2M3QvY1dYNVZwUXlCRG5QZnUwQjZWWk93RDhVVUtl?=
 =?utf-8?B?Q0RPUFJ6aVh2ZGRYNk9xdHJ1am5ZRm5OVTc1TjByZDhjRTJCY2NDenFDWGdx?=
 =?utf-8?B?bjkrZWxqd1RzMGZURDVBQXhtT1dvVkw0Vm1pUWFnNGRCbC9DQ1ZqdmlEb29Y?=
 =?utf-8?B?bkg2UnFrQWJwakFnQ1lYTWlRRkN0TkkyMGx0N3hCbVJZM1Jqd25JclprRXlk?=
 =?utf-8?B?aVVTQnVscW9EaVNzeFp0cTJmcjROR1dBbVJaT3RzRnc3eDFZM3d0Mm4xZTB4?=
 =?utf-8?B?L1ViaVd4TGk5VHlHdlJ4RGpJVk5TTmszS0VMRGhMNHp4NVFqZWNpU2Q1dUpS?=
 =?utf-8?B?WmIwWDYvcnl4bUl3Tnp0b08yNXFYd0JQRk1jbFZTUk02NjNWaDFlbjI2MEJR?=
 =?utf-8?B?cVdHblVESXV3MXFWdWUwVnNzMFQrWUQxZkJpNUEvRFczRlJLZk4xcjVxaEZo?=
 =?utf-8?B?VldtR2s0Z2NySXRFaUlyeTlCRU5lQ1hGMWR4UjRXN2RlemplRWpvWXk5OHF1?=
 =?utf-8?B?dGFacjJ1ZE9HUHR1ZW5IU1VHNEZTVEJkaFZTZm5nRTMvdnlWdXJDMmFKdkZB?=
 =?utf-8?B?YlNZVTUwb3prcDJWSS9JTTY3K25UMk16aFpDSlUyUWk0YXZFUWF1Y3ZlVjJ2?=
 =?utf-8?B?a05VT05lS3BJSURUcTc5SEJDNVVJQU4rMmxkNWxNNlhvNGxNczd2aFZCNkhL?=
 =?utf-8?B?bVRZejl2Wk9HZjJYMU5IOVgxTlpmN2hwTkNpMGxGaktyMGFhR2tnbUtkOFd2?=
 =?utf-8?B?aGtGL3hCRmhDMlJPV0tDdGJPV0R5eWNDUy9KVHV2bkFZQmVJaWxCUW5PYjhQ?=
 =?utf-8?B?ZGEvSXBqR3VBdHQyWHFSaitpYXdQVEdDNjVncXlHNjNwZjh6K21mc3JGWStn?=
 =?utf-8?B?SXY4VVFPcEJhWlFXZHhYallTOENQOURsc0ZWVUtSMkhxNmYzMnhpK0FFOHVK?=
 =?utf-8?B?L0c5VlNzT05TSWpnQXRKb215YWFuRFcyZU40N25tZTM4eFZkdVZpZlpHVDRZ?=
 =?utf-8?B?aVRjeXNseGk4QU8xTEhSdnFGeFNQaUtvbXUwRm9SNWdMb0tza1FxVUc4YUs1?=
 =?utf-8?B?QnVMbjV6R01EUkZnZkkrMG5TUW1XYzRuckt5STFqT0hYSzV2UHJZMUp4OG95?=
 =?utf-8?B?UFdML29ZUzZ4aFV3L2YzSm5KeXh3Zk1iOU5ZMExSYlB1Wmo2bjZLNEE1M0dH?=
 =?utf-8?B?SG5BcStlcDZqb1VpbEhtTkR5MVdMU3F5UHozeTRFMjBzMHBseHZzbDF5bE9I?=
 =?utf-8?B?Yy94MmxEUFJ1NlNBbCsyNXlIZmMzSkVvV1RqTTN5QnRNNVYwN3ZZMC94SWpj?=
 =?utf-8?B?MEo2Q3Rzd2I5VzQwdVZZVDlqSWJGUFRSR3hsYzJ2QllxbEt6NzBZZDhUbWZ1?=
 =?utf-8?B?b0FVQ0ZkbkJnRE9ENjQ4QnJYSWZib0dNakpyc1B6ekYweEM4RlVxMExPZFVo?=
 =?utf-8?B?S3BUNEZsRlhKTi9XOVEwekdSQStTQjRObGY4RXpkZXVORXQ4WjVwMWpYSmxs?=
 =?utf-8?B?UTAvL2xGaDVPNmYxSUUwYnVqQVI3QWVVTjhqd3VqQlFUVjN3UTB3SGE3Z0Vq?=
 =?utf-8?B?VERyVmpQNU1BODY2Ujk4dUVmakk5YXozeWdQYmVrSjV1eWlQM0Fhd2FLR0ow?=
 =?utf-8?B?UzFjZFlET2FLSG5RcXFMMWVWL3VZSXhNWUxjTitVajg1MHZLSllDdmk0U2RT?=
 =?utf-8?B?U1JhMUZnQm1xT01acWo1OVNjTXYydXhmZnJ4WkZyRCtSSFI0aU5aNTJ4OFFz?=
 =?utf-8?B?UjJjWS9Pb1BtR3MySndTWWc2Yld0a051VVVPL2czd0RDTW5SQ3dYM3l0M1lU?=
 =?utf-8?B?aGk4SmxUV0NYOHBURk1ob0x0NWtHbUNvdXV4ZjB2bVN0dklBSWZXMG00eDNm?=
 =?utf-8?B?emU4TDhRa0ZrUWJwOHUvMXVEbklaaFVqY2R0MEswbExBU3pwVnJ4bk5Ub2lT?=
 =?utf-8?B?ai9YeEx0TExiSmJwZWFmUjZVS1kvWE0yeTRnd2ZpbUJhWDRPTng1U2NPUjl0?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NLngfvFh/AOM21md+b3lM7itQj+k83a/QX/LYrbgSiGxajd1aXoUZ+XPx/aro9O2dYG5ROf1G18IhvpamwZK8kn9eB8wnoU8svDl/rQKOuNw362bbqYoIjWCwfzzHMdQ3q+Rjrc4ByTuz4nbFsz0aoajnbfP4S1MUzYmDN4nA1pu8v5J3LHMyZLTYVMSNFIlehgYCNoK2ebJ7/3JOGNpyll8RUuj9/EELhQCqPbYwbZlFC+yhRe4pHyt7u4kWqcUgtpyM3V1mS/iYXq2ihFDIY5+hW652vqvwkZbGgv/9yEBnM19GYS5No22qHucv7rg1TSM7xE85ZxtyZHkV4ma+EY3NpttAqItvVQ9sj9upWpBs/K8fUhiZkeUG4kweLBn+w+117MJRtaTpLB4FOjAvYYpvk4VlcCppZdfTlLJGU7XKi4HCZIAqZTlzR3gFsdTkO0R9AQapOZyn+/nFCPVZ+AZ83QPiPJBzrKOL0Ze03M/E/nUjeLrP7calb8Frgszv9bu7lQ7M5aDip7kehw+oInfLgPWa3WPiBN019H6aOX8NOh5XqlitT9XdZImL3fvHIPGKFRopKPEaFC97BNVoVMWV5BnT7ij0KuOVjiRgzbhIPMeY4EZAvykxoPRKwhKemHaifzN5XHPHXUsya4hkai07S5DuDTX8GQ/sUD69KcWzTeQCfsr3vCYh2+cFJjFW8KxMrg2MNYKaqtLV6Ubg6GAjgk/bHuXuRKOl3B4ABMGd9pjU1ETfRTHdQ8Ge8tfjYKVLmkPawT+uYPv9/6jjH8SmDMOC+c/dosipZ+H3g5j21mnUkBLCGQAlqjW9VKh+yiRgt/0W98oJ5I7BUJ5SEULHX/6ai46jCp4L6EiB+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 554b2779-2535-44f1-5652-08db518c5887
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 19:25:43.0688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +3gruN31o2xoRJCnolAcRsmEyPZ9wJ3S8R+EtVOONlYd+Jdg+1u/eKigFuXyhPn/gtbEfI+ZUVWV9d2R6Np1kh9KAhD9Gqp9793cIpTqn+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100157
X-Proofpoint-GUID: yiRSk5wWseAUhacGEHUtWa2kvUQyGFG3
X-Proofpoint-ORIG-GUID: yiRSk5wWseAUhacGEHUtWa2kvUQyGFG3
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/6/23 4:29 PM, Chris Leech wrote:
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index cd3228293a64..15d28186996d 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1755,17 +1755,16 @@ static DECLARE_TRANSPORT_CLASS_NS(iscsi_connection_class,
>  
>  struct iscsi_net {
>  	struct sock *nls;
> +	spinlock_t sesslock;
> +	struct list_head sesslist;
> +	spinlock_t connlock;
> +	struct list_head connlist;

Instead of lists use an xarray. That was actually one of the TODO items from
Lee's talk last year on lots of sessions. You can kill that and do iscsi ns at
the same time :)


> +	struct list_head connlist_err;
>  };

connlist_err is not used so you can kill it.

