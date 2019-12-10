Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE73E118D36
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfLJQF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:05:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40722 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfLJQF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 11:05:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id t14so3787272wmi.5;
        Tue, 10 Dec 2019 08:05:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=tXdEloH9GmIwAGeGbGRl5PR3T9VcJC7HTQjpethawjY=;
        b=VEiaigHeKrkaOrICF39qfJiQBLSN9PFUnWNaH47NIthcTREEKP0aSk8T5RsFchghaT
         zyRGwBBZUNPH8ce9ZkmP7ODh9zPyq824swidTO6RRm58EYisLTol/03/qh9Hrd2GAebH
         agpvZkxnLO2KI9o2zZ42frqJEITtlzMcHottIYLjZPleZvYmb/cqYKyC913ko5FoObZc
         WhCzLEV4puPO14YrpOq9AvUh9I/WI1MEl4WBz6OvoiMez12fz+/mreYd31qZUdTqIOSD
         0Xx7tXdIWhuZxjelpmAT1lo3Xsecy/4a1t2y0VCJCITpPeTybEzSTvzfBujyzMjGJepH
         m+3g==
X-Gm-Message-State: APjAAAW2NGj8qyjOMEKfDV3IKAcTNgbsBS38vLmLUkRpeUIMQhDjGY5d
        EcvsafJXaPoGyH+69Mc4ado=
X-Google-Smtp-Source: APXvYqzr9wqBqBn98GaDLhVjUUJGk0PiZhgQ4TPTrhEIO0XdGTgd/1bsTVqHefBKf0fR/CHG09fXaQ==
X-Received: by 2002:a1c:5603:: with SMTP id k3mr6285078wmb.150.1575993956260;
        Tue, 10 Dec 2019 08:05:56 -0800 (PST)
Received: from Nover ([161.105.209.130])
        by smtp.gmail.com with ESMTPSA id i16sm3742936wmb.36.2019.12.10.08.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 08:05:56 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:05:55 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 0/3] bpftool: match programs and maps by names
Message-ID: <cover.1575991886.git.paul.chaignon@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When working with frequently modified BPF programs, both the ID and the
tag may change.  bpftool currently doesn't provide a "stable" way to match
such programs.  This patchset allows bpftool to match programs and maps by
name.

When given a tag that matches several programs, bpftool currently only
considers the first match.  The first patch changes that behavior to
either process all matching programs (for the show and dump commands) or
error out.  The second patch implements program lookup by name, with the
same behavior as for tags in case of ambiguity.  The last patch implements
map lookup by name.

Paul Chaignon (3):
  bpftool: match several programs with same tag
  bpftool: match programs by name
  bpftool: match maps by name

 .../bpf/bpftool/Documentation/bpftool-map.rst |  12 +-
 .../bpftool/Documentation/bpftool-prog.rst    |  18 +-
 tools/bpf/bpftool/bash-completion/bpftool     | 145 ++++++-
 tools/bpf/bpftool/main.h                      |   4 +-
 tools/bpf/bpftool/map.c                       | 366 +++++++++++++---
 tools/bpf/bpftool/prog.c                      | 389 +++++++++++++-----
 6 files changed, 735 insertions(+), 199 deletions(-)

-- 
2.17.1

