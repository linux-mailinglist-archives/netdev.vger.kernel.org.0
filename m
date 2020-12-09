Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5932D45A1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgLIPly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgLIPlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:41:49 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EF2C0613CF;
        Wed,  9 Dec 2020 07:41:09 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id f8so481999oou.0;
        Wed, 09 Dec 2020 07:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JKPWvTeOUAWWeTIgOEQ1k8P3eL2U5OpItcuMAQW7INo=;
        b=Hj1UiESjeBP5AmevOGTf6A/W9xJJvcS3eDm6cx5dIVkGB8z9kyiJU9VEWE62VFfK7l
         vi5RDj6WXNGqyogY0y/J23YIc9PVB+X/RLLaJsH4hgFHGmtGTcj838loYr7v45jPADEM
         c8pGvqNrHlcFVoS3KArXTLKNlihTDX8l3gtgkTN46MG2BnpFrAqK0oCeKwcEUKgBin8i
         Q/l7aeUKq4r6Cyh8RwFekPmwVh731B3bk5b7wYpETBZW5Yfy8qYasFeIpuj4hPOdnvJy
         udHwy3wRrb8ER4U6/yVFZTzkjTPA1vceeNB6oU60zxlcCA+2H3je1A4AF4ACJzA6XEo1
         lBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JKPWvTeOUAWWeTIgOEQ1k8P3eL2U5OpItcuMAQW7INo=;
        b=QWlaqjQvabw2GkcFhnSLDbiVtwAxYCk8vKo6Sg7tXN832KX9M1TenNvW/c8YDaImvc
         ELMjXSR0VZDB+hKynIRmc0EiXPMY1ZuJ1WxSFv5XcH4GKNiNqnRPY2Sj1p3bbAKiTBQg
         IfV5FgPEaXadCjxjrLT+RnqcsyjfmDB82YLmkExG7X7nTpU6S8McBCoVn5/X003r2j3Z
         Zoms/rzc9f+U8zlDOMzhBChIEkXVkRWeCRXxge+yTbl50U9iafU5wWbed22f2Gdj4aTp
         Gdu80xLn56kICFRbD5LDSioBf6KregqxiYdH+1sVVpxk8477T/FzN36iv2lVuzY0fK1I
         n2XA==
X-Gm-Message-State: AOAM533SIvdx1yYGPj6LeOAicXht0fAUbqrDD8Efp+nA+1ggVob0Xvj2
        1smhmkRnLW61YhUGgsGOOBU=
X-Google-Smtp-Source: ABdhPJyK21rORfCNf9dRwuUVrVhlTAdISKYwMWBuQTlPCNLLU+QgFl/G7zg79dKi4UhOwnu0HK/6fw==
X-Received: by 2002:a4a:9563:: with SMTP id n32mr2334087ooi.53.1607528468662;
        Wed, 09 Dec 2020 07:41:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id r25sm454194otp.23.2020.12.09.07.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 07:41:07 -0800 (PST)
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com>
 <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
 <20201209095454.GA36812@ranger.igk.intel.com>
 <20201209125223.49096d50@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
Date:   Wed, 9 Dec 2020 08:41:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209125223.49096d50@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 4:52 AM, Jesper Dangaard Brouer wrote:
>>> still load and either share queues across multiple cores or restirct
>>> down to a subset of CPUs.  
>>
>> And that's the missing piece of logic, I suppose.
>>
>>> Do you need 192 cores for a 10gbps nic, probably not.  
>>
>> Let's hear from Jesper :p
> 
> LOL - of-cause you don't need 192 cores.  With XDP I will claim that
> you only need 2 cores (with high GHz) to forward 10gbps wirespeed small
> packets.

You don't need 192 for 10G on Rx. However, if you are using XDP_REDIRECT
from VM tap devices the next device (presumably the host NIC) does need
to be able to handle the redirect.

My personal experience with this one is mlx5/ConnectX4-LX with a limit
of 63 queues and a server with 96 logical cpus. If the vhost thread for
the tap device runs on a cpu that does not have an XDP TX Queue, the
packet is dropped. This is a really bizarre case to debug as some
packets go out fine while others are dropped.
