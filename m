Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CCD1D1EFA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390580AbgEMTXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:23:44 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E10C061A0C;
        Wed, 13 May 2020 12:23:44 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j2so862061ilr.5;
        Wed, 13 May 2020 12:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=QBmPL46g6a5Wyv3wSsi2vj/vNv6Xuxxw+AobVp19YsQ=;
        b=HMPCn76QwDADi/1b8E7aDRnsPvYn8/t17N38KHuHUWBuvm0wyARMY+8djk0B6vcF/4
         Upi6D2VAyY5EQ8xgbpPqViJhiTADvRaO2nvMl+fvha0ayrYOEENb9IwKuHIVWgLLmnX7
         eMHhJXyiEVYtt33GbQNpDMkh5acvjGDvJQGZk8JJYhV0UfPuDeCNf33yd06+qC0Wnjdr
         0P8Bdk5NSg59FCOGmTYlb0EebT2Rdnl1kCjtI9yavOwNLg53eq9He4ijLjP5pIHDo+Ov
         BOO5G+S8PAf82F+0t7SxEKmD9jJRo8DMo0S3SUFsKlnnZsQxYc+yp/7BVfrXdUsTPp7p
         VTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=QBmPL46g6a5Wyv3wSsi2vj/vNv6Xuxxw+AobVp19YsQ=;
        b=p5xyZVptcdtMTKgXkDSYclI+qOuZjezbuppX8elvwS6vbwBjkLxP7v7z6Be1QcqdXl
         y9pH+MqURmWzqEvLlUAufGfVgA7AEyy6b7wSWH2VUKiusZtIArQytofJ6EwHo3cBjrnu
         Y381RHS60V8JdCMfur5bU0/l4PrH+y4JK4PE+qyv/XsbqAtNcxlZAm7oTnKVgsoL9CJo
         v5O2vZqzoJb66C8w3TkFUF6AH7mnTonu+c8gn5zUTem9Ne3D09xOc9gChspE5KZQID0y
         5PFGE5L51GIsFi8QAzGFlPFPQfoSUT5l97D4Ej6trDrbu9wGCh1STHGkMtuEsEBCZaL0
         DkFg==
X-Gm-Message-State: AOAM533TKdZMXR8KKWs/IM2fI54ZlBDoM9kgP3CjapPqEvaFb9JyVpkk
        i9EqOPfzdmLIICbsjMNJKdXW7/ae
X-Google-Smtp-Source: ABdhPJyqNH4HVdFrZD2yslEUxVmS3x+WpJCeO2WWIleFI+ukfUNhZwJjSmxXtRBtbp6efc7CqB9HOQ==
X-Received: by 2002:a92:aa8b:: with SMTP id p11mr1087542ill.228.1589397824142;
        Wed, 13 May 2020 12:23:44 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e19sm224896iob.1.2020.05.13.12.23.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:23:43 -0700 (PDT)
Subject: [bpf-next PATCH 0/3] bpf: Add sk_msg helpers 
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Wed, 13 May 2020 12:23:32 -0700
Message-ID: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds helpers for sk_msg program type.

Add a set of helpers that makes sk_msg more useful. Notable add the
*current_task* getters and the probe_* routines guarded by a capabilities
check for CAP_SYS_ADMIN.

 BPF_FUNC_perf_event_output
 BPF_FUNC_get_current_uid_gid
 BPF_FUNC_get_current_pid_tgid
 BPF_FUNC_get_current_cgroup_id
 BPF_FUNC_get_current_ancestor_cgroup_id
 BPF_FUNC_get_cgroup_classid

 BPF_FUNC_get_current_task
 BPF_FUNC_current_task_under_cgroup
 BPF_FUNC_probe_read_user
 BPF_FUNC_probe_read_kernel
 BPF_FUNC_probe_read
 BPF_FUNC_probe_read_user_str
 BPF_FUNC_probe_read_kernel_str
 BPF_FUNC_probe_read_str

 BPF_FUNC_sk_storage_get
 BPF_FUNC_sk_storage_delete

I have an RFC test for sk_storage_* patch that is pending merge of
other sockmap_test patches.

---

John Fastabend (3):
      bpf: sk_msg add some generic helpers that may be useful from sk_msg
      bpf: sk_msg helpers for probe_* and *current_task*
      bpf: sk_msg add get socket storage helpers


 include/uapi/linux/bpf.h |    2 +
 kernel/trace/bpf_trace.c |   16 ++++++-----
 net/core/filter.c        |   65 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 8 deletions(-)

--
Signature
