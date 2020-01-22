Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA40144C72
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgAVH0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:26:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVH0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:26:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M7I2PK152760;
        Wed, 22 Jan 2020 07:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=t19fr+i+3LAUvZjKR4432MxiwRHJP7muLT3rFzcvB44=;
 b=K8Zv8S6Dql9ihiPPqSMJVU8SFDHL98TVCj/f2M7Wo721MQcoIed7ErtuKP7XSSq5lPct
 agrn19VDdggS/dBEBVRKqT27NM93WOfahSpvaO9F3OfCI4vrX6rm+cMP3DJ+Rbb3E9TI
 ALssTQfWhPnpMfsV0PYa5+K9gyWjQypsrr07ifiG64ADpi+pRwKSky6oZORo8kEvUXtO
 nnw2p2dm9Dnm/jLnKWEaUbjfZ1yweLbSW8EgvTlqrQpIr0Qeq0W2jR5N8Oy6AWEa36i/
 vB1HgioPDx53Ji9A/CJoBr0opZ2jrW5nknylNWIQJ8Dem/RTPHCeCE1nu3XrpZp34uVK SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyq9vft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 07:26:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M7Itmn048101;
        Wed, 22 Jan 2020 07:26:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xnpfqncne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jan 2020 07:26:21 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00M7QEsY021950;
        Wed, 22 Jan 2020 07:26:15 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 23:26:14 -0800
Date:   Wed, 22 Jan 2020 10:26:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        syzbot <syzbot+5cfab121b54dff775399@syzkaller.appspotmail.com>,
        allison@lohutok.net, keescook@chromium.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: [PATCH] net/802/mrp: disconnect on uninit
Message-ID: <20200122072604.hkspgs6ihyelzxtn@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f35c6a059cab64c5@google.com>
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[  I was investigating this bug and I sort of got carried away and wrote
   a patch.  I'm going to see if I can find a test system to start
   testing these patches then I will resend the patch.  - dan ]

Syzbot discovered that mrp_attr attr structs are being leaked.  They're
supposed to be freed by mrp_attr_destroy() which is called from
mrp_attr_event().

I think that when we close everything down, we're supposed to send one
last disconnect event but the code for that wasn't fully implemented.

Reported-by: syzbot+5cfab121b54dff775399@syzkaller.appspotmail.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.  Idea only.

 net/802/mrp.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/802/mrp.c b/net/802/mrp.c
index bea6e43d45a0..f1d71cd68a79 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -562,7 +562,9 @@ void mrp_request_leave(const struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(mrp_request_leave);
 
-static void mrp_mad_event(struct mrp_applicant *app, enum mrp_event event)
+static void mrp_mad_event_helper(struct mrp_applicant *app,
+				 enum mrp_event event,
+				 int state)
 {
 	struct rb_node *node, *next;
 	struct mrp_attr *attr;
@@ -571,10 +573,24 @@ static void mrp_mad_event(struct mrp_applicant *app, enum mrp_event event)
 	     next = node ? rb_next(node) : NULL, node != NULL;
 	     node = next) {
 		attr = rb_entry(node, struct mrp_attr, node);
+		if (state != -1)
+			attr->state = state;
 		mrp_attr_event(app, attr, event);
 	}
 }
 
+static void mrp_mad_event(struct mrp_applicant *app, enum mrp_event event)
+{
+	mrp_mad_event_helper(app, event, -1);
+}
+
+static void mrp_mad_event_state(struct mrp_applicant *app,
+				enum mrp_event event,
+				enum mrp_applicant_state state)
+{
+	mrp_mad_event_helper(app, event, state);
+}
+
 static void mrp_join_timer_arm(struct mrp_applicant *app)
 {
 	unsigned long delay;
@@ -894,7 +910,7 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 	del_timer_sync(&app->periodic_timer);
 
 	spin_lock_bh(&app->lock);
-	mrp_mad_event(app, MRP_EVENT_TX);
+	mrp_mad_event_state(app, MRP_EVENT_TX, MRP_APPLICANT_LA);
 	mrp_pdu_queue(app);
 	spin_unlock_bh(&app->lock);
 
-- 
2.11.0

