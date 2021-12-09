Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9331F46F3EE
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhLITbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhLITbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:31:21 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30880C061746;
        Thu,  9 Dec 2021 11:27:48 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id s11so6372297ilv.3;
        Thu, 09 Dec 2021 11:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4hOHHwkqjJk4kcKlfoyCtHmx/km4QUengLsB3lOjqo0=;
        b=Fek2BxxgUGj5ymX9KOKSMoSMpsCzXrvQDJpIPcPf7d5shUBNJwOZCRZPDHyNTryiZR
         5EIldcRn9YP1N2wlkQVUFLpEudMEsmOs23y5kwtj/Jr2g5uRrDfj64kg7CmFItRdLUta
         mO0YXqOhvi6SbfyxzSTdgLMOTHmRXtITLgPLGSySqwFWJzXGgobwxkL3HjjH1YC6sl7L
         i7eUFedZM0MS9I+9R+X10/gHgzyIjjsu95+2ipul+mYvEiE0/yA/aHi0Jasqc/zhfOSM
         jypUgU7RJ2pMvAfsOQJf/8VVABNZ3Ixx5maH3ANzFpacLSXTz4rlAHZMJW9OFkuvJQ6L
         iodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4hOHHwkqjJk4kcKlfoyCtHmx/km4QUengLsB3lOjqo0=;
        b=VTa3JgX6ZDmZX1NXS24TyF4jjvxQIAwVxvoFsiZkfuGDpqKRrjwuSrkmC0WnoXGD1h
         C9IKqs645E9BX3DqtRZF3bNlThAb3r3/Yf7MFj40M9ckORuvf4FkeOl0CclA4C5RTqKZ
         3et8+BaE/20CXxqBUsduvG30/m80JCAXRbYuIJ/FMIOJCy1gVuWvZ5weZkzDjC5axRVI
         17NBiZC9P3p1/J9q86D7IWuJAEEKSDdDm5Aj8Ljjlv32U5yqRMS0eeKHWKVSMwbcCgOd
         desX2ZFjqSHTplal2ePGeiyj5PXGD3N972R0kEuZhNxFC7me1ksIkLmMbYJQ+anu3sj+
         xDRw==
X-Gm-Message-State: AOAM530CioJVPJASGdS5SX09ffRD5wOVia9MbNeTmVQ5iLbGfqJa3seu
        UfM02rt4sjrie3c2ufIOad8IVZl14ZHsvg==
X-Google-Smtp-Source: ABdhPJyrNKulUyvdZZoKHXSYr3JUSRtRY7yCc+DHlDtN4sZgnBcdJnGnyDC286cU3FcjvQVIqCIGqg==
X-Received: by 2002:a05:6e02:168f:: with SMTP id f15mr16215420ila.207.1639078067662;
        Thu, 09 Dec 2021 11:27:47 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id a7sm301426ioo.5.2021.12.09.11.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 11:27:47 -0800 (PST)
Date:   Thu, 09 Dec 2021 11:27:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tony Lu <tonylu@linux.alibaba.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <61b258ad273a9_6bfb2084d@john.notmuch>
In-Reply-To: <20211209090250.73927-1-tonylu@linux.alibaba.com>
References: <20211209090250.73927-1-tonylu@linux.alibaba.com>
Subject: RE: [PATCH bpf-next 0/2] Introduce TCP_ULP option for
 bpf_{set,get}sockopt
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Lu wrote:
> This patch set introduces a new option TCP_ULP for bpf_{set,get}sockopt
> helper. The bpf prog can set and get TCP_ULP sock option on demand.
> 
> With this, the bpf prog can set TCP_ULP based on strategies when socket
> create or other's socket hook point. For example, the bpf prog can
> control which socket should use tls or smc (WIP) ULP modules without
> modifying the applications.
> 
> Patch 1 replaces if statement with switch to make it easy to extend.
> 
> Patch 2 introduces TCP_ULP sock option.

Can you be a bit more specific on what ULP you are going to load on
demand here and how that would work? For TLS I can't see how this will
work, please elaborate. Because the user space side (e.g. openssl) behaves
differently if running in kTLS vs uTLS modes I don't think you can
from kernel side just flip it on? I'm a bit intrigued though on what
might happen if we do did do this on an active socket, but seems it
wouldn't be normal TLS with handshake and keys at that point? I'm
not sure we need to block it from happening, but struggling to see
how its useful at the moment.

The smc case looks promising, but for that we need to get the order
correct and merge smc first and then this series.

Also this will need a selftests.

Thanks,
John
