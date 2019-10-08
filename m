Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B188CF81C
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbfJHL1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:27:46 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:39420 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730375AbfJHL1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:27:46 -0400
Received: by mail-pg1-f175.google.com with SMTP id e1so10088662pgj.6;
        Tue, 08 Oct 2019 04:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zFvC0IwwelDQZoCyZ3xfn2BPMYFo5V+6CSIBOgosB7Y=;
        b=TA5JzIDOZE2EoGOhmc5GaBNtG1BSSa46Yo+DnUC3CbGPiHOOr2OzEnBrUOfS8/tAk4
         DwjFMADUsVXrhhevuFMg8+/eIu4pHK8mKxW5ERcMfDdW84tsHC5IMqqW3ycWIbPGHnPB
         sX0loLX5wcuL0OlaD+sO0dEmfb8CQHsR3YQz6nFFD4T7x8pdpDC6wD9ErmqjGoojfHho
         glE0cKmrzhRo6GCJWwXoh9PJsYy7Gx2jMX2DGMnPtfKLd1FRpyaI8f1A4UNwyDoGqaXj
         OItaYE2w0dQnMq9Y9frIaMgUk3FcwLK4hhJ7TWeHyvk08TNSDV/aghQH3KzVBJwEhiwN
         VTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zFvC0IwwelDQZoCyZ3xfn2BPMYFo5V+6CSIBOgosB7Y=;
        b=BiCLva6PSUhmc7MN0pjAt/hkHd0G/LYOCWwjhk7M/cCylK5u6cNV4oKzUazxfQonIH
         1KnNPrVWZgoj4RznNLfPeduKX1WssEpuFM7rhqgvFnj/WlZ0ovESxBRckWbzXtOaNL9F
         ED1UOkWtPSwRz163KcRv6b0Ju3LT1pQlGzmhDHPlWlM1DCKsAi+Vpgd8Wi9ZIL+cOAr1
         O/tyUKPtMzdFVTeBbfnj9+sQA7Eu1JApULBP/+YTzJC0+uWKSUMQQuAvR8j2L1GFd/TL
         vwhW5+2DBQvXx2BWIy8TrLaDZoXpMvtoydegnOudZr2zgv+VUy0jWB26jH8RyAyti+Cr
         8HFQ==
X-Gm-Message-State: APjAAAWqw9JQzhLz7tUxtluqI8vjXInbSX9i9TYU4l/ccXhIvFyisPRr
        EKBndnQALijgFCbdlsWic31+qgyf
X-Google-Smtp-Source: APXvYqzh4qIBjrt8wCZQBxY5cKpq7CwpG0pNAithij8os0xePTWfF8+jkxFOxWmfAB0vYKEH3LQLTw==
X-Received: by 2002:a62:1717:: with SMTP id 23mr38777595pfx.20.1570534064980;
        Tue, 08 Oct 2019 04:27:44 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u4sm17077270pfu.177.2019.10.08.04.27.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:27:44 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 0/4] sctp: add some missing events from rfc5061
Date:   Tue,  8 Oct 2019 19:27:32 +0800
Message-Id: <cover.1570534014.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 4 events defined in rfc5061 missed in linux sctp:
SCTP_ADDR_ADDED, SCTP_ADDR_REMOVED, SCTP_ADDR_MADE_PRIM and
SCTP_SEND_FAILED_EVENT.

This patchset is to add them up.

Xin Long (4):
  sctp: add SCTP_ADDR_ADDED event
  sctp: add SCTP_ADDR_REMOVED event
  sctp: add SCTP_ADDR_MADE_PRIM event
  sctp: add SCTP_SEND_FAILED_EVENT event

 include/net/sctp/ulpevent.h | 16 +++++++------
 include/uapi/linux/sctp.h   | 16 ++++++++++++-
 net/sctp/associola.c        | 22 +++++++----------
 net/sctp/chunk.c            | 40 +++++++++++++++----------------
 net/sctp/ulpevent.c         | 57 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 108 insertions(+), 43 deletions(-)

-- 
2.1.0

