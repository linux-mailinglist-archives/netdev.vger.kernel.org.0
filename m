Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75ED207B95
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406135AbgFXSco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:32:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405820AbgFXScn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:32:43 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05OI4ti7040303;
        Wed, 24 Jun 2020 14:32:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vbn691n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jun 2020 14:32:19 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05OI50ro040796;
        Wed, 24 Jun 2020 14:32:19 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vbn691ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jun 2020 14:32:18 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05OILJtK011326;
        Wed, 24 Jun 2020 18:32:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 31uusjgwdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Jun 2020 18:32:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05OIWEOu48562236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 18:32:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20054A4051;
        Wed, 24 Jun 2020 18:32:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB69EA404D;
        Wed, 24 Jun 2020 18:32:12 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.22.164])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Jun 2020 18:32:12 +0000 (GMT)
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20200610154923.27510-5-mcgrof@kernel.org>
 <20200623141157.5409-1-borntraeger@de.ibm.com>
 <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
 <20200624144311.GA5839@infradead.org>
 <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
 <20200624160953.GH4332@42.do-not-panic.com>
 <ea41e2a9-61f7-aec1-79e5-7b08b6dd5119@de.ibm.com>
 <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
Date:   Wed, 24 Jun 2020 20:32:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-24_14:2020-06-24,2020-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 cotscore=-2147483648 suspectscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.06.20 20:09, Christian Borntraeger wrote:
> 
> 
> On 24.06.20 19:58, Christian Borntraeger wrote:
>>
>>
>> On 24.06.20 18:09, Luis Chamberlain wrote:
>>> On Wed, Jun 24, 2020 at 05:54:46PM +0200, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 24.06.20 16:43, Christoph Hellwig wrote:
>>>>> On Wed, Jun 24, 2020 at 01:11:54PM +0200, Christian Borntraeger wrote:
>>>>>> Does anyone have an idea why "umh: fix processed error when UMH_WAIT_PROC is used" breaks the
>>>>>> linux-bridge on s390?
>>>>>
>>>>> Are we even sure this is s390 specific and doesn't happen on other
>>>>> architectures with the same bridge setup?
>>>>
>>>> Fair point. AFAIK nobody has tested this yet on x86.
>>>
>>> Regardless, can you enable dynamic debug prints, to see if the kernel
>>> reveals anything on the bridge code which may be relevant:
>>>
>>> echo "file net/bridge/* +p" > /sys/kernel/debug/dynamic_debug/control
>>>
>>>   Luis
>>
>> When I start a guest the following happens with the patch:
>>
>> [   47.420237] virbr0: port 2(vnet0) entered blocking state
>> [   47.420242] virbr0: port 2(vnet0) entered disabled state
>> [   47.420315] device vnet0 entered promiscuous mode
>> [   47.420365] virbr0: port 2(vnet0) event 16
>> [   47.420366] virbr0: br_fill_info event 16 port vnet0 master virbr0
>> [   47.420373] virbr0: toggle option: 12 state: 0 -> 0
>> [   47.420536] virbr0: port 2(vnet0) entered blocking state
>> [   47.420538] virbr0: port 2(vnet0) event 16
>> [   47.420539] virbr0: br_fill_info event 16 port vnet0 master virbr0
>>
>> and the nothing happens.
>>
>>
>> without the patch
>> [   33.805410] virbr0: hello timer expired
>> [   35.805413] virbr0: hello timer expired
>> [   36.184349] virbr0: port 2(vnet0) entered blocking state
>> [   36.184353] virbr0: port 2(vnet0) entered disabled state
>> [   36.184427] device vnet0 entered promiscuous mode
>> [   36.184479] virbr0: port 2(vnet0) event 16
>> [   36.184480] virbr0: br_fill_info event 16 port vnet0 master virbr0
>> [   36.184487] virbr0: toggle option: 12 state: 0 -> 0
>> [   36.184636] virbr0: port 2(vnet0) entered blocking state
>> [   36.184638] virbr0: port 2(vnet0) entered listening state
>> [   36.184639] virbr0: port 2(vnet0) event 16
>> [   36.184640] virbr0: br_fill_info event 16 port vnet0 master virbr0
>> [   36.184645] virbr0: port 2(vnet0) event 16
>> [   36.184646] virbr0: br_fill_info event 16 port vnet0 master virbr0
>> [   37.805478] virbr0: hello timer expired
>> [   38.205413] virbr0: port 2(vnet0) forward delay timer
>> [   38.205414] virbr0: port 2(vnet0) entered learning state
>> [   38.205427] virbr0: port 2(vnet0) event 16
>> [   38.205430] virbr0: br_fill_info event 16 port vnet0 master virbr0
>> [   38.765414] virbr0: port 2(vnet0) hold timer expired
>> [   39.805415] virbr0: hello timer expired
>> [   40.285410] virbr0: port 2(vnet0) forward delay timer
>> [   40.285411] virbr0: port 2(vnet0) entered forwarding state
>> [   40.285418] virbr0: topology change detected, propagating
>> [   40.285420] virbr0: decreasing ageing time to 400
>> [   40.285427] virbr0: port 2(vnet0) event 16
>> [   40.285432] virbr0: br_fill_info event 16 port vnet0 master virbr0
>> [   40.765408] virbr0: port 2(vnet0) hold timer expired
>> [   41.805415] virbr0: hello timer expired
>> [   42.765426] virbr0: port 2(vnet0) hold timer expired
>> [   43.805425] virbr0: hello timer expired
>> [   44.765426] virbr0: port 2(vnet0) hold timer expired
>> [   45.805418] virbr0: hello timer expired
>>
>> and continuing....
> 
> Just reverting the umh.c parts like this makes the problem go away.
> 
> diff --git a/kernel/umh.c b/kernel/umh.c
> index f81e8698e36e..79f139a7ca03 100644
> --- a/kernel/umh.c
> +++ b/kernel/umh.c
> @@ -154,8 +154,8 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
>                  * the real error code is already in sub_info->retval or
>                  * sub_info->retval is 0 anyway, so don't mess with it then.
>                  */
> -               if (KWIFEXITED(ret))
> -                       sub_info->retval = KWEXITSTATUS(ret);
> +               if (ret)
> +                       sub_info->retval = ret;
>         }
>  
>         /* Restore default kernel sig handler */

I instrumented this:

[    5.118528] ret=0x100 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x1 
[    9.409235] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   10.114914] ret=0x100 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x1 
[   10.116308] ret=0x100 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x1 
[   10.117690] ret=0x100 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x1 
[   10.118732] ret=0x100 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x1 
[   10.119899] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   10.121365] ret=0x100 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x1 
[   10.128044] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   10.945814] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   10.962799] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   10.983755] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   10.992705] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.118877] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.124359] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.129364] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.142139] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.148385] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.153686] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.158861] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.164068] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.192445] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.200605] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.208493] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.216612] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.226467] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.525363] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.532758] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.535279] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.697660] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.701634] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.818652] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   11.836228] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   12.082266] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 
[   40.965898] ret=0x0 KWIFEXITED(ret) = 0x1 KWEXITSTATUS(ret)= 0x0 

So the translations look correct. But your change is actually a sematic change
if(ret) will only trigger if there is an error
if (KWIFEXITED(ret)) will always trigger when the process ends. So we will always overwrite -ECHILD
and we did not do it before. 
