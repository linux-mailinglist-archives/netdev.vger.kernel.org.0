Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B302293AE
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgGVIhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:37:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57474 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgGVIhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:37:18 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jyAFX-0005xE-SG
        for netdev@vger.kernel.org; Wed, 22 Jul 2020 08:37:16 +0000
Received: by mail-ua1-f72.google.com with SMTP id n4so345947uaq.17
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:37:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+bYSyuCUZFAkGtII1RmdIT7fMN+AO1fhPK7l1587qY=;
        b=dqjni4kPnyf/WOHH93YEj/XvAIq5+8WbzjOFhXganQc/esw+oF9ayy29ucrCRzIwel
         4N2CZSMMQEJ2zFQE6KanZvQbqv5jGg8Dm3Tehg2kv1pnf9soiCqSnkcLSIbB9wgYQABz
         80vbXPh/n5cmLGg5APXUHsWri2fqMNtIs9SYLdA1uytGKTAuD9cW1+tFuVWNxGS2wLXT
         biD5HW2R1gF3eMNygzRjrnGEPut50dXar5S3PbBlOFh87RlTQhClc+fzeXdwZKqc9tGP
         MEBHJUOvGu0TPo4oi/Z5vEb6D4Eo5f2oKwEOxpGikFP9EEJH1Xfj90tT8f+hWdLjxFpD
         ZDgQ==
X-Gm-Message-State: AOAM530EksOgSVzvsuth0TjdK9sqrbib4CvFboOPw+LEIo2D5LOlWCrr
        QYFRZRQChzgK8n46rhK7tA+a7i/aHNuNo0JI6zChWYJPDeFLbQv4lgyXLUjdCNCFUwSvVZl73WI
        8sIumTL2z3HqcqWyCjTZI/KHiaRvViLyKij5Ar0YJcvh3pPbY1w==
X-Received: by 2002:a67:1105:: with SMTP id 5mr24340546vsr.174.1595407034591;
        Wed, 22 Jul 2020 01:37:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHhx8M1zvoxC/SgvLXUeJNSlv9KoZs9SK1CB828zfYcRVOHt6JU+7hR5X5KsNVtgCDY7YsQoWp9nuI8gUSZfk=
X-Received: by 2002:a67:1105:: with SMTP id 5mr24340530vsr.174.1595407034362;
 Wed, 22 Jul 2020 01:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
 <20200721161710.80797-1-paolo.pisati@canonical.com> <CA+FuTSe1-ZEC5xEXXbT=cbN6eAK1NXXKJ3f2Gz_v3gQyh2SkjA@mail.gmail.com>
In-Reply-To: <CA+FuTSe1-ZEC5xEXXbT=cbN6eAK1NXXKJ3f2Gz_v3gQyh2SkjA@mail.gmail.com>
From:   Paolo Pisati <paolo.pisati@canonical.com>
Date:   Wed, 22 Jul 2020 10:37:03 +0200
Message-ID: <CAMsH0TTQnPGrXci3WvjM+8sdJdxOjR9MnwFvv4DS6=crMCAt4A@mail.gmail.com>
Subject: Re: [PATCH v2] selftest: txtimestamp: fix net ns entry logic
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 6:26 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Fixes: cda261f421ba ("selftests: add txtimestamp kselftest")
>
> Acked-by: Willem de Bruijn <willemb@google.com>

Besides, is it just me or this test fails frequently? I've been
running it on 5.4.x, 5.7.x and 5.8-rcX and it often fails:

...
    USR: 1595405084 s 947366 us (seq=0, len=0)
    SND: 1595405084 s 948686 us (seq=9, len=10)  (USR +1319 us)
ERROR: 6542 us expected between 6000 and 6500
    ACK: 1595405084 s 953908 us (seq=9, len=10)  (USR +6541 us)
    USR: 1595405084 s 997979 us (seq=0, len=0)
    SND: 1595405084 s 999101 us (seq=19, len=10)  (USR +1121 us)
    ACK: 1595405085 s 4438 us (seq=19, len=10)  (USR +6458 us)
    USR: 1595405085 s 49317 us (seq=0, len=0)
    SND: 1595405085 s 50680 us (seq=29, len=10)  (USR +1363 us)
ERROR: 6661 us expected between 6000 and 6500
    ACK: 1595405085 s 55978 us (seq=29, len=10)  (USR +6661 us)
    USR: 1595405085 s 101049 us (seq=0, len=0)
    SND: 1595405085 s 102342 us (seq=39, len=10)  (USR +1293 us)
ERROR: 6578 us expected between 6000 and 6500
    ACK: 1595405085 s 107627 us (seq=39, len=10)  (USR +6577 us)
    USR-SND: count=4, avg=1274 us, min=1121 us, max=1363 us
    USR-ACK: count=4, avg=6559 us, min=6458 us, max=6661 us


In particular, "run_test_v4v6 ${args}       # tcp" is the most
susceptible to failures (though i've seen the udp variant fail too).
-- 
bye,
p.
