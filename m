Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B263323A985
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHCPiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCPiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:38:16 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6C7C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:38:16 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id s16so28500619qtn.7
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=usSuKDh9W7pyP4uV3ROiWHM3D2Kg18yxfsjU6L+t0vc=;
        b=Q9TpiX9SKUpmwfxt26DMuL8cg6IoIcsTjPmZTJOVXnuBeLmDlmQsaKCj92++XQVTuP
         A9dPedP7iZbfMv3Vuu9B6321oE1ns0x5CI/eqUD/3vnb4TnlqKWm3zCMk/ffx/GkttzR
         5BSK3ORZ6ux4wbiZLxW3FVPD9eoZsO5no8GWz609dXwGTjdUJ4M59iFZ8EZ3FQds8Btt
         yqnfsKPc1k1HRw21Mq9SprrIjMUn7F2hNSBMNNcSOD98dwfxO5XbmgH3Jx+yPfiIWp11
         ot9yJJvvnWH1LFkvd6RTEjsRXEDAZjFQjXzqow7YYEsaXFDRjinO+aTKq2C6Ub/wGGJd
         on6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=usSuKDh9W7pyP4uV3ROiWHM3D2Kg18yxfsjU6L+t0vc=;
        b=XcgLnFce5ADWpN/y8xEs6srrfnIFzBEo4oiy+tu/eI2tBU4fzkBSjlGyj+VJdBnnZN
         KsauECaxX82ePNjeqbFbgcv0sRr7xBBb5WYMGKh26MTHMWtkmcVHu0AGLRLLXmqVfvtF
         mXTvvvdBd+Fi1b524WFVA0AcYM8/vUerKEMQddHYqnKS/nGuB8CSp12EcokD0G88CGQ+
         1usjnl/bYIYjY+2FqvPhr/kdhoq8zmH7SoakXwRMS/LZhlN4l7wpYoscjidgFuZ5rArC
         ERfMu81aG5LW27hiBHVUNiMViKF4SXIg2JM+C3D1XQK+cKA2bBwDkJoa0YKgZ2xZPLOm
         xnew==
X-Gm-Message-State: AOAM531UhydNyqlnlOGCcfYhy2BzuLu64/3mrBoGR+DrWAkRkIRU8WvN
        bn2U+Rsx6TtpVs0IIapN2444PRkU
X-Google-Smtp-Source: ABdhPJyR/r2wJnU8hLTdy2HjM4omPX9DUbTVBOIMRsF8jDCipGRMRUwBCKtIJJ/9EBW0ydbl6aBjqw==
X-Received: by 2002:ac8:548b:: with SMTP id h11mr17187208qtq.209.1596469095556;
        Mon, 03 Aug 2020 08:38:15 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:989f:23de:f9a0:6da? ([2601:284:8202:10b0:989f:23de:f9a0:6da])
        by smtp.googlemail.com with ESMTPSA id c33sm22602822qtk.40.2020.08.03.08.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 08:38:15 -0700 (PDT)
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     mastertheknife <mastertheknife@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
 <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b4ebdb3-8840-810a-0d5e-74e2cf7693bf@gmail.com>
Date:   Mon, 3 Aug 2020 09:38:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 8:24 AM, mastertheknife wrote:
> Hi David,
> 
> In this case, both paths are in the same layer2 network, there is no
> symmetric multi-path routing.
> If original message takes path 1, ICMP response will come from path 1
> If original message takes path 2, ICMP response will come from path 2
> Also, It works fine outside of LXC.
> 
> 

I'll take a look when I get some time; most likely end of the week.
