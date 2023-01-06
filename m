Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E92066002B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjAFMUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjAFMUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:20:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF8C736DA;
        Fri,  6 Jan 2023 04:20:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BE4CB249EA;
        Fri,  6 Jan 2023 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673007636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8QCVLYYjUvcUlvgswB1aZMBn/74NHSJlA341O/hqUaQ=;
        b=kdIc3vyodJBsRjBnoRoPW/005nFodyT/BRoyKPIEu+vznkdjaUrki6gsZNp+jDsnVe5KuG
        vony4h/XWFYOg6zJ0R/QZRkGUsHVcG6aJia4bvCZIA5dJABlOXny+s929mXfiyysx0H1dC
        djK7S2i+L9PT+GrSbU7ulyi8nQep39g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673007636;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8QCVLYYjUvcUlvgswB1aZMBn/74NHSJlA341O/hqUaQ=;
        b=c4e6WO3RFIc/Hvqk/AqGqSKXUqmH/0MfeTEuzObq7xe87k6ov5LsSxpniSW+UdZ2RzFOEo
        Q40+R1tCWjPtqOBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A05D213596;
        Fri,  6 Jan 2023 12:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HkIgJxQSuGMIPAAAMHmgww
        (envelope-from <iivanov@suse.de>); Fri, 06 Jan 2023 12:20:36 +0000
Date:   Fri, 6 Jan 2023 14:20:36 +0200
From:   "Ivan T. Ivanov" <iivanov@suse.de>
To:     Hector Martin <marcan@marcan.st>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, rmk+kernel@armlinux.org.uk,
        kvalo@kernel.org, davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH] brcmfmac: of: Use board compatible string for board type
Message-ID: <20230106122036.nrx4ssodwymhao7u@suse>
References: <20230106072746.29516-1-iivanov@suse.de>
 <fc6d3c3b-1352-4f75-cbef-d29bd74c0e40@marcan.st>
 <2711b084-5937-7e0f-26d8-67510da3939c@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2711b084-5937-7e0f-26d8-67510da3939c@marcan.st>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01-06 21:13, Hector Martin wrote:

> 
> On 2023/01/06 18:27, Hector Martin wrote:
> > On 2023/01/06 16:27, Ivan T. Ivanov wrote:
> >> When "brcm,board-type" is not explicitly set in devicetree
> >> fallback to board compatible string for board type.
> >>
> >> Some of the existing devices rely on the most compatible device
> >> string to find best firmware files, including Raspberry PI's[1].
> >>
> >> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
> >>
> >> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
> >>
> >> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
> > 
> > The existing code already falls back to the compatible string, *as long
> > as there is no board_type set already*.
> > 
> > As far as I can tell, the only way the board_type can get another value
> > first is if it comes from DMI. This behavior was inadvertently changed
> > by commit 7682de8b3351 (since I was not expecting platforms to have
> > *both* DT and DMI information).
> > 
> > I'm guessing the Raspberry Pi is one such platform, and
> > `/sys/devices/virtual/dmi` exists? Hybrid UEFI+ACPI+DT platform I take it?
> > 
> > If so, your commit description should probably be something like:
> > 
> > ===
> > brcmfmac: Prefer DT board type over DMI board type
> > 
> > The introduction of support for Apple board types inadvertently changed
> > the precedence order, causing hybrid ACPI+DT platforms to look up the
> > firmware using the DMI information instead of the device tree compatible
> > to generate the board type. Revert back to the old behavior,
> > as affected platforms use firmwares named after the DT compatible.
> > 
> > Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
> > ===
> > 
> > An also add a Cc: stable@vger.kernel.org to make sure this gets backported.
> > 
> > With the fixed description,
> > 
> > Reviewed-by: Hector Martin <marcan@marcan.st>
> > 
> > - Hector
> 
> Looking into this a bit more from what was mentioned in the linked bug,
> the DMI data comes from the SMBIOS table. We don't have that on Apple
> platforms even though we also boot via U-Boot+EFI, but I'm guessing you
> build U-Boot with CONFIG_GENERATE_SMBIOS_TABLE and provide that stuff in
> the DT?

Yes, that is the way in openSUSE case.

> So s/ACPI/SMBIOS/ would be more accurate in the commit message.

Sure, I will rewrite commit message and repost.

Thanks!

