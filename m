Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7D618E58
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiKDCjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKDCjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:39:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AD323389
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 19:39:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f63so3292021pgc.2
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 19:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ad840VN/m6CZUNX2+yTXMoYbjXLeE1yW5PqZbVgD8q8=;
        b=quKASOMakwT62Oyujtl6FQmpYJ8wadfcvtI8JTxPhZFC8WjZ8dlWQmIWjO5DB2DWaf
         OwwZY9ghIwpyccWevaSWl+7jLXON0aSgh4AM7yPHOQuNX7PZvLk5hPGJnxQFcU2fEA/q
         b5MlEl7aXIIwoLrxrnz+GyMHE7USnzgHfsNYKa1Ehw05rGUG19vKpj3qqVwy+9GtgSVp
         I8U/AqwgDfoeyEF0ytVs6dC0mEnMyKzizsX0ySIyJEN2+unHe+rpcv+TJU5PAiEfOIGy
         J3Q8bEBUNuCa7PQfd8jIfBK62biTve//ifXWEZxKudV24eHZVr+zT1VO2VGdoyxEzfd5
         3Dbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ad840VN/m6CZUNX2+yTXMoYbjXLeE1yW5PqZbVgD8q8=;
        b=WVbr1iX5usJv3IjOhpv9lzwuYx92mcAyk/hQLC9wZLEjxkVoxwfV4y9UF+m0uH4083
         1drSZzyWLUbQxFZ6i+ECD+lfJ6MCcyC9l9ixMTOOhuEFWGP7kYe2wpPHoQPIWRwUkmBi
         7N6unujysrJpufx8puGoEzLPBR0QjRkUodmXvWC9tlYXNoy31DobXljD4gLiwlVkibXa
         f0OyMoxhfC3GaEfa/OBcJrhfp4pSgKYvWTsquQ8eJi46IZBFOeX+D19Cr64JFo5t9KN7
         7NVGJCQ3f9pyZuRCETpJz7s0g67BlOqlV2qXLWtcMHmmOa6KaIY+3lPNEkc9ge/5pYA0
         o8nA==
X-Gm-Message-State: ACrzQf08IIzAQ+7mH5c443KRyzeLiuu5LMUkdgUN0LaPk67o5UvzsONF
        soyKPiQBE8jGlo2DMUAuhpI=
X-Google-Smtp-Source: AMsMyM4xpTE8Q3YstrJFJEuTDNfq8Tqtye7ZEBVS8wtsmaj9bVx80cywXUJcPprFPYaS3mVB7kakjA==
X-Received: by 2002:a63:d64b:0:b0:46f:7941:a8ea with SMTP id d11-20020a63d64b000000b0046f7941a8eamr28315742pgj.331.1667529579534;
        Thu, 03 Nov 2022 19:39:39 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f54500b00186c41bd1e7sm1385226plf.142.2022.11.03.19.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 19:39:38 -0700 (PDT)
Date:   Fri, 4 Nov 2022 10:39:32 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y2R7ZO9uUintP72a@Laptop-X1>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
 <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain>
 <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1>
 <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102163646.131a3910@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 04:36:46PM -0700, Jakub Kicinski wrote:
> > I meant you only added it for filter notification - but such a feature would
> > be useful also for other tc pieces (like actions and qdiscs). Is there a better
> > way to do it such that the other tc parts may benefit (instead of just
> > filter_notify?).
> > 
> > Yes.
> > So looks good to me then.
> > 
> > Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Thanks Jamal for the comments.

> 
> Eish.
> 
> Hangbin, I'm still against this. Please go back to my suggestions /
> questions. A tracepoint or an attribute should do. Multi-part messages
> are very hard to map to normal programming constructs, and I don't
> think there is any precedent for mutli-part notifications.

OK, I will re-consider about how to implement it via tracepoint or an attribute.

Thanks
Hangbin
