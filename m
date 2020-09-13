Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C05126802B
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgIMQNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 12:13:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIMQNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 12:13:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DG9OC8102488;
        Sun, 13 Sep 2020 16:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ug0tMzhluITQTcoGBeWBNqEK3Yug8rBXAC6fgIlchDU=;
 b=SGgTGK+RK3OiyWtYLGQOkQWO6TxPRTZe31NbqbWSTDslO/HSCF4bAjkuVmTsVDmSLt9c
 7ZmnWCjcRCcYFtBwP+0ELWehwh5qUT+YBCNZY6Kfv7L9j/G3WuLJHmo0EbP5RGc8yNvx
 xC6slVYdm0SaZ2DyWu9zL9rKBfa0/zyD1pRVWX54g3iKKi4sOz3wgStkwJ96zw4dH7yV
 O/FHSxCZgbr9Fe/fALWz6TSCrt5Mkazmbnt7bjKMlEXitqMlnyJmk720xLGNQfKlg2gC
 g9Yh7CTNozWFqcKcvKIP7oiBMlO2dk9J0zHE9Uy6PjR79FCDlbJvcKxlcTRQIAXZCp0j SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9ku4ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Sep 2020 16:11:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DG5vgQ160957;
        Sun, 13 Sep 2020 16:11:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33h7wjtmd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Sep 2020 16:11:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08DGBrTb013868;
        Sun, 13 Sep 2020 16:11:53 GMT
Received: from [10.74.86.192] (/10.74.86.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 13 Sep 2020 16:11:53 +0000
Subject: Re: [PATCH v3 02/11] xenbus: add freeze/thaw/restore callbacks
 support
To:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        jgross@suse.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        kamatam@amazon.com, sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw@amazon.co.uk, benh@kernel.crashing.org
References: <cover.1598042152.git.anchalag@amazon.com>
 <2d3a7ed32bf38e13e0141a631a453b6e4c7ba5dc.1598042152.git.anchalag@amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <eebc26b8-f1b1-3bea-5366-dd77f063237e@oracle.com>
Date:   Sun, 13 Sep 2020 12:11:47 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <2d3a7ed32bf38e13e0141a631a453b6e4c7ba5dc.1598042152.git.anchalag@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009130145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=2 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009130145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/21/20 6:26 PM, Anchal Agarwal wrote:
> From: Munehisa Kamata <kamatam@amazon.com> 
>
> Since commit b3e96c0c7562 ("xen: use freeze/restore/thaw PM events for
> suspend/resume/chkpt"), xenbus uses PMSG_FREEZE, PMSG_THAW and
> PMSG_RESTORE events for Xen suspend. However, they're actually assigned
> to xenbus_dev_suspend(), xenbus_dev_cancel() and xenbus_dev_resume()
> respectively, and only suspend and resume callbacks are supported at
> driver level. To support PM suspend and PM hibernation, modify the bus
> level PM callbacks to invoke not only device driver's suspend/resume but
> also freeze/thaw/restore.
>
> Note that we'll use freeze/restore callbacks even for PM suspend whereas
> suspend/resume callbacks are normally used in the case, becausae the
> existing xenbus device drivers already have suspend/resume callbacks
> specifically designed for Xen suspend.


Something is wrong with this sentence. Or with my brain --- I can't
quite parse this.


And please be consistent with "PM suspend" vs. "PM hibernation".


>  So we can allow the device
> drivers to keep the existing callbacks wihtout modification.
>


> @@ -599,16 +600,33 @@ int xenbus_dev_suspend(struct device *dev)
>  	struct xenbus_driver *drv;
>  	struct xenbus_device *xdev
>  		= container_of(dev, struct xenbus_device, dev);
> +	bool xen_suspend = is_xen_suspend();
>  
>  	DPRINTK("%s", xdev->nodename);
>  
>  	if (dev->driver == NULL)
>  		return 0;
>  	drv = to_xenbus_driver(dev->driver);
> -	if (drv->suspend)
> -		err = drv->suspend(xdev);
> -	if (err)
> -		dev_warn(dev, "suspend failed: %i\n", err);
> +	if (xen_suspend) {
> +		if (drv->suspend)
> +			err = drv->suspend(xdev);
> +	} else {
> +		if (drv->freeze) {


'else if' (to avoid extra indent level).  In xenbus_dev_resume() too.


> +			err = drv->freeze(xdev);
> +			if (!err) {
> +				free_otherend_watch(xdev);
> +				free_otherend_details(xdev);
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	if (err) {
> +		dev_warn(&xdev->dev,


Is there a reason why you replaced dev with xdev->dev (here and elsewhere)?


>  "%s %s failed: %d\n", xen_suspend ?
> +				"suspend" : "freeze", xdev->nodename, err);
> +		return err;
> +	}
> +
>  	

> @@ -653,8 +683,44 @@ EXPORT_SYMBOL_GPL(xenbus_dev_resume);
>  
>  int xenbus_dev_cancel(struct device *dev)
>  {
> -	/* Do nothing */
> -	DPRINTK("cancel");
> +	int err;
> +	struct xenbus_driver *drv;
> +	struct xenbus_device *xendev = to_xenbus_device(dev);


xdev for consistency please.


> +	bool xen_suspend = is_xen_suspend();


No need for this, you use it only once anyway.


-boris


