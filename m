Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18230AB6EC
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731917AbfIFLMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:12:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfIFLL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:11:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86BAO2i049604;
        Fri, 6 Sep 2019 11:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=s6bUfn3M2Qn5f9zJCGuo2O8BMmS1pPdybKqDEQJQR8I=;
 b=IbIDBCZAqSX8jfrLOR18B81k6LaArCdkzP+8NvfFJRCeOgYpZismgpKtkigWzaWCVAhh
 wkpcElO//ht2C9fCyLFRI+nBQnFtI1UDU6H85IE2X1IpINoqbDZG6MDclCoYB6LLt39o
 es7cTWiHDNVBnLTj9iXtRmLVeL1/S84FBTzNy02mM0sBlhNkXkS7OeHXSyiRm9Es8/P0
 DDVFq+yDTeBw5jL6ZV5oTWCyc31Nc59EJ4MV5vXKBT/OMXB+5jmO6kV8Uy4/RK9Ma4rV
 7CFx1aHHS+eLTixvyqYq1uqSLurdQAo7fWbo3pign/GYV42c6V9hlqKLctDK66r2USJx ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uupbd00b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 11:11:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86B9PRv156389;
        Fri, 6 Sep 2019 11:11:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2uum4gwaqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 11:11:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x86BBSxK024021;
        Fri, 6 Sep 2019 11:11:28 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 04:11:28 -0700
Date:   Fri, 6 Sep 2019 14:11:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dan Elkouby <streetwalkermc@gmail.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <computersforpeace@gmail.com>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hidp: Fix assumptions on the return value of
 hidp_send_message
Message-ID: <20190906111117.GB14147@kadam>
References: <20190906101306.GA12017@kadam>
 <20190906110645.27601-1-streetwalkermc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906110645.27601-1-streetwalkermc@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=884
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=949 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 02:06:44PM +0300, Dan Elkouby wrote:
> hidp_send_message was changed to return non-zero values on success,
> which some other bits did not expect. This caused spurious errors to be
> propagated through the stack, breaking some drivers, such as hid-sony
> for the Dualshock 4 in Bluetooth mode.
> 
> As pointed out by Dan Carpenter, hid-microsoft directly relied on that
> assumption as well.
> 
> Fixes: 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return number of queued bytes")
> 
> Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

