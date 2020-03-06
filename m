Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0492117C1F9
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCFPjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:39:06 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:33209 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgCFPjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:39:06 -0500
Received: by mail-pg1-f173.google.com with SMTP id m5so1258843pgg.0;
        Fri, 06 Mar 2020 07:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=s9BouoWrv85i1Z+k9ck/8nMkcn5seIvz/uJLFlUOq14=;
        b=qAOXle/3VqVVFQ+RMj22i5BdFRMvgGhK4r25dNXVHSmWuCg8+QsWLOB8w20BB+mjGK
         mdiVXs2RH1Y8rvdK04JBcMjfi4QxRB3qidrlkuvKQV5UO3L9O6zjsxy3b1wXq82ZMNVD
         F073UUcXf86BsrdduYbMZY90CTyqzdOAIO6LcFNhI+A2hJMfto+AKlED2ji9G32YhouR
         BF1MKhsPrFtUwZsqjv+ubAUPKa+rCmsqwgKtl/l65oHyeUC2TiJ4gmisMbtby/9IemY5
         3YskNHjM1l8MZvSrScVAa8+XZ0VC7j1vHQMTwgv2l1wi8Vjh3njcZW+gqJfUmY6DeZOA
         YhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=s9BouoWrv85i1Z+k9ck/8nMkcn5seIvz/uJLFlUOq14=;
        b=mSeF/ODpSG0dd0zUzqEsCZr+tR5pPrsn2AN4PBaxVcKf1VAOEuRXqWs+YHwAmSf7hg
         5p8cbQOxskKV5Ed12obNpig8N1r9+48cj4CtTzYdRtTtMa9L2vV+MkW9tVcmIMxOf0Cq
         APr+/2HtmsSP1uwDAk1YDMhHRYClykc66/OgtdZQLcuwF2NK3y+jsi7CBmoNDnH20n+Q
         ryBHrWSTX82Hh2ElfSkIKL8Mvdaw/NsluEoNqoJL6RlPPksK4r/ju6s24snYncV/cCcx
         wom/WdjYsKFtLwTfDkHlGVHrkErLWia4jaQNjuUUuZ0QIqHlz5Z/1EyBdukVLkf20CH2
         XbhA==
X-Gm-Message-State: ANhLgQ1KdmcGzGtgl0XypVMCictcMatXbjWX2lFK9D/ouRYl7GpWBCzg
        r8g1+gCZct5AFGLaRwZ3AL8=
X-Google-Smtp-Source: ADFU+vts5rXDh8xSLUCqx2lq62PN5SnUMcIArJFJAh9hAHF58VqRlLMWbiTWMjHGnzUe1csTmHupFA==
X-Received: by 2002:a63:f757:: with SMTP id f23mr3874563pgk.223.1583509145043;
        Fri, 06 Mar 2020 07:39:05 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k5sm9692031pju.29.2020.03.06.07.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:39:04 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:38:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e626e8f5fd69_17502acca07205b46e@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-11-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-11-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 10/12] selftests: bpf: add tests for UDP
 sockets in sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Expand the TCP sockmap test suite to also check UDP sockets.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 157 ++++++++++++++----
>  1 file changed, 127 insertions(+), 30 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
