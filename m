Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933DFEA5AE
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfJ3VsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:48:17 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:36232 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbfJ3VsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:48:16 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ULkxAi001097;
        Wed, 30 Oct 2019 21:48:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=10I1Fs8RN7uhtYM/xSVX0DOqS1962ajQS5tQluP9NZU=;
 b=fbykdueNGeOBGBlK2OQwRAnVkt/0d8NtPx2w3c/ebDAuMTErdTa+emfvut0nPv/ky8GC
 muhs2Qsj8TWDMohfZtg8IdYUoCE4vP7MsoWzYCMvMPrv6vIw8ihWPtB69/UsPpa7BSoU
 hlHV1fqMgEODfmYtvXV+X356G8f8mDLLYoWIPEeKiwg+V4xBsFA6HGwnlKYGwJ9Y0qQB
 BJ0dDxb5QEmQcYAi9VoWkZKjXzBoh5T9xGPe3l1oBUXAZjRtH/btO1kzY2hztI0u1H6K
 maxJeSh1scI4hEFT7gb1fhE114k27ticy2i5Wq7xEerqXNaeOsqJnSnq9KwxxYnlajHL ZA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2vxwgfw6c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Oct 2019 21:48:06 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9ULlBk4025791;
        Wed, 30 Oct 2019 17:48:06 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2vxwfnwf0s-1;
        Wed, 30 Oct 2019 17:48:02 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 7E6A11FC6A;
        Wed, 30 Oct 2019 21:48:01 +0000 (GMT)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
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
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
Date:   Wed, 30 Oct 2019 14:48:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <74827a046961422207515b1bb354101d@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300191
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_09:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910300191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 11:27 AM, Subash Abhinov Kasiviswanathan wrote:
>> Thanks. Do you mind sharing what your patch looked like, so we can
>> understand precisely what was changed?
>>
>> Also, are you able to share what the workload looked like that tickled
>> this issue? (web client? file server?...)
> 
> Sure. This was seen only on our regression racks and the workload there
> is a combination of FTP, browsing and other apps.
> 
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 4374196..9af7497 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -232,7 +232,8 @@ struct tcp_sock {
>                  fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
>                  fastopen_no_cookie:1, /* Allow send/recv SYN+data 
> without a cookie */
>                  is_sack_reneg:1,    /* in recovery from loss with SACK 
> reneg? */
> -               unused:2;
> +               unused:1,
> +               wqp_called:1;
>          u8      nonagle     : 4,/* Disable Nagle algorithm? */
>                  thin_lto    : 1,/* Use linear timeouts for thin streams */
>                  recvmsg_inq : 1,/* Indicate # of bytes in queue upon 
> recvmsg */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 1a1fcb3..0c29bdd 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2534,6 +2534,9 @@ void tcp_write_queue_purge(struct sock *sk)
>          INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
>          sk_mem_reclaim(sk);
>          tcp_clear_all_retrans_hints(tcp_sk(sk));
> +       tcp_sk(sk)->highest_sack = NULL;
> +       tcp_sk(sk)->sacked_out = 0;
> +       tcp_sk(sk)->wqp_called = 1;
>          tcp_sk(sk)->packets_out = 0;
>          inet_csk(sk)->icsk_backoff = 0;
>   }
> 
> 

Neal

Since tcp_write_queue_purge() calls tcp_rtx_queue_purge() and we're 
deleting everything in the retrans queue there, doesn't it make sense to 
zero out all of those associated counters? Obviously clearing sacked_out 
is helping here, but is there a reason to keep track of lost_out, 
retrans_out, etc if retrans queue is now empty? Maybe calling 
tcp_clear_retrans() from tcp_rtx_queue_purge() ?

Josh
