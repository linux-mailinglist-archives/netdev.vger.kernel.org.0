Return-Path: <netdev+bounces-223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF896F6170
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 00:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 960B9280C4F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 22:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652A77484;
	Wed,  3 May 2023 22:49:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC423D2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 22:49:35 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D3A44B6
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 15:49:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuOmVYXjUoF4pyVoZ+V/q1dx+lfcytJOl7+LtRbp18FFVFsC1AMs85sx4iQ2f1k5L0lwT35mA9EjaSiorBlqgKyR45s6TccAgWrixpgn3d0BWsrg4YdlXuUsryADneX8DIem8c9NVyPm8BSaJNhI1HTAu27WvE9T75qO+Kt0aO3w64f8iDiXPZaC8SbZrwupknQlqtoRtQIMqElGLsGUt4U6Z858/+xanSCFl33/VvyIcSWiKAbz1SVcqIcHiLqVQyJm7GTFkw2YWKM/U4Xd1rC/Vx6N7Z5M8aiHNbA4eK1BSTPx6W3bN6304YZvgDIQqoagcOml+HimFh/RfVsGGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdIYgcjwpbEvPPgqX7yrrXw7Yy3VgaPP2NxaKBt9oIQ=;
 b=DwvT0TXCP7fwPc2tbnpsot1/bcjR9xCUZuvWKIjuGVaZs5FDSB6Fk0tDt80SLYpk2ho6XSci/TjmbR6M1cslCoxs35/VXpGXdZa1868GAWyloeymOQ8GBhLcnFE3B11SdIS94RADVhiDl3tzdW6RW/97BYLhf0f8uBVGkrA0WUBlmdjBjRK77Z2iaOP2vNogG7wCcdUjdTjJWY41bGoyD1GYpxWDh554xvhlWMZT56t8JkN0dX7mUEvRbm20B3cvBMJnsE4oKQv6bUAhcQ5Qyy8g4mDMxgf4xPOZzYvU3jSxa73f1VYKtlPwFzroRF0+AD9w8fw+0Zu37fZ2eqkezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdIYgcjwpbEvPPgqX7yrrXw7Yy3VgaPP2NxaKBt9oIQ=;
 b=U0Gtd3211t/eHi4+0OrtwZBTF1aRPDnblAtF7HmIwtsu1llt5ycx/7IZoUYnWQAHRZ9Ov9HhwoHLr/7xJW8WB6Z49Ir6XjOEQAcmlDM8CuiDQQRLe1hIwhFC8ouNvrKvvAGkz1OfZUFTf1ntm3XBKlo8YlHR5Ij6bCNJYm83AD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB6896.namprd12.prod.outlook.com (2603:10b6:806:24f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.22; Wed, 3 May 2023 22:49:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 22:49:30 +0000
Message-ID: <ccfccde0-9753-1e54-75b0-f6f1d683d765@amd.com>
Date: Wed, 3 May 2023 15:49:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for vlan
 offload
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: brett.creeley@amd.com, netdev@vger.kernel.org, drivers@pensando.io
References: <20230427164546.31296-1-shannon.nelson@amd.com>
 <20230502164336.1e8974af@kernel.org>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230502164336.1e8974af@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4c0484-18fe-476b-4b3a-08db4c28a802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rRE1v+vyWVijvVQMt8B+1/aLPrpt0bhnUXlSMrSSCvt/TJIoEcbDYhpfXTx7k3gElXMkYj3TPPF2C+PeYsNDPQlLNx8jyBwHfSCxvgRFsSdprj9/1rQnlYcIjxho5JgLt/LiQD7QtRAWWOh0U6BF32XITwtqL5mh+HlVJn2YfTbnw618CJzsCDzto1h7IPeKM3/8zjQx7jLPcEZixpZlCPXi5yIxh2sla79zPEt93MYNACYz4nmD2rxDyk69SWYGmQ+fbAUIR7yeUqZEMPFwiKMSoArvCjxyEUMWOwvaAEt7QIkLRndY7H0a/vOqzUTc8USnh9bg5HVvtLZwAWV+6qGLI5vX6Vc30Yk6Zh2yL7XnMOMajmcYf2QtV1kEtag4D79nBzgJKhjBRS5O745UVGIVwbeJVIm8rF5NzvilWTMs8bw3Dxpqsm+Cl+6PMOHPSgbVufqaEXJW47Y1Ahf5r+m+SxSr3W50K8IDjlTHQm9TRLqXd0ydnbkOurD/EpIdr6fEsAWAuQtwX8jvpIpVQdWtP40E5YPLd2leO1EG+o+RLjZ0Ml+D7ifM889WC8g1AYf4eqY8mMncDqSOAgTEMx1+o+OXHkmugTLqil2l1FmJWTnt2KqfKfAzenvmNI6NyI3OvIDO74cS8KZMy8cyRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199021)(478600001)(2906002)(316002)(66946007)(66556008)(66476007)(4326008)(6486002)(6916009)(6666004)(36756003)(186003)(41300700001)(6506007)(6512007)(53546011)(26005)(2616005)(86362001)(83380400001)(38100700002)(31686004)(8676002)(8936002)(31696002)(44832011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTJWV0l3SXpYVGFPTnVxa3RZbEhTL3BVU3NwZU9BMjdOZFFSK0xWUkU3b2F3?=
 =?utf-8?B?MkhDYlFBTGorL0JJVTdvaXMzNjB6MExpTVY0enF6QS9LSU42amtUVi9Fdys0?=
 =?utf-8?B?SkQ5cWUrRExENmhKZkNWekp2QXFSYll1M1VkNXpZZjhqRngwMFhnRGt3OFVl?=
 =?utf-8?B?cy91bE1UTFZNdkkvZHVia1AxUTlBUTA1UmxZV0ZENjJKVi9PN1MyMzdwOVdC?=
 =?utf-8?B?ZnlvVlZMWFVhTjI5SFgyZmlCb1Zwc2JmQStYcldtQVVFS09rN3NxcEJ2eWZP?=
 =?utf-8?B?bmVoTkFyN2lnVFovM1FIeGFyOXdXL1N2RmQ2YTVpSVVqdmQxTER6R0dFL3hx?=
 =?utf-8?B?Nk52ZG5kQ2NJb0xmT1NnSDVNdnJ5cTQvREZmMUZvRFZLRktDRFN4SUdJN1VL?=
 =?utf-8?B?T2JoQ0NycEtZUkJ6S2JiNXZQVHRFT1VERE1OOHI1RGJIc01OaFFCU09qeEJm?=
 =?utf-8?B?RlZNdE9IQzJlZ0ZqS25wVmZwMUVCeC9wcU1vajhycnFRU24wK0FCZXo3d2lY?=
 =?utf-8?B?aFFTVWdVRGtkdjJXOHdzT2JZUExuMzNnaHpGUFU0SytqRmJ1WDU4cmdTNmFV?=
 =?utf-8?B?ZnNNMXlMenk4RDBaWlBqaTBReG9BVUFXMS9ucDFnay94dUVGNzF1QnJTczEv?=
 =?utf-8?B?R3Yrb1VnUm82RDFhM09MZnRFb2piQy9VZU1VWE9jVVhXRlhKK2tqRlBueGpm?=
 =?utf-8?B?U3ovSVRxWXByTmZCaWR5QTFzNWgxMkFNaGZ6TG1kYm5yQkY0QjdabitOaHlm?=
 =?utf-8?B?ZUlNZ051eVV1YVo5N3paSnlaWklDYmR5UUsrRitHVzY5ZW1Ca0hkb3VzREo1?=
 =?utf-8?B?NjllalNIL1Erb0toQ0REY096WXZ4SnEzWnI2Q2hXNXZXT1VJOVgwRGQ0T1BC?=
 =?utf-8?B?S3BJeXRKeStNNktLYnFDVUxDbmp5VXNSQm5LSUlJNVJ1S0IxaktnWHhvbW1J?=
 =?utf-8?B?dVBFQU9JR3dGT1crdVc5Z0dNQWxzQ1ZoWHRLR0xPKzhENy9GMzRLWGM1S2Vr?=
 =?utf-8?B?bmZIL05udm1USS9sN1hOeGU4OHc2Um9aWmRnblpQWHJXQmNFcDBpNkVwekNT?=
 =?utf-8?B?MWJCcm83QXczc3RJTmlnR0UrVk1aYlNIVkxFem5ZQnRTZE55TjIzeDJXbE1W?=
 =?utf-8?B?cUJiQjlVN0x3VFdudzNhdlFud0lYV0l3ZmcyUlljYXlBekRJQks3R2ZwdmhF?=
 =?utf-8?B?NWNOalpVYWVwZ3U5K3pHTGhUZFlRYjh0R3hMZDBXRURBM2ZKYnFFb3RQWFpK?=
 =?utf-8?B?QmxjclM4aFVLNWpjT3lQMFV3WXpaUy9xSzE1UFJnQzBUS0xnRnh5UTE0UmxM?=
 =?utf-8?B?cVIvY0F0U2FPK0pxVHhxYmJPakFjOFo1dk15MzdvUGN5a3JveE90bktDYjg2?=
 =?utf-8?B?SEtaRGtzMnpTWDVUU2hUdjNSSVRHNTlKZHYxY2d1N1Y5cjMvNHpXc016TXh1?=
 =?utf-8?B?dGYvYjRFVkZkbnFzQjZTV1FVaUVTQjF5R3M2MHhqVG1ZTjV1L1dJbEl2Q2lm?=
 =?utf-8?B?dFZQSWt5a21rd0tJeENBclg4RGhPeittYlh2V0YrcVBnTjRKdGM4VFRzdW9R?=
 =?utf-8?B?aGt0RHVUZGN3b3U1RzByQWgyRGxDeU5OZ3UwK05adU1nU0RkOWYxaVg1MDY1?=
 =?utf-8?B?cWJ1QnpvK2EwU2pUUkk5VHhVbGVhTE1lRVQ3UTl3eEE4VlFNNkVwc1BDRzls?=
 =?utf-8?B?SlJ4bGZoNHZTbjM4QUkrR3V6eFgyWndYcTJEVUlMYWVnM1NOZ2RJb0dnQ1Qv?=
 =?utf-8?B?NE1YRHY0SFBHUUl0TmhrOUFpbWc3MXZHRjRIeVMvK2xxTmJ6R1FVTUZ4TlZj?=
 =?utf-8?B?cThxMFg3NEFWaFV4MkMwamN1NUlhdGtlZFkyMDZOdktBc0RvWmhDTUZKSUs3?=
 =?utf-8?B?NWVpTVN1N29pU0Jiait2L01nTkdzaUVLT2FrV2t0dG5WV2VWVTQ4RWUrajVO?=
 =?utf-8?B?azZBUXV6cit2VldTMVBJeGs3OWh6ZmRkME0vRzYyT1E1UjMyWU5KamptZmxj?=
 =?utf-8?B?alk2cWNwTDhNYXVoZWFhaTRoQ2E3RktxSS85MW9DbVArOUtIYkthN1lVVE5H?=
 =?utf-8?B?SHZCSmVUZ1lvRXFESElrQjAyRndtWW1QV1c2RU8zVFN1Tmh5T054bDdDRWlr?=
 =?utf-8?Q?eQBHWgjs1+ZeTG9+hUfDdhEU6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4c0484-18fe-476b-4b3a-08db4c28a802
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 22:49:30.6851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMb8Sv3cYuobiugOfOg6qIO6blczh0Ox6mCoo6b2aoLA+CNR7w4A1zJ8EBoIejkKf200AHKqMoVggdFFqrw8Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6896
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/2/23 4:43 PM, Jakub Kicinski wrote:
> 
> On Thu, 27 Apr 2023 09:45:44 -0700 Shannon Nelson wrote:
>> This is an RFC for adding to the pds_core driver some very simple support
>> for VF representors and a tc command for offloading VF port vlans.
>>
>> The problem to solve is how to request that a NIC do the push/pop of port
>> vlans on a VF.  The initial pds_core patchset[0] included this support
>> through the legacy ip-link methods with a PF netdev that had no datapath,
>> simply existing to enable commands such as
>>      ip link set <pf> vf <vfid> vlan <vid>
>> This was soundly squashed with a request to create proper VF representors.
>> The pds_core driver has since been reworked and merged without this feature.
> 
> Have you read the representors documentation? Passing traffic is
> crucial.

Given that there is no traffic to the host PF in this case, and I can't 
do anything more than wave my hands at vague promises for the future, 
perhaps tc and representors is the wrong path for now.

But there remains a need for some port related configuration.  I can 
take a stab at adding this concept to "devlink port function" and see 
what discussion follows from there.

sln


