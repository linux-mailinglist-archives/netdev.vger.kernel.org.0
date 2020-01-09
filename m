Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C43113626B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgAIVZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:25:43 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36655 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgAIVZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 16:25:43 -0500
Received: by mail-io1-f67.google.com with SMTP id d15so8807000iog.3;
        Thu, 09 Jan 2020 13:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AuCVOpJkuZYE65RYLpf1B4iFvHjGfRQouDs+XczOndo=;
        b=p64eofYK9oeCPFw8Zo1/iEf2/4l1dCaGTq73L+5EpPn0fZK4PM/bzOqdiyrieA3NF1
         PsLWKLMpIsCAgSfzy7oCqWz3R5WHGrNQ30yfo4uwO4Ds6GhU9lACB0W7Oex39GjuUPJ9
         nY8cFJBgl8NOd/ng0BnBsx2P4J5OaXrAq5OcBfBsp9wo0FuYFbjytJFfjctmlN+382cc
         NjZtQ9D4krYQsfAmE6ePS2hNsq6npBDXVeqQPa+Hi5xaLiyP5092XdgWV9SFgjS+kE+I
         sU3e0/GoX0EvDhtoXzGOVxypF2E2YDf8fsv5FoMnmSkSNM7qPZqcQoVQId+WyKYNzYWd
         vy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AuCVOpJkuZYE65RYLpf1B4iFvHjGfRQouDs+XczOndo=;
        b=qrUN8rCGDkt95O+VrtjeyEkdu6Z2ys92fAmuUPu1uvyKgSNvAktqfc68TVYS3mMuan
         eF7iMsS5MMotGldxUaDuME86z2DCv4OEIMQre5UGiFUoA1Mks/+eqIrLIlTOEXNP/3/p
         UIm4HlFCUF5FE7flxOyioFECrePJKr9TxWBOrZDFnFqr7F3LxojzW77KX+kUVUlWFVVL
         i/csJk6U889txRpIdtxQCG88iOMdF26w2eiFfbzLo7jJGB8OwJWSpT6mF8+LqvnfYeCY
         Q+PoxsSQg95HzsLLjtoGOQJVCNdhE5y3tJuEGnmtKmk+9s37aLHMiye9ZS/YN90Vbvut
         AkVw==
X-Gm-Message-State: APjAAAUuSsfX/kOR/8A0O42dWoIqawd48H0yZByrBPnu+WWtJ2zKOiJx
        04nFcJKIOTbEO01Hum8H7Tc=
X-Google-Smtp-Source: APXvYqxC12MAF27FGhFHFxwOJMwZeqbmfBs0U9vrTtY43nOyCc10QKpGBcY6i/DQr/WWgfS7NHmhAw==
X-Received: by 2002:a05:6602:cd:: with SMTP id z13mr9821376ioe.291.1578605142509;
        Thu, 09 Jan 2020 13:25:42 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g62sm16043ile.39.2020.01.09.13.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 13:25:42 -0800 (PST)
Date:   Thu, 09 Jan 2020 13:25:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5e179a4def787_28762abb601485c027@john-XPS-13-9370.notmuch>
In-Reply-To: <CAPhsuW774z68g_Y-C1XU70H-x6S2mr+Hd0-qY02E9aZBJjepkA@mail.gmail.com>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
 <157851817088.1732.14988301389495595092.stgit@ubuntu3-kvm2>
 <CAPhsuW774z68g_Y-C1XU70H-x6S2mr+Hd0-qY02E9aZBJjepkA@mail.gmail.com>
Subject: Re: [bpf PATCH 8/9] bpf: sockmap/tls, tls_push_record can not handle
 zero length skmsg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> On Wed, Jan 8, 2020 at 1:17 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > When passed a zero length skmsg tls_push_record() causes a NULL ptr
> > deref. To resolve for fixes do a simple length check at start of
> > routine.
> 
> Could you please include the stack dump for the NULL deref?
> 
> Thanks,
> Song

Sure I'll send a v2 with the stack dump.
