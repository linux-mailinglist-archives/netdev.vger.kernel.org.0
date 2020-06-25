Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3682E20A3B5
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406659AbgFYRHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404317AbgFYRHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 13:07:31 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E462FC08C5C1;
        Thu, 25 Jun 2020 10:07:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id l9so5988239ilq.12;
        Thu, 25 Jun 2020 10:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qgELrA3eg3b5dwFTkdkMEjy5n5s0NpbmSDKiMI+7ls4=;
        b=eCDObnmg74R2cb6t3wtFCGoOuAelt28F6Oa+94E+PS/RbZxduidWEGNX2xWY7C17SM
         Xlxf0L6mDRY5Oe2hbgvZD7MabP6/UthkeOOJcx10etKWEm1Tk3Z8shQEGjqzye/+eqq4
         88vht5DM4EyNzQIxOrnTMUH1vhgk6z1O2+/CUHs0oPTL/g2ZJIbnXdduRt/vi7aCn8L8
         XdkX9q4e+38dIVyFivrQmOJBQ/yEmhUjliLy25fvDC7Kmu15y/arhqjLMvPfqzEwYevz
         4pf1Hx0qQfIz2A6xZFNes3zZcGePq5kmNVGC2Nitcnqs+EIotw4VrSEa3/JMWtNwJZzF
         FHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qgELrA3eg3b5dwFTkdkMEjy5n5s0NpbmSDKiMI+7ls4=;
        b=Z4WeTH7pfR785VWXdRc/RBPgYp/f+6PCapr5wmCB2fCcRX0RwJoM2w4TBQ8ecbph2j
         6msnoHrRQWxZUL4+O6TvXYHfMZHm5pXETurej2iNwkTQ0VwguITt/ngR8ai7ejcLdqxD
         1kTCC/W8HdDW3Epbk5PcmASsOVo/wYCQmMdIZpZzcNegiNnwKJTDcH7yaknDVQSkXTm0
         wij0OaAoWh9I9skJHvEVVNJM8zr+F8z6tvn1guzmj6VnaXi6j4k9AA+QBBgWGkHEGmwi
         ZB2jMaQoJLvkxWARVAW74fJ1mnygm65ltAxR+RWDH3XpscqJ4hx5u19IfAMV6/WIGcE2
         nMCw==
X-Gm-Message-State: AOAM532AngdXXBJk9Z4h4oOcpaqionSAGOukIUnDlJvxDWDLlGtkHfHT
        bj3/OMM71PRNbV2dgJNR3UU=
X-Google-Smtp-Source: ABdhPJzeZV0bOTeIEAgd2oaa08zMqEPPYeeu42sXFLfbIq0S46TEgox7i4DGtWYVNQN+bK8rVABttw==
X-Received: by 2002:a92:8552:: with SMTP id f79mr8423781ilh.225.1593104851325;
        Thu, 25 Jun 2020 10:07:31 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l20sm13089081ilk.70.2020.06.25.10.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 10:07:30 -0700 (PDT)
Date:   Thu, 25 Jun 2020 10:07:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5ef4d9ca149ed_486f2aacfa4de5b44e@john-XPS-13-9370.notmuch>
In-Reply-To: <5ef4d4ffa74d3_12d32af9eaf485bc9e@john-XPS-13-9370.notmuch>
References: <159303296342.360.5487181450879978407.stgit@john-XPS-13-9370>
 <20200625062202.jyt5dzcdbanwkah2@kafai-mbp.dhcp.thefacebook.com>
 <5ef4d4ffa74d3_12d32af9eaf485bc9e@john-XPS-13-9370.notmuch>
Subject: Re: [bpf PATCH] bpf, sockmap: RCU splat with TLS redirect and
 strparser
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Martin KaFai Lau wrote:
> > On Wed, Jun 24, 2020 at 02:09:23PM -0700, John Fastabend wrote:
> > > Redirect on non-TLS sockmap side has RCU lock held from sockmap code
> > > path but when called from TLS this is no longer true. The RCU section
> > > is needed because we use rcu dereference to fetch the psock of the
> > > socket we are redirecting to.
> > sk_psock_verdict_apply() is also called by sk_psock_strp_read() after
> > rcu_read_unlock().  This issue should not be limited to tls?
> 
> The base case is covered because the non-TLS case is wrapped in
> rcu_read_lock/unlock here,
> 
>  static void sk_psock_strp_data_ready(struct sock *sk)
>  {
> 	struct sk_psock *psock;
> 
> 	rcu_read_lock();
> 	psock = sk_psock(sk);
> 	if (likely(psock)) {
> 		if (tls_sw_has_ctx_rx(sk)) {
> 			psock->parser.saved_data_ready(sk);
> 		} else {
> 			write_lock_bh(&sk->sk_callback_lock);
> 			strp_data_ready(&psock->parser.strp);
> 			write_unlock_bh(&sk->sk_callback_lock);
> 		}
> 	}
> 	rcu_read_unlock();
>  }
> 
> There is a case that has existed for awhile where if a skb_clone()
> fails or alloc_skb_for_msg() fails when building a merged skb. We
> could call back into sk_psock_strp_read() from a workqueue in
> strparser that would not be covered by above sk_psock_strp_data_ready().
> This would hit the sk_psock_verdict_apply() you caught above.
> 
> We don't actually see this from selftests because in selftests we
> always return skb->len indicating a msg is a single skb. In our
> use cases this is all we've ever used to date so we've not actually
> hit the case you call out. Another case that might hit this, based
> on code review, is some of the zero copy TX cases.
> 
> To fix the above case I think its best to submit another patch
> because the Fixes tag will be different. Sound OK? I could push
> them as a two patch series if that is easier to understand.

Sorry not enough coffee this morning the fix here is enough for
both cases I'll update the commit message.

> 
> Also I should have a patch shortly to allow users to skip setting
> up a parse_msg hook for the strparser. This helps because the
> vast majority of use cases I've seen just use skb->len as the
> message deliminator. It also bypasses above concern.
> 
> Thanks,
> John


