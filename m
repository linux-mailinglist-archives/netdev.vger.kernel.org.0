Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3314218F5
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhJDVJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhJDVJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 17:09:23 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14DFC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 14:07:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x27so76599256lfa.9
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 14:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UL2vZIPweQG1p4QbWw7SXeHCI/dDuD9ruYm3z8gIkTg=;
        b=rRxRyyJB2/OLQOiv0Q1nRho9OVzRJgTv929WjJI37a9bkLYYiAl9oxPaqfgA8Jh7zy
         0a2Cu8PNZ8ShR+f8N7TLq7beHQddGiBCfXaRLTz4BtJDUJVpOoe9ZkxUOzydEJgTfpQJ
         5W92x4SjdclnmLN6Oj+ZLsvOxoAC7bZ6DcFrQmWMno6jMvcz1SreNNXl1ndx8wJChRzV
         ysegPWNxyZuIYI5xeuoS1Oo2SP61nm9YXZitbjOG4j6H6SlmKVOiBZEWPaB3jXROvjnk
         Y7IjU9SOpSKrsEBlqB2k53nGAcKuDNqJB/RDa0lpbrZsN1gzSQ0X6VWn6yXPak07I4V0
         798Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UL2vZIPweQG1p4QbWw7SXeHCI/dDuD9ruYm3z8gIkTg=;
        b=ZQx3u9kf8bnNYVmD9rQweVra4cyJqQtbpOLm7eSjDPP+7KFj+BTRYeakOz0IiPbXY9
         0ioi1QyL1N3iDobCQkv29CRFPrIwBiv2IozPFHmTt07Ii1uo87mU4fmZq0XQvHuaR7PK
         nKzyGCoo/5gKG51GGJKe/Lmdyd/llVDw1fp0MCJo2AeFGsbcikALxsBymXJbEufE2Mqx
         TgZG85TNtf1XRkpetYdeBYavszZLyDLd7KlZFwhp+Cjq9vOSzCoqJ8DHWQW2ITXtIYZO
         1eQj4NRmDKBiCppphr7bqB2pLy5L/KvZYH7UrfEc0fOpR6Z3LPrQQw6oUrqCPFWA0it6
         J1ZA==
X-Gm-Message-State: AOAM532Pg9qH3oXpMcV6Z17Er2SC+xgAe1sloPUML7Dy70paDCRiOayF
        eFBjT3ifrv2XNdt7JInu1qQYvVkmhAFuIlzIegScaQ==
X-Google-Smtp-Source: ABdhPJxJNNiwUZZzunaHk/D+2wF/0bi0sQtJQdgaWM7PvaPKHfnOJQGvoRPJ7br0NSFj+f4xEzGpuXOHTeMydRL3OKo=
X-Received: by 2002:a05:6512:706:: with SMTP id b6mr16299631lfs.656.1633381652316;
 Mon, 04 Oct 2021 14:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-5-linus.walleij@linaro.org> <20210929215430.kyi5ekdu5i36um2k@skbuf>
In-Reply-To: <20210929215430.kyi5ekdu5i36um2k@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 4 Oct 2021 23:07:21 +0200
Message-ID: <CACRpkdbBYr+wiuHqoPhk7OwZQZAcPMaUMnEU+ZYbERUbaaaAaw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4 v4] net: dsa: rtl8366rb: Support setting STP state
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:54 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> > +/* Spanning tree status (STP) control, two bits per port per FID */
> > +#define RTL8368S_SPT_STATE_BASE              0x0050 /* 0x0050..0x0057 */
>
> What does "SPT" stand for?

No idea but I guess "spanning tree". It's what the register is named
in the vendor code:

/*
@func int32 | rtl8368s_setAsicSpanningTreeStatus | Configure spanning
tree state per each port.
@parm enum PORTID | port | Physical port number (0~5).
@parm uint32 | fid | FID of 8 SVL/IVL in port (0~7).
@parm enum SPTSTATE | state | Spanning tree state for FID of 8 SVL/IVL.
@rvalue SUCCESS | Success.
@rvalue ERRNO_SMI | SMI access error.
@rvalue ERRNO_PORT_NUM | Invalid port number.
@rvalue ERRNO_FID | Invalid FID.
@rvalue ERRNO_STP_STATE | Invalid spanning tree state
@common
    System supports 8 SVL/IVL configuration and each port has
dedicated spanning tree state setting for each FID. There are four
states supported by ASIC.

    Disable state         ASIC did not receive and transmit packets at
port with disable state.
    Blocking state        ASIC will receive BPDUs without L2 auto
learning and does not transmit packet out of port in blocking state.
    Learning state        ASIC will receive packets with L2 auto
learning and transmit out BPDUs only.
    Forwarding state    The port will receive and transmit packets normally.

*/
int32 rtl8368s_setAsicSpanningTreeStatus(enum PORTID port, enum
FIDVALUE fid, enum SPTSTATE state)
{
    uint32 regAddr;
    uint32 regData;
    uint32 regBits;
    int32 retVal;

    if(port >=PORT_MAX)
        return ERRNO_PORT_NUM;

    if(fid > RTL8368S_FIDMAX)
        return ERRNO_FID;

    if(state > FORWARDING)
        return ERRNO_STP_STATE;

    regAddr = RTL8368S_SPT_STATE_BASE + fid;
    regBits = RTL8368S_SPT_STATE_MSK << (port*RTL8368S_SPT_STATE_BITS);
    regData = (state << (port*RTL8368S_SPT_STATE_BITS)) & regBits;


    retVal = rtl8368s_setAsicRegBits(regAddr,regBits,regData);

    return retVal;
}

Maybe it is just the coder mixing up STP and SPT, but the register is indeed
named like this in their code.

> Also, is there any particular reason why these are named after RTL8368S,
> when the entire driver has a naming scheme which follows RTL8366RB?

Ooops, my bad. The RTL8368S == RTL8366RB AFAICT, the product
numbers from Realtek makes no sense.

> > +     mask = (RTL8368S_SPT_STATE_MSK << (port * 2));
>
> Could you not add a port argument:
>
> #define RTL8366RB_STP_MASK                      GENMASK(1, 0)
> #define RTL8366RB_STP_STATE(port, state)        (((state) << ((port) * 2))
> #define RTL8366RB_STP_STATE_MASK(port)          RTL8366RB_STP_STATE(RTL8366RB_STP_MASK, (port))
>
>         regmap_update_bits(smi->map, RTL8366RB_STP_STATE_BASE + i,
>                            RTL8366RB_STP_STATE_MASK(port),
>                            RTL8366RB_STP_STATE(port, val));

Yup that's neat, I'll do this!

Yours,
Linus Walleij
