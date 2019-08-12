Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC48A2C0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfHLP4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:56:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbfHLP4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:56:49 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CFugtk148600;
        Mon, 12 Aug 2019 11:56:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ub97363p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 11:56:45 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7CFujNO148881;
        Mon, 12 Aug 2019 11:56:45 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ub97363kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 11:56:45 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7CFtUxP006304;
        Mon, 12 Aug 2019 15:56:40 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 2u9nj6fwr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 15:56:40 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CFuekf36897112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 15:56:40 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02EFDAC05B;
        Mon, 12 Aug 2019 15:56:40 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0A45AC059;
        Mon, 12 Aug 2019 15:56:39 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.213.234])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 15:56:39 +0000 (GMT)
Subject: Re: [PATCHv2 net 0/2] Add netdev_level_ratelimited to avoid netdev
 msg flush
To:     Hangbin Liu <liuhangbin@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, joe@perches.com
References: <20190801090347.8258-1-liuhangbin@gmail.com>
 <20190809002941.15341-1-liuhangbin@gmail.com>
 <20190811.210820.1168889173898610979.davem@davemloft.net>
 <20190812073733.GV18865@dhcp-12-139.nay.redhat.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <9bb8e9af-4d9b-7c16-f58d-e299b1f30007@linux.ibm.com>
Date:   Mon, 12 Aug 2019 10:56:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812073733.GV18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/12/19 2:37 AM, Hangbin Liu wrote:
> On Sun, Aug 11, 2019 at 09:08:20PM -0700, David Miller wrote:
>> From: Hangbin Liu <liuhangbin@gmail.com>
>> Date: Fri,  9 Aug 2019 08:29:39 +0800
>>
>>> ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
>>> error when add more thann 256 memberships in one multicast group. I haven't
>>> found this issue on other driver. It looks like an ibm driver issue and need
>>> to be fixed separately.
>> You need to root cause and fix the reason this message appears so much.
>>
>> Once I let you rate limit the message you will have zero incentive to
>> fix the real problem and fix it.
> Sorry, I'm not familiar with ibmveth driver...
>
> Hi Thomas,
>
> Would you please help check why this issue happens


Hi, thanks for reporting this. I was able to recreate this on my own 
system. The virtual ethernet's multicast filter list size is limited, 
and the driver will check that there is available space before adding 
entries.  The problem is that the size is encoded as big endian, but the 
driver does not convert it for little endian systems after retrieving it 
from the device tree.  As a result the driver is requesting more than 
the hypervisor can allow and getting this error in reply. I will submit 
a patch to correct this soon.

Thanks again,

Tom

> Thanks
> Hangbbin
>
