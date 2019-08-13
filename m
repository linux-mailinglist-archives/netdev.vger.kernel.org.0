Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C3E8C12F
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfHMTAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:00:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39397 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfHMTAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:00:00 -0400
Received: by mail-qt1-f195.google.com with SMTP id l9so107385627qtu.6
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 12:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hWnpwsctAkFfJ/Y7Dx2168l4gTaV9/DNkw70UP5BSgg=;
        b=e3XYEfdK4qDqWEnJOy0jPQS2R+UFWXoFCTPxaoXbWHwcOV21V6gfctNchibdH84Coc
         Viw1Qgk6JAbr5WFBDmEHsrg9pscOS3cbZQpuCZMSZRAzObO4nRVdK6PpWy83VAQNVEeu
         g5NR0Ap9osg/313yfIg4rUfyp4j3C6Y2CJtUJgQdWl1ETgTXLt9QyQa0hZa3wwH5Sh2L
         p0sRusV1zNDElhXu6jqG2CswSE3ekDPJdpTak81BW4MdktcRCrQENpeiruIRr1WLbmI0
         X3+LbO2l+XzNSAfdO7WindmzMkCUkduFIWtZX0kXYo1cQtw5A+tainNkPP1v2W3vay0X
         ULpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hWnpwsctAkFfJ/Y7Dx2168l4gTaV9/DNkw70UP5BSgg=;
        b=UEJcSn+r5M2276japGuX0K4DRvCAa8GGTEBO9E2gWT6Qv4kzrodzD1Gzor9vO/hqED
         qebdN7l0CVpkrhMl3ouEegG2wYVbLj3YhqlHzpcCYS77zcRMkoLO6B34W7RS6hILpszV
         ninr5MnIg1QuOIhufeYnSZuITz+iY043gqtqX+V5275pWC0HapMrUQM7CoX1tOy5FMA0
         7QMAmMQmSEtCU+l8AGVnP6WZ+gPsSuWyi3PiEGfFoX7EqF0/fK/XAb2SkasX6BAMyU6H
         flPlHJFcTDg8ZVHhbKqovIA1fvUEbyW5nxSEUQhMH8JMnEDL4abS8FJYaK2COUQyjtns
         lM9w==
X-Gm-Message-State: APjAAAXqFZHcHAgwrAHUo71L8kU5/3KB/ECtSEnpsiKPbqaU8UGRJNUC
        gkY2Rj7sKYRufuvDM428S3k2PA==
X-Google-Smtp-Source: APXvYqzMWVu3ASVVLZYFrN/WZNILWGDY1hK3UvvS1WCAOqUBWgo1DrucXspjqq0I7kLkP5ELVLTWsg==
X-Received: by 2002:ad4:4373:: with SMTP id u19mr3060qvt.202.1565722799686;
        Tue, 13 Aug 2019 11:59:59 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i5sm4773269qti.0.2019.08.13.11.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 11:59:59 -0700 (PDT)
Date:   Tue, 13 Aug 2019 11:59:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, syzkaller-bugs@googlegroups.com,
        willemb@google.com
Subject: Re: general protection fault in tls_write_space
Message-ID: <20190813115948.5f57b272@cakuba.netronome.com>
In-Reply-To: <5d5301a82578_268d2b12c8efa5b470@john-XPS-13-9370.notmuch>
References: <000000000000f5d619058faea744@google.com>
        <20190810135900.2820-1-hdanton@sina.com>
        <5d52f09299e91_40c72adb748b25c0d3@john-XPS-13-9370.notmuch>
        <20190813102705.1f312b67@cakuba.netronome.com>
        <5d5301a82578_268d2b12c8efa5b470@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 11:30:00 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Tue, 13 Aug 2019 10:17:06 -0700, John Fastabend wrote:  
> > > > Followup of commit 95fa145479fb
> > > > ("bpf: sockmap/tls, close can race with map free")
> > > > 
> > > > --- a/net/tls/tls_main.c
> > > > +++ b/net/tls/tls_main.c
> > > > @@ -308,6 +308,9 @@ static void tls_sk_proto_close(struct so
> > > >  	if (free_ctx)
> > > >  		icsk->icsk_ulp_data = NULL;
> > > >  	sk->sk_prot = ctx->sk_proto;
> > > > +	/* tls will go; restore sock callback before enabling bh */
> > > > +	if (sk->sk_write_space == tls_write_space)
> > > > +		sk->sk_write_space = ctx->sk_write_space;
> > > >  	write_unlock_bh(&sk->sk_callback_lock);
> > > >  	release_sock(sk);
> > > >  	if (ctx->tx_conf == TLS_SW)    
> > > 
> > > Hi Hillf,
> > > 
> > > We need this patch (although slightly updated for bpf tree) do
> > > you want to send it? Otherwise I can. We should only set this if
> > > TX path was enabled otherwise we null it. Checking against
> > > tls_write_space seems best to me as well.
> > > 
> > > Against bpf this patch should fix it.
> > > 
> > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > index ce6ef56a65ef..43252a801c3f 100644
> > > --- a/net/tls/tls_main.c
> > > +++ b/net/tls/tls_main.c
> > > @@ -308,7 +308,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
> > >         if (free_ctx)
> > >                 icsk->icsk_ulp_data = NULL;
> > >         sk->sk_prot = ctx->sk_proto;
> > > -       sk->sk_write_space = ctx->sk_write_space;
> > > +       if (sk->sk_write_space == tls_write_space)
> > > +               sk->sk_write_space = ctx->sk_write_space;
> > >         write_unlock_bh(&sk->sk_callback_lock);
> > >         release_sock(sk);
> > >         if (ctx->tx_conf == TLS_SW)  
> > 
> > This is already in net since Friday:  
> 
> Don't we need to guard that with an
> 
>   if (sk->sk_write_space == tls_write_space)
> 
> or something similar? Where is ctx->sk_write_space set in the rx only
> case? In do_tls_setsockop_conf() we have this block
> 
> 	if (tx) {
> 		ctx->sk_write_space = sk->sk_write_space;
> 		sk->sk_write_space = tls_write_space;
> 	} else {
> 		sk->sk_socket->ops = &tls_sw_proto_ops;
> 	}
> 
> which makes me think ctx->sk_write_space may not be set correctly in
> all cases.

Ah damn, you're right I remember looking at that but then I went down
the rabbit hole of trying to repro and forgot :/

Do you want to send an incremental change?
