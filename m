Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BA7456C01
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhKSJBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 04:01:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65362 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234507AbhKSJBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 04:01:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ5UET3000920;
        Fri, 19 Nov 2021 00:58:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=iltTL0Ko1kdu8ZMfvmoAAhD7MV1pZyQxVn17R8w9/GM=;
 b=MuPZxSqYWn3GVGwIIjwLk2iBriOom0lWH5UCb0GUPLAIYKNKWUkoSSqVuHRI6SARITwr
 QWYzsvNcLA1jmG2A2zXkdo8/8nNIXw2RVjUrq0ENPCTSDL18dyDvUq4yxDAH5k/6S/S7
 7MffPq8NF+X5qbsALmJZraPKM2z8l6ryEs2DPoBOOwf6VXlbUgvze5t/W/GlHoOOS7yD
 7RYip3TvP/mUtV0feHlG+2xjZHgOy9wDbChto5R6WFs1bZJIZU6we3v841jCND5klpTJ
 CcgeMwv/dP7XoNliW6l4nzFV1SwJlq2bdG9/wWbIgivk69HZmAm+6HObBI297EpRnggt 4g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cdvprttmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 00:58:41 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 19 Nov
 2021 00:58:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 19 Nov 2021 00:58:39 -0800
Received: from [10.9.118.29] (EL-LT0043.marvell.com [10.9.118.29])
        by maili.marvell.com (Postfix) with ESMTP id 2E91B5B6925;
        Fri, 19 Nov 2021 00:58:30 -0800 (PST)
Message-ID: <ea15681a-01b8-c6c5-a2c6-d1c255a03d4e@marvell.com>
Date:   Fri, 19 Nov 2021 09:58:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101
 Thunderbird/94.0
Subject: Re: Fw: [Bug 214619] New: Aquantia / Atlantic driver not loading post
 5.14.RC7
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
References: <20211004141418.1b4bd7bb@hermes.local>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20211004141418.1b4bd7bb@hermes.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: lmaF2OYmwpEKg_RaFwTiENdFJuRz_sXs
X-Proofpoint-GUID: lmaF2OYmwpEKg_RaFwTiENdFJuRz_sXs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_08,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello community,

>             Bug ID: 214619
>            Summary: Aquantia / Atlantic driver not loading post 5.14.RC7
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 514.rc7
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: Miles.Rumppe@gmail.com
>         Regression: No
> 

https://bugzilla.kernel.org/show_bug.cgi?id=214619

Quite a strange issue, we are looking for advice/assistance.

After looking into disassembly, I see the failure is AFTER the end of the function:

    272d:       b8 01 00 00 00          mov    $0x1,%eax
    2732:       d3 e0                   shl    %cl,%eax
    2734:       41 09 85 f8 05 00 00    or     %eax,0x5f8(%r13)
    273b:       eb 84                   jmp    26c1 <aq_nic_start+0x301>
>>  273d:       0f 0b                   ud2    

    273f:       90                      nop

On undefined instruction.

We had similar report in past from another user, but were unable to find out how execution could reach that point.

I suspect this is something related to compiler optimization or some other coincidence.

We also were not successful in trying to bisect this driver specific changes. Looks like some side kernel change could have triggered that.

Any clue?

Regards,
  Igor
