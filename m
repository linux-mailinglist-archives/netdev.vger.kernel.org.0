Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A1D360E7
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfFEQNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 12:13:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:52241 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfFEQNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 12:13:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 09:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,550,1549958400"; 
   d="scan'208";a="181987363"
Received: from unknown (HELO localhost) ([10.241.225.31])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2019 09:13:20 -0700
Date:   Wed, 5 Jun 2019 09:13:19 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        <netdev@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
Message-ID: <20190605091319.000054e9@intel.com>
In-Reply-To: <20190605142428.84784-3-wangkefeng.wang@huawei.com>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
        <20190605142428.84784-3-wangkefeng.wang@huawei.com>
X-Mailer: Claws Mail 3.14.0 (GTK+ 2.24.30; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 22:24:26 +0800 Kefeng wrote:
> IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag,
> so no need to do that again from its callers. Drop it.
> 

<snip>

>  	segs = __skb_gso_segment(skb, features, false);
> -	if (unlikely(IS_ERR_OR_NULL(segs))) {
> +	if (IS_ERR_OR_NULL(segs)) {
>  		int segs_nr = skb_shinfo(skb)->gso_segs;
>  

The change itself seems reasonable, but did you check to see if the
paths changed are faster/slower with your fix?  Did you look at any
assembly output to see if the compiler actually generated different
code?  Is there a set of similar changes somewhere else in the kernel
we can refer to?

I'm not sure in the end that the change is worth it, so would like you
to prove it is, unless davem overrides me. :-)

