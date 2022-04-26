Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADCF50FD2A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344533AbiDZMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiDZMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:40:12 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B65614E
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:37:02 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso1438157wms.2
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=exJ1slP1giieouQ+R6UZC5W7jwl0xbu4hzQX+sG1DrM=;
        b=xkegvu80mlhtaorwyFYtI27Zuv2sU+uFehR/JnQ/8IOe1lvdx6T7nsimoFGXlvEwR9
         PuPdlkdw61c91KM8hIowgOSTdRB0DE4ElRBrL/G2LGUpqJSTLg2gRNMhRVaZFUzAOgP9
         XtoaJOtgd7BZ0QAqg4AbL4m90sNclJ10YXPQdwQeBbgUoTbCSuCK841eeH4jxMpEsLqY
         yC4h25+Fpp1eKPXWZ7ibty8SHrqHGbKhw+uoVLjmyBkvprkM6TIF2jYkiJj3SWd02gYa
         vSTLQjlyyGlC5YEi4lMBjUayZFT3RM4tSfNQWFn+++yHxPSGRd27SvoZVdLP1UhyzeHX
         ajnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=exJ1slP1giieouQ+R6UZC5W7jwl0xbu4hzQX+sG1DrM=;
        b=4QBKXIIFp86tw6O5QJc7zBH9nwgv5nw+sGE+hmYfNgrIemvHTboGYwIm+oKfiE1xIe
         sxBP77qmdf2XX6ItXMiq3vXuNxyzWeaTB9dwJSMjVPVJjeNAsIECX/6pQI/qMXmX7Y6n
         6cNP77qm56uY8BJ/FhRKuOpGYK/mRrzsQLD2CixsDKt6fSPSdg30UDQymJDebAEPUnm9
         IA7fVSF6wO4PEv/bom5jiCXNhIjq1v8cE840Q4wUG3reCtri5hNSMyMrwEE+IP40BF6o
         MFSHsJOg8TUI++lR5LaTLHg0r/DCCyO6kKO4RiZIOP3ZDgpVd/kru+NosVd1Xp6sasnf
         2JFA==
X-Gm-Message-State: AOAM533+90k6HXQDSgQvEVOvh4Z97kzgepPiwY7D/U8tuvjXMuuSewHi
        rnp453X8Sw8D8hCXTeFX8mPBK8Lrof5jsTru
X-Google-Smtp-Source: ABdhPJzx3lnwiqz/xrfgLVuTGrGefXUgjqJ0t28uIOybqhG+7NRqFNmC+Kop+/gzkVhmMg5y/EKEpw==
X-Received: by 2002:a1c:f211:0:b0:381:6c60:742f with SMTP id s17-20020a1cf211000000b003816c60742fmr21915551wmc.130.1650976620932;
        Tue, 26 Apr 2022 05:37:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y9-20020a05600015c900b0020adb0e106asm6924497wry.93.2022.04.26.05.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 05:37:00 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:36:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmfnagAJXolPjAi/@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <Ymfhf9aS0Rc/rhN2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymfhf9aS0Rc/rhN2@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 02:11:43PM CEST, andrew@lunn.ch wrote:
>> >> The idea (implemented in the next patchset) is to let these devices
>> >> expose their own "component name", which can then be plugged into the
>> >> existing flash command:
>> >> 
>> >>     $ devlink lc show pci/0000:01:00.0 lc 8
>> >>     pci/0000:01:00.0:
>> >>       lc 8 state active type 16x100G
>> >>         supported_types:
>> >>            16x100G
>> >>         devices:
>> >>           device 0 flashable true component lc8_dev0
>> >>           device 1 flashable false
>> >>           device 2 flashable false
>> >>           device 3 flashable false
>> >>     $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0
>> >
>> >IDK if it's just me or this assumes deep knowledge of the system.
>> >I don't understand why we need to list devices 1-3 at all. And they
>> >don't even have names. No information is exposed. 
>> 
>> There are 4 gearboxes on the line card. They share the same flash. So if
>> you flash gearbox 0, the rest will use the same FW.
>
>Is the flash big enough to hold four copies of the firmware? Listing

One copy, all 4 are using it.


>all four devices gives you a path forward to allowing each device to
>have its own firmware.

Yes.

>
>On the flip side, flashable false is not really true. I don't know
>this API at all, but are there any flags? Can you at least indicate it
>is shared? You could then have an output something like:

Yes, that I can do.

>
>           device 0 flashable true shared component lc8_dev0
>           device 1 flashable true shared component lc8_dev0
>           device 2 flashable true shared component lc8_dev0
>           device 3 flashable true shared component lc8_dev0
>
>so you get to see the sharing relationship.

Agreed.

>
>   Andrew
