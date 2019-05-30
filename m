Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2717C2F925
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfE3JTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:19:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42734 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfE3JTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:19:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id r22so3561595pfh.9;
        Thu, 30 May 2019 02:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QhuVRUBfgD5dDqIAaCxObwAGWAaU0vki7zU9FvFkW8k=;
        b=j8CORNOxlpFqVGp77Z3rhaCMMI3PCUoXkIB6ePB72KKW+ESpmSr8FuQ1mlQ2ihWjC0
         sk9oVOeZiZ8DERS8XpW3btSS7Pz1zQZdZgeOLqImJfo61Xo8dQB0GnSa2XDMpBTeRtNO
         N2/2wujIFIWmaflAjv5fTx7BYe+jwGuz41E+odR8Jw2j9DwzkApMTXhJooqm1C4rm7Nd
         WavOJ+mZB8ef7ts2cQ0M73u/v1PM+MgVkVktNYBzYeFv/EHn2hSP89uyY9D3gnTweDJQ
         uV3q8/DZVDZXr1Pxpc5LKvdrPjKgW+buvRm+XFiLO9Oirm47aU8v6odJMnYXMEzeXHHd
         NuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QhuVRUBfgD5dDqIAaCxObwAGWAaU0vki7zU9FvFkW8k=;
        b=PLbRfq5YoyFTHprQ3mx6PW9ZVZo+dllXHMMZ6TU/16v4/+zxCG6Z4gplCshegV0pvG
         SXTL8b8auiCp8NIk6HUf3ZVDYcPMJazU+3+EKwpYO+kgBdxT8VmH6+JZpxsINhh2OJpP
         9+yKeadzWbcMkOhiPAX4OLEH84YBjU8qyew9flUtIpwOVwLxdxjBLZZ+n8ZXXV24Qjxc
         PZOCcZ4/1Il3X4q3rq2P2PMeu8cIJOE3uAnok8nL9HckJ0exqInjSEs/r4CzZYg4/Iba
         rwuOeQ23ytkXDvS9WiXgqKAhHvdkICPb/5Zi+TNDKJGYt0LPNWB+q7cCC7rRd7FQUFfy
         hXGQ==
X-Gm-Message-State: APjAAAXl8dtPtTUrHfYDbzdUPaKZTafQk3GpsEPswtxl/3PveRLDw8HQ
        RAyzsnOqpV3hlbatTsIISmc=
X-Google-Smtp-Source: APXvYqwA3bycNDmvN9D/sSssmu3wUhyxF0DSK+SbqDf6vc0YhV9vCn5r7tuotHnpHIfPji3ekqPalw==
X-Received: by 2002:a65:6551:: with SMTP id a17mr2611104pgw.1.1559207948070;
        Thu, 30 May 2019 02:19:08 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id t25sm4771120pfq.91.2019.05.30.02.18.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 02:19:07 -0700 (PDT)
Date:   Thu, 30 May 2019 17:18:48 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        ccross@android.com, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] hooks: fix a missing-check bug in selinux_add_mnt_opt()
Message-ID: <20190530091848.GA3499@zhanggen-UX430UQ>
References: <20190530080602.GA3600@zhanggen-UX430UQ>
 <e92b727a-bf5f-669a-18d8-7518a248c04c@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92b727a-bf5f-669a-18d8-7518a248c04c@cogentembedded.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 12:11:33PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 30.05.2019 11:06, Gen Zhang wrote:
> 
> >In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
> 
>    Allocated?
Thanks for your reply, Sergei. I used 'allocated' because kmemdup_nul()
does some allocation in its implementation. And its docs descrips: 
"Return: newly allocated copy of @s with NUL-termination or %NULL in 
case of error". I think it is proper to use 'allocated' here. But it 
could be 'assigned', which is better, right?

Thanks
Gen
> 
> >NULL when fails. So 'val' should be checked.
> >
> >Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> [...]
> 
> MBR, Sergei
