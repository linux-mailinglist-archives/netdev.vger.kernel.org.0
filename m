Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C1F3992CB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFBSsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhFBSs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:48:29 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A08C061756
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 11:46:34 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id b5so3077305ilc.12
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 11:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oyW//aBbhfsZ2AYU/tmiJg56xJ4sB2f6p3p5Lg2LybE=;
        b=AJLriqqMQ6Ffkuni6Ay70kZxK+hMc4Qjr3PYx/PE/BYPLuXLF8PR3jyqxxPyXKZAdu
         qwPUu67vlFcjkKPSI/1JpTkbPi+BFCea6fShJQUyPbIqNS1U7EvZwWX0BLrZPAYuotMx
         BX95sHCULLKTpOmBuDrEFq5DnMySp5utkiD7csSNmdcI+GgBR4Mhwz+oaBh/ABTfw1EN
         BaxH6SoNN5mXPJ9V1BRHS/fnEqDHUWXyCqOOF306Mh//8N3oRoqsxoOGI/NJkPTTw6Vx
         irv8EKGHJdwafXDDfK/0ZGR2DdeMcjBy6bJmaqLKBY668Pm98xPPDpiJn+PkSWjLRIlz
         rtyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oyW//aBbhfsZ2AYU/tmiJg56xJ4sB2f6p3p5Lg2LybE=;
        b=KN/C/2TYSZH4m/zHWaXDngq++NvLI04JHWTXMrKFc/EsDaLVYDsqQmPRYdBCJxeU9V
         DmNL0sbP19eFBTLJ9/bk5PFAuAQzj0XON/IQbI7GQDOSG+o69U0T/F/hVuwHaEYb0Vdh
         3udYBGx4CqUNvk3WNTol1W+jwzaf+QG8fBqlAWEkFfRcCtgaHwbdSbRn1NFkk7DgPOj4
         u7myOIxFGhGzShV3L49tXIxOH6y2M8pDlhi821XvV0HorMeuoAZFNI+HBABaubISWbe6
         WJxtjAMs8OfxDGoPqcOXo65+Ujd3lmAOPch6If6qbc4Ff6conxIZ/koUCTGhjrvJmna3
         Eyrg==
X-Gm-Message-State: AOAM531JcnLM85MLP0No0ZqpU23MdoSdpoHPSD+1KAb/5A/Zv8AiWBPO
        olHieTZG1udAMUtMwdxML4E=
X-Google-Smtp-Source: ABdhPJyQMnPcauJWrpaO57ntlILsJxlVaZYzgzDaNp5/YWslXdRvKWlmIW76wquYqHQeE09/vd3iyA==
X-Received: by 2002:a92:c569:: with SMTP id b9mr11780605ilj.3.1622659593685;
        Wed, 02 Jun 2021 11:46:33 -0700 (PDT)
Received: from ?IPv6:2601:448:c580:1890::96b5? ([2601:448:c580:1890::96b5])
        by smtp.gmail.com with ESMTPSA id n2sm364651iod.54.2021.06.02.11.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:46:33 -0700 (PDT)
Message-ID: <48ff14c5fff0af909519619caa26d20fcda5159c.camel@gmail.com>
Subject: Re: [PATCH net-next V6 1/6] icmp: add support for RFC 8335 PROBE
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Date:   Wed, 02 Jun 2021 13:46:32 -0500
In-Reply-To: <87im2wup0m.fsf@oldenburg.str.redhat.com>
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
         <ba81dcf8097c4d3cc43f4e2ed5cc6f5a7a4c33b6.1617067968.git.andreas.a.roeseler@gmail.com>
         <87im2wup0m.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-02 at 19:58 +0200, Florian Weimer wrote:
> * Andreas Roeseler:
> 
> > diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> > index fb169a50895e..222325d1d80e 100644
> > --- a/include/uapi/linux/icmp.h
> > +++ b/include/uapi/linux/icmp.h
> > @@ -20,6 +20,9 @@
> >  
> >  #include <linux/types.h>
> >  #include <asm/byteorder.h>
> > +#include <linux/in.h>
> > +#include <linux/if.h>
> > +#include <linux/in6.h>
> 
> We have received a report that this breaks compiliation of trinity
> because it includes <netinet/in.h> and <linux/icmp.h> at the same
> time,
> and there is no multiple-definition guard for struct in_addr and
> other
> definitions:
> 
> In file included from include/net.h:5,
>                  from net/proto-ip-raw.c:2:
> /usr/include/netinet/in.h:31:8: error: redefinition of ‘struct
> in_addr’
>    31 | struct in_addr
>       |        ^~~~~~~
> In file included from /usr/include/linux/icmp.h:23,
>                  from net/proto-ip-raw.c:1:
> /usr/include/linux/in.h:89:8: note: originally defined here
>    89 | struct in_addr {
>       |        ^~~~~~~
> In file included from /usr/include/netinet/in.h:37,
>                  from include/net.h:5,
>                  from net/proto-ip-raw.c:2:
> /usr/include/bits/in.h:150:8: error: redefinition of ‘struct
> ip_mreqn’
>   150 | struct ip_mreqn
>       |        ^~~~~~~~
> In file included from /usr/include/linux/icmp.h:23,
>                  from net/proto-ip-raw.c:1:
> /usr/include/linux/in.h:178:8: note: originally defined here
>   178 | struct ip_mreqn {
>       |        ^~~~~~~~
> 
> (More conflicts appear to follow.)
> 
> I do not know what the correct way forward is.  Adding the
> multiple-definition guards is quite a bit of work and requires
> updates
> in glibc and the kernel to work properly.
> 
> Thanks,
> Florian
> 

Are <netinet/in.h> and <linux/in.h> the only conflicting files?
<linux/in.h> is only included to gain use of the in_addr struct, but
that can be easily substituted out of the code in favor of __be32.
Therefore we would no longer need to include <linux/in.h> and would
remove the conflict.

