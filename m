Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF45986AD
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfHUViw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:38:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34537 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfHUViw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:38:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id m10so3265787qkk.1
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bC5fqBHvIGMPVjvJQhyiA8xYhaqcGgYRkivbpM0BBis=;
        b=EKec8j+C+/CntxOfhnFFhCk6ZfwDUhqpeVoMx9mTgWSBg6NkYNNRvs9opnW6+SxfK6
         HfmC6sHPLm+n6vdSCq6/gJ+A+3qvUEE5BeAJSWIIgsAS7k+FiQwlzTw6ibJYqF1W3Rzd
         vrRuJG831RsH+xQolpXU42YYsjkZcXMe9LURg6Vm4kiFhgxVIGlXzOF3TE4kXsjTjw8x
         n2Nq+Jgl56PgM1PEl2JmFjqSt6r0wgSGO4KUvGFmtvs0oo307Sd9WICYYEdn0JLSxUWy
         l9g07NtM0sW0OVLENQ6pSz/Llz3L5HXO4m7dZsHwd7Cj0hDJ/hmaC9ygA2kjvr+Y/CFW
         HDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bC5fqBHvIGMPVjvJQhyiA8xYhaqcGgYRkivbpM0BBis=;
        b=ovsQ2vzFnCNYsymgyKrKTZ9rtUG6Cy7RLrLrxM5K1Q685P+b11EVOAntBIYiTiOKV5
         hci3g/ECWlQwegOmJyW/R/ZFAYdfot6U+z9pImtGOd4q5FFeOEcc8GOKIv/zLQQEvmA6
         lD5vOI/PuY0RWFcAcJ6bKo7gnG7x42pDOtwpNEzr5dMlt9WfbmXd46Bez2/zx5UdvmY5
         bpCKu3XBEPIAXFOhkbESpLYLHEkDxmLYTQAojOEdBPfqXhvfoDA9YWYOI36liDUJISuD
         +0Ks3S+0R8fyMCmwGD40kMzrEz8J7EU7s7Wy87WSSTjOhl52t8RUctQR5O+VxIhla6s/
         KsRA==
X-Gm-Message-State: APjAAAUkoMxbl6kXz10in6S3Q+N675DmY2EtnSmtDxZa0ZEzRaIeaYoJ
        BAjLD4GfawaJViAE1Iq/L+ICf0IJ15I=
X-Google-Smtp-Source: APXvYqxDoRcYD2q8YVe66Pd5u5ZK6lfOkc0Bcht/lhjAWa3IvTGEFW5DJpNhLy4BWWOXkUA9f2uemg==
X-Received: by 2002:a37:a358:: with SMTP id m85mr34168118qke.190.1566423531642;
        Wed, 21 Aug 2019 14:38:51 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w15sm10422398qkj.23.2019.08.21.14.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 14:38:51 -0700 (PDT)
Date:   Wed, 21 Aug 2019 14:38:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 24/38] cls_u32: Convert tc_u_common->handle_idr to
 XArray
Message-ID: <20190821143846.6c621b47@cakuba.netronome.com>
In-Reply-To: <20190821212542.GB21442@bombadil.infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
        <20190820223259.22348-25-willy@infradead.org>
        <20190821141308.54313c30@cakuba.netronome.com>
        <20190821212542.GB21442@bombadil.infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 14:25:42 -0700, Matthew Wilcox wrote:
> On Wed, Aug 21, 2019 at 02:13:08PM -0700, Jakub Kicinski wrote:
> > On Tue, 20 Aug 2019 15:32:45 -0700, Matthew Wilcox wrote:  
> > > @@ -305,8 +306,12 @@ static void *u32_get(struct tcf_proto *tp, u32 handle)
> > >  /* Protected by rtnl lock */
> > >  static u32 gen_new_htid(struct tc_u_common *tp_c, struct tc_u_hnode *ptr)
> > >  {
> > > -	int id = idr_alloc_cyclic(&tp_c->handle_idr, ptr, 1, 0x7FF, GFP_KERNEL);
> > > -	if (id < 0)
> > > +	int err;
> > > +	u32 id;
> > > +
> > > +	err = xa_alloc_cyclic(&tp_c->ht_xa, &id, ptr, XA_LIMIT(0, 0x7ff),
> > > +			&tp_c->ht_next, GFP_KERNEL);  
> > 
> > nit: indentation seems off here and a couple of other places.  
> 
> what indentation rule does the networking stack use?  i just leave the
> cursor where my editor puts it, which seems to be two tabs.

Oh, match opening bracket..

	err = xa_alloc_cyclic(&tp_c->ht_xa, &id, ptr, XA_LIMIT(0, 0x7ff),
			      &tp_c->ht_next, GFP_KERNEL);
