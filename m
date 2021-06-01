Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DA3396C19
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhFAEX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFAEX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 506E961263;
        Tue,  1 Jun 2021 04:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622521306;
        bh=nb8/767fE3N+SWGFQVvNWNF7q7EncmjPK2C39GKZ+3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NftkSjNca7kif7hWbCDBM3vDXg0mm5xW+lzpGIEs6zNB+9Y2fmGjD4DD05GD/Nbe3
         dslTTtN53EUNeaIdZvhP71fsjQAPucExsjQpYxyGf5D5l/j1aAUHbAoxbWYXFVkRxa
         4Y1o+fWxGhdiPdLOjdEB90nQZw0L343l25kgpgG1wiWcNEY4iT8/l/cs4WM1N37Bp1
         OlwtYeIggL06hJCT2jgpncrRC3fbJCX95qCINGQKPhDV8I1/J6LluBso7Y2k99BRHY
         mPHRede5sks8r30giReg4M/zi7N9kOTVSwzAm3a3Kq3pl7F5UX8b/XuEi1dCX56gJC
         YO2QTgsvskAAQ==
Date:   Mon, 31 May 2021 21:21:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
Message-ID: <20210531212145.359f1fed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <915310398.35293280.1622461417600.JavaMail.zimbra@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-3-justin.iurman@uliege.be>
        <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
        <20210530130212.327a0a0c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <915310398.35293280.1622461417600.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 13:43:37 +0200 (CEST) Justin Iurman wrote:
> > BTW the ASCII art in patch 1 looks like node data is filled in in order  
> 
> I agree, this one could be quite confusing without the related
> paragraph in the draft that explains it. Two possibilities here: (a)
> add the paragraph in the patch description to remove ambiguity; or
> (b) revert indexes in the ASCII art (from n to 0). Thoughts?

Inverting the indexes in the ASCII art would make it clear enough 
for me.

> > but:
> > 
> > +	data = trace->data + trace->remlen * 4 - trace->nodelen *
> > 4 - sclen * 4;
> > 
> > Looks like we'd start from the last node data?  
> 
> Correct, it works as a stack from bottom (end of the pre-allocated
> space) to top (start of the pre-allocated space).

