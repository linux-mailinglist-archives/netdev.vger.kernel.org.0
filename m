Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5B7622081
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiKHXzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKHXzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:55:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3FF21824
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:55:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A234617DF
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 23:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C12C433C1;
        Tue,  8 Nov 2022 23:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667951746;
        bh=YanEMSXAQoUxqmApmyh33MV4qags4oxpp5A4aLtzUbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uiklergCQNb+O9bg2X8HJrUglB6Vx9grVh08CYTsgHy0G1b4H+Mtm8Jy4wXGEBhFe
         Zo7xtl0+iSvXPn3/XqTlKryEl3uHUwQd57DK0yb8MkiBzyV3PY+QUO4IjseGBgkBkw
         h2v9GDD3jwN4dHVXMWIZzhmiw5lOHQNFCHC8742S85cszbMKui86QJ03rKoR0rxIbk
         ilbOPYLlFxIqtMswlGve+KxAUpJjzw2pHHnhtvgQT8qa1cmAXcZZ84GpuYYNkgIq45
         69H3s6a8sTLEvkoSiDquV7ADKlnqEWXFAtTfyweuxyusxM8v1pL6+YsN7HagdsLkwe
         M5nXYn1OvsjMw==
Date:   Tue, 8 Nov 2022 15:55:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 2/5] net: txgbe: Initialize service task
Message-ID: <20221108155545.79373df2@kernel.org>
In-Reply-To: <20221108111907.48599-3-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
        <20221108111907.48599-3-mengyuanlou@net-swift.com>
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

On Tue,  8 Nov 2022 19:19:04 +0800 Mengyuan Lou wrote:
> +	__TXGBE_TESTING,
> +	__TXGBE_RESETTING,
> +	__TXGBE_DOWN,
> +	__TXGBE_HANGING,
> +	__TXGBE_DISABLED,
> +	__TXGBE_REMOVING,
> +	__TXGBE_SERVICE_SCHED,
> +	__TXGBE_SERVICE_INITED,

Please don't try to implement a state machine in the driver.
Protect data structures with locks, like a normal piece of SW.
