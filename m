Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809A42C53EA
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgKZMYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbgKZMYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 07:24:43 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D54AC0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 04:24:43 -0800 (PST)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 196CE86B82;
        Thu, 26 Nov 2020 12:24:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606393482; bh=bAkZeI6quyaf2BpyY5/Ib6Uv+UcFWy1pvn6QbwxRP7Q=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20net
         -next=202/2]=20docs:=20update=20ppp_generic.rst=20to=20document=20
         new=20ioctls|Date:=20Thu,=2026=20Nov=202020=2012:24:26=20+0000|Mes
         sage-Id:=20<20201126122426.25243-3-tparkin@katalix.com>|In-Reply-T
         o:=20<20201126122426.25243-1-tparkin@katalix.com>|References:=20<2
         0201126122426.25243-1-tparkin@katalix.com>;
        b=2tsDPZffgeQFH3RUDTM9n18APf445vnR2tDIhKWZHEKgJrL63KIqCIkLJZiCP0olr
         BTQDPIwxY4tcUz95zCDiy2+UYuQRh4t/5IWJVW8+97/TycgLbkcDaAAEkSfhQyBw+Y
         Biqgc0Yn2D/MsAQelfYKsRPEq7r57NcqMON/whtpBcclYHslYweGygBhCvMl1ref8r
         eHWCPWxr19uDkdjcjAiaYpd37+qVa1AA0En9F/UnhJZnIaiOL8QwIs5NvGH6dwiJwa
         b9eXJMRDld7t7rsXaj8ZT8Kt4AptkkZZUk2rAYFTCt9Ttm9ZHddRQlN7vUyT6YKDN0
         svVz0KoCcr0cw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 2/2] docs: update ppp_generic.rst to document new ioctls
Date:   Thu, 26 Nov 2020 12:24:26 +0000
Message-Id: <20201126122426.25243-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126122426.25243-1-tparkin@katalix.com>
References: <20201126122426.25243-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of the newly-added PPPIOCBRIDGECHAN and
PPPIOCUNBRIDGECHAN ioctls.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 Documentation/networking/ppp_generic.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/networking/ppp_generic.rst b/Documentation/networking/ppp_generic.rst
index e60504377900..be25f48468a6 100644
--- a/Documentation/networking/ppp_generic.rst
+++ b/Documentation/networking/ppp_generic.rst
@@ -314,6 +314,15 @@ channel are:
   it is connected to.  It will return an EINVAL error if the channel
   is not connected to an interface.
 
+* PPPIOCBRIDGECHAN bridges a channel with another.  Once two channels
+  are bridged, frames presented to one channel by ppp_input() are passed
+  to the bridge instance for onward transmission.  This allows frames
+  to be switched from one channel into another: for example, to pass
+  PPPoE frames into a PPPoL2TP session.
+
+* PPPIOCUNBRIDGECHAN performs the inverse of PPPIOCBRIDGECHAN, unbridging
+  a channel pair.
+
 * All other ioctl commands are passed to the channel ioctl() function.
 
 The ioctl calls that are available on an instance that is attached to
-- 
2.17.1

