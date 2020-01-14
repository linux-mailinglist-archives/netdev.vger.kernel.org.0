Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C017139FE6
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgANDUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:20:02 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44977 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbgANDUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 22:20:01 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so12198991iof.11;
        Mon, 13 Jan 2020 19:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GUkjo1YR2Y2TREQ4wFD63GXd62gDbG+9LVcHOtxXyd4=;
        b=ggjA7f3JXWH0D8n6P+dteBuwi9Z9pfoOJOmzD/p9rHQbm/32N3Xh9gI1313tDOVbPQ
         oR2Moe9NzLa7fZug6+YAiA3guyLGqCut/NKJGGLuan0mjOFxWZtjOI2LFvaucUUaqtTq
         KBzixHO/qr1uOZYi5Z+2AI5BJxwso/Prrwlwy84lb4t9b5ZAwh8MQEvPYLjHETurWLby
         O45K13J+80oOOLha7Jn0UyCLhDElUmlUg0VSXD+Uez/lud6xEkJ+vJZ9H+vuu9Zjobdq
         2nJOkKSQ+gJFgU6HIZHdqFaa81FtasLEYn7lu/k4oyZiX6iTAIHC3y3oXLUgyUDWfKYS
         i4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GUkjo1YR2Y2TREQ4wFD63GXd62gDbG+9LVcHOtxXyd4=;
        b=OufQS92mhZTHKNw81MSVw/APDzqcSOFkNNX5QXtlqU/N2oQ5M5NFKddFJgHRW5z9+0
         T8AhSuqkrbsTD1hUSeY4Ln7y6stRjC9Ys+6kW+bGis/LW1mc+XKqlnoL3+UX25a1152O
         MJPD7ujtQFapG8g+nH4WQwIYfNYrsBOloAp3agqIWxaz7sF2e/w/7HhNHcP4ab0taZ+o
         gpkDR4A4dCDAlmkoClPaGSqnypQRpAQnimZod5C+grYMGfJpG2Kw/r90UNOvRJ9+ZP+k
         hfmzjOWpzyrIecPZ7Xro6FK/KAwSYuYEjyMarsfAsxah9JwwSrLUawdfAHRav2xNnxhw
         xo1g==
X-Gm-Message-State: APjAAAWzJN8cdsyB+e6ju077VBjenDV6GEfY/Wnt5or724LPgaeoycYM
        Dirg3YBK6iMX3s2pSLfKMVs=
X-Google-Smtp-Source: APXvYqwFqTtR5NfHVXTSCACSOi1YfZHcruZclN+HQP+2FiSPTmHtw20wLjrRRpkvdgt5Czv3MKlkSA==
X-Received: by 2002:a6b:8f11:: with SMTP id r17mr15560737iod.50.1578972001092;
        Mon, 13 Jan 2020 19:20:01 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u80sm4447443ili.77.2020.01.13.19.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 19:20:00 -0800 (PST)
Date:   Mon, 13 Jan 2020 19:19:52 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org, jonathan.lemon@gmail.com
Message-ID: <5e1d3358ae3f0_78752af1940225b430@john-XPS-13-9370.notmuch>
In-Reply-To: <87pnfnscvl.fsf@cloudflare.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
 <20200111061206.8028-2-john.fastabend@gmail.com>
 <87pnfnscvl.fsf@cloudflare.com>
Subject: Re: [bpf PATCH v2 1/8] bpf: sockmap/tls, during free we may call
 tcp_bpf_unhash() in loop
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sat, Jan 11, 2020 at 07:11 AM CET, John Fastabend wrote:
> > When a sockmap is free'd and a socket in the map is enabled with tls
> > we tear down the bpf context on the socket, the psock struct and state,
> > and then call tcp_update_ulp(). The tcp_update_ulp() call is to inform
> > the tls stack it needs to update its saved sock ops so that when the tls
> > socket is later destroyed it doesn't try to call the now destroyed psock
> > hooks.
> >
> > This is about keeping stacked ULPs in good shape so they always have
> > the right set of stacked ops.
> >
> > However, recently unhash() hook was removed from TLS side. But, the
> > sockmap/bpf side is not doing any extra work to update the unhash op
> > when is torn down instead expecting TLS side to manage it. So both
> > TLS and sockmap believe the other side is managing the op and instead
> > no one updates the hook so it continues to point at tcp_bpf_unhash().
> > When unhash hook is called we call tcp_bpf_unhash() which detects the
> > psock has already been destroyed and calls sk->sk_prot_unhash() which
> > calls tcp_bpf_unhash() yet again and so on looping and hanging the core.
> >
> > To fix have sockmap tear down logic fixup the stale pointer.
> >
> > Fixes: 5d92e631b8be ("net/tls: partially revert fix transition through disconnect with close")
> > Reported-by: syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  include/linux/skmsg.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index ef7031f8a304..b6afe01f8592 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -358,6 +358,7 @@ static inline void sk_psock_update_proto(struct sock *sk,
> >  static inline void sk_psock_restore_proto(struct sock *sk,
> >  					  struct sk_psock *psock)
> >  {
> > +	sk->sk_prot->unhash = psock->saved_unhash;
> 
> We could also restore it from psock->sk_proto->unhash if we were not
> NULL'ing on first call, right?
> 
> I've been wondering what is the purpose of having psock->saved_unhash
> and psock->saved_close if we have the whole sk->sk_prot saved in
> psock->sk_proto.

Its historical we can do some cleanups in net-next to simplify this a bit.
I don't think it needs to be done in bpf tree though.

> 
> >  	sk->sk_write_space = psock->saved_write_space;
> >
> >  	if (psock->sk_proto) {
> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>


