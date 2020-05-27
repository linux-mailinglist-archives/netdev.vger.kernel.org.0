Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED581E35DE
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgE0Cs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgE0Cs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 22:48:56 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E12C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:48:56 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id n37so14574484qtf.18
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+tVTPg0pWmJxxJHEVguOlLFMVfnUoICLdNFxFY86dxM=;
        b=MlNz+V2bW91OVG3MhUb2VJSyMDk0xE3fl/8wnkVTUhVsEcty9XkKumetg6cyQZrIVB
         Dne3vEjoS++VcjG4boaHq0SYkUeg3sMDy25Y/0VxYdbnr7QhI9Bs2KsIt9zi1a5y+aK8
         Usec/kBBnRSLdHYmyEhMbSw911UK/x73gax6Nvc6wDRu5e8kz/qzARW6oFoW15A7vrrc
         IWSLiilryAHWpRxZgDFo6ySnAg9vihNy6kVkNg70YCryWyeHQjlAfzNbx1SL9iFkGjQ6
         q8WT+JciRBrf2GQpOcf7hrPvBKDT9Xe508XI1zvG7Aq4+QloYZxncpnO7giGR0Qea7yK
         4aIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+tVTPg0pWmJxxJHEVguOlLFMVfnUoICLdNFxFY86dxM=;
        b=lOa4bcziW5DUmf+5VZtKLDCikIaC/QyIEx2ZSK/Bl1RqHeD5bg7LF6VKnJ3TDw+w8s
         o53U8vrWcT0msmIs8pfq/iTOVynfjvSwgs+dJ7iyQdBJywZF4nvCDEk06gV7nhn3biPD
         S2wYzm0BstbrwGQVqT8yCkf77fBKeL+VzTYiY1WNgnVMHxafnOqrbVK4jf6RUToAzbEY
         3EwC1t310G56WcUfSXWQ3ofrdDGiDj3SKiAI+DgVqpkJbOf7AoT3/ZNEDHDkRfzCqPrK
         fqSTP3iSXdFLP1v8gCJS0Bz6QKguexhDbcQ9C33K8OAWYchLAMK1QNnn9wySMkioRBR8
         HKoQ==
X-Gm-Message-State: AOAM5319IDn0fHwFE+vi//NhufxzfN7deOEZv7oqbdL4pXchLn3wNdaT
        2St16uXu4qBUS8Z4txptQXOtegPr7CWKyw==
X-Google-Smtp-Source: ABdhPJzYKJlVWSlFTDCmtJ6nZWOgsJfu4aYuW0NcDGwV7ULmkXBib8EkGkq4tf7zAk5QutlYPdvLoIlYYCsYyQ==
X-Received: by 2002:a0c:b516:: with SMTP id d22mr639646qve.88.1590547735780;
 Tue, 26 May 2020 19:48:55 -0700 (PDT)
Date:   Tue, 26 May 2020 19:48:48 -0700
Message-Id: <20200527024850.81404-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next 0/2] tcp: tcp_v4_err() cleanups
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a followup of patch 239174945dac ("tcp: tcp_v4_err() icmp
skb is named icmp_skb").

Move the RFC 6069 code into a helper, and rename icmp_skb to standard
skb name so that tcp_v4_err() and tcp_v6_err() are using consistent names.

Eric Dumazet (2):
  tcp: add tcp_ld_RTO_revert() helper
  tcp: rename tcp_v4_err() skb parameter

 net/ipv4/tcp_ipv4.c | 103 +++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 49 deletions(-)

-- 
2.27.0.rc0.183.gde8f92d652-goog

