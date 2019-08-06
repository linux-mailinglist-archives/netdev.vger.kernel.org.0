Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E7282863
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 02:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbfHFALG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 20:11:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41441 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbfHFALG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 20:11:06 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so3905966qtj.8
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 17:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8QBvLZD2PtMjFWXLXZHRh5JdLumVA7S4w1kwQFmHur8=;
        b=XTNHuX5DCsnABH8UbCWgalC8QIqM/NWIuoOu4eNtX/bnTvxaYXVbP+S7ZqRX5FT2Ar
         VIcg/qY+Gx3jm+zMyHPCRJMNlpl7RGUOmeVJl21jmF3KZpGWPDKMLUaDKM8x8nlAogTH
         uQs8DqlDKjB+KZa23cbpFFlh0N/ORtd8Sl0iN+N3t8tMGnXk8KsY2ErgJJVsO2I7d2e3
         TRPN6HL8FafrvUFZFWnKJFELdL1ZNznoTq0dL1jjEeAiUzoGtaIebBlRV0es+M1zYHG6
         gO23dbnKGRtpJTnwsSnzsjoWyqaXwd8MP2ngc+zKO6VY3FPfiX3iq7jmUAImG2apEYZc
         jTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8QBvLZD2PtMjFWXLXZHRh5JdLumVA7S4w1kwQFmHur8=;
        b=g1lHN0s8p4WKu3Q48ln2Nqrs1fisyQ/vlYz7Z9IqBxS3OQDQGVyp6ZjhcZTkRxtTUB
         BWML+ZleiKquxlkUxbx/i5pZSw/Kuhs50s8L1SOJ7gscEilmfVnYGq6GccEkVLfMl0pn
         uorF0YvMG4iKl3zFydhYhLT+MpQYSoKMCEgGrCKnoPsdTb60ccU2Z6IfGCK50uXVDtUN
         TFbi19V0GCYcjNZDdc/fzFbH6iQ9dccMzGiw274Yk4Q4ljX3GpVzsJSqApwygQWc8Oj+
         XTmE2Q/D+E5iTxj8HnRQ/pGLQ00N5Cp96dhq+Gvr2nTzBhbc6H487LRrDDzCw2bkdL9p
         82BA==
X-Gm-Message-State: APjAAAXCYWyNeOHeRiOu+D1UJACHTutI/i6ctWMSo2YR9CGj0mQP7P29
        LpSsFqyjEfkxZZUFrISsCdKV3g==
X-Google-Smtp-Source: APXvYqxJ5lPwiTVrHhNS0rW//zm2Mrk1T+bbsBVChBxwMn3Z9syXgDfBjLhoVKUZRNxA/hs1EcTy7Q==
X-Received: by 2002:a0c:f8c5:: with SMTP id h5mr609172qvo.12.1565050264988;
        Mon, 05 Aug 2019 17:11:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c5sm39049453qkb.41.2019.08.05.17.11.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 17:11:04 -0700 (PDT)
Date:   Mon, 5 Aug 2019 17:10:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Y Song <ys114321@gmail.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Farid Zakaria <farid.m.zakaria@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/1] bpf: introduce new helper udp_flow_src_port
Message-ID: <20190805171036.5a5bf790@cakuba.netronome.com>
In-Reply-To: <CAH3MdRXTEN-Ra+61QA37hM2mkHx99K5NM7f+H6d8Em-bxvaenw@mail.gmail.com>
References: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
        <20190803044320.5530-2-farid.m.zakaria@gmail.com>
        <CAH3MdRXTEN-Ra+61QA37hM2mkHx99K5NM7f+H6d8Em-bxvaenw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Aug 2019 23:52:16 -0700, Y Song wrote:
> >  include/uapi/linux/bpf.h                      | 21 +++++++--
> >  net/core/filter.c                             | 20 ++++++++
> >  tools/include/uapi/linux/bpf.h                | 21 +++++++--
> >  tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
> >  .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
> >  .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
> >  6 files changed, 131 insertions(+), 8 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c  
> 
> First, for each review, backport and sync with libbpf repo, in the future,
> could you break the patch to two patches?
>    1. kernel changes (net/core/filter.c, include/uapi/linux/bpf.h)
>    2. tools/include/uapi/linux/bpf.h
>    3. tools/testing/ changes

A lot of people get caught off by this, could explain why this is
necessary?

git can deal with this scenario without missing a step, format-patch
takes paths:

$ git show --oneline -s
1002f3e955d7 (HEAD) bpf: introduce new helper udp_flow_src_port

$ git format-patch HEAD~ -- tools/include/uapi/linux/bpf.h
0001-bpf-introduce-new-helper-udp_flow_src_port.patch

$ grep -B1 changed 0001-bpf-introduce-new-helper-udp_flow_src_port.patch 
 tools/include/uapi/linux/bpf.h | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

$ cd ../libbpf
$ git am -p2 ../linux/0001-bpf-introduce-new-helper-udp_flow_src_port.patch
Applying: bpf: introduce new helper udp_flow_src_port
error: patch failed: include/uapi/linux/bpf.h:2853
error: include/uapi/linux/bpf.h: patch does not apply
...

Well, the patch doesn't apply to libbpf right now, but git finds the
right paths and all that.

IMO it'd be good to not have this artificial process obstacle and all
the "sync headers" commits in the tree.
