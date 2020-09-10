Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E73B2644A9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgIJKwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:52:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbgIJKtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 06:49:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AAYPWK177381;
        Thu, 10 Sep 2020 10:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fN/ETYUSmj9/pRoUk3iHgY2Npxy2z+BXnfBD/U2xvEE=;
 b=a68PNyTuR/Ya7gDF83LDKZQwcJPvMkAb8MTEijJIo8fXjvS5/dm2yiB8iBvckb6OO4/V
 yR1giJXwGSHbLA6bJgRepaaLySl/LcC01ieNDGys7GTX6TcHtikMJbTS26UOsvAw4a9W
 aAdXPBGpbBL1Tx/GqkI/L7T7LWg1/36uU2Hkmd6HnGEcocw3vJhJlug+qGVHcBqO7bJX
 kQYf7e+l0+sVFw5cGLjN+jOVt7HOuG3t1cdCyNrIJQrEGNfzWtEtdGK48DGcSuEomfDk
 93MRfMYzfeZugwO4tH6FUIIxGCayOxvU3wPFIQN0leeWDXjlzH69xGeyA3A90zn+ofpc wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33c3an76nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 10:49:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AAkerQ067429;
        Thu, 10 Sep 2020 10:49:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33cmm0rd75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 10:49:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08AAnRgq022266;
        Thu, 10 Sep 2020 10:49:27 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 03:49:27 -0700
Date:   Thu, 10 Sep 2020 13:49:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 dereference in hci_event_packet()
Message-ID: <20200910104918.GF12635@kadam>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910043424.19894-1-anmol.karan123@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:04:24AM +0530, Anmol Karn wrote:
> Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
> as NULL. Fix it by adding pointer check for it.
> 
> Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> ---
>  net/bluetooth/hci_event.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 4b7fc430793c..871e16804433 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
>  		return;
>  	}
>  
> +	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {

It can't be an error pointer.  Shouldn't we call hci_conn_del() on this
path?  Try to find the Fixes tag to explain how this bug was introduced.

(Don't rush to send a v2.  The patch requires quite a bit more digging
and detective work before it is ready).

> +		hci_dev_unlock(hdev);
> +		return;
> +	}
> +
>  	if (ev->status) {
>  		hci_conn_del(hcon);
>  		hci_dev_unlock(hdev);

regards,
dan carpenter

