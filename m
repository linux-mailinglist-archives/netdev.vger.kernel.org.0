Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C302920A9B4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgFZAJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgFZAJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:09:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BD8C08C5DB
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:09:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r17so7788347ybj.22
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Po39cTrb4umUGd/JnKFlg9lYtuzyyRnUnXZQpa3U0lU=;
        b=OruMzUJGvxCCYiWGiEkVCinWPSdqr1wMBdbZV0GzX37FKfkT849ItKzQF4DwCmkbRD
         Xa39dWBv2pzYUvw6xuUKvQtx3h3ybZxA5tWZJmB/vkQQpdPL59WK3TZXQZ/mZqMWXD5J
         IscQp7tvMAunXFqJqypEj3K5cFB5wigaCq2zENnZoFQAHBJow9BpjC2AzIiPKR0DdtQ0
         b8/HoDKKfr8Fm+j4T00hbUWlxpEgixT+H5jUCG70+p0fEF1yOfkNCcnfU8AmCgfDTr0g
         yyMdOH8Py5TN8Si31ppSHBP8yuSRxh4TAk1/dyleuqXul9XEyh4dqxj07ilj8RgUJ0S9
         zniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Po39cTrb4umUGd/JnKFlg9lYtuzyyRnUnXZQpa3U0lU=;
        b=nnKQJLla/YTyTf9QmWHWSX4J+rP1eoT1Lg0aID3EpMdLBCZZ/TGx/RI7cyvZJd/P0d
         mgczQ4NvTggxt44FOSbYu4O1GjaP2d7C/Aw+KDASBb9dXNHyAYKJSKkGrJ+AyeSM/MnV
         8hL3Ncw0VeEZ83L7W88PUwa92RYSu0BdP5yedNcxh3BWvrOBYOWpwqO7amcbD9+cNoqK
         pIJBKq3Yd2czjvieyUH/y/fu3hVKKJ1nLfriQQ5tHMFFZYlGmCMAeOc6CraVXjS4AsYq
         Jr+VjvmNpZOQo/6ag8dEoQE2D0Vvrzh6BVcT/+7tQp+jf6L3V74n5BwAPP9pRiwS4c6g
         dTvw==
X-Gm-Message-State: AOAM530CX3UuYoFFEyWvi8qvSG+T7W6T+VcEesdsU9sPaoLHcbogYkSe
        mL1p4dePwXXDaXwKhQIMBuXATtxcZ1u+ZLGln4Lm/rIeo8U4n7JsGYfjiHQWOIgVscb1l3dKSP2
        UFdRUnD91IcDWB2GEEJHJ6kpyOFBFHURdTAJNo9QNAuqgiQzEzPPihg==
X-Google-Smtp-Source: ABdhPJxCU7Cn8UcnnQpFemEz22ZR+/j2WiU/1JW7YkYSdNLk6xgmRCVfOPQAZJVIbp1qu2tuliJU78g=
X-Received: by 2002:a05:6902:4ef:: with SMTP id w15mr740042ybs.44.1593130175290;
 Thu, 25 Jun 2020 17:09:35 -0700 (PDT)
Date:   Thu, 25 Jun 2020 17:09:28 -0700
In-Reply-To: <20200626000929.217930-1-sdf@google.com>
Message-Id: <20200626000929.217930-3-sdf@google.com>
Mime-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH bpf-next 3/4] bpftool: support BPF_CGROUP_INET_SOCK_RELEASE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support attaching to sock_release from the bpftool.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/main.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 5cdf0bc049bd..0a281d3cceb8 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -92,6 +92,7 @@ static const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
 	[BPF_CGROUP_INET_EGRESS] = "egress",
 	[BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
+	[BPF_CGROUP_INET_SOCK_RELEASE] = "sock_release",
 	[BPF_CGROUP_SOCK_OPS] = "sock_ops",
 	[BPF_CGROUP_DEVICE] = "device",
 	[BPF_CGROUP_INET4_BIND] = "bind4",
-- 
2.27.0.111.gc72c7da667-goog

