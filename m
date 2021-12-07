Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C070646C16A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbhLGRPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbhLGRPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 12:15:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AD5C061746;
        Tue,  7 Dec 2021 09:11:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4171DB81745;
        Tue,  7 Dec 2021 17:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF6C341C7;
        Tue,  7 Dec 2021 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638897100;
        bh=03p5gtJk0QC2kVPL9rkE+p7LHkrXt8qG3IGR8xqErpw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JHaxknFV8d+/fd4wOw4KqQnsj3X3Jl0FB0sUyJL/HesvMwpbY4L8Pna/cOUUC7Oic
         fQNnvrbAM8gfLZBOP9w9xR5q3YAce/K1zgtcP5mNyf2O1V+MFf0eGIBJhU8fQ6iJRN
         yCM/ZMG7kvAxsU27n6+s/y4OhRFXciJ/SJRV5muJAEt4bH6fWnjuUiv0eFCJb2lYSL
         W4V3PzuHt1iYwTlwbkptHcKHcP5Pl1+m4GNqIgVU6qO05v1YkGvxJB63FfGtZX4hJY
         2ylAjzF1e+o3ThPyjtx5SD/EoAvfAL0uP42tMi2MQ0AgjBrKu/IMvwQHp9ctiCxsWH
         942mpBsxjADPA==
Date:   Tue, 7 Dec 2021 09:11:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com
Subject: Re: [PATCH net-next v3 01/12] net: wwan: t7xx: Add control DMA
 interface
Message-ID: <20211207091138.6e9bb8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
        <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 19:47:00 -0700 Ricardo Martinez wrote:
> +static inline void __iomem *pcie_addr_transfer(void __iomem *addr, u32 addr_trs1, u32 phy_addr)

please drop the inline keyword from all C files in the next version,
the compiler will know to inline trivial functions.

> +{
> +	return addr + phy_addr - addr_trs1;
> +}
