Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6234D3DDCB9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhHBPs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhHBPs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:48:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F709C06175F;
        Mon,  2 Aug 2021 08:48:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso559958pjf.4;
        Mon, 02 Aug 2021 08:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=iFEvhb+pWS2fHWjo0SPK+/xVkX5ExnAVIzPe3nLKKpI=;
        b=gkFlepEtWgxNsrASRfaQY1uh8Mj1erqxFQyyuDQKRDZoyjFfTKzszqOVZfchtHwSxB
         EayR11JSZNgAg968gT6S5f08lqOqp40AozL+gcIs7p5U/u2OvSV997QvGXceRBSUSyq0
         8/6BeEz2l8ggw7ohQ7L9Aqemvo6H9iS/AjnavSo+8Sgpyfrw4pMw/juAPvShadnZ2p8G
         XdZMWRPfIFvuGlHWcniw9F9dTzaQXIVkbANdvzc8rBVJgzP+WjOZSWpCFVWshcxHwMRc
         FJBkEMGTYBwjm7Q7JKTBiVdV+ncrbrvMr3zySwWg7xAfLcyzwHYcG1lj6KnPs2mk69GR
         ANgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=iFEvhb+pWS2fHWjo0SPK+/xVkX5ExnAVIzPe3nLKKpI=;
        b=MQdKrF5SP3C578dUjo7aYHUEl1LZAQ8zCnNv7UQ+sfTVm0nUt6vGvFZnTrcgHhqnCU
         W01YBSb+3aSrtVwBvFTXMS5gBuLmkT9a/Qyp+3r2Vi72DpkIHXQMC2yo2goRAbIlcUn1
         CmgXFIQjRqFj18+T7S/fa6AHnimMbL6KeoI8z1z1Z+tinqLCV5n4SgGzTHYn71wweRQ9
         KpDS8zZCnv/nMasj/keazhG/7QXMT+8hCtew0mt3IvJFjn0EnrfRPwqn+IZeE5weuseG
         Meerg/WXrL1L2AcUBufcsRPMDFhHw6obkscBqG7lUoiafBZILiQa2PYRAbu9oCtilZcf
         POYg==
X-Gm-Message-State: AOAM530TVyk0GoNyajzJS+gfy8G09pdj3rA3E+aFNcZqzRvbs7VDRWzs
        Z8ST8dbI80bZ3SKF7oqT0ek=
X-Google-Smtp-Source: ABdhPJzqXW1OAkAAZZra+6fqNo9oVwsleYwCd0ZWR5t9Yaba1OfMRtzMKyaaxDMQLw96sEu64UB2ZQ==
X-Received: by 2002:a62:8fd4:0:b029:3af:3fa7:c993 with SMTP id n203-20020a628fd40000b02903af3fa7c993mr16580168pfd.77.1627919327667;
        Mon, 02 Aug 2021 08:48:47 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v13sm11244135pja.44.2021.08.02.08.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:48:47 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 4/4] Revert "mt7530 mt7530_fdb_write only set ivl bit vid larger than 1"
Date:   Mon,  2 Aug 2021 23:48:38 +0800
Message-Id: <20210802154838.1817958-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210802134409.dro5zjp5ymocpglf@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com> <20210731191023.1329446-5-dqfext@gmail.com> <20210802134409.dro5zjp5ymocpglf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 04:44:09PM +0300, Vladimir Oltean wrote:
> Would you mind explaining what made VID 1 special in Eric's patch in the
> first place?

The default value of all ports' PVID is 1, which is copied into the FDB
entry, even if the ports are VLAN unaware. So running `bridge fdb show`
will show entries like `dev sw0p0 vlan 1 self` even on a VLAN-unaware
bridge.

Eric probably thought VID 1 is the FDB of all VLAN-unaware bridges, but
that is not true. And his patch probably cause a new issue that FDB is
inaccessible in a VLAN-**aware** bridge with PVID 1.

This series sets PVID to 0 on VLAN-unaware ports, so `bridge fdb show`
will no longer print `vlan 1` on VLAN-unaware bridges, and we don't
need special case in port_fdb_{add,del} for assisted learning.
