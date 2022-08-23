Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612B959E69D
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbiHWQIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244026AbiHWQIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:08:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3775252382
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:21:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ce26so11334303ejb.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tIjipI5OnMsvB27jl6dnoWOVlvj8f8tXSWpU+F+0Z7A=;
        b=wxmPVTaP1eCrF07C8+DpNK5lzPCmVqgDDn3JZwSsA4+ev1sHD2jJtCHCFCzUK5nfUn
         9bUKxigj9aW1EvjxlB11vPNNAXlKKJSQuIL5q20m4br435Sm5y01T6Jo4XLJDCwfoVRg
         ilErwiGBpGJEY3IZI/IatPB1Skfakyoms7mNUmeiZWPoRC30TSWfAg2MMtV6119lv4T6
         YlLEd+bdBnmKdy8k6UJwLO9behQE6uEbLi+c8RzOWjEHSS7tet3UV0ZtwWBZ9OKp7YyW
         XKZWSCBEJeI4psi9aPLSS7qgR4yLa7Od2I8mFB8HsHVMviWZn7k2mqcMatYrQL/ED9QE
         r40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tIjipI5OnMsvB27jl6dnoWOVlvj8f8tXSWpU+F+0Z7A=;
        b=ehGgQH5D1eD/Mt+2hdoRcDMloNUZdi08fpV9zVjTesipdYnkw2VNzX+CIe92FU/Ft7
         9y6bMGfxg+q/dTPSY+2z5rbYHwNFY90wokgUCj09Wd7ORg6iwiqhBR01oDFvopo5nMRO
         mRKHsyccU/pLR1CDn0JCVkAC25G77l5fnoGo7ttDbKYFIkFSx7Vu61OcFoGf9exZiqK+
         XtIBCBiy7Hn1akIwDqwOfJgd2zwQFR9T8lNcL5H9J6dMR+Ax+NchSn4eXvP0opQS19Qi
         nETe1WnIcuHPbx54AQWHSV6f9SDY5MkI8+FyUl5A8oYmNcSmRviw7cZFSkuVraYe8Bm4
         Ko5A==
X-Gm-Message-State: ACgBeo0lJYcwE0GX6Oc/YBcLyrIpv1VoDq9HdPR2k7IoValf/LOKzybx
        Z+Su9x4uRPo3OKad6bz0wo8yzw==
X-Google-Smtp-Source: AA6agR4bo5ow9tw8GOM9HxO4q9LA1IHL1IBcRtYXOWlM3UkK9wX/M9yhAJGB7pw6/bU0KQRzApm47A==
X-Received: by 2002:a17:907:8687:b0:730:7c7b:b9ce with SMTP id qa7-20020a170907868700b007307c7bb9cemr16075162ejc.656.1661257260037;
        Tue, 23 Aug 2022 05:21:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p21-20020a170906141500b00730a234b863sm7365449ejc.77.2022.08.23.05.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:20:59 -0700 (PDT)
Date:   Tue, 23 Aug 2022 14:20:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, idosch@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, jacob.e.keller@intel.com,
        vikas.gupta@broadcom.com, gospo@broadcom.com,
        chandrashekar.devegowda@intel.com, soumya.prakash.mishra@intel.com,
        linuxwwan@intel.com
Subject: Re: [patch net-next 0/4] net: devlink: sync flash and dev info
 command
Message-ID: <YwTGKTUY3Ty9OF02@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818194940.30fd725e@kernel.org>
 <Yv9I4ACEBRoEFM+I@nanopsycho>
 <d2d6f1a3-a9ea-3124-2652-92914172d997@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2d6f1a3-a9ea-3124-2652-92914172d997@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 23, 2022 at 12:09:06PM CEST, m.chetan.kumar@linux.intel.com wrote:
>On 8/19/2022 1:55 PM, Jiri Pirko wrote:
>> Fri, Aug 19, 2022 at 04:49:40AM CEST, kuba@kernel.org wrote:
>> > On Thu, 18 Aug 2022 15:00:38 +0200 Jiri Pirko wrote:
>> > > Currently it is up to the driver what versions to expose and what flash
>> > > update component names to accept. This is inconsistent. Thankfully, only
>> > > netdevsim is currently using components, so it is a good time
>> > > to sanitize this.
>> > 
>> > Please take a look at recently merged code - 5417197dd516 ("Merge branch
>> > 'wwan-t7xx-fw-flashing-and-coredump-support'"), I don't see any versions
>> > there so I think you're gonna break them?
>> 
>> Ah, crap. Too late :/ They are passing the string to FW (cmd is
>> the component name here):
>> static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
>> {
>>          char flash_command[T7XX_FB_COMMAND_SIZE];
>> 
>>          snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
>>          return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
>> }
>> 
>> This breaks the pairing with info.versions assumption. Any possibility
>> to revert this and let them redo?
>> 
>> Ccing m.chetan.kumar@linux.intel.com, chandrashekar.devegowda@intel.com,
>> soumya.prakash.mishra@intel.com
>> 
>> Guys, could you expose one version for component you are flashing? We
>> need 1:1 mapping here.
>
>Thanks for the heads-up.
>I had a look at the patch & my understanding is driver is supposed
>to expose flash update component name & version details via
>devlink_info_version_running_put_ext().

Yes.

>
>Is version value a must ? Internally version value is not used for making any
>decision so in case driver/device doesn't support it should be ok to pass
>empty string ?

No.

>
>Ex:
>devlink_info_version_running_put_ext(req, "fw", "",
> DEVLINK_INFO_VERSION_TYPE_COMPONENT);
>
>One observation:-
>While testing I noticed "flash_components:" is not getting displayed as
>mentioned in cover note.

You need iproute2 patch for that which is still in my queue:
https://github.com/jpirko/iproute2_mlxsw/commit/e1d36409362257cc42a435f6695d2058ab7ab683


>
>Below is the snapshot for mtk_t7xx driver. Am I missing something here ?
>
># devlink dev info
>pci/0000:55:00.0:
>driver mtk_t7xx
>versions:
>       running:
>           boot
>
>-- 
>Chetan
