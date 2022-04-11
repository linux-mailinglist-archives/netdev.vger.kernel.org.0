Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369074FB9A6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiDKKbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbiDKKa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:59 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF162CE1B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:28:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b15so17780025edn.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 03:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dV05QpFfZGdMcMt+1tGZW845EzKwhgUw3czC5h72hJo=;
        b=yGlR+e4da5zrhMhVOjNtqyoIAx2tVNeJxOaC/ULIvcM3FgMCN/Z/2G2COtLtUp/MXq
         FUB5ZteCerojX0TquZyW/ax7D5+A1OFQI88JOUYdrRgKj/tR+jCUne5wEUlotEHxZZk/
         IOxKPt2sJr1PMvc+aULRvZArw5iqP5tcSNxP9Dn9eBg553W0oQk42Pt1GFj3fWWouw44
         KwbLJiv39WatLXvcyHWfa5ST0l7mQ6mOW9JQ1Y8L2LmCkXXTC33CS/TzfGqN1hWOJP6K
         RbnD1lAWspHt/ED2vKu2uqVBAXQoj9KD/tP26fphrYG+IL2hSRc3QXJZoqla9M0aSDiO
         Ipiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dV05QpFfZGdMcMt+1tGZW845EzKwhgUw3czC5h72hJo=;
        b=Wj8XZEhThlMS92qz0jKPPOuQLYQBHW9aqF3CWb9dfyFdtRWV9g7EU9E+DrGviTAC7r
         QnlSCA3D3iDVcBPRtZuQGUh+vzApCIGWXSkoXa1AE6TVG7vHv3kbFuyVe+jwkwfQxtf7
         F5YfPUZNIEYCZPCfmHMiE/jbjM4vn7Sw2dgTnHV9pgCjP5ABMwz/yNVBwY6BiaDtpny1
         kyl31ZKT8LAYUqNkTFOmx+ilpn/IhaIIU7MJtQhS3L6HoUO7T2sIC1Zv4p5fCDn6vefp
         mdidOzKzl3koi/A5F57iJlk/RSTXyfgQ12jm+ummZaXPKdSsp8dpiKawsK3TELa+p+lN
         tisA==
X-Gm-Message-State: AOAM5311nnmfmBx9rLr2ydgWc498p+4mVSgUqMdkOtGsSJ6YSnSa2366
        Ln3yB5CKTX5RV4o4bt2SaxbzKjfyOWMR5ECZjoc=
X-Google-Smtp-Source: ABdhPJxCGMxUgfvVPPZd7e4Iaq9rcVGVQgeYaKDfl4cWb2c6wu9Cqq3sxE4cQtItRiQPi73SUoO1gA==
X-Received: by 2002:a05:6402:e96:b0:41d:1a0f:e70a with SMTP id h22-20020a0564020e9600b0041d1a0fe70amr17251694eda.411.1649672922937;
        Mon, 11 Apr 2022 03:28:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g3-20020a1709063b0300b006e8872f6585sm1726734ejf.175.2022.04.11.03.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:28:42 -0700 (PDT)
Date:   Mon, 11 Apr 2022 12:28:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Guralnik <michaelgur@nvidia.com>, netdev@vger.kernel.org,
        jiri@nvidia.com, ariela@nvidia.com, maorg@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [RFC PATCH net-next 0/2] devlink: Add port stats
Message-ID: <YlQC2NW5JrnvuN10@nanopsycho>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
 <20220407201638.46e109d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407201638.46e109d1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Apr 08, 2022 at 05:16:38AM CEST, kuba@kernel.org wrote:
>On Thu, 7 Apr 2022 11:40:48 +0300 Michael Guralnik wrote:
>> This patch set adds port statistics to the devlink port object.
>> It allows device drivers to dynamically attach and detach counters from a
>> devlink port object.
>
>The challenge in defining APIs for stats is not in how to wrap a free
>form string in a netlink message but how do define values that have
>clear semantics and are of value to the user.
>
>Start from that, discuss what you have with the customer who requested
>the feature. Then think about the API.
>
>I have said this multiple times to multiple people on your team.
>
>> The approach of adding object-attached statistics is already supported for trap
>> with traffic statistics and for the dev object with reload statistics.
>
>That's an entirely false comparison.

The trap stats are there already, why do you thing it is a "false
comparison" to that?

They use DEVLINK_ATTR_STATS attribute to carry the stats nest and then:
        DEVLINK_ATTR_STATS_RX_PACKETS,          /* u64 */
        DEVLINK_ATTR_STATS_RX_BYTES,            /* u64 */
        DEVLINK_ATTR_STATS_RX_DROPPED,          /* u64 */
I think that the semantics of these are quite clear.



>
>> For the port object, this will allow the device driver to expose and dynamicly
>> control a set of metrics related to the port.
>> Currently we add support only for counters, but later API extensions can be made
>> to support histograms or configurable counters.
>> 
>> The statistics are exposed to the user with the port get command.
>> 
>> Example:
>> # devlink -s port show
>> pci/0000:00:0b.0/65535: type eth netdev eth1 flavour physical port 0 splittable false
>>   stats:
>>     counter1 235
>>     counter2 18
