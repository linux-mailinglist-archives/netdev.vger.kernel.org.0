Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7606A2667
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfH2Ssk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:48:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44323 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbfH2Ssk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:48:40 -0400
Received: by mail-io1-f68.google.com with SMTP id j4so8915907iog.11;
        Thu, 29 Aug 2019 11:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=O0QhddbAdq0Wm1USCsTevVqQjpQsCQKOsNsCDnEPcso=;
        b=BqVgmw6nSwZ1wSmuNPTwUOlZrrd87vsrisy6QCkqsDFrdXOrv6CYHIGoEKqBGzdwo0
         JMbbiWRYjLdpBjT03o+NWP9LQClG46SibBIkmwpI/dLnZJLzjx+IY44OQs750DU5IwbR
         XhaFhNaGn1PfAwx78jfbSSnetv3qcGnS6MAd56WsIY3yNQ9cbDZPeJ2p5tVAD92VgNP7
         dGthY0llK+y0NnfFxibli9+5ElPl5I/Hc3CQPTzdXb5vQofFnzoDV/vqBxbhYcgyLQoV
         hGbR5Qkz2a9f7jrXajUf83pJHxtOtWS9FIjvZWMv0jOroU1tEIJZvxCIec21678Q3Gzs
         5iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=O0QhddbAdq0Wm1USCsTevVqQjpQsCQKOsNsCDnEPcso=;
        b=EQzTqe0iST/Tgwb8vAYEDcLhBLDgi7i8KWZ6+I6C8s04owmjY/jvTXnsAN9Xw3Uj2t
         D+ss//ZjzG7H2ZSEiF/bcsx0YhpLCYZg870MSPcf21o1iFAUnUJXKDwSvaqhMM7t0yH4
         t+uKXl02FYsBIMQGuWhT8FouxqZxFVj84lFOr43bI2WiGMZemePF0svO8saY55uoXXKl
         Uwsk6e3cmPZRROhGXJhFapZHLlTda1l1MABhSb54eWNWLJ45SuLRPBK6V9W31cj2bOSj
         vxEvOD8+whDi3ww4dPcpBhNAAMU43xCCNBNGZE1SfS4FHmPdBCUZUa67ynJDoToVQOQ2
         QkkA==
X-Gm-Message-State: APjAAAULlx3gE81vFtZHhttEm1ECq+9D7lVAGA4U4ic+l+RJ8feJPu/p
        4DEk+S/o7gYpNGCJoxn+p8A=
X-Google-Smtp-Source: APXvYqxsUdCcITpTpmmaIl49H//+cqifoiuFNtkIlv8j7yDIvsH1unuZqY3sqxDmuUkoArx/cMF9eg==
X-Received: by 2002:a5d:9b96:: with SMTP id r22mr13265627iom.17.1567104519093;
        Thu, 29 Aug 2019 11:48:39 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h9sm4832191ior.9.2019.08.29.11.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:48:38 -0700 (PDT)
Date:   Thu, 29 Aug 2019 11:48:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     john.fastabend@gmail.com,
        syzbot <syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Message-ID: <5d681e0011c7b_6b462ad11252c5c084@john-XPS-13-9370.notmuch>
In-Reply-To: <20190829094343.0248c61c@cakuba.netronome.com>
References: <000000000000c3c461059127a1c4@google.com>
 <20190829035200.3340-1-hdanton@sina.com>
 <20190829094343.0248c61c@cakuba.netronome.com>
Subject: Re: general protection fault in tls_sk_proto_close (2)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:52:00 +0800, Hillf Danton wrote:
> > Alternatively work is done if sock is closed again. Anyway ctx is reset
> > under sock's callback lock in write mode.
> > 
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -295,6 +295,8 @@ static void tls_sk_proto_close(struct so
> >  	long timeo = sock_sndtimeo(sk, 0);
> >  	bool free_ctx;
> >  
> > +	if (!ctx)
> > +		return;
> >  	if (ctx->tx_conf == TLS_SW)
> >  		tls_sw_cancel_work_tx(ctx);
> 
> That's no bueno, the real socket's close will never get called.

Seems when we refactored BPF side we dropped the check for ULP on one
path so I'll add that back now. It would be nice and seems we are
getting closer now that tls side is a bit more dynamic if the ordering
didn't matter.

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1330a7442e5b..30d11558740e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -666,6 +666,8 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
        WARN_ON_ONCE(!rcu_read_lock_held());
        if (unlikely(flags > BPF_EXIST))
                return -EINVAL;
+       if (unlikely(icsk->icsk_ulp_data))
+               return -EINVAL;

        link = sk_psock_init_link();
        if (!link)
