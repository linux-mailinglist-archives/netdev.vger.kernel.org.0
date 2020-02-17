Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE52161196
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgBQMFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:05:35 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34319 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729144AbgBQMFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:05:34 -0500
Received: by mail-pg1-f193.google.com with SMTP id j4so9034463pgi.1;
        Mon, 17 Feb 2020 04:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E4kMIrPNCiyRmgWZhxYZuFBKw4V0voF4y3zqsgP+Bx8=;
        b=AjudUUl8bP457vmLEn8jzTV/8BjAFYLhRqQXTc79xuDnZY1eo3TRrvzB2YGEMbvLT7
         UIv4Hhl2OEVYIfYUWECPHSVBKs2rkqRl+v8qd0QPTlEUYCoMxs3BZXaCCV7htJir9cSY
         P/kY0eSDVSH+iALQRmfCw3WMbZMGTo4mQC9tEB8sy7rhWRG3A+4265uZVtAFCkzD21Ah
         9Aoi5xP2qvwE4XSzkGgH1fn6TcBfVX2C/aBtOVd7eDyB9rObsZM2boT3jLVEgvXN/Nbq
         DIo9gfPWLL/Yh5BE6QnzQL4WTrwlJ/DOUhRyBuVqHwTaWEiDf9CJ4PA1Bug15bVIDudS
         pCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E4kMIrPNCiyRmgWZhxYZuFBKw4V0voF4y3zqsgP+Bx8=;
        b=a2uglcqfdm/eigt+XRKtLz7M5tWe5RfHlKci6SQr4zEXEwC4uAkMLj68yAtP1psmGS
         /2ypQWu8W5X1q41EmxwZZRrgLyxkuoC3IteQ0yvZx7Wslw/sbwgc3q7JHWj8AIGBIoMG
         AGDA5c0F976GowPxrKZCX3VGU/TorpJuL2fcJph05ZdfaczMVTWbu8VyYB+AeHrYbBvQ
         vn+DAhdpt4rTJiLTVcxdkvyvDOOqGAgMRZ6pa62kmspDlQGsKGi0sqtHEEi6+mWNbWwg
         5GtTX5UUFnyeUmJ1hJrOK2WkUNsDhkBK1FJHk0RZGDHILch3CaLL1/eEm04/JTYIMkXn
         6HOQ==
X-Gm-Message-State: APjAAAW4/HO/39eJZkAOd7qo3WkSvUau8Du6ubmdmXfidXfqHGCEdTJA
        QKJO/2cVgCBwWLwQtKN39g==
X-Google-Smtp-Source: APXvYqyDFaAFJ2xtas+m18JCGS6zRjMUeJs00Ho6bHth9PbfxctixNvC0pC7ga6HGg9pYbnN4j/oyA==
X-Received: by 2002:a17:90a:bc41:: with SMTP id t1mr19422318pjv.137.1581941134218;
        Mon, 17 Feb 2020 04:05:34 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:1ee0:fe92:14b2:4950:fe83:57e])
        by smtp.gmail.com with ESMTPSA id d2sm377070pjv.18.2020.02.17.04.05.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Feb 2020 04:05:33 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Mon, 17 Feb 2020 17:35:25 +0530
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        davem@davemloft.net, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: batman-adv: Use built-in RCU list checking
Message-ID: <20200217120524.GA12888@madhuparna-HP-Notebook>
References: <20200216144718.2841-1-madhuparnabhowmik10@gmail.com>
 <1634394.jP7ydfi60B@sven-edge>
 <20200216155243.GB4542@madhuparna-HP-Notebook>
 <14125758.fD4hS3u3Vl@sven-edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14125758.fD4hS3u3Vl@sven-edge>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 05:17:36PM +0100, Sven Eckelmann wrote:
> On Sunday, 16 February 2020 16:52:44 CET Madhuparna Bhowmik wrote:
> [...]
> > > I understand this part. I was asking how you've identified them. Did you use 
> > > any tool for that? coccinelle, sparse, ...
> > 
> > Not really, I did it manually by inspecting each occurence.
> 
> In that case, I don't understand why you didn't convert the occurrences from 
> hlist_for_each_entry_rcu to hlist_for_each_entry [1]. Because a manual
> inspection should have noticed that there will always be the lock around
> these ones.
>
Hi Sven,
I have been working on similar issues (passing cond argument to
list_for_each_entry_Rcu()). That's why may be I didn't notice that in
this case rcu variant is not required.
Thank you for taking a closer look and fixing it the right way.

Regards,
Madhuparna

> KInd regards,
> 	Sven
> 
> [1] https://www.kernel.org/doc/html/v5.6-rc1/RCU/whatisRCU.html#analogy-with-reader-writer-locking


