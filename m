Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1804E57B906
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238566AbiGTO6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiGTO63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:58:29 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C356052442
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:58:27 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bp15so33571413ejb.6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v7UZQSWTIkyXAAAPYRDQke900KvI9B81j2LTJEOpCIo=;
        b=7p2TvOmDj6oUxzXY1i/TAIn2ycRdM1xZEiL72CjxWuLMZLKeG86xYLqcvcbwwNcU5B
         hIHeLNId7ThSCgMmJr2pxuFKJrJ6/jqcwBzCuNKqDYSm0DG7HOKkXOP0ONp5h4z5TVF+
         jRZfC2HzvV9RqK0Xq/UWYGYCcIDxWmN9aa+h65FOA3JsLK84SWP/TxBQwlC9pXJVHCvK
         efZAYbSC5XooO9ZkWNMOJ+7R2wKADm1pcA+ZMgzu1P48ND3XlFVZjkJsJDiUxhFP2EV3
         9KEWCjA7STm6H1+4k8MCFEw+UB1Ddvokye6i9KyjdLzOdTbWTJF4Mw5+U1ILKRedMgZ7
         GaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v7UZQSWTIkyXAAAPYRDQke900KvI9B81j2LTJEOpCIo=;
        b=2/VP7lxyoJZCUYSl8VDe6GO2kcmwLYYAOnVGRe44FAEBuqx6RB/tRuVf/XFWEt/2Rr
         4Xs09kWu7fntGnFOSkxTvnNFCW3OJpwA1dEQyQ2s+WsO+XcoHSBk+jCNsKAeRp6Nu4Rq
         I7LzQlX2uF1nqG6syGEqSaupQ8erxBr2gGPb26zNM8No8bwEGznqKsd0OZmv5c87Qpws
         qjMTddfMXr51OZQ3VBe+UW/M+ttPGp3tbW40OnzBr1aQb0MW6/Ar0umkikTfkRw0TPOg
         8id/08lCUZiewT3QZMAlfPSQ3MwYsZ+9j/j4M+0tBtgy+t/EQkyd5r0tdslJVSOo3qJu
         RRRg==
X-Gm-Message-State: AJIora/GeKPTIq8yQ0dwpOqASn0zVyWwMsrzwqnA1Iv5pTt6LKbxZNt3
        utQDyE41P1/pm3cKqbVYHUWrig==
X-Google-Smtp-Source: AGRyM1ueY55U4t39Qn7MmTSF3bzm0qNAcFuNYMyjWa//+s0fsF5aQDmZ7Hh0ZNEkmYZ5l2Qt60X0YA==
X-Received: by 2002:a17:907:a067:b0:72b:8f93:dff with SMTP id ia7-20020a170907a06700b0072b8f930dffmr35414720ejc.238.1658329106315;
        Wed, 20 Jul 2022 07:58:26 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906318f00b0072f2ed809casm4046538ejy.49.2022.07.20.07.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:58:25 -0700 (PDT)
Date:   Wed, 20 Jul 2022 16:58:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <YtgYEN2jXIZftqSH@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
 <Ytf0vDVH7+05f0IS@nanopsycho>
 <Ytf4ZaJdJY20ULfw@shredder>
 <Ytf6ASAXTFItHcT/@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytf6ASAXTFItHcT/@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 02:50:09PM CEST, idosch@nvidia.com wrote:
>On Wed, Jul 20, 2022 at 03:43:17PM +0300, Ido Schimmel wrote:
>> On Wed, Jul 20, 2022 at 02:27:40PM +0200, Jiri Pirko wrote:
>> > Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
>> > >On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
>> > >> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
>> > >> +				    struct devlink_info_req *req,
>> > >> +				    struct netlink_ext_ack *extack)
>> > >> +{
>> > >> +	char buf[32];
>> > >> +	int err;
>> > >> +
>> > >> +	mutex_lock(&linecard->lock);
>> > >> +	if (WARN_ON(!linecard->provisioned)) {
>> > >> +		err = 0;
>> > >
>> > >Why not:
>> > >
>> > >err = -EINVAL;
>> > >
>> > >?
>> > 
>> > Well, a) this should not happen. No need to push error to the user for
>> > this as the rest of the info message is still fine.
>> 
>> Not sure what you mean by "the rest of the info message is still fine".
>> Which info message? If the line card is not provisioned, then it
>> shouldn't even have a devlink instance and it will not appear in
>> "devlink dev info" dump.
>
>How about returning '-EOPNOTSUPP'? Looks like devlink will skip it in a
>dump

Okay.

