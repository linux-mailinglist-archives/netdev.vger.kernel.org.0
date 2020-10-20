Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49EA294410
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgJTUnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 16:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731396AbgJTUnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 16:43:47 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DBCC0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 13:43:46 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CG5FB2Jx8zKmTv;
        Tue, 20 Oct 2020 22:43:42 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603226620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=RcqNMgd9Itw3R6yfOF3QViLfcwzloohzhwU704QYrU4=;
        b=DMGKT3/7R2ejO1QiPyQw/J4x5MTsZgnWULUfMA7zZeiGoTS4vl1cK9PF/E/qwYH23aF5Uj
        O6i7gqQHxMavo5kdnTXYcY2BDRMEsfDCdmAGG9bCqhtNbwcmlnEJjLGWMAdbudid0as5SL
        HH21tmPKC+gHtlBavKqUlP2GdcsmMQB5awh5QpvpYfw1zSw9KL9F6YTzCKr6vsr/DO9lGq
        qsmsbxJH4BagG3gzYc1cNdLkzbiYt6QcxK2XP554C/K67EFe92+nL5NwPGQrs3UUq9A7XL
        wPlj3Ij1FDE8ecfKnzjV64HjmsMS0E+r/k07PtSq/uUjLn40ThOwfqkwjjIBlA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id PqfEXmbi6-nc; Tue, 20 Oct 2020 22:43:39 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 15/15] dcb: Add a subtool for the DCB ETS object
In-reply-to: <20201020114141.53391942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 20 Oct 2020 22:43:37 +0200
Message-ID: <877drkk4qu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.40 / 15.00 / 15.00
X-Rspamd-Queue-Id: 28B0A15
X-Rspamd-UID: d09c2a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 20 Oct 2020 02:58:23 +0200 Petr Machata wrote:
>> +static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets *ets)
>> +{
>> +	print_string(PRINT_ANY, "cbs", "cbs %s ", ets->cbs ? "on" : "off");
>> +}
>
> I'd personally lean in the direction ethtool is taking and try to limit
> string values in json output as much as possible. This would be a good
> fit for bool.

Yep, makes sense. The value is not user-toggleable, so the on / off
there is just arbitrary.

I'll consider it for "willing" as well. That one is user-toggleable, and
the "on" / "off" makes sense for consistency with the command line. But
that doesn't mean it can't be a boolean in JSON.
