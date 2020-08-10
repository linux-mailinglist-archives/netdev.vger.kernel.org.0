Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4F24119F
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHJUVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 16:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHJUVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 16:21:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F85620656;
        Mon, 10 Aug 2020 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597090861;
        bh=bK7hhnLgOAln2zyq3Jy0rJ9cnV5JlvAPE7gm22oNbXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pNdw7IFQbTTUZJQV4ykCEdAAkKkHiioh9zDxPhGU/bQX+u/EsGFOAi8c80fnKmCaF
         bKcnvmlQF90XQjKBRqxzDTjmiuj4lY20kpwUJYUfzIMqDTHiMznYwcIW5bDIf3AphS
         SS5YJrCKoFTFfOu2lEjGfAaF3TyVR33KK23TgKUM=
Date:   Mon, 10 Aug 2020 13:20:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nikolay@cumulusnetworks.com
Subject: Re: HSR/PRP LRE Stats - What is the right user space interface?
Message-ID: <20200810132059.4840ac5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0c743d6e-4a6d-5dcd-88c0-31c6d0971726@ti.com>
References: <0c743d6e-4a6d-5dcd-88c0-31c6d0971726@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Aug 2020 15:55:35 -0400 Murali Karicheri wrote:
> Hi Netdev experts,
> 
> IEC-62439 defines following LRE stats:-
> 
> 	"lreTxA",
> 	"lreTxB",
> 	"lreTxC",
> 	"lreErrWrongLanA",
> 	"lreErrWrongLanB",
> 	"lreErrWrongLanC",
> 	"lreRxA",
> 	"lreRxB",
> 	"lreRxC",
> 	"lreErrorsA",
> 	"lreErrorsB",
> 	"lreErrorsC",
> 	"lreNodes",
> 	"lreProxyNodes",
> 	"lreUniqueRxA",
> 	"lreUniqueRxB",
> 	"lreUniqueRxC",
> 	"lreDuplicateRxA",
> 	"lreDuplicateRxB",
> 	"lreDuplicateRxC",
> 	"lreMultiRxA",
> 	"lreMultiRxB",
> 	"lreMultiRxC",
> 	"lreOwnRxA",
> 	"lreOwnRxB",
> 
> These stats are defined also in the IEC-62439 MIB definition. So
> this MIB support is required in Net-SNMP and that requires a proper
> kernel interface to pull the values from the HSR or PRP
> LRE (Link Redundancy Entity). What is the right interface for this?
> Internally TI uses /proc interface for this. But want to check with
> community before sending a patch for this. One choice is ethtool for
> this. Or something else? Would appreciate if someone can clarify so
> that I can work towards a patch for the same.

Are these collected by HW, or also by the bridge code?

Adding a new IFLA_STATS_LINK_* may be the right choice.
