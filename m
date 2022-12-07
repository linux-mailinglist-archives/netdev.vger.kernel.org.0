Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91B9645AEB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiLGN1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiLGN1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:27:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C595A3AC3F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:27:51 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id d20so24947232edn.0
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yv1iH2aNoHCv96T/l2EkVrXhJMSx9sWTmJz9/IJmT0g=;
        b=ymZhY6Y6lMSV25NHFA+4rnfjNwHfeW2hwMCBSu5t61KOuBNsbVCRGzAkjcxvvJ1NFM
         sKE0O8mJGDpaWNLBfMO6OshjbOn+N/mPqyAUm6S2rN/qCqrsxSBlatADinBqWl/OTnfk
         rt+8Dyko21cXaa7daRpJ4QTYVb67iCnfeXmoOhAwzocCcl77ctl4plwftGI97/mVTiDe
         /fg862GFvKGMmtEcACBFgPKg7/1grpbOxq6UANeK/oFvOknhFaWy6CDCeGnm/kFoOWkg
         +PbS18iLAVODNdzK/ywu/bqEOaqarqxznsW7tSJc2W0FhMq3su2d8+H7IJVrfwnZv7aw
         KaVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yv1iH2aNoHCv96T/l2EkVrXhJMSx9sWTmJz9/IJmT0g=;
        b=1EhfFe5hWeSaucdfUv3jYyeWhcHxrA7usOuVtwiEV+t1nEpE11w2i0N2/ZNcFF1SFc
         JwAkppTA8NpObi9m3VDorx1r9eYC00ujFxcnlSx3vBKsWvqKlxcJL5+s7AOeFd401Fuv
         Qdrn8IAs7e7UxWvxpPrHFOqHIAP8zvLYsvt/53AXj3xqA7R0laD/2hTjTUE85H5X9Ffx
         EX8rg63ZbuaS02HcoRE3FDi69ivHFwoq97RitArCvayvXEeME7doCWxfd1rqXXpP1x9V
         qgDnAYAFdu2IcJvcn/dhUyaK9N3fqB50dFKJ5lkjDfpdn0BbbJ1XCyLcfRI2SdGHwIiN
         xN0Q==
X-Gm-Message-State: ANoB5pm1WHvYWxlPacejKZxuYbIoNocWcdju24MHs8ssm68PpqlJVpYO
        wVRubolzcdWEyyCEAlzUrq6now==
X-Google-Smtp-Source: AA0mqf6WWahQRvq38gAac4RgCGCEF2pAcAFMqxipMW5rf1/JQnK8MCkjI4ppIlWFpVxEipL/oBjO0Q==
X-Received: by 2002:a50:e603:0:b0:46c:ff45:68e9 with SMTP id y3-20020a50e603000000b0046cff4568e9mr7819746edm.90.1670419670356;
        Wed, 07 Dec 2022 05:27:50 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v18-20020a170906293200b0077b2b0563f4sm8654467ejd.173.2022.12.07.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:27:49 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:27:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: Re: [patch net-next 1/8] devlink: call
 devlink_port_register/unregister() on registered instance
Message-ID: <Y5CU1DkXVRoz3PcQ@nanopsycho>
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205152257.454610-2-jiri@resnulli.us>
 <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com>
 <Y47yMItMuOfCrwiO@nanopsycho>
 <a5c5b1f9-60e9-6e82-911e-03e56ff42da1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5c5b1f9-60e9-6e82-911e-03e56ff42da1@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 06:35:32PM CET, shnelson@amd.com wrote:
>On 12/5/22 11:41 PM, Jiri Pirko wrote:
>> Tue, Dec 06, 2022 at 12:55:32AM CET, shnelson@amd.com wrote:
>> > On 12/5/22 7:22 AM, Jiri Pirko wrote:
>> > > 
>> > > From: Jiri Pirko <jiri@nvidia.com>
>> > > 
>> > > Change the drivers that use devlink_port_register/unregister() to call
>> > > these functions only in case devlink is registered.
>
>
>> > 
>> > I haven't kept up on all the discussion about this, but is there no longer a
>> > worry about registering the devlink object before all the related
>> > configuration bits are in place?
>> > 
>> > Does this open any potential issues with userland programs seeing the devlink
>> > device and trying to access port before they get registered?
>> 
>> What exactly do you have in mind? Could you please describe it?
>
>It looks like this could be setting up a race condition that some userland
>udev automation might hit if it notices the device, looks for the port, but
>doesn't see the port yet.  Leon's patch turned this around so that the ports
>would show up at the same time as the device.

Any userland automation should not rely on that. Ports may come and go
with the current code as well, see port split/unsplit, linecard
provision unprovision.
