Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BEE17C20E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCFPoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:44:19 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42147 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFPoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:44:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id h8so1244348pgs.9;
        Fri, 06 Mar 2020 07:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GtC9IEB6Uytb3vSQk6jEoUpN+KV/FafY+w8suLJILpk=;
        b=L4uJh5Wb8MP4t/bAj9XTu2OBHXt3YlYXexST74Y1B+TIaA4EWDUU62PQTTVzdMwRtD
         gEdKEQfwjk3XN1Vja54+mgMVBgaBlo36koMAf2uZQtyBeiCnVT9fSqh5vVnOuU2GZrXE
         tCRN1QomEDj3Uds2Mux+iuc6j0/hEBC7RM1I5imsBujG7LcE3vfPVqW4WbUJwgpK7I5e
         ElqvCld9JKZfHUN/fYonvG0ANywfy9OzI0kAreSgcZPYUFdLoRahVxL2KWTQX6vNFr0L
         YLJ7JDQoP7TB6uwUmw++xQKIo5tfnHjMpJ9DXywHbUk+VpUpI+iiuc8mT5kEiG8rSZ6T
         kK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GtC9IEB6Uytb3vSQk6jEoUpN+KV/FafY+w8suLJILpk=;
        b=DEz+EVXJts+OJSVTCF9YWN2vWwdTS438w8AVV9R5xWD5Y5Sgh1/dXTe8yqKwbppIK3
         KWTmn9tYoh2MzO+cyGN41mFDyNtRT+hFuEHoimvBPPy4GCpuSc56H5DcfS4GPli66VnU
         BVb7wE4CWL1wb+n4jEAafQfkc6a2dV/k4qfWpQSIBVOcKv2hDXMK1MV0D1HlMgw+EiW5
         u8fq58RNM1XXTUOvYf9dsB73vNp+48jo4zHKASP/ux1WjnV/1Yhg8p+G0sGYaZ4N8i8F
         6dGnFhw4smwtbpURu6b98DzQERcE9Gxuz46cCWyY9CDdZAHCsSTauhReaco6rJTge52o
         Eesw==
X-Gm-Message-State: ANhLgQ0Nz6QOi/a3GO1BHEfj1lJVMwWMGM/Fd0kruhDd6XXgxHjoSyn3
        w0cfN5cluZymow9ZcCrEK2E=
X-Google-Smtp-Source: ADFU+vutdtX9QtAAGDh++ZIUrWRjm3jtgDDPIkmFcQOICy9S6ArXrQvpiKGBWcnFaFYM7ipR3BFKDQ==
X-Received: by 2002:a63:b04f:: with SMTP id z15mr3841664pgo.58.1583509458041;
        Fri, 06 Mar 2020 07:44:18 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z6sm11697764pfq.39.2020.03.06.07.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:44:17 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:44:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e626fcb1e39e_17502acca07205b4c7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-8-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-8-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 07/12] bpf: add sockmap hooks for UDP sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Add basic psock hooks for UDP sockets. This allows adding and
> removing sockets, as well as automatic removal on unhash and close.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  MAINTAINERS        |  1 +
>  include/net/udp.h  |  5 +++++
>  net/ipv4/Makefile  |  1 +
>  net/ipv4/udp_bpf.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 60 insertions(+)
>  create mode 100644 net/ipv4/udp_bpf.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8f27f40d22bb..b2fae56dca9f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS

Acked-by: John Fastabend <john.fastabend@gmail.com>
