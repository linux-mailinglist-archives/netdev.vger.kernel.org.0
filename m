Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360063DE12A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhHBVAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhHBVAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 17:00:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C93C06175F;
        Mon,  2 Aug 2021 14:00:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d6so18665741edt.7;
        Mon, 02 Aug 2021 14:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=au7OmFbdKv+WEAGRQZkjaVywZk0CXvijDSw0i4sbtGE=;
        b=EdFRe/KmdoJn1AHOI1FO9W6HwfLEJuPIttmxOrfsgZ7XSj2xJ/yDY+WwBQCzW2hnM9
         uFPAJdttH57zeJzFLM+i5h53NG/Ag4F2m4dpRrSCB3Xf2B82a32BkeO+KEIMT1CYdb7w
         ZRA8EUoCvu1mmmHj3FR8Dd2PRjokDDk3Dw3rvdLKWxG96hVvNSpWqXJu2jOOSNzSAAOx
         kj2KbixhxQbXUVvKHJ9rdW0Dk6jJnd4qswUs+vQC6OdvWgAAr48ndZgwLlmV26YVV4X6
         vZVl+0dj2R6WiWUGYrIbNCcDiMqwNIch/Y8qAKpmWJYmKX1Wp3evBKuJi52lpvJ56z83
         TcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=au7OmFbdKv+WEAGRQZkjaVywZk0CXvijDSw0i4sbtGE=;
        b=sywnXYufs79L4S7FWltKnRx15R0cPEPeYho42nb7/QJpkCyBQfnBVfmMWQ4yR7TH/c
         o0DgUz2yvYKMkDRTbcsbc3DAuC0QUJj9+glXpqaiNkDXoEwIdYKlwHKNtu0d3HBS2unr
         FONSXHxLTwQUwjfgapwENUp7/JFq707RnNb9JugDMod0i7sMJRBaz0TSFdK7l9VATcUu
         Ikn1HF1CroFJcfc9uRdFrfNMy66d+Xj7ZWH26yUo4c8lqicKVCtPItn5v5gI/J4cvL7Y
         RjH2ijluUntrnG+VAASccaphmry1T83YXZVpDUsnwaEsK4LkRslgTqyZO6Zbj160eJy/
         DDHA==
X-Gm-Message-State: AOAM532HwPa1soUVRuTLKiiadN7r8aZXcTMkmV5caWHlZPMpmvC8o5nU
        Ff087+OVkUqCc1/4MG1/t3I=
X-Google-Smtp-Source: ABdhPJzyuFCqFOApHOayrbRXZJjmJ3F5gh6jzvSJdRg/0sb8lMnS6VK2GCoDWXc5t1B1LePaHFf/7g==
X-Received: by 2002:a05:6402:35d2:: with SMTP id z18mr14382992edc.282.1627938009217;
        Mon, 02 Aug 2021 14:00:09 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id b5sm5126644ejq.56.2021.08.02.14.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:00:08 -0700 (PDT)
Date:   Tue, 3 Aug 2021 00:00:06 +0300
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
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on
 filter ID 1
Message-ID: <20210802210006.fhmb5s6dsnziyk7d@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-4-dqfext@gmail.com>
 <20210802134336.gv66le6u2z52kfkh@skbuf>
 <20210802153129.1817825-1-dqfext@gmail.com>
 <20210802154226.qggqzkxe6urkx3yf@skbuf>
 <20210802155810.1818085-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802155810.1818085-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:58:10PM +0800, DENG Qingfang wrote:
> On Mon, Aug 02, 2021 at 06:42:26PM +0300, Vladimir Oltean wrote:
> > On Mon, Aug 02, 2021 at 11:31:29PM +0800, DENG Qingfang wrote:
> > > The current code only sets FID 0's STP state. This patch sets both 0's and
> > > 1's states.
> > >
> > > The *5 part is binary magic. [1:0] is FID 0's state, [3:2] is FID 1's state
> > > and so on. Since 5 == 4'b0101, the value in [1:0] is copied to [3:2] after
> > > the multiplication.
> > >
> > > Perhaps I should only change FID 1's state.
> >
> > Keep the patches dumb for us mortals please.
> > If you only change FID 1's state, I am concerned that the driver no
> > longer initializes FID 0's port state, and might leave that to the
> > default set by other pre-kernel initialization stage (bootloader?).
> > So even if you might assume that standalone ports are FORWARDING, they
> > might not be.
>
> The default value is forwarding, and the switch is reset by the driver
> so any pre-kernel initialization stage is no more.

So then change the port STP state only for FID 1 and resend. Any other
reason why this patch series is marked RFC? It looked okay to me otherwise.
