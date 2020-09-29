Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DCD27BB46
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 05:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgI2DGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 23:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbgI2DGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 23:06:36 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446DCC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 20:06:35 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 197so2672808pge.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 20:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mVuX2czDvnTWRilSn3aFswsoNUBoS6KX4tiy8h1A9Qw=;
        b=ZHshiJg0/mg9qtSpABKGUraki7OopSwPbbCCB7/ViavoF+mwI/3Qq8uaADOQxOoQgM
         BASMCAtDkDoh8hv4FgXLo905HZBynt8cjm6tPwjwxa1wZvSdyjrj2Q9kYICZEF8caEDl
         5dKIwwTuh3VHfJsq2CEJGs5wf+oievF0nDvS2KdG2PnKCnnAiLj1X4K9AhsD8b5isse0
         wS+FKhx6LvzJUKtlI6y8+8mlw81VQeaf+OGg5jDzyNY+wDZbOBcri+fZ13d0ME2qaj8C
         GpygSLf2H1rqL+vi1M64CXlv1WwE7DDg5byc8676h5nA9xC2ChQomggU6RIB/YROMjFS
         P68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVuX2czDvnTWRilSn3aFswsoNUBoS6KX4tiy8h1A9Qw=;
        b=smixXTHUuqa4XCInPKZPBfD0sl+MvD+shvII95mETKaUKiIxLN409jB5K5vktb/1b4
         79U7ErRzy9d+BDRTvNyRiZ6CbKRbDe9WAbJGdx1T3PQ3OArot7PdpiTEl5U5KLxkKOjO
         S7HAA1V9AJ0/vrPFcHCaM5Jtcbhol2PKTbza65HTLOiD6iMYoz9G/NQeKpN/B9h0MPHi
         UBwg0f42o0wRPytBM06UsuwwIHFTUkYsSZRdx//vQfHfx25NLDXsjraeBYEuVKi1u2pc
         Q2ZdSaLfKudLEwg2wMdczhdF6oG3laQs4GJMYQ03VM6Oq5FWCK1tEAqV7/w5ZzSl2Vv2
         vcww==
X-Gm-Message-State: AOAM531NLCo0ds1Ia/Kj2EAyttGhph08e954V6atQOElVdozZMyNcA1y
        1rTbvZdS+LayCYSs6sDyyx0mishVzj8=
X-Google-Smtp-Source: ABdhPJxm7winkpLjic4NVTFBrXDrgUBDttiCEjqqdOZ8Wofd6MqxQ0WZC1WIn2nlIelqtY5cQ3byAQ==
X-Received: by 2002:a17:902:aa02:b029:d0:cbe1:e7b4 with SMTP id be2-20020a170902aa02b02900d0cbe1e7b4mr2320058plb.37.1601348794817;
        Mon, 28 Sep 2020 20:06:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id z63sm2952845pfz.187.2020.09.28.20.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 20:06:34 -0700 (PDT)
Subject: Re: [PATCH 1/1] Network: support default route metric per interface
To:     Qingtao Cao <qingtao.cao.au@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, corbet@lwn.net,
        Qingtao Cao <qingtao.cao@digi.com>,
        David Leonard <david.leonard@digi.com>
References: <20200925231159.945-1-qingtao.cao.au@gmail.com>
 <20200925231159.945-2-qingtao.cao.au@gmail.com>
 <609cfeac-5056-1668-46ca-e083aa6b06b5@gmail.com>
 <CAPcThSEqFwTFoU8_9+Wa3GrruGKHVBDD13ZNfeV7C1D4psm4Ew@mail.gmail.com>
 <CAPcThSFGYd=Q95GqifUu8QX4L1J_eJ=H_L5H3wDz2UgMxVbQ3Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b978cadc-935e-8086-0389-60068677843e@gmail.com>
Date:   Mon, 28 Sep 2020 20:06:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAPcThSFGYd=Q95GqifUu8QX4L1J_eJ=H_L5H3wDz2UgMxVbQ3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 6:54 PM, Qingtao Cao wrote:
> Hi David,
> 
> I understand I can use the "metric" parameter along with the "ip addr
> add/change" and "ip route add/change" commands to make use of the
> IFA_RT_PRIORITY attribute to explicitly specify the metric for routes
> created directly or associated with added addresses, and the network
> manager should do this.
> 
> But what if userspace can bypass the network manager? or forgetting to
> apply the "metric" parameter for example directly on the CLI?

use a sticky note? :-)

> 
> Then the kernel will fall back on the same default metric (such as 0 for
> ipv4 and IP6_RT_PRIO_ADDRCONF(256) or USER(1024) for ipv6) for ALL
> interfaces. So I think the def_rt_metric patchset can be regarded as
> having the kernel providing a mechanism for the uerspace to specify
> DIFFERENT default routes per interface, which does not necessarily
> indulge the userspace network manager skipping over specifying the metic
> explicitly
> 
> What do you think?
> 

I think it is a userspace, configuration management problem.
