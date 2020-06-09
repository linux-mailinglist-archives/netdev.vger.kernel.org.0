Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00011F48C4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgFIVVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFIVVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:21:38 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A069C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 14:21:38 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id n11so66405qkn.8
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7oTQ7EKXMfsjjopueVd+ttmGarAHr4jm+/QY7GlMZRs=;
        b=ee0WXNZ/2okR4digd+MOm37Yat5GaIsNbrFB7gTqugRQ3Oa9q7KOm9G9M381IYlq1v
         2vd7JqWE5X7LZiOGRfqTuhudUIcjrYdLeDeo6dZev9na0qrTIaadaP7pVGv3qqlqHLRW
         PoCTtUFkGiJ5I5fAkMHyPiE+p8YdZ9I/9poVO/wzGKet26yxPG0nJlpgVe58iqbEgPpJ
         ApQNFhNpjNFdH6BNM+PFkQ/D9IxxvLgFLo5erV/3j6LcfFvvZ7BRxQzhqBVeZPg/Bcmm
         ekBqAA12pP6NvwJuj/rq19JcGnM5sBDf9oQ8r2RWvDl7enyQacB6OrUXfkRGpGUNzYzV
         Wr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7oTQ7EKXMfsjjopueVd+ttmGarAHr4jm+/QY7GlMZRs=;
        b=UUkwY6mHca4wc2P5HPqBYrNeXoFZLC7eAEeTZng3zDMaWjj8/RLJ4FVQUdhtQF+ZZr
         xSd6zCmlMX/tzgSEn6qpZLaEet/WSZ2OP+KOWXujGM4HbAUDd7KjGMzZJKyGCAyyxO1T
         u5Oip5Q+CaT+8dwI6GCPJBreLACgPYc36mf2/iRnbwzn359d9XjBowOWnuR7PBehtpQ6
         nvght9dtEoqSGs9KbfZdDAQ12CvwrS+M6/bILgktOzAZ/+d+AGoEcwfEC4GDKkWOeDnD
         b7fpQlnBkCgofkWpcOchEnrE1Voh1Ct3HSH3dl2CFRxTjmkKwBhX3DNy4sWyKvO318rr
         7qLg==
X-Gm-Message-State: AOAM532kSE3bpGbZ9Gh6GDLn0X5kLs29TkiWmbRxfINgklZMk6v5sLeL
        KLF+vu7KwxGJMqfal/wU/jICSkCL
X-Google-Smtp-Source: ABdhPJzGxPf8dOi4pAOniDzZaUlOsngK+uIYHPej7jl2V9MdPNbHcrJzIsUgCA3VpcgRXPr6MbTg8A==
X-Received: by 2002:a37:6cd:: with SMTP id 196mr28824646qkg.393.1591737696686;
        Tue, 09 Jun 2020 14:21:36 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:6db4:c56e:8332:4abd])
        by smtp.gmail.com with ESMTPSA id 6sm11140803qkl.26.2020.06.09.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 14:21:35 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tannerlove <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: in rxtimestamp getopt_long needs terminating null entry
Date:   Tue,  9 Jun 2020 17:21:32 -0400
Message-Id: <20200609212132.100714-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tannerlove <tannerlove@google.com>

getopt_long requires the last element to be filled with zeros.
Otherwise, passing an unrecognized option can cause a segfault.

Fixes: 16e781224198 ("selftests/net: Add a test to validate behavior of rx timestamps")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/rxtimestamp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index 6dee9e636a95..422e7761254d 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -115,6 +115,7 @@ static struct option long_options[] = {
 	{ "tcp", no_argument, 0, 't' },
 	{ "udp", no_argument, 0, 'u' },
 	{ "ip", no_argument, 0, 'i' },
+	{ NULL, 0, NULL, 0 },
 };
 
 static int next_port = 19999;
-- 
2.27.0.278.ge193c7cf3a9-goog

