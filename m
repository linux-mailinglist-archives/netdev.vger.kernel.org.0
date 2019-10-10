Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68345D3346
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 23:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfJJVRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 17:17:48 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:6858 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726771AbfJJVRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 17:17:47 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ALHODT001098;
        Thu, 10 Oct 2019 22:17:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Dg7p7OCTBIxTsZoczxX3+cNI54yyNGTGeXGPDZzR8us=;
 b=P6aHaYqfRFg0aLDTFT3r6pc5Bse+48V9OUxLNr2a5uFbikSW4ivrIgCcri49tXLmHTGT
 idlwbuufOxVyKCO6B9G1W+RoN6x30kwBSQ5KggSEuK4Gvd4IU+m7PiEUC41XqhMQ2pH9
 5/DpNzZbmb2xLklCZ9iKrtw45VYjxoTLzT9g9Xyn3xy+CqUVx5QuDgGw56sZ3z4jnYCP
 bxhbbaMKGr7lUA7hI87lXjIqoHuszOmAJlMX4Mp6ksRTqWppwsc5UVutXfNX94yQkrDq
 aEFmz5MFjKG9c7nABUjYnn8QXOD4EPieouOy9hJCp51SRz7740HvsCAJxerdnFdOR91u fQ== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2veg1u2s8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 22:17:40 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9ALHJAk025233;
        Thu, 10 Oct 2019 17:17:39 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2vepgycdff-1;
        Thu, 10 Oct 2019 17:17:39 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 1445F80E1D;
        Thu, 10 Oct 2019 21:17:38 +0000 (GMT)
Subject: Re: [PATCH 0/3] igb, ixgbe, i40e UDP segmentation offload support
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <CAKgT0UdBPYRnwAuOGhCBAJSRhdHcnw28Tznr0GPAtqe-JWFjTQ@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <cd8ac880-61fe-b064-6271-993e8c6eee65@akamai.com>
Date:   Thu, 10 Oct 2019 14:17:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdBPYRnwAuOGhCBAJSRhdHcnw28Tznr0GPAtqe-JWFjTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100182
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_07:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/19 3:44 PM, Alexander Duyck wrote:
> On Wed, Oct 9, 2019 at 3:08 PM Josh Hunt <johunt@akamai.com> wrote:
>>
>> Alexander Duyck posted a series in 2018 proposing adding UDP segmentation
>> offload support to ixgbe and ixgbevf, but those patches were never
>> accepted:
>>
>> https://lore.kernel.org/netdev/20180504003556.4769.11407.stgit@localhost.localdomain/
>>
>> This series is a repost of his ixgbe patch along with a similar
>> change to the igb and i40e drivers. Testing using the udpgso_bench_tx
>> benchmark shows a noticeable performance improvement with these changes
>> applied.
>>
>> All #s below were run with:
>> udpgso_bench_tx -C 1 -4 -D 172.25.43.133 -z -l 30 -u -S 0 -s $pkt_size
>>
>> igb::
>>
>> SW GSO (ethtool -K eth0 tx-udp-segmentation off):
>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>> ========================================================================
>> 1472            120143.64       113     81263   81263   83.55   1.35
>> 2944            120160.09       114     40638   40638   62.88   1.81
>> 5888            120160.64       114     20319   20319   43.59   2.61
>> 11776           120160.76       114     10160   10160   37.52   3.03
>> 23552           120159.25       114     5080    5080    34.75   3.28
>> 47104           120160.55       114     2540    2540    32.83   3.47
>> 61824           120160.56       114     1935    1935    32.09   3.55
>>
>> HW GSO offload (ethtool -K eth0 tx-udp-segmentation on):
>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>> ========================================================================
>> 1472            120144.65       113     81264   81264   83.03   1.36
>> 2944            120161.56       114     40638   40638   41      2.78
>> 5888            120160.23       114     20319   20319   23.76   4.79
>> 11776           120161.16       114     10160   10160   15.82   7.20
>> 23552           120156.45       114     5079    5079    12.8    8.90
>> 47104           120159.33       114     2540    2540    8.82    12.92
>> 61824           120158.43       114     1935    1935    8.24    13.83
>>
>> ixgbe::
>> SW GSO:
>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>> ========================================================================
>> 1472            1070565.90      1015    724112  724112  100     10.15
>> 2944            1201579.19      1140    406342  406342  95.69   11.91
>> 5888            1201217.55      1140    203185  203185  55.38   20.58
>> 11776           1201613.49      1140    101588  101588  42.15   27.04
>> 23552           1201631.32      1140    50795   50795   35.97   31.69
>> 47104           1201626.38      1140    25397   25397   33.51   34.01
>> 61824           1201625.52      1140    19350   19350   32.83   34.72
>>
>> HW GSO Offload:
>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>> ========================================================================
>> 1472            1058681.25      1004    715954  715954  100     10.04
>> 2944            1201730.86      1134    404254  404254  61.28   18.50
>> 5888            1201776.61      1131    201608  201608  30.25   37.38
>> 11776           1201795.90      1130    100676  100676  16.63   67.94
>> 23552           1201807.90      1129    50304   50304   10.07   112.11
>> 47104           1201748.35      1128    25143   25143   6.8     165.88
>> 61824           1200770.45      1128    19140   19140   5.38    209.66
>>
>> i40e::
>> SW GSO:
>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>> ========================================================================
>> 1472            650122.83       616     439362  439362  100     6.16
>> 2944            943993.53       895     319042  319042  100     8.95
>> 5888            1199751.90      1138    202857  202857  82.51   13.79
>> 11776           1200288.08      1139    101477  101477  64.34   17.70
>> 23552           1201596.56      1140    50793   50793   59.74   19.08
>> 47104           1201597.98      1140    25396   25396   56.31   20.24
>> 61824           1201610.43      1140    19350   19350   55.48   20.54
>>
>> HW GSO offload:
>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>> ========================================================================
>> 1472            657424.83       623     444653  444653  100     6.23
>> 2944            1201242.87      1139    406226  406226  91.45   12.45
>> 5888            1201739.95      1140    203199  203199  57.46   19.83
>> 11776           1201557.36      1140    101584  101584  36.83   30.95
>> 23552           1201525.17      1140    50790   50790   23.86   47.77
>> 47104           1201514.54      1140    25394   25394   17.45   65.32
>> 61824           1201478.91      1140    19348   19348   14.79   77.07
>>
>> I was not sure how to proper attribute Alexander on the ixgbe patch so
>> please adjust this as necessary.
> 
> For the ixgbe patch I would be good with:
> Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> The big hurdle for this will be validation. I know that there are some
> parts such as the 82598 in the case of the ixgbe driver or 82575 in
> the case of igb that didn't support the feature, and I wasn't sure
> about the parts supported by i40e either.  From what I can tell the
> x710 datasheet seems to indicate that it is supported, and you were
> able to get it working with your patch based on the numbers above. So
> that just leaves validation of the x722 and making sure there isn't
> anything firmware-wise on the i40e parts that may cause any issues.

Thanks for feedback Alex.

For validation, I will look around and see if we have any of the above 
chips in our testbeds. The above #s are from i210, 82599ES, and x710 
respectively. I'm happy to share my wrapper script for the gso selftest 
if others have the missing chipsets and can verify.

Thanks!
Josh
