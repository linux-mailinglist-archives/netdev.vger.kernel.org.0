Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E7539586C
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhEaJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:49:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231124AbhEaJtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 05:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622454475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y76x+T/DqY7snXN4EJ21xEIauzznPe1EtLBqOk+ixi8=;
        b=FqRA1OXO9ieSAAq8W7xJYgqoj7U+7t4EVLh2hHbcl2S1m8rksm7Icbw9ToEpMJ1zEH5tuy
        P6r2aHjETSBpSklGqzmvxm68gJrOKJPTeHZDhWzO50Mlop7lq7E/A5dBG90sPsIJDi+DVs
        yD7QGpmy+OS9NWqPpi//f9+iDHYaFoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-lDOLQirXMcmJnOeqVkmafw-1; Mon, 31 May 2021 05:47:54 -0400
X-MC-Unique: lDOLQirXMcmJnOeqVkmafw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22A111008560;
        Mon, 31 May 2021 09:47:53 +0000 (UTC)
Received: from Leo-laptop-t470s.redhat.com (ovpn-12-207.pek2.redhat.com [10.72.12.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 823B95D9C0;
        Mon, 31 May 2021 09:47:51 +0000 (UTC)
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Hangbin Liu <haliu@redhat.com>
Subject: [PATCH iproute2-next 2/2] configure: convert LIBBPF environment variables to command-line options
Date:   Mon, 31 May 2021 17:47:40 +0800
Message-Id: <20210531094740.2483122-3-haliu@redhat.com>
In-Reply-To: <20210531094740.2483122-1-haliu@redhat.com>
References: <20210531094740.2483122-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
 configure | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index c58419c2..0a4a0fc9 100755
--- a/configure
+++ b/configure
@@ -1,11 +1,6 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # This is not an autoconf generated configure
-#
-# Influential LIBBPF environment variables:
-#   LIBBPF_FORCE={on,off}   on: require link against libbpf;
-#                           off: disable libbpf probing
-#   LIBBPF_DIR              Path to libbpf DESTDIR to use
 
 INCLUDE="$PWD/include"
 
@@ -491,6 +486,10 @@ usage()
 	cat <<EOF
 Usage: $0 [OPTIONS]
 	--include_dir		Path to iproute2 include dir
+	--libbpf_dir		Path to libbpf DESTDIR
+	--libbpf_force		Enable/disable libbpf by force. Available options:
+				  on: require link against libbpf, quit config if no libbpf support
+				  off: disable libbpf probing
 	-h | --help		Show this usage info
 EOF
 	exit $1
@@ -505,6 +504,15 @@ else
 			--include_dir)
 				INCLUDE=$2
 				shift 2 ;;
+			--libbpf_dir)
+				LIBBPF_DIR="$2"
+				shift 2 ;;
+			--libbpf_force)
+				if [ "$2" != 'on' ] && [ "$2" != 'off' ]; then
+					usage 1
+				fi
+				LIBBPF_FORCE=$2
+				shift 2 ;;
 			-h | --help)
 				usage 0 ;;
 			"")
-- 
2.26.3

