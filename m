Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B9617C1C0
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFP20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:28:26 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:39182 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFP2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:28:25 -0500
Received: by mail-pf1-f181.google.com with SMTP id w65so726371pfb.6;
        Fri, 06 Mar 2020 07:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lglEGZYxW0hnEoW7mMQ/XbMDpHsIajsIGt2QbD7jk2k=;
        b=K+7c4w9+HrFBk71MUJPg0LLWA/2wI4m2pOIVzyI9/31q7uzLnAU2iPQL4knA8jzV1Q
         m+oFn6iQ6SC5/ifO8tZFSimQUVb6j337CGXWkU4C1FSYs3+qvn3aI8Vz6P1msjMhNXTH
         ysJ7l3cHR72d85MYG7dCkRwUfHiuGCgxaBpp+zQ4qE8okeNQENvTd4qCLH+LL9aNhr6Y
         i6C3LuvJNrb1O7TZmTTZPC6O5URrFqM9dm1tz6n3VCOZ+0D3exTJxWymxi++LX0FOJPB
         SagGJbEWXb6q6AOJfjedyBCUA5bFMwJ2gElmwyAlGbrEZTF/pqTDcolrAey9/9AIzQwF
         3tSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lglEGZYxW0hnEoW7mMQ/XbMDpHsIajsIGt2QbD7jk2k=;
        b=XKy//16iCWhL08F1LYGHieiRBlJTSSAIvhJfhyiJedBS1r+RXTBQa+SgcHBbtcrfnX
         Z8qPBAZXZa0iHvUnopAOSmYaXnXbflI91RNwLGcUpQ5xRGbPB84BR05rwU4XtKl+ZXoZ
         XGl/2sWEIIBSb170KIfRIDrFaLwq9Im9w9rDRyRqeZs+T3HHeCRlGgW4uzMT0QXih8A7
         FeaUqX+kCfsXHEHadhy2fbZ+hjC4T3Ux0/d8DF5GxnRyHusw+Wfzr49A485Udc7PAeCq
         Ow28XPpy9U35L522zVfHCsBsG+dqpYSttU+35yuUVKeyu4V1tXF45sG1/4JQvFdf6gi4
         WCBQ==
X-Gm-Message-State: ANhLgQ1TAvFKbUg/6bckIuabMdNamIbxtD4p9j6Ld5L1XwnA5qDQQZDx
        VWo70s1FdkyPiz/tHpZQd6Y=
X-Google-Smtp-Source: ADFU+vsmC0lDqEQ8bINdVR06tUjHm7Rt47588Xh45rCmrBMOx+lIGIJdZ0qf4dAMq5pTRmQlJW5C+Q==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr4054843pgd.161.1583508504559;
        Fri, 06 Mar 2020 07:28:24 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l4sm9861543pje.27.2020.03.06.07.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:28:23 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:28:15 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e626c0fa6eee_17502acca07205b448@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-6-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-6-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 05/12] bpf: sockmap: move generic sockmap
 hooks from BPF TCP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The init, close and unhash handlers from TCP sockmap are generic,
> and can be reused by UDP sockmap. Move the helpers into the sockmap code
> base and expose them. This requires tcp_bpf_get_proto and tcp_bpf_clone to
> be conditional on BPF_STREAM_PARSER.
> 
> The moved functions are unmodified, except that sk_psock_unlink is
> renamed to sock_map_unlink to better match its behaviour.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/bpf.h   |   4 +-
>  include/linux/skmsg.h |  28 -----------
>  include/net/tcp.h     |  15 +++---
>  net/core/sock_map.c   | 106 ++++++++++++++++++++++++++++++++++++++++--
>  net/ipv4/tcp_bpf.c    |  84 ++-------------------------------
>  5 files changed, 118 insertions(+), 119 deletions(-)

Acked-by: John Fastabend <john.fastabend@gmail.com>
