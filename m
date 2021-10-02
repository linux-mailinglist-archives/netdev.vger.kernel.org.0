Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD56441FD3F
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 18:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhJBQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 12:45:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233656AbhJBQpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 12:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633193018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Q56F8alOjjoETinKdCi9lhlS7jiIZcwAjQIl5WxwzI=;
        b=SA/rMJEiBkxX/sW1nE6neWUU7BTxOx7Mpm/3XkvirvQXWJrH8ckC5S3Jk0VVCoMdf8LxBP
        Kn0R6LuERyDIPYWjbzFN25lHezq/6SEHHRsWlZ8zR8dpG2WUnyIRTCw3hwofZF0CWhxkNl
        Ag5GYIamG9GfdQu64O8i1h+8SVKcHLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-OfsZTbypN22FUkpSFiFAXA-1; Sat, 02 Oct 2021 12:43:37 -0400
X-MC-Unique: OfsZTbypN22FUkpSFiFAXA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5251D1808308;
        Sat,  2 Oct 2021 16:43:36 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13C285D740;
        Sat,  2 Oct 2021 16:43:34 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH 1/2 iproute2] configure: support --param=value style
Date:   Sat,  2 Oct 2021 18:41:20 +0200
Message-Id: <754f3aaeae85cdc9aec0a7b609803a0281e1fabb.1633191885.git.aclaudi@redhat.com>
In-Reply-To: <cover.1633191885.git.aclaudi@redhat.com>
References: <cover.1633191885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes it possible to specify values for configure params
using the common autotools configure syntax '--param=value'.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/configure b/configure
index 7f4f3bd9..f0c81ee1 100755
--- a/configure
+++ b/configure
@@ -504,15 +504,28 @@ else
 			--include_dir)
 				INCLUDE=$2
 				shift 2 ;;
+			--include_dir=*)
+				INCLUDE="${1#*=}"
+				shift ;;
 			--libbpf_dir)
 				LIBBPF_DIR="$2"
 				shift 2 ;;
+			--libbpf_dir=*)
+				LIBBPF_DIR="${1#*=}"
+				shift ;;
 			--libbpf_force)
 				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
 					usage 1
 				fi
 				LIBBPF_FORCE=$2
 				shift 2 ;;
+			--libbpf_force=*)
+				libbpf_f="${1#*=}"
+				if [ "$libbpf_f" != 'on' ] && [ "$libbpf_f" != 'off' ]; then
+					usage 1
+				fi
+				LIBBPF_FORCE="$libbpf_f"
+				shift ;;
 			-h | --help)
 				usage 0 ;;
 			"")
-- 
2.31.1

