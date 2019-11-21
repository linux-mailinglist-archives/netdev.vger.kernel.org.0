Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A166104FF3
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKUKDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:03:43 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:39061 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfKUKDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:03:42 -0500
Received: by mail-pf1-f174.google.com with SMTP id x28so1414597pfo.6
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=65iHVro3BNR8Ku4frZfnL/k6cf3O15sJNdEGobAEz3E=;
        b=LjmlK/SvxdBhK5uwlg4uv8FbUb2/3hzJZQHwmvXRwxLuOug1ZWmeoEUS6CNXjF3BP2
         nkrP8+P1jPkh/orXUDzSsLtPbaKxwQnPXm2ITzKnqfYWF5qeQr1peWDcredVdiAWqjBr
         dcwYodA0eQaO41woQD3xNboLcB2X39W11RjQi5JLQHgG3rghwFf9D6X2N/cG6Iam3Wxq
         D0pfib431kpcny/L4sU8DcjDskQy+3pP38XA+hSvd1Vi6am5kqgDLW1IK3Qbvnlpafsa
         VSL1Nv7NiejVWFsSwTQ75f+W5yJkv/2QZkG8NbFVWS8myi7AYHQg0isLZn4JPbkA5jrA
         9/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=65iHVro3BNR8Ku4frZfnL/k6cf3O15sJNdEGobAEz3E=;
        b=agU4/H0M8spu+udo7ehlZnx3L04e5fHU7AwDNIHsMkb1AkORd8VmVHQyjoV7uFcOwO
         JcJN+RpXkMwRrQUcb9hKkpIiPSboTiIZQ8ODzOaSPRSgE4fNDuPhYXLZkjxbrrREnokh
         0IqdGPVdfjC7jwy4ME8dbvT+RTRw2H7QOaaoJLNYTJhEplreAL0xH0AaniaFcnDSMqxQ
         rzyYKatyQKpqCV3bYnx8jehJezhdchPYH6muQPckJ1SqRWAGTVhoPje6ptJosiZxPPvw
         SOjmG6PdXkxyW9DZtYwh6/zsTE5tDTafxXBpasyb5ATDzVoRUWPL5XOb+WXEAU91YULV
         a70A==
X-Gm-Message-State: APjAAAWQhHtbuRoYQmI3EEi1Eyw7qd46okRZdGlM7EvDzmBAuodYEixp
        aNYknyxDj1gZZDJVkI+hSouol81+
X-Google-Smtp-Source: APXvYqwHsb3hmhjXv1rjgWxuH6SLSdRxnCT/Cqrs5eo0Rz1lEOS9Eiy2zErZk1dcxm5GaC/DuuAAwQ==
X-Received: by 2002:a63:f658:: with SMTP id u24mr8280674pgj.129.1574330617318;
        Thu, 21 Nov 2019 02:03:37 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f25sm2842894pfk.10.2019.11.21.02.03.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:03:36 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: [PATCHv2 net-next 0/4] net: sched: support vxlan and erspan options
Date:   Thu, 21 Nov 2019 18:03:25 +0800
Message-Id: <cover.1574330535.git.lucien.xin@gmail.com>
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

v1->v2:
  - see each patch changelog.

Xin Long (4):
  net: sched: add vxlan option support to act_tunnel_key
  net: sched: add erspan option support to act_tunnel_key
  net: sched: allow flower to match vxlan options
  net: sched: allow flower to match erspan options

 include/uapi/linux/pkt_cls.h              |  29 ++++
 include/uapi/linux/tc_act/tc_tunnel_key.h |  29 ++++
 net/sched/act_tunnel_key.c                | 203 +++++++++++++++++++++++-
 net/sched/cls_flower.c                    | 254 ++++++++++++++++++++++++++++++
 4 files changed, 514 insertions(+), 1 deletion(-)

-- 
2.1.0

