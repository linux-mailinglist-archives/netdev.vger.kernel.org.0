Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158E51339D3
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 04:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgAHDya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 22:54:30 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44173 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgAHDya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 22:54:30 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so1651893iof.11;
        Tue, 07 Jan 2020 19:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=PA2NXViCpuZd13BKIQ60jNtIF1Z4TVH/UHFfmG1BJeg=;
        b=VEU5dl4eSKlyqmE+Ajd1zho06cUgGSbIsAL4CiLtlSTCh6BU3QMAKEtD717gaOhQ4J
         01zIAWKPLvE+vXkxefefJvG3fovRP34yjN69JoodODrJRlyTSuxEmsIrMQymu6Q0/BjD
         DBBv6Teizx881mJCTNg7+wMMYCPMfCCLlr8tPqQPnIcChzBuCrA5RTVngWeVFpLaCvid
         m86gw4QxOwa98j/1ryYSuHrkbwbN/tM7kyEyFQ6XFMM6U3SR4FgxVbMzyb2KCq/DczzS
         35mq+0IOyUmxW2dS/jObS67t38C9oaGR0/xR4hYrOzy+FLTr8/7JwoGhG3qFrklrPpcf
         jsXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=PA2NXViCpuZd13BKIQ60jNtIF1Z4TVH/UHFfmG1BJeg=;
        b=PDWe9tVsgf7+5igx5A8FhyTU3tyEBmgTlNBsDatnBc8t35Z/TChjtyk/Shjhj4+fbn
         LuZ2ih3GQl+8Q+Cc8/BbrRWqs5GrJVw/x7OlluuCwwatpVXdzVodtTxuemGYz7uuxB9L
         +bNO3rY9DnbA9gG7pvwnp3PlJIlsw+9RMZQvbGf2DreMZ8FA3kjG+Xl1DzfgnbiTzA+u
         z77kgBfy8l57NHsPTQQy4E9hUuw1KSc2Ifj5aCMWwbf4pN3YihEf7+wu5oTqc+eu1R/E
         Fcehz25sVXJVfBzsiHpSJh24lT0YDn4zpmk2DNz7XwfQU5J5QN5ex+NBU+aYdlDD6fRx
         TnVQ==
X-Gm-Message-State: APjAAAVGjyY9UFxvKbOSSnIbdCgfqkz6EhwoaxnZM84Hj3N/Hcq7twKs
        cpTnj4JacZoEsq9iZCWDQjI=
X-Google-Smtp-Source: APXvYqw2+UeKJUViHKAcarA/oRX814m+hGNCWAMCjiwXczYrYN13tQex7j+mU5WVzqWiRUrSSLc+vA==
X-Received: by 2002:a6b:dd02:: with SMTP id f2mr1781221ioc.304.1578455669208;
        Tue, 07 Jan 2020 19:54:29 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u80sm528157ili.77.2020.01.07.19.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 19:54:28 -0800 (PST)
Date:   Tue, 07 Jan 2020 19:54:21 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Forrest Chen <forrest0579@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
In-Reply-To: <CAH+Qyb+37gaWZzEvvXeX9ghsCYw1JyH_23S+1HW0ML-MZkcYfg@mail.gmail.com>
References: <20200107042247.16614-1-forrest0579@gmail.com>
 <5e14a5fe53ac8_67962afd051fc5c0ea@john-XPS-13-9370.notmuch>
 <CAH+Qyb+37gaWZzEvvXeX9ghsCYw1JyH_23S+1HW0ML-MZkcYfg@mail.gmail.com>
Subject: Re: [PATCH] bpf/sockmap: read psock ingress_msg before
 sk_receive_queue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forrest Chen wrote:
> Thanks John for the review.

Usually try not to top post.

> 
> I think you are right for the missing part. I would like to update the
> patch and re-send it, is it ok for you?

Yep glad to have more folks looking over sockmap code and looks like it
already hit the list so that is good.

> 
> Since it is my first kernel patch, I'm not familiar with the process.
> What''s the meaning of 'add your Signed-off-by'?
> I think I have add  Signed-off-by in the first patch, do you mean I should
> add 'Signed-off-by: John Fastabend <john.fastabend@gmail.com>' as well?
> 

I was just saying feel free to add _your_ Signed-off-by to the patch I
attached and send it. You added my signed-off-by to your patch which is
also fine I don't think it matters much as long as we get the fix.

Also we should add Fixes tag and a tag to give Arika some credit. Seems
we had the same fix in mind. I'll just add those now, next time for
fixes please add a Fixes tag so we can track where we need to backport
the fix.

Thanks for looking into this.
