Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8526BEDC1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCQQKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCQQKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:10:10 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9C6A268
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:10:08 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m2so4919967wrh.6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679069407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UjzDxDVWXiH7vDhwwdNksFwW7YtaxEhKuy7mNkKU/kY=;
        b=WLtYCSEw6QZI9xCr3EfpQa/4pvjbN6mMOrCWKnyFC71zf7OLUE1vSzp76q1DKeOLvA
         A5qVA3aHYRzDHcj5adEuiwVislL78m8zLrH2E3NYuaZcwvkeXjtwy4jRS7z+aAl0j6d4
         nmvscTrM2Ogf1O2YqX9qmjinE3f/dNi+OoHbbO0tWhqeSf4Vul2FtoeqqosCN0fShjQo
         GZ0M2gGrqJDRHKU/H4YfV18sjgP5QMSaroqqjz7dyEPtPhCQ3HxaatLICuvI0wXSK/m1
         /gyTlC4AXPR6wQIEKFs2h9P5r4WId/zJqdXfYiGdeZteSvQSdijhbZ58jGgpTRWz/eRX
         6/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679069407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjzDxDVWXiH7vDhwwdNksFwW7YtaxEhKuy7mNkKU/kY=;
        b=pWrsFR3EqSO2CIau7e4MaklV+r6ALBX15N4VKWyayJcze4sOHDxJKrM63bmKB/3M30
         +uNU5HXORkYOu5jGk64+8JnoD0tQea/VZl0HtxKcHTcv+X0Uu2+55SH/6FJ+FpUft+aF
         FyuM9pHyXGJSxMBViTz38naYod/Gmrf1Xn6vg7LPTQlgJsry9x6K5PCznWmokiA+1iph
         fn4aufE70bqFHzfosHzerBbJZqzBROKndhqTWY1HwlzCLqNwZb5+jHkKueEQtXl6sq/8
         c561XLrwKnbX+VUjd/1luGLcx5IGh8uCpflGTyDkx8vqYoT+7EDy33Zvi+0fVePwfilR
         nR2w==
X-Gm-Message-State: AO0yUKVxewMR8BIcBKAhICpVWXk/FdBNpg4o09AnbMnWHccTm3OU8cIH
        CdR0j6Culhp+tUGOqSNA+XRnmg==
X-Google-Smtp-Source: AK7set93hypJDsMm1enAfIZg8215eCAIhP4PBJcZFx0zQJdvHMFklrJCpfni543ui1ToxFKL4ckHKw==
X-Received: by 2002:a05:6000:12c5:b0:2ce:a8f9:7cae with SMTP id l5-20020a05600012c500b002cea8f97caemr7964173wrx.53.1679069406830;
        Fri, 17 Mar 2023 09:10:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y1-20020a5d4ac1000000b002ceaeb24c0asm2303163wrs.58.2023.03.17.09.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 09:10:05 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:10:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 0/6] Create common DPLL/clock configuration API
Message-ID: <ZBSQ3MFzQSBfGH7O@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <ZA8VAzAhaXK3hg04@nanopsycho>
 <eb738303-b95c-408c-448d-0ebf983df01f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb738303-b95c-408c-448d-0ebf983df01f@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 13, 2023 at 04:33:13PM CET, vadim.fedorenko@linux.dev wrote:
>On 13/03/2023 12:20, Jiri Pirko wrote:
>> Sun, Mar 12, 2023 at 03:28:01AM CET, vadfed@meta.com wrote:
>> > Implement common API for clock/DPLL configuration and status reporting.
>> > The API utilises netlink interface as transport for commands and event
>> > notifications. This API aim to extend current pin configuration and
>> > make it flexible and easy to cover special configurations.
>> 
>> Could you please put here some command line examples to work with this?
>
>We don't have open-source tools ready right now for specific hardware, but
>with YAML spec published you can use in-kernel tool to manipulate the values,
>i.e.:
>
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --dump
>device-get
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>device-get --json '{"id": 0}'
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --dump
>pin-get
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>pin-get --json '{"id": 0, "pin-idx":1}'
>./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>pin-set --json '{"id":0, "pin-idx":1, "pin-frequency":1}'

Interesting, is this working for you?
I'm experiencing some issue with cmd value. Example:
./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do device-get --json '{"id": 0}'
this should send DPLL_CMD_DEVICE_GET which is 1.
In kernel genl_family_rcv_msg() the hdr->cmd is 2
Any idea what might be wrong?

