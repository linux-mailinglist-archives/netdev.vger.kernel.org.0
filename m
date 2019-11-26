Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0310A6A7
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfKZWhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:37:50 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42491 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfKZWhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:37:50 -0500
Received: by mail-io1-f66.google.com with SMTP id k13so22503498ioa.9;
        Tue, 26 Nov 2019 14:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DK72RUpIHQodTXdGnn/OPB97k6kSr9X/4FdYqG2aVhc=;
        b=COfC0JG/oJMjwF5A2/w9CRWNMpaiFDdIZfIrXJ9Dj9D2CL3ci0uZfq6VnRawkhG1ST
         krVfmuBtDDek8r+ajG5VybToQNCfb4JPG+L7Oyi9i7T8BAUBrsF1jJ5TnVR7HN8iEcv+
         3yo5g+R+e94yGtq+NaXwXEpnvOm3gAPYNvqLYkoo/euVlxizjFs2hvg2OKKtKcsKQImr
         YRw2OXm0p02zssDwtLDdijxV0iZp5dMbLeKb7rQLHvHzSWiLNbOO5fFh/SQHhBf03zyq
         oAfzG5bvpfPvnuO7XBTCFz401FAwmih3oUjaEyYCxCl9hcD5zJOzhXWrLKN5HfL3rBBI
         N3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DK72RUpIHQodTXdGnn/OPB97k6kSr9X/4FdYqG2aVhc=;
        b=lsiockRo7CiabFEPHR4HfcGzsXQ7BkK+TWQxKpnqkD5HpcHXtCxY95/uzQIHU0OT9i
         M9It+oqaZrQgD1c51Qu0ABHN4alZ+/T92Aq56vE6Fxh3Ubgx3jvMMjTzqFQfik96zkB8
         jh/uX6o9ZrqsBNANW9TZEOTm3kVvY8TUFHLZjkky3O9RjRLZxgUppVT1oAjZFhfNDn0L
         NvVt0B0E7lzrAbvhvob6MbFa+oHHVLv4QkeZ305OvIDlIF6ry/ncEBQpRS9+hq3UWR4n
         CrNaXEoKEG0vvOJO1vUcrKoPTbq/LHmDHE0+RlIxllqEuRYrb9HyZo6lhOg7L4ivAOfc
         pYww==
X-Gm-Message-State: APjAAAWGJbK7U2ZGQ3hTKe+1NKqmrEkItTXrMmtpMAUMCuK+pydKEdOH
        tA3pKblWeZZtligkhblVZKGcwcZw
X-Google-Smtp-Source: APXvYqzPhWN/7Caka3h0b/ID5ELwL7InCQ2lMHXJv9IlALuUbnlry8iRTn3dPOiYwRvdzciMrcTmrg==
X-Received: by 2002:a5e:8a01:: with SMTP id d1mr2442665iok.164.1574807869482;
        Tue, 26 Nov 2019 14:37:49 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s81sm3558898ilc.55.2019.11.26.14.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 14:37:49 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:37:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Message-ID: <5ddda9354c976_9832aef3a62e5b8ab@john-XPS-13-9370.notmuch>
In-Reply-To: <20191126174221.200522-1-sdf@google.com>
References: <20191126174221.200522-1-sdf@google.com>
Subject: RE: [PATCH bpf] bpf: support pre-2.25-binutils objcopy for vmlinux
 BTF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> .BTF section of vmlinux is empty and kernel will prohibit
> BPF loading and return "in-kernel BTF is malformed".
> 
> --dump-section argument to binutils' objcopy was added in version 2.25.
> When using pre-2.25 binutils, BTF generation silently fails. Convert
> to --only-section which is present on pre-2.25 binutils.

hmm I think we should fail hard if a feature explicitly asked for
in the .config is not able to be built due to tooling. Otherwise
users may later try to use a feature that can only be supported by
BTF and that will have to fail at runtime. The runtime failure
seems more likely to surprise users compared to the inconvience
of having a compile time error. I view this similar to how having
old ssl libs fails the build with the various signing options are
set.

Can we print a useful help message instead so users can disable
CONFIG_DEBUG_INFO_BTF or update binutils?

> 
> Documentation/process/changes.rst states that binutils 2.21+
> is supported, not sure those standards apply to BPF subsystem.
> 
> Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  scripts/link-vmlinux.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
