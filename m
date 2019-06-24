Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B21A51D62
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfFXVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:51:16 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37840 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:51:15 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so10992656qkl.4
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JtZJ1L4mEHJrpTVc7Bh187AF9hr6CX92oOJfS5iiy/Y=;
        b=hOiY8m4E/HMnStttqjIul0WQDgpYs7gPSazRpvWr63oyhn/wCcYmx+5Mhr6hDEbtV6
         TLboAg5/B/ycWKiQXyzxc1rJcFQzyVwWGLRSZvJ+G5ifq3ZaatW0ZtmEp3F9vEh4sjKB
         n/A9WHQ28RmiGZkEq1DcOjueWko0K9TiVvvrPz5scUZ5c0H58dBcJ1oDlb1Y4rQlk8QK
         DS5fy8FIUCPG+QfFB7VUgOij/ClIKAoFgYA0KRI/XqV+Rl6zajabbiQB1/Cco3FF4bLA
         uwsbC5GLZ/hiv7VW3I3q2jSCgn8BWMcs46X9nQ839VQu4yemK/bCyoi/HSEWB6gc+4IR
         w0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JtZJ1L4mEHJrpTVc7Bh187AF9hr6CX92oOJfS5iiy/Y=;
        b=MN+oqChhwMYZqm4mz1jqP5dITSqAl+PYmNwC8OAyZY062OB4BcZO3+Odfs/XvG4RRt
         U5+ksjO6/tFO7Nnb76G514nLMj+yxmDszOceYDoIXQvz9uf58lF8IC5aH8+qFumbmrgF
         LZRXhtJeqrH9htZYkLn8Rttt5wZqFbWeKDG65mNyvU0NVTV2ryYkMEApwh3dFGdpU4um
         3VF0Ypau9+Rz3LsfnXCnmsKpcWkaXjMQwrjWQiVSddBPkt0PQHcCD17gWuOnl92O0pj8
         KtvX2+OTGXpzy/ol9VslSAqeoC2q7Dxc4xOi4uhYPdXFbJah1+8+wDxgfZu5QiO1NvJM
         2mhA==
X-Gm-Message-State: APjAAAXuq9biz1f49plyisfYFbqMmsyTOxJWtuD6wi1DIVgG40QHQoOZ
        KqRmtPFb5+iRsADHAmlS/bheGA==
X-Google-Smtp-Source: APXvYqzxF5p5XE8xqv/dh3qi1H+Lpwizj+C/H5xSPHDoLrx3SrdVllgN4VPFutVDi+X/UR597oPXPw==
X-Received: by 2002:ae9:ef92:: with SMTP id d140mr18659588qkg.443.1561413074838;
        Mon, 24 Jun 2019 14:51:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v2sm6007335qtf.24.2019.06.24.14.51.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 14:51:14 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:51:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Takshak Chahande <ctakshak@fb.com>, netdev@vger.kernel.org,
        ast@kernel.org, rdna@fb.com, kernel-team@fb.com,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Message-ID: <20190624145111.49176d8e@cakuba.netronome.com>
In-Reply-To: <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
References: <20190621223311.1380295-1-ctakshak@fb.com>
        <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 16:22:25 +0200, Daniel Borkmann wrote:
> On 06/22/2019 12:33 AM, Takshak Chahande wrote:
> > With different bpf attach_flags available to attach bpf programs specially
> > with BPF_F_ALLOW_OVERRIDE and BPF_F_ALLOW_MULTI, the list of effective
> > bpf-programs available to any sub-cgroups really needs to be available for
> > easy debugging.
> > 
> > Using BPF_F_QUERY_EFFECTIVE flag, one can get the list of not only attached
> > bpf-programs to a cgroup but also the inherited ones from parent cgroup.
> > 
> > So "-e" option is introduced to use BPF_F_QUERY_EFFECTIVE query flag here to
> > list all the effective bpf-programs available for execution at a specified
> > cgroup.
> > 
> > Reused modified test program test_cgroup_attach from tools/testing/selftests/bpf:
> >   # ./test_cgroup_attach
> > 
> > With old bpftool (without -e option):
> > 
> >   # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/
> >   ID       AttachType      AttachFlags     Name
> >   271      egress          multi           pkt_cntr_1
> >   272      egress          multi           pkt_cntr_2
> > 
> >   Attached new program pkt_cntr_4 in cg2 gives following:
> > 
> >   # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
> >   ID       AttachType      AttachFlags     Name
> >   273      egress          override        pkt_cntr_4
> > 
> > And with new "-e" option it shows all effective programs for cg2:
> > 
> >   # bpftool -e cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
> >   ID       AttachType      AttachFlags     Name
> >   273      egress          override        pkt_cntr_4
> >   271      egress          override        pkt_cntr_1
> >   272      egress          override        pkt_cntr_2
> > 
> > Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> > Acked-by: Andrey Ignatov <rdna@fb.com>  
> 
> Applied, thanks!

This is a cgroup-specific flag, right?  It should be a parameter 
to cgroup show, not a global flag.  Can we please drop this patch 
from the tree?
