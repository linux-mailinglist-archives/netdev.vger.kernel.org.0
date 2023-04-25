Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937A56EE3CF
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbjDYOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbjDYOTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:19:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA1B1618B;
        Tue, 25 Apr 2023 07:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB4062567;
        Tue, 25 Apr 2023 14:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F4C433EF;
        Tue, 25 Apr 2023 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682432329;
        bh=616hylbH2Q9Uro5He0e9wVu5/l8+kS27AlpK0DGcQXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EHFRAIEtfLrj9npAkf+KM1KDdGmX1JnpktfLDMjegQsKOw+cW26l2DsgSf7VT4jmx
         JF6wPp/uk3CROP2EAoaYIPl5JDjP0LAQXX03qglLZhQWciA54eTXEKt3kap8Kcpqym
         5g78D02w09pIe+B1FcQKbNQ/+7NS0+uelLIqVGNWRGDYpWWxqN4Pw16PRUZIKMJpZ3
         M6aFTE+QDrSBTTVt1kc/B7ApH7t3w7njusbey19kmbMUe36dso3wD9g1QvExaXqqBl
         s6Bx9vUUQYZ1kYjRCqAdZRwF+ud4gfj1CtSOrPdQCCnAFBmApcQGxrpUN6eH5dXR49
         VFznn+CCYTlEA==
Date:   Tue, 25 Apr 2023 07:18:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-04-21
Message-ID: <20230425071848.6156c0a0@kernel.org>
In-Reply-To: <87leigr06u.fsf@kernel.org>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421075404.63c04bca@kernel.org>
        <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
        <87leigr06u.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 08:38:17 +0300 Kalle Valo wrote:
> IIRC we discussed this back in initial rtw88 or rtw89 driver review (not
> sure which one). At the time I pushed for the current solution to have
> the initvals in static variables just to avoid any backwards
> compatibility issues. I agree that the initvals in .c files are ugly but
> is it worth all the extra effort and complexity to move them outside the
> kernel? I'm starting to lean towards it's not worth all the extra work.

I don't think it's that much extra work, the driver requires FW
according to modinfo, anyway, so /lib/firmware is already required.
And on smaller systems with few hundred MB of RAM it'd be nice to not
hold all the stuff in kernel memory, I'd think.

We have a rule against putting FW as a static table in the driver
source, right? Or did we abandon that? Isn't this fundamentally similar?

> For me most important is that backwards compatibility is not broken,
> that would be bad for the users. So whatever we decide let's keep that
> in mind.

Right, not for existing devices, only when new device is added.
