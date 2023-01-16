Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6444F66BCB4
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjAPLTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjAPLSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:18:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137B71E9EA;
        Mon, 16 Jan 2023 03:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC9DBB80E58;
        Mon, 16 Jan 2023 11:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E2C433EF;
        Mon, 16 Jan 2023 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673867907;
        bh=8PrYbyCiD04eZZG/0z88bf7npnuEKHo0T6laY8odGoM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OMsr+rFvO5dK7DgWTkloeRlOGNefEOoyAHywNsjkIs41BXdOKoCSID0G8lc2IZOTI
         /tcmgfrqKZ8YybX5//WcG5XOYgLMMa5IT2W36gYlNaBI7OEK1k9vt6XKP033HIQYaF
         cIBm/eRSw1Ol4r+0rVhI+uyNsVqgvdaO0/MAzs63Pj+Kzrhj3C35uovBFoliJyengS
         FdZDrFC4dd+fhFNPibTKLL2k1JCUI3loFFWkm2/HfE3Zyjbp+XKIIDBi4B6unha/NQ
         /y5FntAW/gPXxc4OpV9NkvhP5k9sl6SxcHNFmbqbIDReTMGt0zAMLB/+Lw19zM5Z/k
         33ibAJVjRy/FA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: Prefer DT board type over DMI board type
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230106131905.81854-1-iivanov@suse.de>
References: <20230106131905.81854-1-iivanov@suse.de>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     aspriel@gmail.com, marcan@marcan.st, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, rmk+kernel@armlinux.org.uk,
        stefan.wahren@i2se.com, pbrobinson@gmail.com,
        jforbes@fedoraproject.org, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        "Ivan T. Ivanov" <iivanov@suse.de>, stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167386788710.4736.8327846687234426691.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 11:18:22 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Ivan T. Ivanov" <iivanov@suse.de> wrote:

> The introduction of support for Apple board types inadvertently changed
> the precedence order, causing hybrid SMBIOS+DT platforms to look up the
> firmware using the DMI information instead of the device tree compatible
> to generate the board type. Revert back to the old behavior,
> as affected platforms use firmwares named after the DT compatible.
> 
> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
> 
> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
> Reviewed-by: Hector Martin <marcan@marcan.st>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Tested-by: Peter Robinson <pbrobinson@gmail.com>

Dave applied this directly to net tree:

https://git.kernel.org/linus/a5a36720c3f6

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230106131905.81854-1-iivanov@suse.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

