Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE3308C0E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhA2SAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:00:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhA2R7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 12:59:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THs8EQ131218;
        Fri, 29 Jan 2021 17:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fvfVwZtb9idfUIrdUZh0mONvhRc9866LkjKLPfO8A3o=;
 b=brUcSBh+Wkf5lC4QGRjZsO5zImmuJcP7YzQDxfo7Y007M6rFsCdrp/Fy1CFx3LzlyxAY
 Rvpp0e5bFMMq5gMeTPCygYRAR6HzJcBhg1Auxqg4cGztOzdrg6+d0it8kVvH/ps7w5/e
 AAlDdwmDdaHZtRnVwBwg/bg+/co4EwWZtGzdAAawp0RAvLxT0yV/cUclq7xx3bnWxiv1
 okfyhI+F4eEXMuYAyT1qvs2OhoDwBjhLvdzJRdPDcPezwMQJy+L5szyxFGxr+L/InW8j
 y/reI7Aq7535KsNS+5pJ4ov+JOozHDz/mpRk0NWip9ql4Yig1J7zBWYJLGMuhtDcQwJ5 iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7ram1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:58:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THtu5m032726;
        Fri, 29 Jan 2021 17:56:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2055.outbound.protection.outlook.com [104.47.36.55])
        by userp3020.oracle.com with ESMTP id 36ceuh06rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:56:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy9iExg/+MGMSUtoL6Ty1iw4ndU0GcDJpkX0gv6ByllQuE30J4O6qdoBIKIVdUvMBJ7RarWNCkphwK29JWgc5NWNjSfjXJZ0Hhmdu8dDDn6TgnU0u6rNqfVBo5EjgQzEMfjiBM3fp99pJOKwFNfC8aaWUmGElgHaCQawez2M4WuNTTJLNf8OL45/2VRNiLYwoEXjn1265hW4HFm2a5IYKd7pSvCmHPUW0vZe4uEzpyhn8/lHKcvwMjR2jT1ianJIGQYtunlm4QRo0aS+KhGOgw1AReFgRTux3lDCingxno2PYcWWmW4BilTZCyAllzOW6zYs0kKlPShhU3PzFedkQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvfVwZtb9idfUIrdUZh0mONvhRc9866LkjKLPfO8A3o=;
 b=ZgJOI9rdRgKmXZkw6ZCY95K/ePh1tEUYBMj71rsZcNBlGNFhRREXJQBas92RKbZSxZCvu1SHEY23uLVQ/EPUZCzXU/Ha/TjG+qkDKNWCw8Agh8VtaCbO+Qvl1kAd5xS0ga3JVJcj5kWr8T2tbvPyqKPVKXLtpOV2zCvFkgdv6OoHAqMv6+HYt+zrR/F1p+Q68igmJIcXXHYAfNFLfF3q+y225qIdW5ewJaGqJvJI9u7nnmbHu3eYzEonuGPGJ8dTnv6gRDTB8t+2Ad8fsek38gPdygKPTZMYvT2JOTMi19a2ATCwUo+26vVYq3sgiv4BSrpn6gD2iYMdJyhBDGrTxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvfVwZtb9idfUIrdUZh0mONvhRc9866LkjKLPfO8A3o=;
 b=ihsE7hw4qDXjGa6F1sMmFqa4IdAgDIIPWyHlQrB7N1lSJEsKeXbY4pKTPYoCTewh5x2KaUMTHuJSsRfCuXGIr2ubjA07k94gLFQ4/+n0lD9fE3iVU6ysUJSWuGiPHDBE7N0TrHE2hqlBzkxGw3pDK42yQHdzTpj22cUL3jxIaNU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BY5PR10MB3778.namprd10.prod.outlook.com (2603:10b6:a03:1f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 29 Jan
 2021 17:56:51 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 17:56:51 +0000
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
To:     Jakub Kicinski <kuba@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
Date:   Fri, 29 Jan 2021 09:56:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BYAPR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::26) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by BYAPR05CA0085.namprd05.prod.outlook.com (2603:10b6:a03:e0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Fri, 29 Jan 2021 17:56:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 361a1d7a-3b3e-466b-a323-08d8c47f4149
X-MS-TrafficTypeDiagnostic: BY5PR10MB3778:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3778B52B55A397E82A16E984EFB99@BY5PR10MB3778.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u3DnFjEsKSVb97QWO4HtpAPYwT9QjA2SyLapV8B2ZywfpX2byIR5JsF1qEwiMmPtL0PSEgJ+p1xgwS9Ik8xDn9RGX40Ec+pUoqznbqnb5WeFrPsupOuxZw1fzeXtSXCKAKK9SaEfYKrmXznP2ZVf8JCDIM1941xlSzXHm1nymzniC+1T0NlT7VkyKi8nJZ+Ie/8RcpJ8Kn+vyAxZTZkH1+8iiBoRZ51ff7aBPiG1m/XCdWj9WlVnibfl7IQYMOTUPKjcQwc2ZFE07Moegprkaf+8SzMPUchSjsgPFTPIoGRnqRrD+FFjNRj2rzlKKO7cNzwYkW80xP+udOTu5QhBRV6p7LeNwgS0w5ilb2nQTj8exvikd0E2VsMvWVORngjQKCZim6dRpu2p+doon6gVmpyapsZRF7MLFTkmCfcvq71ImFh2ECH7AClUAPemYk+BIIC/53sffXH3509EcYYrLoeo6ky+N79ZbdQxuvf+mnWXZIk6OBJpjHouKVxorLF6rstJD21WlLIXoYplROTHbfuxAxKGY5xR2Ey/YUhQV0uQg35BUI72RDGhl3/N6XLDx1pcjvoGAHkkBrAzUa7gaTw8KFkepJtfWHGDYtqBOFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(396003)(366004)(346002)(53546011)(16526019)(5660300002)(8936002)(110136005)(4326008)(83380400001)(36756003)(66476007)(66946007)(2616005)(31686004)(66556008)(316002)(6486002)(186003)(86362001)(31696002)(8676002)(2906002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTRGVUg2Sm4rczd6bGZPbmRVV3M1Tm13ak41RXFJcERXRVIzTmw3dmIxdmlr?=
 =?utf-8?B?ckNUOW0rM1pKaWhkdEdWUTc0V1lwNEJtdlJJeXU2enNQdWU1cjJuSWpsYVRW?=
 =?utf-8?B?MWsrUzgzTUc5cHpMWUlubVg0VzhGaVc3UmdyYWs1YUpuUVN2UjQxTXptekRC?=
 =?utf-8?B?UURkTCtUbktESDhCcDZYNURpWVNWT1BrN1pUcUlKdnpXL0ptVTRmVWtNN1ZX?=
 =?utf-8?B?WnNGY2FkdytrZ0NPUEpUTFRaaEF2YWtsb1JNWkJSZWFnMmxQbHBxd0dLQzJY?=
 =?utf-8?B?dHYwRFNIYmUzS3A4TkJSTGxRYjJwY1R5K1BzMFJlMTc3dUlBaE40c0daMUhq?=
 =?utf-8?B?cTBkNnJXcUdQM216dTFzM3p5WGRpZWJOaGpuTzZDZ3lkOFp6QWpkdUtrNU9N?=
 =?utf-8?B?UnpjNk4yY3d6RTEyRGxldnRua3pIVkR1ZCtSMEd2N3l2MWJjTVE0eEluTlQ4?=
 =?utf-8?B?dWV1REd4OVpENlVZT09ZQUhGUFZOeW5YRFY0S25ON3JmMGlQczFTcElNUGQ5?=
 =?utf-8?B?a1RDOHJDOFJZWlkwOG8rVzFDZlNBaU94Y0lYdzg3WVJDOEIvTEc2VmRkMU1o?=
 =?utf-8?B?VnNDVUdJTS9OM1UvcVRyazJvREUxUDl5NmRlLytRRnh5UlE1VW9iSGs1MVkx?=
 =?utf-8?B?SnVJMFpuQ0VGMDhzbUFGd0pkK1FjMXpjNXdoc1dzUThXVkUwYjJkaXJPekJo?=
 =?utf-8?B?UjVDV09PZzlJcCthQ2JYU2FiNjcvQmZML3JtUmphaUlzZDdCbzZJZ3QyUXVk?=
 =?utf-8?B?eERpZTJMaWhhWkQ1ZFUzQm90VmRLY0NyMWFRZzhKWTFOMVVMRTlLS0F6czB0?=
 =?utf-8?B?NmkzWEF3TXZQN2Fabk9NRFFwenZsNml0a2R5Q1JtditsZlZOWG5WT052QUtC?=
 =?utf-8?B?bmNrQURiWDJWa2RuUGtYM05Ed2xhdFk2d3NBaEZoMFVsaThHTXVvdXFKbCty?=
 =?utf-8?B?b0U0YzYyV2JtSGgyazA3Y01KRWhDdUhXMCtLNnNnSXpkeDU4WmhCTnJ5R0xY?=
 =?utf-8?B?N3d0UVhJZE9jV2huZjV1RlVTenV0eU5Hb3dFRjg4WHJuR096OU45VE5vTS9i?=
 =?utf-8?B?bjNsT2pjOFlmS012R1BCakplME4zd0NISFBxcHhHWWJrRXp0RGV6UFhET3hN?=
 =?utf-8?B?QzhveEdHZDBneWtPVStHVkRMME03VUx0V0Z1UDFEMjVJVDNpaHB3M1lVcDRx?=
 =?utf-8?B?cmh0cDFDOThyN2NjUXZqUjh1NTkxcXZsK3dKZWVCVi8vSWJESURvK3NRNlU1?=
 =?utf-8?B?b2QzdlUweVkxSDlCa3B4b3NiTCtOdmlJY3JQRXNFbXpCQkhyT2JLOTM4ZWpw?=
 =?utf-8?B?bzIzdWxZZmlSaWV1b2hXTEhDZXk4QVNSaXdyWmdVQ1hBRFNvWU8wdWs5QVJY?=
 =?utf-8?B?Y1dCUnFaWDA5THVNcElLVWVUQUh6dnR4bHBYblhjTG56UmFrUzZTaytqekYy?=
 =?utf-8?B?a1U3TWY3ZDlzY2I2U2thSWxidTdGVlk2eGZURW9ndVBpQUdvbTR1TlkrbDk5?=
 =?utf-8?Q?OXarSI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361a1d7a-3b3e-466b-a323-08d8c47f4149
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:56:50.9564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMBO71la+JwRjA6o2EJymHwRLL519gtgKZlRVz5BvCx8QFdR51uStDdtNNlelufg2fqexpea3fCD+QAvg8ox+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3778
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/25/21 3:36 PM, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:
>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>
>> TCP sockets allow SIGURG to be sent to the process holding the other
>> end of the socket.  Extend Unix sockets to have the same ability.
>>
>> The API is the same in that the sender uses sendmsg() with MSG_OOB to
>> raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
>> SO_OOBINLINE set.
> Noob question, if we only want to support the inline mode, why don't we
> require SO_OOBINLINE to have been called on @other? Wouldn't that
> provide more consistent behavior across address families?
>
> With the current implementation the receiver will also not see MSG_OOB
> set in msg->msg_flags, right?

SO_OOBINLINE does not control the delivery of signal, It controls how OOB Byte is delivered. It may not be obvious but this change does not deliver any Byte, just a signal. So, as long as sendmsg flag contains MSG_OOB, signal will be delivered just like it happens for TCP.

Shoaib

>
>> SIGURG is ignored by default, so applications which do not know about this
>> feature will be unaffected.  In addition to installing a SIGURG handler,
>> the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
>> which process or thread should receive the signal.
>>
>> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> ---
>>   net/unix/af_unix.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index 41c3303c3357..849dff688c2c 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -1837,8 +1837,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>   		return err;
>>   
>>   	err = -EOPNOTSUPP;
>> -	if (msg->msg_flags&MSG_OOB)
>> -		goto out_err;
>>   
>>   	if (msg->msg_namelen) {
>>   		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
>> @@ -1903,6 +1901,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>   		sent += size;
>>   	}
>>   
>> +	if (msg->msg_flags & MSG_OOB)
>> +		sk_send_sigurg(other);
>> +
>>   	scm_destroy(&scm);
>>   
>>   	return sent;
