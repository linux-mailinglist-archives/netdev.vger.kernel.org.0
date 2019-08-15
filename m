Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A8E8F680
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbfHOVi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:38:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37066 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHOViZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 17:38:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so3958978qto.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 14:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7RjFhH6dS5ryo8FppK0a6qd+bmHzUr1mS9Tjvl8f9Xg=;
        b=H9ze0nzk6Ys63BibLvJCx1XQtGLvrmRz0XBkMa0V38lvqjiKhq+YyTYWMt/fFtchDW
         KRu7+T413iq15r7Jw7+O5apzJJi/hptumY/OrV6VVQDtaJGj2/j4XVWDu1QCZivQKYe9
         mBymRihkyxBP73gFi8mi+bZG7WbPfnwT0A7EhJqrr1ZXalJxAoSkDQWFvmR774999xvt
         RBAElb1pbQSANNGpyzGJOJu7cRMMvgLKwSto3eQkL4VK38/bH5UFjJmg2dQSlyUxSZBp
         TnmhipB/hLDYVJTetxOjj9oZA+nWrja3I8vjgGtb6ipW+WtbGr8whLNEsAQTijndbTTO
         BIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7RjFhH6dS5ryo8FppK0a6qd+bmHzUr1mS9Tjvl8f9Xg=;
        b=bW8kgdU99eOGVK+lmiv6f2Evmeb21uI1wMBkv5E8NMzidkS7dBhNhIa5JJhMbErSih
         ePNxmuzz3zB3fbwvLyVczeyjxb2pgi2XD46eLfpzUHN2EKsTOg7xfyAKMh/6ClfQG8hG
         2pvDArna8VciatXVQI8CAgD6pmdPTaudCkTjoxTwdMF3XsWd3nck5RFCGQgyj6VeK34X
         Le5M0m5QrBAFjpOA446pzpyX5QDtf+fxFDH7AZwGGBrMmOhuM/gXORyYY68S84RTr7LP
         qzNuFLDQiZjKk63UesJpDftKoJsibbtKhZdHTKor9EiEoozjuS4wdrXCTFAIgqhTPAQz
         mebw==
X-Gm-Message-State: APjAAAXl31tGZi92Fp+oSbk7ZyHDkw1m51ASg5+UtDHomUKSkUa84ORO
        AOMgYbolJOLtb8NOhnHA3qXmVg==
X-Google-Smtp-Source: APXvYqzMHgW4n4enlc9GDOdNi5gmHUYqKqHG+9ImxJBV701czliMZZ4iivhk7+rOfTatE8GIfPwEZg==
X-Received: by 2002:ac8:550f:: with SMTP id j15mr5923046qtq.25.1565905104815;
        Thu, 15 Aug 2019 14:38:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u23sm2059600qkj.98.2019.08.15.14.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 14:38:24 -0700 (PDT)
Date:   Thu, 15 Aug 2019 14:38:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Boris Pismenny <borisp@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] tcp: ulp: add functions to dump
 ulp-specific information
Message-ID: <20190815143810.3a190c81@cakuba.netronome.com>
In-Reply-To: <228db5cc-9b10-521f-9031-e0f86f5ded3e@gmail.com>
References: <cover.1565882584.git.dcaratti@redhat.com>
        <f9b5663d28547b0d1c187d874c7b5e5ece8fe8fa.1565882584.git.dcaratti@redhat.com>
        <228db5cc-9b10-521f-9031-e0f86f5ded3e@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 20:46:01 +0200, Eric Dumazet wrote:
> On 8/15/19 6:00 PM, Davide Caratti wrote:
> 
> >  
> > +	if (net_admin) {
> > +		const struct tcp_ulp_ops *ulp_ops;
> > +
> > +		rcu_read_lock();
> > +		ulp_ops = icsk->icsk_ulp_ops;
> > +		if (ulp_ops)
> > +			err = tcp_diag_put_ulp(skb, sk, ulp_ops);
> > +		rcu_read_unlock();
> > +		if (err)
> > +			return err;
> > +	}
> >  	return 0;  
> 
> 
> Why is rcu_read_lock() and rcu_read_unlock() used at all ?
> 
> icsk->icsk_ulp_ops does not seem to be rcu protected ?
> 
> If this was, then an rcu_dereference() would be appropriate.

Indeed it's ulp_data not ulp_ops that are protected. Davide, 
perhaps we could push the RCU lock into tls_get_info(), after all?

And tls_context has to use rcu_deference there, as Eric points out, 
plus we should probably NULL-check it.
