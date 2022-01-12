Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7F548C94C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350027AbiALRZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348497AbiALRZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:25:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905F0C06173F;
        Wed, 12 Jan 2022 09:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B5F616C7;
        Wed, 12 Jan 2022 17:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32F2C36AE5;
        Wed, 12 Jan 2022 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642008348;
        bh=Xb9eSbJ+w0lYWuqYLvqMJ18zAt6d91dVqHMXgt+dJUw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H0Q1MnNUopwB3OzDNrbTHHfbjkJuca28UtYDhxtXNflpEXkZu5x7qwZATtzIthryc
         avlzTbzftwnNC/G87TW1gFwili85n/JQYU6YwRsyRd6qSEarW83aTGDszoR1OLLeYl
         Vkcw8B05pUzp9zIdrMj0LmBk5kJ8wkzVHJPeIEnhZQbEPCISRKn71arS+L7uESurZg
         ThDM6y6+7142XJ73Hj4RWK3iDVWU2rPdWrFzWHQyjW883g+0T/fSUpxkyg3GOavEgu
         w38UKVmNV/5ZqqEev1RPMuENdYm2qk9AFN+fHs6dDLtdxaP7R493LgO6KDAdgKgVih
         7xFvpZHk3Am/g==
Date:   Wed, 12 Jan 2022 09:25:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Jordy Zomer <jordy@pwning.systems>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] nfc: st21nfca: Fix potential buffer overflows in
 EVT_TRANSACTION
Message-ID: <20220112092546.300c9b56@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <b47eba60-9d02-2901-2759-b2230087193c@canonical.com>
References: <20211117171706.2731410-1-jordy@pwning.systems>
        <20220111164451.3232987-1-jordy@pwning.systems>
        <b47eba60-9d02-2901-2759-b2230087193c@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 11:07:34 +0100 Krzysztof Kozlowski wrote:
> On 11/01/2022 17:44, Jordy Zomer wrote:
> > It appears that there are some buffer overflows in EVT_TRANSACTION.
> > This happens because the length parameters that are passed to memcpy
> > come directly from skb->data and are not guarded in any way.
> > 
> > Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> 
> Looks ok.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Thanks! I believe this is commit 4fbcc1a4cb20 ("nfc: st21nfca: Fix
potential buffer overflows in EVT_TRANSACTION") in net.
