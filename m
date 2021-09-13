Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DDD4097DC
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245253AbhIMPwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244694AbhIMPwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:52:41 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E163C05BD13
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 08:45:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id i21so22087784ejd.2
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 08:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xRmh/Y1qC4SCsf+8wkoMdhsYLeyTPz3IqXaTG4YoU7s=;
        b=I7uE/JXr48ALBl7y0gsZQ9l/ZU+4F+IauUGv9CL01TIFma5Ja0wfc0VDH+BwhLpGdT
         UUQqDGnCsduUutZftLUCGSbOfiMh2WPBfSj65GLWPoIvL+xpqgssyhmblMOifdlOEcf4
         7hgJS+iYTCRHpOA7iIcUHLrkUw2Bt+gj6p8b55qV5/eli+TSl+Gq/l0pO8EZfKPmTHJB
         47y4WjtruaLSp45GhYw6UsXQRKBBBn5w9sekvx+cq8tiKN8dNCxlUAFykI+2APX5kDXh
         48VyOZ+uw2B8VlNvpleqcgfdoewpW6o/sxVTo5MUnadzpHEldw7GQAujVwxb7VXIxzOH
         iWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xRmh/Y1qC4SCsf+8wkoMdhsYLeyTPz3IqXaTG4YoU7s=;
        b=1VDggtvCCQLQCB/1W09tdo5bky6IM+KYIwCw38kwKHe4DtsprbAQu/lYQ7hts6UXYy
         tXkLbXRmaOuwDcUtviX9FrRBv+RjywndfZwrBGOG7oRGxEfDRF5cLYM/Hs9Wxv1yGScl
         quDFj8xpva1a2RipiHoexPRC5GPjvL9aDx+1Xq4M6d7ZoF1o/ufTi2mmn/UXPoRDTcty
         YjIuZ/IFBBAi3/S/763RJtn8j+FbhyaYEYrGCzrW93yACAL7ksdRLq61WXPCelwg9Jsg
         BVpPMlS96jJ6nizGCDHDWRInj2eR46L9zMGAC79xutcGqU8tTugjCjMJitfpsJkGlJEA
         FRmA==
X-Gm-Message-State: AOAM533UVq1SwqvnCOSFzLU+IeOYg9dc6EcaUEpAL+x5tSiGkh13AsIw
        Q7UVHTSFaV3gYggT+UiHBxg=
X-Google-Smtp-Source: ABdhPJyXvLRyukQUR2cc42hz5n/jrkYAAoHdc7fFVSmTKBW8zqXTzYE2LRt+jS9gNOnQhr8AQE9KsQ==
X-Received: by 2002:a17:907:3e20:: with SMTP id hp32mr13040070ejc.536.1631547937600;
        Mon, 13 Sep 2021 08:45:37 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id bw25sm3708255ejb.20.2021.09.13.08.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:45:37 -0700 (PDT)
Date:   Mon, 13 Sep 2021 18:45:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/8] net: dsa: rtl8366rb: Always treat VLAN 0 as
 untagged
Message-ID: <20210913154536.v7rc7ln7ctcuqxl7@skbuf>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210913144300.1265143-5-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 04:42:56PM +0200, Linus Walleij wrote:
> VLAN 0 shall always be treated as untagged, as per example
> from other drivers (I guess from the spec).
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v4:
> - New patch after noting that other drivers always sets VLAN 0
>   as untagged.
> ---

"Other drivers" are not always a good example.

Technically speaking, IEEE 802.1Q-2018 wants switches to _preserve_ the
VID 0 found inside packets when forwarding them, but treat them the same
as untagged packets otherwise (aka classify them to the port's PVID, and
forward them according to the forwarding domain of the $(PVID) VLAN in
that bridge).

"Preserve" the VID 0 tag means "mark it as egress-tagged", so the
opposite of the change you are making.

Now, I know all too well it is not always possible to satisfy that
expectation, and we have had some back-and-forth on other drivers about
this, and ended up accepting the fact that the processing of VID 0 is
more or less broken. User space deals with that the best it can
(read as: sometimes it can't):
https://sourceforge.net/p/linuxptp/mailman/message/37318312/

But the justification given here to make VID 0 egress-untagged is pretty
weak as it is.
