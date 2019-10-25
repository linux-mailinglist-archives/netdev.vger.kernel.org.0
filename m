Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6FCE4C80
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504858AbfJYNmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:42:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33458 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504824AbfJYNmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 09:42:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so2438615wro.0
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 06:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RZsFj5mSHLDPjjfjXJ3TNXEUO7OqHqp8fru+xxws/tM=;
        b=ZhDSnzfh7B4uJ62zsXaqVGW4Au8iBBJ1wUiRaOIF6Kr16ReGw0YtsXjRWZ2u0IEQdm
         oQNaboyIeHxbkZT8bHZFa8IuVS0m0xWrOzhYOZtybO4qiMtvIEv1EMufeRIy4YykT2zy
         bV6uYl3YfCHfPzc1m23eY5Mce79GisIWGMjT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RZsFj5mSHLDPjjfjXJ3TNXEUO7OqHqp8fru+xxws/tM=;
        b=hIEQI4Yz9ABJLCnMIzLqkqNtERjNHlQ2zJp3CRv1z31p3zTsyS4YTKyScMGDC6S3bp
         Modpt+2u7XR0Glz7wetN6RtQHdHU0sTmF4x2x7J3LuNPy4Rx2LFSb7H8V/7iyUiZMQor
         IxyqoDUZ26L97XgfZ6escsqNLT7XRU7NR7Zse7R+xfbWZND0FBv3NObhJ9JRRhujdWiw
         nHy+tICETTOqS0R6SgCk6qlet36MbQ0DdBbukV/ez0yZRRavokQ+8ywuiyDYY1+i6Ecz
         stIeu7dUMXGxLPLnjbO0bcBTEkjjWY3GWieIKBVnzrW7154gz4P5JyaBR32RfD5Dk7ku
         245w==
X-Gm-Message-State: APjAAAXP7psoDTjMAPO9ZSwL6YBoW1qeGGqYMzMB7mGZSSM4YfB+F3up
        NcWYMSdGzLk00lyUfo950X0ke5ohckcnvw==
X-Google-Smtp-Source: APXvYqxJeHJ5GOyx5hF2JJ8W4vj16avyKvi1nOvY1+NwCXXu789wK5brJvb+yEKmgatOE1vZnZ9Ijw==
X-Received: by 2002:adf:9bdc:: with SMTP id e28mr2980294wrc.309.1572010956910;
        Fri, 25 Oct 2019 06:42:36 -0700 (PDT)
Received: from localhost.localdomain ([94.230.83.169])
        by smtp.gmail.com with ESMTPSA id v11sm2194730wrw.97.2019.10.25.06.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 06:42:36 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH bpf-next 0/2] test_bpf: Add an skb_segment test for a linear head_frag=0 skb whose gso_size was mangled
Date:   Fri, 25 Oct 2019 16:42:21 +0300
Message-Id: <20191025134223.2761-1-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a reproducer test that mimics the input skbs that lead to the BUG_ON
in skb_segment() which was fixed by commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list").

Shmulik Ladkani (2):
  test_bpf: Refactor test_skb_segment() to allow testing skb_segment()
    on numerous different skbs
  test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test

 lib/test_bpf.c | 112 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 103 insertions(+), 9 deletions(-)

-- 
2.17.1

