Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74113F89DE
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhHZOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 10:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbhHZOOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 10:14:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4E2C061757;
        Thu, 26 Aug 2021 07:13:31 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i6so5356676wrv.2;
        Thu, 26 Aug 2021 07:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=caYyU5A2AvEDiDoSCaNuh/yyConc6WLj0h0u8wdjUAY=;
        b=sfdfnRDFmn99FvOvSeIqiZu3TIpbOjIpjTkWDSMeJtlSprqfChCgqmNX+yuucnUgV9
         i6zK/gAr7uA4GITCV3DLh9/WVEtp6wrDCq6oQG+jyckvjT3+ADGUV0qEW6rSZr2LH7ph
         FGlaDC5Org74CkvgU6zGV0GrKV5pU0kKKE4Nk35WC/1I1vkXvJa+KHP/mkCE5tdnjk8p
         nWogC+riLx3d2o+ePUibWB3xTtU3gnmw5SmwcoSx6tKsS8kovnIp9gIwqtKUDxJvyBn6
         eIRGhiqWGZW3pfFeGyBnFHX+oGbYmorV+PEvPfhsTHJMSpKVOntuKb41J5jkxTBfA42B
         jktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=caYyU5A2AvEDiDoSCaNuh/yyConc6WLj0h0u8wdjUAY=;
        b=Xg48BEWCi2txNa1W9ZeF1jUI+xD5Gv7Is60gM87vunzpEAaVJl0GL/HnSA5FdfK4Of
         ECAL2Ze9Q2+rRQbEfHNh/D1bxp3+jq3Mg8uHJ79g7AQj/s4B9PO+yquTICSym5cYD4Yd
         37UgAOROR37WzcqDFXsjhtBnz7JGWAE9M+JsJDDCYNaF8W851FBY5SC0mDaMSo7lvp4H
         7c5Cx1TKbdYnDtBVGHOXFuPE0baSELlFiCVKO2FPccXj7AeKilfsiWYidHmOtiS6Lr0I
         7LzzlbpCpsA1vvteFK+7MFHWG5ppj3ajfwDMjUoLN/UM8gUQlQ3/WE6HHnwzfUrwLbLy
         twFA==
X-Gm-Message-State: AOAM530UcKfQtTScTTCbPsY6IaEvQzuQJz4Kjy8CCKQnSR1+rGFSS/u4
        KZ37v1xu2Osv/rYjoJ9rYgU=
X-Google-Smtp-Source: ABdhPJy9JM6BAhgGm12/qstapJvz/0SjmJEusJf+9bezqcUxqhO2JhGEOaReMpCaxTpD+2laTY1RsQ==
X-Received: by 2002:adf:9084:: with SMTP id i4mr4333320wri.23.1629987209616;
        Thu, 26 Aug 2021 07:13:29 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id b24sm4369821wmj.43.2021.08.26.07.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 07:13:28 -0700 (PDT)
Date:   Thu, 26 Aug 2021 17:13:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 2/2] net: dsa: tag_mtk: handle VLAN tag insertion
 on TX
Message-ID: <20210826141326.xa52776uh3r3jpg4@skbuf>
References: <20210825083832.2425886-1-dqfext@gmail.com>
 <20210825083832.2425886-3-dqfext@gmail.com>
 <20210826000349.q3s5gjuworxtbcna@skbuf>
 <20210826052956.3101243-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826052956.3101243-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 01:29:56PM +0800, DENG Qingfang wrote:
> On Thu, Aug 26, 2021 at 03:03:49AM +0300, Vladimir Oltean wrote:
> > 
> > You cannot just remove the old code. Only things like 8021q uppers will
> > send packets with the VLAN in the hwaccel area.
> > 
> > If you have an application that puts the VLAN in the actual AF_PACKET
> > payload, like:
> > 
> > https://github.com/vladimiroltean/tsn-scripts/blob/master/isochron/send.c
> > 
> > then you need to handle the VLAN being in the skb payload.
> 
> I've actually tested this (only apply patch 2 without .features) and it
> still worked.
> 
> The comment says the VLAN tag need to be combined with the special tag in
> order to perform VLAN table lookup,

It does say this.

> so we can set its destination port vector to all zeroes and the switch
> will forward it like a data frame (TX forward offload),

And it does not say this. So this is supported after all with mt7530?
Are you looking to add support for that?

> but as we allow multiple bridges which are either VLAN-unaware or
> VLAN-aware with the same VID, there is no way to determine the
> destination bridge unless we maintain some VLAN translation mapping.

What does "VLAN translation mapping" mean, practically?
Other drivers which cannot remap VIDs to internal VLANs just restrict a
single VLAN-aware bridge, and potentially multiple VLAN-unaware ones.
