Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6698020B237
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgFZNLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 09:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFZNLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 09:11:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06FFC08C5DB
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 06:11:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h22so3122475lji.9
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 06:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ykHvsTrqoFALeQLAnXWhfrYyHVdyurhRXFO7SGklR3U=;
        b=ZlHIlLXUkTteChc9njF9k76HLkkYX12vEgnIvEse4tOSY3NFYFNPJ/IJuqIFc/caDU
         pDqHNIZlCUd5EBPopgwW/61o6yZufgMNiSKVW8/L6OyGsaxx89AMkx3BZX3M6djMTwpj
         RVszREiLpf/GuxyB6srcuxJYPLnzbJWMJaQDpvTqvpUoq1DfbbE1syU3UuctGVkqhxpM
         NL4gD/qlkSdTQZ7XkUVr00aQiv02F07Oc2EU1meHKhGrtZcJk2y94d8ceOhoiEj+oHR5
         qRj71Nt1b/txhSZvxhLW1k4IaEQP/bgt0nsMd0FKXumJGhCmLHyrIwDe1Da8Bt5LP4KN
         /06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ykHvsTrqoFALeQLAnXWhfrYyHVdyurhRXFO7SGklR3U=;
        b=mR2aB0iM1cpUIFpYaloPwcJC7bmwq9Ghx7nTLEPILXsW+c9/PnR5Cot1hsCJ9hP6p0
         I95aPkjyOE/SY7jFB+YLLbJaNIA1DfmJDGqfWaCoorDnTzq5yoZVdOX/aYTKGF4OacEB
         oensD2a4C3s3Z8+xonhz9pRJ0dopc6GsIH+wfAghySuTsBLD0NmYD2rthFyaBy0B7Vby
         4gAsePaD8+gPJ8iGpuPZFKAlnbTkglEXR5hPpTT/l+JApxgc74HcaiVVu+VzIkVftWPL
         oUE2tAQAEphN2j15vZ3go8kcxdZaLv0SKAEs3wis++Tarb2J9GR0zu89Uxd3J5HUva5+
         JPrg==
X-Gm-Message-State: AOAM533uwW3OkSTiKL8ThTZ0hKP7jf1WDvouKLapok9PHINVtM2oN4YN
        DrHKmRwFMCZNbLCcMwWW9tlWEhz5PPk=
X-Google-Smtp-Source: ABdhPJytdicbWQStHtdZwj3lg+5v5M/MlJjlKPxCcX4fuJA9l2DbvUZURhaCc97nc8P3PPVFceLcgQ==
X-Received: by 2002:a2e:8747:: with SMTP id q7mr1328970ljj.459.1593177111264;
        Fri, 26 Jun 2020 06:11:51 -0700 (PDT)
Received: from jonathartonsmbp.lan (83-245-237-85-nat-p.elisa-mobile.fi. [83.245.237.85])
        by smtp.gmail.com with ESMTPSA id y188sm7910691lfc.36.2020.06.26.06.11.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 06:11:50 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.5\))
Subject: Re: [Cake] [PATCH net-next 1/5] sch_cake: fix IP protocol handling in
 the presence of VLAN tags
From:   Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
Date:   Fri, 26 Jun 2020 16:11:49 +0300
Cc:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>, cake@lists.bufferbloat.net,
        netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <78C16717-5EB2-49BF-A377-21A9B22662E1@gmail.com>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
 <159308610390.190211.17831843954243284203.stgit@toke.dk>
 <20200625.122945.321093402617646704.davem@davemloft.net>
 <87k0zuj50u.fsf@toke.dk>
 <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
X-Mailer: Apple Mail (2.3445.9.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke has already replied, but:

> Sure, my proposal does not cover the problem of mangling the CE bit =
inside
> VLAN-tagged packets, i.e. if we should understand if qdiscs should =
allow
> it or not.

This is clearly wrong-headed by itself.

Everything I've heard about VLAN tags thus far indicates that they =
should be *transparent* to nodes which don't care about them; they =
determine where the packet goes within the LAN, but not how it behaves.  =
In particular this means that AQM should be able to apply congestion =
control signals to them in the normal way, by modifying the ECN field of =
the IP header encapsulated within.

The most I would entertain is to incorporate a VLAN tag into the hashes =
that Cake uses to distinguish hosts and/or flows.  This would account =
for the case where two hosts on different VLANs of the same physical =
network have the same IP address.

 - Jonathan Morton

