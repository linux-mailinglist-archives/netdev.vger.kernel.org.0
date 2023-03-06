Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522C96ACB16
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCFRqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCFRpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:45:54 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D936BDC8;
        Mon,  6 Mar 2023 09:45:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so13910991pjb.3;
        Mon, 06 Mar 2023 09:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678124721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F8jEnuaODHkIgm3QXsy3NxYaf9Twek/6N1cAGCi4cq8=;
        b=gLXj/9ELW4hDPJYzjYYPm7rcW4EBxHVxreG9wJ+ygD2ziX4jcK3Fk77fqWfxfJdCEy
         UtI8NqCy4w8Sr+gM15dCWcFwCZxK+my98RKUM4DNL80X36xywZF2J+ls+36gXglvw0aw
         J4maDik894B2wi0/FI5nOAa7bF6dZtl95gZ2QvjJ/7zJiD6kmltlRT28TLq7Engimb56
         SsU+/JLA+S1P95giqlnpBlycbcmxT6oYT6evAm13H9arBp1kpl4YbORrEwzUkP96tF6v
         Cgv2dTAt6zXOh/3Wcq9nhlVe6heo3jWjSK/ckJLHWWBUnwgmIzbj8plYzdts7TOtdi+W
         FpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678124721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8jEnuaODHkIgm3QXsy3NxYaf9Twek/6N1cAGCi4cq8=;
        b=Sui3edHNPqHBbhafU+EW+wWq3gtAIngBSbzNGEjXgXpZYBHWwm6X/JHuutlQZkvp0n
         f0Niyn+xLM3r4YuMwSrOowRA991CnT/MraGLv/Ff1A03VURxBFKD3iaBhrweCtfBxr5m
         wiT2DtFSDjMbqEdv82AYVp41gEXo7CiU+XCkZ1L0BhJMdM8wH18BPJD56B2ld+lnUJVe
         qv6PhXe1OkwiBLE+HvEx2jC7h/jEuqaRBGIDVCBDyZbF80dANhzlU9lQlx6dnaUlqR7G
         eaYJymgD+LQFDCX+k3OGHT6wQPivZPv/e0ze9HcuzbpmTQN9yr98LP/i1eZJGNx7xdy+
         hUkA==
X-Gm-Message-State: AO0yUKVtYq5SUbrzaDxZ303uVJ/LK+kJ0KMM+1tBt3pP6dhmTJTrJDBf
        OWSf0UnSunxYR4GSVloAnWE=
X-Google-Smtp-Source: AK7set+KGmAg/YZWyh+KxC/W4tyYr0Aryv8jvoRETy0kJlnidI1W8lj1sOCa4lJP/6kpyiVCRbmEOA==
X-Received: by 2002:a05:6a20:6aa8:b0:cb:ac6c:13ba with SMTP id bi40-20020a056a206aa800b000cbac6c13bamr10389268pzb.25.1678124720753;
        Mon, 06 Mar 2023 09:45:20 -0800 (PST)
Received: from vernon-pc ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id k15-20020aa792cf000000b005ac8a51d591sm6516741pfa.21.2023.03.06.09.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 09:45:20 -0800 (PST)
Date:   Tue, 7 Mar 2023 01:45:13 +0800
From:   Vernon Yang <vernon2gm@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
Message-ID: <ZAYmqVmeYdDPVpLZ@vernon-pc>
References: <20230306160651.2016767-1-vernon2gm@gmail.com>
 <20230306160651.2016767-6-vernon2gm@gmail.com>
 <ZAYXJ2E+JHcp2kD/@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAYXJ2E+JHcp2kD/@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 08:39:03AM -0800, Yury Norov wrote:
> On Tue, Mar 07, 2023 at 12:06:51AM +0800, Vernon Yang wrote:
> > After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> > optimizations"), the cpumask size is divided into three different case,
> > so fix comment of cpumask_xxx correctly.
> >
> > Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> > ---
> >  include/linux/cpumask.h | 46 ++++++++++++++++++++---------------------
> >  1 file changed, 23 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index 8fbe76607965..248bdb1c50dc 100644
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -155,7 +155,7 @@ static __always_inline unsigned int cpumask_check(unsigned int cpu)
> >   * cpumask_first - get the first cpu in a cpumask
> >   * @srcp: the cpumask pointer
> >   *
> > - * Returns >= nr_cpu_ids if no cpus set.
> > + * Returns >= small_cpumask_bits if no cpus set.
>
> There's no such thing like small_cpumask_bits. Here and everywhere,
> nr_cpu_ids must be used.
>
> Actually, before 596ff4a09b89 nr_cpumask_bits was deprecated, and it
> must be like that for all users even now.
>
> nr_cpumask_bits must be considered as internal cpumask parameter and
> never referenced outside of cpumask code.

OK, I remove this path for next version.

>
> Thansk,
> Yury
