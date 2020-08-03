Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D223A3EA
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 14:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgHCMRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 08:17:45 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:45379
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbgHCMRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 08:17:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDmtS8MFzUFUU5NY9jayJ+jKsxVeicNrdh3BiPxndw25d6qhjMP5mfif2UVG3mtiqQQ1i81Q/bT/9I/K8F4WXpH1esbm4ie/mSIeJTD9SlPn+iQMFo03jGr3ecHZtQ1NXoJsgxB5iZptSH8AxELyHPewc3EM2uDuo1+ag7Hdh7QSJNNoscRv0BgpgUL/6XbpNm2z6s1s+gz21Dy4TcRUrh1T3nW1Dh/GqlyZ4RY/Yfq8fDnRLSXat6exm8aUod5O/nj9Nodt2lNRn8rrAc1QLE9SHawdhRKMkLIIzIqGUeZyPC/B5hIRl+M7hWy1xrYlQk80kDF8GvTkG0iTpGwarg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVRk9Se2Xiy+gO4TklkSlLqZPXqZI2gUg5uqmsNQl4s=;
 b=EeEGtzdOShpLeBl4DLDpuYUkXllVgSmbAcEyTYKTSI29Hzzr0YzHi/T+g+EJfzlqvqy/9EctFlZ3+bXxj0wEDOgpqnGezZGvjtp27KFiQQgMb5NSEz/ipkvEzDldLgQnDs1Dkar54y5tm3ltGyUjFkCRZgiS2dMc3V0T6nErCjCh8ru9HO+hToRaLH9/EB6/pM4J2Me/Sm5TkLfSi5mEebiGGnM+XXZQieLn3r4ZDudO6kKE8HgBJHkIwrqGHjG5kt/9GbjgK5cAssb0yCqXaiX+Ypct8aDxqo1PE5v28r20CJlib1y15c5ZeyNttJTbjyOrGjJuC7ebOMTButqW9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVRk9Se2Xiy+gO4TklkSlLqZPXqZI2gUg5uqmsNQl4s=;
 b=DEj3ntbm+tKShrZxDIqikLUkF8dVFhIhYEe5BFOaVvmepG6I7WFj552Gl+1NKYnNKn0/UW41agDsJmqn9i7HTVCFdEfzPtlieH+aicSCsBqWyWS6rMl4xdBMVC6zIPV5YLBQ1xL01IdvUVs4ys+dMZRxPjaW44r0H7JPgGrLv2k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB4130.eurprd05.prod.outlook.com (2603:10a6:208:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 12:17:36 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 12:17:36 +0000
Subject: Re: [PATCH net-next RFC 00/13] Add devlink reload level option
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <CAACQVJqNXh0B=oe5W7psiMGc6LzNPujNe2sypWi_SvH5sY=F3Q@mail.gmail.com>
 <a3e20b44-9399-93c1-210f-e3c1172bf60d@intel.com>
 <CAACQVJo+bAr_k=LjgdTKbOxFEkpbYAsaWbkSDjUepgO7_XQfNA@mail.gmail.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <7a9c315f-fa29-7bd5-31be-3748b8841b29@mellanox.com>
Date:   Mon, 3 Aug 2020 15:17:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAACQVJo+bAr_k=LjgdTKbOxFEkpbYAsaWbkSDjUepgO7_XQfNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (31.210.180.3) by FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 12:17:35 +0000
X-Originating-IP: [31.210.180.3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 31884b03-3b19-49cf-a795-08d837a7350b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4130:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB41309F234908048ECE65283DD94D0@AM0PR05MB4130.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cK8tn2zvl90gFC9+GxVSjTa6UnA0j+fGXBrkUc1VkI4HPd80yoEKF+wMJOhEWsEQQJYKW320a8HOHKr7Pp0IY8l/YPZz8DPAUUmRdNG0GnWCQn70L6wvPW3ioTB0oyAw7JVvt7fKxHGStwDGt3CGqQ3yD5YZHjqcivQmj7L8Z9mTLVw8ITVTSy8zdswUSimXsCdP25p2zPnbu6MpCRFXXC4NgOa2bA8Ii3agrZSe/94yaRl5qK7B6IMyiiff91oqlRxJ8Ad8yxiW/Tf9C7c5pM6manEEyHsErzwLq5KeW31YHNqtTK1Z1q6OYLmaIzDBLmt8iMjvn47dVaqKAVJdLDWmo67+BNTlSoPa1WKkTeZiRNLTd//J/9cP0lvN+IEz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(52116002)(53546011)(66946007)(66476007)(83380400001)(186003)(36756003)(16526019)(6486002)(66556008)(478600001)(2906002)(4326008)(316002)(8676002)(16576012)(8936002)(54906003)(110136005)(31686004)(5660300002)(31696002)(956004)(86362001)(6666004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c/dOnfU99Nh1+E8iOZhNrcEgQkYlSfgwYvkmqvaXcUz94BamoJ8H95NLajfmvIM5jERQl3l5WHWSa5SaFXrmJ0CiOLaEGK7e9Lze1qeEQm2cX3Vi7WfM7k380zcT6GuLNDTnGy9mMden3smVukuO9cJ+JgBL5LkIqlPvx7kAPsJg8HSKFHv+we7YnthwNTUxl5KPFidWWIrCEhL/3cjY1WMMve3r0k+O9wH6mNF4PaN2MPg5TI+zWFy/9m1Qvdu5qL0T5DFJyR/N1Abluj3XT8u8hIuTkUlgKrCeMdKTarzk5AmjNNOiLVZ7F1u/nRP6jhgtzDHhVLmqhk+7Co0L+LXrlRFxx4NidYZvnkYbgzM/1XWEksGoVh3GxqHogzI/qdJFIojBauFh6yfhg9rzMS/xSv8A5kSrmtD2liDuBdVvNC6HPyRvRjWu0z/g2nRE3E/kv+UHb1e5EaHcoR/NPZmuOIktNE+pOsYGEWsk+k/yyCWN3VCwWNPIti1uMKbrMTFd8cEu3dOFrYWk9ZwQOLRdp2iXOkD21DEDkuHNGYnFmiEiNyzyiVwAccniOFpqkvGGdnkyvG28IfuSORm9fIwT1fk2KLfE+6G608v/LKRRF8hCRhEiHlFjB+6+bF0vfqFwldnOm/RCXLo/NsR2hA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31884b03-3b19-49cf-a795-08d837a7350b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 12:17:36.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZwaMJqwkD0vX9TYGIwIBf7nOBofI6esEfz3bnQD7ZhTNR+qUB+2xQ1OMdEJF8vhhMmbyXoSwdkRrX/7ngXbmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/3/2020 1:24 PM, Vasundhara Volam wrote:
> On Tue, Jul 28, 2020 at 10:13 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>>
>>
>> On 7/27/2020 10:25 PM, Vasundhara Volam wrote:
>>> On Mon, Jul 27, 2020 at 4:36 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>>>> Introduce new option on devlink reload API to enable the user to select the
>>>> reload level required. Complete support for all levels in mlx5.
>>>> The following reload levels are supported:
>>>>    driver: Driver entities re-instantiation only.
>>>>    fw_reset: Firmware reset and driver entities re-instantiation.
>>> The Name is a little confusing. I think it should be renamed to
>>> fw_live_reset (in which both firmware and driver entities are
>>> re-instantiated).  For only fw_reset, the driver should not undergo
>>> reset (it requires a driver reload for firmware to undergo reset).
>>>
>> So, I think the differentiation here is that "live_patch" doesn't reset
>> anything.
> This seems similar to flashing the firmware and does not reset anything.


The live patch is activating fw change without reset.

It is not suitable for any fw change but fw gaps which don't require reset.

I can query the fw to check if the pending image change is suitable or 
require fw reset.

>>>>    fw_live_patch: Firmware live patching only.
>>> This level is not clear. Is this similar to flashing??
>>>
>>> Also I have a basic query. The reload command is split into
>>> reload_up/reload_down handlers (Please correct me if this behaviour is
>>> changed with this patchset). What if the vendor specific driver does
>>> not support up/down and needs only a single handler to fire a firmware
>>> reset or firmware live reset command?
>> In the "reload_down" handler, they would trigger the appropriate reset,
>> and quiesce anything that needs to be done. Then on reload up, it would
>> restore and bring up anything quiesced in the first stage.
> Yes, I got the "reload_down" and "reload_up". Similar to the device
> "remove" and "re-probe" respectively.
>
> But our requirement is a similar "ethtool reset" command, where
> ethtool calls a single callback in driver and driver just sends a
> firmware command for doing the reset. Once firmware receives the
> command, it will initiate the reset of driver and firmware entities
> asynchronously.


It is similar to mlx5 case here for fw_reset. The driver triggers the fw 
command to reset and all PFs drivers gets events to handle and do 
re-initialization.  To fit it to the devlink reload_down and reload_up, 
I wait for the event handler to complete and it stops at driver unload 
to have the driver up by devlink reload_up. See patch 8 in this patchset.

