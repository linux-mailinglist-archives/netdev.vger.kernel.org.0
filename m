Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721DF5A266C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344225AbiHZLEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344118AbiHZLDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:03:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E9DABB7
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:01:07 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w19so2455059ejc.7
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=p1VnAzYWMmV2LvGeDaBY4iJhtoam7Z2qhSMRMfwoHaI=;
        b=hYOg/FCNL8XueJGO8F/ynVJAbP9OCh8XoeNMHltlfLG63WKcD73gnwwlZYjoO2Rsfg
         sKZ35lOMvz4tEMsaxoYYO5e5aD5qSlpIuqI+/549qu7yFOE3pFGHvITqnCyr5Bjz1rS1
         Dnm3QSlSDHRkYjIhfABq36flOnW5h+kVCHRNxrf0XVOsltufEf/3uC5UL9cr0Ig8TQRC
         +cZ8pv6T91J885REVuFqV1Oo1ldGrq0nCA1ArfnUXGuwxI3d36aFcFeI5jpjPJC4BiVQ
         gBVC8MtxXXiotrUvsqDMIGAk0Psd3RHdu0WH6wLSuCr0A1KZBrjfzctDN+mcg4u85Nil
         1klw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=p1VnAzYWMmV2LvGeDaBY4iJhtoam7Z2qhSMRMfwoHaI=;
        b=x5BS0mCDImJ04HA28GQbDE1seWurwBHAVNoDZu2TyjOZcI4G1BkoQw20+LfUKqxt/v
         zImZAnzm8OYPXDw40NxjRCiW+PmQt2MPV1c+mYhmClmFhIsaJFg4krTxoGKioYdlG701
         gUbbv+vBsjOnsOuNqE48pddVdfl0ASZdmT6ZRFuUHd8Trw6fNieC7638hLPOlpJwG+hA
         S6ygPeb0a31hwQUODhcDMMrx0xzj4fTe5wwxsXVp8GHU4Ov1wU7+cIdc8jZNnO8WX0T0
         JCnn7to4gmBr0DvnKtWYFgGTcrBlTTeXuhLcD8meDKhNiHhYhWS2xUyJjymTfW8T5zjy
         2/3Q==
X-Gm-Message-State: ACgBeo3A1OMOhGdNeBaT81jLSbrpbf4K8hs2lscNapmZmtdN9KCwMNG3
        2pTBa1e4SCAnE+NZxX9uVXKvqQ==
X-Google-Smtp-Source: AA6agR5aQ/5zKejx2YiEefvr2WRBVkzOzKZIg2F4xhM1RXEfPnBrYP72wqnbl96/gl7lhyn2Uj4x1Q==
X-Received: by 2002:a17:906:9b89:b0:73d:6a55:c489 with SMTP id dd9-20020a1709069b8900b0073d6a55c489mr5301555ejc.406.1661511665642;
        Fri, 26 Aug 2022 04:01:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y27-20020a1709060a9b00b0073d7bef38e3sm768642ejf.45.2022.08.26.04.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:01:04 -0700 (PDT)
Date:   Fri, 26 Aug 2022 13:01:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, idosch@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, jacob.e.keller@intel.com,
        vikas.gupta@broadcom.com, gospo@broadcom.com,
        chandrashekar.devegowda@intel.com, soumya.prakash.mishra@intel.com,
        linuxwwan@intel.com, hua.yang@mediatek.com
Subject: Re: [patch net-next 0/4] net: devlink: sync flash and dev info
 command
Message-ID: <Ywin73cEn2lrDZ9r@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818194940.30fd725e@kernel.org>
 <Yv9I4ACEBRoEFM+I@nanopsycho>
 <d2d6f1a3-a9ea-3124-2652-92914172d997@linux.intel.com>
 <YwTGKTUY3Ty9OF02@nanopsycho>
 <eaef51b2-07e1-5931-380c-6a8513f9c7b3@linux.intel.com>
 <YwXliFeA9f/j9Ud9@nanopsycho>
 <474077db-df42-6791-0253-74ca6e0d7b34@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474077db-df42-6791-0253-74ca6e0d7b34@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 10:54:52AM CEST, m.chetan.kumar@linux.intel.com wrote:
>Looped hua.yang@mediatek.com to email.
>
>On 8/24/2022 2:17 PM, Jiri Pirko wrote:
>> Tue, Aug 23, 2022 at 06:29:48PM CEST, m.chetan.kumar@linux.intel.com wrote:
>> > On 8/23/2022 5:50 PM, Jiri Pirko wrote:
>> > > Tue, Aug 23, 2022 at 12:09:06PM CEST, m.chetan.kumar@linux.intel.com wrote:
>> > > > On 8/19/2022 1:55 PM, Jiri Pirko wrote:
>> > > > > Fri, Aug 19, 2022 at 04:49:40AM CEST, kuba@kernel.org wrote:
>> > > > > > On Thu, 18 Aug 2022 15:00:38 +0200 Jiri Pirko wrote:
>> > > > > > > Currently it is up to the driver what versions to expose and what flash
>> > > > > > > update component names to accept. This is inconsistent. Thankfully, only
>> > > > > > > netdevsim is currently using components, so it is a good time
>> > > > > > > to sanitize this.
>> > > > > > 
>> > > > > > Please take a look at recently merged code - 5417197dd516 ("Merge branch
>> > > > > > 'wwan-t7xx-fw-flashing-and-coredump-support'"), I don't see any versions
>> > > > > > there so I think you're gonna break them?
>> > > > > 
>> > > > > Ah, crap. Too late :/ They are passing the string to FW (cmd is
>> > > > > the component name here):
>> > > > > static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
>> > > > > {
>> > > > >            char flash_command[T7XX_FB_COMMAND_SIZE];
>> > > > > 
>> > > > >            snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
>> > > > >            return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
>> > > > > }
>> > > > > 
>> > > > > This breaks the pairing with info.versions assumption. Any possibility
>> > > > > to revert this and let them redo?
>> > > > > 
>> > > > > Ccing m.chetan.kumar@linux.intel.com, chandrashekar.devegowda@intel.com,
>> > > > > soumya.prakash.mishra@intel.com
>> > > > > 
>> > > > > Guys, could you expose one version for component you are flashing? We
>> > > > > need 1:1 mapping here.
>> > > > 
>> > > > Thanks for the heads-up.
>> > > > I had a look at the patch & my understanding is driver is supposed
>> > > > to expose flash update component name & version details via
>> > > > devlink_info_version_running_put_ext().
>> > > 
>> > > Yes.
>> > > 
>> > > > 
>> > > > Is version value a must ? Internally version value is not used for making any
>> > > > decision so in case driver/device doesn't support it should be ok to pass
>> > > > empty string ?
>> > > 
>> > > No.
>> > > 
>> > > > 
>> > > > Ex:
>> > > > devlink_info_version_running_put_ext(req, "fw", "",
>> > > > DEVLINK_INFO_VERSION_TYPE_COMPONENT);
>> > > > 
>> > > > One observation:-
>> > > > While testing I noticed "flash_components:" is not getting displayed as
>> > > > mentioned in cover note.
>> > > 
>> > > You need iproute2 patch for that which is still in my queue:
>> > > https://github.com/jpirko/iproute2_mlxsw/commit/e1d36409362257cc42a435f6695d2058ab7ab683
>> > 
>> > Thanks. After applying this patch "flash_components" details are getting
>> > displayed.
>> > 
>> > Another observation is if NULL is passed for version_value there is a crash.
>> 
>> So don't pass NULL :)
>> 
>> 
>> > Below is the backtrace.
>> > 
>> > 3187.556637] BUG: kernel NULL pointer dereference, address: 0000000000000000
>> > [ 3187.556659] #PF: supervisor read access in kernel mode
>> > [ 3187.556666] #PF: error_code(0x0000) - not-present page
>> > 3187.556791] Call Trace:
>> > [ 3187.556796]  <TASK>
>> > [ 3187.556801]  ? devlink_info_version_put+0x112/0x1d0
>> > [ 3187.556823]  ? __nla_put+0x20/0x30
>> > [ 3187.556833]  devlink_info_version_running_put_ext+0x1c/0x30
>> > [ 3187.556851]  t7xx_devlink_info_get+0x37/0x40 [mtk_t7xx]
>> > [ 3187.556880]  devlink_nl_info_fill.constprop.0+0xa1/0x120
>> > [ 3187.556892]  devlink_nl_cmd_info_get_dumpit+0xa8/0x140
>> > [ 3187.556901]  netlink_dump+0x1a3/0x340
>> > [ 3187.556913]  __netlink_dump_start+0x1d0/0x290
>> > 
>> > Is driver expected to set version number along with component name ?
>> 
>> Of course.
>> 
>> 
>> > 
>> > mtk_t7xx WWAN driver is using the devlink interface for flashing the fw to
>> > WWAN device. If WWAN device is not capable of supporting the versioning for
>> > each component how should we handle ? Please suggest.
>> 
>> The user should have a visibility about what version is currently
>> stored/running in the device. You should expose it.
>
>If the only intention of this component version is to give a visbility to
>user, the WWAN Driver exposes the AT & MBIM control ports. Applications like
>Modem Manager uses AT/MBIM commands to obtain fw version info.
>
>So would it be ok to keep component version as an optional for WWAN drivers ?

Nope. It is mandatory now for the devlink flash component name to match
version of component reported. If you cannot do that, there is
most likely something wrong with your design
