Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A00B71BC
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbfISC7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:59:09 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:51132 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727305AbfISC7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 22:59:09 -0400
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x8J2qKIc004046;
        Thu, 19 Sep 2019 03:59:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=HIVIULjw1/etjO3zGk7JusMUdnE4D7X3OW6P2Jfp7es=;
 b=InLqWs1kvMa2udnSldQtptRIF9SlNFTAd0Jp0HGy9HIFAOQqn0e9GwtzZmdQf+7TIU3F
 3npkLZhfpWfKp5zYiweE1eNzZCRSuVCZ6RpMgBzNojKqpXxqeynAw9gUY7bhlbdedegN
 Q5h4AZNwe9D5t3ZqbxSQkaO2KxFPAjiyKFPjOV8P8zOZD//f3I/O7TvKXXCZkF0wDtSx
 ITlo8pB0CRexkYq9IRnJzE59j+U26khZizbvGd1wmkzPrOkAe2XaxyNiFq2H1NtT2dCt
 W9wFuQ3RfyYBIXWkzhZDfDHn5PnHYVi9MD9vYc7nYCL7gc6KDYLU4qrBkHUAEqDoWgBa /A== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 2v3vaw12dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Sep 2019 03:59:05 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x8J2nu7X021071;
        Wed, 18 Sep 2019 19:59:04 -0700
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint5.akamai.com with ESMTP id 2v3vefgh21-1;
        Wed, 18 Sep 2019 19:59:04 -0700
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 8EED71FC6B;
        Thu, 19 Sep 2019 02:59:03 +0000 (GMT)
Subject: Re: udp sendmsg ENOBUFS clarification
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
References: <ce01f024-268d-a44e-8093-91be97f1e8b0@akamai.com>
 <CA+FuTSc3O4XQAmtyY5Fwy96nL17ewdCouvwAJ=6DeMUcQUiz8A@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <ef67fdfc-d5f1-79af-064d-997c13adbea7@akamai.com>
Date:   Wed, 18 Sep 2019 19:59:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSc3O4XQAmtyY5Fwy96nL17ewdCouvwAJ=6DeMUcQUiz8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-19_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=877
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909190023
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-19_01:2019-09-18,2019-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=895 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1909190024
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 8:35 AM, Willem de Bruijn wrote:
> On Tue, Sep 17, 2019 at 4:20 PM Josh Hunt <johunt@akamai.com> wrote:
>>
>> I was running some tests recently with the udpgso_bench_tx benchmark in
>> selftests and noticed that in some configurations it reported sending
>> more than line rate! Looking into it more I found that I was overflowing
>> the qdisc queue and so it was sending back NET_XMIT_DROP however this
>> error did not propagate back up to the application and so it assumed
>> whatever it sent was done successfully. That's when I learned about
>> IP_RECVERR and saw that the benchmark isn't using that socket option.
>>
>> That's all fairly straightforward, but what I was hoping to get
>> clarification on is where is the line drawn on when or when not to send
>> ENOBUFS back to the application if IP_RECVERR is *not* set? My guess
>> based on going through the code is that as long as the packet leaves the
>> stack (in this case sent to the qdisc) that's where we stop reporting
>> ENOBUFS back to the application, but can someone confirm?
> 
> Once a packet is queued the system call may return, so any subsequent
> drops after dequeue are not propagated back. The relevant rc is set in
> __dev_xmit_skb on q->enqueue. On setups with multiple devices, such as
> a tunnel or bonding path, enqueue on the lower device is similar not
> propagated.

Yeah that makes total sense. Once it's enqueued you'd expect it to not 
be able to return an error, but in this particular case we get an error 
on enqueue so was surprised when it did not get back to the application.

> 
>> For example, we sanitize the error in udp_send_skb():
>> send:
>>           err = ip_send_skb(sock_net(sk), skb);
>>           if (err) {
>>                   if (err == -ENOBUFS && !inet->recverr) {
>>                           UDP_INC_STATS(sock_net(sk),
>>                                         UDP_MIB_SNDBUFERRORS, is_udplite);
>>                           err = 0;
>>                   }
>>           } else
>>
>>
>> but in udp_sendmsg() we don't:
>>
>>           if (err == -ENOBUFS || test_bit(SOCK_NOSPACE,
>> &sk->sk_socket->flags)) {
>>                   UDP_INC_STATS(sock_net(sk),
>>                                 UDP_MIB_SNDBUFERRORS, is_udplite);
>>           }
>>           return err;
> 
> That's interesting. My --incorrect-- understanding until now had been
> that IP_RECVERR does nothing but enable optional extra detailed error
> reporting on top of system call error codes.
> 
> But indeed it enables backpressure being reported as a system call
> error that is suppressed otherwise. I don't know why. The behavior
> precedes git history.

Yeah it's interesting. I wasn't able to find any documentation or 
discussion on it either which is why I figured I'd ask the question on 
netdev in case others know.

> 
>> In the case above it looks like we may only get ENOBUFS for allocation
>> failures inside of the stack in udp_sendmsg() and so that's why we
>> propagate the error back up to the application?
> 
> Both the udp lockless fast path and the slow corked path go through
> udp_send_skb, so the backpressure is suppressed consistently across
> both cases.
> 
> Indeed the error handling in udp_sendmsg then is not related to
> backpressure, but to other causes of ENOBUF, i.e., allocation failure.
> 

Yep. Thanks for going through this. We'll see if others have any 
comments. I will likely send a patch for the man page adding that you 
can get ENOBUFS on Linux but need to set IP_RECVERR as Eric pointed out 
in the patch I linked to previously.

Josh
