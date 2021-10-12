Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A978E42AF1C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 23:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhJLVov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhJLVov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 17:44:51 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B4FC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:42:49 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m21so320469pgu.13
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 14:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fF0BohRsk5rZ3VG2ZjFEWW1wWJMS1yFxxRXKtZs3uxY=;
        b=bdjnheDIl9nUqVr6378PPu9QPUUo6kRXtJtjBZ35XCHBS11FUToUlYKkOIKvU3hH2q
         QouT18vbgns0LDEZtlcx4v0tCvuw1fnoQ158g/eOtpF8L3lQxjPnIxI8jCQdlzgTNEZQ
         c6SYUUQkndBeXQZYmLbXZmcRnsPt4zgglcfcpHH0V81qZxPrEW4DayZMgKYjY2d0jamM
         mdYzqakLBRUL9atYemNaXiIhOaUcJ2aagfGHCAmdlfZ+La61J9JtX+f5jETE1nwiR1Ro
         HCX99IFSONcoOW5EiI+TTE7t/hKLdZnBSDUCa0iI+wFVcdZE61ropLdA2KIlxGzVwXuh
         I+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fF0BohRsk5rZ3VG2ZjFEWW1wWJMS1yFxxRXKtZs3uxY=;
        b=heGcQ5U1hKB8jMoLFJTwZ/hTHZ5IEW5RUMc6WGql1bRy5u+ZZRX1wyB724D60I/hL1
         rTNjCISfG4UhhtQ4FtRvtv5AD2k/xrCQaqrRFnfRowHIRy9g58rewiyUYNViuT1N+eKI
         Q2mbIoLeCzHyHVOwbA/qXHvwDpnTiEQwjNf/LfV75z/U2zIRtQWfRFob5IeNDDtROnSV
         Y2Y4HIzdcpWoCULfBGisyO61ucxprq15WhdknACL758Afk6fU685tbB4mPToMwMfDKv9
         3PeXtoSdW4yd34XhnLqTUbXTxizDhC9+dCjP1cSfny2dm2/MJmkMZ7Y1DhE8dJ2rh63c
         DW5Q==
X-Gm-Message-State: AOAM530mT+pILzCGrtAX+85Usq8coTy3YhqnM81wIsdy/wDOtv5wtxAi
        zUuYstQzPQxy+jCbx5LfnXU=
X-Google-Smtp-Source: ABdhPJwZthftf4+QcQaPuR5eQL3L41FcH8pJYsL6P8zMsz3lUwFAdmMu5CN7uISZhEUt1qjDHp3MtQ==
X-Received: by 2002:a65:664f:: with SMTP id z15mr24751979pgv.252.1634074968630;
        Tue, 12 Oct 2021 14:42:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w18sm12099696pfj.170.2021.10.12.14.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 14:42:48 -0700 (PDT)
Subject: Re: [PATCH v2 net 09/10] net: dsa: tag_ocelot_8021q: fix inability to
 inject STP BPDUs into BLOCKING ports
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
 <20211012114044.2526146-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <83d7644b-78e0-9b18-41e8-62a730c1a0f6@gmail.com>
Date:   Tue, 12 Oct 2021 14:42:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012114044.2526146-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:40 AM, Vladimir Oltean wrote:
> When setting up a bridge with stp_state 1, topology changes are not
> detected and loops are not blocked. This is because the standard way of
> transmitting a packet, based on VLAN IDs redirected by VCAP IS2 to the
> right egress port, does not override the port STP state (in the case of
> Ocelot switches, that's really the PGID_SRC masks).
> 
> To force a packet to be injected into a port that's BLOCKING, we must
> send it as a control packet, which means in the case of this tagger to
> send it using the manual register injection method. We already do this
> for PTP frames, extend the logic to apply to any link-local MAC DA.
> 
> Fixes: 7c83a7c539ab ("net: dsa: add a second tagger for Ocelot switches based on tag_8021q")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
