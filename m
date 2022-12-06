Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999B1643DBC
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLFHln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFHlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:41:42 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C0C19010
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 23:41:39 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a16so19064697edb.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 23:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S5TaCAMCSI9/DFEazueP3ebY38fbNGaH1NaWjylSF3M=;
        b=2NLak6kbdMEp/HPZjQWBX0iggHzmNLR3vCZj5HvYU8jx1ubDTp8UnmblRt+n42wmhw
         EtCcU84Yg5+PRN88RA88VL1QFgjs3LmL6eUIp86wZHugMEdN7aBByvDJ4o273o9qxT/k
         6jonecHLYp75sjf4IRdHxkYtGzsVrr/8SeKea6ZVLnbjhdZPSUjSbWLR0yqA3oAWdEeJ
         2yBbHvLxemetdGw3E6FSqtneFNYUGpPNHllr0nB64ccFmFe8KQwQMLHW8lH1A7v1u9sH
         3mRD2RjCeV7JqoQBXDL+ZdvrKsZtcu1NKa6bvl46LXmEzCTUuQyI5+tjdUn4Grx6n9rb
         HvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5TaCAMCSI9/DFEazueP3ebY38fbNGaH1NaWjylSF3M=;
        b=JlrBHPQJF4mpLFRV8CqG1MzdNJ4AcFqH3N/IHkY/cvXmBWP5/Vv7rvd5MxZotrbsai
         ubwIk98eGidjZptDc5Tr8+5UM6Cu9y+pqK/HhjjFs2gyxz+aj5GXWl61J+QJC2/Pf30s
         M0aRk06cfCV1KUSs3So8Dr/9qnmG2RP+Te3P2Et63mWDYkQWnsmP9ellmseZrGhjyuaB
         zZdbSi+R8hczAYxubph35TX16w6VpmL9VTPv2p6IN22kBVLWsi+44fwAJcIvu1ThZV5K
         wpSlWGYBrv2uYT2syCr+LZOtaZo0jLf9tHQC/jJAnXv+1rR39e6o7PlqqMtLEvxTlNEo
         OHdA==
X-Gm-Message-State: ANoB5pk8Rm4TUkatbhTyzY7VANkQhSig7JFRhBpNjKyKXzzROAFcWfUE
        SpDwZGAbRdwVU00Z+f135P21mg==
X-Google-Smtp-Source: AA0mqf5aBUumDT89QPREtkHJkMaKX60rclb/mLtqcmkfsWTxL00V26xs5P1qVQ0AtwJvFviWkdgUGg==
X-Received: by 2002:a05:6402:3808:b0:468:c911:d843 with SMTP id es8-20020a056402380800b00468c911d843mr77311496edb.422.1670312497784;
        Mon, 05 Dec 2022 23:41:37 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g19-20020a056402321300b0045d74aa401fsm661518eda.60.2022.12.05.23.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 23:41:37 -0800 (PST)
Date:   Tue, 6 Dec 2022 08:41:36 +0100
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
Message-ID: <Y47yMItMuOfCrwiO@nanopsycho>
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205152257.454610-2-jiri@resnulli.us>
 <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 12:55:32AM CET, shnelson@amd.com wrote:
>On 12/5/22 7:22 AM, Jiri Pirko wrote:
>> 
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Change the drivers that use devlink_port_register/unregister() to call
>> these functions only in case devlink is registered.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>> RFC->v1:
>> - shortened patch subject
>> ---
>>   .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 29 ++++++++++---------
>>   .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 +++--
>>   .../ethernet/fungible/funeth/funeth_main.c    | 17 +++++++----
>>   drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++++++------
>>   .../ethernet/marvell/prestera/prestera_main.c |  6 ++--
>>   drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 10 +++----
>>   .../ethernet/pensando/ionic/ionic_devlink.c   |  6 ++--
>>   drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 +++--
>>   8 files changed, 60 insertions(+), 43 deletions(-)
>> 
>
>
>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> index e6ff757895ab..06670343f90b 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> @@ -78,16 +78,18 @@ int ionic_devlink_register(struct ionic *ionic)
>>          struct devlink_port_attrs attrs = {};
>>          int err;
>> 
>> +       devlink_register(dl);
>> +
>>          attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>>          devlink_port_attrs_set(&ionic->dl_port, &attrs);
>>          err = devlink_port_register(dl, &ionic->dl_port, 0);
>>          if (err) {
>>                  dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
>> +               devlink_unregister(dl);
>>                  return err;
>>          }
>> 
>>          SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
>> -       devlink_register(dl);
>>          return 0;
>>   }
>> 
>> @@ -95,6 +97,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
>>   {
>>          struct devlink *dl = priv_to_devlink(ionic);
>> 
>> -       devlink_unregister(dl);
>>          devlink_port_unregister(&ionic->dl_port);
>> +       devlink_unregister(dl);
>>   }
>
>I don't know about the rest of the drivers, but this seems to be the exact
>opposite of what Leon did in this patch over a year ago:
>https://lore.kernel.org/netdev/cover.1632565508.git.leonro@nvidia.com/

This patch did move for all objects, even for those where no issue
existed. Ports are such.


>
>I haven't kept up on all the discussion about this, but is there no longer a
>worry about registering the devlink object before all the related
>configuration bits are in place?
>
>Does this open any potential issues with userland programs seeing the devlink
>device and trying to access port before they get registered?

What exactly do you have in mind? Could you please describe it?

>
>sln
>
>
