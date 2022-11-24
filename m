Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F437637C7B
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiKXPHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKXPHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:07:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10809E0B73
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y0olYVP6Su9CBHcys8As859rRPrtHiB/j+qir6ssOIg=;
        b=cSK1GBLRLzh/cKH59Ta1/Y2joOlgfZL3Mf9CthwOiRIRwUEFCrIXYwwHVrDiDQ6Cl4CRMY
        yndE5GztBXqQxnuXZ7ri/hVjLsTvJgtdC9zsrJ5lkkmvqXoFb5on1LqBa1IppqBgJA58fA
        phZ4tdYgDiMUxHqzeo6uavUHt/RA7YQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-77-Lf8XhextOKq21xbcZ_iwOw-1; Thu, 24 Nov 2022 10:06:18 -0500
X-MC-Unique: Lf8XhextOKq21xbcZ_iwOw-1
Received: by mail-wr1-f71.google.com with SMTP id c4-20020adfa304000000b00241e5b2c816so476723wrb.21
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:06:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y0olYVP6Su9CBHcys8As859rRPrtHiB/j+qir6ssOIg=;
        b=FhzilZaJ4FopgYCMi+ZlWwJXfklD7B2IGU6SnUhhjizfYONHjOtQgZmkHp0DWC3NYK
         QySsNBEMMVpRpmaEZxAcQ/hhAZhA5cYthwZc7Z0KX0mOn6yFKQo/LDFPVMGr8JKjJ8Gr
         40s6prwhdKX+obCo78HGgI+8uMcNY1+AYelXjuAnJ0nV94rkjC/elvjlpKN7sRqW9UtN
         fGmbaCtKppI1QqoFBF+n4BFOh9lrTF6nppAtBYMlwylJzTluVaA9XRcgaXEG4ypz9gAN
         2Drwcw1gnY7aY0Z8dPWsVwF5eANaDyBN0gsNps41muQkEuNMiuXE9P2HTf5pgh5fiqkk
         vksg==
X-Gm-Message-State: ANoB5pnJtcXsrq5rpmW8Ik2ifnB7OEjwa/dY/nrkTavwyD3Me1/W1row
        MzXt+z81m0BeJXwSIDjMipJtaOt1JMHHRNakb53ALsBlrvd1VE9awDN4eaLcJVlabbCEtmIRvKi
        iTryskNjgPaNm08qJ
X-Received: by 2002:a05:6000:4082:b0:241:cf15:b6af with SMTP id da2-20020a056000408200b00241cf15b6afmr13859217wrb.282.1669302377678;
        Thu, 24 Nov 2022 07:06:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7YgGwTGX+v0Yq2PLhNpFTAmMgsohaNnaurJkbYQjE/6Jb0KIEFX2boRJrD5iwDoswQZiX1FA==
X-Received: by 2002:a05:6000:4082:b0:241:cf15:b6af with SMTP id da2-20020a056000408200b00241cf15b6afmr13859194wrb.282.1669302377434;
        Thu, 24 Nov 2022 07:06:17 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c4f4700b003cf37c5ddc0sm2304463wmq.22.2022.11.24.07.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 07:06:17 -0800 (PST)
Message-ID: <3e8a822d1e9f0dad7256763cb7d2fdaf1115c0f5.camel@redhat.com>
Subject: Re: [PATCH v3 net 0/6] hsr: HSR send/recv fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Date:   Thu, 24 Nov 2022 16:06:15 +0100
In-Reply-To: <20221123095638.2838922-1-bigeasy@linutronix.de>
References: <20221123095638.2838922-1-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-11-23 at 10:56 +0100, Sebastian Andrzej Siewior wrote:
> I started playing with HSR and run into a problem. Tested latest
> upstream -rc and noticed more problems. Now it appears to work.
> For testing I have a small three node setup with iperf and ping. While
> iperf doesn't complain ping reports missing packets and duplicates.

Thank you for all the good work!

I think this series is too invasive for -net at this late point of the
release cycle. Independently from that, even if contains only fixes, is
a so relevant refactor that I personally see it more suited for net-
next.

In any case it looks like you have some testing setup handy, could you
please use it as starting point to add some basic selftests?

Thanks!

Paolo
> 
> v2…v3:
> - dropped patch #7 was an optimisation.
> 
> v1…v2:
> - Replaced cmpxchg() from patch #6 with lock because RiscV does not provide
>   cmpxchg() for 16bit.
> - Added patch #3 which fixes the random crashes I observed on latest rc5 while
>   testing.
> 
> Sebastian
> 

