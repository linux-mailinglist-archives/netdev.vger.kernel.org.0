Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5331DD0AB
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgEUPBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:01:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgEUPBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:01:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LEg0eG102521;
        Thu, 21 May 2020 15:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tc+I1qFTpfDdz7J58nA474ceD4IiYHXt2HPacvpjr0s=;
 b=vrN9PfqVf4yK22FqudqwJG/Nhl0I78YwekXENchKlCSD3OVfAdUrb32hXQDNsTu0eUZu
 nhzK0A8sKi1NHouaEuQDQ7j5F+dypDASuUFGEe0bted3uo0YFl2mQzPCsmYrBAnbCsmL
 sNWwMG0YVKZbE4FbCDkbx26eiBDK+Iwg1GbUOPndlnjANe5Bp1GjQwB5X6lj1e2jrXCX
 y5r9Daha36LG9wo0uS3546H3ko7FcbwTfUXW3p6+eO6LIF2MamH84+EYpk4wAjrthKiD
 V9Vkkskz/MYezVcOoUC+lgtEgaIgnImawZMV73cDstqzq9f1U2U74PvSLVxb6pWWV80N Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127krh0wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 15:01:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LEXF7e122371;
        Thu, 21 May 2020 15:01:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 315022hs73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 15:01:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LF1AGO027350;
        Thu, 21 May 2020 15:01:10 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 08:01:09 -0700
Date:   Thu, 21 May 2020 18:01:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>,
        horatiu.vultur@microchip.com, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: KASAN: slab-out-of-bounds Read in br_mrp_parse
Message-ID: <20200521150101.GT3041@kadam>
References: <0000000000007b211005a6187dc9@google.com>
 <20200521140803.GI30374@kadam>
 <CACT4Y+bzz-h5vNGH0rDMUiuGZVX01oXawXAPbjtnNHb1KVWSvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bzz-h5vNGH0rDMUiuGZVX01oXawXAPbjtnNHb1KVWSvg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 04:28:05PM +0200, Dmitry Vyukov wrote:
> What do you want to script? Note syzbot is not promising a specific
> stable API wrt these plain text emails. These are flattened into text
> format for human consumption and sent over unreliable media.

I just want to pipe the email to a script which fetches the tree,
checks out the hash, creates the config and does a make cscope.

regards,
dan carpenter


