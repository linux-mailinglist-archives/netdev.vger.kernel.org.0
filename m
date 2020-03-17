Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B47188DF4
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgCQT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:26:55 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:47081 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQT0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:26:55 -0400
Received: by mail-pf1-f180.google.com with SMTP id c19so12480715pfo.13
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 12:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nHBhXpYE5zz65FSso2XhHXUJcU7Luz8hm0FF8yN9P3Q=;
        b=DBxoQ6E20/pCrTazOBDqGoY2qhJpzcsiojFJyFbLjEG82FhX5GkclCZ6N0OsIgcjwK
         mOlm7OoiHyJZ2MnlRM7Cc1J6SSKWInZ7++xdfyZ2vf9dGLzZK0LMoxOmhBeJyI7P6WeU
         ZII5SDtKRIWYvxk7gbltpOLutIfidr9dOaOB72upfglyy8c4eu4eYc3MTKS0vHA5DdiF
         bh8zqGsNgDwK1umtg7/yu7uTLH6AcIfLyMsRGaTWhCDbbKJcIckVznAMxRi99t0mHS+u
         rGa+g2Lqv5aPAtvz/mDS3txWjNMWeHgFDJ8CjPtk03eEbCxeM8dPuhgoeBsgGNSq2PrQ
         Wh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nHBhXpYE5zz65FSso2XhHXUJcU7Luz8hm0FF8yN9P3Q=;
        b=P2rCOt023+y/ZDTLxq/FAqgu6tJcNiWt4k4shTu3kiZqb3t/aTHN2kFd0x30ZXh+mK
         bcGKjLMGhgB+9j42lE3m8ioHk1YBqUh5+Zgbf9/6Oew+SjeM5DuK6ws/cffRan6MZnyc
         7WO2Izkm10yMk41uaaoXu1GqIvdvrCRYo4hw4Ae5NALfwI8YA5njJZgY9dGYIJOcEuHh
         CUvcybYAjvLyQfEITRS/vwsyGmLaQiC1djA46JyhAA2BTnUX7m2iSCNbXyA3nwKuZD7b
         SpxknMB0+yxD+w6Nu6c/EocaftD3VR5N7K8D+90YZvrYQVDdY/DnhqJFakbxDK0hHo7e
         nr8A==
X-Gm-Message-State: ANhLgQ16BMaw4PjoZBmAV9g8v+vjWYyfhdAM1H0xIrgKhgbIpdPQBOfe
        dCEA2ejJvsLwzfA13+771Ek=
X-Google-Smtp-Source: ADFU+vsk942t8I7TzRLheM+zBGJ3SAvae5i5PV2tBmdu1S0Kxn1+jEomBSOuTu8DE5Hd1MhDSlS21A==
X-Received: by 2002:aa7:9abb:: with SMTP id x27mr338836pfi.212.1584473213621;
        Tue, 17 Mar 2020 12:26:53 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id gn11sm173209pjb.42.2020.03.17.12.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:26:53 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next 0/5] selftests: expand txtimestamp with new features
Date:   Tue, 17 Mar 2020 12:25:04 -0700
Message-Id: <20200317192509.150725-1-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

Current txtimestamp selftest issues requests with no delay, or fixed 50
usec delay. Nsec granularity is useful to measure fine-grained latency.
A configurable delay is useful to simulate the case with cold
cachelines.

This patchset adds new flags and features to the txtimestamp selftest,
including:
- Printing in nsec (-N)
- Polling interval (-b, -S)
- Using epoll (-E, -e)
- Printing statistics
- Running individual tests in txtimestamp.sh

Jian Yang (5):
  selftests: txtimestamp: allow individual txtimestamp tests.
  selftests: txtimestamp: allow printing latencies in nsec.
  selftests: txtimestamp: add new command-line flags.
  selftests: txtimestamp: add support for epoll().
  selftests: txtimestamp: print statistics for timestamp events.

 .../networking/timestamping/txtimestamp.c     | 179 ++++++++++++++++--
 .../networking/timestamping/txtimestamp.sh    |  31 ++-
 2 files changed, 187 insertions(+), 23 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

