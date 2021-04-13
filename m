Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F4C35D948
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbhDMHt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:49:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37480 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240576AbhDMHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:49:14 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D7Xhbd017428;
        Tue, 13 Apr 2021 03:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aqPpu0ZAYJAAbxSTqoZ5mb0C26F1ZZj2ECIMEtqfZrA=;
 b=NjYF7a0X66RXU9EfLF/sDrnFrW3ltKE6bTl+g18wbOu55SXYhwtkmuY349Ze3vrd0IXO
 qxxd1XolMgh3uN57+bXQRMxvvHUXNSWjxY7YgYNyt+v9qfLDjpWWQl6kpvgIZGUor4Jq
 aFl1E1h+K1CAoC7VAATuHybkbdQYt0Odfu5dj2WtEEjJzVYNDUm8f5/PAJPY14o+675a
 PLQberAB9UL6q7S2Cy/8voEzHanLRwTjpABeb61bTrOrvjeEWbruDx9oFhpcqBJeR+Pw
 qvvFzcZ0NuLHeBl/bFD9oWWF2gkoNrMh78OXHyv1oo1/bLjJmXxkXRTa+56EqXUtYQ3E OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vk3s90t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:48:52 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D7hX7x051069;
        Tue, 13 Apr 2021 03:48:52 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vk3s90sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:48:52 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D7kgYk016312;
        Tue, 13 Apr 2021 07:48:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n89a94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 07:48:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D7mQK621758348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 07:48:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20670AE056;
        Tue, 13 Apr 2021 07:48:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0196AE051;
        Tue, 13 Apr 2021 07:48:47 +0000 (GMT)
Received: from [9.171.17.58] (unknown [9.171.17.58])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 07:48:47 +0000 (GMT)
Subject: Re: [Patch net] smc: disallow TCP_ULP in smc_setsockopt()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>
References: <20210410181732.25995-1-xiyou.wangcong@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <27d7157d-042c-efb8-2f89-437af321c3df@linux.ibm.com>
Date:   Tue, 13 Apr 2021 09:48:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210410181732.25995-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: irwu4-pkWWA7FfZMTdlSm5dN0Ocsb-fF
X-Proofpoint-ORIG-GUID: iBSnKv3zSDSCuUejyK2AdqO4jaUcVmFA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04/2021 20:17, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> syzbot is able to setup kTLS on an SMC socket, which coincidentally
> uses sk_user_data too, later, kTLS treats it as psock so triggers a
> refcnt warning. The cause is that smc_setsockopt() simply calls
> TCP setsockopt(). I do not think it makes sense to setup kTLS on
> top of SMC, so we can just disallow this.
> 
> Reported-and-tested-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

