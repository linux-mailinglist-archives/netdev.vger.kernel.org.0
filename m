Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF1950DCC1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiDYJgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiDYJfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:35:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0D92A70D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:31:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y21so10743181edo.2
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nirpyaTem0CCyti3Ed23Gi64nDycJ865Scn/83+OJG4=;
        b=71eTuaEaGYLf/4VGscVA09YYisZoz7IIHJ/db8Hs8Y51jregdajtSL9nncZduxKW2A
         ZfIyJnZ4PQ8QbCf+dTzJcuy2fCPOf4okJj+EnJz8zZiNdXeJVsQJ4nml5+gtYzaojGNu
         DzCtGutYPF8fcW9UPZNlC9qy7QpGQqHmDg+AsBBUWrl+xWPohuN7Kxg+eCdqlIUXvTKR
         QyNPRyVkHlCOVfOYK5lukVO5m3VJaRrPAysBraC0dQaMg2rdJukhDyd9DORNfH5sJP/V
         LSBuqrYq02J5QaDTswWXm0HKt9XGv13oSs0CJY/I8pGSnc6hVzYA13gKxUDP0Qbczbuu
         yChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nirpyaTem0CCyti3Ed23Gi64nDycJ865Scn/83+OJG4=;
        b=vHQwPpadAA8uSdM3GI7T+kQxrNayFBPkkfPlZOJki4wA0y3TAdj5FPIknFU6dvu+0c
         HNcebFOKtz138UxiwZCoqZvvK9nJangZM1Kt+mXFmh3lnEvkntU7M9gNQ0UWmS98WzPR
         yohHHYArYGcKQiRreU8oiQLCyDt2zj+vIiraBK3nHWbr6DbbARBMEkUfgd9LEGOLuwty
         Miep6D6U3khS0PmrLoppjPuccXGpSo1OUMBdLIQuvccQl3xnrlIULtRCE+Q6w/ts3V7P
         mCZ3v385c4QZgCXq+TU6Mh7kTnojfMEBgjtKGINrcIFW454yiH4H9CT2+qJiCf1awhob
         HHsg==
X-Gm-Message-State: AOAM530vMsuQ8SwLjyG0eet3DGted44QGICgpIWq+x8i37BZxcLjkYqh
        xmUVz6m+ntZF8ZifsgJxTa9BbQ==
X-Google-Smtp-Source: ABdhPJzOjEHkWbUtnBm9lput7nv1C0Z8PORHBO/C6VCMfWfl7p2wUznbcA54FMNohq400KXT8/IWuA==
X-Received: by 2002:aa7:cac8:0:b0:410:cc6c:6512 with SMTP id l8-20020aa7cac8000000b00410cc6c6512mr17764816edt.408.1650879073700;
        Mon, 25 Apr 2022 02:31:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x19-20020a05640226d300b004228faf83desm4514207edd.12.2022.04.25.02.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 02:31:13 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:31:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        sthemmin@microsoft.com
Subject: Re: [patch iproute2-next] devlink: introduce -h[ex] cmdline option
 to allow dumping numbers in hex format
Message-ID: <YmZqX4adcw55qSb0@nanopsycho>
References: <20220419171637.1147925-1-jiri@resnulli.us>
 <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
 <b386dcb4-6c1e-c615-f737-e2bb3026b976@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b386dcb4-6c1e-c615-f737-e2bb3026b976@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Apr 23, 2022 at 02:20:06AM CEST, dsahern@gmail.com wrote:
>On 4/22/22 3:36 PM, Shannon Nelson wrote:
>>> @@ -9053,6 +9056,7 @@ int main(int argc, char **argv)
>>>           { "statistics",        no_argument,        NULL, 's' },
>>>           { "Netns",        required_argument,    NULL, 'N' },
>>>           { "iec",        no_argument,        NULL, 'i' },
>>> +        { "hex",        no_argument,        NULL, 'h' },
>> 
>> Can we use 'x' instead of 'h' here?  Most times '-h' means 'help', and
>> might surprise unsuspecting users when it isn't a help flag.
>> 
>
>agreed. -h almost always means help

Changed in v2.
