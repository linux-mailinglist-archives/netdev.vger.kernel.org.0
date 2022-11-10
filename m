Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBF462402D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiKJKmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiKJKmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:42:54 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A36A18B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:42:52 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j2so1839667ybb.6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=houAlH4RmEAh9OQ0Kr4c+cjpkjcJy/lrUJn345q8Jck=;
        b=EZ/0xiXiJ8dypd3t5ofTfGOVTq2+vwVqTkRHitWxrDx3k4XhVo183xRukHUouSz+pj
         RVevvtvSIvJgUdEQln+wvw0ymFWE/WIHyp8pZjgLbDH1+yLZrVeZZREqlBn/tRrJUbge
         wTDBfbgimNLYV0Zqx9aCBBni3CcKsO0vrxNOm+3aq1HddwCMPnrztFbuZNzg7oY4ACln
         cFr6aE7YRTgtOCDRqDpOhkjp3ZXBXJ+uhUMu4I+pws5szNPMpEF9TKkchHkvYcKtHCrV
         /SPZFEJz0B1ZFLTwXzbS++i4l6p+DIcVzhTMF2RPPdIMc3YA3mOdcgSLkGgbj9AYXUle
         szcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=houAlH4RmEAh9OQ0Kr4c+cjpkjcJy/lrUJn345q8Jck=;
        b=Qo1hjAWyas5AePF6Sr7jTuy5aKGv3aF0DMUrDA7h8rXncW141YuG1qwiU9Y/qjcazY
         1m32PwUl0Sg7Tr3xxifiCDc3cbj+gr+7wBM1n2mTSW3QIB9JR3/O6N0HsRkzazpS/FOj
         R9WGqylGvo6a3JJ/pZDv8bQLbgbYboboDIRzfDDfXMYGkxidF9B9+DShHvWMUfe7oq9K
         YLMLi6zuIWBP8ypuwWdZxO3o3zUzCePFzAOSlkKNRZCfSppck/BjZPoAbPUh5x7566B8
         XgKLxKmzQzmAXAzoxq1ioPqSjBrEmxeAfHSmhOuUKnAPCQtzOUlo+nQCHNjmQ8KEODFb
         RVvA==
X-Gm-Message-State: ACrzQf1LGb1eYYak/J+x6R2VNtUkKhTdeqwlcwKF48CvqMYzpCGGLrov
        0Bb6j3Hq/4wmTWOXxKcVLdsRoooPkO/H7XtaDq0lyg==
X-Google-Smtp-Source: AMsMyM5UB+oZcVZSOrHC7EMrswaOTmpmFM8Egb7/DjV+aYlRNQT7zKYRKAlATs1KB1LTGMg6SfiUEtmaPnmgF85EGic=
X-Received: by 2002:a25:2187:0:b0:6b0:1abc:2027 with SMTP id
 h129-20020a252187000000b006b01abc2027mr61465076ybh.348.1668076971092; Thu, 10
 Nov 2022 02:42:51 -0800 (PST)
MIME-Version: 1.0
References: <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
In-Reply-To: <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Thu, 10 Nov 2022 19:42:14 +0900
Message-ID: <CAPA1RqBF7u6posD9ozzaONmhoLnQACdYF8HdwDLjwYWDohyqvw@mail.gmail.com>
Subject: Re: [PATCH net-next] rxrpc: Fix missing IPV6 #ifdef
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org,
        "Hideaki Yoshifuji (yoshfuji)" <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2022=E5=B9=B411=E6=9C=8810=E6=97=A5(=E6=9C=A8) 18:44 David Howells <dhowell=
s@redhat.com>:
>
> Fix rxrpc_encap_err_rcv() to make the call to ipv6_icmp_error conditional
> on IPV6 support being enabled.
>
> Fixes: b6c66c4324e7 ("rxrpc: Use the core ICMP/ICMP6 parsers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> cc: netdev@vger.kernel.org
> ---
>
>  net/rxrpc/local_object.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
> index a178f71e5082..25cdfcf7b415 100644
> --- a/net/rxrpc/local_object.c
> +++ b/net/rxrpc/local_object.c
> @@ -33,7 +33,9 @@ static void rxrpc_encap_err_rcv(struct sock *sk, struct=
 sk_buff *skb, int err,
>  {
>         if (ip_hdr(skb)->version =3D=3D IPVERSION)
>                 return ip_icmp_error(sk, skb, err, port, info, payload);
> +#ifdef CONFIG_AF_RXRPC_IPV6
>         return ipv6_icmp_error(sk, skb, err, port, info, payload);
> +#endif
>  }
>

Because this introduces a missing return literally without CONFIG_AF_RXRPC_=
IPV6,
I would prefer #ifdef / #else for the whole function.

--yoshfuji

>  /*
>
>
