Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C219102088
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfKSJb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:31:58 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:37382 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfKSJb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:31:58 -0500
Received: by mail-pg1-f180.google.com with SMTP id b10so2556139pgd.4
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6shmeHUlFkEjtkAoOk9b9A1fqjD0RCSUtm9CSQv4KmA=;
        b=WHaMcdUbPDQFLdgM4UoIzUoPurDOYNDVFoIp32r12AiHAAbFmAdEpu+hh3ogbMWUIr
         KXsinAy3LICRaGwQ0sQ/haSRMmnJ7VtY7Jja1cm+xPIbV4cKZvVLkaou5XhxGgsaHspQ
         GOkWCD4j13cA4yAyahKw/viXlqCbgox7wvNnvBzag8KqPiuqUDAr10BcjsaGtOWJ0Jhk
         /Z9n4VyXTV5c3kdaguw4nJOy/Py8sdaoLNYFewXYEzdBjbxKHb1h8BhC0aRrg7hj9Xjr
         mvLA9YPfSdWjKprwVB54nSfLiNUf2LsLeJGDjm0Dfcd4A2r/p/BY8AcOWjtIwXvBA2iH
         I8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6shmeHUlFkEjtkAoOk9b9A1fqjD0RCSUtm9CSQv4KmA=;
        b=aIgkllXZtZbBzP2x39jbOspMHlfAm/CBsk70Udj5C7L0PQG5opUtzpgQ1fQzppT0Ru
         c79iXlMXhXXl57eJ96m6VeoKje3cqXxPWPu2hywLLnJoabiDc0NF88YCQgxna/VTP4Q9
         ejSmVIvFq3J7VoXez8dT7J5AMXxu/6zFzaPGcLO/qaN9Mz8k+MpV/ozg6cBk0tmMAt40
         Awh1ZChFp7x00kL6YeK8hJMWwxXm2XOA5pAOZ1FdDegOrFQX5OaEGCyHnqNhrpLkUCqP
         jEL5XMOZcHgtg5sbPrim4wjmuvW59xstqaNQ6TiGTR03KaSotFRPD2WzbGK7dca/9nz8
         fDcA==
X-Gm-Message-State: APjAAAXUO0drE6cB44pRj6+sbxvRHGYqt+ZCHfWokI5/Kf5KuwM+qjDu
        pz+b+jUeg9F4UGj8cuq1LZUmS0OB
X-Google-Smtp-Source: APXvYqxGfKm6SpcN7I5OdUTKbZEmnhA9n4DjKRcZlJGYp5Q/BmuDD+9j+9oDW8J+iq8zTqRcYm4lEw==
X-Received: by 2002:a62:ea1a:: with SMTP id t26mr4552149pfh.14.1574155917432;
        Tue, 19 Nov 2019 01:31:57 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x190sm26158894pfc.89.2019.11.19.01.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 01:31:56 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com
Subject: [PATCH net-next 0/4] net: sched: support vxlan and erspan options
Date:   Tue, 19 Nov 2019 17:31:45 +0800
Message-Id: <cover.1574155869.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to add vxlan and erspan options support in
cls_flower and act_tunnel_key. The form is pretty much like
geneve_opts in:

  https://patchwork.ozlabs.org/patch/935272/
  https://patchwork.ozlabs.org/patch/954564/

but only one option is allowed for vxlan and erspan.

Xin Long (4):
  net: sched: add vxlan option support to act_tunnel_key
  net: sched: add erspan option support to act_tunnel_key
  net: sched: allow flower to match vxlan options
  net: sched: allow flower to match erspan options

 include/uapi/linux/pkt_cls.h              |  29 ++++
 include/uapi/linux/tc_act/tc_tunnel_key.h |  29 ++++
 net/sched/act_tunnel_key.c                | 191 +++++++++++++++++++++-
 net/sched/cls_flower.c                    | 252 ++++++++++++++++++++++++++++++
 4 files changed, 500 insertions(+), 1 deletion(-)

-- 
2.1.0

