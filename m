Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5A12AD8A6
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbgKJOWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKJOWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 09:22:00 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD1EC0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 06:22:00 -0800 (PST)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAEF2su019922;
        Tue, 10 Nov 2020 14:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=bzsr6I01mEwqPHMp7Kai1Ifb6tt8RMl5iMCYL3nRC1s=;
 b=GmCe38qwGQBIgK/Kp4cpY0xoYZesrub+V1cQ/z9kEwxmLqWODPqZ+J4O91F1lJg1wU+1
 EoM3TVJV8q0U8w0Ruwszl/s6fhrr33UjiW4cIZgqoSwMYiMidFUwaKum/ZX9B2+Pv6Z/
 HsLk1dLMSmMxWSfyLsO50jy47oMOHpk/vHws2HzwHqqTOsgkpP+gm9gP5h0xaV+Arn+R
 9gAQMpgVjiqLEcOlzYRfltLi3IJ1PlfMOA0b8sap5bwnnp+mC8M+uw9/L2jEB3Xw+2KC
 9gl/+Lp3TVz+VQ0gxSuQ7y7yg3dGPdJaoXqbD2hF1OhfdzS8KaXP3/etmVETBu4KfMcb 3g== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 34nhb5dx68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 14:21:54 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0AAEJegB001778;
        Tue, 10 Nov 2020 09:21:53 -0500
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com with ESMTP id 34nqt2p9ej-1;
        Tue, 10 Nov 2020 09:21:53 -0500
Received: from [0.0.0.0] (stag-ssh-gw01.bos01.corp.akamai.com [172.27.113.23])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 73DEC23CBB;
        Tue, 10 Nov 2020 14:21:53 +0000 (GMT)
Subject: Re: [PATCH net V2] Exempt multicast addresses from five-second
 neighbor lifetime
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20201109025052.23280-1-jdike@akamai.com>
 <20201109114733.0ee71b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jeff Dike <jdike@akamai.com>
Message-ID: <aaf62231-75d2-6b2f-9982-3d24ca4e4e80@akamai.com>
Date:   Tue, 10 Nov 2020 09:21:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201109114733.0ee71b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=846 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100102
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=795
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 impostorscore=0
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100102
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.61)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 11/9/20 2:47 PM, Jakub Kicinski wrote:
> This makes sense because mcast L2 addr is calculated, not discovered,
> and therefore can be recreated at a very low cost, correct?

Yes.

> Perhaps it would make sense to widen the API to any "computed" address
> rather than implicitly depending on this behavior for mcast?

I'm happy to do that, but I don't know of any other types of addresses which are computed and end up in the neighbors table.

> I'm not an expert tho, maybe others disagree.
> 
>> +static int arp_is_multicast(const void *pkey)
>> +{
>> +	return IN_MULTICAST(htonl(*((u32 *)pkey)));
>> +}
> 
> net/ipv4/arp.c:935:16: warning: cast from restricted __be32
> 
> s/u32/__be32/
> s/htonl/ntohl/

Thanks, I ran sparse, but must have missed that somehow.

Jeff

