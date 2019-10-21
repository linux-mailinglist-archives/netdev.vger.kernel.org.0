Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7BBDF681
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbfJUUJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:09:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730104AbfJUUJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571688597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GRr4vvR8SMLlGLaQHrzXZBP/1GJnG/hY1lt52vVZ3iU=;
        b=Nm8h80lA+dV0iqaIGOyKgTd1y/VMRasZAPwov+a6GotDHffinJ1leDct0kL5bEG8xtDPXf
        wDqKatCVWlYZiGrx6NRtxRxn2Mu7NdHH5NllcmoUxEhrAyLjsmkngkobaiKoqhPsB7DcOC
        zhGwUmdzmtDiO91jbcUcCrT+cQJzw8o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-rdN_erQeOlyZUnGiLKqm0A-1; Mon, 21 Oct 2019 16:09:54 -0400
Received: by mail-wm1-f69.google.com with SMTP id c188so5079876wmd.9
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 13:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/hTnU2SL18HXqwrFfPhOqj3zVzoYeINRKnKQ1LCV8o0=;
        b=mD98Ixv/zk2Enb0X+qTev90mED3AB5WbQJW5TD/GtLgp3IkoznLdoaPVJF/VoJUNDx
         gj5LJ16JMSjlR4wk0vzdJFqSHUMjg6fmWSf6m08YqXhTd+VwyNRimM1MZtFU19x828QT
         iSTjyWEdh7/qnyn9kjNF1wb+MDadk0TJjshCr9p7TeeVMCiM+D6bAZDiBQVbHvtLWsjr
         0L79ZggLB1HitdA/9rJuHzF8o8K15EITQEJwzLvd7vWLvEf3srvosyBq+vEEpDivKiGy
         IR0iJJqGv7BEVkZ+NRtr73wPGRgVoT3/IhX9ZCUMV3ynHEn5Ty4E99jBVI+TUeRDHTg9
         BmWw==
X-Gm-Message-State: APjAAAVTlD8GNm50dfLmhGZlzI78Y9f/cL1/SLZfkZXsy/spHsQnhNZ7
        bUUS3Ulfo4mhKLjoqm9V3ECxXLw3JhD6GEeTK+6h5x+2tOh1435dsuvikDvCl7m7/tlhaOhDGnq
        pJmzO+3zaCbVhoKPb
X-Received: by 2002:a5d:5609:: with SMTP id l9mr55396wrv.113.1571688592855;
        Mon, 21 Oct 2019 13:09:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwfmZR8HzPKtuiCjhCoyN0qzOEXt2OB3PSphHLqsNZCKo7B/TomBYT5P/XX6wfn6KR6i/zXPQ==
X-Received: by 2002:a5d:5609:: with SMTP id l9mr55381wrv.113.1571688592582;
        Mon, 21 Oct 2019 13:09:52 -0700 (PDT)
Received: from turbo.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id l18sm20701933wrn.48.2019.10.21.13.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:09:51 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] ICMP flow improvements
Date:   Mon, 21 Oct 2019 22:09:44 +0200
Message-Id: <20191021200948.23775-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: rdN_erQeOlyZUnGiLKqm0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves the flow inspector handling of ICMP packets:
The first two patches just add some comments in the code which would have s=
aved
me a few minutes of time, and refactor a piece of code.
The third one adds to the flow inspector the capability to extract the
Identifier field, if present, so echo requests and replies are classified
as part of the same flow.
The fourth patch uses the function introduced earlier to the bonding driver=
,
so echo replies can be balanced across bonding slaves.

Matteo Croce (4):
  flow_dissector: add meaningful comments
  flow_dissector: skip the ICMP dissector for non ICMP packets
  flow_dissector: extract more ICMP information
  bonding: balance ICMP echoes in layer3+4 mode

 drivers/net/bonding/bond_main.c | 22 ++++++--
 include/net/flow_dissector.h    | 11 +++-
 net/core/flow_dissector.c       | 98 +++++++++++++++++++++++----------
 3 files changed, 95 insertions(+), 36 deletions(-)

--=20
2.21.0

