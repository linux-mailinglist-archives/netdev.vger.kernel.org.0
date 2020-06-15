Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5429E1F9F23
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 20:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbgFOSJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 14:09:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFOSJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 14:09:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05FI7hca026496;
        Mon, 15 Jun 2020 18:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EdV85x/l0ZQB7qs/RGol05XelTO/TGwy+i5Nwcf8gRM=;
 b=ksIm2T40o14OrDnPOVl41oLfXflESyB3DKHmSrY07W8hiE/Z7QLC5o1aUTaHPRbSwzbu
 9c0NwLH9cAIIrEop8mGTFh8G1XGbz9PddITo/iGjFqouwLRZRmyMPkuv312Tprpn0qqE
 vsgCBz56dXPpSbVxKCQXClzuApbPztWVszZo40Z9/pDvMf5EwgQrvvf51uoX9UnrZp3o
 w/4xkBk0XXZDlc2YcrCzTOExgRGYIv3Y4giKzpy8SzyD0DJs8FkiFKoy2usbln1dH7C7
 /e2gagyqK7O847BIeVNSzHbKNPgl/68telPWwh1LacJqZVCnTiRrQlKn7a2GbDXIJ48j 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31p6s22cke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Jun 2020 18:08:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05FHwvkZ051587;
        Mon, 15 Jun 2020 18:08:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31p6de1e1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 18:08:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05FI8G7g031730;
        Mon, 15 Jun 2020 18:08:17 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 11:08:15 -0700
Date:   Mon, 15 Jun 2020 21:07:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        samba-technical@lists.samba.org,
        virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, target-devel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, x86@kernel.org,
        kasan-dev@googlegroups.com, cocci@systeme.lip6.fr,
        linux-wpan@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, wireguard@lists.zx2c4.com,
        linux-ppp@vger.kernel.org, linux-integrity@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-ID: <20200615180753.GJ4151@kadam>
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413211550.8307-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413211550.8307-2-longman@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=930 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=944 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=2 spamscore=0 cotscore=-2147483648 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 05:15:49PM -0400, Waiman Long wrote:
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 23c7500eea7d..c08bc7eb20bd 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1707,17 +1707,17 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
>  EXPORT_SYMBOL(krealloc);
>  
>  /**
> - * kzfree - like kfree but zero memory
> + * kfree_sensitive - Clear sensitive information in memory before freeing
>   * @p: object to free memory of
>   *
>   * The memory of the object @p points to is zeroed before freed.
> - * If @p is %NULL, kzfree() does nothing.
> + * If @p is %NULL, kfree_sensitive() does nothing.
>   *
>   * Note: this function zeroes the whole allocated buffer which can be a good
>   * deal bigger than the requested buffer size passed to kmalloc(). So be
>   * careful when using this function in performance sensitive code.
>   */
> -void kzfree(const void *p)
> +void kfree_sensitive(const void *p)
>  {
>  	size_t ks;
>  	void *mem = (void *)p;
> @@ -1725,10 +1725,10 @@ void kzfree(const void *p)
>  	if (unlikely(ZERO_OR_NULL_PTR(mem)))
>  		return;
>  	ks = ksize(mem);
> -	memset(mem, 0, ks);
> +	memzero_explicit(mem, ks);
        ^^^^^^^^^^^^^^^^^^^^^^^^^
This is an unrelated bug fix.  It really needs to be pulled into a
separate patch by itself and back ported to stable kernels.

>  	kfree(mem);
>  }
> -EXPORT_SYMBOL(kzfree);
> +EXPORT_SYMBOL(kfree_sensitive);
>  
>  /**
>   * ksize - get the actual amount of memory allocated for a given object

regards,
dan carpenter
