Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5BEC3287
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbfJALdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:33:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36585 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJALdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:33:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so7754842pfr.3;
        Tue, 01 Oct 2019 04:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NedOdxduYE192+j0L9U6oJB7serWu3kUApAmq9EK7s0=;
        b=a/daXUUo3gjQK5srp4pfd1YsXfM2FYJ/SeSXm/K2wqAzgLsI9A22Cx4QVUXEUJGgNU
         RXYzxEaVdT8uZrAbGe+FmV7RbeAHd3PV1uWdmSa+O6uHZ1b49Vr9/MCPMJnR/GAJPLh0
         e8R6rENDW2vC5GJcyL+x6f0R2jbS0Mer5ikTdY2rCseYeOII+I2qgTz5L+fbvtdhlGPZ
         8uhbD7rFFHTTeAHpTOXP1Ourma6dHQ6oWXd9dm0FZo75AIy69VThTVgPA8s/xw5BVTud
         fQkemzWD2kwDQ647v/sH8Er1BtLJ1QX3AiiY0PJ3o4D2t5huxSy4KlrbHG65sk5hDxnV
         /SMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NedOdxduYE192+j0L9U6oJB7serWu3kUApAmq9EK7s0=;
        b=HapWnr1Z7LD9XOMZSlA6BSSTOQaUe+E6r0nYZ00KRKI8P+Z8O1zk8GsKGmNq7ZRIGJ
         iVXHuhIPt03PYsrJSB8bBeg6tyLJiid4dGOFRlBBI++n9U9TkV6ZqP/tqZJPTMZb7Rlz
         FotO5SgOaxl9u95xyMPgbBttD7nROzFd9e4zCrGMPYTp4kAWbGK+Dk0GmXO7/uvqmStT
         S/1mh6cAnZ+Lsf421di05O8wOCfdEYd/j8DozRowagW8jS0C2EVvM5Qo+z6pTFQ+tMHD
         7p5rlQ7gnoLVDYNq2wfqP9SwgWUzYsVdA6Cuy6j/0whIY7XTqOEirs9YROkMVuZ4Un5A
         kRTQ==
X-Gm-Message-State: APjAAAVoEisYodzR8MZdoxu+eYsLsEb2ArCfA1LSXqzTZBVPYX2D3kHi
        agkZvPpNw638wbpPId5PnW7RvoeIzdMBdg==
X-Google-Smtp-Source: APXvYqxCn3u/39GjKHZ0Kpc/Yja0tSf1XnpAKP21udqK7c+x2TaaNcm8mxZ+RkgBKqZ8FtEJajuosQ==
X-Received: by 2002:a65:6659:: with SMTP id z25mr30064683pgv.23.1569929597494;
        Tue, 01 Oct 2019 04:33:17 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a29sm16238634pfr.152.2019.10.01.04.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:33:16 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     linux-kernel@vger.kernel.org, acme@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, adrian.hunter@intel.com, jolsa@kernel.org,
        namhyung@kernel.org
Subject: [PATCH 0/2] perf tools: optional compile time test_attr__* depenency for perf-sys.h
Date:   Tue,  1 Oct 2019 13:33:05 +0200
Message-Id: <20191001113307.27796-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This mini series makes it possible to disable the use of test_attr__*
for perf-sys.h users outside perf. E.g., samples/bpf/ uses perf-sys.h
as a syscall wrapper.

Now a user can define HAVE_ATTR_TEST to zero to avoid this, and as a
nice side-effect it also fixes the samples/bpf/ build. ;-)

Björn Töpel (2):
  perf tools: Make usage of test_attr__* optional for perf-sys.h
  samples/bpf: fix build by setting HAVE_ATTR_TEST to zero

 samples/bpf/Makefile  | 1 +
 tools/perf/perf-sys.h | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.20.1

