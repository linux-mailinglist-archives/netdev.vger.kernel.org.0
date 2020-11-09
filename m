Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0883B2AC829
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgKIWRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgKIWRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:17:00 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16EB9206BE;
        Mon,  9 Nov 2020 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604960219;
        bh=ROrsqtYaKXfk3QoJVLVQQdpZkH8gX3j3DtkJ5PIVV2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KcFPTBvE4LyxKT+LnRnmg0jcIbffymp9YQmfgjOZC3m/0SUcWvVAARlRURhXfNw95
         49109i5GvRP7Lv9n68YxB7xWfcNHmLrXBtZfhIAA42MdvEPDOc20fSwIAotRs4Fcm/
         NmoQtEjS0fTNI44pXBpCdjMqrckZryZ5g2P839MM=
Date:   Mon, 9 Nov 2020 14:16:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Georg Kohmann (geokohma)" <geokohma@cisco.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net v3] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201109141658.0265373d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <3c81d2ae-ba14-60d8-247d-87fabf407fea@cisco.com>
References: <20201109115249.14491-1-geokohma@cisco.com>
        <20201109125009.5e54ec8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3c81d2ae-ba14-60d8-247d-87fabf407fea@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 22:08:47 +0000 Georg Kohmann (geokohma) wrote:
> >> +bool ipv6_frag_validate(struct sk_buff *skb, int start, u8 *nexthdrp)  
> > (a) why place this function in exthdrs_core? I don't see any header
> >     specific code here, IMO it belongs in reassembly.c.  
> 
> ipv6_frag_validate() is used in both reassembly.c and nf_conntrack_reasm.c
> Where should I put the prototype so it can be used both places?

The prototype can stay in net/ipv6.h
