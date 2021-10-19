Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC0432ABF
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 02:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhJSAEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 20:04:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbhJSAEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 20:04:14 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IKxRdM009446;
        Mon, 18 Oct 2021 20:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=HaYbOhx0Jisq12+/LcjKuLODglGabQYZoqBazXr8XCQ=;
 b=qB8pbIam8hdV66gGO61iM0IOm3QNuqT9M8SeG/flLtg7PFinCa/eg9K+6s4ssjKPaSsl
 FCYCga1sslgi0TvfJnLxvAWzJl396XD28S75pEvnP4a5323UrI8/oMtzFaOQiPlfh5us
 J/z/euag13TYUYTSQsl8GXOE8xutIcIPfRhL7A91fP9DadQ0Hgzzi3xG8z2I9zfxym+0
 oKUIuQMrCETC+1lU6ad19ACFNGrhzymF8XtcZRQEobPBvBH0+ivb6VCgDegaW0cm/PCu
 aGgpPZKOXohWuUxHbzSdcFVqJHR3PaR5cBX0YnZKT1wDLx601ijsEdJHG+W5GJsJy1R0 DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsg9934ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 20:01:35 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19INqcE3011548;
        Mon, 18 Oct 2021 20:01:34 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsg9934km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 20:01:34 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19INbECB011563;
        Tue, 19 Oct 2021 00:01:33 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3bqpcauyj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 00:01:33 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19J01Wf050987364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 00:01:32 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41B2A12405B;
        Tue, 19 Oct 2021 00:01:32 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8164C12405C;
        Tue, 19 Oct 2021 00:01:30 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.15.50])
        by b01ledav002.gho.pok.ibm.com (Postfix) with SMTP;
        Tue, 19 Oct 2021 00:01:30 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 9C1822E11C0; Mon, 18 Oct 2021 17:01:27 -0700 (PDT)
Date:   Mon, 18 Oct 2021 17:01:27 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dany Madden <drt@linux.ibm.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linyunsheng@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <YW4K1/O51V/5/q1w@us.ibm.com>
References: <20210918085232.71436-1-xuanzhuo@linux.alibaba.com>
 <YW3t8AGxW6p261hw@us.ibm.com>
 <20211018155503.74aeaba9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com>
 <20211018164723.02919102@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018164723.02919102@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BJs2fihDTGGfXqOoUH32BODcKCA-9sfq
X-Proofpoint-ORIG-GUID: 4srfQZsquStLqasXLBIvmdvwZrteOhwa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Mon, 18 Oct 2021 16:36:36 -0700 Dany Madden wrote:
> > > The BUG_ON() is here to make sure that when napi_enable() is called the
> > > napi instance was dormant, i.e. disabled. We have "STATE_SCHED" bit set
> > > on disabled NAPIs because that bit means ownership. Whoever disabled
> > > the NAPI owns it.
> > > 
> > > That BUG_ON() could have been taken outside of the loop, there's no
> > > point re-checking on every try.
> > > 
> > > Are you seeing NAPI-related failures? We had at least 3 reports in the
> > > last two weeks of strange failures which look like NAPI state getting
> > > corrupted on net-next...  
> > 
> > We hit two napi related crashes while attempting mtu size change.

BTW these are with a couple of bug fixes in ibmvnic driver applied
to 1e0083bd0777 ("gve: DQO: avoid unused variable warnings").

We are trying to narrow it down to the following change that is
required to be able to change mtu on ibmvnic.

> 
> Is it reproducible or happens rarely and randomly?

Random. We have been testing for a couple of weeks but hit both today.

Sukadev

---
index 8f17096e614d..a1533979c670 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1914,8 +1914,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
        ind_bufp = &tx_scrq->ind_buf;
 
        if (test_bit(0, &adapter->resetting)) {
-               if (!netif_subqueue_stopped(netdev, skb))
-                       netif_stop_subqueue(netdev, queue_num);
                dev_kfree_skb_any(skb);
 
