Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BD13C099
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfFKA3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:29:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfFKA3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:29:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5B0OAvU187741;
        Tue, 11 Jun 2019 00:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=bHEDKOtoH51quhuCXQ/oKvurxQKeW6TiYF3uEqDbN4w=;
 b=H8ljcxf2C5UyCtrULr4NWoBI+SLOoQAjCY2c9V9FGmv8rcE0nMbeod+aPZYghzcE4U/B
 vSks4OrWVXFbBCgT00JMiP5tnHOJbftLzdqMeQeK2XUKi2k7dFTrtGRv3PUqCZOj5hWR
 mtgjxvNndAVeDibca9l7rqvdEXrGpeADcc8gaq9Sx1j8DzRifutb3RQcTJ4KHnMDLoE0
 rXCVLO1j9XYMheOzVAVYIBac4sVAB4c89+DsvVp1M79FnNXVubrxL2wkGMOV/3gaVoeE
 jZDEdiBQBqtQT3Oc6neERuJYED+NMIxoxkXoNZ2Ee3cKMI/XqnQlQweNtw3+2/UMe5vm 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t05nqhu86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 00:29:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5B0Qpje010440;
        Tue, 11 Jun 2019 00:27:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t04hy294u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 00:27:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5B0RiIp020699;
        Tue, 11 Jun 2019 00:27:44 GMT
Received: from [10.0.0.100] (/111.193.67.110)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 17:27:44 -0700
Subject: Re: [PATCH net] net_sched: sch_mqprio: handle return value of
 mqprio_queue_get
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20190610063821.27007-1-jian.w.wen@oracle.com>
 <CAM_iQpXk_-4zKJXkEDVUKUYxEpa8QNa8u2iD4BVxTTWQe=J4cA@mail.gmail.com>
From:   Jacob Wen <jian.w.wen@oracle.com>
Message-ID: <9812dba9-e7c5-c0c0-7065-1cf5f04e7958@oracle.com>
Date:   Tue, 11 Jun 2019 08:27:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXk_-4zKJXkEDVUKUYxEpa8QNa8u2iD4BVxTTWQe=J4cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=929
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=981 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906110001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

This was detected by a tool.

Thanks for the review :)

I will abandon the patch.

On 6/11/19 2:19 AM, Cong Wang wrote:
> On Sun, Jun 9, 2019 at 11:41 PM Jacob Wen <jian.w.wen@oracle.com> wrote:
>> It may return NULL thus we can't ignore it.
> How is this possible? All of the callers should have validated
> the 'cl' before calling this, for example by calling ->find().
>
> I don't see it is possible to be NULL at this point.
>
> Did you see a real crash? If so, please put the full stack trace
> in your changelog.
>
> Thanks!
