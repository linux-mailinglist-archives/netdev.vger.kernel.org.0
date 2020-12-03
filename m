Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540802CDDD0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgLCSe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729250AbgLCSe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:34:28 -0500
Date:   Thu, 3 Dec 2020 10:33:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607020427;
        bh=Q+UDuMhoCcldB3ftpQf7pCsCaUQ8R+MCu3VYtRw3TMM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=As6GFHIFWmmPUeaIg5YhJ4M0DxX/tRhkAWe+YWlvgp1pXnopvTsdNGSrs2veV8xYS
         DwkwIvporQBaISeEATBhzSQRaOd5KEF9YEFSyG6y+IT+xhkeH80mlW+7ju3xSBpZFs
         r38uw/HKjwXCOdLEXf/JTsOhQs/pG/sOdaYAbwHHehCA+y0JQRfRvRyFLQhYFKkB+f
         RI3h5BP+1DidnO/0x5Neq7HouRikLezvXFvQV55iseAijmvvrjwZD6XfPz9uw4x/3W
         V9Uck2LsIPVkyKEzB/otS0PcBfj9AcICcjSvjfJyFU9PHgOTsV60s4zsICn6YSUzIe
         dbN9ZoKx5/19g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH 4/4] net: ethernet: stmmac: delete the eee_ctrl_timer
 after napi disabled
Message-ID: <20201203103345.45c6ef8d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202085949.3279-6-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
        <20201202085949.3279-6-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 16:59:49 +0800 Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> There have chance to re-enable the eee_ctrl_timer and fire the timer
> in napi callback after delete the timer in .stmmac_release(), which
> introduces to access eee registers in the timer function after clocks
> are disabled then causes system hang. Found this issue when do
> suspend/resume and reboot stress test.
> 
> It is safe to delete the timer after napi disabled and disable lpi mode.

And here
