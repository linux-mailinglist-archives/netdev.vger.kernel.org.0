Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD347D869
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 21:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhLVU4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 15:56:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhLVU4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 15:56:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7831B81DA9;
        Wed, 22 Dec 2021 20:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B894C36AE8;
        Wed, 22 Dec 2021 20:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640206557;
        bh=PIW6wwqIOxe4oZtT//vimt3dQLuUmUszra79YvipIKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=caEy7wNxFUmKoTHPTDG32oHoGU/DhhYcLdFXPWc5gY6hKlDlSIV/TUEbvOIKJjyAr
         rnKO8dmcAebYMsatl8CkW9tUDAz+ZMaAEGgab+rdtpj0mhbjmfO+EsqhLcXiT6RNVz
         0YaBXJ6ikGkrADCE1sngt36DzyVdhHbmLuNcdUiIHzQic4j4QS2TnoKe3AhateSny9
         NVGiRrYh2Xj70sCD8moG3BAff9a2ftPVHSoV0A7R55bbyhr96dG2RTHdfVvD1ykEU1
         u7n80KIpS5XbdXAiUuFFmw8NvKQhipru6o1u+H/5KCJ7omVdXdk9nrKtr/SXawmhmW
         pRUpIooyoNNjg==
Date:   Wed, 22 Dec 2021 12:55:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN
 management
Message-ID: <20211222125555.576e60b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222155743.256280-9-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-9-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 16:57:33 +0100 Miquel Raynal wrote:
> +/* Maximum number of PAN entries to store */
> +static int max_pan_entries = 100;
> +module_param(max_pan_entries, uint, 0644);
> +MODULE_PARM_DESC(max_pan_entries,
> +		 "Maximum number of PANs to discover per scan (default is 100)");
> +
> +static int pan_expiration = 60;
> +module_param(pan_expiration, uint, 0644);
> +MODULE_PARM_DESC(pan_expiration,
> +		 "Expiration of the scan validity in seconds (default is 60s)");

Can these be per-device control knobs? Module params are rarely the
best answer.
