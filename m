Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827661B658B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 22:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgDWUhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 16:37:55 -0400
Received: from relay2.marples.name ([77.68.23.143]:42062 "EHLO
        relay2.marples.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgDWUhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 16:37:55 -0400
X-Greylist: delayed 13477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2020 16:37:54 EDT
Received: from mail.marples.name (cpc115040-bour7-2-0-cust370.15-1.cable.virginm.net [81.108.15.115])
        by relay2.marples.name (Postfix) with ESMTPS id 076BE807
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 20:37:54 +0000 (UTC)
Received: from [10.73.0.30] (uberpc.marples.name [10.73.0.30])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.marples.name (Postfix) with ESMTPSA id 10ABB491E
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 21:37:53 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marples.name;
        s=mail; t=1587674273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yKLrOljADJd251/sjY/sg9T0uYP7Yoc26fkVr1L8qFc=;
        b=PZU9R98rcj6Z8L0uJYJt+VttaUudwf8EIHOR+kFEUwVdEJqIMvfz2QGPzHFd7wAFiihvuq
        0X4slyyBfTez8cfN03owJXDUjG3sOxm0T17gSgnDCGUy7q95P0MqZUyz+ZBdCNlsYarMcb
        jfeYL4l2ao3lWK1j3REiGYtDiX8h+SE=
Subject: [PATCH RESEND net] netlink: Align NLA_ALIGNTO with the other ALIGNTO
 macros
From:   Roy Marples <roy@marples.name>
To:     netdev@vger.kernel.org
References: <f8725c2b-635f-1da9-d2f6-4f34777b194a@marples.name>
Message-ID: <2963ad6d-6c64-f8ba-8ea8-a80d4647e306@marples.name>
Date:   Thu, 23 Apr 2020 21:37:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f8725c2b-635f-1da9-d2f6-4f34777b194a@marples.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids sign conversion errors.

Signed-off-by: Roy Marples <roy@marples.name>

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 0a4d73317759..c9ed05f14005 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -227,7 +227,7 @@ struct nlattr {
  #define NLA_F_NET_BYTEORDER    (1 << 14)
  #define NLA_TYPE_MASK          ~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)

-#define NLA_ALIGNTO            4
+#define NLA_ALIGNTO            4U
  #define NLA_ALIGN(len)         (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
  #define NLA_HDRLEN             ((int) NLA_ALIGN(sizeof(struct nlattr)))
