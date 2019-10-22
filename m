Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26543E0C9F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfJVTeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:34:13 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:44942 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbfJVTeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:34:13 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9MJWd2e003061;
        Tue, 22 Oct 2019 20:34:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=nqBXFcOfPfGbhDdkBDyREmGRiwzlSgM4rwlHjHsJ2lI=;
 b=dOe7nO7MuFThJPVeAjYscwiMu8gianay4mW/VQevbqIb0yBUUfqWZnitrzH7V6ob3Vfu
 G+0LrOdsFR4YXkv6n2QIUWYDsiRaZgPUqqLrJpryGoNbJKiktRj3IC0CpL4I54WtGc4h
 sNT9i4ixzs26Pg6I21Jw+Lp8GpvpE7JSeRpJMldE2MowU7Iq29P/AxMKYed7awa/wHgt
 3s+UrGxPClfecFhbXEDIZaaLYPfIYI/sbG7i+pAyJiDo6hQ5TFFL2dkw4M+WtuiZmwyD
 6FFKOYyJuQVdAX5dxpnK+NWe+dTvrmgTSuahYDM1mlzsXzg1KAaP7r+Y82n0E87z3elv Ug== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2vqsr9s423-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 20:34:02 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9MJWTvi001010;
        Tue, 22 Oct 2019 12:33:50 -0700
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint5.akamai.com with ESMTP id 2vr0f8d31c-1;
        Tue, 22 Oct 2019 12:33:50 -0700
Received: from [172.29.170.83] (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id B3F791FC36;
        Tue, 22 Oct 2019 19:33:50 +0000 (GMT)
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
 <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com>
 <20191021195150.GA7514@MacBook-Pro-64.local>
 <CANn89iJEYWVkS5bw1XtnW7NUP-WjZP1EY4Wzgs9u-VYyy0u-_Q@mail.gmail.com>
 <0841fe66-15a7-418f-4b57-4af6e2d45922@akamai.com>
 <CADVnQykxoK4JarMN_5Lps8YobTtoJvVstehbCZQ4P3hAGUQ+Uw@mail.gmail.com>
 <CAK6E8=eUP9irp3QSZgF7Yd-OT2L2HwNx8SweXDYaGiSz-FJLrQ@mail.gmail.com>
From:   Jason Baron <jbaron@akamai.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jbaron@akamai.com; prefer-encrypt=mutual; keydata=
 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
 JeQ7iQ==
Message-ID: <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com>
Date:   Tue, 22 Oct 2019 15:32:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAK6E8=eUP9irp3QSZgF7Yd-OT2L2HwNx8SweXDYaGiSz-FJLrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220164
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_06:2019-10-22,2019-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910220164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/22/19 2:17 PM, Yuchung Cheng wrote:
> On Mon, Oct 21, 2019 at 7:14 PM Neal Cardwell <ncardwell@google.com> wrote:
>>
>> On Mon, Oct 21, 2019 at 5:11 PM Jason Baron <jbaron@akamai.com> wrote:
>>>
>>>
>>>
>>> On 10/21/19 4:36 PM, Eric Dumazet wrote:
>>>> On Mon, Oct 21, 2019 at 12:53 PM Christoph Paasch <cpaasch@apple.com> wrote:
>>>>>
>>>>
>>>>> Actually, longterm I hope we would be able to get rid of the
>>>>> blackhole-detection and fallback heuristics. In a far distant future where
>>>>> these middleboxes have been weeded out ;-)
>>>>>
>>>>> So, do we really want to eternalize this as part of the API in tcp_info ?
>>>>>
>>>>
>>>> A getsockopt() option won't be available for netlink diag (ss command).
>>>>
>>>> So it all depends on plans to use this FASTOPEN information ?
>>>>
>>>
>>> The original proposal I had 4 states of interest:
>>>
>>> First, we are interested in knowing when a socket has TFO set but
>>> actually requires a retransmit of a non-TFO syn to become established.
>>> In this case, we'd be better off not using TFO.
>>>
>>> A second case is when the server immediately rejects the DATA and just
>>> acks the syn (but not the data). Again in that case, we don't want to be
>>> sending syn+data.
>>>
>>> The third case was whether or not we sent a cookie. Perhaps, the server
>>> doesn't have TFO enabled in which case, it really doesn't make make
>>> sense to enable TFO in the first place. Or if one also controls the
>>> server its helpful in understanding if the server is mis-configured. So
>>> that was the motivation I had for the original four states that I
>>> proposed (final state was a catch-all state).
>>>
>>> Yuchung suggested dividing the 3rd case into 2 for - no cookie sent
>>> because of blackhole or no cookie sent because its not in cache. And
>>> then dropping the second state because we already have the
>>> TCPI_OPT_SYN_DATA bit. However, the TCPI_OPT_SYN_DATA may not be set
>>> because we may fallback in tcp_send_syn_data() due to send failure. So
> but sendto would return -1 w/ EINPROGRESS in this case already so the
> application shouldn't expect TCPI_OPT_SYN_DATA?

Ok, but let's say the sk_stream_alloc_skb() fails in
tcp_send_syn_data(), in that case we aren't going to send a TFO cookie
(just a regular syn). The user isn't going to get any error and would
expect TCPI_OPT_SYN_DATA. Now, TCPI_OPT_SYN_DATA wouldn't be set but we
can't assume then that a SYN+data was sent and the SYN_ACK didn't cover
the data part. Instead, the reason for failure is really -ENOMEM, which
in the proposed states would fall into TFO_STATUS_UNSPEC, but it does
mean that I think we shouldn't have a TFO_DATA_NOT_ACKED state otherwise
we can't differentiate the two.

> 
> 
>>> I'm inclined to say that the second state is valuable. And since
>>> blackhole is already a global thing via MIB, I didn't see a strong need
>>> for it. But it sounded like Yuchung had an interest in it, and I'd
>>> obviously like a set of states that is generally useful.
>>
>> I have not kept up with all the proposals in this thread, but would it
>> work to include all of the cases proposed in this thread? It seems
>> like there are enough bits available in holes in tcp_sock and tcp_info
>> to have up to 7 bits of information saved in tcp_sock and exported to
>> tcp_info. That seems like more than enough?
> I would rather use only at most 2-bits for TFO errors to be
> parsimonious on (bloated) tcp sock. I don't mind if the next patch
> skip my idea of BH detection.
> my experience is reading host global stats for most applications are a
> hassle (or sometimes not even feasible). they mostly care about
> information of their own sockets.

hmmm, if you are ok without having the BH failure state which Christoph
also pushed back on a bit, but we still only want 2 bits as you
suggested how about:

1) TFO_STATUS_UNSPEC - includes black hole state and other failures
2) TFO_COOKIE_UNAVAILABLE - we don't have a cookie in the cache
3) TFO_DATA_NOT_ACKED - syn+data sent but no ack for data part
4) TFO_SYN_RETRANSMITTED - same as 3 but at least 1 additional syn sent

Thanks,

-Jason
