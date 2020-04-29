Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E4D1BE744
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgD2TXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2TXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:23:48 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9E2C03C1AE;
        Wed, 29 Apr 2020 12:23:48 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id w4so3511794ioc.6;
        Wed, 29 Apr 2020 12:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EyvlRZmYRqgOVKkGlRAQL5B5ntHKxv5MkfrBLYoa3CQ=;
        b=UdW6B2hyAbti7P4F+W+xDgEVNmyWG6XqyIspcho4ZAVAOqFcE9RsDWDJYq4qCADP3C
         wUcDHz3TLnPowsgzFN+plb1P6TzHBK8ZM1vbOUyxjOZcUZTvxCR0IxqqoqpHqxXIdmZv
         DNcSnfdwTaHdyb8vNEPgGb53AFLYh6NT996VAkKzMSGTQQkJp8hB5BYR56qlwICpKX6e
         2HKnMWqwLtONrd+c+gPCbs8GXksRfaTxL7HA3m2kYwqKuzyIwcHbSOqqEGaL5qZ6NHHf
         UTPvukHNoTpj44udUkWFxjpIP+g1g7UukFjYPLprJK/81v6I/4qxgfLJU2rxda9Fmg9W
         lSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EyvlRZmYRqgOVKkGlRAQL5B5ntHKxv5MkfrBLYoa3CQ=;
        b=TNWNa6LzK7i8xLCZjkGfFtjmhGPze531LnEmj0m+XuQFxSiwpQMuznT02O0nM5OnCN
         8SKaRyA+BDWo9NDC56dExqsxwWZlitddaHGc183bDCiH8Ox78Gxx1ISpZfa42qJpc4ra
         mUIudTap5EPhXsc6QYl8wMbnjS7RO/Djn7pZL5dNwyDj0bLp2bKwQVyjrKRi/IBWX+9n
         TEUvPQ+ugrW4+qpKzn+eBIghLpjzVhw/R4ZUWB6ManiJS9CiaN4008xokgoLR18dX36V
         K5JOtZnrXhMtzBSkMXmi+XnZHoc/Dvzwm/KzBZekBR3gYrFsrILszc7XSPfsIDo5I064
         3d1g==
X-Gm-Message-State: AGi0PubvH3rIqfqXKtTB+ga1HklI6pTmpF7eurGbdcyiQ5A1H8EFgunC
        S7AfZHfLxXocpEm3b6ct7Ts=
X-Google-Smtp-Source: APiQypKDIH0fqyb+ONNt08dzrXFTAq0QeCCv/TXC+cnpC7OJjZa4OLZjSyVLYYvXoKAkl+YVJuftog==
X-Received: by 2002:a5d:8889:: with SMTP id d9mr32563820ioo.50.1588188227941;
        Wed, 29 Apr 2020 12:23:47 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i13sm1345927ilq.35.2020.04.29.12.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 12:23:47 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:23:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5ea9d43aa9298_220d2ac81567a5b8fa@john-XPS-13-9370.notmuch>
In-Reply-To: <20200429181154.479310-3-jakub@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
 <20200429181154.479310-3-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 2/3] selftests/bpf: Test that lookup on
 SOCKMAP/SOCKHASH is allowed
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Now that bpf_map_lookup_elem() is white-listed for SOCKMAP/SOCKHASH,
> replace the tests which check that verifier prevents lookup on these map
> types with ones that ensure that lookup operation is permitted, but only
> with a release of acquired socket reference.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

For completeness would be nice to add a test passing this into
sk_select_reuseport to cover that case as well. Could come as
a follow up patch imo.

Acked-by: John Fastabend <john.fastabend@gmail.com>
