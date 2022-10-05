Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3005F50D5
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiJEIcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiJEIcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:32:39 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5DC6D563
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:32:38 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 2so9166836pgl.7
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 01:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/eytcqcN9ObTjJXf5sWWbGpgnvUxzBhOmrxffhLDb8A=;
        b=DG/kNFiVNEycPiKk3NuoWSHbut8wRcXmM6VuM1dkdcRMtRI9QpID7D9jy4bDNzUzfG
         Vxslk5P760O46JDAZgMwuSFsiBOo374uPHpgDE1/tmF7uj9Z+B5DM8ZWNhWKAEiqZgV8
         H36oluwI4ExV6UtwooRJOyEGpNlO7qsJjMw5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/eytcqcN9ObTjJXf5sWWbGpgnvUxzBhOmrxffhLDb8A=;
        b=07ED/BS/VVwBIGUbuIRBj3y7+sNI1/DmxIEf7+rEsvyrn4mPS3qjeXFCkCCg50guRt
         WUKkkfOa5TgXsMurQJXd88OnjLDO9qi4fjjY7k76RV2dEUwr5ERNSj0B4IDHdib7P9X5
         j/xOTKgCLlaoRoX4MmfTk8m26XQOAfKybaypYUpftXLxOy9DhoO01PZSGkTCShqL/j1o
         TV/cwF5rO1N0qk30s407LkvRvMS6eO3LV82mkG/7jRqUKYIK5T3UaHmA83xBPFibrPiA
         PjhaMujX9XIxYosiohcCLnceRwZKinx+GTHtYcYOEGb8aqbnc78hI1eDR+WP0y0dqMfr
         Oi0w==
X-Gm-Message-State: ACrzQf3ev+tbs0qfOP5MfSUmj8YaFK/hrNIKOBfyTkCIjPCgBr8RQZcz
        qG/u3yP9QRMlLTdMXJUaSZwC0g==
X-Google-Smtp-Source: AMsMyM4h7FqDzkyepaxhErmCqwlZbJPt0bfly91xvwlxEOAWVD/3M2M+654mqKzZT+9f3nZy8NqQLw==
X-Received: by 2002:a63:2c0b:0:b0:434:ebb6:7594 with SMTP id s11-20020a632c0b000000b00434ebb67594mr26209005pgs.245.1664958758170;
        Wed, 05 Oct 2022 01:32:38 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0017ec1b1bf9fsm5899320plb.217.2022.10.05.01.32.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 01:32:37 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue 0/3] i40e: Add an i40e_napi_poll tracepoint
Date:   Wed,  5 Oct 2022 01:31:40 -0700
Message-Id: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Debugging and tuning the NAPI and i40e NIC parameters can be a bit tricky
as there are many different options to test.

This change adds a tracepoint to i40e_napi_poll which exposes a lot of
helpful debug information for users who'd like to get a better
understanding of how their NIC is performing as they adjust various
parameters and tuning knobs.

Some tweaks to i40e to support this information are made along the way;
including a tweak to i40e_clean_tx_irq (and i40e_clean_xdp_tx_irq, etc)
which returns the actual number of packets processed.

Thanks,
Joe


Joe Damato (3):
  i40e: Store the irq number in i40e_q_vector
  i40e: i40e_clean_tx_irq returns work done
  i40e: Add i40e_napi_poll tracepoint

 drivers/net/ethernet/intel/i40e/i40e.h       |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c  |  1 +
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 50 ++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 27 +++++++++------
 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 12 +++----
 drivers/net/ethernet/intel/i40e/i40e_xsk.h   |  2 +-
 6 files changed, 75 insertions(+), 18 deletions(-)

-- 
2.7.4

