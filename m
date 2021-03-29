Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75134D510
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhC2Q0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhC2QZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:25:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE0AC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:25:53 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ap14so7277813ejc.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CB2oaAB16RhkGrLV5SIuygFLJclZt6p+4maK2u/2B2I=;
        b=UiQmkU13cgJeIOiy0ke8mt4mEz1Mz+rX62hPC4k8jauG8X+Qw38o3vumDrQecvh2vM
         2hUe/Arqkcb8H15pc50SsOYFqAUuALg46lm7VO/IvJeUCxHvViIcca5TddFpe+dNaZhn
         uz0eZvUAw55yDAXqVLXXkhy60cxuFrNVTDvvUw9sKKKjLrPY7wk/052gigF1MAWGL432
         Pzs58erVly29Whdf5L+mixApCzNt4bmUhK5+pegdOygpyO1GC4gHN2lOKHTFF8/Yt50C
         MFGlyT1rLGpYUo+ydWvZWEPrWWCAAhjpJlS2SsdP1rmDhpTMHic7esq0mdGsXfXAju3o
         Y5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CB2oaAB16RhkGrLV5SIuygFLJclZt6p+4maK2u/2B2I=;
        b=EazD+Vlq91Y6N6nXiUYZ7nmheyWkauILOQk95sK9jESr0Gv5RgWdsTT2eGvyk91qp/
         muOlgkmiq15UZPN7L/HRgYe1MedAJtjunYbh2iDhkm3TWPxyNQA2p2j01NqexIQhis2R
         sxQ9Nwy09RAl0eiO0JrdiBSmWMP29yoR1yoEkvqWHZt+sLwDVT8TkGhZyuJ8KaFYQ21P
         Gu6nDzFrmHX9Boq9oyMQJpI5tpCTPNHeWgUj1ODEpusJpHgLi9V2yvcKvvOkplrgDuBL
         aXkj+TxOtBtYo4NcZBM4zzE0mtEj4UUOqqdSFknmVYl0q/lyzECO6+1bGZKR2OTr/jbl
         nKaA==
X-Gm-Message-State: AOAM530AB+PC9ikBxjBl2VQjuwPeHEe2W8O1NLL/xnJo2eOO5qF8EZLk
        COYT+XSY1R7tsB+5/xFjWLEbVsILdf0=
X-Google-Smtp-Source: ABdhPJy9O5XqPdHWFxkc2awMmuZC+X13Y0EKkYM7Z9ANTE7SAm7YmMOqvmtGingZKj6Widy0z4qWbg==
X-Received: by 2002:a17:906:2312:: with SMTP id l18mr29998737eja.468.1617035152370;
        Mon, 29 Mar 2021 09:25:52 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id mp12sm8467669ejc.1.2021.03.29.09.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 09:25:51 -0700 (PDT)
Date:   Mon, 29 Mar 2021 19:25:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: Fix type was not set for devlink port
Message-ID: <20210329162550.ket62265ykcb7vkx@skbuf>
References: <20210329153016.1940552-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329153016.1940552-1-fido_max@inbox.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:30:16PM +0300, Maxim Kochetkov wrote:
> If PHY is not available on DSA port (described at devicetree but absent or
> failed to detect) then kernel prints warning after 3700 secs:
> 
> [ 3707.948771] ------------[ cut here ]------------
> [ 3707.948784] Type was not set for devlink port.
> [ 3707.948894] WARNING: CPU: 1 PID: 17 at net/core/devlink.c:8097 0xc083f9d8
> 
> We should unregister the devlink port as a user port and
> re-register it as an unused port before executing "continue" in case of
> dsa_port_setup error.
> 
> Fixes: 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
