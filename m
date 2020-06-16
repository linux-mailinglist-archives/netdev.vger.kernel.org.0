Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD801FAC00
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 11:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFPJMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 05:12:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPJMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 05:12:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G93Vcj108652;
        Tue, 16 Jun 2020 09:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vHFhOuRLkm8vQDg8Dof4S5HKAiKznh8tBQ+Mr1OID/Q=;
 b=cVx0KE5h1EIzH/Nv6xjfZ5nTWCPzlMev+meeNe8ig/R6zGb1hcI4zPyrerRBxYg+mmc+
 qKwemscmFpcbtZudgCHIJKFWU2+MEqUR3sjHNYzDUDCSWPx5pmD4LBuQpWhngStPV5H0
 4QQ1w6PiSDdHFWQ+ndzL39yxLvqknoA5VRhKUkk0TCj0AiX8q664S4ecxGUJH34dsTgv
 f9QhZLAjaVCh+OyWTAfnAqTx90cKQuDChSnHHM+F7Utt0PRApBfU8iMActdQhiOLrCqP
 +xx+YuMkqnBp9yLLOcyvwHAC7rCtpaJ69Rrf1s2Xt7AKk0laObtgJ3Pt4+o8dQUQESCt bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31p6e5wptp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 09:10:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G933ih037660;
        Tue, 16 Jun 2020 09:08:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31p6s6w4s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 09:08:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05G98O1L002227;
        Tue, 16 Jun 2020 09:08:25 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 02:08:24 -0700
Date:   Tue, 16 Jun 2020 12:08:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Waiman Long <longman@redhat.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-btrfs@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        David Sterba <dsterba@suse.cz>,
        David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, keyrings@vger.kernel.org,
        kasan-dev@googlegroups.com,
        linux-stm32@st-md-mailman.stormreply.com,
        devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
        linux-scsi@vger.kernel.org, James Morris <jmorris@namei.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-wpan@vger.kernel.org, David Rientjes <rientjes@google.com>,
        linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        virtualization@lists.linux-foundation.org,
        linux-integrity@vger.kernel.org, linux-nfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm/slab: Use memzero_explicit() in kzfree()
Message-ID: <20200616090807.GK4151@kadam>
References: <20200616015718.7812-1-longman@redhat.com>
 <20200616015718.7812-2-longman@redhat.com>
 <20200616064208.GA9499@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616064208.GA9499@dhcp22.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=781 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 mlxscore=0 phishscore=0 mlxlogscore=814 lowpriorityscore=0 clxscore=1011
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 08:42:08AM +0200, Michal Hocko wrote:
> On Mon 15-06-20 21:57:16, Waiman Long wrote:
> > The kzfree() function is normally used to clear some sensitive
> > information, like encryption keys, in the buffer before freeing it back
> > to the pool. Memset() is currently used for the buffer clearing. However,
> > it is entirely possible that the compiler may choose to optimize away the
> > memory clearing especially if LTO is being used. To make sure that this
> > optimization will not happen, memzero_explicit(), which is introduced
> > in v3.18, is now used in kzfree() to do the clearing.
> > 
> > Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Waiman Long <longman@redhat.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Although I am not really sure this is a stable material. Is there any
> known instance where the memset was optimized out from kzfree?

I told him to add the stable.  Otherwise it will just get reported to
me again.  It's a just safer to backport it before we forget.

regards,
dan carpenter

