Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A982F224196
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgGQRPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgGQRPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:15:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A35C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:15:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j20so5723426pfe.5
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S5C1kGzcRMh5s/xY35azbfaECu6ziYdmjWrDYnFfJwo=;
        b=O3U9cXdhHUGlStVnak0/NAZMRb2ktBQVCGkUKQpZK+CvTlV0dHTZ2devvh1Ckwie8a
         78dPQ8dMBho4ThvDyK7I5Ipqz5GTIcOzB3yp1u7cyYjWbqM3wPSnU/197PJYnz8CMHrf
         gaEsnu8SzPBrY8Syh9dkwlYsvL16rLoBN9P96aSv5cc2oE3mATK++CrDXygbfMbT2hVf
         Lf0GdXh7QnS6WWHqz6GUgAsa/1ylTnSBW1fs2ydRokEPJuW1sx0iwlAYMGvVO/MTo2ae
         XrCaVJjy1l8OSbLlzc//UBrNu5dkUAvWFdz7IEvVhsMULRQziBh5n7c0vHqGwd/ups59
         paqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S5C1kGzcRMh5s/xY35azbfaECu6ziYdmjWrDYnFfJwo=;
        b=ud3dw823NxEbUhpWv/jAtQflqOv8tSrDJAHvp8jfJu6frbhmDthV1SYIEc6MYO7cCd
         nYHpujQIPSTRGq18F46zGL6EZO9mV7AtOKRgtGZsa3/s+PWcIl1PZ5SMPeds6CzpeJfM
         4nCVj4qiU0mA3JMY8QJ60BZenesSQcrG7WTAUReh+MOZr/eh5ksxUtwtwkKGGrLpwrMz
         NZl7HJNH8rPqDjwq9WCbgrhAh1ZgIzqaz6cVJnozHjWvEa+eSVvHfpTl5BETv2Cec8sr
         o2wTBf8wTsR82FO5QPEKZhyOYo+XLhS0q5433ksK3ltCRuuSEMTqbM9V3ckjhcX3zzfK
         1RQQ==
X-Gm-Message-State: AOAM532Q+0opC48xBFGwqdw5hnw1YjXzaFMT/VmqObfphWq2IuNeEXTY
        7MJql2mb15P5uMIb3urXzqzq/A==
X-Google-Smtp-Source: ABdhPJyvFL0kYbKEv0lMOW8F4w+Qc9Y8qj8kBRC1EnjD51+LqQyMvBntqEKUB+MgAxFyS0wTKc/IEw==
X-Received: by 2002:aa7:84d3:: with SMTP id x19mr9208993pfn.155.1595006131819;
        Fri, 17 Jul 2020 10:15:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id nk22sm3297605pjb.51.2020.07.17.10.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 10:15:31 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:15:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     haiyangz@microsoft.com, Song.Chi@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Message-ID: <20200717101523.6573061b@hermes.lan>
In-Reply-To: <20200717.095535.195550343235350259.davem@davemloft.net>
References: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
        <20200717082451.00c59b42@hermes.lan>
        <DM5PR2101MB09344BA75F08EC926E31E040CA7C0@DM5PR2101MB0934.namprd21.prod.outlook.com>
        <20200717.095535.195550343235350259.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 09:55:35 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri, 17 Jul 2020 16:18:11 +0000
> 
> > Also in some minimal installation, "ethtool" may not always be
> > installed.  
> 
> This is never an argument against using the most well suited API for
> exporting information to the user.
> 
> You can write "minimal" tools that just perform the ethtool netlink
> operations you require for information retrieval, you don't have to
> have the ethtool utility installed.

Would it be better in the long term to make the transmit indirection
table available under the new rt_netlink based API's for ethtool?

I can imagine that other hardware or hypervisors might have the
same kind of transmit mapping.

Alternatively, the hyperv network driver could integrate/replace the
indirection table with something based on current receive flow steering.
