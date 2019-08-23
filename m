Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E999B62C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404716AbfHWS0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:26:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35273 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404692AbfHWS0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:26:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so9007239qke.2
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 11:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ic2bPmp49U9Rzy6H/8n3XKjawc1Iamf9LKy2R4QYjC4=;
        b=mO/cdfSTCGvxNm2hVxTmeIbX0z4BjuwXIq6RV0OAHvNarrv95AY3v6XTpi594yhY7S
         nnFEF3KccvUWxhxFvScJaeI9PnFW2xJ98Jd/fuoDQn7iHZFgebh6kb6aB1dG+RQRleTr
         3cF8R5qmY5UOTyBgHbXDpsAbiDO6f+AvesizVil3iL7UvRwwTpiBygPvp8NPZPmTxRoe
         D14SSsf/8C+gP8HKcsNinJX/VW/+2knO4W5WzBevX+2DtVg+57qJxmbnlmn00cg6gyz3
         9nLWqnfHI8QALNp4gNuOQzI3zYXz1o3lOEEjml7HSPSuEKfG+ZaHWzebMVg6yyVYcmmD
         R9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ic2bPmp49U9Rzy6H/8n3XKjawc1Iamf9LKy2R4QYjC4=;
        b=EC36hYY14YniG7EGO93SwgJHXz7WtS87yDfNYXc9vGWY9vqYdsaFu+u0hK+IBxcNR4
         ZZXmVcMtl+VxaGaVJiVByOjqtnLoCVeXU4y3nbHX3NFsnoojZohRaGVz5DBihS1o87OW
         /3C5D+xSH0frQ5zXzlxo4BWNXvzF1h3k2Il8fdFtnx3GAcNquyStogB7vKCcX4pnOFGv
         hssn8PiIHMvjhpOXxnYHgzLTRwdUun9ZspcQV6Mq1PGAA44KcOPLRxS60KpxmRClbIql
         mXSLGSKHwn1InFUTUyiKniQLIA4ERoiJJI5tkQkUTGzDDNzhVVbY/E4/WYWcFYSVuhLW
         LevQ==
X-Gm-Message-State: APjAAAUAuNZvypgpQvhqDhZuIFGdzEBEUPwtn4+RAQxkTUxt7p8eT5m5
        ADyJaRkXxZYQiNYUQlst18Bk8w==
X-Google-Smtp-Source: APXvYqw3QqHpmr1xJ3t7APG0/UNZ+q0SyFowdckejxy7PLJHI93b8EoUiwSpx4co8S43qM2s7LTC+g==
X-Received: by 2002:a05:620a:6cf:: with SMTP id 15mr5273647qky.98.1566584778139;
        Fri, 23 Aug 2019 11:26:18 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x69sm1820881qkb.4.2019.08.23.11.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 11:26:18 -0700 (PDT)
Date:   Fri, 23 Aug 2019 11:26:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 03/10] net: sched: refactor block offloads
 counter usage
Message-ID: <20190823112607.1b4a69bf@cakuba.netronome.com>
In-Reply-To: <vbfftls17yl.fsf@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
        <20190822124353.16902-4-vladbu@mellanox.com>
        <20190822155358.0171852c@cakuba.netronome.com>
        <vbfftls17yl.fsf@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 10:39:50 +0000, Vlad Buslov wrote:
> >> +/* Destroy filter and decrement block offload counter, if filter was previously
> >> + * offloaded.
> >> + */
> >> +  
> >
> > hm.. is this gap between comment and function it pertains to
> > intentional?  
> 
> Majority of function comments in cls_api.c have newline after them (not
> all of them though). I don't have any strong opinions regarding this.
> You suggest it is better not to have blank lines after function
> comments?

Ah, you're right. I think it's pretty strange to have a new line after
a comment which pertains only to the function which is immediately
following it. Often the new line is used as a separation, when the
comment describes whole section of the file..

I kind of wish kdoc allowed none of the parameters to be described.
Often you want to document the function but the parameters are kind 
of obvious.

Anyway... feel free to leave this as is.
