Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF084A4ACD
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242966AbiAaPmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:42:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236278AbiAaPmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643643719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=1C6Hmt87vWzjWxqoVkiCorkigZnguA91Obr4BW1inuA=;
        b=X0wfa4AuzBgmR42f4VShBu9NpfQ8BjNL+E6Tu8yWcHMvknRm71fbXGjBkOeVawfDQ7tgPz
        rNDVJGL0FWymYqCgmUt1LfV24LQVCWQNd4lm/q5ryybuxCP/QnPFqRkaMfl4saXoJnKLYx
        JnI0rM4L0N1YFnK2x2qEfiOC+Eb1qdY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-YHu6A2rtNUmqJ55ylLmoyg-1; Mon, 31 Jan 2022 10:41:58 -0500
X-MC-Unique: YHu6A2rtNUmqJ55ylLmoyg-1
Received: by mail-wr1-f70.google.com with SMTP id k12-20020adfe3cc000000b001d6806dfde1so4954104wrm.16
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:41:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1C6Hmt87vWzjWxqoVkiCorkigZnguA91Obr4BW1inuA=;
        b=lL2ypC6GjhdXaE8PYC6AUcCYuUi6XRkUMXXXevQMj1KvwfuJU/34YnHBGL9OB/3ikW
         TwNYxyoydvIYlIFMcUwp9KRfJOtrM1E83L2w8zzigSNjzJMubGUBsXTNK4EZpCEa8FY4
         yJeME7ZYvpnFb/0VCfqFfVjrst4MzX5Ql0ZsQN/H1NPvHAXBoVh2pPKUyGzbKrBCOs28
         k+mFiY284kcUXiaHMUx7lmpmbUKC24IdmOz+B+n99MjbyCH9zWYk/ZFT5Q24Dq1tlsO1
         pyFVe8kPYk15ImK4sMdJ7YyHqDijc2931RTkHETSZhEei6w26cTnZT9ZReTsAI/wd+o9
         TkCg==
X-Gm-Message-State: AOAM531Grx4pDP1M/Df34xf4DpObD40YtylfkJqp02jc9rpU7jiGjoDE
        c1OQ37bfu+jPYrqoznyf7LfIXYbvtB8EU7PL2GMJfvRVx8hlOn0f+fG7Sh6ZQV8z0Uwmy+rym5x
        PdpdtO96kun0ghJo+
X-Received: by 2002:a5d:67cf:: with SMTP id n15mr7577959wrw.673.1643643717425;
        Mon, 31 Jan 2022 07:41:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy22KrqgW3Xz3v8qnHlD9gcRIZxiGHVoXvKPYyNXVgwkhNMPpOBlchmZYI+ec9lVTV5v52bqA==
X-Received: by 2002:a5d:67cf:: with SMTP id n15mr7577948wrw.673.1643643717269;
        Mon, 31 Jan 2022 07:41:57 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id i6sm9239390wma.22.2022.01.31.07.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:41:56 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:41:54 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 0/4] selftests: fib rule: Small internal and test
 output improvments
Message-ID: <cover.1643643083.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first half of these patch set improves the code logic and has no
user visible effect. The second half improves the script output, to
make it clearer and nicer to read.

Guillaume Nault (4):
  selftests: fib rule: Make 'getmatch' and 'match' local variables
  selftests: fib rule: Drop erroneous TABLE variable
  selftests: fib rule: Log test description
  selftests: fib rule: Don't echo modified sysctls

 tools/testing/selftests/net/fib_rule_tests.sh | 26 ++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

-- 
2.21.3

