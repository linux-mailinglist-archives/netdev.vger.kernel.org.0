Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026DBF2389
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfKGAwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:52:02 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:39110 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKGAwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 19:52:02 -0500
Received: by mail-pf1-f177.google.com with SMTP id x28so759419pfo.6;
        Wed, 06 Nov 2019 16:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D/M9OydzPO/UgaX+FYiSgWUI1xGo+eZfOL/yXoivzNI=;
        b=gzvgBfYt2PvGYYZJxI91RnIxbiMUB/LjlOArQTN6ZZaCVw5/laYC5rEo/22A16nDI4
         bGyahsvnM/SbxG7Mug/QW5dwwIL8rX2t7lQGRKf4x/6KMdUuPWkDw78L1ojF5noK1zWM
         7BgtzL3sFZLGattFmVOgjXGqrsM2p+3NonU3rbCzskQTcQW4AacTmclKWeuqfqMalI3Z
         UmltPKrbsb5sWgn6Sa5dlPfNz5MN8EO2zT8AUWw8yPMpEiIPlV/Gp0Srv2m1GcVZWUuY
         6bmYzHAil2UCOtedUOzb5GTrZqqWU2HGJYBzu8dQiIeBsQPplcGjqfvq5pBxeD6RPdQT
         Q8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D/M9OydzPO/UgaX+FYiSgWUI1xGo+eZfOL/yXoivzNI=;
        b=QL5sLfAb5tcT0vEuLnZ1XFxNuNd3Trtn58AryGeCYh6yNQ9ujwrWzFHnDMfSzvoTkH
         s8H1FlvLlQKc7y4ACMMflJ+8BmB8qJvlIGHxrW2tlWhjwx+w0N1XSsPFDkhj9/Z1o6eJ
         NoWVsMtqGg5wObh3RvY9q3u8xERVbT81P00u2B2d+AgwMFRjRX1zdo032yzksDnIxskM
         Qi9lNLW5c6fB3ZwqL2X5w6jxGQL7Moy1MR0NkWsn2TNHdL+VxYFbVk7wdc/mpl/6E+xY
         M9jwAjstPyFCXAMWWxfGLUCdc7ueUsZF5gZ9zrChZOURkTEH6fLbcVFVJGKpMwdCJMOZ
         OeCg==
X-Gm-Message-State: APjAAAVG+cZLSNcAmB28yuvofzPyCVy6JZCpbHrONgJSUZboLLUdICUr
        LzEriwbId8uvTri+vAZuaqFEehD16JmV
X-Google-Smtp-Source: APXvYqwE0Kw1Lr57hJrKf2YCBvaywsdXkSsaqQ5vjkTWRFNXWT65U04S2Bn4exhtUmO+e2EEslEZxg==
X-Received: by 2002:a63:ff26:: with SMTP id k38mr1016742pgi.128.1573087921090;
        Wed, 06 Nov 2019 16:52:01 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id m68sm186606pfb.122.2019.11.06.16.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 16:52:00 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next v2 0/2] samples: bpf: update map definition to new syntax BTF-defined map
Date:   Thu,  7 Nov 2019 09:51:51 +0900
Message-Id: <20191107005153.31541-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since, the new syntax of BTF-defined map has been introduced,
the syntax for using maps under samples directory are mixed up.
For example, some are already using the new syntax, and some are using
existing syntax by calling them as 'legacy'.

As stated at commit abd29c931459 ("libbpf: allow specifying map
definitions using BTF"), the BTF-defined map has more compatablility
with extending supported map definition features.

Also, unifying the map definition to BTF-defined map will help reduce
confusion between new syntax and existing syntax.

The commit doesn't replace all of the map to new BTF-defined map,
because some of the samples still use bpf_load instead of libbpf, which
can't properly create BTF-defined map.

This will only updates the samples which uses libbpf API for loading bpf
program. (ex. bpf_prog_load_xattr)

This patchset fixes some of the outdated error message regarded to loading
bpf program (load_bpf_file -> bpf_prog_load_xattr), and updates map
definition to new syntax of BTF-defined map.

v1 -> v2:
  - stick to __type() instead of __uint({key,value}_size) where possible

Daniel T. Lee (2):
  samples: bpf: update outdated error message
  samples: bpf: update map definition to new syntax BTF-defined map

 samples/bpf/hbm.c                   |   2 +-
 samples/bpf/sockex1_kern.c          |  12 ++--
 samples/bpf/sockex2_kern.c          |  12 ++--
 samples/bpf/xdp1_kern.c             |  12 ++--
 samples/bpf/xdp1_user.c             |   2 +-
 samples/bpf/xdp2_kern.c             |  12 ++--
 samples/bpf/xdp_adjust_tail_kern.c  |  12 ++--
 samples/bpf/xdp_fwd_kern.c          |  13 ++--
 samples/bpf/xdp_redirect_cpu_kern.c | 108 ++++++++++++++--------------
 samples/bpf/xdp_redirect_kern.c     |  24 +++----
 samples/bpf/xdp_redirect_map_kern.c |  24 +++----
 samples/bpf/xdp_router_ipv4_kern.c  |  64 ++++++++---------
 samples/bpf/xdp_rxq_info_kern.c     |  37 +++++-----
 samples/bpf/xdp_rxq_info_user.c     |   6 +-
 samples/bpf/xdp_sample_pkts_user.c  |   2 +-
 samples/bpf/xdp_tx_iptunnel_kern.c  |  26 +++----
 samples/bpf/xdp_tx_iptunnel_user.c  |   2 +-
 17 files changed, 185 insertions(+), 185 deletions(-)

-- 
2.23.0

