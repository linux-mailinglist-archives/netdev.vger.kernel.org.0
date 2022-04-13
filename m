Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B934FFA72
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiDMPl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiDMPlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:41:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B77C6578F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649864342;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DTng1VBQBG1w5ddfOZndBpJ6F/sDE1kAEyXenf5ppGY=;
        b=d0DGnVkUBpW2MSmLJ/tmXzAKN46azZN5D9zEqj1k9MgFmpyyaqUsDp7QDrUgcGIGVJN1Pb
        P5HU9pAZexsKIYWa9IUrhMcAqRo8QgyqTrdnGlpjhzM945GXUfi9OAMVurOoshejYxyIra
        22H1Q63jV7m6RKJO+R6QqDHcdby+tfE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-bNa_4QBINbSPrTTLoS02iA-1; Wed, 13 Apr 2022 11:39:00 -0400
X-MC-Unique: bNa_4QBINbSPrTTLoS02iA-1
Received: by mail-ed1-f70.google.com with SMTP id cx6-20020a05640222a600b0041df79fb9e8so1300039edb.1
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=DTng1VBQBG1w5ddfOZndBpJ6F/sDE1kAEyXenf5ppGY=;
        b=JScYnWk/oLM5p50y/YBeKNyV3cXBFEHrCEe7mof69mEUzdcIC8HouEBUJL7Gv4eu2m
         CQZgZerY/T54H7dbLaIdyXWQ1oiQPAjewchH5uOPiaHj/4F+n/X3MeoXgM70B1d22yv3
         Laic+uVqxYPb2a9yjoUY6Fl2cs5RaujJqVNmaZMjL+nkzPPBXXB0AWy/J5jLpWgJV19k
         s/8cfLHvJDndNckE6VEkf6fRCIhbsFYgDHPWNnDHEXJAlSmIUDQAoM43i4ePug6qex0a
         R6/XtbxdpdISftLs+a5QjjqXKW04mE+ah/GiCj/lkSsH4vSW+GLa2utopJY9hwEKvt4z
         bXgw==
X-Gm-Message-State: AOAM5335xmHh6PF+7nToN7xoAdlhR7BWUVVChgWRMfgHQWrisb4FOtYd
        t9jQSz50lpTAC0Khmmqj04dV3RdrvO9oROrvId5uV1qCk37EP8RaayWpGMadbgm/U/fh8zaW0CH
        SopWkoUsxyshA0YvH
X-Received: by 2002:a17:907:eaa:b0:6e8:9105:b3c7 with SMTP id ho42-20020a1709070eaa00b006e89105b3c7mr13907600ejc.26.1649864339303;
        Wed, 13 Apr 2022 08:38:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS4emMuGiZkqPvPLYDGoWTninw7nHNjPU9LlyGy1tPOzLfzqSeEApClSgyutyj3qg6/dRukg==
X-Received: by 2002:a17:907:eaa:b0:6e8:9105:b3c7 with SMTP id ho42-20020a1709070eaa00b006e89105b3c7mr13907582ejc.26.1649864339020;
        Wed, 13 Apr 2022 08:38:59 -0700 (PDT)
Received: from [192.168.2.36] (ip4-46-175-183-46.net.iconn.cz. [46.175.183.46])
        by smtp.gmail.com with ESMTPSA id z22-20020a1709063ad600b006e8867caa5dsm102643ejd.72.2022.04.13.08.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:38:58 -0700 (PDT)
Message-ID: <8106efcab543ada95ac7ea9e56c47889f7b44f3d.camel@redhat.com>
Subject: Re: [PATCH] ice: wait for EMP reset after firmware flash
From:   Petr Oros <poros@redhat.com>
Reply-To: poros@redhat.com
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        ivecera@redhat.com
Date:   Wed, 13 Apr 2022 17:38:56 +0200
In-Reply-To: <092c941b-a057-5cf0-97d8-0c061768dae7@intel.com>
References: <20220412102753.670867-1-poros@redhat.com>
         <092c941b-a057-5cf0-97d8-0c061768dae7@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob Keller píše v Út 12. 04. 2022 v 09:58 -0700:
> 
> 
> On 4/12/2022 3:27 AM, Petr Oros wrote:
> > We need to wait for EMP reset after firmware flash.
> > Code was extracted from OOT driver and without this wait
> > fw_activate let
> > card in inconsistent state recoverable only by second
> > flash/activate
> > 
> > Reproducer:
> > [root@host ~]# devlink dev flash pci/0000:ca:00.0 file
> > E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bi
> > n
> > Preparing to flash
> > [fw.mgmt] Erasing
> > [fw.mgmt] Erasing done
> > [fw.mgmt] Flashing 100%
> > [fw.mgmt] Flashing done 100%
> > [fw.undi] Erasing
> > [fw.undi] Erasing done
> > [fw.undi] Flashing 100%
> > [fw.undi] Flashing done 100%
> > [fw.netlist] Erasing
> > [fw.netlist] Erasing done
> > [fw.netlist] Flashing 100%
> > [fw.netlist] Flashing done 100%
> > Activate new firmware by devlink reload
> > [root@host ~]# devlink dev reload pci/0000:ca:00.0 action
> > fw_activate
> > reload_actions_performed:
> >     fw_activate
> > [root@host ~]# ip link show ens7f0
> > 71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq
> > state DOWN mode DEFAULT group default qlen 1000
> >     link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
> >     altname enp202s0f0
> > 
> > dmesg after flash:
> > [   55.120788] ice: Copyright (c) 2018, Intel Corporation.
> > [   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status
> > = -5, continuing anyway
> > [   55.569797] ice 0000:ca:00.0: The DDP package was successfully
> > loaded: ICE OS Default Package version 1.3.28.0
> > [   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
> > [   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
> > [   55.647348] ice 0000:ca:00.0: PTP init successful
> > [   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware,
> > max number of TCs supported on this port are 8
> > [   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in
> > SW mode.
> > [   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the
> > hardware
> > [   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe
> > bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0
> > (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
> > Reboot don't help, only second flash/activate with OOT or patched
> > driver put card back in consistent state
> > 
> > After patch:
> > [root@host ~]# devlink dev flash pci/0000:ca:00.0 file
> > E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bi
> > n
> > Preparing to flash
> > [fw.mgmt] Erasing
> > [fw.mgmt] Erasing done
> > [fw.mgmt] Flashing 100%
> > [fw.mgmt] Flashing done 100%
> > [fw.undi] Erasing
> > [fw.undi] Erasing done
> > [fw.undi] Flashing 100%
> > [fw.undi] Flashing done 100%
> > [fw.netlist] Erasing
> > [fw.netlist] Erasing done
> > [fw.netlist] Flashing 100%
> > [fw.netlist] Flashing done 100%
> > Activate new firmware by devlink reload
> > [root@host ~]# devlink dev reload pci/0000:ca:00.0 action
> > fw_activate
> > reload_actions_performed:
> >     fw_activate
> > [root@host ~]# ip link show ens7f0
> > 19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq
> > state UP mode DEFAULT group default qlen 1000
> >     link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
> >     altname enp202s0f0
> > 
> 
> Ahh.. good find. I checked a bunch of places, but didn't check here
> for
> differences. :(
> 
> For what its worth, I checked the source history of the out-of-tree
> driver this came from. It appears to be a workaround added for fixing
> a
> similar issue.
> 
> I haven't been able to dig up the full details yet. It appeares to be
> a
> collision with firmware finalizing recovery after the EMP reset.
> 
> Still trying to dig for any more information I can find.

Interesting time frame could be around this commit:
08771bce330036 ("ice: Continue probe on link/PHY errors")

Petr

> 
> > Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation
> > via devlink reload")
> > Signed-off-by: Petr Oros <poros@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> > b/drivers/net/ethernet/intel/ice/ice_main.c
> > index d768925785ca79..90ea2203cdc763 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -6931,12 +6931,15 @@ static void ice_rebuild(struct ice_pf *pf,
> > enum ice_reset_req reset_type)
> >  
> >         dev_dbg(dev, "rebuilding PF after reset_type=%d\n",
> > reset_type);
> >  
> > +#define ICE_EMP_RESET_SLEEP 5000
> >         if (reset_type == ICE_RESET_EMPR) {
> >                 /* If an EMP reset has occurred, any previously
> > pending flash
> >                  * update will have completed. We no longer know
> > whether or
> >                  * not the NVM update EMP reset is restricted.
> >                  */
> >                 pf->fw_emp_reset_disabled = false;
> > +
> > +               msleep(ICE_EMP_RESET_SLEEP);
> >         }
> >  
> >         err = ice_init_all_ctrlq(hw);
> 

