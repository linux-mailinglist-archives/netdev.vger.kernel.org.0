Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D0C458D75
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 12:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhKVLdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 06:33:15 -0500
Received: from linux.microsoft.com ([13.77.154.182]:34446 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbhKVLdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 06:33:12 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1BC6420CDF8A
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 03:30:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1BC6420CDF8A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637580606;
        bh=Gc95weIGGpO+jXyf82d/fH9Q/HcQ7XjvTMwfhsgPgI4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OI4ZWxsym+mw7hYk8A2um8Y/M/Iwse97wugDiCCxlFnyfQcsFtsRLS1z2D5hW+Vkx
         ZvfKh0GEahgx9z15FD8Kg/9y2H4v0Bskj8nYnCPjrsBuE9e+z7e9DR/nE4/0Liwy/Y
         7PUedmA1zE8iO5LF/8jCK7UhzX+cPqFhS+dLlt0w=
Received: by mail-pf1-f179.google.com with SMTP id u80so4163953pfc.9
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 03:30:06 -0800 (PST)
X-Gm-Message-State: AOAM5313ND70+Pk+yHepBBWk4cPPJYBO7e6smMEAEl0bwTDGO9L8phDx
        ZYz/sHvN8zaZA+/2YvmIajLlPOCZ25lSNS1u5lc=
X-Google-Smtp-Source: ABdhPJxSTevhDOzsZ28L/0ODxidwCGCcz7z3raqHwmrHB2ue0L4viG8Xnag+6PfN/t0C11BGDPcCuvS4O41ETSmLU0s=
X-Received: by 2002:aa7:98dd:0:b0:49f:bab8:3b67 with SMTP id
 e29-20020aa798dd000000b0049fbab83b67mr42597291pfm.86.1637580605680; Mon, 22
 Nov 2021 03:30:05 -0800 (PST)
MIME-Version: 1.0
References: <20211122111931.135135-1-kurt@linutronix.de>
In-Reply-To: <20211122111931.135135-1-kurt@linutronix.de>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Mon, 22 Nov 2021 12:29:29 +0100
X-Gmail-Original-Message-ID: <CAFnufp2U8Dv3yJiw+uPGOiYXxdNspmvsJ0rWKicvXTi4R32tdQ@mail.gmail.com>
Message-ID: <CAFnufp2U8Dv3yJiw+uPGOiYXxdNspmvsJ0rWKicvXTi4R32tdQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: stmmac: Caclucate CDC error only once
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Benedikt Spranger <b.spranger@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 12:19 PM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> The clock domain crossing error (CDC) is calculated at every fetch of Tx or Rx
> timestamps. It includes a division. Especially on arm32 based systems it is
> expensive. It also requires two conditionals in the hotpath.
>
> Add a compensation value cache to struct plat_stmmacenet_data and subtract it
> unconditionally in the RX/TX functions which spares the conditionals.
>
> The value is initialized to 0 and if supported calculated in the PTP
> initialization code.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Nit: "Caclucate" in the subject

-- 
per aspera ad upstream
