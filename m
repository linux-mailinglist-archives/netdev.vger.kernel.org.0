Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9D59D167
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 08:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiHWGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbiHWGio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:38:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706EE2CDF2
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 23:38:42 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id q2so14624841edb.6
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 23:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=eMamWz8Ie1SSRj51k1XaHCt8x4Vc1FuEI/FUfzOuPS8=;
        b=5KcEClW/aNZEof7PwUdUuytXNhQJ1ZF7Yos7yLKwE6HLl8d2Ate2M8N0IIsuGNXIh+
         iBnQ0CGGX4QgTgsNbKQ4Ui7cNDjxbHc8R3tTsqI47CiOc3JQZKbQLZ7EFX7f9cLcoL8t
         hrIQQNFRp6NseBbVmLi8yUHfEMUEIjG5WrDaq+LwNAWzQ7mflhOx0zooGBp8qpeWLtw9
         0Gezw6SvsZVoXMy1vwqvkX71bt4tsFolMGS63OSXgdRLZy92+Ely6IxhnCguLoIRhFFn
         yek9bBxPfENm8cco3AcixqIW+H9IG2d3u+fzhQy+zUbIePVya0aaCtQNAPKOp6oMGGjp
         qhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=eMamWz8Ie1SSRj51k1XaHCt8x4Vc1FuEI/FUfzOuPS8=;
        b=b1gCX7Dup7k/9YasRk5cnwb2cbLlYfUbI0NAxJ/zEM/D4L/3MP/zifTqypxUmHot1j
         NCEPyp9LoTN4hkFO2JsDN5O3XrGHmh+h7n9FyF+vfU2MR+f82Jnv6eY0ZpATP/Y5u8CD
         JXduzIZkZb750KohJnOnEUasFkF3bl7OJ/aZ5Cp5PiY6IH2fHrahgOF6uRJ2laL8R645
         YnWlDjrwuLWmj5EvJpsE32Xc3nXFp/XwimIg1xj/vo6Gp/V5Ntv7gS6ynoe42LAUqd/6
         NEElUAh5PxRqdhth02aev9SZ4zVpWVd9pblCtMkH/NrV+y3tO0TQmZl1SmgNqkWE02GB
         mqIw==
X-Gm-Message-State: ACgBeo0JuEa199hjL21cfSZJ355Y0F1b3jberqx4JI2Zgv0fvHrbgKUs
        64X+3UqEquIyvkoSCkrjrpDXug==
X-Google-Smtp-Source: AA6agR7J4k2bkG09bhV2WEpgktUdmU7Is80s6XmJvGmZQ/HQeOBcIozGxX1QE6UE+m4pyk/gpHnMmA==
X-Received: by 2002:a05:6402:d57:b0:445:fba7:422d with SMTP id ec23-20020a0564020d5700b00445fba7422dmr2415519edb.138.1661236720711;
        Mon, 22 Aug 2022 23:38:40 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d6-20020a50fb06000000b0043a5bcf80a2sm859435edq.60.2022.08.22.23.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 23:38:39 -0700 (PDT)
Date:   Tue, 23 Aug 2022 08:38:38 +0200
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
Message-ID: <YwR17lo/0vI1WiAH@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818130042.535762-5-jiri@resnulli.us>
 <20220818195301.27e76539@kernel.org>
 <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220819144545.1efd6a04@kernel.org>
 <CO1PR11MB5089655E5281C29FA1AC19BAD66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <YwB1T8GJgi+dezIH@nanopsycho>
 <CO1PR11MB5089CDBD5B989C45FDA80B77D6719@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5089CDBD5B989C45FDA80B77D6719@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 22, 2022 at 07:09:35PM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Friday, August 19, 2022 10:47 PM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org;
>> davem@davemloft.net; idosch@nvidia.com; pabeni@redhat.com;
>> edumazet@google.com; saeedm@nvidia.com; vikas.gupta@broadcom.com;
>> gospo@broadcom.com
>> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update target
>> 
>> Sat, Aug 20, 2022 at 12:07:41AM CEST, jacob.e.keller@intel.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jakub Kicinski <kuba@kernel.org>
>> >> Sent: Friday, August 19, 2022 2:46 PM
>> >> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> >> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org;
>> davem@davemloft.net;
>> >> idosch@nvidia.com; pabeni@redhat.com; edumazet@google.com;
>> >> saeedm@nvidia.com; vikas.gupta@broadcom.com; gospo@broadcom.com
>> >> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
>> target
>> >>
>> >> On Fri, 19 Aug 2022 20:59:28 +0000 Keller, Jacob E wrote:
>> >> > > My intuition would be that if you specify no component you're flashing
>> >> > > the entire device. Is that insufficient? Can you explain the use case?
>> >> > >
>> >> > > Also Documentation/ needs to be updated.
>> >> >
>> >> > Some of the components in ice include the DDP which has an info
>> >> > version, but which is not part of the flash but is loaded by the
>> >> > driver during initialization.
>> >>
>> >> Right "entire device" as in "everything in 'stored'". Runtime loaded
>> >> stuff should not be listed in "stored" and therefore not be considered
>> >> "flashable". Correct?
>> >
>> >Yes I believe we don't list those as stored.
>> >
>> >We do have some extra version information that is reported through multiple
>> info lines, i.e. we report:
>> >
>> >fw.mgmt
>> >fw.mgmt.api
>> >fw.mgmt.build
>> >
>> >where the .api and .build are sub-version fields of the fw.mgmt and can
>> potentially give further information but are just a part of the fw.mgmt
>> component. They can't be flashed separately.
>> 
>> Yep, in my patchset, this is accounted for. The driver can say if the
>> "version" is flashable (passed as a compenent name) or not. In this case,
>> it is not and it only tells the user version of some fw part.
>> 
>
>I think we can just go with "is this flashable or not?" and then document that if no component is flashed, the driver should be flashing all marked components?
>
>Then we don't need a "default" since the default without component is to flash everything.

I dropped "default" from the patchset. We need to document the
semanticts for default at least. Is it always "everything"? Idk.

>
>> >
>> >Thanks,
>> >Jake
