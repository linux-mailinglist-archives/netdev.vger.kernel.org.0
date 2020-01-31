Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B011414F02D
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAaPxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:53:53 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:42744 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgAaPxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:53:52 -0500
Received: by mail-pg1-f178.google.com with SMTP id s64so3662015pgb.9
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 07:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pFoOX7gjiGZf03jGzjZNslrPlz38fgNxlv/hKmkxGUk=;
        b=MSXsT7Lg/0lPfvsj4jQU++irwgUtcvnLiwvcOcaxJG60J9x3nOh47coDaGMVVK44EZ
         krwNS4n2gA7Uf+AUc7+6pZK3RDUlUre3mGw8yK6Dh2TIaJnKmLb1nQ8bnDRKrHpbl+Qp
         TM/L0+L2QG34od4RmMSyf1rpgUrsthsj0aK2u6u4u6Ow3/qkBmLmE7hi/GlaecQv0lvX
         UpxG37/WS2ATWplkyGAcfT7Fg5G5g/6/m/VDGnz8J9qw7m+GHa9wZT3HW/AQZq2fQMVs
         6pdu+pYz+puJ3F6Y2mObs1HUNT0KNfcJDyKZ6CIk2Cb4Po48q1FAiYrf/2DGPGvgzUgS
         K0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pFoOX7gjiGZf03jGzjZNslrPlz38fgNxlv/hKmkxGUk=;
        b=gA+WnjkjbvD6uLsIDUVwoL/ADTiOFHkOniIoQ0feEAgxQF5yt67QXvJvZJtS7ppnl/
         Ro6VQ33nLbDKQRayVhOOPTvhzHXAmOcmuI061mb6AyAsQMP0wwtyMDAloGq1Fn/1mbEc
         tWh2Pbf9YS4wkwYrlji2vX+ff0rRRWY/NEfz3bAuiYlK/yI7a+w9rC1ZetFAB7/MvN5i
         ydBnLs3WAQh1YWeAl5+957qUiEtlv5C7Vdof+zx92//cbJGERMp7onkEiFA57NnPHQRQ
         HPW9GoaRHmT3xclgHW2w9n01OFVT9TlvniLMNO+uKos9CPflMv+Jvs2Xp9PaLmcagqze
         K8Ww==
X-Gm-Message-State: APjAAAWaq5EKFDmwRc2fHfBqqr3A/cztauPqW82zkozn7gRSEwCOaiMv
        stGruBUCt6+WZHqxLCeoH903OB0j
X-Google-Smtp-Source: APXvYqz9Oc0VC0pz2+1SYteDwn9EdEE9I+oeF6ZuL8qZvwawS36bOBNqV3ePcKEQez50Au9WVonUzg==
X-Received: by 2002:a63:5b59:: with SMTP id l25mr11404214pgm.382.1580486030661;
        Fri, 31 Jan 2020 07:53:50 -0800 (PST)
Received: from [192.168.84.170] (207.sub-166-167-102.myvzw.com. [166.167.102.207])
        by smtp.gmail.com with ESMTPSA id z19sm10879106pfn.49.2020.01.31.07.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:53:49 -0800 (PST)
Subject: Re: Freeing 'temporary' IPv4 route table entries.
To:     David Laight <David.Laight@ACULAB.COM>,
        netdev <netdev@vger.kernel.org>
References: <bee231ddc34142d2a96bfdc9a6a2f57c@AcuMS.aculab.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3cfcd1b7-96e4-a5b6-21e7-8182a367f349@gmail.com>
Date:   Fri, 31 Jan 2020 07:53:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bee231ddc34142d2a96bfdc9a6a2f57c@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/20 2:26 AM, David Laight wrote:
> If I call sendmsg() on a raw socket (or probably
> an unconnected UDP one) rt_dst_alloc() is called
> in the bowels of ip_route_output_flow() to hold
> the remote address.
> 
> Much later __dev_queue_xmit() calls dst_release()
> to delete the 'dst' referenced from the skb.
> 
> Prior to f8864972 it did just that.
> Afterwards the actual delete is 'laundered' through the
> rcu callbacks.
> This is probably ok for dst that are actually attached
> to sockets or tunnels (which aren't freed very often).
> But it leads to horrid long rcu callback sequences
> when a lot of messages are sent.
> (A sample of 1 gave nearly 100 deletes in one go.)
> There is also the additional cost of deferring the free
> (and the extra retpoline etc).
> 
> ISTM that the dst_alloc() done during a send should
> set a flag so that the 'dst' can be immediately
> freed since it is known that no one can be picking up
> a reference as it is being freed.
> 
> Thoughts?
> 

I thought these routes were cached in per-cpu caches.

At least for UDP I do not see rcu callbacks being queueed.

