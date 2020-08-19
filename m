Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C258524A886
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHSVb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSVb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:31:27 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BADC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 14:31:27 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c6so21932508ilo.13
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 14:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Stl2EchNFv/3NOFNfXqabQGXyVzB7hWqOGSk3uDlk8E=;
        b=Y4GSxRU9QwWaVP8s/51s1fiEETzT7Bs4l5V9KG5uWGIpOU6fYr4HrU8ikIf91zM4/n
         52oG4Ug49M4A2rlP2A2wwlFIJSA2g5UDsSoYH7JQAjW1etf77k3cSH7+VuaG7j1mNNrT
         muBXER/PjegPSEgGUmaVsJ3dCcDoo7rYP38fDtbi+zpii6ad2QuvERLHYC8RRENFtgMA
         /k01FqinxQM4RLX+hGizXKyHAuSYcjJvUYpepSUGAuthtekKD75HVIeJuCOInxD1Ccq5
         itPd9OAfMnx7Yew+TWTV6Z4ghJoG8qgJqzRSQaThWeLxXkFGymnSYrb5ZgV05DMLBjGC
         nZ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Stl2EchNFv/3NOFNfXqabQGXyVzB7hWqOGSk3uDlk8E=;
        b=CDC7x0OSbtpSlvuw2xIzTaiOSHugDhDFxXLUoL04GhA0v+u/QOBSRlpEA0FZwPBbur
         O4YPSpNZItWU8V0A8Ej3SJfINQKdVs9/H1KY95Uj+21RmNR6FSf/QSh5ZC4P2sR52ytz
         RW3I1OgwnMUFqzQfGynZj6jtmetOw/vd9ugZDat5xI/OnNqeEt5tskm6gg26xOQWSOAm
         svb5wRc6Q+DdgcFIzy5Zj13kMeU79Moyq2oRITK1lVwSd3Jl/GZxF1K95hmkDSCbPq5y
         CwqMwsseYdzTZilFTaDYBeyFkSiKZ+ZUST4yEayPCK0sFG/59f64suzA44qBeby0NGsn
         izSw==
X-Gm-Message-State: AOAM5327hdqJHynvY2MXHi/o9GQyMA9/bQMWlP+5dny5YKiN0zozcOQg
        tkN2VWXEOprrUXIGgg19ElD/385EtZONgfOIbGzSwNE3DmoZYA==
X-Google-Smtp-Source: ABdhPJzW9dbqdA+DslVfu9aUv9gPEinp98hjBE5q6s8IC6bzBDlbs10szJWWquyO7mRyuS78yw33pA/3wHGqudGIgYY=
X-Received: by 2002:a05:6e02:e8d:: with SMTP id t13mr23442428ilj.211.1597872685896;
 Wed, 19 Aug 2020 14:31:25 -0700 (PDT)
MIME-Version: 1.0
From:   Denis Gubin <denis.gubin@gmail.com>
Date:   Thu, 20 Aug 2020 00:30:49 +0300
Message-ID: <CAE_-sdmwbA-Otz1a__tQrTB7jT53b7j0PB2q7xPV6MYLrY5YGg@mail.gmail.com>
Subject: tc filter by source port and destination port strange offset
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear colleagues,

There are filters.
Let's have a look on it.

Pretty mode showing:

tc -p filter show dev ens5 parent ffff:

filter protocol ip pref 49146 u32 chain 0
filter protocol ip pref 49146 u32 chain 0 fh 806: ht divisor 1
filter protocol ip pref 49146 u32 chain 0 fh 806::800 order 2048 key
ht 806 bkt 0 terminal flowid ??? not_in_hw
  match IP protocol 16
  match dport 8080

Normal  mode showing:

tc filter show dev ens5 parent ffff:


filter protocol ip pref 49146 u32 chain 0
filter protocol ip pref 49146 u32 chain 0 fh 806: ht divisor 1
filter protocol ip pref 49146 u32 chain 0 fh 806::800 order 2048 key
ht 806 bkt 0 terminal flowid ??? not_in_hw
  match 00100000/00ff0000 at 8
  match 00001f90/0000ffff at 20


The string  "match 00100000/00ff0000 at 8" looks like is correct since
offset up 8 byte from IP Header point is "ip protocol field"

But string "match 00001f90/0000ffff at 20" looks like strange, doens't it?
Since 20 bytes offset up is IP Header "options field ip".

Could somebody explain it to me?

-- 
Best regards,
Denis Gubin
