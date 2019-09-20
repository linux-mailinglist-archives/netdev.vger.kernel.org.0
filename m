Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51D0B9918
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 23:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfITVee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 17:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730095AbfITVee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 17:34:34 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688A02080F;
        Fri, 20 Sep 2019 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569015274;
        bh=qSkVdMFviHv9GATIp3bGtPpX5gymfYN8MGrr/PyDBj4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=A7ED/31/xY/0osDez3scJGuUxWCLCXj1SoSE3quqJUkoQ9f3/Pec8JQ8tc5GSCJO5
         9AmjPvOE/eWbqk/I5fLgT6lmmJuKITefI0q+hMjPP+HCCNtQMXxBwrcjRUchMrJ18z
         uFJh9N+7gS8IUKjVxB1fS3QxK+A/pCMFe6SGWZPQ=
Date:   Fri, 20 Sep 2019 23:34:04 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5.1-rc] iwlwifi: make locking in iwl_mvm_tx_mpdu()
 BH-safe
In-Reply-To: <nycvar.YFH.7.76.1909111301510.473@cbobk.fhfr.pm>
Message-ID: <nycvar.YFH.7.76.1909202333450.1459@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1904151300160.9803@cbobk.fhfr.pm>  <24e05607b902e811d1142e3bd345af021fd3d077.camel@sipsolutions.net>  <nycvar.YFH.7.76.1904151328270.9803@cbobk.fhfr.pm> <01d55c5cf513554d9cbdee0b14f9360a8df859c8.camel@sipsolutions.net>
 <nycvar.YFH.7.76.1909111238470.473@cbobk.fhfr.pm> <nycvar.YFH.7.76.1909111301510.473@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Sep 2019, Jiri Kosina wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] iwlwifi: make locking in iwl_mvm_tx_mpdu() BH-safe
> 
> Hm, scratch that, that might actually spuriously enable BHs if called from 
> contexts that already did disabled BHs.
> 
> So what solution would you prefer here? Just stick another par of 
> bh_disable() / bh_enable() somewhere to the wake_txs() -> 
> iwl_mvm_mac_itxq_xmit() -> iwl_mvm_tx_skb() -> iwl_mvm_tx_mpdu() path?

Ping? This seems to be still the case.

Thanks,

-- 
Jiri Kosina
SUSE Labs

