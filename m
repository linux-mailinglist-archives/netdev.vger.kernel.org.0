Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9182619DC51
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 19:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgDCRDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 13:03:10 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:41164 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgDCRDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 13:03:10 -0400
Received: by mail-qv1-f68.google.com with SMTP id t4so3929549qvz.8;
        Fri, 03 Apr 2020 10:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=C18c1IugNAFxFaCXPQKTt7OVFB64Oo1MwWK6g2EBugk=;
        b=hENydy7D0JCIgFa87b7M0ed1qoGpz0QGXHyXVDmHGDh7zw+L+WUhbK8IW02pBk8qHM
         ADsA25xAJ67o4Ra6VRdXBwMhcZMuHy475xAxlyiU1YuRkbqv+PF2ir5V5qEjMcANfQVn
         jGY8UQU13Viwi+GDqFDM01+/XrhVQbFZPaY/Tb2zki4oxJUEWTJXSoycxyeREVVBXM5T
         uUK7ezP46TqBapFishKlJi3Sy21RVUbp0ZoycRDNJ8VBJIH1oXob0kZUNKCSq+meSRlw
         PvtxAFdZSw3sGPJDdA0MlyJjyUWjLDDi5bCftL5qN/hJ4Jis+/StdK4ZXo5AsP3JJEfj
         3FBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=C18c1IugNAFxFaCXPQKTt7OVFB64Oo1MwWK6g2EBugk=;
        b=rybU4ozIerctSM0MzTB0k3ERvOnYEv6ZCk0L2c4W6/1IYwZN8R+xDAFiT8Pd59MexN
         UFTVEdcfYD5zv8ByxFHsGXipcbXgxsLLYFmYUk5qTzyyb5rvnmQbousLiaburYrS/dTN
         47iTws+XsMaZX3YUuQd3RkiQBiAP97qOVLYQEbIuJHSzEkRSU+H/olyY2alErw2q0DtC
         twBn3MWyVsGQMRk/Lvj+FynUL7QaF4alci5buJE4RyJYrUDR+ziDeKKKIsEMalzXqrBn
         3+Bx2IG///BqqOgXeXuLIQ265ouq3uOxdIFBqOy3BOhXfbqmnNOyZeb2NzEp+OaFATFL
         q5Ig==
X-Gm-Message-State: AGi0Pub7mxwRCDhfmmPwPQPG+PIW8qszdXyOnYgo1qSsXoaeIqhEOFoO
        jpERSXYDFTJyuaFz6rQNkGg=
X-Google-Smtp-Source: APiQypI7c1myt6pyEA1+Je1XA2txJx4TleqRCwZGZQeWyffLtTOCPCApztHQrbf9btvLkagoi//UCw==
X-Received: by 2002:a05:6214:1933:: with SMTP id es19mr9320626qvb.186.1585933389339;
        Fri, 03 Apr 2020 10:03:09 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k2sm6777761qte.16.2020.04.03.10.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:03:08 -0700 (PDT)
Date:   Fri, 3 Apr 2020 13:03:05 -0400
Message-ID: <20200403130305.GB6453@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Chuanhong Guo <gch981213@gmail.com>
Cc:     netdev@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in port5
 setup
In-Reply-To: <20200403112830.505720-1-gch981213@gmail.com>
References: <20200403112830.505720-1-gch981213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Apr 2020 19:28:24 +0800, Chuanhong Guo <gch981213@gmail.com> wrote:
> The 2nd gmac of mediatek soc ethernet may not be connected to a PHY
> and a phy-handle isn't always available.
> Unfortunately, mt7530 dsa driver assumes that the 2nd gmac is always
> connected to switch port 5 and setup mt7530 according to phy address
> of 2nd gmac node, causing null pointer dereferencing when phy-handle
> isn't defined in dts.
> This commit fix this setup code by checking return value of
> of_parse_phandle before using it.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
