Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC96211F4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiKHNGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiKHNGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:06:41 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207F6BD3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:06:41 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so38464108ejc.4
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mYO3Xkfj/SqRH0wna5T/HK2EonIHonOrulbnXno0Khc=;
        b=rZrQ8O1TAVwCkCKJ0kASAmj1iR8Oyurt7fqj7H0GlENbeXkqTqS6dvZIOY3Ky3sWXo
         jpy8b28fPUxKS3fB6qPwTh91X17rpWWJQRLHgkUh6fgh0kLVlhSw8h+aTueLSjdZqZZQ
         ln6rNeLT+/+/MkvolMUcCkSeS9PiDKeaZ0D/+eoL7JkVQop2GEEIgggsxlTydhsBVtYY
         KNZAVxS2ofqT5dnmnph7wgzEG/GTlc8rV5qd1zAtCKuPX+7melqTnvA/RDjqVwICqCEW
         Fd1G7hRrd+9ytUHuXqpoyjyTsYFEhtD99QSBHh864k1Gdn2uF8m/bG2X/Ya9J3/sf2by
         NCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYO3Xkfj/SqRH0wna5T/HK2EonIHonOrulbnXno0Khc=;
        b=VpjmDLDjXp+2At4Vn2c7SQgOTW4DW30WVKfGRVFbV2oe3yGnPcc5yyUVy798Ou/qRJ
         Gzei3NsUJ1HCQcUfr1f8RuaBZ3fSIoRbG8EWKHxMbQbJVNAe4fSJC7dJxWfpN2Fh02RU
         92wv16aSGpKg1YVZU22WZmnQnx2Pxk3dWywLmMmMlWOCmRslTZ9Ap4mapWCJmeFk/DxD
         OjVjIuPZFgBlLa/m6ZwgX+TXY2lQOB0pLBa+5mF1vRDSlBJ8Vaj8DETMXvJ3zEfVJIXq
         QGeunMJoUT7WhIr8Bsfdkd50aenLsnHRMf3a6jzL4luOxR1JX9QpI5cX7AzhNxprophf
         8PcA==
X-Gm-Message-State: ACrzQf1/V3VGKDl7dRMm0N40WnlW27IFkX1vAgOxhxIgCC4brHxfnO6O
        r4vFkxdXlWnWEpKw/8UhS9Aj+A==
X-Google-Smtp-Source: AMsMyM6559Y0J9x3pufjlt+AxMrDZmMoY1iP14K0vmVUFtLyraoWjqJXSXwQQ+1mxlyjVFB1f3HlPg==
X-Received: by 2002:a17:907:320c:b0:741:1e55:7a69 with SMTP id xg12-20020a170907320c00b007411e557a69mr54195357ejb.740.1667912795896;
        Tue, 08 Nov 2022 05:06:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709064a1300b007ad9adabcd4sm4608866eju.213.2022.11.08.05.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 05:06:35 -0800 (PST)
Date:   Tue, 8 Nov 2022 14:06:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: expose the info about version
 representing a component
Message-ID: <Y2pUWr/LTw+4J3OS@nanopsycho>
References: <20221104152425.783701-1-jiri@resnulli.us>
 <20221104192510.32193898@kernel.org>
 <Y2YsSfcGgrxuuivW@nanopsycho>
 <20221107085218.490e79ed@kernel.org>
 <Y2k6SpW9Wu4Ctznm@nanopsycho>
 <20221107100206.1e2f3743@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107100206.1e2f3743@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 07, 2022 at 07:02:06PM CET, kuba@kernel.org wrote:
>On Mon, 7 Nov 2022 18:03:06 +0100 Jiri Pirko wrote:
>>> Oh, my bad. But I think the same justification applies here.
>>> Overloading the API with information with no clear use seems
>>> counter-productive to me.  
>> 
>> Well, it gives the user hint about what he can pass as a "component
>> name" on the cmdline. Otherwise, the user has no clue.
>
>The command line contains:
> - device
> - component (optional)
> - fw file to flash
>
>What scenario are you thinking of where the user has the file they want
>to flash, intent to flash a particular component only but does not know
>whether that component can be flashed? 

No scenario. Lets drop this.
