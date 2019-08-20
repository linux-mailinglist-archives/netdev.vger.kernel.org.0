Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C9295A84
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbfHTI6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:58:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbfHTI63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 04:58:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K8mlIl093857;
        Tue, 20 Aug 2019 08:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=OBYJdKc9ABkHszixtESMVjnUaHwXkRGiyjxpo+PVkvU=;
 b=gUbYQwHvEQoNaNOFYW0nCR3NQAKBh/gA8DnqX71fqTX1K1f+Z3QCtgecMgP1PwMZejuv
 dASOeQ/w+i4UV5je8whUi6gPiCx4nGRZrPr9MhFwqKNKTRZOEW/NQngr89I1y9q7Lni3
 6HTBzaHErW/L4jU+nZP4xoFQSM+NKsT+fQXdigmxv+O+qh1rFrCmqiLhigThxoMQiG7b
 k9o7+DLO4ThH9VOZDWItyLVU54t/ptxvNH5HaOH7pjpOPmcD1fOJRTY0gEqOq803wPDi
 M5Hi64a3PXiofVQstBK96i1NakYSH6f2PXEk9N7g9yboI0YnQR5hznXywnO2Z+05C4Xe VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uea7qmvqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 08:57:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K8mSLG068665;
        Tue, 20 Aug 2019 08:55:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ufwgcx89f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 08:55:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7K8tvCl009490;
        Tue, 20 Aug 2019 08:55:57 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 01:55:57 -0700
Date:   Tue, 20 Aug 2019 11:55:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()
Message-ID: <20190820085547.GE4451@kadam>
References: <20190820013652.147041-1-yuehaibing@huawei.com>
 <93fafdab-8fb3-0f2b-8f36-0cf297db3cd9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93fafdab-8fb3-0f2b-8f36-0cf297db3cd9@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=710
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=777 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 09:28:26AM +0200, Björn Töpel wrote:
> For future patches: Prefix AF_XDP socket work with "xsk:" and use "PATCH
> bpf-next" to let the developers know what tree you're aiming for.

There are over 300 trees in linux-next.  It impossible to try remember
everyone's trees.  No one else has this requirement.

Maybe add it as an option to get_maintainer.pl --tree <hash> then that
would be very easy.

regards,
dan carpenter

