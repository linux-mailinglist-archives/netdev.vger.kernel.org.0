Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C3450DCBF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbiDYJfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbiDYJfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:35:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A27F2A245
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:31:06 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i27so28399150ejd.9
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UCBFyidgS3lgkKJBY5Uc+yDE8aEyTHw0+uUXn2oRCqU=;
        b=Pp5ZZyjfwx4+13XLG5rqXeRiNbDEhXUgo4Xyw50jPwlrYkLPjvWnPxS8YmY+spuY1G
         falCMWBNbB1CUH4y4L0UyWAguH4x9UYybIGtxHU7U2aI73yOLb98MkVXX5+UoD1EvVom
         EvHXVEKv0IvzXDcfQ+Vctx32XBIvzG3118MrRvbF6Bq+/O7BIiofyjKt/581QDJ7WgeM
         wjn2nX2OMZaClz7jTH40y8CPJldo+ZWHPY+6HoryshWxC74RV4rrSEqouG2MLR1kfXp3
         JvmlIhy2iamaBIGvf0RRGzPfsRye7vXFz1LaNhP8D/0L2zbgR1BUZkTCE/U8f2QecoMy
         dixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UCBFyidgS3lgkKJBY5Uc+yDE8aEyTHw0+uUXn2oRCqU=;
        b=K2fDCELVoJ+yWdKqlZ6XHcg5LxB/VPyE57+cXrM7G4jOc5PnU4/bXk0+o8sGhrfmcg
         xOdk7ZUZFWlByAu0H2c1T53heZ/kz2PqtIAS+TyGiqQMxseUjm5UkWg1ULraihzB9x3N
         +ykYG6n41P33lRXGFktwOzAc7qgWe4pfo+EweEx0gzp844jpWSOrBzOexEZBeaWxwwiK
         Tr38GWk8yAJ0+tC0Bn51UkRRBm5De7aDdBH39uV10MMKZRU1kV0wNxtfmqZSIU5LkQMv
         ssZRmA262mY0DihecICW28Cyx4cCJpUevhlygL/K87V0Dqd2yMJ/KC/8YMJLiDFuxcw5
         qaLA==
X-Gm-Message-State: AOAM531nZum1AmlTduf3vJnu4FFqP4Um3Rs/MbNRX/6ktKXv/4bc1QqJ
        ZfU53JIcbtH20yg6fWrQGRb5BA==
X-Google-Smtp-Source: ABdhPJzlDuSXogY+5FXVFpmSp9Tb9Kiz76yuuAOpYEhCZoqq+UK8nXPBoPe8qrrlzHfbffMQDwVynw==
X-Received: by 2002:a17:907:7248:b0:6f3:6e33:cd8e with SMTP id ds8-20020a170907724800b006f36e33cd8emr10256437ejc.198.1650879065505;
        Mon, 25 Apr 2022 02:31:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id nd31-20020a170907629f00b006dff863d41asm3452361ejc.156.2022.04.25.02.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 02:31:04 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:31:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dsahern@gmail.com
Subject: Re: [patch iproute2-next] devlink: introduce -h[ex] cmdline option
 to allow dumping numbers in hex format
Message-ID: <YmZqVw/U7UV8kpNI@nanopsycho>
References: <20220419171637.1147925-1-jiri@resnulli.us>
 <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
 <20220422161054.1db3c836@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422161054.1db3c836@hermes.local>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Apr 23, 2022 at 01:10:54AM CEST, stephen@networkplumber.org wrote:
>On Fri, 22 Apr 2022 14:36:21 -0700
>Shannon Nelson <snelson@pensando.io> wrote:
>
>> >   static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
>> >   {
>> > +	const char *num_fmt = dl->hex ? "%x" : "%u";
>> > +	const char *num64_fmt = dl->hex ? "%"PRIx64 : "%"PRIu64;  
>> 
>> Can we get a leading "0x" on these to help identify that they are hex 
>> digits?
>
>Yes use %#x

Changed in v2.
