Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03388089A
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfHCXhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 19:37:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42878 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbfHCXhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 19:37:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so37774866pff.9
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 16:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dG75FH/rlWRdh8D7RWWexprO0W9nSo81lL58r3GgALE=;
        b=l4xbCukxqQyrb3j4HUsJ8BZEqzMusjmOrjrOGJ/fyaqZiCjWC8bpE+UjMbwnKIzpny
         JDUrVxiQCjeR1WGZ5Mrx+HK/tOT2o7LQ+23u8FiJX9RUpepzpY4vC0KiBHMYVonw9Fqx
         chTvDH7LfQ9pdUCM/aMHoNgq17PvUvw69Xj2Ms5hnSh7k8oZPio4tnO+Dv6joF0eEP3S
         /Q3FlrC1UqL//hPxDbCGObpfHIw1MmtjV9ym0PAVtHPJesY+ElIThZgi+Q5SrQ1is8DI
         5kc0yRL57AyTMIAOYG0L9gfXz3CQyrrKjQD8ALAnq62dsMMPMXnK1U9kLECsW2Z90gXf
         Zm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dG75FH/rlWRdh8D7RWWexprO0W9nSo81lL58r3GgALE=;
        b=aoYtSC4K2yZIXQUpfIIi8xJxPlLtDpc6COjuxEQzZWvInmmZPUURCBQb9j6ZHUK8HB
         j1qSJTDJbyUDAiBEFftLVRgb8bCZ/eG6UsbTwy815Lb6r9Evn8iG7YyQfSrcEbMdov1T
         2tvSkbfx9F9odlrc/uBCZaa9M+39EYlsYOwMqAQxp9BxVOqgefYgJYtnruF8JlRyDaRA
         T6NZR//4+wS1asPMkNVL4W68+wkWGV5ReaS0hnENa9sKm+L0KrrnPkbAMTNxf1d2N31F
         1w0W0Fp1TeuLMdskO3xxCpGcocowRXkUVcT8yEG/9iblJOMBxG66RZvUG7xFUswpRdX3
         UsgQ==
X-Gm-Message-State: APjAAAVDMhw/+IvCNA9K89DN+/um0eHVY1k2Rnq6fRYZYyWI7YpUzCZF
        Du7Wq3AG+yD8BUAlh+XRcXAgvyPQL9s=
X-Google-Smtp-Source: APXvYqzBDLUfzYtw/wxDFWnjH1+KV5YVvnGPMpID6rkOi6S+EFuEki1enZKB3xe4KGx40ig3zS1/0g==
X-Received: by 2002:a63:755e:: with SMTP id f30mr131162183pgn.246.1564875451495;
        Sat, 03 Aug 2019 16:37:31 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id x24sm76076336pgl.84.2019.08.03.16.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 03 Aug 2019 16:37:30 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 0/2] Two small fq_codel optimizations
Date:   Sat,  3 Aug 2019 16:37:27 -0700
Message-Id: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches improve fq_codel performance 
under extreme network loads. The first patch 
more rapidly escalates the codel count under
overload, the second just kills a totally useless
statistic. 

(sent together because they'd otherwise conflict)

Signed-off-by: Dave Taht <dave.taht@gmail.com>

Dave Taht (2):
  Increase fq_codel count in the bulk dropper
  fq_codel: Kill useless per-flow dropped statistic

 net/sched/sch_fq_codel.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

-- 
2.17.1

