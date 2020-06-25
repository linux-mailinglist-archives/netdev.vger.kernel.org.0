Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748C620A668
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390424AbgFYUMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:12:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390360AbgFYUMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593115932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iBtEMSCqqwF2ous8/euoABiQZsWtPIJIzCTYf75JDC4=;
        b=KOjFXTCijFPP2y5U36YkZ4nDZT1UDacfBQj10tw3JR88cTDIImMkSgrxZsJZSXk1/G+yW/
        I3pTNvfUjNsCn+HjBWcL3DCbCxoRl/xKSpy1P2E+twZrSRtSAK2k66BPTuDX54z95DzMYi
        J8JqsALzskg8VR8nFxMT2qTh+ujC9pA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-TrmwAKoOMuKbZL-V3YJuZg-1; Thu, 25 Jun 2020 16:12:10 -0400
X-MC-Unique: TrmwAKoOMuKbZL-V3YJuZg-1
Received: by mail-qt1-f197.google.com with SMTP id b1so4858770qti.4
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=iBtEMSCqqwF2ous8/euoABiQZsWtPIJIzCTYf75JDC4=;
        b=Fxaulg+DckdTNsR4RQGBbadOqIIhuNhNVIe6s/ITm/D+UM9OKAwQ/v33DGD+dcYUYd
         e9V9BveqVMMXGia5mxq12NB5z4M/p90zyR5YJCHfWbyx5BC+ObyMEKSosw4V4ZX+6BkI
         Q9ImWVpsQJP5/oY1Odygzc15Dy1o646BWvp0/iX0nPo13FYl/V1HkRd6ZaJ+ZjW/l+u0
         TIjx5M2JyqfdbNMbNImyHd2zwVBv5lnjQkMMCA2MLbNp6sREJhIif/4us97wO9Mti7+0
         Vp4mkN0pDq6WzS2rFMSHxMR1RG4SDqkkB27S7/VzLB5T1lfDu2MLRxOqJnWQkbbqcdV/
         yRSw==
X-Gm-Message-State: AOAM530UiiaCqC8r2vxlYuSzVJGVI0mmYkowk4wGPo21IkFcGK/YPuL2
        jdiKL9sUwX/g7SvqWYeWHn3Wm6VLziP4AgN87WKyAEL+GkEx/G3R1Qc6YKtnCa3ALemg81qukVN
        iVwZaG2J1i6TI+TLy
X-Received: by 2002:aed:35d8:: with SMTP id d24mr23150762qte.246.1593115929546;
        Thu, 25 Jun 2020 13:12:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyxhLCgg5JPGhq1a2rfL0Ro5fph9NDD2W2NBFhMnORhzlyx7accvwmYxH1iKAGUHZ5C8I0bQ==
X-Received: by 2002:aed:35d8:: with SMTP id d24mr23150748qte.246.1593115929331;
        Thu, 25 Jun 2020 13:12:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q194sm2403456qke.90.2020.06.25.13.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:12:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 22C231814F9; Thu, 25 Jun 2020 22:12:06 +0200 (CEST)
Subject: [PATCH net 0/3] sched: A couple of fixes for sch_cake
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 22:12:06 +0200
Message-ID: <159311592607.207748.5904268231642411759.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave

This series contains a couple of fixes for diffserv handling in sch_cake that
provide a nice speedup (with a somewhat pedantic nit fix tacked on to the end).

Not quite sure about whether this should go to stable; it does provide a nice
speedup, but it's not strictly a fix in the "correctness" sense. I lean towards
including this in stable as well, since our most important consumer of that
(OpenWrt) is likely to backport the series anyway.

-Toke

---

Ilya Ponetayev (1):
      sch_cake: don't try to reallocate or unshare skb unconditionally

Toke Høiland-Jørgensen (2):
      sch_cake: don't call diffserv parsing code when it is not needed
      sch_cake: fix a few style nits


 net/sched/sch_cake.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

