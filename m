Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12D91E2663
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgEZQEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:04:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728016AbgEZQEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590509070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZRIwOSzaDOAR8K19LR7XSCEkdNxzWMLTpTWvAhUTBcE=;
        b=E/jxgb/80N1yffkZpha94ztR3rO4HVzBz1uxG5x8LELKeL3eTUSfGux5kaXkKCFvU/RUpk
        tmMuujapHgPtpkhxb1OGJTONHToWnbyeuknmZhpIhD8W/CbpbYwbOlxIhoRVaL6UhEDwY7
        GKBcPs4hbQ+Hir+RyWtIat/6cZXkNvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-zeyY00v2PGGmZb6tmxHMlA-1; Tue, 26 May 2020 12:04:28 -0400
X-MC-Unique: zeyY00v2PGGmZb6tmxHMlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7251D18017E8;
        Tue, 26 May 2020 16:04:27 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.40.192.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9972D5C1BB;
        Tue, 26 May 2020 16:04:17 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jhs@mojatatu.com
Subject: [iproute2 PATCH 0/2] Fix segfault in lib/bpf.c
Date:   Tue, 26 May 2020 18:04:09 +0200
Message-Id: <cover.1590508215.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal reported a segfault in bpf_make_custom_path() when custom pinning is
used. This is caused by commit c0325b06382cb ("bpf: replace snprintf with
asprintf when dealing with long buffers").

As the only goal of that commit is to get rid of a truncation warning when
compiling lib/bpf.c, revert it and fix the warning checking for snprintf
return value

Andrea Claudi (2):
  Revert "bpf: replace snprintf with asprintf when dealing with long
    buffers"
  bpf: Fixes a snprintf truncation warning

 lib/bpf.c | 155 +++++++++++++++---------------------------------------
 1 file changed, 41 insertions(+), 114 deletions(-)

-- 
2.25.4

