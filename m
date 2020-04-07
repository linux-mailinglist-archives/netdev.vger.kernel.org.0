Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53411A0396
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgDGATL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:19:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726254AbgDGATI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 20:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586218747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O68wn4Pe4Xnq82stQk8cQ2xWIKc1fXmzXjPQY3YHR/c=;
        b=EiHn//9q69D2IDfCT/t72wctk4Cay0NoRMxSHVtCBmoJJjGO1fuXTvgYVmZCxiffWtQ+WK
        UhRsE3Miv2/HI75RLkY3qE+hYg/qL5Ys2bmpKS3wMDkgMv9+dEJ7x2Ds7vU/33g8mzKk9z
        2bnX1/flX6z8YIU5FN3Z4qCmaUrg0Rk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-6xhVm4c-OSycWycwXboclQ-1; Mon, 06 Apr 2020 20:19:02 -0400
X-MC-Unique: 6xhVm4c-OSycWycwXboclQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 451E618C35A1;
        Tue,  7 Apr 2020 00:19:01 +0000 (UTC)
Received: from localhost (unknown [10.36.110.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA3D85E010;
        Tue,  7 Apr 2020 00:18:58 +0000 (UTC)
Date:   Tue, 7 Apr 2020 02:18:48 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set
 back-ends to report partial overlaps on insertion
Message-ID: <20200407021848.626df832@redhat.com>
In-Reply-To: <20200407000058.16423-27-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
        <20200407000058.16423-27-sashal@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Mon,  6 Apr 2020 20:00:49 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 8c2d45b2b65ca1f215244be1c600236e83f9815f ]

This patch, together with 28/35 and 29/35 in this series, and all the
equivalent patches for 5.4 and 4.19, that is:
	[PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
	[PATCH AUTOSEL 5.5 28/35] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
	[PATCH AUTOSEL 5.5 29/35] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
	[PATCH AUTOSEL 5.4 24/32] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
	[PATCH AUTOSEL 5.4 25/32] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
	[PATCH AUTOSEL 5.4 26/32] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
	[PATCH AUTOSEL 4.19 08/13] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
	[PATCH AUTOSEL 4.19 09/13] netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
	[PATCH AUTOSEL 4.19 10/13] netfilter: nft_set_rbtree: Detect partial overlaps on insertion

should only be backported together with nf.git commit
	72239f2795fa ("netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion")

as they would otherwise introduce a regression. In general, those changes
are not really relevant before 5.6, as nft_set_pipapo wasn't there and the
main purpose here is to make the nft_set_rbtree back-end consistent with it:
they also prevent a malfunction in nft_set_rbtree itself, but nothing that
would be triggered using 'nft' alone, and no memory badnesses or critical
issues whatsoever. So it's also safe to drop them, in my opinion.

Also patches for 4.14 and 4.9:
	[PATCH AUTOSEL 4.14 6/9] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
	[PATCH AUTOSEL 4.9 3/5] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion

can safely be dropped, because there are no set back-ends there, without
the following patches, that use this way of reporting a partial overlap.

I'm used to not Cc: stable on networking patches (Dave's net.git),
but I guess I should instead if they go through nf.git (Pablo's tree),
right?

-- 
Stefano

