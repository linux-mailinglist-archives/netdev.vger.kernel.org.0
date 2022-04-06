Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E25D4F630B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbiDFPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiDFPMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:12:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023FB425E22;
        Wed,  6 Apr 2022 05:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA2F8B822B4;
        Wed,  6 Apr 2022 12:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9DCC385A1;
        Wed,  6 Apr 2022 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247128;
        bh=2LXuV2u6lOLRBe8QZ3x4ZpZ7WwX1scejq0bAc+nswto=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qKEEJeyd4F53ztiMWPerjHQBobIXpFH3ochkjmigcZav3g1ySfLgELE1Zd/hU9kS/
         NFYSm8OO1BFUkpHvcr9CmNoYx1U6ImxdSXJfD41jcICniGvLkBLIDPpJsf/Md5XDUR
         kWhObUXMLVb0twnCx/SZEz6QkHEy6xfbeeNxfLNnM9lvZ0iqLUrWEgtS2Z9kEmCQPR
         QWtdZ7SoYeA3lNZtKEvtoccwIeW2l3apHcgIddUu3rKEB+rLaPZATnwYVsscWwRII1
         AHitI4XLeUXR98Qg2jZgsxO5dzY36TKUktmQ3FILdEx+udWc3EyZAPCsgAfjjm5nXx
         u+4sdcoPHL7qQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: replace usage of found with dedicated list
 iterator
 variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220324072124.62458-1-jakobkoschel@gmail.com>
References: <20220324072124.62458-1-jakobkoschel@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924712364.19026.13730544282775946007.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:12:05 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakob Koschel <jakobkoschel@gmail.com> wrote:

> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

a0ff2a87194a rtlwifi: replace usage of found with dedicated list iterator variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220324072124.62458-1-jakobkoschel@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

