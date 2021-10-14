Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA6342D56C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhJNIxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230007AbhJNIxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVxKVD8rNAzc9BEQjgKBWH125v4czXDZxBhtnZPFuTc=;
        b=OSGMT6cjz2jlJS36xpNTzBJSq4KdkNi1Tgcn47PUsk49WXNatIwk6C1oe5q2gBaHXjJY5X
        oqq2BcC/2RHMZ3xmrMG4IS8CGd3kPrhwd98M8nVwzv3GQXbSVX3r62WdJpT0pO6D6hl0r9
        5KhZZH4pwxwZbbgWlB4NJL1iJfsugxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-KFqmEjpSM3SVwDp-_I2ykQ-1; Thu, 14 Oct 2021 04:51:34 -0400
X-MC-Unique: KFqmEjpSM3SVwDp-_I2ykQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E28B19200C0;
        Thu, 14 Oct 2021 08:51:33 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF5A71B42C;
        Thu, 14 Oct 2021 08:51:30 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 5/7] configure: support --param=value style
Date:   Thu, 14 Oct 2021 10:50:53 +0200
Message-Id: <7db73d1995abf4f91ff6f6d7ab6bea24df7591dc.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes it possible to specify values for configure params
using the common autotools configure syntax '--param=value'.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure b/configure
index 26e06eb8..9a2645d9 100755
--- a/configure
+++ b/configure
@@ -504,12 +504,18 @@ else
 			--include_dir)
 				shift
 				INCLUDE="$1" ;;
+			--include_dir=*)
+				INCLUDE="${1#*=}" ;;
 			--libbpf_dir)
 				shift
 				LIBBPF_DIR="$1" ;;
+			--libbpf_dir=*)
+				LIBBPF_DIR="${1#*=}" ;;
 			--libbpf_force)
 				shift
 				LIBBPF_FORCE="$1" ;;
+			--libbpf_force=*)
+				LIBBPF_FORCE="${1#*=}" ;;
 			-h | --help)
 				usage 0 ;;
 			--*)
-- 
2.31.1

