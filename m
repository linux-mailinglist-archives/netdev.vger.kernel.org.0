Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9457B625FD5
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiKKQwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKQww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:52:52 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203B4657D0
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:52:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u6so4642158plq.12
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z9pdYNMQkyz5HmBe8Ij+ELZlfWokTFiP+2A1uLvxzG8=;
        b=N8NJjdgbPsRXI24OfkyQMQwO+4RqWKSqX+/joMogYcKGQaoj1LP4/LjFeTCV6B9Qg3
         G17ipm8WL9T79Lst0ShfT+MqP3NzqbMUWGHaA69xhrU19SSyaITo2jdwa8sDfVn5mHDP
         NNeVC9KaJm4f0pa252JPG0TNec9n5x2Yk/opLaVepO5s24yWqtNLSYyCINbN9PogkxIv
         i1PU8dJ9s9FGDGQvjQxmFM3m0Y6e2ANxHZXsLVkTIYbTqmqhF4hpkP9AoQxRRq1gWbjz
         EvuYWqCsCX/vNmy8vcy95oLlkI6xCJWeRbaqxf4n5xKGxnWOULvPFG6krDs7sS/YM4il
         giUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9pdYNMQkyz5HmBe8Ij+ELZlfWokTFiP+2A1uLvxzG8=;
        b=uRe0lFYmQbwJ2+5Ee4IhKllEds9YCba0i8xVMsFHn9mLa5IyuECtkQt19+9BzFkWd0
         G4UKqcvUku4g0rr9JT/qFHbGXfdsOWg1hiCx4snMpuqlDcDtIeTygNfBBxWKRe48q67k
         7eS10nmQHpbnN0lVzArcEj2T45ZR8Z1psCcSoEPGLm1Ry2yKfRgdck2YcyGHTUFsns4l
         4ro+ZtavBT1bZ6Yh7d/Mc/0IoyBgqCVi75tCfiThRnOB4vT7ebQCsBnU1ujqoA+1cX9N
         Lv7kLvpTuSCd+BnaPGNoMmlNaX6JLCC9vFkKQxa5KgFosg8ntu5iRLGA5cab/0cnod4F
         AY6A==
X-Gm-Message-State: ANoB5pnL33MkO/b6W2rC3W8Vmj5E6ch9h28TQ3BGtzKceBrgnMdl55ZA
        PlWvuT3enRR0EyNkmL7TWSTZFopixYJIrw==
X-Google-Smtp-Source: AA0mqf537q8DTZYSBcbUtWa5wUUYC0TECWedjL5/J50QE8P7TiIjiUWW9zWRzMF7K5SnWdTEl7hgGg==
X-Received: by 2002:a17:902:f608:b0:17d:5e67:c523 with SMTP id n8-20020a170902f60800b0017d5e67c523mr3316925plg.115.1668185568212;
        Fri, 11 Nov 2022 08:52:48 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b00186b6a04636sm1932635plg.255.2022.11.11.08.52.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:52:47 -0800 (PST)
Date:   Fri, 11 Nov 2022 08:52:45 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216680] New: suspicious sock leak
Message-ID: <20221111085245.0c0cd18c@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 11 Nov 2022 13:59:04 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216680] New: suspicious sock leak


https://bugzilla.kernel.org/show_bug.cgi?id=3D216680

            Bug ID: 216680
           Summary: suspicious sock leak
           Product: Networking
           Version: 2.5
    Kernel Version: 4.18.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: bianmingkun@gmail.com
        Regression: No

1. A HTTP Server=EF=BC=8CI will insert a node to ebpf map(BPF_MAP_TYPE_LRU_=
HASH) by
BPF_MAP_UPDATE_ELEM when receving a "HTTP GET" packet,
ebpf map
key: cookie(by SO_COOKIE)
value: saddr sport daddr dport

2. I will delete the corresponding ebpf map node by "kprobe __sk_free" in e=
bpf.

3. Sending pressure "HTTP GET" to HTTP Server for a while=EF=BC=8Cthen stop=
 sending and
closing the HTTP Server, then wait a long time, we can not see any tcpinfo =
by
"netstat -anp", then error occurs=EF=BC=9A

   We can see some node which is not deleted by "bpftool map dump id **"=EF=
=BC=8C it
seems look like "sock leak", but the sockstat's inuse does not increase
quickly.

4. I did some more experiments by ebpf' kprobe, I find that a sock* does not
come int __sock_free, but the same sock* will be reused by another tcp
connection(the most frequent is "127.0.0.1") after a while.
   What I doubt is that why a new tcp connection can resue a old sock while=
 the
old sock does not come in __sk_free

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
