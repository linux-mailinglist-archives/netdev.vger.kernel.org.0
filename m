Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113BEB53B8
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfIQRNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:13:17 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:21738 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbfIQRNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 13:13:16 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8HHBwws027355;
        Tue, 17 Sep 2019 18:13:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=yeNjn3xSDTtrCdNVc3piT+7ZHZueO6kVy9n4ih6yQB0=;
 b=lnh+odwCa4vz2S9/1Dl7D1UkBcNYrWLZwEIa/89yARLex1luIngjiu+o9H4AYy+6Nrqb
 Oj/GD14b2mH8ivYvZkqkz7hLA2tUo9krEU9XfrBrS1BRX32OjsfOJO7hV3qEPzMyQup6
 VIiEomnv0igqCsvAGAZMTWoJruxT5nuvsvwlsJtkIMJ+4qeJiZ83CvZfA7yVdGXG12n2
 37ps3GW/+t98jBSVfBNoY5a+bgDlY6+xWOyXi1h0P1qm8w6+xzWo2ba3bRbgc4YQ9RH4
 cqyqiaYfj4942U0V+i+cgvgmhQEann7tsO3qSAGaxqaJV43enXFBWCcT7bYy0aN0WRTH 0g== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2v0r8hq5b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 18:13:08 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x8HH36xP017361;
        Tue, 17 Sep 2019 13:13:07 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2v0uhw4qf7-1;
        Tue, 17 Sep 2019 13:13:06 -0400
Received: from [172.29.170.83] (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id AFB6A1FC78;
        Tue, 17 Sep 2019 17:13:06 +0000 (GMT)
Subject: Re: [PATCH v2] tcp: Add TCP_INFO counter for packets received
 out-of-order
To:     Eric Dumazet <edumazet@google.com>, Thomas Higdon <tph@fb.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>
References: <20190910201128.3967163-1-tph@fb.com>
 <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
From:   Jason Baron <jbaron@akamai.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jbaron@akamai.com; prefer-encrypt=mutual; keydata=
 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
 JeQ7iQ==
Message-ID: <2c6a44fd-3b7e-9fd9-4773-34796b64928f@akamai.com>
Date:   Tue, 17 Sep 2019 13:12:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909170163
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_08:2019-09-17,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 malwarescore=0 clxscore=1011 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909170165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/19 4:38 PM, Eric Dumazet wrote:
> On Tue, Sep 10, 2019 at 10:11 PM Thomas Higdon <tph@fb.com> wrote:
>>
>>
> ...
>> Because an additional 32-bit member in struct tcp_info would cause
>> a hole on 64-bit systems, we reserve a struct member '_reserved'.
> ...
>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>> index b3564f85a762..990a5bae3ac1 100644
>> --- a/include/uapi/linux/tcp.h
>> +++ b/include/uapi/linux/tcp.h
>> @@ -270,6 +270,9 @@ struct tcp_info {
>>         __u64   tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetrans */
>>         __u32   tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups */
>>         __u32   tcpi_reord_seen;     /* reordering events seen */
>> +
>> +       __u32   _reserved;           /* Reserved for future 32-bit member. */
>> +       __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */
>>  };
>>
> 
> Unfortunately we won't be able to use this hole, because the way the
> TCP_INFO works,
> 
> The kernel will report the same size after the reserved field is
> renamed to something else.
> 
> User space code is able to detect which fields are there or not based
> on what the kernel
> returns for the size of the structure.
> 

Hi,

I was interested in adding a field to tcp_info around the TFO state of a
socket. So for the server side it would indicate if TFO was used to
create the socket and on the client side it would report whether TFO
worked and if not that it failed with maybe some additional states
around why it failed. I'm thinking it would be maybe 3 bits.

My question is whether its reasonable to use the unused bits of
__u8    tcpi_delivery_rate_app_limited:1;. Or is this not good because
the size hasn't changed? What if I avoided using 0 for the new field to
avoid the possibility of not knowing if 0 because its the old kernel or
0 because that's now its a TFO state? IE the new field could always be >
0 for the new kernel.

Thanks,

-Jason
