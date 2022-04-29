Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3155153FB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380130AbiD2SvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380011AbiD2SvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3B3B53D5;
        Fri, 29 Apr 2022 11:48:00 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TIhYbi008240;
        Fri, 29 Apr 2022 18:46:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=CmQcpniDwe+mXgnPI+CYX47gDa+lF4VP2K5Tb10PSgo=;
 b=bTNrOnkDXh09pnCHUKCfVTj5O7a2rMkLSO1DAFMikxnzlOk842BnVGNnlxjbavr8wxSm
 aOP4oPacZVwhk2+nACPTWiDhwPxyd0jlejF5h74fWWI1oIVsbhF16gpgLRcULgtREdDE
 ZVJN5BEU2k3dT7ownrQWfbB7t+hMkUYaYJeBX/g91k8XSQa3Vre/7LGhk8wcXzDf1kiv
 oQ2iUNVOdBVbKDS9SyEcnVmbm4ZhnqmtglnqQQ9AIucI/CNGWOo+s+8TbDE7Hi7pEpcO
 DHP4bZPnfDn7+LocgB0sqZLpX0rqcpBhSBx8Sg3u1bbgRievtyCZGncSkoY2WOU7WhmC jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3frnhvg21h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:46:47 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23TIjCZm012916;
        Fri, 29 Apr 2022 18:46:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3frnhvg20t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:46:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TIcqwO026358;
        Fri, 29 Apr 2022 18:46:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fpuygbgfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:46:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TIkenH33554928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 18:46:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 153A4A4057;
        Fri, 29 Apr 2022 18:46:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA594A4053;
        Fri, 29 Apr 2022 18:46:37 +0000 (GMT)
Received: from osiris (unknown [9.145.187.229])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 29 Apr 2022 18:46:37 +0000 (GMT)
Date:   Fri, 29 Apr 2022 20:46:36 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 13/30] s390/consoles: Improve panic notifiers reliability
Message-ID: <YmwyjMtT7QTZiHaa@osiris>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-14-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-14-gpiccoli@igalia.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ot_aQO11mG-F1A04tqv6Sk5P4k7ltRIu
X-Proofpoint-ORIG-GUID: vOdOmdbQUdbprpYu7qwc87i31NSF1LbM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_09,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=368 impostorscore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 07:49:07PM -0300, Guilherme G. Piccoli wrote:
> Currently many console drivers for s390 rely on panic/reboot notifiers
> to invoke callbacks on these events. The panic() function disables local
> IRQs, secondary CPUs and preemption, so callbacks invoked on panic are
> effectively running in atomic context.
> 
> Happens that most of these console callbacks from s390 doesn't take the
> proper care with regards to atomic context, like taking spinlocks that
> might be taken in other function/CPU and hence will cause a lockup
> situation.
> 
> The goal for this patch is to improve the notifiers reliability, acting
> on 4 console drivers, as detailed below:
> 
> (1) con3215: changed a regular spinlock to the trylock alternative.
> 
> (2) con3270: also changed a regular spinlock to its trylock counterpart,
> but here we also have another problem: raw3270_activate_view() takes a
> different spinlock. So, we worked a helper to validate if this other lock
> is safe to acquire, and if so, raw3270_activate_view() should be safe.
> 
> Notice though that there is a functional change here: it's now possible
> to continue the notifier code [reaching con3270_wait_write() and
> con3270_rebuild_update()] without executing raw3270_activate_view().
> 
> (3) sclp: a global lock is used heavily in the functions called from
> the notifier, so we added a check here - if the lock is taken already,
> we just bail-out, preventing the lockup.
> 
> (4) sclp_vt220: same as (3), a lock validation was added to prevent the
> potential lockup problem.
> 
> Besides (1)-(4), we also removed useless void functions, adding the
> code called from the notifier inside its own body, and changed the
> priority of such notifiers to execute late, since they are "heavyweight"
> for the panic environment, so we aim to reduce risks here.
> Changed return values to NOTIFY_DONE as well, the standard one.
> 
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
> 
> As a design choice, the option used here to verify a given spinlock is taken
> was the function "spin_is_locked()" - but we noticed that it is not often used.
> An alternative would to take the lock with a spin_trylock() and if it succeeds,
> just release the spinlock and continue the code. But that seemed weird...
> 
> Also, we'd like to ask a good validation of case (2) potential functionality
> change from the s390 console experts - far from expert here, and in our naive
> code observation, that seems fine, but that analysis might be missing some
> corner case.
> 
> Thanks in advance!
> 
>  drivers/s390/char/con3215.c    | 36 +++++++++++++++--------------
>  drivers/s390/char/con3270.c    | 34 +++++++++++++++------------
>  drivers/s390/char/raw3270.c    | 18 +++++++++++++++
>  drivers/s390/char/raw3270.h    |  1 +
>  drivers/s390/char/sclp_con.c   | 28 +++++++++++++----------
>  drivers/s390/char/sclp_vt220.c | 42 +++++++++++++++++++---------------
>  6 files changed, 96 insertions(+), 63 deletions(-)

Code looks good, and everything still seems to work. I applied this
internally for the time being, and if it passes testing, I'll schedule
it for the next merge window.

Thanks!
