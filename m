Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5330337B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 05:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbhAZEyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:54:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbhAYJsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:48:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8Jmuf180207;
        Mon, 25 Jan 2021 08:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Gny0ys3dn79MPY7dervEdEGIVTuwIAFn9k0P2oupp44=;
 b=yHxJdtNEIaY3XlUc7Uwu7L7y2c2DzCw06sdIJalG3n6a7RE4xPR07T6+ab+ub7gBBlTY
 Q2PJeDF1W6K+Q6DBOKY7/woV8+ZRMMcTC2KBRNt/MS70trKLZK95mBxHdpPGTqAdZXuJ
 YIrXMBLfC/SrvfMXlpOmYOevF4UZ0xZqwqnC0bEhZkuZvyOGQ66PaJcggUN1WnRXyinf
 PkjOXIRpTWUscKNE0QNKG/gRqMcDFnup29r2QALsHy2ULIzwWmcYdjmsOzCF2/x0ioBF
 IFe9tZPhbEAxmCJGWnMSwVfpvOLDG54lHO/NYQQHLmWpynRdZewdhLfPIX3AUusV9iwL zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7qm2b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:19:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8JU5P037779;
        Mon, 25 Jan 2021 08:19:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 368wjpd2hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:19:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10P8Jl2K023050;
        Mon, 25 Jan 2021 08:19:47 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 00:19:47 -0800
Date:   Mon, 25 Jan 2021 11:19:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 net-next] net: mscc: ocelot: fix error handling bugs
 in mscc_ocelot_init_ports()
Message-ID: <20210125081940.GK20820@kadam>
References: <YA59en4lJCiYsPHv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YA59en4lJCiYsPHv@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250049
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Oops.  Please ignore this patch.  Part of it is missing.

regards,
dan carpenter

