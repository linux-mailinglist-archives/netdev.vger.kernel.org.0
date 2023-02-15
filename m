Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9343569804A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjBOQOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjBOQOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:14:17 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744FB39CC3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:14:16 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id z5so22294578qtn.8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mrALx6mRIuF1PFuPpekjRioBfV9eufzecGmCciKmx+c=;
        b=KVmS9I7oG2QZaciFXogT/XI1Ah7ZZQwrmAGnKq+eo0c9JKQr2/vBHCjVsn8jYj42YE
         MK+zHKL8ArKiOZ6Owcf0nI6TBOvpdvsTLv979J4Qs9TTAGAmG1pgLRZvI7LqJX0+Daqc
         qFXQd0puJqemrfygtlvjsw58xXN2rq5roxCW+9Vm1JVMo6GnCvPfYo/uZUhoEIWFPlzJ
         8hnDdmKhf/kcHGFzN/WRWYfXqG6TS1F8MIFwryguzrt80KzAV4J5I5WiyxIQbVoAZmsH
         ol7lX5dr35XxfY0dPdJWxxPhFxARh26xQdKOXo3bq2j8/N/LD+0GEE5TMYBTPj3sRl5u
         aIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrALx6mRIuF1PFuPpekjRioBfV9eufzecGmCciKmx+c=;
        b=3MYo4MrG7H4NTIL81RHzPA/cLfJvgEz9TnQq/Dv13Ip4bDcw8ZdPA8Y1OWOrlWTP7P
         T+2SglLUKpal0zsZb6/S7kDq3g4uygwA8FhNh5DOai/cHY19uP/SlBvKSc1aaMbITy75
         fyqb4ihuzuY2tSQ+ffpnxffozg+RuinTMv00aB/q9qOOLaLGGSgMpk4392biI8kdcmXe
         4iVO4qo42wVOcNTPgdtd7dpdeJ4wNS8j/6tQXXEmNKeVa5dAUdDpEvbr9/dFSsBrF9vi
         ocAALwhR+1G3Cb0KGkQVYiQLxeE+NR49jla1HM0Dyhg8ObCdJdDQYXJ4AkCqCFpE/f5v
         72mA==
X-Gm-Message-State: AO0yUKVRUSWba4RD6Nab/CjmFFWV8bi2HDrxqN/ZwEL2pu6hNvBMy5xe
        xUBrLoX/OGyWPzifUh0M7cI=
X-Google-Smtp-Source: AK7set+JX3HRh2+UyujJ9bRdnsJzhRarb3Fg9J/1ZaN9lQrUv865ZElgBaZeP9+m9hX81DZlF6jRug==
X-Received: by 2002:ac8:4d94:0:b0:3b5:5234:e895 with SMTP id a20-20020ac84d94000000b003b55234e895mr3243897qtw.15.1676477655483;
        Wed, 15 Feb 2023 08:14:15 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id 205-20020a370cd6000000b00706aeebe71csm971604qkm.108.2023.02.15.08.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 08:14:14 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id BA6BC4C27CF; Wed, 15 Feb 2023 08:14:13 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:14:13 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, Oz Shlomo <ozsh@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y+0E1eoKreHKN1rD@t14s.localdomain>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-2-paulb@nvidia.com>
 <20230210022108.xb5wqqrvpqa5jqcf@t14s.localdomain>
 <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
 <Y+qE66i7R01QnvNk@t14s.localdomain>
 <a3f14d60-578f-bd00-166d-b8be3de1de20@nvidia.com>
 <8232a755-fea4-6701-badc-a684c5b22b20@nvidia.com>
 <Y+vXhDvkFL3DBqJu@t14s.localdomain>
 <c060bf5f-4598-8a12-91d4-6340ecd24e14@gmail.com>
 <18a4244f-ee30-0e42-f3ac-444849203731@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a4244f-ee30-0e42-f3ac-444849203731@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 12:09:51PM +0200, Paul Blakey wrote:
> 
> 
> On 14/02/2023 21:24, Edward Cree wrote:
> > On 14/02/2023 18:48, Marcelo Ricardo Leitner wrote:
> > > On Tue, Feb 14, 2023 at 02:31:06PM +0200, Oz Shlomo wrote:
> > > > Actually, I think the current naming scheme of act_cookie and miss_cookie
> > > > makes sense.
> > > 
> > > Then perhaps,
> > > act_cookie here -> instance_cookie
> > > miss_cookie -> config_cookie
> > > 
> > > Sorry for the bikeshedding, btw, but these cookies are getting
> > > confusing. We need them to taste nice :-}
> > 
> > I'm with Oz, keep the current name for act_cookie.
> > 
> > (In my ideal world, it'd just be called cookie, and the existing
> >   cookie in struct flow_action_entry would be renamed user_cookie.
> >   Because act_cookie is the same thing conceptually as
> >   flow_cls_offload.cookie.  Though I wonder if that means it
> >   belongs in struct flow_offload_action instead?)
> > 
> > -ed
> 
> 
> 
> 
> Ok so I want to add this patch to the series:
> 
> 
> From 326938812758dbd2591b221452708504911ca419 Mon Sep 17 00:00:00 2001
> From: Paul Blakey <paulb@nvidia.com>
> Date: Wed, 15 Feb 2023 10:57:40 +0200
> Subject: [PATCH] net: sched: Rename user cookie and act cookie
> 
> struct tc_action->act_cookie is a user defined cookie,
> and the related struct flow_action_entry->act_cookie is
> used as an handle similar to struct flow_cls_offload->cookie.
> 
> Rename tc_action->act_cookie to user_cookie, and
> flow_action_entry->act_cookie to cookie so their names
> would better fit their usage.

Makes sense. This helps a lot already.
(I didn't review the patch carefully yet, but it seems good)
Thanks!
