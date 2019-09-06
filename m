Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5BCAB78B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404268AbfIFLzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:55:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389491AbfIFLzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:55:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86Bs9q1084833;
        Fri, 6 Sep 2019 11:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UQ7HZzVsUj9ewFhA6fQpQ91lzSpUtdtyloZU6ZAWe04=;
 b=V7YmFi2h8p3HXetZAeZvjZ1vpqxdwMH+sg5CGT4ej4gyFv9iw6jz/10yTXc3ibXht8Gh
 veBX1PGMp6vhAoHHcTBWb3ijpPzgCzSZgv9G0fRmFw94qzO/RPWx2OfWsvufET1ESHFs
 ynKZxtumzwADP/mK1FCFhmWz/dhY+VwOk47YvU+Iu3sMQ7vtFWwRfjBMs5lJ4gDa4u/x
 J3+azWJJcw0qT2tNhonEcFY7CxvD0QNDkzrDIxs0tRRRYknI0Bs/gUxzK1hEJ3BFm3h1
 piDPa42KVtxk3y7d+kngg1+Q2x3d8Uq/k9RinMVcwWO2F5DKxm93yx0hLm+6Egzy2j/2 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uupvpr1k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 11:55:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86BrvSo047977;
        Fri, 6 Sep 2019 11:55:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7pers0-60
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 11:55:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x86AwWeY031955;
        Fri, 6 Sep 2019 10:58:32 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 03:58:32 -0700
Date:   Fri, 6 Sep 2019 13:58:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dan Elkouby <streetwalkermc@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hidp: Fix error checks in
 hidp_get/set_raw_report
Message-ID: <20190906105824.GA14147@kadam>
References: <20190906094158.8854-1-streetwalkermc@gmail.com>
 <20190906101306.GA12017@kadam>
 <CANnEQ3HX0SNG+Hzs2b+BzLwuewsC8-3sF2urWV+bqUahXq0hVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANnEQ3HX0SNG+Hzs2b+BzLwuewsC8-3sF2urWV+bqUahXq0hVA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 01:40:15PM +0300, Dan Elkouby wrote:
> On Fri, Sep 6, 2019 at 1:14 PM Dan Carpenter wrote:
> > I think we also need to update update ms_ff_worker() which assumes that
> > hid_hw_output_report() returns zero on success.
> 
> Yes, it looks like that's the case. Should I amend my patch to include
> this fix, or should it be a separate patch? I don't have access to any
> hardware covered by hid-microsoft, so I won't be able to test it.
> 

Yes.  Please amend the patch.  We all understand that you don't have
the hardware so it's not a problem.  If you want to blame me in the
commit message that's fine.  "Dan Carpenter pointed out a related issue
in ms_ff_worker()".  But we're only silencing a warning so it can't
really break anything.

You can add my Reviewed-by tag as well when you resend.

regards,
dan carpenter

