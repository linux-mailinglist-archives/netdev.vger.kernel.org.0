Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC911E9C65
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 06:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgFAEKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 00:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFAEKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 00:10:06 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3F9C08C5C0
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 21:10:06 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05149mjg031694;
        Mon, 1 Jun 2020 05:09:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=kmwaOksx6U423nHKSyTVLqUCl/KNWpIF22XSqHc5vVY=;
 b=W3ATNHbh/LCss0o1KX0wVv0yVJAW6fbq86SLX5o7TEhBwurAQoXABHHqiKAsiIacg6Al
 BkUGAnO7KfbRaZpfJs5pJAcwJP+hAF/I0yVK/XL3ZFCXu7nKvuaw9Oymbt3rQyjQbuaw
 8AltmGkp4iI+sUQr3hJujz9fyBs9xTKZhOCqFl90MDVYMFmdZbfd+rTiAtUfRifbqoEq
 RGckj/IUqLYpzYbfKB/PS669U2o1mOKJAKMFVlHAUfaulLdSiy81N02gTpaWDpaxktaB
 OHqKc13Bv3RMKvqwvqeTSIxGVpFwa9l0QljNmBbBmO06VJ1XG6O0fX99e7W/rKEgStaU eQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 31bd51ckpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jun 2020 05:09:59 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 0513m0qj014464;
        Mon, 1 Jun 2020 00:09:58 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 31bjtu773w-1;
        Mon, 01 Jun 2020 00:09:58 -0400
Received: from [0.0.0.0] (stag-ssh-gw01.bos01.corp.akamai.com [172.27.113.23])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id A14BD349F6;
        Mon,  1 Jun 2020 04:09:58 +0000 (GMT)
Subject: Re: [net-next 0/2] net: sched: cls-flower: add support for port-based
 fragment filtering
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
References: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
 <20200529.165234.25764810096006532.davem@davemloft.net>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <9aba7ddc-d908-892d-c4fa-addd733e1277@akamai.com>
Date:   Mon, 1 Jun 2020 00:09:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529.165234.25764810096006532.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-01_01:2020-05-28,2020-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=750
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2004280000 definitions=main-2006010027
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-01_01:2020-05-28,2020-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=728 bulkscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 cotscore=-2147483648 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006010030
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/29/20 7:52 PM, David Miller wrote:
> From: Jason Baron <jbaron@akamai.com>
> Date: Wed, 27 May 2020 16:25:28 -0400
> 
>> Port based allow rules must currently allow all fragments since the
>> port number is not included in the 1rst fragment. We want to restrict
>> allowing all fragments by inclucding the port number in the 1rst
>> fragments.
>>
>> For example, we can now allow fragments for only port 80 via:
>>
>> # tc filter add dev $DEVICE parent ffff: priority 1 protocol ipv4 flower
>>   ip_proto tcp dst_port 80 action pass
>> # tc filter add dev $DEVICE parent ffff: priority 2 protocol ipv4 flower
>>   ip_flags frag/nofirstfrag action pass
>>
>> The first patch includes ports for 1rst fragments.
>> The second patch adds test cases, demonstrating the new behavior.
> 
> But this is only going to drop the first frag right?
>

Yes, only the first frag is dropped, as subsequent packets wouldn't
have the port #. This will prevent re-assembly since the first fragment
is missing. Currently, drop rules on ports will just allow all fragments
through, so this seems to me to be easy to subvert.

> Unless there is logic to toss the rest of the frags this seems
> extremely hackish as best.
> 
> I don't want to apply this as-is, it's a short sighted design
> as far as I am concerned.
> 

The use-case we are using this patch for is to allow specific ports
through the firewall without having to allow all fragments. So the
rules look like:

1) Allow port 80 including first frags

# tc filter add dev $DEVICE parent ffff: priority 1 protocol ipv4 flower
  ip_proto tcp dst_port 80 action pass

2) Allow all non-first frags

# tc filter add dev $DEVICE parent ffff: priority 2 protocol ipv4 flower
  ip_flags frag/nofirstfrag action pass

3) Drop everything left

# tc filter add dev $DEVICE parent ffff: priority 3 flower action drop


This allows one to process fragments without allowing all fragments to
all ports.

I'm certainly open to other ideas on how to improve this.

Thanks,

-Jason

