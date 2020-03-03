Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4717839C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbgCCUFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:05:10 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38883 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgCCUFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:05:09 -0500
Received: by mail-qk1-f193.google.com with SMTP id h22so4731006qke.5;
        Tue, 03 Mar 2020 12:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2K6BAwGj3FC5N5znWE5+GD6Ye83Rz4tnyHf9aqTUl8=;
        b=tgU0aql004PTeTTbF6pSvwuD2O8vinGL33sbkqU2otxXvjK1VeIP/tc3LWLM+6hi3C
         MVZ6mZil+KWym7pVVqyLqD+liZVZxZUj4ICKTP7C1NjwONnJOYWiJmybGheH8xMxoysR
         F31xnJ0t4jhU6Vde5O/39yCneFpzg63gD+bN8CRA555HOT9B47vDcrTysZMYGmpxuQX6
         AERGQrDMv6ZVA8L8wAtiMrvEJFMky2T+oo+K4pScD0Exd2xtyeYA6jCom0WIqVrZyayd
         ZrnM4u9KpiByj7Jqjd2igZ+9ZkaYvChsLdd4f0eIkJBBkNSlTuDBYzuIJmLjW+GvyVqj
         Mg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2K6BAwGj3FC5N5znWE5+GD6Ye83Rz4tnyHf9aqTUl8=;
        b=cUD0R3lhXbib/ZujB8pVWWSVVUxhIovFhGRSt2tgYxKwj+fMjY5weFFBg/nngPDYik
         7NhBhEiG+54IxbRJHbrZp0j4es9zdYJDjp/7YaHZQOoa5Vjx8D4gse/ZEvNcfmEZhqKb
         DiywZE9iwTnfxWY/ajlfJ/5hz9j25ASrWDZ0rYh55i0fh0DB5ciyu6uJ3xojppo7VZck
         ZivhKRgkr96AXVFmR1GjyHcGjEru0RTk3zzwOfkqHyt8GGicwtJ2uCV8Bz8MrBRJJvGr
         VaeKxVOwztVObgZmnJhxyK6JlNrczKk6bToPGJnTsHWET0KzqXU4mVvQRIcdqkoyjQOB
         unbw==
X-Gm-Message-State: ANhLgQ13Vkz5AqG4cZaD74Ue/eUCce5eaKbqpvS8vDmgRrekoFXOadm1
        uN7Oz7Nlln1hmHHl7CmF9v1gPp3l
X-Google-Smtp-Source: ADFU+vuRuUUnfuIK2U0RZ3AMJJLlK8GM7piA4IPqD81BaS7i7+wPEfGdy9q11Wlz/YfZr1brfMaNZA==
X-Received: by 2002:a37:349:: with SMTP id 70mr5691931qkd.91.1583265906819;
        Tue, 03 Mar 2020 12:05:06 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:37b5:dd03:b905:30ea])
        by smtp.gmail.com with ESMTPSA id d7sm9846281qkg.62.2020.03.03.12.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 12:05:06 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next 0/3] add gso_size to __sk_buff
Date:   Tue,  3 Mar 2020 15:05:00 -0500
Message-Id: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

See first patch for details.

Patch split across three parts { kernel feature, uapi header, tools }
following the custom for such __sk_buff changes.

Willem de Bruijn (3):
  bpf: add gso_size to __sk_buff
  bpf: Sync uapi bpf.h to tools/
  selftests/bpf: test new __sk_buff field gso_size

 include/uapi/linux/bpf.h                      |  1 +
 net/bpf/test_run.c                            |  7 +++
 net/core/filter.c                             | 44 +++++++++++------
 tools/include/uapi/linux/bpf.h                |  1 +
 .../selftests/bpf/prog_tests/skb_ctx.c        |  1 +
 .../selftests/bpf/progs/test_skb_ctx.c        |  2 +
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 47 +++++++++++++++++++
 7 files changed, 89 insertions(+), 14 deletions(-)

-- 
2.25.0.265.gbab2e86ba0-goog

