Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354C24C8498
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiCAHEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiCAHEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:04:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5718D4B1ED;
        Mon, 28 Feb 2022 23:03:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvvOXFY4D+4j9Om9loFmmlH6oXGdE3SgsJoHYgP1pfqfYVyfDnI4a/WdRkjMn0VK/Y3r+NvEqj87OZ4qJfoQQiYyJc12nexWV4wk6V7U1/NDHzrGOzY8Myph3r8y19ru08DQRN3qZFjKVQgRCOB6q3AM8+h0qHsN7mihtbIbPYl0jAJMvnHEiGrgU0CVsZwVSo1N3SWpBlxrRrLY1W0q9Hy3UAkeFJy8gjbjKc41nzNaKtWrm3CusIubiZfzVnf7sUWNVSp1/d/BrrEKoJ3sXqINbrYII/iF2jgFr6ja3TaM32dka6cwAqSqZc7FeWiWN76VN77A19dyXbym2h5mOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jo0XPCk8EMRRi/eZQNSbAIIYUIJOZ4OTcUMZN8WAooQ=;
 b=l5fjk+B3leRMMHbv9dDOPZLKLzKKzvUBLIgc/ohAu4Luina0uiizu/fw7R2jf8o/royUgiZi4uI5Ldsr5CZVstQwPVL7P4PH+I7Qe6qGAGBLBlBYql+Wc1gQB0GbjdkKEWpdyb3MvEuZ09bxh92ScsG/WbxpX1xu9lVlzfti97MYpvT2cf9ooyuhU+DrXQmW6YSUuIB9YUjh6C4L8C1imZMQlgiN7LsYxlpMFkKcI86BcMssCgVX3+xcSf4lMcOD6kn1oClcoPM9pK5r3XbmsrzzWTu1DRPpF6sQwxw0MuWu/pJfYnrKUzpK5KyZT5ul6M9tVEHnPz3dFJmroAqrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jo0XPCk8EMRRi/eZQNSbAIIYUIJOZ4OTcUMZN8WAooQ=;
 b=vAN1z48ZTkTjY4nguQUbwFhv2wSXHHppfrMIPcbUb2G3w65r9dss6onF7B/GQEZ0TFJDuTx4qZEyhPjnLmycf+Q8RrAZJmk9w2fV8/c2hT7/BmV6brMZ2BcJc7I2JvDklTzL5xgRq8juvq4wG7CZw6Rb7IXWoACt/FZGhPvH/jU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by DM5PR12MB1241.namprd12.prod.outlook.com (2603:10b6:3:72::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Tue, 1 Mar
 2022 07:03:38 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581%6]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 07:03:38 +0000
Message-ID: <3d37084e-72d4-d3a5-ec8d-df1ac1758fad@amd.com>
Date:   Tue, 1 Mar 2022 08:03:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Content-Language: en-US
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
 <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com>
 <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <0b65541a-3da7-dc35-690a-0ada75b0adae@amd.com>
 <ade13f419519350e460e7ef1e64477ec72e828ed.camel@HansenPartnership.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <ade13f419519350e460e7ef1e64477ec72e828ed.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::18) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 302df7da-fd4a-410d-8dc7-08d9fb519c10
X-MS-TrafficTypeDiagnostic: DM5PR12MB1241:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB12412AEA183322CC6E7C13C883029@DM5PR12MB1241.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CaXFfN3gQBsD59oHgr90d+wbdphgr7kPmQfkKb+3r/NEc/rtNpjNY6xy00e/ndVf+t4JzIsI+/5PIpu2wn48xlzB8AmdcQRuhLNxO3xxEr+bulj3Ft7cnI9VV/q1caN2mRRaFl6yL+7JzxkGqO2FQ4JPw5HwN0a4hORsgcx/Lr7WWbo9nhznkmlz7tRjnbokbE7Imz4+dxctTWz5vwyreMdJxtaT47e9aI3VjxSPohtD94wkes8Z8U5s4WsmbZIOJsjqqXrJvRUk6Tlz1ieqx1f7Bp6BG/9W6u7tQKUwsr+MmM+SHGAuSwdYKWSV7svQrIRqVwkaLpkc9UNT7nVieCuf0iSmvegeQc57E9bHJKGJjwS2IyUEMlMRYfSYqE4Wd/v3+q+ktHFAIZGYIS+RT7YAKuuZtWfVUt4DzFLjZMRGwln+pONLA6eN78uRrxGnkLrnhL3OwFMVKBvtEmCn+Tjr6rYV5PUjuR8vGLjJ/R5YPzsDIeY47ZP7TfAosuthBjQI2hDv1kLQHeZhL5rfSgxdWQTGiLQEsicqwSKJ+ou2nH8ALkwSHUzhfauIJeSJGQ/fp4x9qTUL/vH+v5EQVO7KXW0rC7FaBYKRR1E48OSigpr/7j5lDr2h6wxD0ZWNTR2wbrVr3OqsTgOSjtkpajY4qLR6L1nxD4aGfYzNCRSyRmmePQsF/8TJBnWpG7PAar0kWWzxbxXRkd+SBFa5SEouWYv30crPEj1OmR4uFMw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(26005)(186003)(5660300002)(8676002)(2906002)(66946007)(66556008)(86362001)(66476007)(6666004)(6512007)(2616005)(54906003)(110136005)(66574015)(53546011)(6506007)(316002)(31696002)(7366002)(36756003)(7416002)(8936002)(7406005)(508600001)(38100700002)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTIxUkMwUEhFOC90S0RLb3NieVk0Nm5ESnNXekIwSnNIdm5Qb3lQL3pFVDVl?=
 =?utf-8?B?alMxejBuYzhPZFpyZ1p3d1VvcjRBZ3p1NXFnNDBEWml4Tkl1S1FlWnQ4L3Ju?=
 =?utf-8?B?SHVaOStwczFEeFgxOWNmNklDNEdONDZzMEdoYmFWMlVVRnFiU1pSQVhMb1lX?=
 =?utf-8?B?d0JOS1JIVGtma0dGa0ZiRjJoNktGb0VJay9ybmVBZm5XOXBRdWlqa0wrSjhy?=
 =?utf-8?B?blBuUU5FdDdEdWRIY040Q1JyajRRUHFHb1dyT3Q1bUtvWWFuUzBOc3d0U1FB?=
 =?utf-8?B?elVCUFJSVjhuSmwvdGJFUHNVRHc3RmZzZEZQTEFQTnVRSGVrQTRWWXpIYXJ4?=
 =?utf-8?B?Y0lLWFUwb2RLT0FudlB1MTNYQkNLczkwTDBydUhteUdYMlNnOWJ3VmtUWXgz?=
 =?utf-8?B?bzlKdXo1VmJzaWgvaEkxUXRMSFJPMlFLcnFycVVhTUdtdUl2eUN4UnpZbE9V?=
 =?utf-8?B?UkFFVHFSaDBvbHlleElyN28wSGRSMGl5OURkL1ZQTUw4RUZlS0g3YXY2Z2FC?=
 =?utf-8?B?Zlo5eEpVSEJUNXVhaC9qZHR1R20rRkJrbWZIYUJzR0dma1lDanRJVDA0N0Nu?=
 =?utf-8?B?YjlnYnJMQ1hXN0xuTUpwbEhrQi80YkdHL3VJdTJaVStpZm5BT29UNjJROThN?=
 =?utf-8?B?Zkpvcm1CVTMrMXFPZjAwNmtGSVEvMkpXeFptT2FTT0NDbE9VV0NWSjVpWTBE?=
 =?utf-8?B?ODZSWUorRk5zeGtGbFp2MTQxODNKdXF2WFIrS0tiQTJ1RCtQbXhldDlNemo5?=
 =?utf-8?B?aHZNWjJoSGc3SzRzUnpKRm9LVnRzRzRTN2FLOUFKUnA1WWk5WDRyZjhtcE9p?=
 =?utf-8?B?REdsMUZRRTRQV3dpalIwRWdPcVlqbjlBTFI2bW9VOVdTcGQ2NlpHdTloK1dG?=
 =?utf-8?B?T2g1SUdSWFdYdEVXK25jR0lKdzdoQlVpaUlrcXJuY0l3a3NLcFo3TTFLQnZH?=
 =?utf-8?B?M3poRWtvUTE3WDNQZ1pTUkpSNXlaKzhoSUt5QTBtS2tZZnBmbWVPdUc0aEt2?=
 =?utf-8?B?YjVFU1ZIMjI2UzFVdFp3cnI3NUo4MExCSzJrSW1nemdVS1U0TWR0ckc0RjdE?=
 =?utf-8?B?d0tuOXpGTURPeEcrYzM1MVdhdktnc0NycHBON2pTaE9idWhJbURiWU15cVZI?=
 =?utf-8?B?K1pBS3V1akgzTWJ6bURXTnloYnlPUFhHL3dRN2hmVWpOQUtEQWxrU25XMkV1?=
 =?utf-8?B?WEQrMGwwZzFRVk1ZLzlYZnRUREliTTNjeFZWczZ3Z2VGRll6QVdiaEd3em9k?=
 =?utf-8?B?T2tjcnZMZ1ZkY2I2MHUrcnJmdDF5S3ZZdmlXVER4bkhUbHMySHVQRVNEclFE?=
 =?utf-8?B?V2RMSkljQ1hMamkwT3RxT1QvZjA1RUd6Wk9qYitxY0FlVG80VmNERDc1Zkta?=
 =?utf-8?B?SjFnUG9RcVgwcHZEWk5pVW1LTzlVcnZob1pMbjNrb002VjdvNGdTVExzYlFj?=
 =?utf-8?B?d1BMb1dEQklvNkZrTjRNdy9FdFBCd0xoL05tY0YxQXdrcUZzTzFPa0JWUzhu?=
 =?utf-8?B?RnBuMHpSQTk5MmkxeTEwUG9PNlJuWDNrWGJmbHFUblFpbnBDL0FhdjA3M1Fj?=
 =?utf-8?B?c0paNGhJSEJHSkZIaDdFQ0JMZ0hJVlJmVHR2dVVZVTdxNFdYUTF4K2tmaGJr?=
 =?utf-8?B?aUpwNkVFbzdJelAwdlFDb2U4ZkZPUGNqQW1tQVJvengyZ0pUaWtOQy91VlhH?=
 =?utf-8?B?ZlUzMzFCMFQzQjY4VjJrU0xPN3BjSlBTbGU5d2ltQzlDVTFBaTBPWDBDQTQ5?=
 =?utf-8?B?RWZhZWJ4Q3Y0cy9zaUF1U2RUTjVadnVETUNhS2ttSkdxVVVQNUVESm8wMllX?=
 =?utf-8?B?bFZSVjFLd3VvUTJWYlpaQTZVRlNXWVV4RzlGVkp5UGJhdm8rcFc5MnYvbnI4?=
 =?utf-8?B?UkJ3S2dPU09VMlY2T0VPbHduVWxiYXZqd0NGS1M4MTZPMVdEbkl0d2dEeGMz?=
 =?utf-8?B?NGhlR1lMaFBnbFAxRTdNaHhRNzhNODBiS2V2b1pkK2NuU3dtMEdIaGd0WUdr?=
 =?utf-8?B?YytubUdzU1hVeGZ1NHVPNXpNanhzV1lmRWNtTTBvakx3RjcwQ0ExUmhmcXdR?=
 =?utf-8?B?KzIyVnlRZllQdkVybUJjWi85S0FQbkxQVk1hTVJ4dkY3cExyQldSMldGSjBw?=
 =?utf-8?Q?kjuA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 302df7da-fd4a-410d-8dc7-08d9fb519c10
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 07:03:38.2638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d67d8u277CntQhYj6Sq9JC5m7zDPTNRpA1Ua+t/lEoHqCHZNuqPtsnLUFrJJmruS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1241
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 28.02.22 um 22:13 schrieb James Bottomley:
> On Mon, 2022-02-28 at 21:56 +0100, Christian König wrote:
>> Am 28.02.22 um 21:42 schrieb James Bottomley:
>>> On Mon, 2022-02-28 at 21:07 +0100, Christian König wrote:
>>>> Am 28.02.22 um 20:56 schrieb Linus Torvalds:
>>>>> On Mon, Feb 28, 2022 at 4:19 AM Christian König
>>>>> <christian.koenig@amd.com> wrote:
>>>>> [SNIP]
>>>>> Anybody have any ideas?
>>>> I think we should look at the use cases why code is touching
>>>> (pos)
>>>> after the loop.
>>>>
>>>> Just from skimming over the patches to change this and experience
>>>> with the drivers/subsystems I help to maintain I think the
>>>> primary pattern looks something like this:
>>>>
>>>> list_for_each_entry(entry, head, member) {
>>>>        if (some_condition_checking(entry))
>>>>            break;
>>>> }
>>>> do_something_with(entry);
>>> Actually, we usually have a check to see if the loop found
>>> anything, but in that case it should something like
>>>
>>> if (list_entry_is_head(entry, head, member)) {
>>>       return with error;
>>> }
>>> do_somethin_with(entry);
>>>
>>> Suffice?  The list_entry_is_head() macro is designed to cope with
>>> the bogus entry on head problem.
>> That will work and is also what people already do.
>>
>> The key problem is that we let people do the same thing over and
>> over again with slightly different implementations.
>>
>> Out in the wild I've seen at least using a separate variable, using
>> a bool to indicate that something was found and just assuming that
>> the list has an entry.
>>
>> The last case is bogus and basically what can break badly.
> Yes, I understand that.  I'm saying we should replace that bogus checks
> of entry->something against some_value loop termination condition with
> the list_entry_is_head() macro.  That should be a one line and fairly
> mechanical change rather than the explosion of code changes we seem to
> have in the patch series.

Yes, exactly that's my thinking as well.

Christian.

>
> James
>
>

