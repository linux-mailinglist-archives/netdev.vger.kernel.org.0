Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2286563
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbfHHPOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:14:14 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:23048 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729925AbfHHPOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 11:14:14 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x78F2dXI011081;
        Thu, 8 Aug 2019 16:14:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=kqQVyAG5WCcT1qS99SNQp6qpudJnmWU0aLJ398jisr0=;
 b=SiZILCvc2odKZab+0Vc3HxYOfycicTyh8E5z+9dnaUGEkhZnJ1IbQsVJujII3zUsJdFo
 8IuvTG1lJ4RCzdmHxJF4YoZs5KdX7fx4Abk2BQTzJptGGpq0zBdrb3xTiC3rFVP+q2VK
 v/tgIWic+WRqveZbWXZ+HF+hG8VFtix8oWdUkvGQC7f73mNKtKsTf71aPLFkwJeFH6Rr
 FAWGE2K5huHbLjUNBhIbnXC2ryD2QsrPOT4FzIsutlhz05g+ReNJuiTAkMQ6VM2Kz0Bh
 6zq1ecu8wKvcQCbtai1c4KQ1iEBd4JaXa2nZ4mPKPehRzK+ierajQPfVxjIo8qYYECDF TQ== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2u51wv5spx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 16:14:08 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x78F2G1G000798;
        Thu, 8 Aug 2019 11:14:08 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2u55kvk885-1;
        Thu, 08 Aug 2019 11:14:07 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 0749181668;
        Thu,  8 Aug 2019 15:14:06 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] tcp: add new tcp_mtu_probe_floor sysctl
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
 <a3a69a9d-5e30-77c4-02e2-c644bfdab820@gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <477bbf57-b383-9724-4f70-cb48841203f1@akamai.com>
Date:   Thu, 8 Aug 2019 08:14:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a3a69a9d-5e30-77c4-02e2-c644bfdab820@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080148
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-08_06:2019-08-07,2019-08-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 phishscore=0 clxscore=1011 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908080148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 11:12 PM, Eric Dumazet wrote:
> 
> 
> On 8/8/19 1:52 AM, Josh Hunt wrote:
>> The current implementation of TCP MTU probing can considerably
>> underestimate the MTU on lossy connections allowing the MSS to get down to
>> 48. We have found that in almost all of these cases on our networks these
>> paths can handle much larger MTUs meaning the connections are being
>> artificially limited. Even though TCP MTU probing can raise the MSS back up
>> we have seen this not to be the case causing connections to be "stuck" with
>> an MSS of 48 when heavy loss is present.
>>
>> Prior to pushing out this change we could not keep TCP MTU probing enabled
>> b/c of the above reasons. Now with a reasonble floor set we've had it
>> enabled for the past 6 months.
> 
> I am still sad to see you do not share what is a reasonable value and let
> everybody guess.
> 
> It seems to be a top-secret value.

Haha, no sorry I didn't mean for it to come across like that.

We are currently setting tcp_base_mss to 1348 and tcp_mtu_probe_floor to 
1208. I thought I mentioned it in our earlier mails, but I guess I did 
not put the exact #s. 1348 was derived after analyzing common MTU we see 
across our networks and noticing that an MTU of around 1400 would cover 
a very large % (sorry I don't have the #s handy) of those paths. 1400 - 
20 - 20 - 12 = 1348. For the floor we based it off the v6 min MTU of 
1280 and subtracted out headers, etc, so 1280 - 40 - 20 - 12 = 1208. 
Using a floor of 1280 MTU matches what the RFC suggests in section 7.7 
for v6 connections, we're just applying that to v4 right now as well. I 
guess that brings up a good point, would per-IP proto floor sysctls be 
an option here for upstream (the RFC suggests different floors for v4 
and v6)? For now I'm not sure it makes sense b/c of the problems we see 
with lossy connections, but in the future if that can be resolved it 
seems like it would give some more flexibility.

I'd like to investigate this all further at some point to see if we can 
make it work better for lossy connections. It looks like one of the 
problems is there are a # of conditions which cause us to not probe in 
the upward direction. I'm not sure if any of those can be 
relaxed/changed and if so would help these connections out.

Thanks
Josh
