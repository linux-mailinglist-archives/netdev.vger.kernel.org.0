Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC10B6AEFE
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388442AbfGPSo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:44:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728366AbfGPSo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:44:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIfcrQ098988;
        Tue, 16 Jul 2019 14:43:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tsj824pyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:43:34 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GIfguM099589;
        Tue, 16 Jul 2019 14:43:34 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tsj824pxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:43:34 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6GIdjUq031073;
        Tue, 16 Jul 2019 18:43:33 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 2tq6x79948-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 18:43:33 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GIhWqR45875528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:43:32 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06C7DB2067;
        Tue, 16 Jul 2019 18:43:32 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8068B2065;
        Tue, 16 Jul 2019 18:43:31 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:43:31 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id C9CDC16C8E9B; Tue, 16 Jul 2019 11:43:31 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:43:31 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 8/9] acpi: Use built-in RCU list checking for
 acpi_ioremaps list (v1)
Message-ID: <20190716184331.GJ14271@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-9-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-9-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160229
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 10:37:04AM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it for acpi_ioremaps list traversal.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Given that Rafael acked it, this one looks ready.

							Thanx, Paul

> ---
>  drivers/acpi/osl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9c0edf2fc0dd..2f9d0d20b836 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> +#include <linux/lockdep.h>
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
>  #include <linux/kmod.h>
> @@ -80,6 +81,7 @@ struct acpi_ioremap {
>  
>  static LIST_HEAD(acpi_ioremaps);
>  static DEFINE_MUTEX(acpi_ioremap_lock);
> +#define acpi_ioremap_lock_held() lock_is_held(&acpi_ioremap_lock.dep_map)
>  
>  static void __init acpi_request_region (struct acpi_generic_address *gas,
>  	unsigned int length, char *desc)
> @@ -206,7 +208,7 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
>  {
>  	struct acpi_ioremap *map;
>  
> -	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
> +	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
>  		if (map->phys <= phys &&
>  		    phys + size <= map->phys + map->size)
>  			return map;
> @@ -249,7 +251,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
>  {
>  	struct acpi_ioremap *map;
>  
> -	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
> +	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
>  		if (map->virt <= virt &&
>  		    virt + size <= map->virt + map->size)
>  			return map;
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
