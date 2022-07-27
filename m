Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843F7582A61
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiG0QJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiG0QJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:09:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7A12E9F2
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2342B8219D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 16:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8894AC433D6;
        Wed, 27 Jul 2022 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658938141;
        bh=UMc26es24hpH/MNzph+0enEJ3bFAyfMlV04dxCh36RE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RVUH3Jgfr7bRyERdKK5I2LV3zmXvdl+Pu1dpTBa/4h00bxqBY3GGnDc1vnSSn9FxE
         R7x1cDThLgze+g2AbjEZ+rcaT9GmYRN98Z5imbGmcOs1/4EhNHdMXzkbf3Mg5KRG/m
         z+uPoB98dyKzKFg4drBB01v7V21beIwx0uIzJoqnMrRFCMaxAQsPBoVBP5N7Td8xNq
         JDl9KAmEJurfJE6lv9I2b54SQVg10PApF1FhMAL1qkCo8e7+z9di/TTsJAGTSGwcB6
         0ezzWghTd/S3JxgoTqQh28oLcKhX4C5cEYxFWL5p+3VAVuPt8upxzkXOKgKn4dcFvu
         U4huT4F7S6+LA==
Date:   Wed, 27 Jul 2022 09:09:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: question on MAC passthrough and multiple devices in r8152
Message-ID: <20220727090900.75d2b7b8@kernel.org>
In-Reply-To: <444df45c-ec1d-62a6-eea8-44a0635b2fdf@suse.com>
References: <444df45c-ec1d-62a6-eea8-44a0635b2fdf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 12:51:44 +0200 Oliver Neukum wrote:
> I am looking at the logic the r8152 driver uses to
> assign a pass through MAC and I do not understand how
> you make sure that it is passed to one device only.
> As far as I can see the MAC comes from an ACPI object,
> hence the driver will happily read it out and assign
> it multiple times. Am I overlooking something?

Just to be sure - have you seen the giant threads on the topic?
IIRC lenovo was sending patches to extend the mechanism, broke
some people's setups and to much teeth grinding we accepted the
somewhat improved patches and moved on. The entire mechanism is
quite poorly designed, we couldn't come up with a better way :(
