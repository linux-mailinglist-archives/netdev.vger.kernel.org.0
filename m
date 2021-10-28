Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC30743E4CF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhJ1PSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhJ1PSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FFB61221;
        Thu, 28 Oct 2021 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635434183;
        bh=oTD0uzTuFWhkB81ERcflZ4QQgV/0+hOuDfU7dxb4yuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gafaAGoWKJAXXQXi+uI01Fanlm5UylYfFf/8/8DvIg0zm+BiOBFpiIaMH+ra2wf7B
         q57qQYPFu23OTfSYIn+WKgfu4CVr04zmw4R5wHYS7fml78+HS+xPYORUFXOfuS+jR6
         W8m2RfOi1dXcW5m6+h0FRBJEDTbZttcUDlwFwIkTzJXvpMirP9jVUAQ4r+SeucE2fB
         ER6RUlj/YFGeMf1ciOgtJD3Duc84f5+LguOkMZXgmNPIEFf9WndfuAcrUT/Zxmv1h/
         W8tqqkKklcVc+tGU1RiN+e2mosQmsxLPItO3RYKyuBdg50/TKKhZ/3XiCbsQwtiFar
         KcnHt2ZGBkBdQ==
Date:   Thu, 28 Oct 2021 08:16:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH bpf] riscv, bpf: Fix potential NULL dereference
Message-ID: <20211028081621.1fb6bb31@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028125115.514587-1-bjorn@kernel.org>
References: <20211028125115.514587-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 14:51:15 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> The bpf_jit_binary_free() function requires a non-NULL argument. When
> the RISC-V BPF JIT fails to converge in NR_JIT_ITERATIONS steps,
> jit_data->header will be NULL, which triggers a NULL
> dereference. Avoid this by checking the argument, prior calling the
> function.
>=20
> Fixes: ca6cb5447cec ("riscv, bpf: Factor common RISC-V JIT code")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

Looks pretty trivial so applied to net with Daniel's off-list blessing.
