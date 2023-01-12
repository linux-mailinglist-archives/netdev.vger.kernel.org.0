Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D697666ADC
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbjALFbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbjALFbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:31:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAE21B9F9;
        Wed, 11 Jan 2023 21:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DFBB81DBE;
        Thu, 12 Jan 2023 05:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84DEC433D2;
        Thu, 12 Jan 2023 05:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673501504;
        bh=k6K4XfraXrxIB9XWz/v1a+l1ie9WasxsA+o7stisLAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uzE8iQ4SeEZAe3EAL0HfEtS8gbqKAxACJQZidwntvEd1mddf6vPsHvwUD18Bd0fUo
         2RnbPZJN/JWzT7UvuXBIKPuGskpAouaDHbZXHWOC5vI3NGDgQTTnSv1zXYNB5+NsYy
         qEQ7YaxLBxm12xkQJi3WPjyYh8Kj9ceap4m1Er94PUVA3fT7fWvaFZUfGnTvo0f46+
         LusmFlqnrNEXQ8wIqsUieSRl0N2Rx3H8kvppjyZPqUZbe/Gwe8K28CjUzqp9D1EMUD
         RCFp8GnnRw6oTCS6iXv+x7foAyfBSKCKpqjNwvA6Dr3O+md/yMYZjWeHx2RjcGwtod
         IDnIl7PadwrZw==
Date:   Wed, 11 Jan 2023 21:31:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
Message-ID: <20230111213143.71f2ad7e@kernel.org>
In-Reply-To: <20230111133228.190801-1-andre.przywara@arm.com>
References: <20230111133228.190801-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 13:32:28 +0000 Andre Przywara wrote:
> The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
> Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
> machines, Microsoft uses a custom USB device ID.
> 
> Add the respective ID values to the driver. This makes Ethernet work on
> the MS Devkit device. The chip has been visually confirmed to be a
> RTL8153.

Hm, we have a patch in net-next which reformats the entries:
ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b

Would you like this ID to be also added in stable? We could just 
apply it to net, and deal with the conflict locally. But if you 
don't care about older kernels then better if you rebase.
