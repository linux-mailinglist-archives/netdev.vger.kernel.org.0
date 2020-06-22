Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D582031F4
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgFVIUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgFVIUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 04:20:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B849FC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 01:20:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so2246056wml.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 01:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2/77xZOPuFOPPv9J9YuPkow2vqhTG6kapE9uH4FzlI=;
        b=CGv5xTihsuHTBi1j0tQz8YCcEnZ13wcEjNppho6byFD/x5QfjkKffxic0rD8PLR9Ac
         2QtGyZVvdO5T6tLp6eHscKYdWdAD64Gde9ApvP3seWq4X9t9fuGglkQL3c9uQXelg13z
         Je2i1Sacd19o8o4NMz+1oOuucZvSPQFcghYqqzhApt8wjrBYFGgQqubCTVqQnUXGnfc8
         Fug7VtO8sIZpktY9wErppIyn1m9JTP8BmiALt/G+rZaXUgZ1/FsCxIs5byBFRJOwD98a
         2jq/4XBWMymwbytKFbwOguTrSCStxIfeuoL+nqcmFbPJyaHQiyTq/KAamSwn4GGyNvVI
         xQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2/77xZOPuFOPPv9J9YuPkow2vqhTG6kapE9uH4FzlI=;
        b=QFOnQTfY7ejSct+MjiEUpa9vJbKRt7iXWcxmEhPq3Z6m+VWr1QN2CwGghGYLI/NIVI
         gFURGJ4O5oaJQowsU/BpSN6ddA7kcPjKPImOTTui2rSs5qtqBl2Y8Ssio9u0Gz8VJtvC
         MUqih04vfGxxoN7cOVKYlimeL/2wUCHkeLzoRrZ/qVyEessgkjRDD4ouSNSsh4YwxVbl
         k5aMRbKA6MrICWw80l7g3J5No2qmV7ttPz4WTMDwhdxH6lmRTGWt9uJ+FG/ALhsw75up
         S6wZWo6nqeYPfezBakw0ScUcMaxBCafE3byIIeZx4hZZnANe7ldJf26S5Bx2e8fr+hfr
         Tq+A==
X-Gm-Message-State: AOAM531iAc16CWGzV+Gl0ZYUvrPs+ysj1cx010+h6tOZbGPv1Hbt2cbW
        xnfOCVBX5My6P/9zgn++aQP4zQ56XwM1JGiIjHb06/3uFbw=
X-Google-Smtp-Source: ABdhPJxZdlTJIjXI/4EQDfB3n9BoDpDItkXoM6PMKp0AdvfvKAtP/4rJcfs5IeroGwVCHDtg2p/mzK4szYyHf9L+beM=
X-Received: by 2002:a1c:7d54:: with SMTP id y81mr9057058wmc.110.1592814031522;
 Mon, 22 Jun 2020 01:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592328814.git.lucien.xin@gmail.com> <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <20200617091905.2b007939@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617091905.2b007939@kicinski-fedora-PC1C0HJN>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 22 Jun 2020 16:29:22 +0800
Message-ID: <CADvbK_fbCdmo2s3mPs57i8DeK8st9d8fMi4SMa-Vrhis5NkaBQ@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 02/10] tunnel4: add cb_handler to struct xfrm_tunnel
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 17 Jun 2020 01:36:27 +0800 Xin Long wrote:
> > This patch is to register a callback function tunnel4_rcv_cb with
> > is_ipip set in a xfrm_input_afinfo object for tunnel4 and tunnel64.
> >
> > It will be called by xfrm_rcv_cb() from xfrm_input() when family
> > is AF_INET and proto is IPPROTO_IPIP or IPPROTO_IPV6.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Please make sure W=1 C=1 builds don't add new warnings:
>
> net/ipv4/tunnel4.c:118:14: warning: incorrect type in assignment (different address spaces)
> net/ipv4/tunnel4.c:118:14:    expected struct xfrm_tunnel *head
> net/ipv4/tunnel4.c:118:14:    got struct xfrm_tunnel [noderef] <asn:4> *
> net/ipv4/tunnel4.c:120:9: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/tunnel4.c:120:9:    struct xfrm_tunnel [noderef] <asn:4> *
> net/ipv4/tunnel4.c:120:9:    struct xfrm_tunnel *
I will change to on v2:
 static int tunnel4_rcv_cb(struct sk_buff *skb, u8 proto, int err)
 {
-       struct xfrm_tunnel *head, *handler;
+       struct xfrm_tunnel __rcu *head;
+       struct xfrm_tunnel *handler;
        int ret;

Thanks.
