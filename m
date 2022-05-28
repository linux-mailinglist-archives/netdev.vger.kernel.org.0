Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906CB536BC2
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiE1JJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 05:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiE1JJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 05:09:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548B7E9D
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 02:09:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id jx22so12527579ejb.12
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 02:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BY5yasMsqTfJMBQVF3Io3tLIhVmJ/LDXEwvEyAsm4RQ=;
        b=0k+SpiVsbqKEnVqV9lneGXNqV/kh7T75mOqkQKAcuHvNu3go0NFnOsunabxAPpCpUa
         eRofHCPEzDhsNKKV1NrVjSbQnYjLfiX+2HN+xrOC7C3yGiJO2IGTDh0+ugQ/zY7IIjgZ
         2Yf5SKw6Vk/g7SY7AQFA2kvTAlYVs5Xc33VpyfFh18JcflcFHzOzOhf1xqfaolUjDJo0
         WaT6Ktp3wNaQItMW2elCAR+ESKZWUIoXgZ8hHwqlbmo6e15E7sbzdDwYRMYWb9/nHZ+1
         NjtpxOZUk5ydgNAwgVxj+4LW0ugSEEYjUDedHnd6sRWOl0V/m/IVkCLTLDnhoJQ4QRch
         2Q3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BY5yasMsqTfJMBQVF3Io3tLIhVmJ/LDXEwvEyAsm4RQ=;
        b=Rx38/frtKNuMHYAMvgqjuwXFxk1qD7b6oEnsJFInAI97JARUw+8vKg3B2v27mfFNOu
         4rplylKl8f1pjy9TSgqzS8lL69bwrX9sG5ISSyuWOZP+f41lWj4j/L+YfETlu8zUJOjl
         tDkBy9zVtjPqmZ5Q00D5n/jLSE8cfQgmcBiLvn1lo9MPrpzLDeUKWg43ve6nL5/rzEIf
         yvmsyl7TwjqS2eEtXLdYHvkGZGx/rj/VTkWaQwP4l+aUl6XEzZC4Iie4HlaaXS2u2FAL
         4GAl/cU/piWebVkfX1ckuz2lEK3Og6P4whMZsBtf854PbfxH+P244MO7bNxQN6S82ULj
         NGmQ==
X-Gm-Message-State: AOAM532howbgKTFhx5OY4bRNWDAl0IDHvjqAbNIkHecM2Hd03LPzz/l7
        53IdUwqJW/sZpCj7Tth+tIFjlw==
X-Google-Smtp-Source: ABdhPJw/upP/XNBfFs4kfeJHh/O+WUvd07HRIz2HYUfQhGf+EYUiozsMAMFkmD66ir4HlWiMRjYPxw==
X-Received: by 2002:a17:907:3f9f:b0:6fe:f9e2:9c6a with SMTP id hr31-20020a1709073f9f00b006fef9e29c6amr23531670ejc.479.1653728943756;
        Sat, 28 May 2022 02:09:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q3-20020a50aa83000000b0042dc513ced8sm47275edc.30.2022.05.28.02.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 02:09:02 -0700 (PDT)
Date:   Sat, 28 May 2022 11:09:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpHmrdCmiRagdxvt@nanopsycho>
References: <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <20220524110057.38f3ca0d@kernel.org>
 <Yo3KvfgTVTFM/JHL@nanopsycho>
 <20220525085054.70f297ac@kernel.org>
 <Yo9obX5Cppn8GFC4@nanopsycho>
 <20220526103539.60dcb7f0@kernel.org>
 <YpB9cwqcSAMslKLu@nanopsycho>
 <20220527171038.52363749@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527171038.52363749@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 28, 2022 at 02:10:38AM CEST, kuba@kernel.org wrote:
>On Fri, 27 May 2022 09:27:47 +0200 Jiri Pirko wrote:
>> Okay. So the output of devlink dev info would be extended by
>> "components" nest. This nest would carry array of components which
>> contain versions. The name of the component is openin each array member
>> nest:
>> 
>> $ devlink dev info
>> pci/0000:01:00.0:
>>   driver mlxsw_spectrum2
>>   versions:
>>       fixed:
>>         hw.revision A0
>>         fw.psid MT_0000000199
>>       running:
>>         fw.version 29.2010.2302
>>         fw 29.2010.2302
>>   components:
>>     lc1:
>
>Is the "lc1" free-form or generated by the core based on subobjects?
>Is it carried as a string or object type + id?

It could be both:
1) for line cards I plan to have a helper to have this generated by core
2) for other FW objects, it is up to the driver.


>
>I guess my suggestion of a CLI mockup has proven its weakness :)

I'm not sure I understand what you mean by this sentence. Could you
please be more blunt? You know, my english is not so good to understand
some hidden meanings :)



>
>>       versions:
>>         fixed:
>>           hw.revision 0
>>           fw.psid MT_0000000111
>>         running:
>>           fw 19.2010.1310
>>           ini.version 4
>>     lc2:
>>       versions:
>>         fixed:
>>           hw.revision 0
>>           fw.psid MT_0000000111
>>         running:
>>           fw 19.2010.1310
>>           ini.version 4
>>     someothercomponentname:
>>       versions:
>>         running:
>> 	   fw: 888
>> 
>> Now on top of exsisting "devlink dev flash" cmd without component, user
>> may specify the component name from the array above:
>> 
>> $ devlink dev flash pci/0000:01:00.0 component lc1 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>> 
>> $ devlink dev flash pci/0000:01:00.0 component someothercomponentname file foo.bin
>> 
>> Note this is generic vehicle, line cards would benefit but it is usable
>> for multiple ASIC FW partitions for example.
>> 
>> Note that on "devlink dev flash" there is no change. This is implemented
>> currently. Only "devlink dev info" is extended to show the component
>> list.
>
>I sort of assumed that the DEVLINK_ATTR_INFO_VERSION_NAME is the
>component, the docs also use the word "component" for it. 

Okay, that I didn't see.

>
>For the nfp for instance we had "fw.app" for the datapath microcode and
>"fw.mgmt" for the control processor. These are separate partitions on
>the flash. I don't think we ever implemented writing them separately
>but it's certainly was our internal plan at some point.

Okay, so what you say it, we already have components in "devlink dev
info". Like you pointed out as an example:
  fw.app
  fw.mgmt
so the flash comment would be:
  devlink dev flash pci/0000:01:00.0 component fw.app file foo.bin
  devlink dev flash pci/0000:01:00.0 component fw.mgmt file bar.bin
?

If yes, what should be the default in case component is not defined? Do
we need to expose it in "devlink dev info"? How?

So to extend this existing facility with my line card example, we would
have:

$ devlink dev info
pci/0000:01:00.0:
   driver mlxsw_spectrum2
   versions:
       fixed:
         hw.revision A0
         fw.psid MT_0000000199
	 lc1.hw.revision 0
	 lc1.fw.psid MT_0000000111
	 lc2.hw.revision 0
	 lc2.fw.psid MT_0000000111
       running:
         fw.version 29.2010.2302
         fw 29.2010.2302
	 lc1.fw 19.2010.1310
	 lc1.ini.version 4
	 lc2.fw 19.2010.1310
	 lc2.ini.version 4

And then:
devlink dev flash pci/0000:01:00.0 component lc1.fw file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

Does this sound correct?

Also, to avoid free-form, I can imagine to have per-linecard info_get() op
which would be called for each line card from devlink_nl_info_fill() and
prefix the "lcX" automatically without driver being involved.

Sounds good?

Thanks!


