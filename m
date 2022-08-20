Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C6C59AB84
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 07:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbiHTFrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 01:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243288AbiHTFrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 01:47:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD04CAC76
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 22:46:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qn6so12242744ejc.11
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 22:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=LDH4PX8EuUFutdwVTpT5mdBRug1m//ps5OiiWm9q4vQ=;
        b=NUCyUEJ36sj6mf+TvOX9MsaZoI410gRy5GXfpKOU7CHqQUxn19zBS5Lbg/JrygFtqi
         eoNaE0TZXKPSjRgRICcBmPZtk0APJmTgUtSXVDxmoDT9VL84mRNlrZWyJbJ9mIKikdW3
         yhBRGGZku3RmmLKNwQNkUNecKMfMYOCa3pTlUZp+9sUr/Axa1wP8fQkJfZUYmlTnTXs8
         ECUb/F1cmBIRXMGA3CUQoqg5/Nsf/9sRroAUpoyl3T0CvEPi+pBzhRXhn+bUAGZFObvo
         nQTV6L0vxuhn1OyEdPHN1CwDn9ieAk6QtT6/Yi5ivfeDydn8JfnPeDRi+ShmBeJ1uC6f
         vEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=LDH4PX8EuUFutdwVTpT5mdBRug1m//ps5OiiWm9q4vQ=;
        b=tFsrnuzFKfEoGivJ27c+7x7JYy1mZDZvniGNxFKaYueErUG4OTVVm3kv/rfd9HZTHy
         LK/cyyZk6obMl7gIIqDV2fH68hBS4mAGB918uafZN0CB5m2tFJAo9EvnsUdQ1JCQ3J/B
         PHO4xEN65au17wdA2As6kgFKwJo4cKTUCu+wvILkFriyQRFhZxevNPHn0GsPCUqHBmV0
         DdpG4wMHkczfhmwnUtlWiJKv2DvdtQ0bJWYNTnmPPWqdrdnD97AfIFgrTEbdrFv98Acr
         xsQamLuKUfSrOuxMe+rs50SV3YUdB9V17LUeQR/qREYEAIplFUxb1bMV0vyhv2NuLNjW
         1+8A==
X-Gm-Message-State: ACgBeo0NE/NENX4Md3YszwMDwIVm4S6JKhw/CjFbvlMfkbuamC3V8ltL
        +qhDH4PfKAlPrOEz0kMR3/50DA==
X-Google-Smtp-Source: AA6agR4vtlgNSoY4W1p7OMs9ZJsxvBwgbplwQvyTR4YSomM0CaPvzPMrVFwgg5rSo9DLuauylhB7LQ==
X-Received: by 2002:a17:907:7d8c:b0:731:65f6:1f28 with SMTP id oz12-20020a1709077d8c00b0073165f61f28mr6611331ejc.91.1660974416702;
        Fri, 19 Aug 2022 22:46:56 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b2-20020a05640202c200b00440ced0e117sm4080487edx.58.2022.08.19.22.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 22:46:56 -0700 (PDT)
Date:   Sat, 20 Aug 2022 07:46:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <YwB1T8GJgi+dezIH@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818130042.535762-5-jiri@resnulli.us>
 <20220818195301.27e76539@kernel.org>
 <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220819144545.1efd6a04@kernel.org>
 <CO1PR11MB5089655E5281C29FA1AC19BAD66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5089655E5281C29FA1AC19BAD66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 20, 2022 at 12:07:41AM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Friday, August 19, 2022 2:46 PM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org; davem@davemloft.net;
>> idosch@nvidia.com; pabeni@redhat.com; edumazet@google.com;
>> saeedm@nvidia.com; vikas.gupta@broadcom.com; gospo@broadcom.com
>> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update target
>> 
>> On Fri, 19 Aug 2022 20:59:28 +0000 Keller, Jacob E wrote:
>> > > My intuition would be that if you specify no component you're flashing
>> > > the entire device. Is that insufficient? Can you explain the use case?
>> > >
>> > > Also Documentation/ needs to be updated.
>> >
>> > Some of the components in ice include the DDP which has an info
>> > version, but which is not part of the flash but is loaded by the
>> > driver during initialization.
>> 
>> Right "entire device" as in "everything in 'stored'". Runtime loaded
>> stuff should not be listed in "stored" and therefore not be considered
>> "flashable". Correct?
>
>Yes I believe we don't list those as stored.
>
>We do have some extra version information that is reported through multiple info lines, i.e. we report:
>
>fw.mgmt
>fw.mgmt.api
>fw.mgmt.build
>
>where the .api and .build are sub-version fields of the fw.mgmt and can potentially give further information but are just a part of the fw.mgmt component. They can't be flashed separately.

Yep, in my patchset, this is accounted for. The driver can say if the
"version" is flashable (passed as a compenent name) or not. In this case,
it is not and it only tells the user version of some fw part.

>
>Thanks,
>Jake
