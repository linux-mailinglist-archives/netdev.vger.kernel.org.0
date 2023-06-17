Return-Path: <netdev+bounces-11660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA6E733D54
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 02:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A4F31C20A7D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D92630;
	Sat, 17 Jun 2023 00:47:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF285371
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:47:24 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446573AA5;
	Fri, 16 Jun 2023 17:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fA+UjN8dt6O848U/KrE+674uZNtClC8CymbxbktKM5foIKoAZgDeOhThAkCXT2f+yFMd79kubLTxeFz6ihkPkkb5YUMxnVq/gYG5fQm2b0ncDnP8zcncTdI4QPBmj+3mhYmgyq6zTTZCVVhr1MlN5SV1Zkiiin0M1/gEIWpJqsgKnxEjjJOD4kdxs3aQq68F2W7LPKOTY2vZMgrmbNSGfpTYjS+4REOo/kBQi53mHRSkNXjExORcYNOhRdOvb2pUfQSwP6+k3h91a9N/nqom1Jw3Tph2GRldLG8HSBoJjlhDySGscjDI/dHt8WJ4WjfNfHNQseyLK1W5Sk85D7u7kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rW5bfAzevZoYO9gZzGT9oNwWUtTgrVheqN1+eVjyiZ0=;
 b=kpcn9NO6rT9D4THPYmtg6YUXxZ3ilIgKjj8/yRy+PE9sw5jtyZ4dQ8odaVxinbjk+TmcPEG8eUlEny0lRzU5awNjbbpacOa5iegpcgTPBfWVeWWLof8UvJp1mHrPv3Z2ix2Gef4hPpHSiI9GaiuhR/L1RxKAIjBpjEiobgEJdCs2PcEcYD6mPLS1LWO5Dg4Gqx5m7PoSIll042B38p3kZW9xgtdU2oo2lazsrE0KphBnsMbyWwBbCES2NdkFhgczJ9W/6PlE+kXgFJzh9pp0tRwu49SuxpCXV/a/lEIiD93ZH2GW8/RUr7WecLamTvg60lob7BsxFX1CIFxII43vdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW5bfAzevZoYO9gZzGT9oNwWUtTgrVheqN1+eVjyiZ0=;
 b=KGEOT5aZ3BdDSsYSg2P/0E9N1LN3WwR+dWsT+eCVjthnKQr+qAPeQrHA+0cUNlCCt9hstFlVIYUWvnaJxJckHQNnqKY6ZmUbYclX24jZBzsDyqtCczKA47RpadEACsIjyXAq8xt4AM86kN2WnwfUyXlKuT8zkWRqqutvBPn+8jE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS7PR12MB8229.namprd12.prod.outlook.com (2603:10b6:8:ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Sat, 17 Jun
 2023 00:47:20 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Sat, 17 Jun 2023
 00:47:19 +0000
Message-ID: <7cf529ef-3a0e-efc2-3cd0-d4bc98dd4a4a@amd.com>
Date: Fri, 16 Jun 2023 17:47:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 6/7] vfio/pds: Add support for firmware recovery
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>,
 Brett Creeley <brett.creeley@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com"
 <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-7-brett.creeley@amd.com>
 <BN9PR11MB52765DA10BA305647D5D2A7A8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52765DA10BA305647D5D2A7A8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::6) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS7PR12MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3d90b0-6493-4b5a-6186-08db6ecc67bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	crHYRqzMJnzPx4AozOO/1FK0Hie80tSV3cvcCLkP222YNBR1Rkvs+6YEaaArnLGAwAQNBalTHPngL5lww0iR/VL3GAF9uHpe+iZjgDwk+WjV524zpnatu2tc4Ht7MXNwXpmvckQnmITkLvp5/NZZOBPyyOljaGSZ2zydNxKVMGf31mk9fDRN2LtPWrI/xbTtfTUousi0Xfm3gKlw+4XF7bIUxL/AkJXQTOQ223DxLmEkUV6gJa+3teOzPnSzsVEey1koFRxMJojisS4UtsCpXgFbGRSszaOen5h61OPsjh+duZ0HXlNxci3RLkheqQcjPqcd5Q6Y//l8TDqeYCD1dHPBmZ2KkI4oVHnhjElZueI8UaDO6Kb/V1tnRFA8KA7M5bPdjxjmCz72g79ZI7X/xVS7IKpUcGEf27bgQ+TuHZC5cr/1xLfksSUCsA31jxmDwri4HZ2yPZ32Vur+4sOXhVgd/fSJPJEwGRMP1ridaNQ42DWvTnHajHms6YBcaIAxc7Aed5FXhx6OMOmhN7j8OEomExzldxLzRTOX/tBgHR5rGzCd5TyQsehv2PHsTC9Qd24KMzxn1FsnE8Ay9Fu4SMOfCZ56O/hzgx5JOAuJStrZl0SC4hLUPsjjxkxS0wBQE/YEbeBU//zsR/Ls00gnqg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199021)(53546011)(6512007)(6506007)(26005)(4326008)(66946007)(66476007)(316002)(66556008)(2616005)(186003)(83380400001)(31686004)(6486002)(110136005)(478600001)(38100700002)(8676002)(8936002)(5660300002)(31696002)(36756003)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDZqakYwK0dEcTIvUmVkR0dLbkszZUx3Zk9GdXU2NVdLZCswY21DYlNsakR4?=
 =?utf-8?B?aStNcytxQThaSlRJY0JkVGxtNmJUekF3Z2FqZ3RpSnN3SnFaamZWWGFKaUJR?=
 =?utf-8?B?YjlxeUo2Y3N4b1ljS1I1aGR6aDNUOUpJWWs2TWtuU1Btb2JJM2pzZlFVSFpQ?=
 =?utf-8?B?MU10ZVFwOHFTOFRhY3NaL25ISy93czdoYkhTQjhZOWJ1ZWxVNGZwdVp5WFhk?=
 =?utf-8?B?ZkZPK0xBRndGMXpRbU9WeVBmNHN0eUNqOCtleDdUckRyVXlxT1VrYjR2eWk3?=
 =?utf-8?B?L2ZQNE1sVTExbTMxcDR0dWd2cnRDQ2p1K1VISWpPOTdmeVc0dEIxbU1OUE9P?=
 =?utf-8?B?cHFNOXkzSWg2aDExQnpHcGJTdE5DdzVzRnFnU2tteVZsOC81Nk5FbXdTNGFw?=
 =?utf-8?B?SWZMWWlWc0tLY1FpRE1hZTV1Snlhdnc4Y25YQ2IrbWJ0TmF6ckJGbFhmNDlC?=
 =?utf-8?B?ZTIzQU1mcGR0NzhNZmQzRm1kK2JVOW9xZW1mZDM5WDNreWM3cmo1am5GWnBy?=
 =?utf-8?B?SlY3UStXMWxlRHBUdWpsdy83OVhneVRqZGZ1RjF0Sko4bWFWa0VHVjVPWXNs?=
 =?utf-8?B?Y29wQWtpc3MxSXo2UDF6OEVWbGx1THdBT0VmNE1NUFA2M1FCbmJaNS9POHBl?=
 =?utf-8?B?Q3k4U0lzcDJuN0VFVDlueEJjallxTmczODVnblhOSHdnaTlCVjhhK1doRzh1?=
 =?utf-8?B?T2FrU3l4U2NMZXNHdEVqdHBqN2FKbGszZ0FacUJDSVJRckhRVVBRSEJuTjBn?=
 =?utf-8?B?Ukd1RkRpRm9JSTFvWHNtRXljejhhQlVrZFBtQ2gvKzhDUkoyK0dlUHpNd2xE?=
 =?utf-8?B?M3l6Uk13ditCYzRUaGtiY01HSE1YNDBNSHd5d1JPTEVyTnJHVkR0UTRQSnl4?=
 =?utf-8?B?TmtrV2Ntb2lad1RDYXUrNGtMcGhCWHpRQ1JVUmt6R1hWeDV6VWtsNHdPZkZE?=
 =?utf-8?B?QlNwU09rdnc2MG5UU2JTZEo1UTZZUU5WbUdXTG9DenV5d0hXaGIrNG1EZmRq?=
 =?utf-8?B?dC9pWWVWSlJNRElkbko3VStBK252U3hMRmJhY0tvY0xSRFM4ajBaUEVmSHd3?=
 =?utf-8?B?alBLc0IvUjJMc3FyRXJ6UVp4NERBbHo1Z1JuY2I5bG4vM3VXVzNRTXV5aktQ?=
 =?utf-8?B?NGRpdW1ERjFZcXd1TWJzUlRjYXdTdHI5MFhTWGRKMEREaVNvSlB4aGliek5n?=
 =?utf-8?B?N1FaNEJjVkJhNE5YMlA5NXo3c3ZqZVhJWHlEMk9LZ2UwVndmM290WXhoaVhh?=
 =?utf-8?B?UThyU3o1ajhqZWZDR3p1R1JvVFFBREV0MXJ4Zmk0NnlWZTNiY2Z1SlNNOFlX?=
 =?utf-8?B?YTlkWk1kclBSdVNwZG1Pd1FQcGZlR05XekRVOHVRNGJxa0VRUEROdmFVT0ds?=
 =?utf-8?B?WDV4VHY3WTEraWV5T2owVjg5bVN4RHJpbFdib2s0UDRZSVVGV2VzWUtJYmta?=
 =?utf-8?B?Y1VwR3V0TStKZnJlM1NQOEpsa3M4YUpCeHR0ajNmL0ZSM2tXSXNUbk9XOW1l?=
 =?utf-8?B?TGs4cVljZjZxczkvajZxUGg2czhCU00zdllOZm43ZXVObDg0eDhYM1VGZDBS?=
 =?utf-8?B?VTJCNloxejhLeWxGbkhocktGaWpEdjVZeG52bmI0WDgrUmFqMEFCemx5THFw?=
 =?utf-8?B?c0NibFJ6RjJjYWpUME4rR2hPVHdiNWJTRXRyV3VVUWt0UU91dnBmZHFmckpC?=
 =?utf-8?B?YmwzQTlKSzlZM3ZIRlhhZ0h4QmtTQWtuckRSZ2YvKzhGZExJMzdqMjFDYllV?=
 =?utf-8?B?OXh2V2lQcDhYMDdleERoaUlsRytiNzNCZTJGVTAxT2ZBaWIrQlMzamFXKzBh?=
 =?utf-8?B?NFAwZzdRWnc4OE5pcmVENEhRZUJGV0ovSzVUK0VSYjJ1UWpJM1M1citobWVh?=
 =?utf-8?B?a093R0N2UThtUTd4QStjdDdZenpqamQvZ1ZSOUNzdy83MDBBcG52Zi9HVUk0?=
 =?utf-8?B?eEVtVjltOXNPQlhPNXN0NEoxUEp5MjhYWjFCNyswU0JQSmgrS2FJSHFWa1lZ?=
 =?utf-8?B?U2ttWHE5czVDVGUzMkxuS3BnUUU2ZFU2YTNncHVuSXBoM01QdTZnUWtZOVI3?=
 =?utf-8?B?M01UUlJ2dTU5Yk9DWFlVdWZoV0FVV2V4bWlDRmNQWFVmdTdNdXdNQzQzN29r?=
 =?utf-8?Q?fi3Zr0zb48t4SngcepLz2sEAW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3d90b0-6493-4b5a-6186-08db6ecc67bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2023 00:47:19.7396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJJ7eHgTocfPviL9cDWCwJvvMAhoHwHZczpxr0h9aPmcfxJbtiCyJo2N/5efFlDbj4KI9BwrlWIkwT1xPw5boA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8229
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/2023 1:24 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>>
>> +static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     bool deferred_reset_needed = false;
>> +
>> +     /*
>> +      * Documentation states that the kernel migration driver must not
>> +      * generate asynchronous device state transitions outside of
>> +      * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
>> +      *
>> +      * Since recovery is an asynchronous event received from the device,
>> +      * initiate a deferred reset. Only issue the deferred reset if a
>> +      * migration is in progress, which will cause the next step of the
>> +      * migration to fail. Also, if the device is in a state that will
>> +      * be set to VFIO_DEVICE_STATE_RUNNING on the next action (i.e.
>> VM is
>> +      * shutdown and device is in VFIO_DEVICE_STATE_STOP) as that will
>> clear
>> +      * the VFIO_DEVICE_STATE_ERROR when the VM starts back up.
> 
> the last sentence after "Also, ..." is incomplete?

Yeah, not sure what happened there. Will fix. Thanks.

> 
>> +      */
>> +     mutex_lock(&pds_vfio->state_mutex);
>> +     if ((pds_vfio->state != VFIO_DEVICE_STATE_RUNNING &&
>> +          pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
>> +         (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
>> +          pds_vfio_dirty_is_enabled(pds_vfio)))
>> +             deferred_reset_needed = true;
> 
> any unwind to be done in the dirty tracking path? When firmware crashes
> presumably the cmd to retrieve dirty pages is also blocked...

Hmm. I'll double check this. Thanks.

> 
>> +     mutex_unlock(&pds_vfio->state_mutex);
>> +
>> +     /*
>> +      * On the next user initiated state transition, the device will
>> +      * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the
>> user's
>> +      * responsibility to reset the device.
>> +      *
>> +      * If a VFIO_DEVICE_RESET is requested post recovery and before the
>> next
>> +      * state transition, then the deferred reset state will be set to
>> +      * VFIO_DEVICE_STATE_RUNNING.
>> +      */
>> +     if (deferred_reset_needed)
>> +             pds_vfio_deferred_reset(pds_vfio,
>> VFIO_DEVICE_STATE_ERROR);
> 
> open-code as here is the only caller.
> 
>> +}
>> +
>> +static int pds_vfio_pci_notify_handler(struct notifier_block *nb,
>> +                                    unsigned long ecode, void *data)
>> +{
>> +     struct pds_vfio_pci_device *pds_vfio =
>> +             container_of(nb, struct pds_vfio_pci_device, nb);
>> +     struct device *dev = pds_vfio_to_dev(pds_vfio);
>> +     union pds_core_notifyq_comp *event = data;
>> +
>> +     dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
>> +
>> +     /*
>> +      * We don't need to do anything for RESET state==0 as there is no
>> notify
>> +      * or feedback mechanism available, and it is possible that we won't
>> +      * even see a state==0 event.
>> +      *
>> +      * Any requests from VFIO while state==0 will fail, which will return
>> +      * error and may cause migration to fail.
>> +      */
>> +     if (ecode == PDS_EVENT_RESET) {
>> +             dev_info(dev, "%s: PDS_EVENT_RESET event received,
>> state==%d\n",
>> +                      __func__, event->reset.state);
>> +             if (event->reset.state == 1)
>> +                     pds_vfio_recovery(pds_vfio);
>> +     }
> 
> Please explain what state==0 is, and why state==1 is handled while
> state==2 is not.

Sure, will clarify. Thanks.

> 
>> @@ -33,10 +33,13 @@ void pds_vfio_state_mutex_unlock(struct
>> pds_vfio_pci_device *pds_vfio)
>>        if (pds_vfio->deferred_reset) {
>>                pds_vfio->deferred_reset = false;
>>                if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
>> -                     pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
>> +                     pds_vfio->state = pds_vfio->deferred_reset_state;
>>                        pds_vfio_put_restore_file(pds_vfio);
>>                        pds_vfio_put_save_file(pds_vfio);
>> +             } else if (pds_vfio->deferred_reset_state ==
>> VFIO_DEVICE_STATE_ERROR) {
>> +                     pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
>>                }
>> +             pds_vfio->deferred_reset_state =
>> VFIO_DEVICE_STATE_RUNNING;
> 
> this is not required. 'deferred_reset_state' should be set only when
> deferred_reset is true. Currently only in the notify path and reset path.
> 
> So the last assignment is pointless.
> 
> It's simpler to be:
> 
>          if (pds_vfio->deferred_reset) {
>                  pds_vfio->deferred_reset = false;
>                  if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
>                          pds_vfio_put_restore_file(pds_vfio);
>                          pds_vfio_put_save_file(pds_vfio);
>                  }
>                  pds_vfio->state = pds_vfio->deferred_reset_state;
>                  ...
>          }

I think that makes sense. I will take another look and fix/improve this 
on the next version.
> 

