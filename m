Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7602A6181
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgKDK0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbgKDKZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 05:25:27 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AFC022243;
        Wed,  4 Nov 2020 10:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604485526;
        bh=HDC47LFG9hdz+rbd5Qat2lNu0i0erRF6pGmMXBo8+7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lBA+MLzitOHFMyDaNO5UvPkE9Qvoqk25069qzkti4vhZTwgG3d7gYLJQpkGundWrT
         /QtmBX/XGAm/V9WIOQjAh9Du4OmZmLzLIp2WfyN45yWPz9N2QnAWp6ciI/z3IagWQ3
         voQzbxuUtban4M0h2WOP7TJDT6LED5z/ipbd8l6Y=
Date:   Wed, 4 Nov 2020 11:25:11 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201104112511.78643f6e@kernel.org>
In-Reply-To: <20201104084710.wr3eq4orjspwqvss@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
        <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf>
        <20201104065524.36a85743@kernel.org>
        <20201104084710.wr3eq4orjspwqvss@skbuf>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 10:47:10 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> > So you aren't complaining about the definition of pla_ and usb_
> > functions, just that they are defined via macros?  
> 
> Yes.

What if concatenation wasn't used, but the functions were still defined
with macro?

DEFINE_READ_FUNC(pla_ocp_read_byte, u8, MCU_TYPE_PLA, ocp_read_byte)
DEFINE_WRITE_FUNC(pla_ocp_write_byte, u8, MCU_TYPE_PLA, ocp_write_byte)

DEFINE_READ_FUNC(pla_ocp_read_word, u16, MCU_TYPE_PLA, ocp_read_word)
DEFINE_WRITE_FUNC(pla_ocp_write_word, u16, MCU_TYPE_PLA, ocp_write_word)

DEFINE_READ_FUNC(pla_ocp_read_dword, u32, MCU_TYPE_PLA, ocp_read_dword)
DEFINE_WRITE_FUNC(pla_ocp_write_dword, u32, MCU_TYPE_PLA, ocp_write_dword)

DEFINE_READ_FUNC(usb_ocp_read_byte, u8, MCU_TYPE_USB, ocp_read_byte)
DEFINE_WRITE_FUNC(usb_ocp_write_byte, u8, MCU_TYPE_USB, ocp_write_byte)

DEFINE_READ_FUNC(usb_ocp_read_word, u16, MCU_TYPE_USB, ocp_read_word)
DEFINE_WRITE_FUNC(usb_ocp_write_word, u16, MCU_TYPE_USB, ocp_write_word)

DEFINE_READ_FUNC(usb_ocp_read_dword, u32, MCU_TYPE_USB, ocp_read_dword)
DEFINE_WRITE_FUNC(usb_ocp_write_dword, u32, MCU_TYPE_USB, ocp_write_dword)

This way there is no concantenation. Or should I abandon macros at all?

Marek

