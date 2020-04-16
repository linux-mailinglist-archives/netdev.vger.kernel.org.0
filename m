Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7971AC421
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 15:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgDPNyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:54:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbgDPNyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:54:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GDruw5059005;
        Thu, 16 Apr 2020 13:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=ewaUBdhOkKob9iIFy9m3K0prmwFTG1DLRzvoCPBRDmM=;
 b=WapX0vA+MMohwDAw+oFE94garCniL8tFeOp4FSxAnPznNkgWSAg/41+GMuj8l9eKgvqK
 21eew9TudM+WsSKECzs6BsgFE+MIuGLMTEGv4UYrU9oyn2bxYrWppOcqZo3i+uTyWd37
 7C9bJi4jeNI57koT0tk43UYO7uRK0j7ex6Aj2hMm198eaAcxS2cUw3WZqOaVadF8wPvJ
 sjpwQxYtAWA54MJC6Yz279TaH/t/nGwN4Ipp0vQRRc3dkg03edVa8RhWSPZfRUfqBKTn
 3ekjd3Vbip0Tu7ilVugZVA/xXeT1gd64XuwTjw8OiL4cYE3NLVdHAMj494zKnOVArFS7 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30emejharp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 13:54:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GDh7EI155474;
        Thu, 16 Apr 2020 13:52:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30emen3jp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 13:52:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03GDqZF0012118;
        Thu, 16 Apr 2020 13:52:35 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 06:52:35 -0700
Date:   Thu, 16 Apr 2020 16:52:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 12/20] staging: wfx: align semantic of beacon filter with
 other filters
Message-ID: <20200416135225.GQ1163@kadam>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
 <20200415161147.69738-13-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200415161147.69738-13-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004160098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004160099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 06:11:39PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Filters provided by HIF API are sometime inclusive, sometime exclusive.
> 
> This patch align the behavior and name of the beacon filter with the
> other filters. Also avoid double negation: "disable filter"

Hooray!  I have been wanting to suggest this every time I see the
->disable_beacon_filter name, especially for patch 7/20.

regards,
dan carpenter

