Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5C63890B0
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbhESOVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:21:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240320AbhESOVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:21:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JEFEbI047562;
        Wed, 19 May 2021 14:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=rYoKQ/yqCkVsQ9pvVzOFd9sWEWniiy34eTt7ihcghYs=;
 b=Pg6efs+2MiVkVanYzqUkUk2rz/7YOehsm4kL8KJYKeeXcKUdFBmsN7B/uxfnfrl1QvbR
 A3tgxSz2Oi6/em5OrLjpe8aod/vd4RMEeYeguU0yS4hQyx+QJA0OZ2iOpYz9kl2BoGwY
 Se9lorg8oqMeZc+FeC/nwXXDgK3y0ShrqfB7ra4bwPpHQzUEUIEPJArHuI6sSkacha7o
 qUi2yXEpV6DITC8xyUHFPjR0zUgxnP6MewVNU67UTxoioD5cmzFEIM4Tlyzh6mI+yxe5
 YdQKG1SVgRj0aust3I22ij04Sd8Zjm2AYUf2kzQHelq0DAPV07PmlIMcRk1XOnLYPMh/ Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38j5qr9quq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:19:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JEAO9j031306;
        Wed, 19 May 2021 14:19:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38megkh1k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:19:48 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JEJmJJ053023;
        Wed, 19 May 2021 14:19:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 38megkh1jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 14:19:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14JEJlJH004080;
        Wed, 19 May 2021 14:19:47 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 07:19:46 -0700
Date:   Wed, 19 May 2021 17:19:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     luiz.von.dentz@intel.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [bug report] Bluetooth: L2CAP: Add initial code for Enhanced Credit
 Based Mode
Message-ID: <YKUefcovrIVJg50u@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518082855.GB32682@kadam>
X-Proofpoint-GUID: gy8W_cX1yt19Zs-c12LkzdY3yt6Uwo5A
X-Proofpoint-ORIG-GUID: gy8W_cX1yt19Zs-c12LkzdY3yt6Uwo5A
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Luiz Augusto von Dentz,

The patch 15f02b910562: "Bluetooth: L2CAP: Add initial code for
Enhanced Credit Based Mode" from Mar 2, 2020, leads to the following
static checker warning:

	net/bluetooth/l2cap_core.c:6265 l2cap_ecred_reconf_rsp()
	warn: iterator 'chan->list.next' changed during iteration

net/bluetooth/l2cap_core.c
  6247  static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
  6248                                           struct l2cap_cmd_hdr *cmd, u16 cmd_len,
  6249                                           u8 *data)
  6250  {
  6251          struct l2cap_chan *chan;
  6252          struct l2cap_ecred_conn_rsp *rsp = (void *) data;
  6253          u16 result;
  6254  
  6255          if (cmd_len < sizeof(*rsp))
  6256                  return -EPROTO;
  6257  
  6258          result = __le16_to_cpu(rsp->result);
  6259  
  6260          BT_DBG("result 0x%4.4x", rsp->result);
  6261  
  6262          if (!result)
  6263                  return 0;
  6264  
  6265          list_for_each_entry(chan, &conn->chan_l, list) {
  6266                  if (chan->ident != cmd->ident)
  6267                          continue;
  6268  
  6269                  l2cap_chan_del(chan, ECONNRESET);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This can call:

		list_del(&chan->list);

which will lead to an oops in the next iteration.

  6270          }
  6271  
  6272          return 0;
  6273  }

regards,
dan carpenter
