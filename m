Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7758311BD6D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfLKTrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:47:20 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60587 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfLKTrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:47:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3791B220FF;
        Wed, 11 Dec 2019 14:47:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 11 Dec 2019 14:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AA6JNm
        PLFiwugb2/Q/Tds6Me1AQ4yG0OAPhoGdszRdU=; b=DICqxrmhZ0GJRy50488zpT
        m3XrIkPTy4IPTQRcpoSE1lChda1v/Xmz0lOFtBFI4rguvw/P9TuSkTKEvbsqQGDQ
        ulNoSnmKZld+LcWebqWmZPZ8II3lTTvxcHIMPcSQKgmpYrgCIuVAooejOJn1cgLw
        QfYJHx2Qi2YEwrtTi65yVq247xI5uGBI0ve10SVeHRSSo/wj8M5F0+kBh5ES1zEN
        c7wI2rfQ3ctQg7+cT+44QJ4d8waXhOKT5po3EqQ0GT/uDjkSQu1fweaNYdJKdjbP
        EPFPnim6btOY2S3ENP1c7a4Jpq3tvJCHmZYQk2IXhszXzSogrmp1OTJCWysL90Yg
        ==
X-ME-Sender: <xms:xkfxXXHYe4j7CnzYfsJOIiUJn7aWR-jCdMfghplzTL64uRd9afMxiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    ejrddufeekrddvgeelrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xkfxXbXVTA4fp0hNbNsKmwkL59ckFFUt1bGBDWTrBr0XRYnnMiuC1A>
    <xmx:xkfxXVfZ_zRH9n1CdVTM0_lkIhRvnObMz3Ea1duzs5br7ZfiT5B_eQ>
    <xmx:xkfxXb9K5RovUFjVKlSEVLJL1Me5fTCD6gqY9k3rt39Saqoove4yVQ>
    <xmx:x0fxXRXbUwHRWriaKijoBFjbzfkgNfmCpq-hIXfOFTj8O8A1y_VPJA>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2581780064;
        Wed, 11 Dec 2019 14:47:17 -0500 (EST)
Date:   Wed, 11 Dec 2019 21:47:05 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/9] ipv4: Notify route if replacing currently
 offloaded one
Message-ID: <20191211194705.GA486739@splinter>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-4-idosch@idosch.org>
 <112373c1-cdb6-86bf-33ac-f555b93db735@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112373c1-cdb6-86bf-33ac-f555b93db735@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 10:40:09AM -0700, David Ahern wrote:
> On 12/10/19 10:23 AM, Ido Schimmel wrote:
> > +/* Return the first fib alias matching prefix length and table ID. */
> > +static struct fib_alias *fib_find_first_alias(struct hlist_head *fah, u8 slen,
> > +					      u32 tb_id)
> > +{
> > +	struct fib_alias *fa;
> > +
> > +	hlist_for_each_entry(fa, fah, fa_list) {
> > +		if (fa->fa_slen < slen)
> > +			continue;
> > +		if (fa->fa_slen != slen)
> > +			break;
> > +		if (fa->tb_id > tb_id)
> > +			continue;
> > +		if (fa->tb_id != tb_id)
> > +			break;
> > +		return fa;
> 
> Rather than duplicating fib_find_alias, how about adding a 'bool
> find_first' argument and bail on it:
> 
> 		if (find_first)
> 			return fa;
> 
> 		continue to tos and priority compares.

Sure, I'll change this tomorrow morning.

Thanks, David!

> 
> > +	}
> > +
> > +	return NULL;
> > +}
