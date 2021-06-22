Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73593B0F70
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFVVfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFVVfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 17:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D80861352;
        Tue, 22 Jun 2021 21:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624397569;
        bh=al41K9fwXEZSaEnsn5+ajXGj3kMQhiUzCAbysqboRMQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=buH34uIEGQrklCKaIua+D8+DLgzg6xnuUQbY4h1jd9fXGN4HsnfpDxxCaFUzjOYIA
         bxoROawc3+/yvS98ReHZWxYJxH2Bu0ZOS5l1Gu/bi2jEABP9APfLtRtdopCNA9Gqvq
         5y0ET1FLmeIT/5J29+4dHV5pPSNhURuXjzdF548Eg+R/7fD9+nBHX7KMVlHz3nl9et
         S+1uu9ITxfUIosOmV3NlacFF97ASwqeroXyYowmV23tolRM3xrNa8GclzTjWwCwjpj
         y87+Qsft6IcU0mT7JWVCdsuNgtufAkXIc3KPnG7xSzez5QMMhEKEBNUR2+WEIAX76h
         8nm1IZ29Iniig==
Message-ID: <1076d165f30e09e9e1fdbd75d32bdb3170a2b37e.camel@kernel.org>
Subject: Re: [PATCH net-next] ethtool: strset: account for nesting in reply
 size
From:   Saeed Mahameed <saeed@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Tue, 22 Jun 2021 14:32:48 -0700
In-Reply-To: <20210618233720.js4sk2xtgvf4ssn2@lion.mk-sys.cz>
References: <20210618225502.170644-1-saeed@kernel.org>
         <20210618233720.js4sk2xtgvf4ssn2@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-06-19 at 01:37 +0200, Michal Kubecek wrote:
> On Fri, Jun 18, 2021 at 03:55:02PM -0700, Saeed Mahameed wrote:
> > From: Saeed Mahameed <saeedm@nvidia.com>
> > 
> > The cited patch revealed a bug in strset reply size where the
> > calculation didn't include the 1st nla_nest_start(), a size of 4
> > Bytes in
> > strset_fill_reply().
> > 
> > To fix the issue we account for the missing nla_nest 4Bytes by
> > reporting
> > them in strset_reply_size()
> > 
> > Before this patch issuing "ethtool -k" command will produce the
> > following call trace:
[...]
> 
> Out of the three fixes, personally I liked most the one which applied
> nla_total_len() to calculated length of the nest contents as it IMHO
> reflects the message structure best; but adding nla_total_size(0)
> also
> provides the same result so either does the trick.
> 
> Michal

will go with the net fix, thanks for taking a look !



