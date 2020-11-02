Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008D62A35EC
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgKBVWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgKBVWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 16:22:44 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C52CC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 13:22:44 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id w1so14693182edv.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 13:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XWw0iYRJAd0GQDRWITf4AnzWuFMoCU7403fyL3hJP84=;
        b=Pb5qJkUipomU5TBS6wwLkJCr2v//nYZZjZT39Px8yxZWNca3EM6Rr6n/0Lad6cNPdQ
         o1SXBcBU/tOLybBPhIJXFPtEL3QwZUt74sDTu2VYAFE3F8mRKIPuTLZ1A0Jj7tGhmrts
         EAGIU8RPT4E9oX1JkLBhr9HLeQttOOrzuMhV7r7rvDBjM488yQOjaKTGYF25KX04VjLz
         695MHYLQz29A3kWdmSmv6jNc7X94aoF+C+kfkY46wCUTAywL4vXSv+XRd/HUm66EZdsh
         Qjo75HBe0/9M3yZVdZDGpDi0jgfhvFSPob/wApU4aeYsnmXsDGmIDl6Hn4q78KX+f13y
         EBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XWw0iYRJAd0GQDRWITf4AnzWuFMoCU7403fyL3hJP84=;
        b=bkVStKovLDrMV2xNTrno/kHyi6p+lSZDqOsclMek18D2HQLDEQLGST5pOKjMnpwaDm
         7jSW9RASr2KrSL7LWV1H5KrFAPOTy9iGal8ZN74b0dNFm4q1dcn4L9tvCO46c/I1Rbcd
         bS6dC761zKEz7j9g02/SiABfsNyEqaAFmduElKKV1XdGXrU4YW34OcbSk41D0VJlZ7M+
         M+Y8Kh7YR3+xAcnSuwbWHXevDY+SVO4ZpnjueIrqsfbAHVFjBdJFZIhPDjvBbPWSFwas
         C7+nqxqCkp18GrRPop/ewjxJl8sY6RQq5qT7tQJFwfcLRugpEOgEeipiXSy8BVf62HHv
         fPjw==
X-Gm-Message-State: AOAM532isGSJfoIRRCk4Hr++dLQTzaNbO4tmv1jEHO8K5emVlxw9WnMU
        qgaNd/BY0PDCEM5cDQuWghyVsorkw/CytDpQrtg=
X-Google-Smtp-Source: ABdhPJyviqzh4v1cOKOoAjei83js2viyRjSKxU4SnLTfwzpg0qgkeaPFGLxjiVzkOHUAghhOfUBmSzAJkmUDKj+eyJ0=
X-Received: by 2002:a05:6402:17e4:: with SMTP id t4mr18888937edy.118.1604352163178;
 Mon, 02 Nov 2020 13:22:43 -0800 (PST)
MIME-Version: 1.0
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com> <d5091440-3fe2-4d14-dfed-3d030bd09633@gmail.com>
In-Reply-To: <d5091440-3fe2-4d14-dfed-3d030bd09633@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 2 Nov 2020 23:22:32 +0200
Message-ID: <CA+h21hruPyA-X72Mzo9H-6pPESO+roJQ8xUfcmPJOgp7a031vQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: dsa: use net core stats64 handling
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 01:37:03PM +0100, Heiner Kallweit wrote:
> Use netdev->tstats instead of a member of dsa_slave_priv for storing
> a pointer to the per-cpu counters. This allows us to use core
> functionality for statistics handling.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>
