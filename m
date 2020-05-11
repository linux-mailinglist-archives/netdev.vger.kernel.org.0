Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7271CE865
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgEKWpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKWpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 18:45:06 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88A9C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 15:45:05 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id o10so9335739ejn.10
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 15:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/n/JO/9yaomlIJWtLvceGZSYsq+7oJ0YpBw03WoIiI=;
        b=pNYSlg7H3H/yau85wHzzuFhcpu8YCzO+v9PH5lKYtjQ5SXqRYKMvHmn2CpSQmBKJZI
         LNAOmkS9OCl5EztRS0IkI3HVX7wgftc/+Jm1OALlkH0OCLeElM0PGtAlkS/NW7gIIxFU
         76c7WGn9OuUCc71zhVXyX/xNDreREEiQ0k1qykHEg6zvXeNtBElo9HuUht7gegLevOQe
         CVNfBfmnh0KAX9OuHk8xgNi5Tzocgpxizv32xi1mgObm/BexPeK9VmLxnemi+Fey2Rj7
         90Sl0V2VLBh3HZHX2Lq3fv0aLguNOIQFWUGrzDxGdXwYEFqvLRvLWvJSeK/H2g87teJy
         H6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/n/JO/9yaomlIJWtLvceGZSYsq+7oJ0YpBw03WoIiI=;
        b=EkpwfxY6eSwjewmw2FuqD+CWt0YP1mdhuTyOVTECuhe7F34J5zWeYSz8zYJvKelSKN
         PdTFjiza7x9erBa3muV+t6rIiwYWy9EF+1y35yjD4N9TL3VvqDtPxn+/ax938g59jDt+
         wXn1tfn7L4l9gCIa40+N3F13UzLs1xNltvpOp6YB5C6hbIfPGfDvhy9Av90ibwl898pY
         HTGl5/1AmCCmnebn7vTaCdkb/6KbpGJkoUk7PD9Plp9T7kyZYxDpI9oh+BpzG42I/Wj1
         bgm0RxsEwkCIjjuM/fRJP0F6bFjxG7kfD2uAd76jqv16G6nuTQBad83hE6LgSoYX/HT0
         MgQA==
X-Gm-Message-State: AGi0PuZwa7dVk176WxGSnga+CCHkVC+rRHJFQmNj2CWJBHGcrU4+C536
        oXcWRA2tKeTVIxTPQRB8X4rm1g9FksNATysgXn4=
X-Google-Smtp-Source: APiQypIlD743InEvJ4bl29tQnDRvN1lqezyFoM9CYaYsNX8cFn6g5QcIcOBKVTHcT2Po428mAVhwWZiWmyzmtaFrBiU=
X-Received: by 2002:a17:906:add7:: with SMTP id lb23mr16028020ejb.6.1589237104675;
 Mon, 11 May 2020 15:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200511202046.20515-1-olteanv@gmail.com> <20200511202046.20515-4-olteanv@gmail.com>
 <20200511154019.216d8aa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200511154019.216d8aa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 May 2020 01:44:53 +0300
Message-ID: <CA+h21hqC=wQmgb_pwaJTdZsj5ceL5fMu1OLKp8wix8M-pPg4tQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: dsa: tag_ocelot: use a short prefix on
 both ingress and egress
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 01:40, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 11 May 2020 23:20:45 +0300 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > There are 2 goals that we follow:
> >
> > - Reduce the header size
> > - Make the header size equal between RX and TX
>
> Getting this from sparse:
>
> ../net/dsa/tag_ocelot.c:185:17: warning: incorrect type in assignment (different base types)
> ../net/dsa/tag_ocelot.c:185:17:    expected unsigned int [usertype]
> ../net/dsa/tag_ocelot.c:185:17:    got restricted __be32 [usertype]

I hate this warning :(
