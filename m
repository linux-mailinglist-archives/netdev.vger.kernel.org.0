Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2284F21EAC9
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGNIAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:00:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:00:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E7vXl2177462;
        Tue, 14 Jul 2020 08:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=C9ONEvJcEuBYJCXRgpHShvymZKUc+CA90dBt/Q2+rs8=;
 b=I9od1WDDxaSyifltzGam/113d6WpJ2gzMwEICdAcRiPqP/ENodFW1X7eCuFgtEldT5yo
 ZjAkQm3MALHDGgGfoZs/mKrcj+s4OF42VDON58y81A4R4/ZXaL4Z6UBXOqjyCC2g73S/
 qKss54/GIWBRAB0V2429zO68bFfHPBfiqK0P2nHSeYoF/lL12wPQMes4OCZny6RMT2ZP
 MMLMzivW+XUwdiwKAjb2SEIuyWc4FjaRfSIDJuMUU6htqs2A23C2lly+LJrPD0qyFVp9
 +YmBxAZPiWSc+7unswhgoK3AFbhY+cwPaFkhsjtifHt518vpINsXXzv50ZAGXhazfG9I Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cm3s05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 08:00:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E7qcqd119837;
        Tue, 14 Jul 2020 08:00:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 327qbx4bfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 08:00:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E80jox000463;
        Tue, 14 Jul 2020 08:00:45 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 01:00:44 -0700
Date:   Tue, 14 Jul 2020 11:00:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Miller <davem@davemloft.net>
Cc:     george.kennedy@oracle.com, kuba@kernel.org,
        dhaval.giani@oracle.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] ax88172a: fix ax88172a_unbind() failures
Message-ID: <20200714080038.GX2571@kadam>
References: <1594641537-1288-1-git-send-email-george.kennedy@oracle.com>
 <20200713.170859.794084104671494668.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713.170859.794084104671494668.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 05:08:59PM -0700, David Miller wrote:
> From: George Kennedy <george.kennedy@oracle.com>
> Date: Mon, 13 Jul 2020 07:58:57 -0400
> 
> > @@ -237,6 +237,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
> >  
> >  free:
> >  	kfree(priv);
> > +	if (ret >= 0)
> > +		ret = -EIO;
> >  	return ret;
> 
> Success paths reach here, so ">= 0" is not appropriate.  Maybe you
> meant "> 0"?

No, the success path is the "return 0;" one line before the start of the
diff.  This is always a failure path.

regards,
dan carpenter

