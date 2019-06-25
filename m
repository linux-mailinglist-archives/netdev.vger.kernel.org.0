Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29EA54CD3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfFYKzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:55:13 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:42709 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfFYKzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:55:12 -0400
Received: by mail-qt1-f172.google.com with SMTP id s15so17794980qtk.9
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 03:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UUtls/BlGmqeITSWqxOJG/wuLJnlYxTh3oSGZiiLpNY=;
        b=CdHoLQu5W9ufNr9QFF3TAJ/yK9+ISi7S8lYjlJh1Xmw66deYlFPX4+U1rJymqc0lWO
         UQZT/wTHKLkgwAyP7Rsqey22jKF1q0M9w2tCjeDWzVy2e4d7KA5Q9xLSC/40notLFRTV
         Wp3BzFfIW0492YzKSKhM/eIgz4FMuRCB/jykiEdRr2LTl7nmuoGvh2UByUBwcenCXRhs
         DmSiXvA1oklS0i02uRRgQUdiKrfoogZCNXBDz/XDaiLZrUS8FEv3DO6MbFLPMobmZ5Pd
         rVb/YpAihV+Ucm/IJ3NH7gpxgxxT6k8Xi/GMQVSdkRTShtU442KOEvMC8Qi+s5rrdyNH
         QO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UUtls/BlGmqeITSWqxOJG/wuLJnlYxTh3oSGZiiLpNY=;
        b=TzBxN7xzE3Le0ci1LEx35D14ql+a8KkED6gUmS23k8p+DOE+MTrZARPk0Zshs+b2gJ
         2WR+Lt9mJfFRXiXtnUcut7fJvWNpj1dSwLnWebMwx+ZynKwl/ZVC5PYkpWnuii9GvoKc
         ODC31eDFJ6cM2F7T2LsWTa8r4C593+8Rc1k57lOYImQblzOIegfBHWnMv18ZiZJCitDx
         X/XeEAWtQMpJLpaUXC0hg3bYnHDeGyVFgvt8Kur+lqc5ciogiFcx2jZMTRUkIjdjZKRL
         QZ6PgR6NjicTAaUHVyPBNMdx+Qqyt9ojiUE1KEQWYRtOwIPKzjJpoEbb2jAM9qhRT+H7
         xGrw==
X-Gm-Message-State: APjAAAXt1zY5pRpqUz4DyRvssc4R+Hzc1rJ72J5Raa0zr5F59QBmXvFK
        H6hDVshoHf9EiB4qyNYzp/eBdw==
X-Google-Smtp-Source: APXvYqxJc8Rc/hB9ygjNROBs1z5zaX2LwfJp3CVzhQ3Sr3r5/pHe3cgvMn0265cJlvg/omiev6PJGw==
X-Received: by 2002:ac8:5298:: with SMTP id s24mr121586240qtn.303.1561460111809;
        Tue, 25 Jun 2019 03:55:11 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id s11sm8003938qte.49.2019.06.25.03.55.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 03:55:11 -0700 (PDT)
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Joe Stringer <joe@wand.net.nz>, Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
 <d2692f14-6ac7-1335-3359-d397fbe1676f@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <429437d0-509d-aaaa-05bf-3a0f1f0391d6@mojatatu.com>
Date:   Tue, 25 Jun 2019 06:55:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d2692f14-6ac7-1335-3359-d397fbe1676f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-24 12:49 p.m., Eric Dumazet wrote:
>  
> 
> Well, I would simply remove the skb_orphan() call completely.

My experience: You still need to call skb_orphan() from the lower level
(and set the skb destructor etc).

cheers,
jamal

