Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC06D29724D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465826AbgJWP3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S465813AbgJWP3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 11:29:23 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 801ED21D47;
        Fri, 23 Oct 2020 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603466962;
        bh=S5Kn3O68f3PPLfkqkvktfe3VeUC3zGbtEVTjNDfQ1dI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k2SO/YRozuovEuKIf8sn6zUN/XwdtHaF9gL3hkJKPAE6Cs643zu+niAbpUS4R4MtE
         ECSBECy/GVl/FeWRYrh2+Ce0w0QPLyOF+eEzKzhkkpFk24bKCBubpTQ56pPrt2l1gy
         7So0ful2VpPJKGQZVYEeMaKyIsl2cYqkIWzORdN4=
Date:   Fri, 23 Oct 2020 08:29:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Kees Cook <keescook@chromium.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC][PATCH v3 3/3] Rename nla_strlcpy to nla_strscpy.
Message-ID: <20201023082920.6addf3cb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <b55d502089c44b3589973fa4e0d90617@AcuMS.aculab.com>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
        <20201020164707.30402-4-laniel_francis@privacyrequired.com>
        <202010211649.ABD53841B@keescook>
        <2286512.66XcFyAlgq@machine>
        <202010221302.5BA047AC9@keescook>
        <20201022160551.33d85912@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <b55d502089c44b3589973fa4e0d90617@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 08:07:44 +0000 David Laight wrote:
> FWIW I suspect  the 'return -ERR on overflow' is going to bite us.
> Code that does p += strsxxx(p, ..., lim - p, ...) assuming (or not
> caring) about overflow goes badly wrong.

I don't really care either way, but in netlink there's usually an
attribute per value, nothing combines strings like p += strx..().
Looking at the conversion in patch 2 the callers just want to 
check for overflow.
