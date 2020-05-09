Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8D1CC397
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgEISCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 14:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727106AbgEISCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 14:02:36 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF70C05BD09
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 11:02:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id e9so5140929iok.9
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aqzi31B4lB7EoaZQ+FK0ZwwXEjmhbTHSk4NXHROzAKE=;
        b=rAMmZ2jVDzFafNNJaeH5i7FM2LLOBi5CfK8f1M+5DA/34UmGKnOgOjnnYlCFFFbjUU
         3GboYI/aDhyYWk4pPwxJ52LFHaE2w4WfJqxl8V7/UUj3UbxbwLG6fFZRs/On9OfLdt3l
         vzWdbL99CGuPrY0cl9QF6MFmkV2UWeL5jsjzbb7DO2Fu/+xJQDmdNMLJGDDzaKY3bEHD
         iBGPIK4r4NMSUDD0YKVTlA/tKiHdwyovggKYtR7XMUCTcDzT/00lVckzTDovtsaI8FwP
         Jm3tj4hwCKTn70rMBTpfg9pEISAWu7Z+nwps5pw0eHOHhb89N0e0cpbjcELm29p71bBV
         OGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aqzi31B4lB7EoaZQ+FK0ZwwXEjmhbTHSk4NXHROzAKE=;
        b=aWsDyH0G1xbiBRRzubQTnl+w5sK6HX/ZIDrk7uP7MpxBi7lVF1hND0UAFq/WfPFRtR
         BZtCgWw8v37vIHkEpPqrh+ibgmstl0FZcLOYgm18VSHp740IVzkbYi2iokR6u1UjtV3n
         f57gDMyQ1UhE/mYvLO3R80E5ZAqQ2aG0Tcwg/Kyt/vQbvjnDXYx+230DPL5DaifcVQOQ
         +wf0KvtNjYMNGRqRuL/pFSm+qrVe+L52fuWW9X8TXkjEhUzgdBdzmr8y0+2V/UkPzmnk
         U7QGXD3gY+yPHTTA6WmgbKGwxQV9cLEX6zmD9Hhys+L3Jz/vdtcZFBJJtqP0gplBI/37
         3N0g==
X-Gm-Message-State: AGi0PuYLqYq3whvCFSMrWOcIEtgeCp/AFpQVsrketmgH2FuZ36EZdq3R
        7ooaGX4xO9k4/OmVUTDYzhpbZEASzUy72Bhzd3d0DA==
X-Google-Smtp-Source: APiQypLSzXmQo2+CQ+YJm3gNvF6RrvZk/X6nVlc4jzEZN94Y7nyOEvJ5sCwPYx3oMkZPxHQDM49bP81GXtOO/607TuA=
X-Received: by 2002:a6b:bc85:: with SMTP id m127mr7945271iof.89.1589047355256;
 Sat, 09 May 2020 11:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200509052235.150348-1-zenczykowski@gmail.com>
 <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr> <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
In-Reply-To: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 11:02:23 -0700
Message-ID: <CANP3RGeonDWcL72_zGrucvsGpyZchDML5DzSbHgiJBDHX=Zn4A@mail.gmail.com>
Subject: Re: [PATCH] document danger of '-j REJECT'ing of '-m state INVALID' packets
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Side note, it doesn't have to be nearly as aggressive as the above.

With just:
  tc qdisc replace dev ifb0 root netem reorder 99.9% 0% delay 1s
I still see 169.58M @ 7.02MB/s in 26s:
  [24263:180667450] -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  [27:174654] -A INPUT -m state --state INVALID -j DROP
  [0:0] -A INPUT -p tcp -j REJECT --reject-with tcp-reset

And the connection still freezes without the INVALID/DROP rule (after
43MiB this time)
