Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F922389D3B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 07:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhETFqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 01:46:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22978 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhETFqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 01:46:33 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K5aE9N010395;
        Thu, 20 May 2021 05:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AcofJe4OsYgrXuCBDsBRH0YG1kx+BV8oi3tFkRmbIws=;
 b=TlKOBtTCEOsslclf5b9rxfON9qQlpL3X/VE+fAa9AlcMj0iw+fZinIUb5yN9z6hPi3XK
 fLc+wfSLZl+nmvegrZ/ello31gfa/F9RBgSd5y6jsXnEq0fjJuALNq5VJoiVRMiD53SB
 JfSnKMX0YP2iH2IWzHytNpfndmFZfq8GJxrMAm/DbZjBHxOvUqE6mzlg2ObXgzzx5vqB
 DhWBE5BCNjhCqf3qvWtg3HeZuJGCBGPWWJHpB+ukFRch5c+Fki+caAtBz3aImy46HB0u
 TFf6Pe/BTVG4ncsk7Co+6YisXNg6FcUh1ViUec182ldbxLfSTsjDsq4WFxBnTe5yHd61 Kw== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4u8ra29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:44:49 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14K5imx1020150;
        Thu, 20 May 2021 05:44:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mecmbq7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:44:48 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14K5ihSu018930;
        Thu, 20 May 2021 05:44:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 38mecmbpw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:44:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14K5iPse028273;
        Thu, 20 May 2021 05:44:25 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 22:44:23 -0700
Date:   Thu, 20 May 2021 08:44:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Phoebe Buckheister <phoebe.buckheister@itwm.fraunhofer.de>
Subject: Re: [PATCH net-next] ieee802154: fix error return code in
 ieee802154_llsec_getparams()
Message-ID: <20210520054411.GC1955@kadam>
References: <20210519141614.3040055-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519141614.3040055-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: V7WVPR1lgVaBwvepuhB0VkR4f6TgD-lc
X-Proofpoint-ORIG-GUID: V7WVPR1lgVaBwvepuhB0VkR4f6TgD-lc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 02:16:14PM +0000, Wei Yongjun wrote:
> Fix to return negative error code -ENOBUFS from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Fixes: 3e9c156e2c21 ("ieee802154: add netlink interfaces for llsec")

This patch doesn't seem to affect runtime so far as I can tell with
a quick glance...

regards,
dan carpenter

