Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102A232E1F9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhCEGG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCEGG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 01:06:28 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8631EC061574;
        Thu,  4 Mar 2021 22:06:26 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n10so643759pgl.10;
        Thu, 04 Mar 2021 22:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9CaErE4FXeql1gXgshWXUI5h/4VlMYlVPUbDTYqc8PU=;
        b=THKkIJ0NqC/MMw9JAo1hyQCg+vKPXt4XxX4PhuplkBAuHlE/S0pnw71mbuBSeq1XWj
         knuf5xtZ9q/V0l0hZ4oTVQypdbnerQ5pW1QKApsizJALST/yc1LC1hZDYW9HESs2vAV8
         JOYBifl0gagWGYMrmYF7Bp7c2fIaXmJBC8B38/cfVihwhh3Jp8pk7tXIOLD24/9reVHz
         L3D9ubboNrq8LeeTNobEWyAaC+j0Kvowi0+CKqrww6eL6OWTcgyNFcDH88xYpwyBiWf3
         y7zvTa+a0+wxxr4mh2M+53MVAoSztYtNzB4lbgFopyBMx4EUzzmLKl0iaawfcH9oYm9q
         sICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9CaErE4FXeql1gXgshWXUI5h/4VlMYlVPUbDTYqc8PU=;
        b=rUadRfVdAK6BHo3/QrQoyGsnLrs0MckPffIlxTkpLKLh2Zmw1A5alkdVY2yqTHBLcq
         3ICbdTN6llYmH9rA5OwMryQ5hRzionP/buBYfA0mYb3e88BqCPlMNN6jJadnoEbKyMia
         bOLAMYBV+ITr1k23gaDhOLsJGaY/+WzAziAVyRy6Rvgu6liWhdU4y8Ewp2j4G4GCRpKz
         75ZeiD/VN2P2uYFm67Tj47glmIo+h1iOxabQrSHwNkkTpiqoGPTFuTKmXos9gStCd21L
         2FL+YGE8rjnAxxqtNyoy3z5drcEwBoOZXrmEr1BgjnXtzsKBrvW0InvPw4mv7SQ0PRbU
         tnOQ==
X-Gm-Message-State: AOAM532p0Dat090R8HfAYbwkilD5dV3BoNGXrgzAU7+xVIfQ5Pn8Nt7J
        /0jPTf5hdjCgLQFy/ntTqDFriFI0I8Rbfw==
X-Google-Smtp-Source: ABdhPJxrX73NFj9WGGrslSfV+HxWI2FMZTh4n7O2JaJPPURKgsW0l64shyGFC4/dpMAlgxKxI90dCw==
X-Received: by 2002:aa7:86d9:0:b029:1ef:4f40:4bba with SMTP id h25-20020aa786d90000b02901ef4f404bbamr4295179pfo.54.1614924386031;
        Thu, 04 Mar 2021 22:06:26 -0800 (PST)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id o9sm1239116pfh.47.2021.03.04.22.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 22:06:25 -0800 (PST)
Subject: Re: [RFC PATCH 1/12] x86/Hyper-V: Add visibility parameter for
 vmbus_establish_gpadl()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org
References: <20210228150315.2552437-1-ltykernel@gmail.com>
 <20210228150315.2552437-2-ltykernel@gmail.com>
 <87y2f4cidh.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <e4be1a18-c882-50ef-3ac7-7838c9dfa5ba@gmail.com>
Date:   Fri, 5 Mar 2021 14:06:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87y2f4cidh.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vitaly:
      Thanks for your review.

On 3/4/2021 12:27 AM, Vitaly Kuznetsov wrote:
> Tianyu Lan <ltykernel@gmail.com> writes:
> 
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> Add visibility parameter for vmbus_establish_gpadl() and prepare
>> to change host visibility when create gpadl for buffer.
>>
> 
> "No functional change" as you don't actually use the parameter.

Yes, will add it into commit log.

> 
>> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
>> Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Nit: Sunil's SoB looks misleading because the patch is from you,
> Co-Developed-by should be sufficient.
> 

Will update.

>> ---
>>   arch/x86/include/asm/hyperv-tlfs.h |  9 +++++++++
>>   drivers/hv/channel.c               | 20 +++++++++++---------
>>   drivers/net/hyperv/netvsc.c        |  8 ++++++--
>>   drivers/uio/uio_hv_generic.c       |  7 +++++--
>>   include/linux/hyperv.h             |  3 ++-
>>   5 files changed, 33 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index e6cd3fee562b..fb1893a4c32b 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -236,6 +236,15 @@ enum hv_isolation_type {
>>   /* TSC invariant control */
>>   #define HV_X64_MSR_TSC_INVARIANT_CONTROL	0x40000118
>>   
>> +/* Hyper-V GPA map flags */
>> +#define HV_MAP_GPA_PERMISSIONS_NONE		0x0
>> +#define HV_MAP_GPA_READABLE			0x1
>> +#define HV_MAP_GPA_WRITABLE			0x2
>> +
>> +#define VMBUS_PAGE_VISIBLE_READ_ONLY HV_MAP_GPA_READABLE
>> +#define VMBUS_PAGE_VISIBLE_READ_WRITE (HV_MAP_GPA_READABLE|HV_MAP_GPA_WRITABLE)
>> +#define VMBUS_PAGE_NOT_VISIBLE HV_MAP_GPA_PERMISSIONS_NONE
>> +
> 
> Are these x86-only? If not, then we should probably move these defines
> to include/asm-generic/hyperv-tlfs.h. In case they are, we should do
> something as we're using them from arch neutral places.
> 
> Also, could you please add a comment stating that these flags define
> host's visibility of a page and not guest's (this seems to be not
> obvious at least to me).
>




>>   /*
>>    * Declare the MSR used to setup pages used to communicate with the hypervisor.
>>    */
>> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
>> index 0bd202de7960..daa21cc72beb 100644
>> --- a/drivers/hv/channel.c
>> +++ b/drivers/hv/channel.c
>> @@ -242,7 +242,7 @@ EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
>>    */
>>   static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
>>   			       u32 size, u32 send_offset,
>> -			       struct vmbus_channel_msginfo **msginfo)
>> +			       struct vmbus_channel_msginfo **msginfo, u32 visibility)
>>   {
>>   	int i;
>>   	int pagecount;
>> @@ -391,7 +391,7 @@ static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
>>   static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>>   				   enum hv_gpadl_type type, void *kbuffer,
>>   				   u32 size, u32 send_offset,
>> -				   u32 *gpadl_handle)
>> +				   u32 *gpadl_handle, u32 visibility)
>>   {
>>   	struct vmbus_channel_gpadl_header *gpadlmsg;
>>   	struct vmbus_channel_gpadl_body *gpadl_body;
>> @@ -405,7 +405,8 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>>   	next_gpadl_handle =
>>   		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
>>   
>> -	ret = create_gpadl_header(type, kbuffer, size, send_offset, &msginfo);
>> +	ret = create_gpadl_header(type, kbuffer, size, send_offset,
>> +				  &msginfo, visibility);
>>   	if (ret)
>>   		return ret;
>>   
>> @@ -496,10 +497,10 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>>    * @gpadl_handle: some funky thing
>>    */
>>   int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
>> -			  u32 size, u32 *gpadl_handle)
>> +			  u32 size, u32 *gpadl_handle, u32 visibility)
>>   {
>>   	return __vmbus_establish_gpadl(channel, HV_GPADL_BUFFER, kbuffer, size,
>> -				       0U, gpadl_handle);
>> +				       0U, gpadl_handle, visibility);
>>   }
>>   EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
>>   
>> @@ -610,10 +611,11 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
>>   	newchannel->ringbuffer_gpadlhandle = 0;
>>   
>>   	err = __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
>> -				      page_address(newchannel->ringbuffer_page),
>> -				      (send_pages + recv_pages) << PAGE_SHIFT,
>> -				      newchannel->ringbuffer_send_offset << PAGE_SHIFT,
>> -				      &newchannel->ringbuffer_gpadlhandle);
>> +			page_address(newchannel->ringbuffer_page),
>> +			(send_pages + recv_pages) << PAGE_SHIFT,
>> +			newchannel->ringbuffer_send_offset << PAGE_SHIFT,
>> +			&newchannel->ringbuffer_gpadlhandle,
>> +			VMBUS_PAGE_VISIBLE_READ_WRITE);
> 
> Nit: I liked the original alignment more and we can avoid the unneeded
> code churn.
> 
>>   	if (err)
>>   		goto error_clean_ring;
>>   
>> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
>> index 2353623259f3..bb72c7578330 100644
>> --- a/drivers/net/hyperv/netvsc.c
>> +++ b/drivers/net/hyperv/netvsc.c
>> @@ -333,7 +333,8 @@ static int netvsc_init_buf(struct hv_device *device,
>>   	 */
>>   	ret = vmbus_establish_gpadl(device->channel, net_device->recv_buf,
>>   				    buf_size,
>> -				    &net_device->recv_buf_gpadl_handle);
>> +				    &net_device->recv_buf_gpadl_handle,
>> +				    VMBUS_PAGE_VISIBLE_READ_WRITE);
>>   	if (ret != 0) {
>>   		netdev_err(ndev,
>>   			"unable to establish receive buffer's gpadl\n");
>> @@ -422,10 +423,13 @@ static int netvsc_init_buf(struct hv_device *device,
>>   	/* Establish the gpadl handle for this buffer on this
>>   	 * channel.  Note: This call uses the vmbus connection rather
>>   	 * than the channel to establish the gpadl handle.
>> +	 * Send buffer should theoretically be only marked as "read-only", but
>> +	 * the netvsp for some reason needs write capabilities on it.
>>   	 */
>>   	ret = vmbus_establish_gpadl(device->channel, net_device->send_buf,
>>   				    buf_size,
>> -				    &net_device->send_buf_gpadl_handle);
>> +				    &net_device->send_buf_gpadl_handle,
>> +				    VMBUS_PAGE_VISIBLE_READ_WRITE);
>>   	if (ret != 0) {
>>   		netdev_err(ndev,
>>   			   "unable to establish send buffer's gpadl\n");
>> diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
>> index 0330ba99730e..813a7bee5139 100644
>> --- a/drivers/uio/uio_hv_generic.c
>> +++ b/drivers/uio/uio_hv_generic.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/hyperv.h>
>>   #include <linux/vmalloc.h>
>>   #include <linux/slab.h>
>> +#include <asm/mshyperv.h>
>>   
>>   #include "../hv/hyperv_vmbus.h"
>>   
>> @@ -295,7 +296,8 @@ hv_uio_probe(struct hv_device *dev,
>>   	}
>>   
>>   	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
>> -				    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
>> +				    RECV_BUFFER_SIZE, &pdata->recv_gpadl,
>> +				    VMBUS_PAGE_VISIBLE_READ_WRITE);
>>   	if (ret)
>>   		goto fail_close;
>>   
>> @@ -315,7 +317,8 @@ hv_uio_probe(struct hv_device *dev,
>>   	}
>>   
>>   	ret = vmbus_establish_gpadl(channel, pdata->send_buf,
>> -				    SEND_BUFFER_SIZE, &pdata->send_gpadl);
>> +				    SEND_BUFFER_SIZE, &pdata->send_gpadl,
>> +				    VMBUS_PAGE_VISIBLE_READ_ONLY);
> 
> Actually, this is the only place where you use 'READ_ONLY' mapping --
> which makes me wonder if it's actually worth it or we can hard-code
> VMBUS_PAGE_VISIBLE_READ_WRITE for now and avoid this additional
> parameter.
> 

Another option is to set host visibility out of vmbus_establish_gpadl(). 
There are three places calling vmbus_establish_gpadl(). Vmbus, netvsc 
and uio drivers.

>>   	if (ret)
>>   		goto fail_close;
>>   
>> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
>> index f1d74dcf0353..016fdca20d6e 100644
>> --- a/include/linux/hyperv.h
>> +++ b/include/linux/hyperv.h
>> @@ -1179,7 +1179,8 @@ extern int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
>>   extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
>>   				      void *kbuffer,
>>   				      u32 size,
>> -				      u32 *gpadl_handle);
>> +				      u32 *gpadl_handle,
>> +				      u32 visibility);
>>   
>>   extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
>>   				     u32 gpadl_handle);
> 
