Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49A61A334
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 20:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfEJS6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 14:58:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41626 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfEJS6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 14:58:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AIwjQS182555;
        Fri, 10 May 2019 18:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=psbcggnwCbHqVUIGLWJqXqeYJ2Nv5NCgcm/et5n9K+4=;
 b=cdipuxHON4tBT6wIO/KIoRAZFdk6kUahfHFKgPDRrBfD/eulhspQzlksFLMBgHAdc4LT
 qpSsbqvvYYgKQfYGkUW0SVwbJ9ABXIHINFJMd8kQm+2iDTRUswqAGkhDmIKE8kl6ldIN
 4APU9ifoYCR2od2ReiZYvuls1hDh4fiCTjgFulQ/ZvWJ27WkgmCsrMGGCx/NYiO4jadZ
 kM9vXj892urHvIPEHzSWvM/FnlH2ukFiqtzwwHlyuKny9OpfbfwB+Kd+pTr13XltxikV
 nBIw+Nl810RmpoIlfYyX/3nu8RjliZCKgyBZo/2TJe5zPyRL2lLCPH/M7q39kVcy/SB+ bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2s94b6k2tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 18:58:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AIviel194105;
        Fri, 10 May 2019 18:58:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2schw0k33f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 18:58:44 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4AIwhGc015489;
        Fri, 10 May 2019 18:58:43 GMT
Received: from Santoshs-MacBook-Pro.local (/10.11.23.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 11:58:43 -0700
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
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <d25910f3-51f1-9214-3479-150b1d320e43@oracle.com>
Date:   Fri, 10 May 2019 11:58:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510180719.GD13038@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100123
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/19 11:07 AM, Jason Gunthorpe wrote:
> On Fri, May 10, 2019 at 11:02:35AM -0700, santosh.shilimkar@oracle.com wrote:
>>
>>
>> On 5/10/19 10:55 AM, Jason Gunthorpe wrote:
>>> On Fri, May 10, 2019 at 09:11:24AM -0700, Santosh Shilimkar wrote:
>>>> On 5/10/2019 5:54 AM, Jason Gunthorpe wrote:
>>>>> On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
>>>>>> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>>>>
>>>>>> RDS doesn't support RDMA on memory apertures that require On Demand
>>>>>> Paging (ODP), such as FS DAX memory. User applications can try to use
>>>>>> RDS to perform RDMA over such memories and since it doesn't report any
>>>>>> failure, it can lead to unexpected issues like memory corruption when
>>>>>> a couple of out of sync file system operations like ftruncate etc. are
>>>>>> performed.
>>>>>
>>>>> This comment doesn't make any sense..
>>>>>
>>>>>> The patch adds a check so that such an attempt to RDMA to/from memory
>>>>>> apertures requiring ODP will fail.
>>>>>>
>>>>>> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
>>>>>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>>>>>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>>>>>     net/rds/rdma.c | 5 +++--
>>>>>>     1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>
[...]

> 
> Why would you need to detect FS DAX memory? GUP users are not supposed
> to care.
> 
> GUP is supposed to work just 'fine' - other than the usual bugs we
> have with GUP and any FS backed memory.
> 
Am not saying there is any issue with GUP. Let me try to explain the
issue first. You are aware of various discussions about doing DMA
or RDMA on FS DAX memory. e.g [1] [2] [3]

One of the proposal to do safely RDMA on FS DAX memory is/was ODP
Since its hooked with mm, it can block file system operations
like ftruncate on the mmaped file systems handle while ongoing IO(RDMA).

Currently RDS doesn't have support for ODP MR registration
and hence we don't want user application to do RDMA using
fastreg/fmr on FS DAX memory which isn't safe. So the intention
was, to make RDS_GET_MR fail if the user provided memory are is
FS DAX & RDS kernel module doesn't support ODP.

We have systems equipped with both regular DRAM as well as PMEM
DIMMs. So RDS needs to find out what kind of memory user is
passing to registers for RDMA. If its regular DRAM, it will
continue as now and return the key to application and if its
FS DAX memory, it  suppose to fail the call. GUP long
term was used since it checked fs dax memory and
reports -EOPNOTSUPP for fs_dax memory. Using that error
code, patch was making RDS get_mr call fail.

In short, till the ODP support added to RDS, we want the RDMA
request to fail for FS dax memory.

Hope above clarifies it.

Regards,
Santosh

[1] https://lwn.net/Articles/737273/
[2] https://lkml.org/lkml/2019/2/5/570
[3] https://lists.01.org/pipermail/linux-nvdimm/2018-January/013935.html

