Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22CD1C42A9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgEDR0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbgEDR0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:26:05 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1458FC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:26:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d15so63798wrx.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=39a6a45aAhI37SBtghDGoyPPZUGcFGiRqSVaNvdGgcY=;
        b=kiqOtDeQl0yxJa8BxFwZsTrkIVFjBY8+zhTPq2S7+ArMT5cvnf66Jo0Mkx25BW4ljm
         LdyufEEqGZgM33HS2urc3LD31rSU741cd51QbDdEvI7sTDsArvRGOhyra36JO/b++JY8
         AG6QNuu+LVGsXEGLLNmDNrUG0bhmAwB3SMzbkhIJrMj4ByEqPv+iDCnFvx2mMhFPJd1r
         5tElpwGE2wHtdufOy+4C6Lc1+dgataW2ihacod/MIbkTq6PvUYCbTLjzGxo4JnUfnNi/
         HLv/68KM1kBHp6sZ3cgHPEGOr25iI6s1MBFdc6Wh11w/9EmRWK/A+57OSBYUWshxwr0J
         vUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=39a6a45aAhI37SBtghDGoyPPZUGcFGiRqSVaNvdGgcY=;
        b=gNNB3Vl9dWnFDy5KZGoFVWN5CeDlSMLWhf6HZvR14QH7b50HmkM2aVSBtDkdDxfUtn
         W7yHNIrbN3oqmCPgDq0kNKvjl4cNhRsD1OKztMuBp9y5dbAEwHfnGMU9+FDn4ieAIgQk
         K0F697k3Uw8WPcP4lSPv/nOxSl9sGrcRfHQLxUw5lXda2cbl+g2sTv6zSPsgSX/jaq56
         viiL3B/UntwWIF5cHz1Zj3VL9enNmhKuv2B32bNxqa2CzTvdt+sF0YWMa/AKXsbtIJ2m
         rwEF2P8a5DAxDj9J3ygOU8kKg54dRdphztEDJNGNL/oV/+bZEi90zHhOVHHMAi2sEHqo
         ym3w==
X-Gm-Message-State: AGi0Pua2BUobB76X1dwHsJhHJ2gi1DigY/dMnUjchV9rBgsgSodbnZoa
        zfO4uCymDh0I3DvWZnt8NDUGfTg2
X-Google-Smtp-Source: APiQypI+IFt2aHXbPlcZsh9k8lCx/QGcxu8n6Or9OAWn+0ooR2Kr8yWvTh+1+9CqnTBknHHVZeWh1g==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr383162wrp.140.1588613163574;
        Mon, 04 May 2020 10:26:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:c500:c07a:3448:98ce:439e? (p200300EA8F43C500C07A344898CE439E.dip0.t-ipconnect.de. [2003:ea:8f43:c500:c07a:3448:98ce:439e])
        by smtp.googlemail.com with ESMTPSA id s8sm16482169wrt.69.2020.05.04.10.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:26:03 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: add helper eth_hw_addr_crc
Message-ID: <329df165-a6a3-3c3b-cbb3-ea77ce2ea672@gmail.com>
Date:   Mon, 4 May 2020 19:25:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers use the same code as basis for filter hashes. Therefore
let's factor it out to a helper. This way drivers don't have to access
struct netdev_hw_addr internals.

First user is r8169.

Heiner Kallweit (2):
  net: add helper eth_hw_addr_crc
  r8169: use new helper eth_hw_addr_crc

 drivers/net/ethernet/realtek/r8169_main.c |  3 +--
 include/linux/etherdevice.h               | 12 ++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

-- 
2.26.2

