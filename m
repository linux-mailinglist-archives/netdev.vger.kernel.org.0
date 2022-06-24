Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF76559357
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiFXGZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXGZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:25:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650494F9E0;
        Thu, 23 Jun 2022 23:25:20 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id a17so1272189pls.6;
        Thu, 23 Jun 2022 23:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YzS6DEPqt3lHPSZZNgKFpPjyHQrp9ZFD5gLKipQgADQ=;
        b=ldlfMmihFpyEyNLk9EveOKgKcvWKoGOxwobyUknq3LvuLaw2a+jnMEbmbIoIZtaF8O
         O8V7HKonaKZWwESgR+UqQx4Ofjdix8p0C6wAKAPiJ9mdXbz5NRWouIiwCow+pkN0QPrk
         bAJds845htlNu511f1gkeIIy6GtXtpVZQAfYxT1xVQGgSOWpQeN99J9Z/kX+psUkJgwP
         0y11bFBVd83ef98m/bTy8mce/D7vmIFX+ICNpiGjmn9aD4EswVuosypYBNrDOTVErCaB
         8Nvk/nMF1dajggwP5lvuAqaLQXR1GXLnV5tLZDtB4JJ1r1hPr+xvE6LILsEGSamXY0ZX
         trMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YzS6DEPqt3lHPSZZNgKFpPjyHQrp9ZFD5gLKipQgADQ=;
        b=O3wJqyRqv/fEsO6GvlVXtI3YhJCNzN56P3ikgluWbWHaMjlUq2HO5cFZ0Qj74c7SKi
         VZSA+hJ6nruLoOzCJ73I0eU7ADe5F+50855C8E19rNvFutuScKYzZMifm2J44PIre+ry
         JE05DbvXxhKVsEahm3OZzKbr9AmYP2n23iq4QyIXDvqb91hMMg7T0ncQ/7H3XX8hYvTi
         Xmeqh4ujK5sFl9PYIU7Ewcp0kvvuhVhFAwGK4BPzncAwqXwVupZAKFs883dSoFRIMuG1
         NlA0rdCOwGWp33wLAu5T+ov8Ip7DZ7fcuXD6J3thzol4UitQjQEn/cWu6Tm4RbyrGU/e
         EGdg==
X-Gm-Message-State: AJIora/Z2dKfoiJrwC2Lcyo8gxK3Frsq5a313SZY/MhzJW3TwgNhdoCx
        Fv95ZuPgcnMmsdh0WJvB/rw=
X-Google-Smtp-Source: AGRyM1thgI+CyzAM+KdY/bGmMul5M/V1mcgFSjjfRva8yMVO3W7abyn1Ry2ZWFlUXlV784O7kbFTSQ==
X-Received: by 2002:a17:902:d905:b0:16a:2917:73dc with SMTP id c5-20020a170902d90500b0016a291773dcmr23306983plz.6.1656051919783;
        Thu, 23 Jun 2022 23:25:19 -0700 (PDT)
Received: from archdragon (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id a25-20020aa79719000000b0052551c1a413sm760337pfg.204.2022.06.23.23.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:25:19 -0700 (PDT)
Date:   Fri, 24 Jun 2022 15:25:15 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KASAN: use-after-free Read in cfusbl_device_notify
Message-ID: <YrVYywPFYiqWJo4a@archdragon>
References: <YrVUujEka5jSXZvt@archdragon>
 <CANn89iKLpGamedvzZjnhpNUUpPJ7ueiGo62DH0XM+omQvhr9HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKLpGamedvzZjnhpNUUpPJ7ueiGo62DH0XM+omQvhr9HA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 08:15:54AM +0200, Eric Dumazet wrote:
> On Fri, Jun 24, 2022 at 8:08 AM Dae R. Jeong <threeearcat@gmail.com> wrote:
> >
> > Hello,
> >
> > We observed a crash "KASAN: use-after-free Read in cfusbl_device_notify" during fuzzing.
> 
> This is a known problem.
> 
> Some drivers do not like NETDEV_UNREGISTER being delivered multiple times.
>
> Make sure in your fuzzing to have NET_DEV_REFCNT_TRACKER=y
> 
> Thanks.

Our config already have CONFIG_NET_DEV_REFCNT_TRACKER=y.
Anyway, this UAF report seems not interesting.

Thank you for your quick reply.


Best regards,
Dae R. Jeong.
