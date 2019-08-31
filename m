Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB6A457F
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 19:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfHaRHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 13:07:41 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44855 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfHaRHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 13:07:41 -0400
Received: by mail-ed1-f66.google.com with SMTP id a21so11559656edt.11;
        Sat, 31 Aug 2019 10:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lik2TQFtm24ZeMK7lbOS3RM+iMDhKtG/DlU1Hn/vZvk=;
        b=IzJRNCSwoQaaawnqH5JdQhmrYzO19Ll6eYto0R1OjvO+dLU0rqEfq9SHnOBHM4ZJmd
         PZVOH6es77IXwL9eQS9AS45/VuyjnKGEcSuFCpbTWMU8OqPgXZSrUdAN0ze+MSfUGe4h
         UD8jfnSbkTUK+oALMnqQff0HvXr9w5bYf0Q4aBZH4x6D+BojR3LeEtdPFbQphnskvAPR
         RFjb49+o+9L+N1BF6gyKlTMlODxDbg77UnIEdTQnUwbFJWTp1jkHJZG1h49eX8qgICpJ
         Lnk+zEtSzCNjLeOlun606LVo6Zj4C/hyVR096kFtvgw5ptdfD+ph+r2roCxu+wTA4qLE
         IQ4A==
X-Gm-Message-State: APjAAAWnzPTprPpd4yAextydYr/KFliZwBLSAjicJFr7z5c+QVebLtpV
        W5aUKwVNipYyFRQKWJQSdsE=
X-Google-Smtp-Source: APXvYqwYiVn+T/jnXqHdTksQFpnl6eq02sfkOXYISHWm5GobK2D0xg22AxYic/zL89Sp0zVPu8fsxw==
X-Received: by 2002:a50:88c5:: with SMTP id d63mr21674654edd.122.1567271258673;
        Sat, 31 Aug 2019 10:07:38 -0700 (PDT)
Received: from [10.68.32.192] (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.gmail.com with ESMTPSA id i23sm1739594edv.11.2019.08.31.10.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2019 10:07:38 -0700 (PDT)
Subject: Re: [PATCH v3 01/11] checkpatch: check for nested (un)?likely() calls
To:     Markus Elfring <Markus.Elfring@web.de>,
        Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Andy Whitcroft <apw@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        linux-wimax@intel.com, linux-xfs@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        netdev@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sean Paul <sean@poorly.run>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        xen-devel@lists.xenproject.org, Enrico Weigelt <lkml@metux.net>
References: <20190829165025.15750-1-efremov@linux.com>
 <0d9345ed-f16a-de0b-6125-1f663765eb46@web.de>
 <689c8baf-2298-f086-3461-5cd1cdd191c6@linux.com>
 <493a7377-2de9-1d44-cd8f-c658793d15db@web.de>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <c5e4479d-2fb3-b5a5-00c3-b06e5177d869@linux.com>
Date:   Sat, 31 Aug 2019 20:07:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <493a7377-2de9-1d44-cd8f-c658793d15db@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31.08.2019 19:45, Markus Elfring wrote:
>>>> +# nested likely/unlikely calls
>>>> +        if ($line =~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
>>>> +            WARN("LIKELY_MISUSE",
>>>
>>> How do you think about to use the specification “(?:IS_ERR(?:_(?:OR_NULL|VALUE))?|WARN)”
>>> in this regular expression?
> …
>>    IS_ERR
>>    (?:_ <- Another atomic group just to show that '_' is a common prefix?
> 
> Yes. - I hope that this specification detail can help a bit.

I'm not sure that another pair of brackets for a single char worth it.

>>            Usually, Perl interpreter is very good at optimizing such things.

The interpreter optimizes it internally:
echo 'IS_ERR_OR_NULL' | perl -Mre=debug -ne '/IS_ERR(?:_OR_NULL|_VALUE)?/ && print'
Compiling REx "IS_ERR(?:_OR_NULL|_VALUE)?"
Final program:
   1: EXACT <IS_ERR> (4)
   4: CURLYX[0]{0,1} (16)
   6:   EXACT <_> (8)      <-- common prefix
   8:   TRIE-EXACT[OV] (15)
        <OR_NULL> 
        <VALUE>
...
> 
> Would you like to help this software component by omitting a pair of
> non-capturing parentheses at the beginning?
> 
> \b(?:un)?likely\s*

This pair of brackets is required to match "unlikely" and it's
optional in order to match "likely".

Regards,
Denis
