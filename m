Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7D813DB6D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgAPNWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:22:18 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59049 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726366AbgAPNWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:22:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579180937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVICxkwYE819T09jumS9b6kqZZVW9alGabNhw2Byv4c=;
        b=BGMS7Qso2vvxNKbeNU5Isy3YUTyy3KLha9b4tf5sU9DyV0RHLPzE6DftI3CI3oV+53GY25
        PsArIUENlTxqfd2HCRWFSENc9MP18rrb0HVWN0s6vdGQQQvxrhpMaVaj/1zqq9PSutAXGB
        p7gTpwWvD/H50XNi0dRjglYtwEYss/8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-XzyQzmCCO12b_eszd5c49A-1; Thu, 16 Jan 2020 08:22:15 -0500
X-MC-Unique: XzyQzmCCO12b_eszd5c49A-1
Received: by mail-lj1-f199.google.com with SMTP id v1so5126785lja.21
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:22:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oVICxkwYE819T09jumS9b6kqZZVW9alGabNhw2Byv4c=;
        b=rK6q1RvFAghiQweDzhHUFgmW6lH6RaHAEOjpvUyQg3OmJRo6Em1SQnp7BroXDEFzPJ
         H6mgn+dAYhNqHRQGtaGoX9hP+bgRocHnkT4nXB7CsO8KpLb34yLqHdSGvagu0/MoHmjw
         UDTYcR76qja2nKfYZOm2BzBT14jMy4HVX7t1Nbmrnh5PV9a0E3NDeQ9v7Qvhe8pS5u02
         lhjWyJ5PPlhowYyHxUIIpwu6/N/6yieCYDCJP9oEtme4SWWOOVddm1HbLCyF7xcd318o
         /RQghcVSRyEDtdqcXz3RzgZ/Q0nkcb3AhOj49w8NVWTXu7tJkmMluv4mrjPcVjWGS/lU
         FuNw==
X-Gm-Message-State: APjAAAWgcYkQuTIM61efHlci0WcrqQJ6u/iTaQjxK3I9NhUJ5S1hlMT4
        Z8pnVYgJzrq7prTWrf95Frtjw7TKI05jZWLHW44NsntiwajL9i8kViud03zwwnTyh1HDqfi2dkc
        6cvgYIUNpzKlT5m+D
X-Received: by 2002:a2e:b007:: with SMTP id y7mr2286047ljk.215.1579180934266;
        Thu, 16 Jan 2020 05:22:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQWrcaU+nW1F4XoH997rZHaa169MNBHkP1drBFjaeoj4ZaAxptcEhRwkbakFT89vmLfrEkOg==
X-Received: by 2002:a2e:b007:: with SMTP id y7mr2286032ljk.215.1579180934124;
        Thu, 16 Jan 2020 05:22:14 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f16sm10703433ljn.17.2020.01.16.05.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:22:13 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D9E2F1804D7; Thu, 16 Jan 2020 14:22:12 +0100 (CET)
Subject: [PATCH bpf-next v3 01/11] samples/bpf: Don't try to remove user's
 homedir on clean
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Thu, 16 Jan 2020 14:22:12 +0100
Message-ID: <157918093278.1357254.3453847369567754938.stgit@toke.dk>
In-Reply-To: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The 'clean' rule in the samples/bpf Makefile tries to remove backup
files (ending in ~). However, if no such files exist, it will instead try
to remove the user's home directory. While the attempt is mostly harmless,
it does lead to a somewhat scary warning like this:

rm: cannot remove '~': Is a directory

Fix this by using find instead of shell expansion to locate any actual
backup files that need to be removed.

Fixes: b62a796c109c ("samples/bpf: allow make to be run from samples/bpf/ directory")
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 5b89c0370f33..f86d713a17a5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -254,7 +254,7 @@ all:
 
 clean:
 	$(MAKE) -C ../../ M=$(CURDIR) clean
-	@rm -f *~
+	@find $(CURDIR) -type f -name '*~' -delete
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like

