Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD942E130
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhJNS2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhJNS2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:28:47 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB8EC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:26:42 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id q189so16882713ybq.1
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LgTnr/MkN1YZYK7RKoXkTgRbPOJFfj7z+dc2sz9GtK4=;
        b=NaCCGsBfJbrVLqB90BJM/HMqnww3k5b+fnQHCas+XSx9+NIKtSRYh9EPynIdyI1FLs
         GGVgPTzKETZjrIBCPT5RXQGf7isceNfCpPouWhnPdBesvGGixuO33g7/mO5VDXwvghB+
         +TkTnjfeUhUsTMwIXuOfN4hsTjW4B6CL01g8BttSoZyt4WBro08o4JYx6pZczOOrIdfd
         yNZ6gXrpH5r73DU+5smSx5pwMoNcTaaZQLV5PvTT0juYr6v3N7Z78vB0X1YYPP9IxrzW
         YGGU1pfl5hG279GvmLBpDMVJeBF14CQY4Tf8rgRIle2n+1g4MzoAzvjzT9GNILgIYCiR
         Apvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LgTnr/MkN1YZYK7RKoXkTgRbPOJFfj7z+dc2sz9GtK4=;
        b=PmMjfr0pnH3ZZXu5eM44ns6/x30+QXQAufCQlQyZ/lvQDdTsWKCHRdhcKf3n8SWSD2
         QE/Qj2pT00xOz6O8HP4g81nwZYXXjr1plFVeM1Ke9/ifgfuCDdAXo/bCDYE3Nvi2AupZ
         qbC02/ILajH6Z93hK0xDjkqnhPB81VmXyyLImZTiFVWfM7ptihBUrGgoy/KygSIVRpRM
         R8c7202KOaE7rZpQLtaVSON5YBsztyPyoxk+tAwtAKh+9vnvjlrpXOxTxsU2+It8x02J
         YwCwEKillf5VnF6QQCZ/1KdXxPlAegNc57gwgyRXwgLT2Swzr2MI2YiK1/p7ZeGLTxVm
         B8PQ==
X-Gm-Message-State: AOAM530w/FQIqvJor0mKJSiDBfiGiWwdX16mYqAR6maduYx8lidR9UV/
        6sKiUz1zKw44/NCUi4jJqUY/NWJh0plISkW/OQ1LvA==
X-Google-Smtp-Source: ABdhPJzmgRB7i4XKtaZ1ziigIc6twHuvRiS/uGBwbq/+E8pGsaAn7rUvhvmgXi60uTRaCdZzL59GUSJPapuocKAbYOY=
X-Received: by 2002:a25:698f:: with SMTP id e137mr7762090ybc.323.1634236001671;
 Thu, 14 Oct 2021 11:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
 <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
 <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
 <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
 <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
 <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
 <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
 <17c7be50990.d8ff97ac1139678.6280958386678329804@shytyi.net> <17c7bf4fe17.10fe56af01139851.4883748910080031944@shytyi.net>
In-Reply-To: <17c7bf4fe17.10fe56af01139851.4883748910080031944@shytyi.net>
From:   Erik Kline <ek@google.com>
Date:   Thu, 14 Oct 2021 11:26:30 -0700
Message-ID: <CAAedzxrXyfi4L9pGVLJhQFeajOmjOUJz10s3ohMnApsTi3OjiA@mail.gmail.com>
Subject: Re: [PATCH net-next V10] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        kuznet <kuznet@ms2.inr.ac.ru>, liuhangbin <liuhangbin@gmail.com>,
        davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jscherpelz <jscherpelz@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This patch solves "Race to the bottom"  problem  in  VSLAAC.

How exactly does this "solve" the fundamental problem?
