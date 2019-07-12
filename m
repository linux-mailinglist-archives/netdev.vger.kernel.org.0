Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8553566361
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 03:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfGLBfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 21:35:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43957 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfGLBfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 21:35:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so3755447pgv.10
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 18:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TKZ1LuXHr1JpoBiDvXz797CS79UfB8U18zpY2ba3tso=;
        b=c5r0+emfqfgNC+E6k4qVRW2Wm4QmMFBG1Gm2ADs2dxWnxPSwDdBgbYXVyveOjH0/w4
         PzW3FormD3+X8r13dc635ikpgCplMvuL61UtRFvLNbN8zpuSnR5Ln+/phTX+lbkvUA9w
         Qk5JG6zZq0c9GaPFbO8eMp5a0fNSVCpJxkcAu5YqYfnHGoONMCABljbsQ4DJDMR5pXPL
         GCtinv4MMwzOylgnTvPbhty0wfylWSwpEQ1jJ/xF9Mn9CjVJhFDRso6HVYT8vby0EGjs
         S5LATriL/MS9HG3TaLjsq84Ad/1UsQYRC47KeYtLQpiYXxUiayzg28wF4Qw2fVCYABD+
         kS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TKZ1LuXHr1JpoBiDvXz797CS79UfB8U18zpY2ba3tso=;
        b=ckKmHwFTiIkP3qTt5oa+G8Nyfvl6tt3TaLRx1Z+mkAyCrI0KvPwr7qseS6xEv1E9LR
         RrfGEyv1+Z2HfV4p2XXYnM28D/S7WM2+qfo1NREvgvLb43Au8AhQXkRNWDjzCurecs+E
         1sU276lWWPTe31GFbtvVgz+Nob7D+LVmeRffZ/9NOi+R3PE/HP8z1qNBJ5Rky1gwitti
         MrWIxA3HhPjKYQVin4PD/EKDjbdjoiA0PadzIHbQYE9B9oWlbwBA7xQGJRJSMfYAOkwO
         uOkS+I2ovd/2AdZ70/2kE6Mbsc94ln1GnecH6RbTr2xx53iaE4jXXFgFTi4cXTFrrp9f
         BiNg==
X-Gm-Message-State: APjAAAUMunl4wgpnyjCOVtWU+avhlrkI6q6PAJanz8jERmZcedpOW8BA
        94kPO63i/PBJRXQldgRhnWVrfDiuv98M
X-Google-Smtp-Source: APXvYqxXD5DoqO88cU1uQDeL3kZc7l7eFHtHCe5soDJQoyTJjoU1mUrvSQGAdz1SfY0TAEhF41eYyw==
X-Received: by 2002:a63:fb4b:: with SMTP id w11mr7568398pgj.415.1562895349536;
        Thu, 11 Jul 2019 18:35:49 -0700 (PDT)
Received: from localhost.localdomain ([58.76.163.19])
        by smtp.gmail.com with ESMTPSA id o32sm6331260pje.9.2019.07.11.18.35.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 18:35:48 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] tools: bpftool: add raw_tracepoint_writable prog type to header
Date:   Fri, 12 Jul 2019 10:35:39 +0900
Message-Id: <20190712013539.17407-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints"),
a new type of BPF_PROG, RAW_TRACEPOINT_WRITABLE has been added.

Since this BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE is not listed at
bpftool's header, it causes a segfault when executing 'bpftool feature'.

This commit adds BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE entry to
prog_type_name enum, and will eventually fixes the segfault issue.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/main.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 3ef0d9051e10..7031a4bf87a0 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -74,6 +74,7 @@ static const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_SK_REUSEPORT]		= "sk_reuseport",
 	[BPF_PROG_TYPE_FLOW_DISSECTOR]		= "flow_dissector",
 	[BPF_PROG_TYPE_CGROUP_SYSCTL]		= "cgroup_sysctl",
+	[BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE]	= "raw_tracepoint_writable",
 	[BPF_PROG_TYPE_CGROUP_SOCKOPT]		= "cgroup_sockopt",
 };
 
-- 
2.17.1

