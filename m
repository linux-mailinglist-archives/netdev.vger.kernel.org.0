Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83045B06A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbhKWXsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhKWXsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 18:48:54 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B444EC061574;
        Tue, 23 Nov 2021 15:45:45 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id j17so944473qtx.2;
        Tue, 23 Nov 2021 15:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aSwWHHk6hLb9/N5LwVurTbg0m12fvHHJ19aB7t+3LRk=;
        b=TFCmX2UIynzL35f+i4CgrO744Vl4Yk50o/DuEAh7dXDWnNyNP6l0lFVR6JZBOJ8HJY
         FJRgKFO1vAdJctHLwcMVVAgsiJPzVX0mAdRMGYqHVM0elPuUMeBrqlojYBLSUW/m0Gd4
         bwGb+4zlkJdjsRcR/YaDugRhK1AppA77qLmxnJdzat7Qk0F5Z8gp6e1Xfi0po7d8zxzu
         7dRn9zXv7buGzNm0EgFAwq+9OcKLwkSX7VhB6vS3IlNW7DlmGa+ijNDDkzvGr1EOxUx4
         CYEHumjioa5y5uJoKMkwqRB2J0/PmVYe0C/2GzQ6Wtdqj6PMfm67R4NeKQ5C3Xz6xpFn
         tUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aSwWHHk6hLb9/N5LwVurTbg0m12fvHHJ19aB7t+3LRk=;
        b=K/KIbDRLyusfVm1/TMsqzpBkqq79AXTyMa9lucN2Fybq121lr5Frvs6cjVKV4TJSsA
         SVlxDtI9JLl5/QAuNgGcZaAkifOC94tva32vAhYfZ7jR27RFm5NGhxUOhxW5e8ew4k85
         pVP3E+HQmvWlpLP/JhdJsDDSnm7MZ7Snf+yeCWNE3EJJxDm23v2ZkcaupjyYXaCh54rN
         TiCRAAKjt5nWAXNCJlfLxMjFeUZZ9NfgsPcW7vit6yCLOPbe6Sas305oisCg2zln8I+u
         ZTu3RbQ3ynO0wqLp/oGKM3HkuFI/PoGcVeUM9/vcS2KkJk4rUeoctZ2z5//tsKQpHH4r
         QTBg==
X-Gm-Message-State: AOAM531NfOxrrSNCWfjxkOArLArpyZUKs6hnQmvYyt5jIuoz9ehES3He
        NfzMhZyAndBEtLl0YWKN92A=
X-Google-Smtp-Source: ABdhPJzAVlDI0kRuMk+kMS3N70UqoXOL98FwsKJLEU9O09bi9pGfR1J2fJ+RENcFe8nqcyDHF5QpPA==
X-Received: by 2002:ac8:5ac5:: with SMTP id d5mr1651131qtd.153.1637711144846;
        Tue, 23 Nov 2021 15:45:44 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:ed62:84b1:6aa6:3403])
        by smtp.gmail.com with ESMTPSA id e20sm7057259qty.14.2021.11.23.15.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 15:45:44 -0800 (PST)
Date:   Tue, 23 Nov 2021 15:45:43 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel@axis.com,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] af_unix: fix regression in read after shutdown
Message-ID: <YZ19J+jZrOXxR1oR@unknown>
References: <20211119120521.18813-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119120521.18813-1-vincent.whitchurch@axis.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 01:05:21PM +0100, Vincent Whitchurch wrote:
> On kernels before v5.15, calling read() on a unix socket after
> shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
> previously written or EOF.  But now, while read() after
> shutdown(SHUT_RD) still behaves the same way, read() after
> shutdown(SHUT_RDWR) always fails with -EINVAL.

Maybe just lift the socket tate check in unix_stream_read_generic()?

> 
> This behaviour change was apparently inadvertently introduced as part of
> a bug fix for a different regression caused by the commit adding sockmap
> support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
> unix_stream_proto for sockmap").  Those commits, for unclear reasons,
> started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),

Not sure why it is unclear here, for an connection oriented socket, it
can be closed for just one direction, in this case we want to prevent it
from being redirected in sockmap, hence the point of the commits.

> while this state change had previously only been done in
> unix_release_sock().
> 
> Restore the original behaviour.  The sockmap tests in
> tests/selftests/bpf continue to pass after this patch.

Isn't this because we don't have shutdown() in sockmap tests?

Thanks.
