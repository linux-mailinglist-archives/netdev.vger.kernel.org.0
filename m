Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9B314BD9C
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 17:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgA1QX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 11:23:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44657 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725974AbgA1QX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 11:23:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580228607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8NnfslLDT/k2MBtTi8gVAUbBn9vcdCPU49nuvUQAco=;
        b=KwfKIPwpbfcfOpJJB4FD8LrTjcNRpZB2g3uHqnuHqavdGlGtyfa5mCMqUGrYcxfQtDfeL6
        BtAGajq1IgD9LAO7b2tQGhWi0YiIjJcgJa/gqW6G6PJgSjBd7l7EAMbKwN1iB0nBPREbB5
        UzGSVJC8xpxy12DWyJswSPJWYpeu3nE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-BJMHNNX5MMmfVFRdbA7Qzg-1; Tue, 28 Jan 2020 11:23:25 -0500
X-MC-Unique: BJMHNNX5MMmfVFRdbA7Qzg-1
Received: by mail-ed1-f69.google.com with SMTP id f25so5571264eds.22
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 08:23:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8NnfslLDT/k2MBtTi8gVAUbBn9vcdCPU49nuvUQAco=;
        b=CWz4jrqSJ5St4nyCG5WH7y4nc6oYdKNvhHsLkwHgMCmXjJzYushbMHT0CbUzy/8Px0
         tIeuEJVPWrEsmQTxa03HgrqaCl/bFu/s3NeJE+m916qx2q07XSrJJouwFBYGgl/JnxJM
         hcjgKbG1jDNlb+jrbsUvvvHKzMRCNgrdtLY+3E3ziLCnNE0ClsPYvLvNTDAgd2nI6H0e
         i4U2zN5D3mAHEoiSPptMMEpSWrm7HY4tAtsh/2MEnLsUdv1VcyAoi8ekekMZ376tucBW
         SjpOoA6lnuhxwpB1ivH07zDpysnZukrcfJO2LyY05uO/oAlyM8ISoJ2tHM3KTOjLye02
         86xw==
X-Gm-Message-State: APjAAAX/R6KJ8aWj8QJ1nqW8Aky1ns1Gs5MtSomGCSlTpUttyYgpcZTH
        hL4MpnXThgskTCF8seVFgFYLd/uLUctPiwag6ULriNsb3uxM8HPY1LvHhvqV2K742cPmwj1mKbW
        L2watLyXwcYF9QyhnVnx1SGqvpYLrnO3p
X-Received: by 2002:a17:906:c791:: with SMTP id cw17mr3659117ejb.69.1580228603784;
        Tue, 28 Jan 2020 08:23:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEi2H/jvH2nU/oJzebRmoduq0tqXhbk2krfS+sflXuCRWvm6+W2NJqW1zB7XpfCFz6LwQKje6Rs5QIQ8SKHNo=
X-Received: by 2002:a17:906:c791:: with SMTP id cw17mr3659099ejb.69.1580228603515;
 Tue, 28 Jan 2020 08:23:23 -0800 (PST)
MIME-Version: 1.0
References: <20200121170945.41e58f32@carbon> <20200122104205.GA569175@apalos.home>
 <20200122130932.0209cb27@carbon>
In-Reply-To: <20200122130932.0209cb27@carbon>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 28 Jan 2020 17:22:47 +0100
Message-ID: <CAGnkfhy4O+VO9u+pGE83qmtce8+OR4Q2s1e9Wdupr-Bo5FU1fg@mail.gmail.com>
Subject: Re: Created benchmarks modules for page_pool
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 1:09 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
> On Wed, 22 Jan 2020 12:42:05 +0200
> > Interesting, i'll try having a look at the code and maybe run then on
> > my armv8 board.
>
> That will be great, but we/you have to fixup the Intel specific ASM
> instructions in time_bench.c (which we already discussed on IRC).
>

What does it need to work on arm64? Replace RDPMC with something generic?


--
Matteo Croce
per aspera ad upstream

