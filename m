Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF39025FBF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 10:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfEVIpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 04:45:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbfEVIpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 04:45:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M8hqLA137897;
        Wed, 22 May 2019 08:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=rLT9olIu6zNtNMMyHRkUQBkMEZ9LLWui5FRwcXMEYnE=;
 b=y6wZuUc9PEOOkwU5h6GjP+LBm3nvi9f+wv+JLr/SNsPwhwCvjrqu9dHUzABVF6HaAF06
 aB747ojaMazNwxzSVN8tMIxH1aR9/aKyljnGNznpeihVcenu+dWuoXFzsob40lMrJyHG
 Kh5D4/xD/kPUiPthtBwNdKMrhTx8njynKnn7vqK1zXj7MT7ALCK4DdwftlzvD0PYZE7T
 YiyuudYiosQ5KLhFThoSQp3mIPBf6rz9mwDpDepEo704e2YX3QP79Ol8S1U1vrN504t4
 e7UtWv8CKmKjKqG9UdQh5RR+R2exEa1HjHYwl6nk8je3S+D5Gk/Md70CyDDJa1wAfuMI qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2smsk5283y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 08:45:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M8j9kH035071;
        Wed, 22 May 2019 08:45:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2smshefsg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 08:45:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4M8jLHI029368;
        Wed, 22 May 2019 08:45:22 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 08:45:21 +0000
Date:   Wed, 22 May 2019 11:45:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Karsten Keil <isdn@linux-pingi.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        zhong jiang <zhongjiang@huawei.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] mISDN: make sure device name is NUL terminated
Message-ID: <20190522084513.GA2129@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user can change the device_name with the IMSETDEVNAME ioctl, but we
need to ensure that the user's name is NUL terminated.  Otherwise it
could result in a buffer overflow when we copy the name back to the user
with IMGETDEVINFO ioctl.

I also changed two strcpy() calls which handle the name to strscpy().
Hopefully, there aren't any other ways to create a too long name, but
it's nice to do this as a kernel hardening measure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/isdn/mISDN/socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index a14e35d40538..84e1d4c2db66 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -393,7 +393,7 @@ data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			memcpy(di.channelmap, dev->channelmap,
 			       sizeof(di.channelmap));
 			di.nrbchan = dev->nrbchan;
-			strcpy(di.name, dev_name(&dev->dev));
+			strscpy(di.name, dev_name(&dev->dev), sizeof(di.name));
 			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
 				err = -EFAULT;
 		} else
@@ -676,7 +676,7 @@ base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			memcpy(di.channelmap, dev->channelmap,
 			       sizeof(di.channelmap));
 			di.nrbchan = dev->nrbchan;
-			strcpy(di.name, dev_name(&dev->dev));
+			strscpy(di.name, dev_name(&dev->dev), sizeof(di.name));
 			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
 				err = -EFAULT;
 		} else
@@ -690,6 +690,7 @@ base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
+		dn.name[sizeof(dn.name) - 1] = '\0';
 		dev = get_mdevice(dn.id);
 		if (dev)
 			err = device_rename(&dev->dev, dn.name);
-- 
2.20.1

