Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F16EB8A2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbfJaU75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:59:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:52970 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfJaU75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:59:57 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQHXu-0002uN-Fj; Thu, 31 Oct 2019 21:59:54 +0100
Date:   Thu, 31 Oct 2019 21:59:53 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, jakub.kicinski@netronome.com, toke@redhat.com
Subject: Re: [PATCH bpf] bpf: change size to u64 for
 bpf_map_{area_alloc,charge_init}()
Message-ID: <20191031205953.GB24528@pc-63.home>
References: <20191029154307.23053-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029154307.23053-1-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25619/Thu Oct 31 09:55:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 04:43:07PM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The functions bpf_map_area_alloc() and bpf_map_charge_init() prior
> this commit passed the size parameter as size_t. In this commit this
> is changed to u64.
> 
> All users of these functions avoid size_t overflows on 32-bit systems,
> by explicitly using u64 when calculating the allocation size and
> memory charge cost. However, since the result was narrowed by the
> size_t when passing size and cost to the functions, the overflow
> handling was in vain.
> 
> Instead of changing all call sites to size_t and handle overflow at
> the call site, the parameter is changed to u64 and checked in the
> functions above.
> 
> Fixes: d407bd25a204 ("bpf: don't trigger OOM killer under pressure with map alloc")
> Fixes: c85d69135a91 ("bpf: move memory size checks to bpf_map_charge_init()")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Applied, thanks!
