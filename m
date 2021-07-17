Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CBD3CC43D
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 17:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhGQPok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 11:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbhGQPoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 11:44:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8EBC06175F;
        Sat, 17 Jul 2021 08:41:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id a127so11716297pfa.10;
        Sat, 17 Jul 2021 08:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=joQ8gEeTx6Yiij5UFZWM2uMjNke7wP9TlqjIUNge51M=;
        b=d8CLmdnIzEpfIgHQZ3lctgsM+Ll9uXpCnw6FK8u2FvmNaciwfEqcae8VPqK0UBwWBT
         F/Tfv2WucvBot95eTUkTEqmM21hV51mCirP2RFQ4dj6i8K/riP6i2VvEpbGErMYtg45C
         MNt2UeRF3x6E0waatVGUyOIl2ay7K0zDZ/h8SHgzEXsERFSjs+1vGXQHAp1+E0REdbhK
         nG/dy11kVfvqCagWSYon64fGT2Hvyz92qk4p3jSiyMaickRqyfdD9ph/r7O/yr+jq7+E
         V3ATxNSj3HTkqckg1jYB/ftOxO1j5MFb+DJaw0NApKBclLYp91uC+YheWkPYu3JWvgyK
         RceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=joQ8gEeTx6Yiij5UFZWM2uMjNke7wP9TlqjIUNge51M=;
        b=gB3SIP5S2taxvWveNe5WJtOaNxD4errAWXqR4375U7d6TYfrFyymtefzjMHwpqtA+U
         Dtfo12wGqrDQeuQjDolNlSlxvtTKduNy4uPx+2MRkwI3xm2crnMH0c+fHPWdfNbgOxc3
         c8NgpRLiE4bopOChqOESlKnr0w3wmFWz7Gj2w5ihoPSwktCWgWoo2Wbi3Eqi8btPDoKS
         XLgEzq0CvDjwoZoMFqu2mqv0lXy55xje5BSm3WamjOgZOPYIGvLTHv9wOkjCqn647M55
         U1aWSTOVDeNjuNUy5Nk61nQyDb+Oya/dKbLJmQMR58apeN1w9UQTOnHyIEoH93duUUZF
         Fk/A==
X-Gm-Message-State: AOAM530zcXHGEwrPsLBZY30wmgGJwlqylgf5fNGxJDfA+5c8dybf522m
        IiAFZRYuXwPOguAMmIHtJas=
X-Google-Smtp-Source: ABdhPJzpED/z+AzlaCHgvYtysgYgXl0cEeH9cNxEg30LHu8mqrynywd7fdi9wIVfeMVwiYHoKA1EWg==
X-Received: by 2002:a63:d74c:: with SMTP id w12mr15631066pgi.91.1626536501212;
        Sat, 17 Jul 2021 08:41:41 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id m13sm13461930pfc.119.2021.07.17.08.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 08:41:40 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Eric Woudstra <ericwouds@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Date:   Sat, 17 Jul 2021 23:41:31 +0800
Message-Id: <20210717154131.82657-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com>
References: <20210716153641.4678-1-ericwouds@gmail.com> <20210716210655.i5hxcwau5tdq4zhb@skbuf> <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 10:09:53AM +0200, Eric Woudstra wrote:
> 
> You are right now there is a problem with vlan unaware bridge.
> 
> We need to change the line to:
> 
> if (vid > 1) reg[1] |= ATA2_IVL;

Does it not work with vid 1?

> 
> I have just tested this with a vlan unaware bridge and also with vlan bridge option disabled in the kernel. Only after applying the if statement it works for vlan unaware bridges/kernel.
