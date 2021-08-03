Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECAE3DE84C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhHCIXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhHCIXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:23:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5069C0613D5;
        Tue,  3 Aug 2021 01:23:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so3649891pji.5;
        Tue, 03 Aug 2021 01:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=fDhSpWOSrYcVlwun8gKdxsTr1lzh+svxX3HU4xChX8k=;
        b=IUdeMuz+/AS3Ep+u+FgMmD8Ox6TBlMgruYzD3GGNU7o1g1ERcVRhhBK/QgocRFpo7f
         gGYBlsGd8+5pZWrW+mPMa6aLOPBpiqUczPgvHyUp7nupFcyHo88cpDA8ALjYMj2MNSBR
         DksADRmnQIYXtjsXZ9VhqjkF2z41KTxb7dyjY8zmj4YjawVdan1jzzdNpWbHA7JxPlSg
         ob28eHXI6oKEsKT8LSQapasliDnnsiI9A2CyTXaAUrrdOQUD266AOm/FhAMtLP0h8vPC
         hm4Dhxxh/vtAOkfy/GRGihnbs+beU56rmS0jeAX9YOqjoCWqXBAXYGvjMJCijGx/GP6I
         Px3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=fDhSpWOSrYcVlwun8gKdxsTr1lzh+svxX3HU4xChX8k=;
        b=fBDw4oGry0u35w282Bi8dAXp3zTUPYBWlih3nWNt878fxvsFFelw8lsfbHbYR58tXJ
         bhX85TqnU57l7F3DrT7u99lNYb73Z00CoIbn9gtfkAPqnYym8+eOlMe+A5/ctk3gRB5J
         QyTislwW6nT6cu2YnYlSlBKlvTfxExAgXD5/+SIW0Q0XnL6goUxriZysD0y4F5ZmzEwX
         bdaQ8fIwKqZ8xH3LmUNOXPZ/PhQeAbwEgOjK7br9IheuQoZxN+dQSRY6bF/nyCrFUgBc
         WCXo2OtI7ItDvPLKvLHIG/7HyTllwDmwSLmuxizuIhrDPeBUJjmHYlsbOF99olljY2Qb
         q15Q==
X-Gm-Message-State: AOAM532o5lRdLZNXZf60HNA07VVnpNCHGGfNzN0W8c8D0Bs9ya3qtaCu
        Zfn3fof/DDQ2qx3gY8cNg54=
X-Google-Smtp-Source: ABdhPJzNZWth+D0i4tKa/kdtzaQkkuP562QJnrg5hpFwhUMJpx6kbamQt1Vc91d9ILTlZ3M1XGaMmw==
X-Received: by 2002:a17:90a:7106:: with SMTP id h6mr3208328pjk.222.1627979005366;
        Tue, 03 Aug 2021 01:23:25 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id h16sm13815443pfn.215.2021.08.03.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 01:23:24 -0700 (PDT)
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
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on filter ID 1
Date:   Tue,  3 Aug 2021 16:23:16 +0800
Message-Id: <20210803082316.2910759-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210802210006.fhmb5s6dsnziyk7d@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com> <20210731191023.1329446-4-dqfext@gmail.com> <20210802134336.gv66le6u2z52kfkh@skbuf> <20210802153129.1817825-1-dqfext@gmail.com> <20210802154226.qggqzkxe6urkx3yf@skbuf> <20210802155810.1818085-1-dqfext@gmail.com> <20210802210006.fhmb5s6dsnziyk7d@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 12:00:06AM +0300, Vladimir Oltean wrote:
> 
> So then change the port STP state only for FID 1 and resend. Any other
> reason why this patch series is marked RFC? It looked okay to me otherwise.

Okay, will resend with that change and without RFC.

By the way, if I were to implement .port_fast_age, should I only flush
dynamically learned FDB entries? What about MDB entries?
