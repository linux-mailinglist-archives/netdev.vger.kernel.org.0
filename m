Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C6D28EAB0
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 04:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbgJOCEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 22:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbgJOCEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 22:04:39 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AB8C0610DF
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:27:20 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z9so444998pfk.2
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Dq0fASL5YHiC4fXFKgVoJo/MQPES7hZ5XSaulXDX4Og=;
        b=UmWZpGFFk2X8sYAycPyfVImcPpoRKiamxUHkOqTd7fWPUkbqPfwJ1cg7PrIBH+aeMx
         SHh9U+1FpjSeQ0vfyISb1sdNkWhZWLmACCOizREz5nHUKm3CuEik3zuwEjvHJy9wgBRG
         Q8qIoL/9DJAdoAD6u1KJL4No7WareTTZNSOisaNVy14mNsFE/LHb2zjPnurqMH9t0bvx
         OF3uOegcSpxFlhsfuNUJyuM+jDrhDluTFUPk3aTDif7xk/eRVfTxYE3SfW5pnDlcYlkP
         auS4MvgeOK6wb+OiBomerUk7ZLxEuR1OT5QRX9sH/2WWLjqMgWHlDPhKTKwb1EMIvjX3
         rbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Dq0fASL5YHiC4fXFKgVoJo/MQPES7hZ5XSaulXDX4Og=;
        b=rihsZKDRjWxVoCGp6VUxzFFn2Fjfg26M+qD0IUiQNiAZwbQh21dsH5CgQjqr0yhgC1
         x1XDo0mdqL3664CCcTCFSEMwGxZPZ/OQysg8nJaq2hPMCAoc+dRkqyRybxDboxoKJFHW
         8G9K+c9U7clKQTHHzQun+2jpRDN8J/uRiW+gPHTvE2QCbQetiW85f5eZstBDj6PBnhzE
         ipLktnxlxRXGFysux8J25FqM7wkfEpCsYhmGSz8YWyFFfgsb/oPWs0UUMdWddwPsOGhb
         AjTkpvsxkudwhhPa/CC1YaNTegECtFx3uSqOcIilhrdxfIR+Rg+g6ETqxlaJ4UeyLFR7
         5l1w==
X-Gm-Message-State: AOAM5333DkS5cI9fuxAYikvGotqoaoOdu5WmT4B4IOfZstsDbZgOdtNy
        NChu0FH6SRHlYAdITSQn5UHS8W7qHWtlir3+pu08r5QdHyiEcnmMH2QHv2UjNLpmn1cwQzoBGH1
        ui//A/K7M5LReAfG3gqKQTZ8SZPppfXZpKB+3GD20IlkYhbqDKNOJMwvgqKde9xpQSTlFfHpu
X-Google-Smtp-Source: ABdhPJzHyM6/KQkf+3eop4S8tzflfTlrr3LjrCGtyOGaDH/l8Yr4Z7fqc2BShPqudoqphe838V1FI+c8ytfPhZ8B
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:8345:b029:d3:d5f6:f7ad with
 SMTP id z5-20020a1709028345b02900d3d5f6f7admr998994pln.59.1602714439605; Wed,
 14 Oct 2020 15:27:19 -0700 (PDT)
Date:   Wed, 14 Oct 2020 15:27:11 -0700
Message-Id: <20201014222715.83445-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v4 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v3:
Patch 1: Avoid long condition in describe_device when verifying size of option and option length,
        apply byteswap to constant when verifying raw addressing feature mask so conversion can be
	done at compile time,
        use dev_warn & print bad params for raw addressing feature mask errors,
        use dev_dbg for unrecognized oprion error,
        fix alignment.
Patch 2: Fix error path where page allocation fails during
	gve_prefill_rx_pages.
	Add function gve_rx_unfill_pages to herlp clean up rx _rings.
Patch 3: Fix double space,
        simplify check to fit packet into half page & use mtu, not max_mtu,
        remove unncessary parens,
        add missing empty line,
        correct segments spelling,
        add Buffer refilling mechanism for RDA: return budget to trigger napi reschedule,
        remove  unnecessary parens.
Patch 4: Fix double space.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h        |  40 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  70 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 366 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 205 +++++++++--
 7 files changed, 574 insertions(+), 152 deletions(-)

-- 
2.28.0.1011.ga647a8990f-goog

