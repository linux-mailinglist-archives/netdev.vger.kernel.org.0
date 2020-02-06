Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CDB154B8E
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBFTDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:03:21 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53864 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgBFTDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:03:21 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so373695pjc.3;
        Thu, 06 Feb 2020 11:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=m0YE9ta+l3R6mLiNSqlhrDUfKEKdzXDv7P6vhO+CCh0=;
        b=pjt1nH/pOx7Ou/Fj8McFD6t6uk2qYxH8sfd30ZdyO0KnqnIT+N6OQvNue0+hEjgmWo
         NwrSi70NO6rKCuXkaWSLxTh+snJwJjs5hvY/iI+CSOsJnhUJlB+T0x04IJnXw9A/95ek
         anQfMuL1OiqNMlz1+hXctNYUqz/gR/iG7013NXx2ZXjd87UPS00S6r3VP2F9O1jSZci0
         4SiG/HKiFZaND/XqPTyCRPM5DuqdwbTPFyo990sFcXRYmLY2YmT9sG1yaM+4qarL8a4t
         1G5LC5LEXyC5VmchDs2oSpaAA8YFb58nf1cm22AstpJjtVE3x9S4Lomp78fShMR+KS4a
         5q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=m0YE9ta+l3R6mLiNSqlhrDUfKEKdzXDv7P6vhO+CCh0=;
        b=Hh2WZEt40nIFiK8rO619VgSkXgNqCvKTMS90g/yNLEOrKto7tlXKJXg4M7DWjyB8NY
         nRwpZPnmKQRJXs0rb51Zg3B0WnYCcRQdWSTeWGbiSAMnch4RcYMV7w3E432qxtN0ySH/
         3j70Z2DoXl43ZZbMe5cBGg1AgBKFOdKns6mQfAE2Z3BNbK5K3W3p2DbEIwNEatZSGqDO
         n+NlLQOWQx52s/6DTNx3F3txl28N1ps4SHd6HLnN2HqJBsEbrHUYROAm20LYjYBHVK/k
         hk6nciS93iS5zTMhWZPXffAS1BXoP1WAF1SVxhTB48q4pMAB0F7PvWSC3m2NNenay5yD
         guAQ==
X-Gm-Message-State: APjAAAVyTl6Cz3XfvjBhTqB3CvtfCuGtNN/owLKtCUn4z1xM8WMF9ok+
        vbuhmJM4isDkgovf79ZAHP0=
X-Google-Smtp-Source: APXvYqzY1rzRDIRkJo87+klWiI2eucxbBaLu8D4ufZqeaLREBFOEhIojn6FADhymp2HgRZeQHCqu4Q==
X-Received: by 2002:a17:902:b690:: with SMTP id c16mr5496388pls.320.1581015800708;
        Thu, 06 Feb 2020 11:03:20 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y10sm144877pfq.110.2020.02.06.11.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:03:20 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:03:13 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e3c62f129cd3_22ad2af2cbd0a5b45@john-XPS-13-9370.notmuch>
In-Reply-To: <20200206111652.694507-4-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <20200206111652.694507-4-jakub@cloudflare.com>
Subject: RE: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with
 a socket in it
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
> down") introduced sleeping issues inside RCU critical sections and while
> holding a spinlock on sockmap/sockhash tear-down. There has to be at least
> one socket in the map for the problem to surface.
> 
> This adds a test that triggers the warnings for broken locking rules. Not a
> fix per se, but rather tooling to verify the accompanying fixes. Run on a
> VM with 1 vCPU to reproduce the warnings.
> 
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_basic.c  | 74 +++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> new file mode 100644
> index 000000000000..07f5b462c2ef
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c

Yes! This helps a lot now we will get some coverege on these cases.

Acked-by: John Fastabend <john.fastabend@gmail.com>
