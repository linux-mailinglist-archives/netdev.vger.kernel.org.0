Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FBF2F26B0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 04:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbhALD16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 22:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbhALD15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 22:27:57 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68193C061575;
        Mon, 11 Jan 2021 19:27:17 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id b64so752430qkc.12;
        Mon, 11 Jan 2021 19:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=W1IEn1o6eWOwCU+LqSBLdPY2mzZjKp1Qh5GWlNBzenQ=;
        b=WWfaItCu7eMkjGNiBic3Iz+khFM6SaikBC7i6LdeJiOODc6bg6MDvC2ShCF3Hl5ZTt
         jp/mlgW3trjRXruymsuSs5uLWwCrp2y+jViZ3gUFA888SdZSItK60yG3VAniBByGDhyG
         bG2ZnjURgWPbdagnrZtndw2zKRRQlXrRJpFK/wUx35Cxkgz+xcJJE4aC5tXchkO18zA/
         lfJU3P7BiCbdEAKhDbDHK+4SL2sVBCTpiB5kI1acpizjfT84MgCE/0X96lrLsQT/Movh
         Eh6ZsRGrg8pY+4RMQyn2Ri6ONsdbf6ZXe22v81MTxe+iibq3qhPVHXWVftY2k+gGdlAM
         /QhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=W1IEn1o6eWOwCU+LqSBLdPY2mzZjKp1Qh5GWlNBzenQ=;
        b=fvGAaixF/4V+aKW2fIEhWgIaC3YurcpienRgnG3ALGiSepR4IHsZdW87+Coc3SFa4X
         kxssUGhGadoNL5KPLbhdW5RN1mXbwmEh6uf/GlPKnaVwW93qPArk0ZY+6O1qcjlNWY2C
         sW/9qtAiBX6llJg3bJ18pkC3TK2y211sHo/zB2VV7ENVNpSYDI7TxID1fbPNPWHuA3ge
         ywQpzOR3OQKp68KJwxh/UNMwcfZt/FymF0LDUDPko/uVynW54/MUqBXIwqJb/oABFFQ8
         JxT5l6U5BAWDmo83HKjwlUEioQBs6MJeN6cSNehqXZcO00yIuNF7tG0rBz6mSD5Z097e
         HtUQ==
X-Gm-Message-State: AOAM53216ar5qH4fP3vPnuJTujOVUnSD5SGwi2kuDBrFjl15lJhD5M1D
        EHsdYjUlPayp6BuKWSokq2s=
X-Google-Smtp-Source: ABdhPJx5nCMD87uewGRBxnMpYljToVWREtfHtWs5iE9Z7JifFyPmgvQlgl0/wDDsfBqJjvSpEoTHKQ==
X-Received: by 2002:a05:620a:1256:: with SMTP id a22mr2542089qkl.484.1610422036661;
        Mon, 11 Jan 2021 19:27:16 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f016:2182:69ea:afba:d188:e39c])
        by smtp.gmail.com with ESMTPSA id n5sm829838qkh.126.2021.01.11.19.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 19:27:16 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id B3840C085D; Tue, 12 Jan 2021 00:27:13 -0300 (-03)
Date:   Tue, 12 Jan 2021 00:27:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     =?utf-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, vyasevich@gmail.com, rkovhaev@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: "general protection fault in
 sctp_ulpevent_notify_peer_addr_change" and "general protection fault in
 sctp_ulpevent_nofity_peer_addr_change" should share the same root cause
Message-ID: <20210112032713.GB2677@horizon.localdomain>
References: <CAD-N9QWDdRDiud42D8HMeRabqVvQ+Pbz=qgbOYrvpUvjRFp05Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-N9QWDdRDiud42D8HMeRabqVvQ+Pbz=qgbOYrvpUvjRFp05Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:18:00AM +0800, 慕冬亮 wrote:
> Dear developers,
> 
> I find that "general protection fault in l2cap_sock_getsockopt" and
> "general protection fault in sco_sock_getsockopt" may be duplicated
> bugs from the same root cause.
> 
> First, by comparing the PoC similarity after own minimization, we find
> they share the same PoC. Second, the stack traces for both bug reports
> are the same except for the last function. And the different last
> functions are due to a function name change (typo fix) from
> "sctp_ulpevent_nofity_peer_addr_change" to
> "sctp_ulpevent_notify_peer_addr_change"

Not sure where you saw stack traces with this sctp function in it, but
the syzkaller reports from 17 Feb 2020 are not related to SCTP.

The one on sco_sock_getsockopt() seems to be lack of parameter
validation: it doesn't check if optval is big enough when handling
BT_PHY (which has the same value as SCTP_STATUS). It seems also miss a
check on if level != SOL_BLUETOOTH, but I may be wrong here.

l2cap_sock_getsockopt also lacks checking optlen.

  Marcelo
