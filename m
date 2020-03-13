Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115731840C7
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgCMGKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:10:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39520 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgCMGKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:10:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02D68eax114524;
        Fri, 13 Mar 2020 06:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TJWOR0b05KYgrYXI33ZRi3S9npsn8UNea81aSvD6684=;
 b=WCcVfhSDYmCqDAdlLcWsgyl0yX6YKMuRsrY0QlXfFfauSSkTGOnv9nbeHHtFAbQkXUeN
 Gj3W9gh/f2PAYwD7OJeWJFlewNW4tPhukgQLSq6oePyMvrd4Dgmp/PRaiNKipqXUQBXT
 FQpyFRbmHUHPSAIt5tmXCUnVv9pc5/JWCV3M+9pHLjGSSDMnL/bn0gjDYP/h5QQpiN0T
 T2uPnKKuzQJg/NGO7nvW2b7SNrcRAFkiBibnYiXr0x5ln3xvc5EsOC/ITcs6P3LEKlrf
 Huo5GZRA9OtsshVp5zbZEa128OMYMzGUkp2Bg0bz2FQ8QHc0/gLu1r8CK3AOWWiMTHHO tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yqtaga1bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 06:10:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02D68FS5104230;
        Fri, 13 Mar 2020 06:10:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yqtabvxcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 06:10:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02D6AbFF030638;
        Fri, 13 Mar 2020 06:10:37 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 23:10:37 -0700
Date:   Fri, 13 Mar 2020 09:10:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Miller <davem@davemloft.net>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, andrew@lunn.ch, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] octeontx2-pf: unlock on error path in
 otx2_config_pause_frm()
Message-ID: <20200313061028.GP11561@kadam>
References: <20200312113048.GB20562@mwanda>
 <20200312.155321.1860923182739836747.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312.155321.1860923182739836747.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 03:53:21PM -0700, David Miller wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Date: Thu, 12 Mar 2020 14:30:48 +0300
> 
> > We need to unlock before returning if this allocation fails.
> > 
> > Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Applied to net-next.
> 
> Dan, please indicate the appropriate target tree in your Subject lines
> in the future.  I have to dance around my GIT trees to figure out where
> your patches apply and that eats up more time than necessary.

Sorry, I've been trying to do that but I forgot.  I'm going to update
my QC scripts so hopefully it doesn't happen again.

regards,
dan carpenter

