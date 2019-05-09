Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D216F19598
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEIXOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:14:19 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:38364 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfEIXOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:14:19 -0400
Received: by mail-qk1-f172.google.com with SMTP id a64so2573244qkg.5
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d0CXdl0SexEGvTBsjhc29e66B4ug+UCxMVXLoUd4CrQ=;
        b=rf1dl0DtgdJe6D99aOEgLg2gryI+yM13mVXie73LcqFitrQXA+UWolL/ElgoArX3jn
         NuCCh1Xy7gWad1aOPzzkhRp2W4/Qxwj8LwGTJPFVS7tMgO0L6WTtWYDS79GWRT88Vx0o
         l0KVtFPp6ZUMb5A/xPG+OIzuKvsnmZdcezySKF1zLxZ6xBGvc7kaF7/PlZq7gNFYkmsr
         w3Xw6gs+XEF8Up+9zPUpYXcHxdv5rekwCmQ5EPsfwYdU8TfHtud79E7Ax04J/DDFbbSl
         ZtkPzBQnPQ7VtZuZd4W4QpanvH/WbQ/SuT0+g5a9aLEU1X0vFKTLXz44yQ7KHjKU818R
         FeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d0CXdl0SexEGvTBsjhc29e66B4ug+UCxMVXLoUd4CrQ=;
        b=F9YInpbo0Hzd42vw8U7mj/8/lPDaZq3hCWX3fyT1I7BnC9K83brLfVX9jgJIYjRhS6
         bft1O3ePmxwtNgWruxl8qYQs407IVQ9NRfJJlDfZAHq6xKA1x2tKVfqYAsjwefAJSWAV
         dWItW8p6tHIB9ZwHs7zto9SmFirWT6hbjBvKZq7hvs5ryXYDcQ9rXpxDmqjAuGt3Abbi
         R94wL6/PHrDAKexd0Ep7ZDok48G2VpWa3p4oETe1QAlUSGz4m06kdSqGXIjNya0s2CID
         bY5YiCjDsQQlSYnO5zxvV4/CFDucw++yllsDeryjemvJoF3IcMCdCX+jfI4YIo3bPjK9
         Zpmg==
X-Gm-Message-State: APjAAAXsddWbYbcJcfRz8AM6ZiPRXXoAsIhaPCf7QICQTSmKWKEgUCWB
        BNAE0CbiflGOps2DJugSrR3oYA==
X-Google-Smtp-Source: APXvYqxVjBu4DFQbKNrJs2fRaFxVD4uwIu7LESNvVW70t4ARBg7Xcz59PtUSSY3j9z/2OmnCbFSabQ==
X-Received: by 2002:a37:a490:: with SMTP id n138mr6044990qke.55.1557443658132;
        Thu, 09 May 2019 16:14:18 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s42sm2036778qth.45.2019.05.09.16.14.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:14:17 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/2] net/tls: fix W=1 build warnings
Date:   Thu,  9 May 2019 16:14:05 -0700
Message-Id: <20190509231407.25685-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This small series cleans up two outstanding W=1 build
warnings in tls code.  Both are set but not used variables.
The first case looks fairly straightforward.  In the second
I think it's better to propagate the error code, even if
not doing some does not lead to a crash with current code.

Jakub Kicinski (2):
  net/tls: remove set but not used variables
  net/tls: handle errors from padding_length()

 net/tls/tls_device.c |  5 +----
 net/tls/tls_sw.c     | 30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 12 deletions(-)

-- 
2.21.0

