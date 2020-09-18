Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861A22703B7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIRSHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:07:25 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17056C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:07:25 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id w126so5258246qka.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=hYLWd9vyuyHv2gwxAXUYv1pRSJIhEfyLfgKWUmVW25A=;
        b=fgMpB4i3PoG926zg0tBE/PKftBZioM5KQu9qacZyYzPZAnbPl+1Iwb5MWRzGzwZV3Q
         OF7OohOLId8S1dX9JU/7NPzLbUMpxrUJZQXJQ3iH3DiBWdFTNuSqCm40ZW4zUDLgJFx0
         LEd92jG/0vF0xwwoICd0LlVrAMTzBqTkQ0rHedpM/sACRfjzprD/smETq0dP9ip8VlyV
         mpZNs2sFy0hk/hgfbgZPuCQjOaUH02ys+l+eLj92Nz79flk1BFAwPzglyFC+FUQSW8ky
         zNYHVJobUctJ5wN2MTnJPDBq9oYq6CS5w8qRm9xisqnUdmf9MYNl1RLjHUXP/u3q3lni
         CS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=hYLWd9vyuyHv2gwxAXUYv1pRSJIhEfyLfgKWUmVW25A=;
        b=fgU0AYPS2UUoiL9NA3LMigdZERYaKHNLsZ10wAEIunc9rXU+d/5ecxpIVPQj/9X62m
         eEdZML538n+jJ8hNb2qDELeiHn9HIz1sccaT8XGsP/RCsDFd1xyvXZJmtgEN9T5mST9B
         kPFhJKLVLloP/jqsf9YslH/Mh2LlFX4//hd/XHutK+lIovzz6G6buNkEMDwiv3oJOGk6
         KyrW0Jix0pQM+gDEy8sn0D7MzEsNie61mynxnNf7rFcL3Y5joi2DSDTbfTNC7IlVYmjs
         1GdstBNDXsjpcy28YPmIUMdJL60Jh58qoTHctpX1D+ZFH0vLHSDICoNAbht+wpahYJtJ
         Xp7Q==
X-Gm-Message-State: AOAM533rk2AenTmlmz3/CQYY5goWuQ8C0D0RHxc/g4PDIysCdNhSUv00
        og4CIw8kkHRK4i98U1n5vhB3sL4weB+Qs8bKYPUqiAJoONIgY66PW46DClu59Q2mnuQZoTB+VLx
        JUFS4BLAhDZex/H1ZB3eau98//rwbFpUcNy72Uob4s7KYir1XlLrBse2+lPdZF6BP7PQB99N6
X-Google-Smtp-Source: ABdhPJzmjDtbc4e/R8bkTjI6ZWR0bgBHNLV30mrUM6Wfk4gW/Ju/FM2sHvGaQD+mn0fBq/FIQqzXur5+2SQrzRNz
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a0c:ac44:: with SMTP id
 m4mr18421729qvb.50.1600452443959; Fri, 18 Sep 2020 11:07:23 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:07:17 -0700
Message-Id: <20200918180720.2080407-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next v1 0/3] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This  patch set introduces "raw addressing" mode to the GVE driver.
Previously (in "queue_page_list" or "qpl" mode), the driver would
pre-allocate and dma_map buffers to be used on egress and ingress.
On egress, it would copy data from the skb provided to the
pre-allocated buffers - this was expensive.
In raw addressing mode, the driver can avoid this copy and simply
dma_map the skb's data so that the NIC can use it.
On ingress, the driver passes buffers up to the networking stack and
then frees and reallocates buffers when necessary instead of using
skb_copy_to_linear_data.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

 drivers/net/ethernet/google/gve/gve.h        |  40 ++-
 drivers/net/ethernet/google/gve/gve_adminq.c |  61 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 342 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 207 +++++++++--
 7 files changed, 549 insertions(+), 146 deletions(-)

-- 
2.28.0.618.gf4bc123cb7-goog

