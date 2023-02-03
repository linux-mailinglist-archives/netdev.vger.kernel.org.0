Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B7568947E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjBCJ6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBCJ6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:58:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0067A12859;
        Fri,  3 Feb 2023 01:58:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B40E4B82A28;
        Fri,  3 Feb 2023 09:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801DBC4339B;
        Fri,  3 Feb 2023 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675418288;
        bh=Ofw7oV9zxqty9gholG27cDWDW7iU77SQ0HdVlwkckzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVue34tDdm/aW2chH57gJ28Oc1QoGGR4RG5AOUBqJ3sjvf8oDf9uLJN9rpfToHFkj
         hJD/RlcWEfIjO131ze4pIEccdi07sDDEu2TQMok7v5lb1MN/aM5Ph+ozs0Wc2HFS2m
         B0XWPl3bhdlCLaraxkDqP/nZ+3hNAT9uPOTMJlTnyVLMcYz5wA9qKMKi7fRQr8rcDB
         A+ruoHx5WaExJWwgMV+4NF6q+cQg823jpOn9JRhYTQDva3FlzyFJ6gOveT/XEICGkC
         HHw34pdSV7UBPxDgme6WZQJzOO9qWgANgAzpxgN4JW1kG1vRlfIBdHpT4kpVT3JWum
         KheWuf8augFWw==
Date:   Fri, 3 Feb 2023 15:28:04 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/9] net: ethernet: ti: am65-cpsw: Convert to
 devm_of_phy_optional_get()
Message-ID: <Y9zarDUw7fWYw53U@matsya>
References: <cover.1674584626.git.geert+renesas@glider.be>
 <3d612c95031cf5c6d5af4ec35f40121288a2c1c6.1674584626.git.geert+renesas@glider.be>
 <Y9ybPmWub43JpMUb@matsya>
 <CAMuHMdVJo3aRLh4BCSvOrX+4KMNC=WoQCHMzdiWOmdjSSESxbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVJo3aRLh4BCSvOrX+4KMNC=WoQCHMzdiWOmdjSSESxbg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03-02-23, 09:04, Geert Uytterhoeven wrote:
> Hi Vinod,
> 
> On Fri, Feb 3, 2023 at 6:27 AM Vinod Koul <vkoul@kernel.org> wrote:
> > On 24-01-23, 19:37, Geert Uytterhoeven wrote:
> > > Use the new devm_of_phy_optional_get() helper instead of open-coding the
> > > same operation.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > > v2:
> > >   - Rebase on top of commit 854617f52ab42418 ("net: ethernet: ti:
> > >     am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in net-next
> > >     (next-20230123 and later).
> >
> > I was trying to apply this on rc1, so ofcourse this fails for me? How do
> > we resolve this?
> >
> > I can skip this patch, provide a tag for this to be pulled into -net
> > tree
> 
> Thanks, that's one option.
> The other option is to postpone this patch, and apply it after v6.3-rc1.

Okay, done

-- 
~Vinod
