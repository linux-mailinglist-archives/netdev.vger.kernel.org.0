Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267453FC4EA
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhHaJLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:11:49 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:58688
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240548AbhHaJLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 05:11:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaNrPLpWTIOfW45uXGGH5U2NlvcV0bFJ/1x4yxXM3+j84ZA8MbEnSL8vpNGdNqGVKyE8EXsuLYNW84M2XIxnyjKSJtIdp9Wdgq+yYrFQAUFZS/ZZH+cyXQ2FIqHjrl1R5Xrlcwda2Vmq75jWIQmZpeknZ7izkg/Z4UAZzZ3hsGvT6W2uG5k2AsDEt2cxn+FFcgGVyKD1QS8P72nGvq7FFZ1AhpbykUE3oAkdnSqfRoZa43MIKca64jj8wIobuuK6nXPfxUaaXrtb4QEJurER0axAcl9Ls2afjB5gCiFlkFF2FFg3j4DhgUxNuy9+0qDRizJlmiaxhWjzBzT8EHmueA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeSN+zn+tlKt0xVnLibu+Dba/L377KxzbQS9AUSJzH4=;
 b=moRDdI97XvRPKnVmFGaNeVPGp5++HnYC4yFlZaSQe1JZtTHGKoSKPevn9b9tKEs5OepqukOoI98OXX3Q7U1Tt9/UYAnewYhVHht5tJRp4itDs3Sjoiw8DoWElzvJ/uDcXuGHb9ktIWnn/hXEoyZQMxnhuWvUeXNxPWRmGZOsNXZUBHZrgDDfCn3c1Fd3RH2EfPcHC/7o3qvDMKWO8VwApxEC3A8XvSO4yl3xJwzJZZo/WmuPp0JlChTezgWGEUCbcDXaLNS2FqY2S4B9jqdtMpxJETQjba6KgG4xaurXX41ovZhyPQhtGhw/bUWeStWPGdKwXpYTRbeha5ZJ6Uum9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeSN+zn+tlKt0xVnLibu+Dba/L377KxzbQS9AUSJzH4=;
 b=ndoMpwA1P3bIJwCyXpvmebSBzPy73u1DmaWLZ7jX7p+U/DnCVMBFO5coATkI36EGJLoi17338JI3RCrAPqJsTWub+2pbAwci7hWHXtdtuy3+ezWU2dMp1aiRsI/XcN1JgPVe2q0hOt55DsB8m8gkMgdNzUsIgPmwXyjDP3D64TwMrrMrFgPu2d3+PPMfFBg7bfWOeXIcFuBjUxbjC2iigPqN4JU0cjUd2inXGhNgeso+EQEJnabS9PYWzcpvuhmJwagMo5sYmidVeNNaX31U7pLFWf8ckrm77Jpi1/iacQb67Fj2kxpzKMrhhT2spXl+ia0lFLsvUkQ9TZFvO2xp/A==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 09:10:51 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%7]) with mapi id 15.20.4478.017; Tue, 31 Aug 2021
 09:10:51 +0000
Subject: Re: [PATCH iproute2-next 06/17] bridge: vlan: add global
 mcast_igmp_version option
To:     Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-7-razor@blackwall.org> <87pmtuoulz.fsf@gmail.com>
 <b14e6b19-96d8-71ce-7e7f-3318356ed7cc@nvidia.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4b9ae5bf-27fa-c6ac-6de2-0c8d0c3e6ab0@nvidia.com>
Date:   Tue, 31 Aug 2021 12:10:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <b14e6b19-96d8-71ce-7e7f-3318356ed7cc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0061.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.175] (213.179.129.39) by ZR0P278CA0061.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19 via Frontend Transport; Tue, 31 Aug 2021 09:10:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be485fef-4ece-4522-255f-08d96c5f3a9d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5184:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5184F3F4BD67E0CF6B9D00E0DFCC9@DM4PR12MB5184.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IEvoCvVeOgjP2jMzBWqDrn3Sm09Mtgtu6PVensvQrKliX3nOqVsEAMFKrjwrATT4WAh+gvMs5pb//bODtuN7r/bfbG/wowIwL8Mmh3jioUdiCX7pbR7JuVIfBmrSADHsIrLiAEw6j363b8RPTAdY+bKzhzOgyFFS0eVLOhkgjCgaVc5zstuC71RZiyKIjAVxV4ezyPKa4xumZL3G/qPa8bzSOmGJ0XW+Ed5NimZVYQoGThD1JDonDoHEuXGXqumX50l4+OOn7U5fFKD8vxNF2CoCpRXwZuRMg3a2ce0mkpLRllj0ygx2IzD3cK/qce5i7cEQJ5FYETxU2qZME9KRtzyvTSsyp8kV0P4p7ga0h4UnZHusdrSttEeg2uBhHWL6opReRw03NgYpk8VJ02+BinNxfILw6iaLnOVi04NLZ2QWDHEb1gRZLtn857pV6PKhiWDGrWOdAiT5To7s6z4JX6WkgSO+lyiYto0gyNMokvFPtHGx1HwQFeVt68u4bSmTXEyeVVdXauFjfr66lEjPasllkRRqqoHjdygAqUC/QF3dOHb2z66bmX1on7UmnKkEw4ySIlCc6CCPKHoXs4EKYreImKBSSNd3bjdAEqxN8tUaGzeqkwCe01wtDX28ZHV4vCkt78acFIPfWFQlQT3y/xuAUij/adTW0E+94ERAhDEo6ZaACi/lONTgnQSjnjsrBc4gG4PYE4sLzS4uL+Ybnk4klx0Oqa//mBOUQgj20/lT1ZHlRZ68sQJRGxEjorfaKDNn7EK8JdtenJKN53AP7+dLr/sYfbaLkL6eXfIvexP9yHbEL/Frtj3PfXgAO4x9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(86362001)(956004)(2906002)(316002)(83380400001)(66946007)(36756003)(31686004)(66556008)(966005)(5660300002)(2616005)(4326008)(16576012)(6486002)(38100700002)(53546011)(478600001)(8676002)(31696002)(6666004)(26005)(110136005)(186003)(66476007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEh6MEwyM3ZxWk5DWGxXZjVzYkFKVGREMXZFc0NGaEJ1aDB1ZVE1aUdQN3FX?=
 =?utf-8?B?aUpja1EzVkdGdTFvRThmbEpOcnorWWNhL0lnZDNuNlY3Uzk5QnVjMUZ1OW1s?=
 =?utf-8?B?RUNIK2dFc2NibWJ2SkpBMjV5bS9VTGxIUFY0SlZLc1AxcGo4eGhQUWtzYUls?=
 =?utf-8?B?S3licFljUmVEckJDRUJVeUt6WVVCc093OHNQTW5KU3NqVUQ2bHg2cTJQOWgw?=
 =?utf-8?B?bkc2ZSs3dEMrZThQbHF2Tkloa2owcnBteDlsK20ydGtJeTl6ZkcrblRTVzRG?=
 =?utf-8?B?NDNCS1JmZ2I5Q3NydHdIUk45bUJpbXBNZEpUNlhFdGMzS2EwRHBsRlgvdkRM?=
 =?utf-8?B?ekRyNzNvN2JXeWk3QnY0N3M1dHdyVm82U2ZxRFpYdXUxcVVweVcvd0NLdWlS?=
 =?utf-8?B?U080SCtVSzJMUDczWVhQZENPajE0UXVIanNKOTA0V1FGazArVERuajdlZjh6?=
 =?utf-8?B?dVg5d0VNdXRQRDdDQ2dDZEdqTVB1SzVrOUQ3cmxONnFhSkZ0VEEwNnlidTJu?=
 =?utf-8?B?UFNIZ3JRdk10eXRldDhETTNrUWM2SDVyaXFyeUMxMUxCdTB4dUlsbWFaVWRv?=
 =?utf-8?B?VW1HbG5MM0xsRnlGTHpUVFhveXVjUStvOWdETDJpZFNJOTJxRGMwdkdVdkli?=
 =?utf-8?B?aldjODhMY1QrNXNHd2dMV2tiazh2OFZkN3FXbzZEUnptSVkxbEdyeklMVXFt?=
 =?utf-8?B?SFdpQzFTRnZlVUZ5M09LMkFJblZvODZXbHdOZ3B1NkZBS01Kejhkc3VZUm5h?=
 =?utf-8?B?WEoxMzVydWdacXMrZGg0VEtVT2NwalB0YzQ0V3dubHdrcEJ1MldzeFpyRXVM?=
 =?utf-8?B?Y3c4NS9Ka0dZVTM0UTF3WDBMRmo3MytHRzdOYTNDVG52WmZ4OWVxMDVxVkRq?=
 =?utf-8?B?SS9laVA1UlFWK01YbTB4eEg3RWQwM2JTY1o5ZlVjbGVWdTYvSXJ2cFozUVE0?=
 =?utf-8?B?U3JZOUFBcGpVL016c3FSemZ1UGhab1ZoTmZmT3R0U0xPY054MDJla2YvQ2Vo?=
 =?utf-8?B?bXRkTHRGTmdIRGVFZ0s4YnhUUlpIbFE5R3dsTnlGaTBPRFZBeTBpOW9oQ0R0?=
 =?utf-8?B?cnJYS003OEtjR3JKYTMxc0Z0dlhDc3BKMWFMQk5Vc1JmdEhjaTNmRjZYMUkz?=
 =?utf-8?B?S3V3RmNDYTVoVXlyVkE1V3lKMUE1Qis3RXc4dVdTMGpnc0dlUk5ZakRjbWYr?=
 =?utf-8?B?YkxCcEt4dXJINExmZzBuK01OTGVPWnlvWUpySHBqVG9pWmkvdnRtUWNPZWs2?=
 =?utf-8?B?dmNlMkRPV0hnZjQ3VEtOZ1hSWmhzL2ZtRlBCaUkzRHExNXF2a2tZQlFqUlhx?=
 =?utf-8?B?bGlwZU96d0lJbU9yMWxhbDFyd0FFZVN0alZvZjlJazZ5TUl6bkhoZk5ubk8x?=
 =?utf-8?B?Smp3cGd1QnBVYzlMd1NnYWJuSkxKdHRTelFVdE4zMVNwc1pGMjB2Wi92dUdP?=
 =?utf-8?B?NU1GUndOSXR0QkoreGNEemRKbGJ5M3pJM0dLM3Q5clltVXZyUXloL09EbkdJ?=
 =?utf-8?B?ZjJZbm1IMktnejVQV3VnWTdmSk1FQWgrOVkraE9zb0dVMUZxcmxsb0xZb3Rq?=
 =?utf-8?B?dnFrLzZoUkp0MTlrdE1jTDNiNStuaDdhcWNxQzY1YVRkNWcwZDY5dUEweXhT?=
 =?utf-8?B?Y3k3ajgwWExDMnNNaVhFd1ZjOXE0aENxRGN4VzZEMmJFaUNFektwKy9OTE5Y?=
 =?utf-8?B?enZXM3JaQjU3Q1krZDFhVEJMcG9zTWhYSjZTRW13V2lHTVpjY0pyZ0ZlSnFk?=
 =?utf-8?Q?palU2UgfUXsZJAMHGY5FLy9SqHdM0+eHnNEOGCD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be485fef-4ece-4522-255f-08d96c5f3a9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 09:10:51.1681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHjfxNISXJl2GIicXHec7QZMP3361R+1ipgs9CJFtAGo0XNhr6iBwC9l+6QugR3H28ielprevrs2pyT1/mIqVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2021 12:04, Nikolay Aleksandrov wrote:
> On 31/08/2021 12:02, Joachim Wiberg wrote:
>>
>> Hi Nik,
>>
>> awesome to see this patchset! :-)  I've begun setting things up here
>> for testing.  Just have a question about this:
>>
>> On Thu, Aug 26, 2021 at 16:05, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> Add control and dump support for the global mcast_igmp_version option
>>> which controls the IGMP version on the vlan (default 2).
>>
>> Why is the default IGMPv2?  Since we support IGMPv3, surely that should
>> be the default, with fallback to IGMPv2 when we detect end devices that
>> don't support v3?
>>
>> The snooping RFC refers back to the IGMPv3 RFC
>>
>>   https://datatracker.ietf.org/doc/html/rfc3376#section-7
>>
>> I noticed the default for MLD is also set to the older version v1, and
>> I'm guessing there's a reasoning behind both that I haven't yet grasped.
>>
>> Best regards
>>  /Joachim
>>
> 
> Hi,
> The reason is to be consistent with the bridge config. It already has IGMPv2 as default.
> I added IGMPv3 support much later and we couldn't change the default.
> I'd prefer not to surprise users and have different behaviour when they switch snooping
> from bridge-wide to per-vlan. It is a config option after all, distributions can choose
> to change their default when they create devices. :)
> 
> Cheers,
>  Nik
> 

Forgot to mention - the RFC fallback and compatibility logic is not implemented yet, so if
we set v3 we'll be stuck with it even if there are v2 participants. In fact it's a bit of
a mess when mixing v2 and v3 right now, their interop needs more work.

