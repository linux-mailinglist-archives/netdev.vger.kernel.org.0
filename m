Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3566AEC8
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbfGPSjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:39:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730499AbfGPSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:39:16 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIbTrJ016453
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:39:14 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsh3m82r9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:39:14 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 16 Jul 2019 19:39:13 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 19:39:03 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GId2Kc37224762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:39:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61D9CB2068;
        Tue, 16 Jul 2019 18:39:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20A15B205F;
        Tue, 16 Jul 2019 18:39:02 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:39:01 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 1337116C9988; Tue, 16 Jul 2019 11:39:02 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:39:02 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
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
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 3/9] rcu/sync: Remove custom check for reader-section (v2)
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-4-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071618-0060-0000-0000-0000035F2659
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011440; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233107; UDB=6.00649718; IPR=6.01014419;
 MB=3.00027748; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-16 18:39:11
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071618-0061-0000-0000-00004A2A2193
Message-Id: <20190716183902.GE14271@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160228
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 10:36:59AM -0400, Joel Fernandes (Google) wrote:
> The rcu/sync code was doing its own check whether we are in a reader
> section. With RCU consolidating flavors and the generic helper added in
> this series, this is no longer need. We can just use the generic helper
> and it results in a nice cleanup.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

This one looks good!

							Thanx, Paul

> ---
>  include/linux/rcu_sync.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> index 9b83865d24f9..0027d4c8087c 100644
> --- a/include/linux/rcu_sync.h
> +++ b/include/linux/rcu_sync.h
> @@ -31,9 +31,7 @@ struct rcu_sync {
>   */
>  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
>  {
> -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> -			 !rcu_read_lock_bh_held() &&
> -			 !rcu_read_lock_sched_held(),
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
>  			 "suspicious rcu_sync_is_idle() usage");
>  	return !READ_ONCE(rsp->gp_state); /* GP_IDLE */
>  }
> -- 
> 2.22.0.510.g264f2c817a-goog
> 

