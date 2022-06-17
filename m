Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E1454FC17
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiFQRT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiFQRT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:19:57 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F04B85D
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:19:56 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x138so4676919pfc.12
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EwrCxB3SoFQJXSsWWzF7eQZfRjToOi0C6T1fYQ5VxVw=;
        b=PxfChe6x6QSH8cqMh8VgZ7HDjTRF53kMZBfH9y2Q5N7+OJQHp6R94lgXRegh3VMids
         oHxUXDRVwbqoUKm97MuV8zXez4KogiU2Opo13VvLdZZ10jCAdHNy/SXWchHehSQU6CPn
         0eqhDDitqQzcQx7C2owdmHqFbn5NcUCG77maQv/dBUTRX7LN1dl2EMqX5fSxRn//YsRa
         21TRGiyUdAFmLkMYeLP6fsvZ3EOTSebKANLsSCDm1B+z+eOXoEFMi8gpfHdTEaaUGdss
         +nlJPWnrfzk+iEeLP1Ch7EKrSHdqlpJs9P11Fh3OklDYJp1CT7fzFIL/4ted54TbvQPK
         WWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EwrCxB3SoFQJXSsWWzF7eQZfRjToOi0C6T1fYQ5VxVw=;
        b=v5Px63fdh7OJm7+6K12j42e0Yzyfl9QZumceAJLbFxptaIm/RrM3x0jEP73BRzlWM1
         Q+WgjswFEnCxAHEYEKEWP0YWvZoIv+GMyG2toIDIh0FqjRXlA1W2O57hd7438wLRcELm
         FaleTYqTjl7arujVX6FnDE3GDXn/8w3zpBKK+YqN/wL+pbw8dEZYMHmvXOJU2vEDExqS
         qKpRXX+D5FQQaQU1ef33XWeaGlpqrbks3KAlZM8nIa7hJGDWu9cSRYOjr3+QyKsNgc+t
         4g91b0LcppD3XS6DJeeux/hLopThdpLcKbqd3RQw8CXoN+m3ysHdDH2256la+IPZ+WEq
         /nQA==
X-Gm-Message-State: AJIora/QVhwtJ3/a1kdwCTHm2LAIV6UI2aw4iBfgBR+q+x23Ju43UctR
        3OtinnTUqoEOYVGIiqf8FmP6ZInNuS1UW1V6
X-Google-Smtp-Source: AGRyM1vY5FEiKOkAD67v2sXX+QxLq5PpELb5DR1N59vkR33CdyVLNgmTo62hHjGdCHO1ZffmBxUG1g==
X-Received: by 2002:a63:4a4e:0:b0:401:baa6:d695 with SMTP id j14-20020a634a4e000000b00401baa6d695mr10173277pgl.259.1655486396117;
        Fri, 17 Jun 2022 10:19:56 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id o26-20020a63921a000000b00408a3724b38sm4074714pgd.76.2022.06.17.10.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:19:55 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 0/2] Fixes from LGTM
Date:   Fri, 17 Jun 2022 10:19:51 -0700
Message-Id: <20220617171953.38720-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ran LGTM (aka codeql) on iproute2 and it found a couple of
obvious poitential issues.

Stephen Hemminger (2):
  genl: fix duplicate include guard
  tc: declaration hides parameter

 genl/genl_utils.h |  4 ++--
 tc/f_basic.c      |  6 +++---
 tc/f_bpf.c        |  6 +++---
 tc/f_flower.c     | 14 +++++++-------
 tc/f_fw.c         |  6 +++---
 tc/f_matchall.c   |  6 +++---
 tc/f_route.c      |  6 +++---
 tc/f_rsvp.c       |  6 +++---
 8 files changed, 27 insertions(+), 27 deletions(-)

-- 
2.35.1

