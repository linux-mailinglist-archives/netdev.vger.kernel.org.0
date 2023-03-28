Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6210D6CBD63
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjC1LWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjC1LWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:22:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F3A7D9A;
        Tue, 28 Mar 2023 04:21:58 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id s13so6705019wmr.4;
        Tue, 28 Mar 2023 04:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680002517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=slvp/Lh/A2Cql09K0z7xHRMQAgWLXzuT8obGzP7qfCk=;
        b=KU1v0Fx4pnv1ZCVQH4jp0KoRE4V+rcGx0RcLrPGetxThL36IsY0cdWosFkiDefHuAV
         CqymSSCvpyC4uv8qt2/CLvwSiWoHq12OSLbPUPUx8Iw7Ye2J39PW0szVqxtVVcPMFN0/
         L299LPc34Fdlfqx/Qz2ztzwX/hduA+P7bb9V8Uw+cTYOSGTmKdYPE5mYCWGdSRA9RNqQ
         PNhp8VqQlom8Sk/kPpJTWpLqYRh8joXl5UFkg9ryTcAutGOOCDGzdPJUNJ/15FPTBkXq
         Pj0wm7Ej1ewq0qzrcA2gob4gdTpQGA/g8xLxQWOY2PrpBqidYksWzE8tVPEtBj9cOk4z
         Dvgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680002517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slvp/Lh/A2Cql09K0z7xHRMQAgWLXzuT8obGzP7qfCk=;
        b=Pb+6LRPl74aE8daGOK2Q9Ls9t79SGgOYq/GFGzuIOUFMTcT2aynBlgPOceduWzzL8K
         +JvfmDX/sPjN0JXREtesl25yld2k8t+r0xUreFLwJxMiilraMX/H0NUwfFOqnwhBT1HF
         dZyH2oceX6ATGFtcy9K2HfzfaNumPnzmq7t2rrLQtNtijXSuF6aiT5FM6tx0ThZsAzR0
         M1TdYiRWa6dXkd++4x3LBf6p9ytKTNrYgqIkWSclUfZhmvDeOVTdcq4hLenJo/4z51cd
         3kNa8CGNAT0xQP50dyi2E+HUqhuu7BQm4GLw0Fvtv3pjm/KKGROjNTL1sIaUY5bQ+zgA
         50qw==
X-Gm-Message-State: AO0yUKWE43f5VZjKfF1lRM5uPfz1BeS9zCaHZynzQNIUhuFSEhrN+gkn
        Q1RCGNTjZIMBhZ8wYgqkpxg=
X-Google-Smtp-Source: AK7set8kjZ2lZPkSladu0ABr5wkk+sKce4J1PUAbHXmMAzrtQEwWAjBFTHklV6EO9Gy91f5+K1M7PQ==
X-Received: by 2002:a05:600c:20d:b0:3ed:6693:138d with SMTP id 13-20020a05600c020d00b003ed6693138dmr11760571wmi.4.1680002517204;
        Tue, 28 Mar 2023 04:21:57 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w13-20020a1cf60d000000b003ed4f6c6234sm16782604wmc.23.2023.03.28.04.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 04:21:56 -0700 (PDT)
Date:   Tue, 28 Mar 2023 14:21:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 0/7] net: dsa: mt7530: fix port 5 phylink, phy muxing,
 and port 6
Message-ID: <20230328112154.qk5fwqaig4sit3ho@skbuf>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326140818.246575-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 05:08:11PM +0300, arinc9.unal@gmail.com wrote:
> Hello!
> 
> This patch series is mainly focused on fixing the support for port 5 and
> setting up port 6.
> 
> The only missing piece to properly support port 5 as a CPU port is the
> fixes [0] [1] [2] from Richard.
> 
> Russell, looking forward to your review regarding phylink.
> 
> I have very thoroughly tested the patch series with every possible mode to
> use. I'll let the name of the dtb files speak for themselves.

This patch needs to be resubmitted (potentially as RFC) to the net-next
tree, and the commits readjusted to clarify what are fixes and what is
pure refactoring. With the mentioned that I have not reviewed the entire
series and I will not do that, either.
