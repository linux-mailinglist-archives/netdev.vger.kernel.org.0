Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55B06BAC4A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjCOJkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjCOJkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:40:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B4240E8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:40:05 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y19so10409192pgk.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678873205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dcNETBexw8mBCgUeaZzbU1dhEQdep9rOvUPnKvVfUuA=;
        b=MkYdErAptoQ0pGlJuoBfRcr18hvkGlno73VrCKMC2oXxGb84A/pJL2YKrbfFaWarOp
         Cu4f81jVW+354AtrbuvCIOaKSWXMxFQ8O2NHur/L0Eyix3hHf7rgIz02wMgDeBQ6cOk/
         tbKYIcnog+n7Gah9aIMCZDo9KeKdAlFqNz3WircRpQIhHEPt811tzigofjV+y1fiRJ5w
         I+smoAGfeqrnPfdYvvRGlkskBcpDRLVXoP2wvbD8cPbTwnlPd6Xg5GlrZr034xtJ7Q35
         x38CWQYnM7iohY/FtsNSYtUkUYkbBGjC8zTQAMMb73fzeZScDnY7FE74GgXTPIAMW6Du
         YKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678873205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dcNETBexw8mBCgUeaZzbU1dhEQdep9rOvUPnKvVfUuA=;
        b=WWxw2cvD8FPw+M5acNf2NbXNxUsC4AQiJvG6W1lPK1NmHlhd3SunZ+xw9F8KI7bNZD
         VFh3dmxsJw8RH+CW5HeKaou3jhN4AJye1ZuqqYfw320fGugeqr3HlrIc1QfZ3+KJjYg4
         060ycgglH0EqL4TbM+lrYW9QOsJNC+sYHYoIcGMVr4Vd5E2wkGHgD138yXwc9bSnk7hi
         v3RvxbJf86/oavpig4zciEr7r7u7Tnf6uPNuwLtCaemshzpl25JguDvC5AuhtyGlFLej
         qae1+gRNOXBioVWPci+7G9CcdfS40Ed4BON4FdXWnNsGsJ8+py2GQIbd3isg0Swpq5/0
         7pzA==
X-Gm-Message-State: AO0yUKVCz7Y58Fpb1F2Odt1AmaJYRgLIO6LgN89rAdjuHW/PcmhMq++d
        OA5+40MDWyCxELQj8HBCg94=
X-Google-Smtp-Source: AK7set/kdUAkqOv4CfY7PgxGZxB3XTsR2cCfunkpcPQazOR1RL2oAjfsR2zQYflEQ/HMDZ5GLm32HQ==
X-Received: by 2002:a62:63c2:0:b0:5de:3c49:b06 with SMTP id x185-20020a6263c2000000b005de3c490b06mr16315910pfb.3.1678873205309;
        Wed, 15 Mar 2023 02:40:05 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j13-20020aa78dcd000000b0058837da69edsm3024756pfr.128.2023.03.15.02.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:40:04 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:39:59 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG
 for tc action
Message-ID: <ZBGSbzgL2fVvBYG5@Laptop-X1>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314065802.1532741-3-liuhangbin@gmail.com>
 <20230315004532.60fb0a41@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315004532.60fb0a41@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:45:32AM -0700, Jakub Kicinski wrote:
> On Tue, 14 Mar 2023 14:58:02 +0800 Hangbin Liu wrote:
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -789,6 +789,7 @@ enum {
> >  	TCA_ROOT_FLAGS,
> >  	TCA_ROOT_COUNT,
> >  	TCA_ROOT_TIME_DELTA, /* in msecs */
> > +	TCA_ACT_EXT_WARN_MSG,
> 
> Not TCA_ROOT_EXT_... ?
> All other attrs in this set are called TCA_ROOT_x

Hmm, when we discussed this issue, Jamal suggested to use TCAA_EXT_WARN_MSG.
I expand it to TCA_ACT_EXT_WARN_MSG to correspond with the format of TCA_*.
But your suggest TCA_ROOT_EXT_ also makes sense. I'm OK to change it.

Jamal, what do you think?

Thanks
Hangbin
