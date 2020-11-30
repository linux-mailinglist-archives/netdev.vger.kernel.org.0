Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BA62C848C
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgK3M6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:58:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgK3M6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:58:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCsqrj065582;
        Mon, 30 Nov 2020 12:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Z32HeZTxYmA2bg5YFp3JSD0ies4QNEPkMbhbYtB8dhg=;
 b=A6zuZjx50193pqYusUq0vapLI3Rmgn/N5eJtrgSZoUgnCv2ZikcLLnglaCj+DvZgNkBS
 buCLJDSxSkhiG6rDOn8OauFi83J9q0gYyQSc8ENMbrAinvh5Ym2Wc2BDd4yhpclLRDtc
 iowN8I3vBGjquBk8JPxN3qaLvZqaWdGFMKS+ypgyRSFBZNZJJJ48Sz76SzCF0DVbAMoS
 QK20bB5NCpYFy3pMIbipWFIjE/A2V01In6R0ZHeMubsbz37HDuMP+DI7WaM1Myp/WeVi
 enYDU65QqDFyPhFiGdTP1MuCl6QHkzWeGCvVt/tPwQas0OdSax1yO5HbQ4P/msgwvZhz kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egkcuwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 12:57:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCoKt9083188;
        Mon, 30 Nov 2020 12:55:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404kj7sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 12:55:22 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUCtKqI016127;
        Mon, 30 Nov 2020 12:55:20 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 04:55:19 -0800
Date:   Mon, 30 Nov 2020 15:55:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 127/141] staging: qlge: Fix fall-through warnings for
 Clang
Message-ID: <20201130125510.GF2767@kadam>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <673bd9f27bcc2df8c9d12be94f54001d8066d4ab.1605896060.git.gustavoars@kernel.org>
 <20201125044257.GA142382@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125044257.GA142382@f3>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 01:42:57PM +0900, Benjamin Poirier wrote:
> On 2020-11-20 12:39 -0600, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> > by explicitly adding a break statement instead of letting the code fall
> > through to the next case.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >  drivers/staging/qlge/qlge_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index 27da386f9d87..c41b1373dcf8 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -1385,6 +1385,7 @@ static void ql_categorize_rx_err(struct ql_adapter *qdev, u8 rx_err,
> >  		break;
> >  	case IB_MAC_IOCB_RSP_ERR_CRC:
> >  		stats->rx_crc_err++;
> > +		break;
> >  	default:
> >  		break;
> >  	}
> 
> In this instance, it think it would be more appropriate to remove the
> "default" case.

There are checkers which complain about that.  (As a static checker
developer myself, I think complaining about missing default cases is a
waste of everyone's time).

regards,
dan carpenter
