Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D229C51B
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfHYR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:28:48 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38565 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfHYR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:28:48 -0400
Received: by mail-qk1-f193.google.com with SMTP id u190so12392661qkh.5
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=9rLRj13GcQUnMPWsTxOY0K4UGnjTb8RB2bEJSsII3gM=;
        b=VFyIv5rB6qjAJQKjJgKK82KME3CRnF9/7/FfYr+jdPiWRz+plke6Il51Mp8s0E1TfK
         DAo2CmigfTFFw0eZzj4njkPvngzlxpabeyjSiewD7znXAIFcSVuid/Xqadwmj5k7yXyX
         /stZJJzra5M29T537gbU2qlmwUP4A/NSgeGrhl9dlmPs2jGE8YNZFyZcH6QJDU4NYzBZ
         f19EywrOE7MXZKPGB3apuFzqikZQvaetHe5rle7voJeIXl5bQThsd8hHF0crxIjcSk2z
         9y0tywibKmx84lOknZ7Hj7C3MsoQiJLKPl1W2/P41GvWIQgUNCFhYZdndCy2dTi+8So8
         34Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=9rLRj13GcQUnMPWsTxOY0K4UGnjTb8RB2bEJSsII3gM=;
        b=uB3ViHMOUCi/V0+r76SG/4kJ82F8BB2aj8SsRYFmLYZq1WwNCzvj81jrAP3qtNmcz7
         BUmc3ibcaUhQr/v503pQIs5bt12wFGPV9TPLDLzci0ZSjuOkkjKK9Wui83DKT2+gofJs
         OaR1YevMbtHs2Nsvj9biB5NMAp2xXqKl82u0dm+95HHDSYyn9A5TWMBjDSfLrF0HwY89
         zPcPeySNiUvw1IDP+YWv7VhtII5rvhW/XriQpahdp2kubyBfM8sq1Meoye9kKHME6bdh
         XMLXK7zuCEDDaw3NfRfxezhrzZZRueIBGTSDa5pZYyuohlg5zLX6cziewDlpl0UjMBdH
         ooUw==
X-Gm-Message-State: APjAAAXTt16JQ3ZkgN3aeSpXzz1NE7yFXeudT8Tj+vXRghX6O3Fi4G5N
        kYwq/QEwXmn+OJtYz4h98A8=
X-Google-Smtp-Source: APXvYqyCQqCIq+80lBYeaPsmZ3vqxWfcIs/0KJyh+YPIIsO0tqWF5M+qpfaJyuiKXlzdI2hXxFHYkg==
X-Received: by 2002:a05:620a:132e:: with SMTP id p14mr13348378qkj.498.1566754127264;
        Sun, 25 Aug 2019 10:28:47 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g207sm4801898qke.11.2019.08.25.10.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:28:46 -0700 (PDT)
Date:   Sun, 25 Aug 2019 13:28:45 -0400
Message-ID: <20190825132845.GB23073@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 6/6] net: dsa: clear VLAN flags for CPU port
In-Reply-To: <CA+h21hpML8GLQ-n5AsJ4+BAYy8dwTQuAGYRwcZrwHxY9wy=6aQ@mail.gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-7-vivien.didelot@gmail.com>
 <aee63928-a99e-3849-c8b4-dee9b660247c@gmail.com>
 <3c88db34-464a-1ab7-a525-66791faad698@gmail.com>
 <CA+h21hpML8GLQ-n5AsJ4+BAYy8dwTQuAGYRwcZrwHxY9wy=6aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 22:53:08 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> Vivien, can't you just unset the PVID flag? Keeping the same
> tagged/untagged setting on ingress as on egress does make more sense.

Why not. I've sent a v2 with this single change.


Thanks,

	Vivien
