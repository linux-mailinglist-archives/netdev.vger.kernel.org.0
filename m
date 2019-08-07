Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC00983E35
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfHGATf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:19:35 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:44878 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfHGATf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:19:35 -0400
Received: by mail-qt1-f171.google.com with SMTP id 44so55516578qtg.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 17:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hQP3AxityeIthQe511tHjlhhvw8xArH7gbP2iVT9D4Q=;
        b=esdCvdGpMWHdUyOvd5yR7Gx7/DgV2g6yjD9kTCaXYy5vVbF89NKKN84dskNmPgGxt6
         R+1qpGyzXvFB7afccwtwI+duEOHuHOosp9mrrYFGvo0AIz75ZxlTrplbuSvKRBL5Ag8u
         9BuefzUpiufdcJR1IVJV4CIzCVIt4ERnGWWle5Tnc52rOV5tg0MnxrcVzMcWM9qHvsDP
         wqBs5q+7dl026XK+I2tf5wQ5oMu07XcuftCMASL71141VT88u6s43XpMszCJchNj8gBh
         ngbdBBI/Uqv1Y/TYgGT/PDmHXqCOP3E1Btn7C0zulq+XY3gtjl1mW1PAfFNBCicMyye+
         gCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hQP3AxityeIthQe511tHjlhhvw8xArH7gbP2iVT9D4Q=;
        b=bqHVkDj2t/qYrW0sBVquW4auPEQ21pTAueXNos9sLNN+REHFObXN0KGVClD47HwvPq
         w53KkAT/QVmMsSqZHTCxxcyXLZ9vQGY/yvA1IRvY/tHXdae5yC/tpViKzYvH5Bn4pKjA
         EOX/4HfaN4RpCxFe5nLvGgwziJbmlK3esNIQSbLlqmRuOyYj9rpC/YFupTe+/1EPjc3f
         zE1W7eRxQvbstneVlOLWeu0nrvtQ7yFxUOpHyzYL29bHAOCgCWCtesG97gy0azQXpVRe
         cPB8+pguT/yMtFHI3AgFw4KlOADN1DuyvCPnoXJq5TMZchunQh25NGVXCpir8rVdW+Mk
         65lA==
X-Gm-Message-State: APjAAAViUJC7GH5xeKlFyJtSoATWvYE3cUiSN7iDj5eNzF4SMewIeVyq
        XNDkgnxohtwTTMKV90MigXT7sg==
X-Google-Smtp-Source: APXvYqwnoK90JYybpVflra8o69gKlsXnYlKN8Bnw0NvlQd2Xagxo8naytMugwblEf6LjG2EU8fqu/w==
X-Received: by 2002:ac8:6c31:: with SMTP id k17mr5568504qtu.253.1565137174201;
        Tue, 06 Aug 2019 17:19:34 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i5sm35547554qtp.20.2019.08.06.17.19.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 17:19:33 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf 0/2] tools: bpftool: fix pinning error messages
Date:   Tue,  6 Aug 2019 17:19:21 -0700
Message-Id: <20190807001923.19483-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

First make sure we don't use "prog" in error messages because
the pinning operation could be performed on a map. Second add
back missing error message if pin syscall failed.

Jakub Kicinski (2):
  tools: bpftool: fix error message (prog -> object)
  tools: bpftool: add error message on pin failure

 tools/bpf/bpftool/common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.21.0

