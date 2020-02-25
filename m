Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F0216BA47
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgBYHOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:14:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgBYHOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:14:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P788Uj059207;
        Tue, 25 Feb 2020 07:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=IYwcpqgvaZsnC0I2doF/aLiQrjXJBnM3Sq3y0Svxgr0=;
 b=ooAXvZGmWZmpXqsvvQ6y6uMQkCB5TpygSJ7oBw6K0z3GHxIdWzmcoMzXVn0iHlHAgMhU
 kuOqPF29xWn5vXMtS2oRmB+Bswe+/aSZDHsHfITIJhRVJmMuVCTXQUIaPh1Re8o1Lhkn
 1ubHelC0LbT5BXwBPcIhi4xtAl6IaD/n0XULtjGDClYnP6hYnhlBXpDzWZBZj3wFC5kp
 tDwWR1CDBwHUvmucyFuPB7ns6GarUg3+mwsDkGpZbRfNK5nag3Zsyva70PGk25U2k8uZ
 czdL8eNWnIC4JvmaRqS9Y/I8JjZspwGr6BXJqBHudV/L3IdejInPC8TfC6k/eevnx22O PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4re0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 07:14:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P7811C189087;
        Tue, 25 Feb 2020 07:14:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ybe13623n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 07:14:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P7EGaw025386;
        Tue, 25 Feb 2020 07:14:18 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 23:14:15 -0800
Date:   Tue, 25 Feb 2020 10:14:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     netdev@vger.kernel.org
Cc:     tgraf@suug.ch
Subject: [bug report] dcbnl: Shorten all command handling functions
Message-ID: <20200225071408.gbrnwkr7q5kcj33v@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=565 spamscore=0
 suspectscore=1 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250058
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=626 spamscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=1 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch 7be994138b18: "dcbnl: Shorten all command handling
functions" from Jun 13, 2012, leads to the following static checker
warning:

	net/dcb/dcbnl.c:1509 dcbnl_ieee_set()
	warn: passing signed to unsigned: 'err'

net/dcb/dcbnl.c
  1491                                  continue;
  1492  
  1493                          if (nla_len(attr) < sizeof(struct dcb_app)) {
  1494                                  err = -ERANGE;
  1495                                  goto err;
  1496                          }
  1497  
  1498                          app_data = nla_data(attr);
  1499                          if (ops->ieee_setapp)
  1500                                  err = ops->ieee_setapp(netdev, app_data);
  1501                          else
  1502                                  err = dcb_ieee_setapp(netdev, app_data);
  1503                          if (err)
  1504                                  goto err;

"err" is negative error codes.

  1505                  }
  1506          }
  1507  
  1508  err:
  1509          err = nla_put_u8(skb, DCB_ATTR_IEEE, err);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
It's not clear what this is doing but it truncates "err" to a u8 and
sets err to zero.

  1510          dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, seq, 0);
  1511          return err;
  1512  }

There is a similar one at the end of dcbnl_ieee_del() as well.  I've no
idea how to fix this.

regards,
dan carpenter
