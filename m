Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2149972DE9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfGXLn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:43:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43996 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfGXLn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:43:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ED3A36043F; Wed, 24 Jul 2019 11:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968607;
        bh=byFzy6X7pbJq+TN7J3RSRYSWZPSaIMEFe5+Gacdf8+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jMbf6RhSVdlKS5cdyy1s9CEHQLtp3BnhmMZ0/4niIoSR0WbvOKaciXFZGi2YtI+v/
         HQQzQrLNe/S0at8eg9V4LGOyr0Bh9XmWD3lGA0O/nGUWE89JJ2B66GzrBUKf4vThDg
         FboysX+zxHu9ytLSwzEb/FvjW5aOKYWLmHQYsbr4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D725C6021C;
        Wed, 24 Jul 2019 11:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968606;
        bh=byFzy6X7pbJq+TN7J3RSRYSWZPSaIMEFe5+Gacdf8+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LNAY3xDmVfM3fN9HTzMB6M09awe6/uE/AYEm4IHvwcM8jIkgldz6wnR5HnAjGlQAj
         cP4UqAAOovPXH/fkY3eZPt4mNFRe+z5tDSs2y5+LqfqU1nRttobjm0wOb44sl/MHPX
         qN3GxJX7jSDVpwFLOQeyFJv66ULdmgdWZy9MmsNM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D725C6021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rt2x00: no need to check return value of
 debugfs_create functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190703113956.GA26652@kroah.com>
References: <20190703113956.GA26652@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114326.ED3A36043F@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:43:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Because we don't need to save the individual debugfs files and
> directories, remove the local storage of them and just remove the entire
> debugfs directory in a single call, making things a lot simpler.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

1dc244064c47 rt2x00: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/11029367/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

