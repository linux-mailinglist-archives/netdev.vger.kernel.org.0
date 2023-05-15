Return-Path: <netdev+bounces-2742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3662703CA5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A32A51C20C05
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9740E565;
	Mon, 15 May 2023 18:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6692182D0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:30:43 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2049.outbound.protection.outlook.com [40.107.212.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072A246B2
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:30:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cxg6P6icx+nQkDPWVS8XbIOjoTsmUBCoM+638ICqckL9fVryRuoQCwfAoYIGWi2+anDh3HUpLZnHn1jtSlAUDSvECxkCxe+DfsC/D5RbO2g+9jnAj/EA8O16LX0iE43zgpGl5RjU6VQXHqjzTHKpG8xSpqWrdsy8kX4UQvJoUa/R6wwRcmQW7LgNKlOeqjG2DVxd2YujkcCNEfa2R72ODpkVmC/59ZfdLNc37duE2wtJp2pE0EHDb17AuTX1U+1reV6hK1frIzlJcYpa3Exd1xhL2fBVUSKyW+eFs+XlXJQe6EvD/xxJ2WyATiN9ilEIuptGHpzfRFc9nwSFF4Sm7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q711ubYKFPcGk+ZtOZtXhPLA/r3fdhXk1taCpUXS+Fo=;
 b=eFd7lTNt1JmAiQiImDdrFlWRIfHc2lHO250dK0r7W1ckjIvS0KZl/EFoKyqd95XbxZL+lSG8a5FdHeZHcw4cL0BF5vNJeDEroKFFCnL/U6aIYrYckmKrRO3lJNI7sCXarEeaDnmVrPVdYd+0z0Vdzup2ooDuLM++ju2W0gI1Ix14tWAMEvPPotlJT4pCvrMBtXQYcTNuLTCcRBsWLfdJ1FGAs7xbT8qzGKJ8pjVF1oOEpCseerJKuWRza0olGk+tyFvHIWelaQyGMYp6CCpgwTfVsijLOHgAd/qWiU1onSGfY2Ihyxms9YMdwZsG8R8xQEz9LddBL6g6IeOSV3pL4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q711ubYKFPcGk+ZtOZtXhPLA/r3fdhXk1taCpUXS+Fo=;
 b=tErNTvZf9TFTNPpvCn9+MK/CZCQeIZAdg6KHtDYH5ZX335XgoEKrh74AJphRssIlYMMIA1UszM9/xhmwDPRXa+D1YZ3PQZ4fm9MFt6TSVwKY13go3E6FEbeJv7qAaCyTeb5Tpg7DQ9R/oPn8Q3HDlvgEcMURDtuSo79skRoPtLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 18:30:39 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 18:30:39 +0000
Message-ID: <429e42a9-c478-6951-2661-d3fa569a6e83@amd.com>
Date: Mon, 15 May 2023 11:30:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v5 virtio 10/11] pds_vdpa: subscribe to the pds_core
 events
Content-Language: en-US
To: Jason Wang <jasowang@redhat.com>
Cc: "mst@redhat.com" <mst@redhat.com>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "Creeley, Brett" <Brett.Creeley@amd.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "simon.horman@corigine.com" <simon.horman@corigine.com>,
 "drivers@pensando.io" <drivers@pensando.io>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
 <20230503181240.14009-11-shannon.nelson@amd.com>
 <CACGkMEuytKwDp3GLcaQmU1CtWSmb2RZRaGdgFyXoCqveruJBpA@mail.gmail.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEuytKwDp3GLcaQmU1CtWSmb2RZRaGdgFyXoCqveruJBpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:a03:333::12) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 869c13be-9bb6-4f77-0127-08db55727bb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RVFDPP10cGVO6UTG1MkjIbQyuV+bHaHSB7Rw7bfmza5Toq23k57qnS9Ro2PYoDso9WVQV9IKatoce7JGTx0mIkM9o44wp3ySWSxSpQCkSQDKTlI3//G8BqB8hL4XYH1LCzMamW9TE/YGaIEykIZYHXMsmGzpYCyjMPzmVnQINCJrX1nPPdioLwiv3E6971y+X0ACjh3PtjCG/B2fDy6aC8gfHojfy2Z81BSwzwH8LzBaZTsPphml8aNxRbEaL1lYSZZ4EKmyOLuoK/XTp6UKj05XyF2PEmGr+9FLlKFGDHox8rJBetdbZnH80nzg2WLTSWQHZGqWR9tnt3TaiN5ewQjjmiK++2CCnEJyRZvuASviUzL3J3qDKKnjZQsyx1G0hRLDadjh0RGYGSg4sE01hMRo40G/XfSJAftm50Zh9C71lBWmZGNKjyArtWhf6jVwoitezbnZPHKU1pMXEqoJVeni6x7Y+XYqMXuqIlCNU6jabPeGjSdhhzz4+uJa47wfldy4FPwX/Ku1Tvykvliv6MTHtshItP7bSmssEJXExQMYw+KnlBeVRETWD5/mNLI03ksIRaUHw20MnHnZV8XYdWA6Xu+4dhYOVqlQK1PxUIqhXGGrJB656OubZe7zRuq67agbF+LoQEmrRQo9r9PNIQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199021)(86362001)(2906002)(31696002)(66946007)(66556008)(66476007)(316002)(4326008)(6916009)(38100700002)(6666004)(36756003)(478600001)(54906003)(83380400001)(53546011)(31686004)(8676002)(26005)(186003)(8936002)(6506007)(44832011)(6512007)(41300700001)(2616005)(6486002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emdBZ1BZSDR1dG14VlozeVNKcjVpSXhLR0xjbCtlQVBCcW5kdU9uRUFOeTQ2?=
 =?utf-8?B?REJyUHpNbXlaa2FGdmF1RWFEVjZ1QWtxM3h6TVZ5R1hkenJHbEg0Y2MrdWNJ?=
 =?utf-8?B?dzlYcmttZjdUWkdkVld6R3FmK25RbWNLcXRKMjNnQklCcHJpL1BTVlhHaE9O?=
 =?utf-8?B?UlRuMXJVdzJoQUFkUUZZd2xEQndXUzh0b1U1NXcvaENNZ1MwTGxGekVuaGtX?=
 =?utf-8?B?ZGhnVXhZeWhud1BnSVVSUEg0ZVlleHVhTEtGTXV5QTV6RFJtUmJHS1lZRnds?=
 =?utf-8?B?RThDblpsVEtyTWZBUHZDRjduYTk5dGJ6eGFvQ3J5SFZpMHpHUGM5ejEyUGlN?=
 =?utf-8?B?QWQ3L0swZHlXdmliaTRxZVNWa1U5SlpBZ3FHa1YyWi9uTExUakNob2YzSFJG?=
 =?utf-8?B?YjNjd3NvUmVoYnhQUzl0ZkNlR2lQTllhZVB1V2NIa0R6MkFaM2FybFFBMldJ?=
 =?utf-8?B?TzlaMWRXaUlkcGU3K3NaSm9odkhFRjJLc0RhY0pDSmQvS1NGRk5BTW5XQ3oy?=
 =?utf-8?B?a0xqeVVRazEwL1IrTGZvMGVQdkZoMERrZ2hnN05MTGswUWg4Q1RkSlpPQkZQ?=
 =?utf-8?B?QVBhZWNZWDNDMHU1a29WbFZLQ3lVMFdiT1FHZ1VWVFpaM0UvejNOVGFLUHlV?=
 =?utf-8?B?bXRMcnBIejB1OVUyZEFNRFEvUW5XQ2hlK0kxV1ViY2xMZyt4SjFWT0V0M3F5?=
 =?utf-8?B?Y3JKWS95R2dLeXJWeDFSa29VTk4yUVZKNElnakpSMmhvWXFicWtkV1QyejJS?=
 =?utf-8?B?a2E5ZjFqVm84MFBpdDJ1ZXQ0RGpucmRWZ3JqcHBodTN5NnhhQW1uMi85TDNl?=
 =?utf-8?B?Zm1ZaTRmanMyWldWQmRvM0kxa1Z0azBEWjlRS1VPb1JOZHR2c3IvSWVXSjZa?=
 =?utf-8?B?WEw5cERJc3pmb3BkbHo1Yk1ualVMNzVzUkgyN2U0cjkzMi9qcm1tSlBxSm5z?=
 =?utf-8?B?N053enowbTNUSXNhWkE4MUJIZ3dBazE3ZU9idkVzU241OXFHSTdhSUxyRjhj?=
 =?utf-8?B?UTc0eXFvN0lvcStnYmpGKzVwL2ErTWZsMUxRdjVoeHVTajVjREVGd2FjUEQv?=
 =?utf-8?B?YXRUN0dwczc5a0tYNE13T0NwUkRvd3N2YzRJZ2N5eHJPSHlLajdKcnVTcGEy?=
 =?utf-8?B?RmFxaERVU0IrNnJIOFd2aGxncVR3WDVwdlE3bGwxQlg5TkZRL0tBbm5yVEZj?=
 =?utf-8?B?ci9jS21mSFJ0QmcydC83T21VTld2UHFHOVFzU1FPd01nMzdGeHk2eG0ra0Vj?=
 =?utf-8?B?L040Tm1NMFBDRkYvWEp4cnRPZlVEUnFSRjMyRVhNN1d4T3gwUTgxMEhYY2NH?=
 =?utf-8?B?cUlFdGdkcVM1TER0amN6OEQ5VEF0aVJLM25TeFcxMEtMNUx2bWQyaHl4RXVN?=
 =?utf-8?B?RmhRNno0TW5xWDI0dVd2ZzduTHBnSFljOG5Obk13elJEbW9ydDhSRlo4Z0xo?=
 =?utf-8?B?cXpGVE5rZ2JXaWxMLzZOSDMyMm1nbzVBZ1JneVQyNk5yOWx2MTFjSlhNWW4w?=
 =?utf-8?B?a3hSVk5ibENvTTZnMHpsU1EvbC9OY3g3bUxPdjVyaE1uenQ0SmNqQ1VwMUV3?=
 =?utf-8?B?K2d3MGJsNHV1MXJKRnNEaFhvalFOdGFuT3drWUtad01QN3lEbEsyM3BhVTdh?=
 =?utf-8?B?bWlyN3JhTWhuOHViZEI2Z1RhTG9VRzNBNWVSUndFZk8wT1pxRWVraEdhREF6?=
 =?utf-8?B?ekJOZXU4UE5DZ1VJOU5Lc01sNHA3dlJEQ3VZS0haREkrZi9wdzFMUnhxZmFM?=
 =?utf-8?B?czhxUmQ3TzRjcERzOEVTUTBmZXREK1g5b282NXhlZURwRkthN1ljdTRXL2VV?=
 =?utf-8?B?eVFSWnZ0YW1aMUhpd1pZMVdMQ0dSMlJIOURYVUsxdkR4ZVpxaDVZZVlIZ3Vs?=
 =?utf-8?B?NzNsVTBadldmanB3MklYMjNwSFJCQU11UkVBdytNam9ZbmxkSnZobHhUNFVX?=
 =?utf-8?B?OTR3VFJWSU8zMjluMkJuYW9NR200dVZ6cThOUHVtaWtVTHlRS2duQXNDNFZO?=
 =?utf-8?B?VElRWW1FVGs3cW90UjB0OVFQN0ViLzlEYmYrOWdvUG41ekN5WEZZSEhyTFhZ?=
 =?utf-8?B?ak1nMTZZcElxVmYrejRlSW5ZUW0xd0t5SUthZjU2Z0JvdFY4UjFocjlHTXMz?=
 =?utf-8?Q?fcz4U5qB8y7/YlRjv6KwLWh9C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869c13be-9bb6-4f77-0127-08db55727bb4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 18:30:39.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1TyBYQryJV6scWYo4XmH0W6CIT8p+JZFmi+pvznTS8MX2jClegE4fSRCruyWcIWP0b73WG8VNa/GUq27QqAhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/14/23 10:02 PM, Jason Wang wrote:
> On Thu, May 4, 2023 at 2:13 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> Register for the pds_core's notification events, primarily to
>> find out when the FW has been reset so we can pass this on
>> back up the chain.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/vdpa_dev.c | 68 ++++++++++++++++++++++++++++++++++++-
>>   drivers/vdpa/pds/vdpa_dev.h |  1 +
>>   2 files changed, 68 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
>> index 9970657cdb3d..377eefc2fa1e 100644
>> --- a/drivers/vdpa/pds/vdpa_dev.c
>> +++ b/drivers/vdpa/pds/vdpa_dev.c
>> @@ -21,6 +21,61 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
>>          return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
>>   }
>>
>> +static int pds_vdpa_notify_handler(struct notifier_block *nb,
>> +                                  unsigned long ecode,
>> +                                  void *data)
>> +{
>> +       struct pds_vdpa_device *pdsv = container_of(nb, struct pds_vdpa_device, nb);
>> +       struct device *dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
>> +
>> +       dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
>> +
>> +       /* Give the upper layers a hint that something interesting
>> +        * may have happened.  It seems that the only thing this
>> +        * triggers in the virtio-net drivers above us is a check
>> +        * of link status.
>> +        *
>> +        * We don't set the NEEDS_RESET flag for EVENT_RESET
>> +        * because we're likely going through a recovery or
>> +        * fw_update and will be back up and running soon.
>> +        */
>> +       if (ecode == PDS_EVENT_RESET || ecode == PDS_EVENT_LINK_CHANGE) {
> 
> The code here seems to conflict with the comment above. If we don't
> set NEEDS_RESET, there's no need for the config callback?

Yes, that's an out-of-date comment that should be removed.  I think we 
really just need to pass up the stack the hint that something 
interesting may have happened and let the upper layers decide what they 
want to do with whatever info they have available.

I'll clean up this comment block.

sln


> 
> Thanks
> 
>> +               if (pdsv->config_cb.callback)
>> +                       pdsv->config_cb.callback(pdsv->config_cb.private);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
>> +{
>> +       struct device *dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
>> +       struct notifier_block *nb = &pdsv->nb;
>> +       int err;
>> +
>> +       if (!nb->notifier_call) {
>> +               nb->notifier_call = pds_vdpa_notify_handler;
>> +               err = pdsc_register_notify(nb);
>> +               if (err) {
>> +                       nb->notifier_call = NULL;
>> +                       dev_err(dev, "failed to register pds event handler: %ps\n",
>> +                               ERR_PTR(err));
>> +                       return -EINVAL;
>> +               }
>> +               dev_dbg(dev, "pds event handler registered\n");
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void pds_vdpa_unregister_event_handler(struct pds_vdpa_device *pdsv)
>> +{
>> +       if (pdsv->nb.notifier_call) {
>> +               pdsc_unregister_notify(&pdsv->nb);
>> +               pdsv->nb.notifier_call = NULL;
>> +       }
>> +}
>> +
>>   static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>>                                     u64 desc_addr, u64 driver_addr, u64 device_addr)
>>   {
>> @@ -522,6 +577,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>>
>>          pdsv->vdpa_dev.mdev = &vdpa_aux->vdpa_mdev;
>>
>> +       err = pds_vdpa_register_event_handler(pdsv);
>> +       if (err) {
>> +               dev_err(dev, "Failed to register for PDS events: %pe\n", ERR_PTR(err));
>> +               goto err_unmap;
>> +       }
>> +
>>          /* We use the _vdpa_register_device() call rather than the
>>           * vdpa_register_device() to avoid a deadlock because our
>>           * dev_add() is called with the vdpa_dev_lock already set
>> @@ -530,13 +591,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>>          err = _vdpa_register_device(&pdsv->vdpa_dev, pdsv->num_vqs);
>>          if (err) {
>>                  dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR_PTR(err));
>> -               goto err_unmap;
>> +               goto err_unevent;
>>          }
>>
>>          pds_vdpa_debugfs_add_vdpadev(vdpa_aux);
>>
>>          return 0;
>>
>> +err_unevent:
>> +       pds_vdpa_unregister_event_handler(pdsv);
>>   err_unmap:
>>          put_device(&pdsv->vdpa_dev.dev);
>>          vdpa_aux->pdsv = NULL;
>> @@ -546,8 +609,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>>   static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
>>                               struct vdpa_device *vdpa_dev)
>>   {
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>>          struct pds_vdpa_aux *vdpa_aux;
>>
>> +       pds_vdpa_unregister_event_handler(pdsv);
>> +
>>          vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
>>          _vdpa_unregister_device(vdpa_dev);
>>
>> diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
>> index a21596f438c1..1650a2b08845 100644
>> --- a/drivers/vdpa/pds/vdpa_dev.h
>> +++ b/drivers/vdpa/pds/vdpa_dev.h
>> @@ -40,6 +40,7 @@ struct pds_vdpa_device {
>>          u8 vdpa_index;                  /* rsvd for future subdevice use */
>>          u8 num_vqs;                     /* num vqs in use */
>>          struct vdpa_callback config_cb;
>> +       struct notifier_block nb;
>>   };
>>
>>   int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
>> --
>> 2.17.1
>>
> 

