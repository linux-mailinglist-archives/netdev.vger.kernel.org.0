Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3675632E9A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiKUVRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiKUVRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:17:09 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBF24C250;
        Mon, 21 Nov 2022 13:17:05 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id f27so31523922eje.1;
        Mon, 21 Nov 2022 13:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J4M9TI7AR4OgJadp3C58zz3rlNRRRueDQ1CdlwASDX4=;
        b=pWh+ByunsuuktyLY7ubAZRWiVS0Hmwa/4eNNcAewLWhbjCEpyLjSU4cJgG9beTu4Bh
         Rex9Zdd/mczmBS+XiFAWcoO4T6uhX5q+m2uBeQJ2+mt9WQ8Ir57pfQsx3ttsqbOwfZsE
         oh8Rvbp53gAmanHTUlbbnKaLRVH6Knh+gMCqxaqAzEGGQHr10yrMxpgRkCxe3UBmaqAZ
         l6zQM4aahvLmqZk5E4nfSZBS7F2TYiI4pZcElyrqsahdUlXyIU3Rg7KYYvuGjytSnTSQ
         YBltiE5oEn9X3u0R5RDkbO84Tqu0TlHgpR8FmnTp5xKrp3+WZMDXIOrW0VpS2fp7Drq+
         tJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4M9TI7AR4OgJadp3C58zz3rlNRRRueDQ1CdlwASDX4=;
        b=rM5/36BCuEaK6sGi4ySlFkxxO/BRFYoLlcboLQ1aSV2tnPx52n2bE5dMS4ppxdhNsx
         y7hBdMeV+89IwB046OAh7UdLuIC7PrPkGIGWIEnr6Dm9HcH3HsIbsK9JLc0U4DH8z+jF
         CwM09UN2wmfhxqrkUhvIGyEtfk4BnC5eVnwd010+oZeVEkCbDdbOWHy78XaUYjZYzeIx
         BTYnJFaU6HCHf6yaju7XHX+lKPo7kZW+/Wxw8H1TdSJ+V/aeZhpW4aMZn2g5uDHij6EA
         wp569Be16JyoI4wp3/IIe586rnKhHoAdfR6CRXkPmqWpE3cFUPD2XzZcdrzM/hhzuR8+
         OESQ==
X-Gm-Message-State: ANoB5pmAU2Ul/mH46WMZ72hBgbUqfQD8bB0flDL/gdjrhQAVG82uiT4C
        Fa/JtuhZzVAWQ6yAcyr7z8k=
X-Google-Smtp-Source: AA0mqf6mAmmSnfS9SnWiU7N+ovuVP+3zzQarOCYDy/t20leR1UbHF1fOPtzC9gqkusg2YF4mv8MwHQ==
X-Received: by 2002:a17:906:edce:b0:7ad:dd43:5d18 with SMTP id sb14-20020a170906edce00b007addd435d18mr1048608ejb.389.1669065423932;
        Mon, 21 Nov 2022 13:17:03 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id fi13-20020a056402550d00b004580862ffdbsm5610901edb.59.2022.11.21.13.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 13:17:03 -0800 (PST)
Date:   Mon, 21 Nov 2022 23:17:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com
Subject: Re: [RFC Patch net-next v2 0/8] net: dsa: microchip: add PTP support
 for KSZ9x and LAN937x
Message-ID: <20221121211700.egmoxcav55axeylb@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121154150.9573-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Mon, Nov 21, 2022 at 09:11:42PM +0530, Arun Ramadoss wrote:
> The LAN937x switch has capable for supporting IEEE 1588 PTP protocol. This
> patch series add PTP support and tested using the ptp4l application.
> LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the ksz switches.
> KSZ9563 does not support two step timestamping but LAN937x supports both.
> Tested the 1step & 2step p2p timestamping in LAN937x and p2p1step
> timestamping in KSZ9563.

A process-related pattern I noticed in your patches. The Author: is in
general the same as the first Signed-off-by:. I don't know of cases
where that's not true.

There can be more subsequent Signed-off-by: tags, and those are people
through the hands of whom those patches have passed, and who might have
made changes to them.

When you use Christian's patches (verbatim or with non-radical rework,
like fixes here and there, styling rework, commit message rewrite),
you need Christian to appear in the Author: and first Signed-off-by:
field, and you in the second. When patches are more or less a complete
rework (such that it no longer resembles Christian's original intentions
and it would be misleading to put his sign off on something which he did
not write), you can put yourself as author and first sign off, and use
Co-developed-by: + Signed-off-by for Christian's work (the sign off
still seems to be required for some reason). You need to use your
judgement here, you can't always put your name on others' work.
You can also say "based on a previous patch posted on the mailing lists
which was heavily reworked" and provide a Link: tag with a
lore.kernel.org or patchwork.kernel.org link. Under the "---" sign in
the patch you can also clarify the changes you've made, if you decide to
keep Christian's authorship but make significant but not radical changes.
These annotations will always be visible in patchwork even if not in
git. At least that's what I would do.
