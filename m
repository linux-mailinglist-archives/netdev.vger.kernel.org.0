Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E82563809
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiGAQfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbiGAQf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:35:29 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7BF4161B
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:35:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id pk21so5049067ejb.2
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 09:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NZFSzqhKDvfdwkbj8RFi1E5kn8TyofO5vvu6ZfNjWY=;
        b=yBMTO1tJpI7+0ooJmmpl3hu3IfZoAnR4jiY642XeHPPVXSDyZxIL6/lAfwvfbRlCkr
         MkqtKkwQ2ClbH82J60w7iaf+GaMqjJBpHHE7XAC549TvOU5za7acfUcABSLjQFQbB+M5
         eNLW68HDMu5aOSIKaBfqKyp857uW1eS6/O/EMONkItb7M1EmGlmqszshinbsvmYOHsjr
         xMeZmh6oUwvl8tkqab3PR6M2y1byXUhl6wR7AW8WkEzMjR5YER1SApemFR/MztTwMBKM
         YAKgF+T0KvCb7lreWhZsh7o62iybpE/pKjiPpYRF3OeJlQxXhMw8btRtjIZA7GvV+Osl
         Y7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1NZFSzqhKDvfdwkbj8RFi1E5kn8TyofO5vvu6ZfNjWY=;
        b=DK1nnp4TNApNnS2b9mC5Yvhjt3tvOH5tFf/GENupAMolVy3B0BlFssPHaFzP+1+VNv
         zvBz6MiIBKgEhFo0DEY3RGtQtDe57HD9Nihz/Rg1TWOtqOerjXDVajuoib+st/nnchgw
         f0xIieEslIyleSXIqSEg9KQhQ6mGjr3iuv9QECoxXsQl8JIugAkhyAacMS3vW5/0aTZ4
         0EU+eFN9G0KnCkitnJBx4qYT0kOcv0KunnEDJmyQmMgDcI0HSCwfmiFvc9loWL7Prm3h
         vd5w1PPFbfEGeBelhr6KHnSCA3fij3uUQl5voPGc3v61UwuffBt94+wLasVG5wXmstd8
         f5Rw==
X-Gm-Message-State: AJIora9nrhFzw2oMBQCby5vTzynINxSOJ93prwyGJvCepln23UZkC39y
        BYocXLYtWp1q3Uxqkc6+f5PoeQ==
X-Google-Smtp-Source: AGRyM1uIo8GKehAgxdPz+7ohaiue0VfkS9ghqFUomT4r7D6c3LAZ+HFt85/2/ZBqYP3rRsgVOG1/4g==
X-Received: by 2002:a17:907:9801:b0:723:dc27:2225 with SMTP id ji1-20020a170907980100b00723dc272225mr15583039ejc.472.1656693323644;
        Fri, 01 Jul 2022 09:35:23 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s16-20020a170906455000b00722bc0aa9e3sm4331080ejq.162.2022.07.01.09.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 09:35:23 -0700 (PDT)
Date:   Fri, 1 Jul 2022 18:35:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 3/3] net: devlink: fix unlocked vs locked
 functions descriptions
Message-ID: <Yr8iSRZEMSdhOGCQ@nanopsycho>
References: <20220701095926.1191660-1-jiri@resnulli.us>
 <20220701095926.1191660-4-jiri@resnulli.us>
 <20220701093037.36ae3c67@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701093037.36ae3c67@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 01, 2022 at 06:30:37PM CEST, kuba@kernel.org wrote:
>On Fri,  1 Jul 2022 11:59:26 +0200 Jiri Pirko wrote:
>
>> + *	Register devlink port with provided port index. User can use
>> + *	any indexing, even hw-related one. devlink_port structure
>> + *	is convenient to be embedded inside user driver private structure.
>> + *	Note that the caller should take care of zeroing the devlink_port
>> + *	structure.
>
>Should we also mention that the port type has to be set later?
>I guess that may be beyond the scope.

Let's do that in a separate patch. This is just to keep consistency
between devlink_ and devl_

>
>> + */
>
>> +/**
>> + *	devlink_port_unregister - Unregister devlink port
>
>devl_

Right.


>
>> + *
>> + *	@devlink_port: devlink port
>> + */
>
>I wonder if we should use this as an opportunity to start following 
>the more modern kdoc format:
>
>No tab indentation, and () after the function's name.
>
>At least for the new kdoc we add.

Okay. Makes sense.


>
>>  void devl_port_unregister(struct devlink_port *devlink_port)
>>  {
>>  	lockdep_assert_held(&devlink_port->devlink->lock);
>
