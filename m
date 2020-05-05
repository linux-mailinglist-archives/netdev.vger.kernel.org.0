Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1E1C6000
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgEESXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:23:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730258AbgEESXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:23:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045I8V2V180478;
        Tue, 5 May 2020 14:23:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s1sx7xdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 14:23:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045IAVDk015526;
        Tue, 5 May 2020 18:23:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5qfwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 18:23:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045INVoK50987208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 18:23:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C23E5204E;
        Tue,  5 May 2020 18:23:31 +0000 (GMT)
Received: from [9.145.75.123] (unknown [9.145.75.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5A84C5204F;
        Tue,  5 May 2020 18:23:31 +0000 (GMT)
Subject: Re: [PATCH net-next 10/11] s390/qeth: allow reset via ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
 <20200505162559.14138-11-jwi@linux.ibm.com>
 <20200505102149.1fd5b9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <a19ccf27-2280-036c-057f-8e6d2319bb28@linux.ibm.com>
Date:   Tue, 5 May 2020 20:23:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505102149.1fd5b9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050133
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.20 19:21, Jakub Kicinski wrote:
> On Tue,  5 May 2020 18:25:58 +0200 Julian Wiedmann wrote:
>> Implement the .reset callback. Only a full reset is supported.
>>
>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
>> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
>> ---
>>  drivers/s390/net/qeth_ethtool.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
>> index ebdc03210608..0d12002d0615 100644
>> --- a/drivers/s390/net/qeth_ethtool.c
>> +++ b/drivers/s390/net/qeth_ethtool.c
>> @@ -193,6 +193,21 @@ static void qeth_get_drvinfo(struct net_device *dev,
>>  		 CARD_RDEV_ID(card), CARD_WDEV_ID(card), CARD_DDEV_ID(card));
>>  }
>>  
>> +static int qeth_reset(struct net_device *dev, u32 *flags)
>> +{
>> +	struct qeth_card *card = dev->ml_priv;
>> +	int rc;
>> +
>> +	if (*flags != ETH_RESET_ALL)
>> +		return -EINVAL;
>> +
>> +	rc = qeth_schedule_recovery(card);
>> +	if (!rc)
>> +		*flags = 0;
> 
> I think it's better if you only clear the flags for things you actually
> reset. See the commit message for 7a13240e3718 ("bnxt_en: fix
> ethtool_reset_flags ABI violations").
> 

Not sure I understand - you mean *flags &= ~ETH_RESET_ALL ?

Since we're effectively managing a virtual device, those individual
ETH_RESET_* flags just don't map very well...
This _is_ a full-blown reset, I don't see how we could provide any finer
granularity.
