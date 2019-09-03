Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F90A7692
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 23:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfICVzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 17:55:20 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45966 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfICVzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 17:55:19 -0400
Received: by mail-pg1-f171.google.com with SMTP id 4so6409048pgm.12
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 14:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version;
        bh=Gv9/+rRRkWgEfLiUgicWpon/RMx52rySUXaIWWH7fWs=;
        b=qjC6fUd8emlan9xz8u2gflzvXSzWC71ly7lKK6V0T8z1uBlJNVwLC/6TKlD7uplU9z
         pijgEeqpELU2KDMvD8AwWHpS9mDrMNy5Ivh9QLxrtd2y16chZx31b9gLhCGEChEQRcaM
         Hw+Dm9DpDAyKYEj3z37ac3svEiKCrooNZhiCDQb09DyH2a/x2qLIalB7uaVzLmR5BT50
         J5BBc3Q5Z1opeUUiCuLHLAgX14izU4crHrloUV1BmATj+TmknZEJFP6q1+3Q4eVr8Kcq
         qj4Ulq/b6EdXuP+6a4HBRgA7+ahLx8ZB3qzpGvDEBpq2XZrebRXSbcipWnzC5K732b2W
         yiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version;
        bh=Gv9/+rRRkWgEfLiUgicWpon/RMx52rySUXaIWWH7fWs=;
        b=oYil1Vk5pqwYTKJaKoLtEU/E8ehtQvYv5IVu/Jp/lzSUAOy0VQ5vfFKzL5/6BNqJfi
         sKDP8skzHgyZ9gGmskVYKQ/gfwa9hLeKCEoJ9lNyH2xpOm+Fad+GIx/d7gP+lwPZp1AN
         b5O+ZhwQ7A6vxjfJDj7fajKhA9hUxTctJcuEVbxFXNfy6ADPHzdrvUbdQz6RTbwMt+ev
         iIDebKHz9O1uhxOw3OH++SL8yUwjvXX/dq/GMLAGL2cCzZqzwKF9vkKfC+2wcqqVlv25
         xkstiNc32gIjBwO4UvrpxKgCVJXBhkNamGM6wsYFxM2Ubdvjqq5A613g1xjiihmYM4cn
         +H6g==
X-Gm-Message-State: APjAAAUIqDPMNBr1sXE3kcu/N18DfS9TjaT9QX3/AQYNBhk7Og8gu1a0
        EXgHgcfNI++X2Sd1pM8UD3BHBGxU
X-Google-Smtp-Source: APXvYqz1LDKgE00E/3WQRan6XX9HzVsaWnWFST7Y6aKrxKpe2tcDd+kQCDfPjjaTWoaLGeaO+rq4ig==
X-Received: by 2002:a63:c006:: with SMTP id h6mr31977165pgg.290.1567547718997;
        Tue, 03 Sep 2019 14:55:18 -0700 (PDT)
Received: from [172.20.41.163] ([2620:10d:c090:200::1:503d])
        by smtp.gmail.com with ESMTPSA id x2sm480697pja.22.2019.09.03.14.55.18
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 14:55:18 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     Netdev <netdev@vger.kernel.org>
Subject: rtnl_lock() question
Date:   Tue, 03 Sep 2019 14:55:17 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <29EC5179-D939-42CD-8577-682BE4B05916@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How appropriate is it to hold the rtnl_lock() across a sleepable
memory allocation?  On one hand it's just a mutex, but it would
seem like it could block quite a few things.
-- 
Jonathan
