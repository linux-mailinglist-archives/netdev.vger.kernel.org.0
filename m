Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B87357B656
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiGTM3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiGTM3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:29:14 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F36A6112E
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:29:13 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id j22so32804400ejs.2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v2CERhLffH8pReC2HaPGdFSN4ghP8Q4amyoU1y7eE5U=;
        b=fVnpyHnTjF3c4sLX7Wza7hwt0lgxwPfLhsxVyy1jRrVpNWte9Q3DLsj1p5QdrfGa0o
         7TgeOVKXl5m9d1d1NJitJnVCObc2hbAYhsK7gDLHXuJjsEDIE4lqt/OBOgACexDD4Pwh
         qaHLvTrpnyjgAdakS2Hy2499BkN1NkERbzfb6CR7cS+HohNjKh9HO+/7ANY9wcbjvokB
         JfteDjxdiZU2iLqJo3o6sX8k0R7ZCehWWGQmZjBf5F00eKyCooRpfR3l5scUlDCl3lDd
         U6GQsxLxb1QhF668Fc6jwve+CIhvi+OZ4Qrwcp4v8QeMxftYh8hRvj0GGhqqfSsGJnA+
         XrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v2CERhLffH8pReC2HaPGdFSN4ghP8Q4amyoU1y7eE5U=;
        b=3vy2N0/xkJ/fwILCqDbqd67ulfU/8OrnxzqffBu0vpbLrTbijqMAwNIUYwSLdIP29C
         hxX5pepGChcYGsXQEbMuCoIe/45vzjaqaZpnZI/DllCE0gSkCyqyGW1Cw2Eq39bvdHQC
         XfEhV7/BEy0z491Sh2h1jgiW1vHFf70xcoFOy41KRw2stK7mMg8trq/MS23qqg8HBb59
         42oBSIgsOPUH5omEXPui/xyyNw3YYztK+yfjziM/vVB6w03psjFBVLL2Axx0TcTif9oI
         ieqyWZu/eB77VNtLB0M6zwXZPNtKUajKJ/iZAxeHRAQts8cTQuLC7PbYkmXtXfpR5Egq
         PIow==
X-Gm-Message-State: AJIora8sMOBYxa65VLuTG77wclGIW3rgY8rAAj/9m8iti8aAhYQRGt04
        wo9kdLPLUtEh27dWi114MCq4Sg==
X-Google-Smtp-Source: AGRyM1t0Agbn1P3n2O8a8+APaE/jjoMBGYSgCUHo7QWNNX0tTfcFQLaNZL6/I5yugLRGsMu9ZasUGg==
X-Received: by 2002:a17:907:60cf:b0:72f:267e:eb8e with SMTP id hv15-20020a17090760cf00b0072f267eeb8emr15950774ejc.544.1658320152024;
        Wed, 20 Jul 2022 05:29:12 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id qx21-20020a170906fcd500b0072abb95c9f4sm7847339ejb.193.2022.07.20.05.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 05:29:11 -0700 (PDT)
Date:   Wed, 20 Jul 2022 14:29:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 07/12] mlxsw: core_linecards: Probe
 provisioned line cards for devices and expose FW version
Message-ID: <Ytf1FrPvYhqGl6VT@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-8-jiri@resnulli.us>
 <YtfHgvf7ZRg3V2EA@shredder>
 <YtfeNeebi04zcbs4@nanopsycho>
 <YtfkFT4A0wa+Q0A0@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtfkFT4A0wa+Q0A0@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 01:16:37PM CEST, idosch@nvidia.com wrote:
>On Wed, Jul 20, 2022 at 12:51:33PM +0200, Jiri Pirko wrote:
>> Wed, Jul 20, 2022 at 11:14:42AM CEST, idosch@nvidia.com wrote:
>> >On Tue, Jul 19, 2022 at 08:48:42AM +0200, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> In case the line card is provisioned, go over all possible existing
>> >> devices (gearboxes) on it and expose FW version of the flashable one.
>> >
>> >I think this is a bit misleading. The FW version is only exposed for
>> >line cards that are "ready", which is a temporary state between
>> >"provisioned" and "active".
>> >
>> >Any reason not to expose the FW version only when the line card is
>> >"active"? At least this state is exposed to user space.
>> 
>> When it is active, the ready bool is still set. So it is "since ready".
>
>My point is that sometimes while the line card is still "provisioned"
>you will get the FW version and sometimes not. Because it is enabled
>based on a transient state not exposed to user space. If you enable it
>based on "linecard->active", then there is no race.

Okay, will do.
