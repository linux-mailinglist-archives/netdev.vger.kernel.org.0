Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681322A2DA5
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgKBPH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:07:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbgKBPHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:07:24 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2F2BqL017658;
        Mon, 2 Nov 2020 10:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=ej00TIy/LHYCfZ0dOvBL2CZGGwy/uU70D7NYwppsmbI=;
 b=CeaooSde8P9MLJGQKN7VpxuBW/kugZ0Ubk8qYGUGVzkeohHArRsAJfqjFGzuwYnrSWTi
 /ptajn1Z7ZgrR3zZo31N4TxfYQu4DwGZIM9MOdp/Y+Dsb/J7RVxYpG/UlZjrBsr38JMO
 QU2XYT4rgLfb/wu/r4f3NmrOWsd4bjbrs6bQe/3v6mVbSf7UsID1yUh0YKSXWWRY7S5G
 u7rS5ryqq0f4CSoaiy5ymxKzUUuttHCjWDDJlWCNeRqBInxF3obTc89/GHKBGSfpbGvF
 v2/iDtwKFAbGThkzyRZhk+yph3cAassBbG/Fw51NpGogJLBtisfxJdZunU8gGohvdF9x Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34jf03ayb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 10:06:59 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A2F2FeQ018031;
        Mon, 2 Nov 2020 10:06:59 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34jf03aya2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 10:06:59 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2EvfuO018377;
        Mon, 2 Nov 2020 15:06:57 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 34h0ehdquv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 15:06:57 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2F6u9U6554070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 15:06:56 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DB85C6057;
        Mon,  2 Nov 2020 15:06:56 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6B42C605F;
        Mon,  2 Nov 2020 15:06:55 +0000 (GMT)
Received: from sofia.ibm.com (unknown [9.199.57.175])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 15:06:55 +0000 (GMT)
Received: by sofia.ibm.com (Postfix, from userid 1000)
        id 06C7A2E323C; Mon,  2 Nov 2020 20:36:52 +0530 (IST)
Date:   Mon, 2 Nov 2020 20:36:51 +0530
From:   Gautham R Shenoy <ego@linux.vnet.ibm.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Len Brown <lenb@kernel.org>,
        Leonid Maksymchuk <leonmaxx@gmail.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Orson Zhai <orsonzhai@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Peter Rosin <peda@axentia.se>, Petr Mladek <pmladek@suse.com>,
        Philippe Bergheaud <felix@linux.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 20/33] docs: ABI: testing: make the files compatible with
 ReST output
Message-ID: <20201102150651.GA4379@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <cover.1603893146.git.mchehab+huawei@kernel.org>
 <4ebaaa0320101479e392ce2db4b62e24fdf15ef1.1603893146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ebaaa0320101479e392ce2db4b62e24fdf15ef1.1603893146.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_07:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 03:23:18PM +0100, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> Some files over there won't parse well by Sphinx.
> 

[..snip..]



> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index b555df825447..274c337ec6a9 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -151,23 +151,28 @@ Description:
>  		The processor idle states which are available for use have the
>  		following attributes:
> 
> -		name: (RO) Name of the idle state (string).
> +		======== ==== =================================================
> +		name:	 (RO) Name of the idle state (string).
> 
>  		latency: (RO) The latency to exit out of this idle state (in
> -		microseconds).
> +			      microseconds).
> 
> -		power: (RO) The power consumed while in this idle state (in
> -		milliwatts).
> +		power:   (RO) The power consumed while in this idle state (in
> +			      milliwatts).
> 
> -		time: (RO) The total time spent in this idle state (in microseconds).
> +		time:    (RO) The total time spent in this idle state
> +			      (in microseconds).
> 
> -		usage: (RO) Number of times this state was entered (a count).
> +		usage:	 (RO) Number of times this state was entered (a count).
> 
> -		above: (RO) Number of times this state was entered, but the
> -		       observed CPU idle duration was too short for it (a count).
> +		above:	 (RO) Number of times this state was entered, but the
> +			      observed CPU idle duration was too short for it
> +			      (a count).
> 
> -		below: (RO) Number of times this state was entered, but the
> -		       observed CPU idle duration was too long for it (a count).
> +		below: 	 (RO) Number of times this state was entered, but the
> +			      observed CPU idle duration was too long for it
> +			      (a count).
> +		======== ==== =================================================
> 
>  What:		/sys/devices/system/cpu/cpuX/cpuidle/stateN/desc
>  Date:		February 2008
> @@ -290,6 +295,7 @@ Description:	Processor frequency boosting control
>  		This switch controls the boost setting for the whole system.
>  		Boosting allows the CPU and the firmware to run at a frequency
>  		beyound it's nominal limit.
> +
>  		More details can be found in
>  		Documentation/admin-guide/pm/cpufreq.rst
> 

The changes to cpuidle states look good to me.


[..snip..]

> @@ -414,30 +434,30 @@ Description:	POWERNV CPUFreq driver's frequency throttle stats directory and
>  		throttle attributes exported in the 'throttle_stats' directory:
> 
>  		- turbo_stat : This file gives the total number of times the max
> -		frequency is throttled to lower frequency in turbo (at and above
> -		nominal frequency) range of frequencies.
> +		  frequency is throttled to lower frequency in turbo (at and above
> +		  nominal frequency) range of frequencies.
> 
>  		- sub_turbo_stat : This file gives the total number of times the
> -		max frequency is throttled to lower frequency in sub-turbo(below
> -		nominal frequency) range of frequencies.
> +		  max frequency is throttled to lower frequency in sub-turbo(below
> +		  nominal frequency) range of frequencies.
> 
>  		- unthrottle : This file gives the total number of times the max
> -		frequency is unthrottled after being throttled.
> +		  frequency is unthrottled after being throttled.
> 
>  		- powercap : This file gives the total number of times the max
> -		frequency is throttled due to 'Power Capping'.
> +		  frequency is throttled due to 'Power Capping'.
> 
>  		- overtemp : This file gives the total number of times the max
> -		frequency is throttled due to 'CPU Over Temperature'.
> +		  frequency is throttled due to 'CPU Over Temperature'.
> 
>  		- supply_fault : This file gives the total number of times the
> -		max frequency is throttled due to 'Power Supply Failure'.
> +		  max frequency is throttled due to 'Power Supply Failure'.
> 
>  		- overcurrent : This file gives the total number of times the
> -		max frequency is throttled due to 'Overcurrent'.
> +		  max frequency is throttled due to 'Overcurrent'.
> 
>  		- occ_reset : This file gives the total number of times the max
> -		frequency is throttled due to 'OCC Reset'.
> +		  frequency is throttled due to 'OCC Reset'.
> 
>  		The sysfs attributes representing different throttle reasons like
>  		powercap, overtemp, supply_fault, overcurrent and occ_reset map to


This hunk for the powernv cpufreq driver looks good to me.
For these two hunks,

Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>


