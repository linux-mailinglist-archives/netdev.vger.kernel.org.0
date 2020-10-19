Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1832929A7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgJSOmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:42:55 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:52758 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728311AbgJSOmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 10:42:55 -0400
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09JEe24d002415;
        Mon, 19 Oct 2020 15:41:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=VICPoP7kXHVBZ4NOce1CiwVs0e/iaYqbSEJ/PgohhTg=;
 b=QRb0j/VNwL3wxvschiHdIppM+j5y28tI5yOWL0772jMnJy11pp7XFKvxRIvo9okDv61J
 pRZ7KwLAqobfRzSXtRFxA8EfaNmYVkoffzv6kgb4DaQOklVbeqOFwgV87dZ6CGbAtE/d
 aY28uA6+03Dg1GGd3OAskguA7JkQ1rlfEd0lWWjQL6t5vivQRECdVk9jtOnhgLfqTcBg
 rAu4tt6E97hXtBkbQGJExSm6N75Fo+bdSkVGq31EgPS0sxitdRdLNTSO+DFED945RH3m
 osRbudBbfSf47ehxOx81vW80RXrAnHNP+c4vuMDn0O/7hG/T3W8qJvLUvBlxFnzhko1G Bw== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 348et0qrvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Oct 2020 15:41:53 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09JEYetv030680;
        Mon, 19 Oct 2020 10:41:52 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint8.akamai.com with ESMTP id 347uxxn2h5-1;
        Mon, 19 Oct 2020 10:41:52 -0400
Received: from [0.0.0.0] (stag-ssh-gw01.bos01.corp.akamai.com [172.27.113.23])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 112FA603E2;
        Mon, 19 Oct 2020 14:41:51 +0000 (GMT)
Subject: Re: [RFC] Exempt multicast address from five-second neighbor lifetime
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
References: <0d7a29d2-499f-70ab-ee6f-ced4c9305181@akamai.com>
 <20201016145952.000054ad@intel.com>
From:   Jeff Dike <jdike@akamai.com>
Message-ID: <357ad409-5e3c-d47c-e7f1-8a11a307ee5e@akamai.com>
Date:   Mon, 19 Oct 2020 10:41:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016145952.000054ad@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_06:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190101
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_06:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190102
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.34)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse,

> Your subject should indicate net or net-next as the tree, please see:

I was intending more to see if this is an intrinsically bad idea than for it to go directly into a tree right now.

> Not sure how many patches you've submitted, but your commit message
> should be wrapped at 68 or 72 characters or so.

Not my first patch, but the first sent through Thunderbird and Outlook.

> your triple-dash and a diffstat should be right here, did you hand edit
> this mail instead of using git format-patch to generate it?

Yup, the log message on my internal commit wouldn't make too much sense outside of Akamai, so I wrote this changelog in my MUA.
 
> Why is this added in the middle of the includes?

I needed to get IN_MULTICAST defined - this is one reason I don't expect this patch as it stands to go anywhere.  IN_MULTICAST seems intended just for userspace use, but there isn't any way to ask the same question in the kernel.  The same seems to be true of IPv6 multicast addresses.

>> +static int arp_is_multicast(const void *pkey)
>> +{
>> +	return IN_MULTICAST(htonl(*((u32 *) pkey)));
>> +}
> 
> Why not just move this function up and skip the declaration above?

Following existing practice in this file.  Similar functions are declared above the structure and defined below it.

>>  
>> +static int ndisc_is_multicast(const void *pkey)
>> +{
>> +	return (((struct in6_addr *) pkey)->in6_u.u6_addr8[0] & 0xf0) == 0xf0;
>> +}
>> +
> 
> Again, just move this up above the first usage?

Following existing practice again.
> 
> Does the above work on big and little endian, just seems suspicious
> even though you're using a byte offset? Also I suspect this will
> trigger a warning with sparse or with W=2 about pointer alignment.

I used the byte offsets on purpose for this reason.  Didn't check if sparse had any problems with it.

Jeff
