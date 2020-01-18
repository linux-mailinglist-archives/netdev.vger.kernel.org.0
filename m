Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7513F1415D7
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 05:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgAREpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 23:45:52 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:36822 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgAREpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 23:45:52 -0500
Received: by mail-io1-f45.google.com with SMTP id d15so28316651iog.3;
        Fri, 17 Jan 2020 20:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qhDebGkBzEzfgwo4AOFywLggeVUm1FKDg/bcQQUsutU=;
        b=ArR7l/gZ2KZ8wXOyMEBfBz78KodvnPMnAusaq/jdKdaX3a6tdXfU5fnqHoMrtMn5lL
         1NjDVqg9Tat51Nm8Aqcik3z2sSAE2sBM6uARRdsaPOcn0VkfsZ6sI8bAxSv96VHbUjMU
         juXcd0UmuJgq3PGFWU1B8l7STXF6tOs6tdB1BBoERVevzvqxJcyLtARX+IwqqkWvJwKg
         swLI2OR1e1zKDkDSSmZ/zcJjGf4rBaVyxmTCyPTbsligYR67hytYjG1pcNkG2fnl1jtn
         ssCd8J3qbGS3Y2KGMRDXDJgeMDvlPgYAb6iLXp5rU8jN1B6Jz0lnNGM5Io44z8K+t3oR
         YLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qhDebGkBzEzfgwo4AOFywLggeVUm1FKDg/bcQQUsutU=;
        b=V1uVWeVFKhVngYQkdKctd7dHk79a7GxV6dYsG4Z6bH7H5KGXy6FKmEut5/y+JU0Rqk
         MQtYg3eLjjfOAokn9tYHHjvdurtupDtcGUPMNR1ql1iCi3BsHoKXPWVLZCGMtumLabo7
         +hV9Kz5y6MLyMWejSkenxa7k8jlN74ZlqhlVKgaI/sMcFnhG6rF23W2OH215GgWne2fo
         nEfO22Gz9HQDjyg0CUC/wB/+JiqTrClNE2apWMOWEnybZFEB4aRJN0eM9saRcEEg4Pi6
         0jNCyXVeICRTh+6XjkzBJ6kZbEfQezF4N4/+GZI6AA2B2NEaFB4oQvTqBhOtm1qaIhP1
         TS0g==
X-Gm-Message-State: APjAAAUvxxWnO8+ERC2JkSPaDj8llfffjAIyIZea2yk77Ms2o0I9muuW
        1y2XE/L1REOlIOIxelLFN4g=
X-Google-Smtp-Source: APXvYqx8Tpl/QxQb2AGlYyTD4UaFh50fqzgD1MccJ1IEs+y6U2BK+slEjypSi0C/zxBNKbvDzSW2+g==
X-Received: by 2002:a5d:8782:: with SMTP id f2mr32942104ion.53.1579322751689;
        Fri, 17 Jan 2020 20:45:51 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t16sm8492361ilh.75.2020.01.17.20.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 20:45:51 -0800 (PST)
Date:   Fri, 17 Jan 2020 20:45:42 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Message-ID: <5e228d76ec631_4cb22afa407465c025@john-XPS-13-9370.notmuch>
In-Reply-To: <20200118010546.74279-1-sdf@google.com>
References: <20200118010546.74279-1-sdf@google.com>
Subject: RE: [PATCH bpf-next] selftests/bpf: don't check for btf fd in
 test_btf
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> After commit 0d13bfce023a ("libbpf: Don't require root for
> bpf_object__open()") we no longer load BTF during bpf_object__open(),
> so let's remove the expectation from test_btf that the fd is not -1.
> The test currently fails.
> 
> Before:
> BTF libbpf test[1] (test_btf_haskv.o): do_test_file:4152:FAIL bpf_object__btf_fd: -1
> BTF libbpf test[2] (test_btf_newkv.o): do_test_file:4152:FAIL bpf_object__btf_fd: -1
> BTF libbpf test[3] (test_btf_nokv.o): do_test_file:4152:FAIL bpf_object__btf_fd: -1
> 
> After:
> BTF libbpf test[1] (test_btf_haskv.o): OK
> BTF libbpf test[2] (test_btf_newkv.o): OK
> BTF libbpf test[3] (test_btf_nokv.o): OK
> 
> Fixes: 0d13bfce023a ("libbpf: Don't require root forbpf_object__open()")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
