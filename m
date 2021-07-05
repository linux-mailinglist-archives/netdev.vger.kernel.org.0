Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E589F3BC240
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 19:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhGER2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGER2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 13:28:02 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B85EC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 10:25:24 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q190so17604130qkd.2
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=stGKzx5MqRwRk+9Us9nYzahGLFsprjaqOct4Iq0rayM=;
        b=QzS8BuFHids4m0qR0o2LCp+vkuC0qXEEupsyz8juz7zW36fhBJ2YaYpSTj0NuTvTIc
         eoiGkFVgPEgTkSfkC8nxKM6jo9KLdOYJBiIYlFemp7f/7lEwchJ2X0Kxv94p+2mhp08Q
         7NkKitTXTwMezaBIvhE5WTaNCCjpnWwKmA60AJan3F6DAGbt5Q/9Ly7NVRcUjjSPWGLk
         KZxd+Muo7B07MNSExgsAyiOfzZlhrl+aPGfD8yeALxmhYrCXZ/XSBlOjWhaFpG5Gk8VJ
         +Te87hpzPka3bkNlpnn0cVuPJ35Gox1tbeRiJcZHH4j4KpKB9SVDQjjX/d82ePxh/IGz
         RQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=stGKzx5MqRwRk+9Us9nYzahGLFsprjaqOct4Iq0rayM=;
        b=muzyi39dbVjh++fiMotr4/iXmd8nC5rAdGTJ5avkscw/EeYar9Duryp2Yxqda3xLIA
         1uLgowOzQdmoCJR59o0uVuR3npQerb6XxX3sFIjJ3RUEQxOD+T6OBKbZCmbuc88Z56C9
         aFJWhXFjxCMDhPNEcpamBWtwH/MKkIcdSCc3ud/v6YhmwazMZxh942YlH5LsL3DMXclh
         uVhpIihaka88BlGMksRQ1YxCZoxikZWJugdIVSfbQQ4/ckVmYEYt2jjPIsjASb41HnK5
         SI111yDjMHHdrVsWPSd6a1ehLXGF2LHRhU+8ZF8cQlfU1TX5623dHl0Kq/z9FMFfyo2k
         rDKQ==
X-Gm-Message-State: AOAM5301QL1lgptHDIakR/7fQbN3m7is38+5oKYVAskIwhVEw/yPbaIm
        jaDufxJWkQAoEMSIUMN8Xz4ZXrdQSVaHso0Y
X-Google-Smtp-Source: ABdhPJxMF15Is6+HEkJJOtUMoAmxWLAblrZIcIAX3IByUQtDIQrsSI2Ft1/no4iiy9Km9XKF2lrxxw==
X-Received: by 2002:a37:7046:: with SMTP id l67mr15221488qkc.69.1625505923105;
        Mon, 05 Jul 2021 10:25:23 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id f1sm5651170qkh.75.2021.07.05.10.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 10:25:22 -0700 (PDT)
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <20210705141740.GI3673@orbyte.nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <12ac420d-1b04-9338-03bf-b18ce2d71dcf@mojatatu.com>
Date:   Mon, 5 Jul 2021 13:25:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705141740.GI3673@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-05 10:17 a.m., Phil Sutter wrote:
> Hi,
> 
> On Tue, Feb 02, 2021 at 07:30:51PM +0100, Phil Sutter wrote:
>> In between Linux kernel 2.4 and 2.6, key folding for hash tables changed
>> in kernel space. When iproute2 dropped support for the older algorithm,
>> the wrong code was removed and kernel 2.4 folding method remained in
>> place. To get things functional for recent kernels again, restoring the
>> old code alone was not sufficient - additional byteorder fixes were
>> needed.
>>
>> While being at it, make use of ffs() and thereby align the code with how
>> kernel determines the shift width.
>>
>> Fixes: 267480f55383c ("Backout the 2.4 utsname hash patch.")
>> Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Seems this patch fell off the table? Or was there an objection I missed?
> 

None i am aware of. I did ACK the patch.

cheers,
jamal
