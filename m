Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F266100AF4
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfKRR7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:59:15 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37532 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfKRR7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:59:14 -0500
Received: by mail-pg1-f194.google.com with SMTP id b10so1465125pgd.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 09:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7EYmZ7NRTxHkOWSbSxQ0gywzZ0Cdf+FfUYZH7rtEdQE=;
        b=dLIQEzcwJz03sHkX/zkGpM9f5gUe4Ym6v3uAIwg37cDxKuvpfBDkJEaQpxzKHzK5fv
         PwiH8ZdFLgm9mi7G+FxOTJvbzKFvKbp0ZgvV/+/9eTdRu09rUCCIgt5Tijrm0oYfy6vY
         ae1TO3fwnzHwp3RD6ch5hUmBkvcD+bd+BIxgPXQNrpmYl0ys7jhvyb4EoYa0Z8UumCPo
         gh6FWfkUDYgGqYD38BJRkMEycx7slcYj7Jq8bjTk9qSQY/FFFun9JXxsrlxiyZ1WepyL
         7KFFRRVvozD2Fp1TqFeOS5wq0MPMFwO17JNiyIJpw+vvX/Dh4GK7wqmIU4GXaHYcgUuq
         WMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7EYmZ7NRTxHkOWSbSxQ0gywzZ0Cdf+FfUYZH7rtEdQE=;
        b=d/h2LZTnTXCp2yrJVYUutANVfzWdqKOECBfrjk/VioN4uQjoI7ZMVzVEmvKv+XYC19
         cgC0M2uHm0pzMHM57Xf7F/8ivPrm+av3uqTH85lNILaaKPKzCgsV4jGe7lqyJxy5xdWn
         i5Vj5Z4xphYuvayVOAvit2cioXMWKrAtGWL8ibTDa8HlfjcivQct2h5tF6P3cJuOriPT
         xMWeVvkQ5iXMrNKC1Iqjkw8wxYMJOeAmU6vrii2bmclsBnWV/htoi2HNyRxVyFWC8PJP
         r1QoalP1iJBpp3W/okCxHSaUKv0L62omgsMVKBvJYql2vh1NMPI8e9mu8K8RkWG6tQY3
         vjBg==
X-Gm-Message-State: APjAAAV0iXHfR+CmtA/ZDzpF82tu/I+QdRmP6ivsOvil46w06lqh7XW5
        v6nS5+MvEF2/wLAtCHJ5WOvIMw==
X-Google-Smtp-Source: APXvYqwe244ck0Ha1OOKUd5dlfDyynPE9re1cJMR8bAB5hw9pzDlUwsH4z+WwCavWNf8pM4H24Z4bg==
X-Received: by 2002:a63:f40e:: with SMTP id g14mr623031pgi.132.1574099953908;
        Mon, 18 Nov 2019 09:59:13 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r16sm18525557pgl.77.2019.11.18.09.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 09:59:13 -0800 (PST)
Date:   Mon, 18 Nov 2019 09:59:10 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal\@kernel.org" <sashal@kernel.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net, 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Message-ID: <20191118095910.3566c5dd@hermes.lan>
In-Reply-To: <87wobxgkkv.fsf@vitty.brq.redhat.com>
References: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
        <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
        <87wobxgkkv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 18:28:48 +0100
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> > +		netdev_err(ndev, "Received send-table offset too big:%u\n",
> > +			   offset);
> > +		return;
> > +	}
> > +
> > +	tab = (void *)nvmsg + offset;  
> 
> But tab is 'u32 *', doesn't compiler complain?

nvmsg + offset is still of type void *.
assigning void * to another pointer type is allowed with C.
