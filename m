Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC3B43D1E4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbhJ0Txc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:53:32 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:57505
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231656AbhJ0Tx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:53:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qan43SNtJZfknfQh0Klvb9W7PN/NqZ/bvCd8nObGJgNjZYTOgutMHdA7PInSb32tbF29XOjzjvsFdQR/rWpGIzVOKTYQIHWLfqRc4J6N3ml7Te/Eg+0cCsGNr7bU4i0RNrYqS/deAzHN4WzoX6uObWcT0mAxZXlfa4PG8yXM23B/92cVAgP3bR2sURuJvFd5j8VNykKSCBXcqWV2W8izOku164ZlripIdOXZRnbZLaPd3ooVjzKYEOCNfWUWBfufZGeMOCxcG41uV9EKU/XpBBEF5r/odyP5W0B/0FY7d9K3JOldVTBE6SFiPdzGFMn0+CTjJpR+V88p+BZGwIAHTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Ve90mojB5CNrR5qHjgDX2ZUZ3/NonQ1MLTHIhyzsOQ=;
 b=nT6jHEpRqr12Wxv+RzU6ibDoK+8VPRiblA7uRwC6Fb2djxXdX0DRnn3VA9sxX75SSAOatMHSDxNnJviEblw1QVpam1HkWPuGx9dwX+gGVu9hejhKssJjtUgoidyCiGbz+Z9Af1wOmPNf6l/azu/OKGHS1UT55H4bZ0vCQ0YkqX/xUcXMgfX12shmzt8imym5W6ULV1RVRlCK8HxmyFePUwV/DkYeME4Su8BYPMf/0A3+f9Ppgm1HShA9sPJdph6ncCv4K/gip9ukPbfmLFjWHw4NivmgpmILCT5KEkS5NOfQy4KPHp1XWuF0rKGM/JMFOHFZzy6Iu5Nj6poaCWIa3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ve90mojB5CNrR5qHjgDX2ZUZ3/NonQ1MLTHIhyzsOQ=;
 b=U21agq/W8mVBzVDjEoCDbIsumoW9vMTxvGIOTfGLyc1Rqal1/aXZRxTCvoS3nDTqosa3ochQFphhf2Y4Bl6aMX/a/mNA2nddm1H5L8AItSg4MylYr0reqFhfFAS4j8tCZEdzm8f6DesO2srSppU5HW0MWYW2BDxGMQjRRkhQZ379HPCRWL08n12ViCAkY3xdDNVCHUc/BpeX4Pjj7ARKxt2GrC2zxIYNl1z8Sm2RbRsnaRfo0KtwXUlPnBkGKam0C9cgeVIAUMiSnZAWEvGbQorvtXY3vgFMCIZM8CsAELOoUWEJ9Mk/DQTeOQq772p14lZyY1kFvE/PwtqLH6qILQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 27 Oct
 2021 19:50:55 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 19:50:55 +0000
Message-ID: <97a4088c-ba81-229b-0f7c-088a0069db41@nvidia.com>
Date:   Wed, 27 Oct 2021 22:50:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-2-vladimir.oltean@nxp.com>
 <a8d9df33-408b-a2a0-2e77-754200ff7840@nvidia.com>
 <20211027194552.3t4l5hi2ivfvibru@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027194552.3t4l5hi2ivfvibru@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0148.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0148.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Wed, 27 Oct 2021 19:50:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42e35169-f20d-4e75-fe9f-08d9998316f3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5086FA6B98F636BAB88B33EADF859@DM4PR12MB5086.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrKm9xpjYCzq0ywC4XXhCV/NGk+aSIL7tCPRYxdEkHGuOL9g3v4FPqx+acZX198MvO1FzuJcJMGJgeGzHK50nV/KvrDe4gtDgTb4ONPMDAvqK1BVTLRIs2+/Rw0hJ0RiH62DrCQ/VxRVP3piOiN63zoOjTrXbu8alCUNDTDY2J6kG8h6UBczPxz7grudE1OV8UdOt7+z1NFcKb24Nxxld7/tYijG21oJHBl4LlkFEIHn/IeQsjBy3oJkH9s3wvptBaiE7ki7JXHb+1iGprYvWzYFbRgzveIvmwiHxE7a3Ee9jnPHbqnt2TgFmbJawcYghza03TEfi1eLlOrAr57RCVC9cWw28N4jzE9aPv/0a3zsTDpFmu4Wh9I+tRZbyVoctuyDDJ4nNHWp3u2gYiDX7+KTak7LOyXAV5GXIB/UqZykiUDEskwrPGpM61Gtk+LGltyDZg4ynqWQ90HBRiwEX38sBsE/jySvJ53HuarveoOLD0pw3b/vMn2vnacOX5ZuPIbHMmLDFZ1HHLU7HGc/JKwPy2YSLuiCiToLvVNRUjJ5fp0Hp40DwE/sG0FkbA4CrfBR8dVYgrGfKOAi2ZIIElexVLRFXCtZINcLZwxpWmHJU33QwlbS+1Y5oR+tA7jKs2DP3T+2eRQ4S4XO6Bed1FTRH5jisoFhnRQQ5oWzuhl0PEvRCBPrjA8J+nXoXcBbxkUZJXeQRdkUBzZN7/OKwo6S+Ssg/vJ02oHAsHuVDzBKEJ3XwD0eBp7iSjHkRiwn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(83380400001)(38100700002)(4326008)(31696002)(86362001)(6666004)(956004)(2616005)(16576012)(31686004)(53546011)(6916009)(5660300002)(107886003)(66946007)(66556008)(2906002)(66476007)(26005)(8676002)(54906003)(8936002)(186003)(316002)(36756003)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0cvTWNZRE0yTS9VR1JVOE5EMHN2ME5QMlBhWHpVT0RZVHNzQWlFN211VS9V?=
 =?utf-8?B?MmpQd1hLVjhWSHpKZmRPZ0Q4Z2VMaDR6Nk5LUVlwKzVtRzM3OXZtWGs1RUxQ?=
 =?utf-8?B?emlHZXBhcmlQcGxvWXgyVUlhbXZRenJuU040Ni9OU0NubmJCQlltdDhoa1Y0?=
 =?utf-8?B?RkJxYmNYUkRGQlZkNjRBTWZHaGVyOWw1NEVNZEw4bXFoekhxU0lKQ1VRTllF?=
 =?utf-8?B?enl0UVdPanF1NmhOakdZUHp2SE44T1daYXNhYVAwbEF0VzEwbnZhTFdLY2RX?=
 =?utf-8?B?VUdCN0l6SUNjOGhPTE1NNTlhQ0ZadjhubWR2MVRVVzQwajJKMzIvYU40M3Vy?=
 =?utf-8?B?NGsrcjVGVmdxeldiWWw0c0JOZ1Q1enNzamV3MFRGOW9lYit4amRjOXl5T1Ir?=
 =?utf-8?B?RnY1RVJRRjUzdGNEOVExanF6RUQxODFsdjhmQm80UmJheDBWSXlHcG05d3l2?=
 =?utf-8?B?elcrK2lkTVhkRnh6NDliN1Y2USs3Ylh3ekRPdXdTY3gwU0QrZzN6aU1YK3Zl?=
 =?utf-8?B?RU9reUFKelFNQ3BSVW1qd0Nxc1o4a2RxVFA0UllpWmczU21DZHdVRy9mUVdh?=
 =?utf-8?B?K2xxOFFrMHlWUVg2MEw0Q3RaVmM2cHUwajIrSVNHb3N4QXgrNXNDY3pMNzZj?=
 =?utf-8?B?WlJSam0yQzdjMVRRSzlnL1Z3TnVLZnVzK21ySkMycUI2ZlE2QzZHcE1vZWdX?=
 =?utf-8?B?SEFGRyt1MkpNSXIrNko5WXhJUFYrZ2JxazRLWjlFdWIrbjRuSDZHN2FoU2Yx?=
 =?utf-8?B?Yk1mNy9OQkRZY0tpcXl1akUvMUtpOUZjZ1BhK09TSHJFSzM3UWFYeDREc2JR?=
 =?utf-8?B?a2ttVzZ1Y2VSTXVtak85azlVRmd3elI2VnpMd01SMERnTVpwSGQ1MHZ6dWtO?=
 =?utf-8?B?aGxTcEJvV2R0SDhQZHpjYjYxQ3dyVUZ0czlqZE1JSkQvaDJpQkFQSjhSSjhH?=
 =?utf-8?B?M2dVaGxka2xGU1dEMFJ1aktkN0M1N1Fmd05JMUQrb2ZySzN2S1NybGlHSnNK?=
 =?utf-8?B?ZnJ4dDh1VEpTY2pvMnlvbG9XRGg4YU1GOUhGK0VrVlE5VkpTQmprTFpiS1FG?=
 =?utf-8?B?MktRQitGckV3UGZCUFJMSVl6TFFlc3YyMEpjazhCUlpmWml1R1RLS3BPRXJO?=
 =?utf-8?B?ODJKdHVuNm4wcTVlMW15dUQ0OGREbGNiQmdTVXNiV2VGNVZUMHp6ZWRZZFRt?=
 =?utf-8?B?NUg1Zi9xUjVqWExjQm1KV2lPbEk2NVBFKzYvcGZiWWdxbitTOEhCT1RaWHoy?=
 =?utf-8?B?ajZBZ3BwUE1IOFZTYTdSK2toSHhyeGltRVlpS0FNNEVEd0NiOUphTGtFMFF0?=
 =?utf-8?B?bDR5NHJyck9uaDYrcTk3N0lsSDBxb0tJMVh6MVkxQlJQdW1XT0tnNkdZR3pn?=
 =?utf-8?B?ZG9kcUl2RW81RXJ3RFlGaU1RRmxGMWw0cFJjdytiT3RZUmxIRzJqQXNHZXc1?=
 =?utf-8?B?RW5oU21WZUFzbFp3d3ViYm5YOWtnblJnNEhjR0d4aFdQdFZEbHYzQjZGeEkw?=
 =?utf-8?B?ZkdEdko2VnlMKzdzdUJ2T1pZemdMTG5PZ0d6VHQ5WVl1WnAzOFRleGdtKzZ6?=
 =?utf-8?B?MUFIb09zblh1ZXhQcnhPT0k5eFAxa0Z0WHlQNVRHRTFNbVgzMFppeFUwKzF0?=
 =?utf-8?B?L0RUeWRzZEhpa0kyMzdZTThLTDVqMENqTE1Pd0taekxCTG9pNlYwTTl1aHFs?=
 =?utf-8?B?UjcvR29HOC81dkY3SzE3TGN0eExhSHhUVVFQVTl2bzJEZStiVWI2OCtXcnpM?=
 =?utf-8?B?ci9lWFMreHRGclZETUZYK0FvbVYzb1RrVExPMnZzWU02VnNHb2JLRGxSTHh5?=
 =?utf-8?B?NWtrY2Yya1cvc3liSjZlYzB2a2JMbjN1ZWIrenpSWEZFdWc5TVpJT0hwbEd1?=
 =?utf-8?B?a1lhbjRxdUZpcHlsbmF0ODdEa3UxVGRGZFlidDNGaHZkbGdTZ1NBS2dDOExi?=
 =?utf-8?B?N3RPRGtjWkJEQTFUWXFUNnVpZHpYMHNyaksvQUYrSE1WQnM4ejc1MXYrS3lh?=
 =?utf-8?B?c0gyWURIMmdvendlZUpaclZFR2NCT0xZTmF1M3pxazdhSFhpT2JSbE5qMGxa?=
 =?utf-8?B?Y2JpaWI5WkUvaVgzc2Y2bUZLRlNjOHlxRTg2dTZYVE10ZXk0N25raGc0L0NZ?=
 =?utf-8?B?Z3JGYWZRWFpSazNsemxKK1h5Mzl0Slk2dU1kTjRmYTNtNEJnUm5LbklFVXVl?=
 =?utf-8?Q?AXuPc6CB05GiqEsUfy3WXcE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e35169-f20d-4e75-fe9f-08d9998316f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 19:50:55.5555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vimoY/vgXrqgQCOT6pE66fpl81FKysw5lrQQie9EQcfnW1s90gCzuj4A9flh9vVAYIHnT1uKLowONpN0w0uulA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 22:45, Vladimir Oltean wrote:
> On Wed, Oct 27, 2021 at 10:28:12PM +0300, Nikolay Aleksandrov wrote:
>> On 27/10/2021 19:21, Vladimir Oltean wrote:
>>> br_vlan_replay() needs this, and we're preparing to move it to
>>> br_switchdev.c, which will be compiled regardless of whether or not
>>> CONFIG_BRIDGE_VLAN_FILTERING is enabled.
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>>  net/bridge/br_private.h | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index 3c9327628060..cc31c3fe1e02 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -1708,6 +1708,11 @@ static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>>>  	return true;
>>>  }
>>>  
>>> +static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
>>> +{
>>> +	return 0;
>>> +}
>>> +
>>>  static inline int br_vlan_replay(struct net_device *br_dev,
>>>  				 struct net_device *dev, const void *ctx,
>>>  				 bool adding, struct notifier_block *nb,
>>>
>>
>> hm, shouldn't the vlan replay be a shim if bridge vlans are not defined?
>> I.e. shouldn't this rather be turned into br_vlan_replay's shim?
>>
>> TBH, I haven't looked into the details just wonder why we would compile all that vlan
>> code if bridge vlan filtering is not enabled.
> 
> The main reason is that I would like to avoid #ifdef if possible. If you
> have a strong opinion otherwise I can follow suit.
> 

Well, I see that we add ifdefs for IGMP, so I don't see a reason why not
to ifdef out the vlan replay in the same way too.

I don't have a strong preference either way, end result is the same.

