Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA7594FF5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfHSVf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:35:59 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:38512 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbfHSVf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:35:59 -0400
Received: by mail-qk1-f169.google.com with SMTP id u190so2767110qkh.5
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HRf/rgT/WG8UbnB9CjMWjQnc+PtTo38b22VnPUq0Gg8=;
        b=bfNVMyCC+kpeWN4Ybm2ppMO2SSq9dd2BlbnaSbYunSW9kMr7c3/Mn7ghnxAYXX/H9w
         5cnSpgo2YJd/pI0Wqb+d59pIFjFHJRUl59fR5WiO8eqo6wjq4l7mVfR/Dr2gNwO8ZQav
         6L9PLkWJJs05//MgTBjYa8Y+6ITBMMRL+sTah5MhvAS7N1/asb8a+WQaUDzPlrKstd9L
         HipbiFhOGFIavip/WSrlseDc+9rsiX1OLiBr9skoN9ZOkRjlgLZ0hh6eOiGSMaCMBWEN
         gj71PmdpSRKKD4F7Lsrve9PMd/cNE+Dx8in71GFDGAmo0/BO8CpnzHVBUI6xiqFz76Gr
         ej1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HRf/rgT/WG8UbnB9CjMWjQnc+PtTo38b22VnPUq0Gg8=;
        b=dINkQYuG+urCTesPUN2DoKorISpGEjXIIxpOfYTdKCQBVTfGCVjS056M3PkcZtdYd/
         MRmxKw9VK4SmushMML4JmXXphs8OkqEplpkBt3tKDsUDiJyTHuFZ4s7aXzH24xP/QzTd
         TwzRTICMf78YWoxiOS8edmd0dMZhu15NGhMiTmyVC3XjlnGsat8TtKUPBqPpi9OuLqM0
         tgdf0IrskW4MYMVQfTVw4IzN9evMc6zRjbuppVLrTzLWPIaKuefkN+3aJwMif5yngNlY
         ntdFvgnsULo1L3+3FkqBw7/NZKhXQyRjRyE7AWlmi+EavVPBQYNE4QFIkSoONzAHG+lz
         c/2Q==
X-Gm-Message-State: APjAAAVYfexNqQzNyvomxwmM68IWPapCtr5+WtMu/46irdB8MtBambAV
        bdaTLnJ8Dse4SKA0zl2qjWb2lQ==
X-Google-Smtp-Source: APXvYqyP3YqD1FV6I4CPqc2ji59sr1BQNcZd6k5ZgqSkUowaBMDrU4lqioDJjyN9S5NapIiP5Q/Vrg==
X-Received: by 2002:a37:9cc2:: with SMTP id f185mr22980034qke.172.1566250558671;
        Mon, 19 Aug 2019 14:35:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i5sm8912132qti.0.2019.08.19.14.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:35:58 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:35:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, hdanton@sina.com, john.fastabend@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: INFO: task hung in tls_sw_release_resources_tx
Message-ID: <20190819143551.5b8935f5@cakuba.netronome.com>
In-Reply-To: <20190819141255.010a323a@cakuba.netronome.com>
References: <000000000000523ea3059025b11d@google.com>
        <000000000000e75f1805902bb919@google.com>
        <20190816190234.2aaab5b6@cakuba.netronome.com>
        <20190817054743.GE8209@sol.localdomain>
        <20190819141255.010a323a@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 14:12:55 -0700, Jakub Kicinski wrote:
> Looks like the dup didn't tickle syzbot the right way. Let me retry
> sending this directly to the original report.

Oh, no, my bad, there was just a third bug of the same nature.
tls_sw_release_resources_tx got renamed at some point, hence 
the duplicate report.
