Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D927568D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgIWKnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:43:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgIWKnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 06:43:18 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NAWXSR124402;
        Wed, 23 Sep 2020 06:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pceg9TFZ4Lrf4sF6vlde1jFqMOIvFsV7jjTeVFuf6RM=;
 b=n1YiuhpWmu71RQ7XATUq9CjEo/k8BDRr3HBlX3lSnnypsJg9837nDUOrKhhHp0zCRNxM
 b+n+zdFIrBYvPAjXlmNwP+l9elGhmG/JL5Gz9Bs/GUcsTzCeESMKPGOsD7EOI8tBX6wq
 cszEsJvpQzKoSwkDXcKj7bdOuEtdoEFiv+f7pqawr8v0rYOQrQgKyBo77XybJObMjBY5
 cCS147ffkij0IHmLM0BEbfGE3a8X3Yjb+0ptxcWhL5o+FHpZApDy04QE0ZRXOaK1PPb9
 NT7Q4wYi5z8io7uhtDzV2S09asbl9o4wtOkKdiM//9hZ9FzPslhrNYQQT2doj7jsDuPm Cg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r4dkgu0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 06:43:10 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NAg5LG008136;
        Wed, 23 Sep 2020 10:43:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 33n9m7t3c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 10:43:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NAh3UJ28377540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 10:43:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9770EA405F;
        Wed, 23 Sep 2020 10:43:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1044A4054;
        Wed, 23 Sep 2020 10:43:04 +0000 (GMT)
Received: from [9.145.46.114] (unknown [9.145.46.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 10:43:04 +0000 (GMT)
Subject: Re: [PATCH net-next 3/9] s390/qeth: clean up string ops in
 qeth_l3_parse_ipatoe()
To:     David Laight <David.Laight@ACULAB.COM>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
 <20200923083700.44624-4-jwi@linux.ibm.com>
 <2e439abb31e942e2a441f28439d287fa@AcuMS.aculab.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <32389826-0c77-cade-5105-a5b710276e42@linux.ibm.com>
Date:   Wed, 23 Sep 2020 13:43:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <2e439abb31e942e2a441f28439d287fa@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.09.20 12:55, David Laight wrote:
> From: Julian Wiedmann
>> Sent: 23 September 2020 09:37
>>
>> Indicate the max number of to-be-parsed characters, and avoid copying
>> the address sub-string.
>>
>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
>> ---
>>  drivers/s390/net/qeth_l3_sys.c | 27 ++++++++++++++-------------
>>  1 file changed, 14 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
>> index ca9c95b6bf35..05fa986e30fc 100644
>> --- a/drivers/s390/net/qeth_l3_sys.c
>> +++ b/drivers/s390/net/qeth_l3_sys.c
>> @@ -409,21 +409,22 @@ static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
>>  static int qeth_l3_parse_ipatoe(const char *buf, enum qeth_prot_versions proto,
>>  		  u8 *addr, int *mask_bits)
>>  {
>> -	const char *start, *end;
>> -	char *tmp;
>> -	char buffer[40] = {0, };
>> +	const char *start;
>> +	char *sep, *tmp;
>> +	int rc;
>>
>> -	start = buf;
>> -	/* get address string */
>> -	end = strchr(start, '/');
>> -	if (!end || (end - start >= 40)) {
>> +	/* Expected input pattern: %addr/%mask */
>> +	sep = strnchr(buf, 40, '/');
>> +	if (!sep)
>>  		return -EINVAL;
>> -	}
>> -	strncpy(buffer, start, end - start);
>> -	if (qeth_l3_string_to_ipaddr(buffer, proto, addr)) {
>> -		return -EINVAL;
>> -	}
>> -	start = end + 1;
>> +
>> +	/* Terminate the %addr sub-string, and parse it: */
>> +	*sep = '\0';
> 
> Is it valid to write into the input buffer here?
> 

It's a private buffer that was handed to us by the kernfs write code.

>> +	rc = qeth_l3_string_to_ipaddr(buf, proto, addr);
>> +	if (rc)
>> +		return rc;
>> +
>> +	start = sep + 1;
>>  	*mask_bits = simple_strtoul(start, &tmp, 10);
> 
> The use of strnchr() rather implies that the input
> buffer may not be '\0' terminated.

It's a kernfs write buffer, so guaranteed to be terminated.

> If that is true then you've just run off the end of the
> input buffer.
> 
>>  	if (!strlen(start) ||
>>  	    (tmp == start) ||
> 
> Hmmm... delete the strlen() clause.
> It ought to test start[0], but the 'tmp == start' test
> covers that case.
> 

See the next patch in this series, all this goes away.

> I don't understand why simple_strtoul() is deprecated.
> I don't recall any of the replacements returning the
> address of the terminating character.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

b
