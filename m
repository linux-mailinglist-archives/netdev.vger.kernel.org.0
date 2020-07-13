Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A821F21DADE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgGMPzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:55:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729864AbgGMPzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:55:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DFkrsq142046;
        Mon, 13 Jul 2020 15:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YfsCV97Xo9LXbqDIaJggcb1pS+4bJbSWqsCksn6aRt4=;
 b=qfIW8De2FYILCNtlXt/UGbYzyfngsSU3s6D7AZqhh+ORukvy1OS5Bk9irwhm3BG5fqxz
 Sh9mxtjU6u08LA1gORyS6FgGuSJTgftzoOW1sjHXOzvkxrmerVFue7spOoEFbisa+Rz3
 JUBl4UaMF5jrkciTUDuhfp/Ig78kuViMQZa+nMaKGbOqkCnSJvZH3KzxYImCEAjHz302
 HvT7eiPx79vM+CQWVWS398iBHBImeVIQCV/E8RS0PxTAv+4PaPcVywzSmZOOOFNWvG/g
 9I5QEOXeqEYxOBHrv6BzUD21wFfHSArHQ0accz5j650r5fJt7U43bq1uVT6B+36lVzB3 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275ckyv8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 15:54:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DFmYAG136898;
        Mon, 13 Jul 2020 15:52:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qbvt2rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 15:52:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06DFq5Ll000743;
        Mon, 13 Jul 2020 15:52:06 GMT
Received: from [10.39.206.45] (/10.39.206.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 08:52:05 -0700
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend
 mode
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
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Autocrypt: addr=boris.ostrovsky@oracle.com; keydata=
 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
 Jg6OxFYd01z+a+oL
Message-ID: <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
Date:   Mon, 13 Jul 2020 11:52:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> From: Munehisa Kamata <kamatam@amazon.com>
>
> Guest hibernation is different from xen suspend/resume/live migration.
> Xen save/restore does not use pm_ops as is needed by guest hibernation.=

> Hibernation in guest follows ACPI path and is guest inititated , the
> hibernation image is saved within guest as compared to later modes
> which are xen toolstack assisted and image creation/storage is in
> control of hypervisor/host machine.
> To differentiate between Xen suspend and PM hibernation, keep track
> of the on-going suspend mode by mainly using a new PM notifier.
> Introduce simple functions which help to know the on-going suspend mode=

> so that other Xen-related code can behave differently according to the
> current suspend mode.
> Since Xen suspend doesn't have corresponding PM event, its main logic
> is modfied to acquire pm_mutex and set the current mode.
>
> Though, acquirng pm_mutex is still right thing to do, we may
> see deadlock if PM hibernation is interrupted by Xen suspend.
> PM hibernation depends on xenwatch thread to process xenbus state
> transactions, but the thread will sleep to wait pm_mutex which is
> already held by PM hibernation context in the scenario. Xen shutdown
> code may need some changes to avoid the issue.
>
> [Anchal Agarwal: Changelog]:
>  RFC v1->v2: Code refactoring
>  v1->v2:     Remove unused functions for PM SUSPEND/PM hibernation
>
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> ---
>  drivers/xen/manage.c  | 60 +++++++++++++++++++++++++++++++++++++++++++=

>  include/xen/xen-ops.h |  1 +
>  2 files changed, 61 insertions(+)
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index cd046684e0d1..69833fd6cfd1 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -14,6 +14,7 @@
>  #include <linux/freezer.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/export.h>
> +#include <linux/suspend.h>
> =20
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -40,6 +41,20 @@ enum shutdown_state {
>  /* Ignore multiple shutdown requests. */
>  static enum shutdown_state shutting_down =3D SHUTDOWN_INVALID;
> =20
> +enum suspend_modes {
> +	NO_SUSPEND =3D 0,
> +	XEN_SUSPEND,
> +	PM_HIBERNATION,
> +};
> +
> +/* Protected by pm_mutex */
> +static enum suspend_modes suspend_mode =3D NO_SUSPEND;
> +
> +bool xen_is_xen_suspend(void)


Weren't you going to call this pv suspend? (And also --- is this suspend
or hibernation? Your commit messages and cover letter talk about fixing
hibernation).


> +{
> +	return suspend_mode =3D=3D XEN_SUSPEND;
> +}
> +



> +
> +static int xen_pm_notifier(struct notifier_block *notifier,
> +			unsigned long pm_event, void *unused)
> +{
> +	switch (pm_event) {
> +	case PM_SUSPEND_PREPARE:
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_RESTORE_PREPARE:
> +		suspend_mode =3D PM_HIBERNATION;


Do you ever use this mode? It seems to me all you care about is whether
or not we are doing XEN_SUSPEND. And so perhaps suspend_mode could
become a boolean. And then maybe even drop it altogether because it you
should be able to key off (shutting_down =3D=3D SHUTDOWN_SUSPEND).


> +		break;
> +	case PM_POST_SUSPEND:
> +	case PM_POST_RESTORE:
> +	case PM_POST_HIBERNATION:
> +		/* Set back to the default */
> +		suspend_mode =3D NO_SUSPEND;
> +		break;
> +	default:
> +		pr_warn("Receive unknown PM event 0x%lx\n", pm_event);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +};



> +static int xen_setup_pm_notifier(void)
> +{
> +	if (!xen_hvm_domain())
> +		return -ENODEV;


I forgot --- what did we decide about non-x86 (i.e. ARM)?


And PVH dom0.


-boris



