Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0A59973B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346457AbiHSIZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243414AbiHSIZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:25:09 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1276CE1913
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:25:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id o22so4762924edc.10
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XsgMrgpDlqpCh+Wo8/M+goLpUFIUwPMg5kJWCUzHcik=;
        b=C6yeJq2IyUGZid1x5YTjFJ9vy8K3KIULE28UyDHNPTi/PPatGV6Bc5M6lC9YPJrTMa
         cBdFeFTAaJ0oxlEBNQ1SLrfqFXAu2++GbZfZ19PzOE55wk9lrHL/o2G1MsuJtgD0ifC9
         25Xo5W1+ezAh5I7LPBgh+CUiNDorRZHKiHTPqOfbVeIPQJCbwalXKNLd4z2Pv0AB6xNs
         FUCLF3EeHXIvcP1iArgmn6wVR/Kn26gYIPQg4aYrAs4VbPQQ9loUBJ6/sTN9BNd3CmtJ
         Bq/lFIhs+kEvGoWEjZvbCT0SsHOjGDp3ncJG0xgcG9ryW5gatKkG/7KNajFu9NPq8g/X
         Z7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XsgMrgpDlqpCh+Wo8/M+goLpUFIUwPMg5kJWCUzHcik=;
        b=rjUfuYAfLDhj2sYgNWoCutIEwyhHuZuM061Meh7cmXoUVMWBXpG3i2YMSKcokGsPkL
         QBLHyWa4x8jkpNoxLNeH2p/G9TFT2ylC476jrS/R3ISM20dMz/z0ls/fB2tP8IIhYfOS
         Aq1KIKwL0ir+IMm0WMr6a6cI/69euoebQiE3UdhBz1TNEY9gaRJ99mZrNtDYM9ayte3f
         2D2/t223DzD53iRAUJktYcgKlA+sj2wxBNmMDNzm8tl72GAi7pEOetRIIqafJ2xgoK3/
         bq+mU3NGUTsj4e7qG1PbTnymYlLnHD5Men9z+4Vv4GWorafS6yu5GinLH3SX9i3FPR56
         NyBg==
X-Gm-Message-State: ACgBeo0vczewxL7i4FbC4QVes3ruY158uxatmMlIgLyFF4W6p09Gg/du
        uX2qMz+B5fl4tsLEHHmYxfPALg==
X-Google-Smtp-Source: AA6agR6WrbeGtVnEYCExkJ+TsVoz8MFXBVl2dCIvyW0X3h5Up29vv20omjOVRMM0GcJY44hmPtOlMw==
X-Received: by 2002:a05:6402:5203:b0:43d:444b:9f99 with SMTP id s3-20020a056402520300b0043d444b9f99mr5334570edd.343.1660897506542;
        Fri, 19 Aug 2022 01:25:06 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v9-20020a170906338900b0073ae9ba9b9asm1977973eja.59.2022.08.19.01.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 01:25:06 -0700 (PDT)
Date:   Fri, 19 Aug 2022 10:25:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com, m.chetan.kumar@linux.intel.com,
        chandrashekar.devegowda@intel.com, soumya.prakash.mishra@intel.com
Subject: Re: [patch net-next 0/4] net: devlink: sync flash and dev info
 command
Message-ID: <Yv9I4ACEBRoEFM+I@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818194940.30fd725e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818194940.30fd725e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 19, 2022 at 04:49:40AM CEST, kuba@kernel.org wrote:
>On Thu, 18 Aug 2022 15:00:38 +0200 Jiri Pirko wrote:
>> Currently it is up to the driver what versions to expose and what flash
>> update component names to accept. This is inconsistent. Thankfully, only
>> netdevsim is currently using components, so it is a good time
>> to sanitize this.
>
>Please take a look at recently merged code - 5417197dd516 ("Merge branch
>'wwan-t7xx-fw-flashing-and-coredump-support'"), I don't see any versions
>there so I think you're gonna break them?

Ah, crap. Too late :/ They are passing the string to FW (cmd is
the component name here):
static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
{
        char flash_command[T7XX_FB_COMMAND_SIZE];

        snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
        return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
}

This breaks the pairing with info.versions assumption. Any possibility
to revert this and let them redo?

Ccing m.chetan.kumar@linux.intel.com, chandrashekar.devegowda@intel.com,
soumya.prakash.mishra@intel.com

Guys, could you expose one version for component you are flashing? We
need 1:1 mapping here.

Thanks!
