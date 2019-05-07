Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4DD81615A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfEGJrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:47:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfEGJrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:47:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x479hpZa188983;
        Tue, 7 May 2019 09:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=IszXfswFlYl2arvHcEs+8IRK7idVEl3hS9gc+dq8XSk=;
 b=RossLspbAbEVPTw69pFQWUUJfZtMyELXS/kRP6gPlL9wSsnSZAjLtr9sMYwN8ggyXNi3
 RHnOdhE3i0WNvIILqHZHRB+BUZslMmZUB9qBN69vt++4fr4GHyM465m/dHNbr1XmH3j/
 vMiPqb9erN/soXxsW4DlF0FDelDqYTMGtqikXIoqOcNrVki2RfTYwnKZMXCohhUXfard
 2N6QN65MaKWfUlMXqhBSMqSFVp22hfI54I2H1OVmSR4upjW5iVibhzMrCc7iAiAjJBZ9
 JwhwkNXoRZVRQ9hrxezohwFeflllTmSgmpwpKFkrmWsDoROIvU1saAgydEnP9zlAcWSH 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b0m018-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 09:47:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x479hIc0018848;
        Tue, 7 May 2019 09:45:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s94afcj0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 09:45:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x479iuHY011092;
        Tue, 7 May 2019 09:44:56 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 02:44:56 -0700
Date:   Tue, 7 May 2019 12:44:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Message-ID: <20190507094446.GA21059@kadam>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
 <20190507071914.GJ2269@kadam>
 <20190507083918.GI81826@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507083918.GI81826@meh.true.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=852
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070064
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=885 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh crap.  You did add a Fixes tag.  My bad.

I should have been more clear/pro-active on Friday and we could have
avoided this...  Next time.

regards,
dan carpenter
