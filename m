Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24CD4D7818
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiCMUEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 16:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCMUEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 16:04:35 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C6F2A731;
        Sun, 13 Mar 2022 13:03:26 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v4so12695753pjh.2;
        Sun, 13 Mar 2022 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oTB3z/CiYe0gCHLWrVeh5ooeKA/UKcP9DlP2m+aGfiY=;
        b=CNSM9PjsdUbDPcIBkhCHccSnKdLXn5flnVEFDssiyCrpqPjnCEKE6eVl0qY5GRoCPE
         v9GPmKBncaVTFelOPgQ3rIesYEHPRv+Zeerpw3aiGoGqbdbYpnsOlj2+jNRLVUC1hTjf
         yaU1MGDtRPA1y+aChybxrWVlZ1+qvEALmu6UPZQmOeXAaSFYoS+05xRtgqUdcQI49R8/
         pW+hkDcmHnLltIje9lgyF7ywutUZwqT7v5yoM8My4q2ZVOwBb/6j/AhMrK1VRNxcPuSa
         F92k5+4KHS2wr1t1rbKh2dqMnm9UqOTtQ8kZpSecLYwbVo1yJD1Dt55bhKdhES8C+u3Q
         0b7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oTB3z/CiYe0gCHLWrVeh5ooeKA/UKcP9DlP2m+aGfiY=;
        b=VD4k7qszP2dTOkVi05M3U/3JCWYd39Q0yNYTqZZ+LqUDm2CqFvCScdXS84uHCOw0Nw
         R1mzc5ziyYMDZ2eh9aTaDpdOFymvJ0Cfy66D2BmoPfT99JDMTyjx3VxiLak0SMVBP1I7
         Y4uo2kuPLLw0m28NY3dqoZFNHSGxhQWbWXMQisOI9bMNzrNhyEJiGLHB+MELfX0eUAqk
         t+SPcWqW2XKNkyV58JLu54QzdAhnZrazdJJU7PLfq7npy2BfobsrSBaLtTYhSzsZFu+y
         PwvL4PU7k9+72Mk8mcPBVBxgdw34szES4Aamc/wnBKnQCJ34yXi7xs9c2pJK3rC/N8aU
         aEzw==
X-Gm-Message-State: AOAM532i+3N9o/6ciF55/JOvFnzcN5/yt6fboVHVtfODp3UlP++z5c1j
        Eh0TtCGpJm1GOdFTdR3zycQ=
X-Google-Smtp-Source: ABdhPJxVdfz0Y0lmH9JUhsldGJMADHRSMV73ZZRZY2+qKusip6IU/Rf27ybRMVpusNwzCUnwthrWVA==
X-Received: by 2002:a17:902:ab43:b0:153:29c8:38da with SMTP id ij3-20020a170902ab4300b0015329c838damr16014833plb.11.1647201805961;
        Sun, 13 Mar 2022 13:03:25 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id nn15-20020a17090b38cf00b001b90c745188sm15048671pjb.25.2022.03.13.13.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 13:03:25 -0700 (PDT)
Date:   Sun, 13 Mar 2022 13:03:22 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Woojung.Huh@microchip.com,
        linux@armlinux.org.uk, Horatiu.Vultur@microchip.com,
        Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220313200322.GC7471@hoboy.vegasvil.org>
References: <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
 <20220312024828.GA15046@hoboy.vegasvil.org>
 <Yiz8z3UPqNANa5zA@lunn.ch>
 <20220313024646.GC29538@hoboy.vegasvil.org>
 <Yi4IrO4Qcm1KVMaa@lunn.ch>
 <20220313193744.6gu6l2mjj4r3wj6x@den-dk-m31684h>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313193744.6gu6l2mjj4r3wj6x@den-dk-m31684h>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 08:37:44PM +0100, Allan W. Nielsen wrote:
> On Sun, Mar 13, 2022 at 04:07:24PM +0100, Andrew Lunn wrote:
> > On Sat, Mar 12, 2022 at 06:46:46PM -0800, Richard Cochran wrote:
> > > On Sat, Mar 12, 2022 at 09:04:31PM +0100, Andrew Lunn wrote:
> > > > Do these get passed to the kernel so the hardware can act on them, or
> > > > are they used purely in userspace by ptp4l?
> > >
> > > user space only.
> I'm wondering if one-step will work if these correction values are not
> applied to HW.

They are applied to the time stamps that are available to the
program.  So, no, they obviously won't be applied to one step Sync.
But then again, neither will the driver values.

(You could imagine a HW tstamp unit that includes a correction factor,
for example by adding the egress time stamp value to the correction
field.  But there are no APIs for that, and maybe no HW either.)

(BTW one step is overrated IMO)

Thanks,
Richard

