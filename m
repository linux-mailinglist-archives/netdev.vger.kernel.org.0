Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A06AD004
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCFVRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCFVRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:17:38 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79123A850
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:17:36 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id j2so10221164wrh.9
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 13:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678137455;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vubP3m1jFC3igbCdV15GkqxPvGr15BckGHuPQAoQN50=;
        b=Xwsn7MmOXgAgXjOjIFXU+K/7Qs59KzJA7OsAv5slODG2fTY5HD9MR7Ds+YxZbFW/LC
         EksIWl1ci4W+f2WqD5FHVfA41WDfhjsocHWOe0Nuk2bK5WN0LOgvAli6KF/EMieSyjci
         uOM7X+3UTVB7Q4vdJ1lfnfCyCab8Qi/0J4xQyb7tRUrD5rCEqAiMjSd9asxKSl8dJ1Ve
         6mD4xTU92HFKHCpX667T9+k+v48Lx2WiszXZ86/8fhvFwKfxhsXgfJB6oVXfIYLxkDDj
         NEJAhGpnGJ4Mze7na+Yvec4l/k7dJYl2Maca5gbqPjXecPx0SGVfztrI42uBe72xHIXj
         9IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678137455;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vubP3m1jFC3igbCdV15GkqxPvGr15BckGHuPQAoQN50=;
        b=D2AHSS+nj47qQYwreZ59JxL5s6pUxSmo28CvrmAcxVK+ToWrMWeEx+N1k0K3C9wzCT
         kk45yWg5br9txHlATYFtmvydg+JnPgK3U5WAJYHYCIMy2D2/jHCtW5n4wczVSzoTneSU
         yHvSfOE659qdKswzzGcZRFEmz6o7hys4b0G3+bR8+5L1MJpmOHGXZpUzVxzND8EYdsSf
         TeGYwNqGF//+5SG8yHmZ5Wb5RdgFqWzOrM6I/Ib7SIlYtyV1FtpPCcQAHCXMHn2ntD4R
         DX/4ujb+dBAi+xCsrAkdBUn7eftUg2TFxY4x0n24vboQeHAd2lOpmAKCjYY0PVHISYCf
         e6Uw==
X-Gm-Message-State: AO0yUKXjRAkFruvzrAc0SWitT3HrDTOfGVqr+rBFlWJtZt0Mt6JjMk0j
        f2xOr9jNEehGEdVtycysFBzKU++gMGo=
X-Google-Smtp-Source: AK7set9AFQj+/1PA0Utc9rtqH+Rifg7dc7149WIbF8IVXPD/Ymf58TEiggmvh1XnpUBIGScqgLzi9Q==
X-Received: by 2002:adf:ee4c:0:b0:2cd:8237:345b with SMTP id w12-20020adfee4c000000b002cd8237345bmr8645518wro.9.1678137454850;
        Mon, 06 Mar 2023 13:17:34 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bf4:7d00:9590:4142:18ea:aa32? (dynamic-2a01-0c22-7bf4-7d00-9590-4142-18ea-aa32.c22.pool.telefonica.de. [2a01:c22:7bf4:7d00:9590:4142:18ea:aa32])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600000cb00b002c3f03d8851sm10531983wrx.16.2023.03.06.13.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 13:17:34 -0800 (PST)
Message-ID: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
Date:   Mon, 6 Mar 2023 22:17:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/6] r8169: disable ASPM during NAPI poll
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a rework of ideas from Kai-Heng on how to avoid the known
ASPM issues whilst still allowing for a maximum of ASPM-related power
savings. As a prerequisite some locking is added first.

Heiner Kallweit (6):
  r8169: use spinlock to protect mac ocp register access
  r8169: use spinlock to protect access to registers Config2 and Config5
  r8169: enable cfg9346 config register access in atomic context
  r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
  r8169: disable ASPM during NAPI poll
  r8169: remove ASPM restrictions now that ASPM is disabled during NAPI
    poll

 drivers/net/ethernet/realtek/r8169_main.c | 145 +++++++++++++++-------
 1 file changed, 100 insertions(+), 45 deletions(-)

-- 
2.39.2
