Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFEA1A3B8
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfEJUKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 16:10:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbfEJUKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 16:10:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AK43Nk044278;
        Fri, 10 May 2019 20:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wdSwICY/ygPtf7dxhy+947Fby4ZA7tj+GNdtNBEOUrg=;
 b=azJEIydEM51WBBSVZmiDOxluutwmxCi9Nnq709ez8D5cOv3cnGB+5/30HokE+SaWdMGv
 7q2zFnXmeaNrzhXdWhmkzxXTnx8Dzi27w8jgd230kc32OzaxnieR2iQ5q8RDeW6gKQYA
 B/ZwmwgyAOxzc9p8HV0UKTbLK3hHQmrhR61RDRk25bG4VXWtevee3yoG1J0j3PXMErDu
 DdWVj3sJl56zWRMwzj6WB5DUP3/FB9rlSDfgTlHIw4nfSCLtHlnsBqvEqIofMJQrKuN8
 1+d7MuHH+oSSbaQ9vlv5cShUsbrvIs1lxlv3U3q+W9xOC5dTW13TpI6DzfYLIYUIc3O4 Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b1bbd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 20:10:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AK9Wpq092987;
        Fri, 10 May 2019 20:10:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s94ahjmj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 20:10:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4AKA8Mx011595;
        Fri, 10 May 2019 20:10:09 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 13:10:08 -0700
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190510125431.GA15434@ziepe.ca>
 <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
 <20190510175538.GB13038@ziepe.ca>
 <9b0e6760-b684-c1ce-6bf5-738eff325240@oracle.com>
 <20190510180719.GD13038@ziepe.ca>
 <d25910f3-51f1-9214-3479-150b1d320e43@oracle.com>
 <20190510192046.GH13038@ziepe.ca>
 <2c16b35d-c20c-e51d-5d4e-0904c740a4ec@oracle.com>
 <20190510194753.GI13038@ziepe.ca>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <bb3d7aa4-e400-1b2f-dfd0-2b711816ee53@oracle.com>
Date:   Fri, 10 May 2019 13:12:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510194753.GI13038@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9253 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100131
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9253 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/2019 12:47 PM, Jason Gunthorpe wrote:
> On Fri, May 10, 2019 at 12:38:31PM -0700, Santosh Shilimkar wrote:
>> On 5/10/2019 12:20 PM, Jason Gunthorpe wrote:
>>> On Fri, May 10, 2019 at 11:58:42AM -0700, santosh.shilimkar@oracle.com wrote:
>>>> On 5/10/19 11:07 AM, Jason Gunthorpe wrote:
>>>>> On Fri, May 10, 2019 at 11:02:35AM -0700, santosh.shilimkar@oracle.com wrote:
>>
>> [...]
>>
>>>>> Why would you need to detect FS DAX memory? GUP users are not supposed
>>>>> to care.
>>>>>
>>>>> GUP is supposed to work just 'fine' - other than the usual bugs we
>>>>> have with GUP and any FS backed memory.
>>>>>
>>>> Am not saying there is any issue with GUP. Let me try to explain the
>>>> issue first. You are aware of various discussions about doing DMA
>>>> or RDMA on FS DAX memory. e.g [1] [2] [3]
>>>>
>>>> One of the proposal to do safely RDMA on FS DAX memory is/was ODP
>>>
>>> It is not about safety. ODP is required in all places that would have
>>> used gup_longterm because ODP avoids th gup_longterm entirely.
>>>
>>>> Currently RDS doesn't have support for ODP MR registration
>>>> and hence we don't want user application to do RDMA using
>>>> fastreg/fmr on FS DAX memory which isn't safe.
>>>
>>> No, it is safe.
>>>
>>> The only issue is you need to determine if this use of GUP is longterm
>>> or short term. Longterm means userspace is in control of how long the
>>> GUP lasts, short term means the kernel is in control.
>>>
>>> ie posting a fastreg, sending the data, then un-GUP'ing on completion
>>> is a short term GUP and it is fine on any type of memory.
>>>
>>> So if it is a long term pin then it needs to be corrected and the only
>>> thing the comment needs to explain is that it is a long term pin.
>>>
>> Thanks for clarification. At least the distinction is clear to me now. Yes
>> the key can be valid for long term till the remote RDMA IO is issued and
>> finished. After that user can issue an invalidate/free key or
>> upfront specify a flag to free/invalidate the key on remote IO
>> completion.
> 
> Again, the test is if *userspace* controls this. So if userspace is
> the thing that does the invalidate/free then it is long term. Sounds
> like if it specifies the free/invalidate flag then it short term.
> 
> At this point you'd probably be better to keep both options.
>
Thats possible using the provided flag state but I am still not sure
whether its guaranteed to be safe when marked as short term even with
flag which tells kernel to invalidate/free the MR on remote IO
completion. Till the remote server finishes the IO, there is
still a window where userspace on local server can
modify the file mappings. Registered file handle say was
ftuncated to zero by another process and the backing memory
was allocated  by some other process as part of fallocate.
Now the mapping on HCA is invalid from local userspace perspective
but since key is valid, remote can still do RDMA to that region.

How do we avoid such an issue without GUP_longterm ?

>> Will update the commit message accordingly. Can you please also
>> comment on question on 2/2 ?
> 
> I have no advice on how to do compatability knobs in netdev - only
> that sysctl does not seem appropriate.
>   
OK. Let me think about alternative.

Regards,
Santosh
