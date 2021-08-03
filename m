Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14703DF333
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhHCQvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237263AbhHCQvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:51:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E37C061757;
        Tue,  3 Aug 2021 09:51:41 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o5so37374243ejy.2;
        Tue, 03 Aug 2021 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8+umZScsOZjOsyO3Wgd5I6k6s08z12UwqmKO/ZSDzWU=;
        b=G+XrZz7H5KnPA/nVBuuIkEaI21RE2FQpOo+vC0IjPeng/+qXv9H0vBR0xGr+AuuAvv
         6QgZe8g1nMyJ32bUEf2+qyjh/V/+sUbDv8tb1osloY+UpXTrJ3SrhRhyD2Dsa5lbvGCP
         Gq//U3+Oi7lesf96t/OrQVtfKYtKKcYmF0fLoClgGbrjZ4AIx1YbP3OlXConq267zcl4
         DS/VnBRnAB6eHStgvc1oGx7dVrC5w3uSQd4wEW92f3eILcHMuXRWlLqhKG7uRv331h1a
         y2QX9qRtOgOCJNzd4S3qhZGL+We3J+jNOppctVY1AXUbEv/nLn/GUD6a1Tc/tIqORDfU
         56Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8+umZScsOZjOsyO3Wgd5I6k6s08z12UwqmKO/ZSDzWU=;
        b=nAFaYwXkx6lZRxWr0UcHNF0k+ByyqML4PTvUjXtbuFBzcJgysjKZgZ26+MaPl68YcJ
         1wua2qbaxbdGCsoWV9KZKI3+dJAhMpcIK4jHXKzh04TLHAP97LJAhDI6fKG/L16p6c27
         Bas9AHYnkqCT4iT1CEA7KWXPyYqOEMZSyQly93LHJb9+/QJwCrbVPPG17nGhhRbX9IKY
         YtQiyOQoLXt5hHN8s0FOBsko1NsdOnhtcMOEHJCkc8/frk7UK2Yr40Wa6riAWSbyd12O
         yOq/bAu8eU9kEE5oDThD/+1Yk43PLOAil6Hjniz647NDGdGR2Iunjjj7mHPcQP6GFHhs
         KMwA==
X-Gm-Message-State: AOAM531gebb8uj/KnNwC5yNTXDooLh5Udgtu2O38ygDTRPM26k29WgYw
        ZItFwOalS0dGdheyFcoJSlI=
X-Google-Smtp-Source: ABdhPJzOeuhc7RhMVyEW4bwBTNsbiGz/zk2oNpxReoCzfanmHcb+Hs0q5HvBCcSEdVlFIYLwg6PVyw==
X-Received: by 2002:a17:906:c1da:: with SMTP id bw26mr21664503ejb.253.1628009500105;
        Tue, 03 Aug 2021 09:51:40 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id dh8sm8406135edb.14.2021.08.03.09.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:51:39 -0700 (PDT)
Date:   Tue, 3 Aug 2021 19:51:38 +0300
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: dsa: mt7530: always install FDB
 entries with IVL and FID 1
Message-ID: <20210803165138.3obbvtjj2xn6j2n5@skbuf>
References: <20210803160405.3025624-1-dqfext@gmail.com>
 <20210803160405.3025624-5-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803160405.3025624-5-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 12:04:04AM +0800, DENG Qingfang wrote:
> This reverts commit 7e777021780e ("mt7530 mt7530_fdb_write only set ivl
> bit vid larger than 1").
> 
> Before this series, the default value of all ports' PVID is 1, which is
> copied into the FDB entry, even if the ports are VLAN unaware. So
> `bridge fdb show` will show entries like `dev swp0 vlan 1 self` even on
> a VLAN-unaware bridge.
> 
> The blamed commit does not solve that issue completely, instead it may
> cause a new issue that FDB is inaccessible in a VLAN-aware bridge with
> PVID 1.
> 
> This series sets PVID to 0 on VLAN-unaware ports, so `bridge fdb show`
> will no longer print `vlan 1` on VLAN-unaware bridges, and that special
> case in fdb_write is not required anymore.
> 
> Set FDB entries' filter ID to 1 to match the VLAN table.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

The way FDB entries are installed now makes a lot more intuitive sense.
