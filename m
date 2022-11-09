Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6D622AFB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKILxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKILxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:53:30 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7CC38AE
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:53:28 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gw22so16503049pjb.3
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpPna8fKvG37MQGogeJbREjGCZphRT0BvVHqQx0iFvY=;
        b=YIxLRyMGJW9vjBTNupYhgDLVq5Qx34KR6xljF/FFy7+F2t2BHcuS64fzLRuTutBtAZ
         X6FbQl4ne1YcN4zwgcIkp9IIWNcx3dVCb2wfHLXheH7SuIwPk9vFOt3F3SWlAXcFfLA4
         mIfIrsZU00+jRTKP/783GUvmlH23DzpuX3CPUb1m4N8zsPYZ3b/UR8YHXq2jVvfhbZZ/
         CjE0TWNFtfFfGNPnfAgFbiashcrwG869x4+ZPJCQJL3MRqnAvRrhd12tw2MxWA5NEAPG
         Q2z/My5t9s6DfsmFz8Q+yiCQBahHh7v6EEX2LkHdzCLX4Pku99pbI2gs1DkZw9U70z0R
         nu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpPna8fKvG37MQGogeJbREjGCZphRT0BvVHqQx0iFvY=;
        b=hUa8t2SX5wJEGi/hG8KH4UCLXHTZO8FB3Ca0bkP+YRW+1cXG3/EfHYJ6n+HWZxL7Ux
         OV4dMqrXTFyWOzRQMCuIxu8KZUHYmjRxkpxQ6lV1NXnqS3U0zYAHm4S9MmAE6czDxdwV
         q4QlDDxUUvvrFdJXroej/Nyv3uaYTKmGsXyBFxChueMB3a310WDcaY/Y7LMN/IyhEwqE
         lmhG0KZsU3BdkAT9Y0n70tlg0t1JVn/tZDC9htu5KCQ6qKr3tZr4JfAg3GMSFDh+JOHW
         EK2w9mrrXhvmucLPBjkn8/I1M7ld/P0YcRLEfYYYrlZMYjc21mz7FV9V+Z5T25Lg/qh9
         QG4Q==
X-Gm-Message-State: ACrzQf0037r8uf+BIwsk5eHeaUz5MAuyqYYNsozHBwyqYxbB2A9Gqm6Z
        UIu6qzCfsPlxtGqceSApjp4=
X-Google-Smtp-Source: AMsMyM4m/FiIpo7y3h7DMy8LehhBdFVK98iSOF1sUU27Crgdm649sn+to+9wPxNi8wNo4OOhSbiU3Q==
X-Received: by 2002:a17:902:f252:b0:186:9efb:7203 with SMTP id j18-20020a170902f25200b001869efb7203mr59403294plc.12.1667994808300;
        Wed, 09 Nov 2022 03:53:28 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w14-20020aa79a0e000000b0056beae3dee2sm8386528pfj.145.2022.11.09.03.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 03:53:27 -0800 (PST)
Date:   Wed, 9 Nov 2022 19:53:22 +0800
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
Message-ID: <Y2uUsmVu6pKuHnBr@Laptop-X1>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
 <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain>
 <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1>
 <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org>
 <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108105544.65e728ad@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 10:55:44AM -0800, Jakub Kicinski wrote:
> My initial thought was to add an attribute type completely independent
> of the attribute space defined in enum nlmsgerr_attrs, add it in the
> TCA_* space. So for example add a TCA_NTF_WARN_MSG which will carry the
> string message.
> 
> We can also create a nest to carry the full nlmsgerr_attrs attributes
> with their existing types (TCA_NTF_EXT_ACK?). Each nest gets
> to choose what attribute set it carries.
> 
> That said, most of the ext_ack attributes refer to an input attribute by
> specifying the offset within the request. The notification recipient
> will not be able to resolve those in any meaningful way. So since only
> the string message will be of interest I reckon adding a full nest is
> an unnecessary complication?

Thanks for the explanation. I will try add the TCA_NTF_WARN_MSG to TCA
space.

Hangbin
