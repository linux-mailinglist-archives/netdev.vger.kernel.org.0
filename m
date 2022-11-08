Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221AA620BD0
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiKHJLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiKHJLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:11:33 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A6A192AA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:11:32 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id io19so13610869plb.8
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 01:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pWqn5iuLxNBI+c6A+kNA0klIgVVNgRzYi1f+hRtIhi8=;
        b=DeQaL10EY65w08eZ6QDNzmJrOTBKQkm7TFCnPFreadMUXmyMvfEKuSXp6wES5fZ893
         CBDMYgqTnXYlkf4BgQcxCinvuHWV53XGWlLBPuXn9zegeX5pNRCG6b1JpcvLgRBBKNZM
         fs/BCGZ0UL4DVgwdukRhTac41UmELO2K/bsgeOQkpCnagk86YPo/MlWDhW+eJOYzYQK0
         h2VCYs/gompR7y/MwdRsBnweeEvk3bQU0patR713COQdMgvoF8SCZ71zzRAeePIczmNC
         zk8rFz540DKZdpjFc3hAabmSkd+v9oJUZmLNAV8va+mvdITaQCusYwRvbx4XsUjV+9Ym
         HWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWqn5iuLxNBI+c6A+kNA0klIgVVNgRzYi1f+hRtIhi8=;
        b=BLVILCKI+gUImNaHi4YvA5np9tD1C3bva7yT+eS9rgZHrEg7khOaccZY9Dwt/aaOtE
         CurGFXCggxgLLzVnAOo6/4DC24tSx37bUYZihixKehjPM9G3pXxUsecxcXsSdyLU7OFn
         EwBLIs4u888IaNLxNdZ31IE/ZrnVgX9FfKl/uXlpqq9x9YIVtIF2Ndg+FgxzgtG7xHSP
         5ZJGLGBqTIbnItdb+3Yh0tOj2NwWyegQC9vm6kYzZ+RrtBqai2Ubr5v/Peg6FjSxiHy5
         /zxJhewABD5i/KhvIP1QtHzcClep/EELljw5IojJg6ULoIa5jNMWYhyVne/AyZ51+3BN
         9n/w==
X-Gm-Message-State: ACrzQf1ECo39iiO2kaljmk8UmB52HVsbUh0czahGoQYL4Kzo+PTLJFYy
        ihj/ZrmT0UhnVPqW04M/LHs=
X-Google-Smtp-Source: AMsMyM7PA7TI2B2NSUv9dZ7sMhHY+70VCFdf9CwPxzWNZRSL5WMBOqL4ZST1+dt3TYsvMHQjAaqd1Q==
X-Received: by 2002:a17:902:f252:b0:186:9efb:7203 with SMTP id j18-20020a170902f25200b001869efb7203mr54030969plc.12.1667898692020;
        Tue, 08 Nov 2022 01:11:32 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v126-20020a626184000000b00565cf8c52c8sm6088117pfb.174.2022.11.08.01.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:11:31 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:11:22 +0800
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
Message-ID: <Y2odOlWlonu1juWZ@Laptop-X1>
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
> Eish.
> 
> Hangbin, I'm still against this. Please go back to my suggestions /
> questions. A tracepoint or an attribute should do. Multi-part messages
> are very hard to map to normal programming constructs, and I don't
> think there is any precedent for mutli-part notifications.

Hi Jakub,

I checked the doc[1], the NLMSGERR_ATTR_MSG could only be in NLMSG_ERROR and
NLMSG_DONE messages. But the tfilter_notify() set the nlmsg type to
RTM_NEWTFILTER. Would you like to help explain what you mean of using
attribute? Should I send a NLMSG_ERROR/NLMSG_DONE message separately after the
tfilter_notify()?

[1] https://www.kernel.org/doc/html//next/userspace-api/netlink/intro.html#ext-ack

Thanks
Hangbin
