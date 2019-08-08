Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7398684E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732708AbfHHRuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 13:50:21 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34580 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbfHHRuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 13:50:20 -0400
Received: by mail-qk1-f195.google.com with SMTP id p1so2106401qkm.1
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 10:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oKFwrL4RPnBdhgXX2NvVWtcFE2czxOUkdtY3yXFr7eg=;
        b=VaP4MKnk+DypFhEnNMAymSXYx+CWgVGcTZDlYu4PQ8b6pgD9bNgtz7taQAhrK8KqW+
         W+hmYnlOVcFweLyyRy6HrVKdCElmOzLBCQIHzKz1bKB1jLVY8tjfuzueTMqZfu5jSTer
         BBKPLdWumEKT+pmnCzEhr45g1MWpzGUesJzUJSlmwl9s5I44fQVbuMxHzmd3AHD5Rgv5
         WvbebqQwsetV9o4oOAQrbyk3Z2UsWoF0wB95cWbFe4thQfrwEuPq3d+7bCotdk30zuL9
         FzLdEHObnnMzBlahdz3R37d2Pqsk1kFJnHFjHKNb9aPABzsHADIrXySdvxmvfC8a40OY
         TwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oKFwrL4RPnBdhgXX2NvVWtcFE2czxOUkdtY3yXFr7eg=;
        b=N8kC93CdaFugXnELdkLEfyA2xJBTtggCeLFRQ7TTXauMeytTbd8i5cT5B7r41NtGQf
         lBbtw20XZgOuZnYFmjwC8Q+KhcnnEhCRZUqzQSbaNlQuqBgH7aZEtcfc/r7SFtDAobIC
         SkAMh2F8bUBWfvdp5UG7jAhA40aDKSuqHDpF6onjqIRzFRr7pbM7dL8T//pujkoxHS5A
         LKB4A0fPeT5Tjhzwyg58mH1raMADyvOqOYfXKwKDtXPJSdX4lonMSY4+h3IlN9xohIfI
         EexTkpizyA0PQC9myt6cgRdQbRHmwhY4XjrpMUd/WtkYkIhFFjIipAge2TonaV3Sf6Cf
         PwJQ==
X-Gm-Message-State: APjAAAXg3vj/sQQj+2HHahe6PlrpQZHLGAGwGolofs9zgmKcnkOQlcdZ
        CoH3hqdWj2pi9EEXVtibczZabw==
X-Google-Smtp-Source: APXvYqyGe5MD+6NthrTzl1Hid/T1mppKva2Udga73zOV27jgXHyohSgMvj7vtb4PXFlCBe1ZYmmFDg==
X-Received: by 2002:a05:620a:746:: with SMTP id i6mr4013364qki.104.1565286619814;
        Thu, 08 Aug 2019 10:50:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r205sm46813454qke.115.2019.08.08.10.50.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:50:19 -0700 (PDT)
Date:   Thu, 8 Aug 2019 10:49:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v3,1/4] tools: bpftool: add net attach command to attach XDP
 on interface
Message-ID: <20190808104948.7e72dea0@cakuba.netronome.com>
In-Reply-To: <CAEKGpzj1VKWuWioEmRkNXrgfDdT-KkWZWsrbY+p=yyK8sPctwg@mail.gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
        <20190807022509.4214-2-danieltimlee@gmail.com>
        <20190807134208.6601fad2@cakuba.netronome.com>
        <CAEKGpzj1VKWuWioEmRkNXrgfDdT-KkWZWsrbY+p=yyK8sPctwg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019 07:15:22 +0900, Daniel T. Lee wrote:
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     NEXT_ARG();  
> >
> > nit: the new line should be before NEXT_ARG(), IOV NEXT_ARG() belongs
> > to the code which consumed the argument
> >  
> 
> I'm not sure I'm following.
> Are you saying that, at here the newline shouldn't be necessary?

I mean this is better:

	if (!is_prefix(*argv, "bla-bla"))
		return -EINVAL;
	NEXT_ARG();

	if (!is_prefix(*argv, "bla-bla"))
		return -EINVAL;
	NEXT_ARG();

Than this:

	if (!is_prefix(*argv, "bla-bla"))
		return -EINVAL;

	NEXT_ARG();
	if (!is_prefix(*argv, "bla-bla"))
		return -EINVAL;

	NEXT_ARG();

Because the NEXT_ARG() "belongs" to the code that "consumed" the option.

So instead of this:

     attach_type = parse_attach_type(*argv);
     if (attach_type == max_net_attach_type) {
             p_err("invalid net attach/detach type");  
             return -EINVAL;
     }

     NEXT_ARG();  
     progfd = prog_parse_fd(&argc, &argv);
     if (progfd < 0)
             return -EINVAL;

This seems more logical to me:

     attach_type = parse_attach_type(*argv);
     if (attach_type == max_net_attach_type) {
             p_err("invalid net attach/detach type");  
             return -EINVAL;
     }
     NEXT_ARG();  

     progfd = prog_parse_fd(&argc, &argv);
     if (progfd < 0)
             return -EINVAL;
