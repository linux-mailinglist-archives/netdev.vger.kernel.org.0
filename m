Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9294465CBC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355202AbhLBDbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351677AbhLBDbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:31:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7064C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69E39B821CA
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE203C00446;
        Thu,  2 Dec 2021 03:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415658;
        bh=Nne6/y2ezb61X7XPAFddia3XsJHKlOVNTZ/flL8YRps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ScoI/TDgIwrASMVToEs0syPxfBoefubJIfugcEABj8ZBV8JOtc6HeUuoFo2GQN4S4
         9L9YLEKn965SiQOiWB2DXDowZ/I2526lda4LprCsSiQ2fFuOeV/gCXGhMFoyMTJ8cx
         WLp0aGHJ58c9gS/xOnTE6IoitD/rCLXSxf7w0TI4BOImYZBBMJdB3KY427YYp0X8ql
         J9ia1daCCJAaZyngB9hzXRpAQKiHIOJSCj8DVPVGuttF+JrH938XUwrQQXzQWMB0IU
         pb4APkbm0hbCfXncFvVgaJFT2YKnq8zW0zsRvJyLCtFSEM91wg6Z61iJk2ITr2wNAQ
         ay79LS7l2BftQ==
Date:   Wed, 1 Dec 2021 19:27:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 5/6] i40e: Fix VF failed to init adminq: -53
Message-ID: <20211201192736.60739e28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201215914.1200153-6-anthony.l.nguyen@intel.com>
References: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
        <20211201215914.1200153-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Dec 2021 13:59:13 -0800 Tony Nguyen wrote:
> +	if (ktime_get_ns() - vf->reset_timestamp < I40E_VF_RESET_TIME_MIN)
> +		usleep_range(30000, 60000);

		msleep(30);

Seems pretty strange to usleep_range() once the length is in 10s of
msecs.
