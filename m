Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477631E545E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 05:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgE1DKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 23:10:38 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:60374 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgE1DKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 23:10:38 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 49XXl12vbwz9vYBT
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 03:10:37 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 69pQVCrq01Y2 for <netdev@vger.kernel.org>;
        Wed, 27 May 2020 22:10:37 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 49XXl11D9Fz9vKln
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 22:10:37 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p5.oit.umn.edu 49XXl11D9Fz9vKln
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p5.oit.umn.edu 49XXl11D9Fz9vKln
Received: by mail-io1-f71.google.com with SMTP id h65so4709360ioa.7
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 20:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=IHcaKYQFAiNpjDs/H7x5QNmUSskJMpHECApqwdRwTWM=;
        b=gvbMCp6GIqQTfK/GiPhRiAmCDTkrNDaCfn8BnA/o0LRY3Wn260v7b4F4sHZ0kCKO34
         6LAjdtdpWJWEIsivJtWDXm9raSVKWLKACHfTjZSdRb8IfZmUob9sQmmgYumjSTDiA8NL
         zrrYP5xb8+HnxfZo/N8a3JaYeJb9NhH94CZqSMTovLyI+RoNae3riAFD7b+0hGJzvoYU
         ndUvLIhQ5wi+jm6yiqzbdUxjEUFIgj779zul63p1GprJu6KwxlP85Lyq+5g2R6K8EiG4
         ZuypldLfEQxx+2KfTBvGP+IakUO+HYeNXIdOmFVYXgb8LRZZfblBbSpk9lo5/8wP5+Af
         IGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IHcaKYQFAiNpjDs/H7x5QNmUSskJMpHECApqwdRwTWM=;
        b=eJJLzRhQ2Frl4f/8VfpgC0dmLqEdsQa2ZsjuTvXIkJQQAj9NCevIFGnn3J4bN1rrlD
         k9ZSHYt4wtBNyJ+nWdiqYB9YkObR4f/l4bGmTmbhG1aLKSF6POSktYnERi/olufe9F9v
         uFHLK2cFvR8MZx2KfleqXCYhDBijELh6k/BG1Sgl9YTpFN3ZahYZRpSzcUr0XwMshYIf
         WQPNJ2I3xI4OTKimPAwfxDhufN/CVjy43E0ODr5H0GqkNF+qT3kfzp20B7eGVcXk8qie
         /Y2iL+6L2sG+hCd8WNtzEA9mkqZI/6IX4dBl18vyzoD5EOqG17vZPGC65CSG4wyGtT7T
         D0jg==
X-Gm-Message-State: AOAM532eRi1uLJHyOZJfQCHhMhIbZJFZI+ATDOPADHFSF+iBo98g+nZp
        TQxgxQJzIaC18zKWXmNUtTf0TSx7WFSJJa/6D43v8RU5XURpvAXPe5smdx2z6bhIi406GQzZh7V
        ohlOYjH5R6NZodXD+3nzg
X-Received: by 2002:a05:6602:13c6:: with SMTP id o6mr748538iov.84.1590635436649;
        Wed, 27 May 2020 20:10:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPEPAGkAoZSYNeSa2XOy08F0GoMu7kvQ4ldrnc4xVMjlUt3rARcZ1w4aU3Bhyak/8uYIsdHw==
X-Received: by 2002:a05:6602:13c6:: with SMTP id o6mr748526iov.84.1590635436342;
        Wed, 27 May 2020 20:10:36 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id n8sm2008029ioo.2.2020.05.27.20.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 20:10:35 -0700 (PDT)
From:   wu000273@umn.edu
To:     kjlu@umn.edu
Cc:     wu000273@umn.edu, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "sfeldma@cumulusnetworks.com" <sfeldma@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bonding: Fix reference count leak in bond_sysfs_slave_add.
Date:   Wed, 27 May 2020 22:10:29 -0500
Message-Id: <20200528031029.11078-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/net/bonding/bond_sysfs_slave.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 007481557191..9b8346638f69 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -149,8 +149,10 @@ int bond_sysfs_slave_add(struct slave *slave)
 
 	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
 				   &(slave->dev->dev.kobj), "bonding_slave");
-	if (err)
+	if (err) {
+		kobject_put(&slave->kobj);
 		return err;
+	}
 
 	for (a = slave_attrs; *a; ++a) {
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
-- 
2.17.1

