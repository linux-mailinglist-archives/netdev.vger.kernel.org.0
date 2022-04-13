Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09154FF174
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiDMIMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiDMIML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:12:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F4A64DD;
        Wed, 13 Apr 2022 01:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C83ECB820FD;
        Wed, 13 Apr 2022 08:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D09C385A4;
        Wed, 13 Apr 2022 08:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649837388;
        bh=7dRvLs/Squ22R+scDlSG9re8YSadv6HhAtuiD/awykQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Kshi/SnmDVYPCGpaw4/TRZPxJODVaWZYlavAwmIkJVPei0A6X2fmhxTjXeSUQ3568
         Xv9HmI6mPkFZnFXjmQSmX2dIA0tRzRgPVuqCnYZ2jo67rmsDS5wZhJh/EX5rgdg9x9
         /Qwcf8JTSKJ2i8wCmdvpcxy5/sO/VX7fso7C7iplwfhowdIcBCqksgtSAOjm69CIBi
         6fL/wp0Jd2ZB4GTYsykdck3IeAOn0WaYIK9opgcdmuN39YjCRI2P34sCEtT3JPioIT
         UVQYJpOGrHIBO//bSxpJaoa/sr/MWnwDjNh2wvzignKAw1Z/1WTnPKnOp9taVHTDwW
         uUNKzX9E7+xtA==
Message-ID: <c5b8606c-c729-cddb-8fff-6240453a88fb@kernel.org>
Date:   Wed, 13 Apr 2022 11:09:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC 13/13] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Puranjay Mohan <p-mohan@ti.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com, Grygorii Strashko <grygorii.strashko@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com> <Yk3fHzDsl1iNl9ah@lunn.ch>
 <080bf31d-a452-af0b-ca41-a6b3d951e18f@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <080bf31d-a452-af0b-ca41-a6b3d951e18f@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/04/2022 12:46, Puranjay Mohan wrote:
> +Roger, Grygorii
> 
> On 07/04/22 00:12, Andrew Lunn wrote:
>>> +config TI_ICSSG_PRUETH
>>> +	tristate "TI Gigabit PRU Ethernet driver"
>>> +	select TI_DAVINCI_MDIO
>>> +
>>
>> I don't see a dependency on TI_DAVINCI_MDIO in the code. All you need
>> is an MDIO bus so that your phy-handle has somewhere to point. But that
>> could be a GPIO bit banger.
>>
>> What i do think is missing here is a dependency on PHYLIB.

That is correct.

>>
>> If possible, it would be good to also have it compile when
>> COMPILE_TEST is set.
>>

Yes, that is a good idea.

cheers,
-roger
