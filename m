Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39751224033
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGQQKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgGQQKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:10:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB148C0619D2;
        Fri, 17 Jul 2020 09:10:43 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d18so8133593edv.6;
        Fri, 17 Jul 2020 09:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=13hxd0qOeoNdKjzcW9Md9uf34H7KfIzZmbYDIbjslco=;
        b=kGm+4R9RBKT3+pxDXJ+fUhHfC/ZCSQpJtGDb2BKfxiypUkQYD4l+vz7VJjv3wAWlnf
         5pelvJhK1w/AMqVFl1Bfts5qJ1OQ8ak4DrxJxa5hTGoDN5yvwmbUsA95zoa3MWoSQPzi
         DbnSXlhD2UcEMdbYD2qqDZwYPveqLTT7v63IQqFh4wjBXiCxhNif5kWeyoqWfu3Y1GGA
         UhlA0bPq2k5R/xtR1PuRVvqJHoJaoJpnOuDp3WW5ZM1m+2iSyYsG46FRpMJ4CnQBwX1R
         nI3UbIOWFIhteZBDZpgg8JQtWtoo0UzA14rt8PyFR8OFfRki69za+BjITZHNA4DxwnOV
         ledw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=13hxd0qOeoNdKjzcW9Md9uf34H7KfIzZmbYDIbjslco=;
        b=bYR7p9gNq43Q6Xfs42OqsAU0cSPypvgI5KF+vTxdJJ8lrJEnhu4E8SJSmgnT7Y9ysd
         XcduNQK8864FdJmNYRAWXkA6PRKpfWyOSOXr8oYy4wnDJQoVH9CU1a/aKfL6zukuCZWa
         O5teiUOvnXbsXL8fNNwYJYQbnu7Rxa85mtt3E2+bPPSlqhbcCQaNthu5rITMd1ySJf80
         HzFZXfuwvTD1qlL4S2eX4uqimn50NNPnEgBg9d74IE/qB56C7nveXB2LwxxscBRaa7OH
         IL8QqjK9M4w0fpltICUWEiAod+oZblgLMC9ATPUSB+SboZ49k+4D8Gh8LK++VwZ6CTp0
         vd0Q==
X-Gm-Message-State: AOAM532MrFL3kvAyGw6tmwzTe6XSyhhdqVPWpPthLd5XqWUxI/9N0oOC
        cgquRlPQM9djRyNP4rNjj+M=
X-Google-Smtp-Source: ABdhPJzE5phYPHsYA7TMXWDz7V/lNvaTuFbMYH/m+NdYA2LmFyivgWr7CcDvYjCfNvM3UcmoK9s9Hw==
X-Received: by 2002:a50:eac5:: with SMTP id u5mr10238807edp.6.1595002242563;
        Fri, 17 Jul 2020 09:10:42 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bc23sm8578253edb.90.2020.07.17.09.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 09:10:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next 0/3] Document more PTP timestamping known quirks
Date:   Fri, 17 Jul 2020 19:10:24 +0300
Message-Id: <20200717161027.1408240-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've tried to collect and summarize the conclusions of these discussions:
https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
which were a bit surprising to me. Make sure they are present in the
documentation.

Vladimir Oltean (3):
  docs: networking: timestamping: rename last section to "Known bugs".
  docs: networking: timestamping: add one more known issue
  docs: networking: timestamping: add a set of frequently asked
    questions

 Documentation/networking/timestamping.rst | 77 ++++++++++++++++++++---
 1 file changed, 70 insertions(+), 7 deletions(-)

-- 
2.25.1

