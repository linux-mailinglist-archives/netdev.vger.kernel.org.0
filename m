Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0792FAB59A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391590AbfIFKON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 06:14:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391487AbfIFKON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 06:14:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86ADnO6003918;
        Fri, 6 Sep 2019 10:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9ZMm+KBPOZqRS75mZ7031RkVZwnvS9z1Wx5ZMZLh53E=;
 b=IHImL/hkpYOt1DBem1nyKiRma41Tt63AdsBBMTsHoMHCrk4qYIyF8MEAUudo0LBszc00
 EuEYKFG28HacWSmOii8pkGPNVO5KH4N+ogm3MKctbmUOAe8XSffQPwjpR/djF0MeTS43
 qu7y5p/eZMCCzVW+Nxo48gHxAPrZTUsg01mGXwRysBu7ECLmGLWehZc36MYaFRjmrRxZ
 JW0axSSHVkyH6JbOyFgFvTvHmvAOdYybAC1pT3cv218pWD73PQBNAdPm8eHYogsrDIjR
 qVkeHtFBEToIrfgdFEQjQVSaT5P2qs7nRImhdOdknH7ihjx/pXX5mv3gIGky60w4eZ8Q pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uungtg02d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 10:13:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86ADoDW032312;
        Fri, 6 Sep 2019 10:13:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uum4gu7f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 10:13:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x86ADINC020397;
        Fri, 6 Sep 2019 10:13:18 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 03:13:18 -0700
Date:   Fri, 6 Sep 2019 13:13:06 +0300
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
Message-ID: <20190906101306.GA12017@kadam>
References: <20190906094158.8854-1-streetwalkermc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906094158.8854-1-streetwalkermc@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=927
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=992 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 12:41:57PM +0300, Dan Elkouby wrote:
> Commit 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return
> number of queued bytes") changed hidp_send_message to return non-zero
> values on success, which some other bits did not expect. This caused
> spurious errors to be propagated through the stack, breaking some (all?)
> drivers, such as hid-sony for the Dualshock 4 in Bluetooth mode.
> 
> Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>

I think we also need to update update ms_ff_worker() which assumes that
hid_hw_output_report() returns zero on success.  Please use the Fixes
tag for this since a lot of scripts rely on it to decide what to
backport.

Fixes: 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return number of queued bytes")

Otherwise, it looks good.  Thanks for catching this.

regards,
dan carpenter

