Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8062C2198AC
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgGIGaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgGIGaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:30:12 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E6C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 23:30:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f139so616421wmf.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w4xGeCQvHs5BM4AqDhQmVCYfjON8oIwFGZ88CD4H6ak=;
        b=to7S3hbf78WpurgmYZYzSKF6IeZ7nhH+mcI+D7CkQ4CVyj0P+tNV+yRHCr36ly3kuZ
         zDOK/B+XXqXaPck7XBBhbvHs6r2UeYAVkPZtYytwDf9OUt2bs84ezT+H+4hJOYsuT0nV
         LP3U7QbAuGDxnWOwgDWcA3qJouD7OZq6I0BEd9qZ769vfqRaLR48UC47RSCl2WkmJnxE
         JN9wPeZCPA6sEN4Fu6St1oCEa+3r5pGJEHWGWj87wn192Gwl4JPTUQdCvEhPFRgTNAFB
         jBsuZNqHx/FAoClAust2zHOagMPZOi/UsBtJpfkEqN5oUqAYxTRcwenT7uh6yZoQo+o6
         Akog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w4xGeCQvHs5BM4AqDhQmVCYfjON8oIwFGZ88CD4H6ak=;
        b=K0ZXB5MjKbIRStiY6Ed4n+DpG1gwko+wVu4RWLPHOqcTugt0gCjSjAxNXZbkvvAEJ5
         kF1ein6nkB7wzABWrczUHJmT6WSQUExX2PuvSu2kPb+IJa1ej4GBK9b7gDLu3o2sXCfF
         VM7ocRzF6jr5eUSH9rnXy8EPMPs/lEX0ImpwJv1fcb7I+xQk7rC5sH10XZCkDMeO9NT+
         pYD/qu0GUqwRVWZ9ebBUddREyenrN/aDPD+OUwKANY3ejCiO2QWD/MYWYDwRQmWUISO5
         NZXwqc8370AL9ZGtzxRLK7erUuY0S1J+tTKx2diy+ZjL+rAMk/K3CFWKEJWJvZKFTTJ3
         pYJg==
X-Gm-Message-State: AOAM532gzv4W7BceiemhNSzNyqFm8gpYcn4pOIKf1Fry7YlDLwHoXe2p
        ib6coV1u/G4bI4zfN15p6BM=
X-Google-Smtp-Source: ABdhPJwDKDeE98+47dY3B5aKgXCABHdfge545HN/V1WyJx6ryi0z2j1POBhfN3ZfloAefoeyRFIMIQ==
X-Received: by 2002:a1c:5a41:: with SMTP id o62mr12687487wmb.16.1594276209584;
        Wed, 08 Jul 2020 23:30:09 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id l8sm3777854wrq.15.2020.07.08.23.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 23:30:08 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2,v2 0/2] ip xfrm: policy: support policies with IF_ID in get/delete/deleteall
Date:   Thu,  9 Jul 2020 09:29:46 +0300
Message-Id: <20200709062948.1762006-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow getting/deleting policies which contain an xfrm interface ID.

First patch fixes the man page with regards to the original addition
of IF-ID in ip xfrm operations.

---

v1 -> v2: update man page

Eyal Birger (2):
  ip xfrm: update man page on setting/printing XFRMA_IF_ID in
    states/policies
  ip xfrm: policy: support policies with IF_ID in get/delete/deleteall

 ip/xfrm_policy.c   | 17 ++++++++++++++++-
 man/man8/ip-xfrm.8 | 10 ++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

-- 
2.25.1

