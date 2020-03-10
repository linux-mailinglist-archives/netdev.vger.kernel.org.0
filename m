Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7CF180AC4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgCJVqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:46:03 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35893 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJVqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:46:03 -0400
Received: by mail-pl1-f177.google.com with SMTP id g12so62365plo.3;
        Tue, 10 Mar 2020 14:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0QWUlQ6TAxo5AJHtPDkRjusgzM7PzqNClJfu4qAMvk4=;
        b=M9hJQ505ZvW1Y+u+YQS+KXAjabukxbA/oKuyRsmBp1aImuOp6rDwgxuCtMjT7T5FRe
         we6+osO4WHEZMh4TGZjf+q+g6Tmx+25sJryOfYaR7TsgK1dKWYjLY6Bxq/jayG6VT/x9
         XSRDa8lQuZvwXXvMfnDFj9vg9aNQAlpqVLWKgP/x73ojAk9NUl89Mz69enRCkoV5gD5m
         ThmxnRPS64fzptLd71Shrr9wcsjktZFZynJs8syXpOoJOD2G1QN2q/pQ/PZvVV4YAfGd
         4KuvOC1rRsvMrWq0j0BJRnl0K3+e8qiklxfkUPWlVhEvUmpyGF1+YVWsx8sq3BxxK6Q8
         8Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0QWUlQ6TAxo5AJHtPDkRjusgzM7PzqNClJfu4qAMvk4=;
        b=Np8Q1cFHElRFScOlRggNHcviTwDjQMYTIvL9HUaIUbPxMSt+3ssbXVr865wgAgvsp7
         fRxwe/x6PjtHYpDKDqHy+uTvQ7z53jh7eZGHuwBlHwuBFXvdzciI2BypUORG91zLgBba
         TnMi/lpCEfk0ihtOLfPx3AYL4heGs9VvtG9sdkm2/sC0dAVZviyrz7BpEQ230NjPRcov
         +3MVoe9epLwvFbi28k9TOm/mXXNbL1o9QXNXWG07ycAN+IZm5so4RFMWQjVVA5GJFqCU
         1zu+jt+Q1Lf4ERFQTOQj4H2gpqGjvvcuF6yp8GD89yCsW7Ef+nON3t32GvdlNhnloy6P
         OPxw==
X-Gm-Message-State: ANhLgQ0ZENStlNB31l1/mWpsYzgtHg8po2DZ5jaWbckgSw50nAnmmrvU
        RsXP8wYH8aTCe8gOaSIqS/0=
X-Google-Smtp-Source: ADFU+vswKhqitiydc/ruHGRUrB3YiWWwuMnw9ZsntI12ntAk9jHkp7nhsyHyVwillSfTDPwRQBH6YA==
X-Received: by 2002:a17:90a:9515:: with SMTP id t21mr51003pjo.14.1583876760868;
        Tue, 10 Mar 2020 14:46:00 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w206sm6150524pfc.54.2020.03.10.14.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:46:00 -0700 (PDT)
Date:   Tue, 10 Mar 2020 14:45:52 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5e680a909371e_586d2b10f16785b8c9@john-XPS-13-9370.notmuch>
In-Reply-To: <20200309231051.1270337-1-andriin@fb.com>
References: <20200309231051.1270337-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next] bpf: add bpf_link_new_file that doesn't install
 FD
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add bpf_link_new_file() API for cases when we need to ensure anon_inode is
> successfully created before we proceed with expensive BPF program attachment
> procedure, which will require equally (if not more so) expensive and
> potentially failing compensation detachment procedure just because anon_inode
> creation failed. This API allows to simplify code by ensuring first that
> anon_inode is created and after BPF program is attached proceed with
> fd_install() that can't fail.
> 
> After anon_inode file is created, link can't be just kfree()'d anymore,
> because its destruction will be performed by deferred file_operations->release
> call. For this, bpf_link API required specifying two separate operations:
> release() and dealloc(), former performing detachment only, while the latter
> frees memory used by bpf_link itself. dealloc() needs to be specified, because
> struct bpf_link is frequently embedded into link type-specific container
> struct (e.g., struct bpf_raw_tp_link), so bpf_link itself doesn't know how to
> properly free the memory. In case when anon_inode file was successfully
> created, but subsequent BPF attachment failed, bpf_link needs to be marked as
> "defunct", so that file's release() callback will perform only memory
> deallocation, but no detachment.
> 
> Convert raw tracepoint and tracing attachment to new API and eliminate
> detachment from error handling path.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
