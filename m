Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F81E498B64
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 20:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343978AbiAXTNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 14:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347804AbiAXTLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 14:11:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E26C06135F
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 11:02:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA3B60010
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 19:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59922C340E7;
        Mon, 24 Jan 2022 19:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643050970;
        bh=3F5JStDr5glBCuIaUP/eAi7l3DroZ6AEH9Kxz5+YA1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rfCFC0Pkt+muyZbnCQDM7fBuMBu7oqTtizFDDRqOOcqWSKcj+fHUIMh5D+NptgLKE
         i9K2ehkb85XkU+3g4ged6xvgjJGC4975zvSKaKDmMTPrsHN24szw+wK4/+kTeX9we6
         rPFMmSA6laJ0dAWEvMLe6zihlauFFKTmyx08DMEcdQMOHGzakdWC2CXpcLvtM9fne9
         RuxZJ9lifsC6nHPmbl6RME4LxMoNL30gV4O9/TGTFKQjaSP1VFG1YzV+qCb5o11F8u
         yKfbNiOmpoypvDSoLJIGNMExRnmtegrHgp4jDmNxH2VA6rwcPvoVWvDpPxpkZlT7pZ
         G65/ln6syYsjA==
Date:   Mon, 24 Jan 2022 11:02:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denys Fedoryshchenko <denys.f@collabora.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next v2] features: add --json support
Message-ID: <20220124110249.47b5d504@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5577ef768eaaab6dd3fc7af5dcc32fb8bbbee68c.camel@collabora.com>
References: <5577ef768eaaab6dd3fc7af5dcc32fb8bbbee68c.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 10:06:35 +0200 Denys Fedoryshchenko wrote:
> +			if (is_json_context()) {
> +				print_bool(PRINT_JSON, off_flag_def[i].long_name, NULL, flag_value);
> +			} else {

Would it make sense to report "fixed" and "requested" as nil for the
special features? I'm not a high level language expert but otherwise
generic code handling features will have to test for presence of those
keys before accessing them, no?
