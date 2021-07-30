Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4083DBEFF
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhG3TbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhG3TbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:31:05 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4F8C06175F;
        Fri, 30 Jul 2021 12:31:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f13so14603522edq.13;
        Fri, 30 Jul 2021 12:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zxmFnKmrbzC01vibbcZbCwfThDgwyJDKO9mjaDJdf4Q=;
        b=klZjUNFrmqh5cLgy/VXo6hou9+QrP5pePgd9SLL+4SDgA3y6GAOaSxd+DfADIerLWZ
         quXYnuiIrIqh52hZ2AwKn4e7TF5llnKebULpa7ny0C/lliSiZwdkmvesZOBefQzsHbKb
         MntKTtjxs/ydSHgQ8nRuahv1ZgfCgLCA+WlI9Alrkv6bCuxdhGd93q/XeT/rR7DG82Qg
         LquVD2d8Tmb/TkN1QnmaMqV1MWEagEOoALqLZpy0t25N6Mdu5iVGbaRLuMagnoqg/f7U
         CSKU089Is04zsMwWdtCGOMxb9JwJ+sOAUfTUmMvwcI+kjO2+0iVgVv5cc3Ovc3rAXe8m
         Ze9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxmFnKmrbzC01vibbcZbCwfThDgwyJDKO9mjaDJdf4Q=;
        b=HnyLtsbsxgQnXSjg/iIrqlm9tAjRK8bEgH6Zjdq5SjgYw1Tw1XiCgd+cPY53+WNgbp
         nFIrpQttC9p83k6BQDBZyVNy2mWYBNW7NCICva5whPlnIeIGbKVPjam6sowMHOhyA7Mj
         MkjSGLRfa2VnXySU9V2cIrG7cTjLuVQagdLZdnwgInLOH/gWwxnTHobWDULINpu+mlAZ
         Se6lCYCGsHOlOf5MOEaziWRyUl6evWLYsur3Bu2HESlBl8S25Y36l+wtqB6jzlygPenS
         kMAi0IMCPoSVkNesdO/H1q/zb/WRoazbPlKzOpvZrTzEfFWlQurMlgtauXj+1nUc38Ta
         VHZA==
X-Gm-Message-State: AOAM533Su18sHwInCMt7IIgNVwEIx9elRG+2L8lxyD/hyc+eCppu+00S
        oOjlYtnBuLUUoGT6FhDB99w=
X-Google-Smtp-Source: ABdhPJwmaQpRc62eWEILeOk95XVTegm2+paD53ybnJ7M0WRyCXpfkE7Y+duCEOXbhFOpsyQ6lXHEpw==
X-Received: by 2002:a50:c092:: with SMTP id k18mr2544420edf.361.1627673458891;
        Fri, 30 Jul 2021 12:30:58 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id b5sm886286ejq.56.2021.07.30.12.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 12:30:58 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:30:57 +0300
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
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on
 transmit to standalone ports
Message-ID: <20210730193057.k7su2njgdakhsnah@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-2-dqfext@gmail.com>
 <20210728183705.4gea64qlbe64kkpl@skbuf>
 <20210730162403.p2dnwvwwgsxttomg@skbuf>
 <20210730190020.638409-1-dqfext@gmail.com>
 <20210730190706.jm7uizyqltmle2bi@skbuf>
 <20210730192555.638774-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730192555.638774-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 03:25:55AM +0800, DENG Qingfang wrote:
> On Fri, Jul 30, 2021 at 10:07:06PM +0300, Vladimir Oltean wrote:
> > > After enabling it, I noticed .port_fdb_{add,del} are called with VID=0
> > > (which it does not use now) unless I turn on VLAN filtering. Is that
> > > normal?
> > 
> > They are called with the VID from the learned packet.
> > If the bridge is VLAN-unaware, the MAC SA is learned with VID 0.
> > Generally, VID 0 is always used for VLAN-unaware bridging. You can
> > privately translate VID 0 to whatever VLAN ID you use in VLAN-unaware
> > mode.
> 
> Now the issue is PVID is always set to the bridge's vlan_default_pvid,
> regardless of VLAN awareless.

Then change that, sja1105 and ocelot/felix are good examples of how to
set a pvid in VLAN-unaware mode that is independent of what the bridge
asks for.
