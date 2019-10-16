Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9E5D974D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393998AbfJPQ1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:27:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44074 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390135AbfJPQ1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:27:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so10598738pgd.11
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 09:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nD7/B9wEfV2QwJsD+kkGncs6H/92+ihCIlxpYJZuty0=;
        b=hJstxUu7qYT4KRJ+7JYRTl+WsJh5u927Z3troD14yqq2VP3A5EQhFVcKa0KgrTWAzL
         m3Pl/9He8k8BTJxTxwZWp4wIFR2WqVsqN9BeG6XN+3jRkzr4qDvv7DT3oo30SDje4Xkm
         k57dRUJaAvj7otbKqB9iqsacSS9mnJEYNu08340Kadonb8lisHVoO2rbtSDfCjdgi2yK
         67ah7963+hilHQPGF9GwQxCaZt20d0S3GpG14jWnq22FotCsDHIU+CtfIz/aWiT55gcW
         Qr2Umu7nu9QAgn+FL+WGQ7KGAdAIq66JIf1tJlZL+ZABEIcwtWLPZ8++s20VeYlVEZ9d
         Ll6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nD7/B9wEfV2QwJsD+kkGncs6H/92+ihCIlxpYJZuty0=;
        b=S6rhDY23wBtNSUOIV9sIVZfJTlrzyUuWHz2mvst1RBOjj2zLE8E5pf3E9hv0SaRxWr
         QyDc4lOrxiafqmyNirQulLrXJc9suwbuu6SfTrVizsK99CjsWa0xQp34znjn0UyMqHZ3
         1M+DtayEN2x63VbWamjF7oUBdnA+J7Cd8baomry/B6OT8Juv1PTVz9DaHdwhVEQdxyN4
         hqqEybT8/xvaW0MjGAR9xCdw6Mf4yJKHcGsK+W+/IcPjncMAE1it8DUuN99gkDwdyTZp
         0rf7wqUxIvKwFP/tPPd6dsGp5Tlto+IbIc2VAldPZfxMd/S+QYLoDRqfCgOP7Zh/VLfV
         qdzg==
X-Gm-Message-State: APjAAAUfJXZN1XZ64f+ltuV8qw1wH/I5Y29AuntR1ZuZyEfG2lCjFQEh
        UcPAot6cl77cxoqYVX2WB6DEUw==
X-Google-Smtp-Source: APXvYqxM/h3gTSUz+O66+rbNfG5i9VnNX3yHG8pdebJgP4n8AuiNV66hoYNb3+1S7crJdki+9BuNQg==
X-Received: by 2002:a62:ab02:: with SMTP id p2mr46152072pff.92.1571243240809;
        Wed, 16 Oct 2019 09:27:20 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id y2sm28863795pfe.126.2019.10.16.09.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 09:27:20 -0700 (PDT)
Date:   Wed, 16 Oct 2019 09:27:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Message-ID: <20191016092716.1a8d528f@cakuba.netronome.com>
In-Reply-To: <20191016100900.GE2638@localhost.localdomain>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
        <20191015171152.41d9a747@cakuba.netronome.com>
        <20191016100900.GE2638@localhost.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 12:09:00 +0200, Lorenzo Bianconi wrote:
> > > +static int
> > > +mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
> > > +{
> > > +	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
> > > +	int cpu = smp_processor_id();
> > > +	struct mvneta_tx_queue *txq;
> > > +	struct netdev_queue *nq;
> > > +	u32 ret;
> > > +
> > > +	if (unlikely(!xdpf))
> > > +		return MVNETA_XDP_CONSUMED;  
> > 
> > Personally I'd prefer you haven't called a function which return code
> > has to be error checked in local variable init.  
> 
> do you mean moving cpu = smp_processor_id(); after the if condition?

	[...]
	struct xdp_frame *xdpf;
	[...]

	xdpf = convert_to_xdp_frame(xdp);
	if (unlikely(!xdpf))
		return MVNETA_XDP_CONSUMED;

I meant xdpf, sorry to be unclear.
