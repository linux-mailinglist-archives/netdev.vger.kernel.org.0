Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AC8DF50B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfJUS2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:28:30 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:10798 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbfJUS2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:28:30 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9LIIn3U003545;
        Mon, 21 Oct 2019 19:28:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=lyqJQhpPkWLIw3t5A+kDP9A7ZTzf7I+ACo38J4LeDTs=;
 b=POvlyKmZ88Sj00MVO6HI0W0bZRHI6b+iSNFSubqlPW1gucChnqt11BOJk4NfemeAYl1h
 N7yzoJ1DY6d4VuGRjKVg4NhZ2aJHB+PqGMsriR4NWbE5i8PjX6ooDO0H/a3CNYeA+rge
 Qi3W1GD55W3Ygy54Ey91LPFIgubKx+GITuI/MiFpOOYWe2h+GKfypSmFy8vReLZTDVxB
 Sm3gH/531JkUaIOlN3q4YzyFYGzaQH90M6xdJ1wK9lKiA1Mo1QdR6Mj2QP14ZhGOUwph
 LZ7puXC5KQmpKfdcC9SnRiXhQdRcgugd0UZ7Mkbq//nSOZz09tcjLIcWGlsyntddWiNj mQ== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2vqthjbey0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 19:28:21 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9LIHTlc029870;
        Mon, 21 Oct 2019 14:28:20 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2vqwtwjumc-1;
        Mon, 21 Oct 2019 14:28:20 -0400
Received: from [172.29.170.83] (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 2B47A27216;
        Mon, 21 Oct 2019 18:28:19 +0000 (GMT)
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Christoph Paasch <cpaasch@apple.com>
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
From:   Jason Baron <jbaron@akamai.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jbaron@akamai.com; prefer-encrypt=mutual; keydata=
 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
 JeQ7iQ==
Message-ID: <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com>
Date:   Mon, 21 Oct 2019 14:27:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210175
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_05:2019-10-21,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/19 2:02 PM, Yuchung Cheng wrote:
> Thanks for the patch. Detailed comments below
> 
> On Fri, Oct 18, 2019 at 4:58 PM Neal Cardwell <ncardwell@google.com> wrote:
>>
>> On Fri, Oct 18, 2019 at 3:03 PM Jason Baron <jbaron@akamai.com> wrote:
>>>
>>> The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
>>> or not data-in-SYN was ack'd on both the client and server side. We'd like
>>> to gather more information on the client-side in the failure case in order
>>> to indicate the reason for the failure. This can be useful for not only
>>> debugging TFO, but also for creating TFO socket policies. For example, if
>>> a middle box removes the TFO option or drops a data-in-SYN, we can
>>> can detect this case, and turn off TFO for these connections saving the
>>> extra retransmits.
>>>
>>> The newly added tcpi_fastopen_client_fail status is 2 bits and has 4
>>> states:
>>>
>>> 1) TFO_STATUS_UNSPEC
>>>
>>> catch-all.
>>>
>>> 2) TFO_NO_COOKIE_SENT
>>>
>>> If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
>>> was sent because we don't have one yet, its not in cache or black-holing
>>> may be enabled (already indicated by the global
>>> LINUX_MIB_TCPFASTOPENBLACKHOLE).
> 
> It'd be useful to separate the two that cookie is available but is
> prohibited to use due to BH checking. We've seen users internally get
> confused due to lack of this info (after seeing cookies from ip
> metrics).
> 

ok, yeah i had been thinking about splitting these out but thought that
the LINUX_MIB_TCPFASTOPENBLACKHOLE counter could help differentiate
these cases - but I'm ok making it explicit.

>>>
>>> 3) TFO_NO_SYN_DATA
>>>
>>> Data was sent with SYN, we received a SYN/ACK but it did not cover the data
>>> portion. Cookie is not accepted by server because the cookie may be invalid
>>> or the server may be overloaded.
>>>
>>>
>>> 4) TFO_NO_SYN_DATA_TIMEOUT
>>>
>>> Data was sent with SYN, we received a SYN/ACK which did not cover the data
>>> after at least 1 additional SYN was sent (without data). It may be the case
>>> that a middle-box is dropping data-in-SYN packets. Thus, it would be more
>>> efficient to not use TFO on this connection to avoid extra retransmits
>>> during connection establishment.
>>>
>>> These new fields certainly not cover all the cases where TFO may fail, but
>>> other failures, such as SYN/ACK + data being dropped, will result in the
>>> connection not becoming established. And a connection blackhole after
>>> session establishment shows up as a stalled connection.
>>>
>>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Neal Cardwell <ncardwell@google.com>
>>> Cc: Christoph Paasch <cpaasch@apple.com>
>>> ---
>>
>> Thanks for adding this!
>>
>> It would be good to reset tp->fastopen_client_fail to 0 in tcp_disconnect().
>>
>>> +/* why fastopen failed from client perspective */
>>> +enum tcp_fastopen_client_fail {
>>> +       TFO_STATUS_UNSPEC, /* catch-all */
>>> +       TFO_NO_COOKIE_SENT, /* if not in TFO_CLIENT_NO_COOKIE mode */
>>> +       TFO_NO_SYN_DATA, /* SYN-ACK did not ack SYN data */
>>
>> I found the "TFO_NO_SYN_DATA" name a little unintuitive; it sounded to
>> me like this means the client didn't send a SYN+DATA. What about
>> "TFO_DATA_NOT_ACKED", or something like that?
>>
>> If you don't mind, it would be great to cc: Yuchung on the next rev.
> TFO_DATA_NOT_ACKED is already available from the inverse of TCPI_OPT_SYN_DATA
> #define TCPI_OPT_SYN_DATA       32 /* SYN-ACK acked data in SYN sent or rcvd */
> 
> It occurs (3)(4) are already available indirectly from
> TCPI_OPT_SYN_DATA and tcpi_total_retrans together, but the socket must
> query tcpi_total_retrans right after connect/sendto returns which may
> not be preferred.
> 
> How about an alternative proposal to the types to catch more TFO issues:
> 
> TFO_STATUS_UNSPEC
> TFO_DISABLED_BLACKHOLE_DETECTED
> TFO_COOKIE_UNAVAILABLE
> TFO_SYN_RETRANSMITTED  // use in conjunction w/ TCPI_OPT_SYN_DATA for (3)(4)

Ok, that set works for me. I will re-spin with these states for v2.
Thanks for the suggestion!

-Jason

