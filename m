Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416CB11035E
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLCRYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 12:24:49 -0500
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:43910 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726484AbfLCRYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 12:24:49 -0500
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3HMjOH007227;
        Tue, 3 Dec 2019 17:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=8j874wqZgTXk820rXjZvI+WKmjpxaIKDq9NdV0zMafM=;
 b=QpgF+ffMicbJH0WGV8n/nYb+xZZp1iz44KE3It669M4H42b+Fpf/BbscGjwC53vsUISd
 /oyjPoYIPmGYLpZ1oBp2BguGXfB8JTNLsr/yiZzMCh/jPy58quJt1zo33Sou/wOYsCKX
 nf3TYifneOIvTH4TCmaG3Xl+pI/EhLb3TOI4DmqN0W3Lvht9t8WGwdJEVaSNZ18jcBwk
 SiI0SUozBCsNak4Lw44eSKnI6Nu1VRnqBQuuhfffyt//ThuTxAaVOMpEpGWytBltL1T5
 dXqEBEpz/+0y9dkak564DHidPL7EQJppur9NCb6/4A4d/Ffo8MnNkQbSoUDT4U8Mu2GB 9A== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2wnkj79r4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 17:24:43 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id xB3HHegu001963;
        Tue, 3 Dec 2019 12:24:42 -0500
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2wkmmyk3pp-2;
        Tue, 03 Dec 2019 12:24:41 -0500
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 3137581218;
        Tue,  3 Dec 2019 17:24:35 +0000 (GMT)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     subashab@codeaurora.org, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
 <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org>
 <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
 <74827a046961422207515b1bb354101d@codeaurora.org>
 <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
 <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com>
 <5a267a9d-2bf5-4978-b71d-0c8e71a64807@gmail.com>
 <0101016eba38455f-e79cd85a-a807-4309-bf3b-8a788135f3f2-000000@us-west-2.amazonses.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <f2016893-bf9e-3b65-4fe8-ff1bba4f4ced@akamai.com>
Date:   Tue, 3 Dec 2019 09:24:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <0101016eba38455f-e79cd85a-a807-4309-bf3b-8a788135f3f2-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-12-03_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030130
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_05:2019-12-02,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912030129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/19 6:51 PM, subashab@codeaurora.org wrote:
>>>> Since tcp_write_queue_purge() calls tcp_rtx_queue_purge() and we're 
>>>> deleting everything in the retrans queue there, doesn't it make 
>>>> sense to zero out all of those associated counters? Obviously 
>>>> clearing sacked_out is helping here, but is there a reason to keep 
>>>> track of lost_out, retrans_out, etc if retrans queue is now empty? 
>>>> Maybe calling tcp_clear_retrans() from tcp_rtx_queue_purge() ?
>>>
>>> First, I would like to understand if we hit this problem on current 
>>> upstream kernels.
>>>
>>> Maybe a backport forgot a dependency.
>>>
>>> tcp_write_queue_purge() calls tcp_clear_all_retrans_hints(), not 
>>> tcp_clear_retrans(),
>>> this is probably for a reason.
>>>
>>> Brute force clearing these fields might hide a serious bug.
>>>
>>
>> I guess we are all too busy to get more understanding on this :/
> 
> Our test devices are on 4.19.x and it is not possible to switch to a newer
> version. Perhaps Josh has seen this on a newer kernel.

Sorry I've been out of town without email access. To be clear I've never 
seen this crash. I've only noticed that we do not clear some counters 
when we clear out the retransmit queue and this caught my eye when 
debugging another unrelated issue. I will try and get some cycles this 
week to instrument a kernel and reproduce the behavior I was seeing. My 
concern IIRC was more around tcp_left_out() being > packets_out and 
retrans_out causing tcp_packets_in_flight() to wrap. Anyway I'll report 
my findings on this thread if they seem relevant otherwise maybe I'll 
start another discussion thread. I don't want to pollute this one with 
my ramblings...

Josh
