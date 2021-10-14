Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF9242E1BE
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhJNS5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhJNS5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:57:23 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173ABC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:55:18 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id g5so4808386plg.1
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=j7wDhfUYmgwotP1y7gzXQPMh0D1p5UqPh72hBSBD4Qc=;
        b=lun74KBrBj2/0VKpxEMxdXYS9uGj/cnpxqRj85owJApxk47olqfgZpmgeVPcdIRfqa
         kv8EHF8pGz07CPy6tBdCgDChR1gNHzqP3xV+/8ywliLFqAN4S8014rty6Ug3fLp+gMLj
         G610N6C8ZWbLbeAGB8URHF2FYgXpLAcUasKsEK9PJsm0YFE1WjcYGL7UkAaesfNXCr2l
         OJWXHL8UG9oOyM/nKFOW/wMQffreNitxEAHVUpo62P7l3Dccf4ITAk4MXTIwV397JY77
         bv5gKjyagQEVDRjXrF9OEyGx0LLCLjvpfaauAtYPGi2hUHpr+rJd9BWMB5LPPuCEoK5M
         OefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=j7wDhfUYmgwotP1y7gzXQPMh0D1p5UqPh72hBSBD4Qc=;
        b=1k7tD9vwJmB6m2Ki65ULAqhv3wWsZiV4BuGd5bxVxuGdBG7G/UmXXTextbCmk+4E8v
         KzpnhUiUFtnLgyM9RzE8LoSFlcGPP+DsGSk2afU9TR5zeQoCJ8TMMfKwBeKvTSeLdIGW
         OnS1QDHYdlSHgRGZ7a0uQykCWQpuzBEAEfy+J5waEU8Aovtq/g2/SBqhGw+ylmKjDSow
         g3yXfem95TDeZL+M6qgsjcPgkKzBwF+QmGshOX8wgP61qqEIwm4imCU6LUtntR7zxq+A
         wBCNOVYkg4mkSak1vxGOujN9WWQSzK1WGo7T4/rPn9d78Fey4LT2myskKiP0hAoXagpS
         rjOg==
X-Gm-Message-State: AOAM533uLgDdi7ueoZU/D+hB4MIIyQG30fysRIT+7RHsxqJ8/V1RslLr
        yczOP3DHAJONVFZs+z2BGhw=
X-Google-Smtp-Source: ABdhPJwHBaUw13G4UA8teOg204EBZVH8DEk0p0EqTVqo2ZFmeh4FF6BTuJV44+qNZbmPE9ilU+Hn6g==
X-Received: by 2002:a17:902:6b86:b0:13f:8d7a:397c with SMTP id p6-20020a1709026b8600b0013f8d7a397cmr655812plk.50.1634237717587;
        Thu, 14 Oct 2021 11:55:17 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id t126sm3178139pfc.80.2021.10.14.11.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:55:17 -0700 (PDT)
Message-ID: <81cd604b9d44d2058464d90788f43d6803f7eea3.camel@gmail.com>
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
From:   James Prestwood <prestwoj@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Date:   Thu, 14 Oct 2021 11:52:00 -0700
In-Reply-To: <1d503584-e463-3324-140a-14c86521cd59@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
         <1d503584-e463-3324-140a-14c86521cd59@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, 2021-10-14 at 12:34 -0600, David Ahern wrote:
> On 10/13/21 4:27 PM, James Prestwood wrote:
> > This change introduces a new sysctl parameter, arp_evict_nocarrier.
> > When set (default) the ARP cache will be cleared on a NOCARRIER
> > event.
> > This new option has been defaulted to '1' which maintains existing
> > behavior.
> > 
> > Clearing the ARP cache on NOCARRIER is relatively new, introduced
> > by:
> > 
> > commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> > Author: David Ahern <dsahern@gmail.com>
> > Date:   Thu Oct 11 20:33:49 2018 -0700
> > 
> >     net: Evict neighbor entries on carrier down
> > 
> > The reason for this changes is to prevent the ARP cache from being
> > cleared when a wireless device roams. Specifically for wireless
> > roams
> > the ARP cache should not be cleared because the underlying network
> > has not
> > changed. Clearing the ARP cache in this case can introduce
> > significant
> > delays sending out packets after a roam.
> 
> how do you know if the existing ARP / ND entries are valid when
> roaming?
> 

I guess there is no way of really knowing, but since your roaming in
the same network I think we can assume the entries are just as valid
prior to the roam as after it right? If there are invalid entries, they
were likely invalid prior to the roam too.

I obviously cant speak to all network configurations, but I think if
your network infrastructure is set up to roam you into a different
subnet you're doing something wrong. Or I can't think of a reason to do
this, it would defeat the purpose of quickly roaming between BSS's
since you would then have to do DHCP aftewards.

Thanks,
James

