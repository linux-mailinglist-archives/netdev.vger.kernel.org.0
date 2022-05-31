Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACD53970D
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347307AbiEaTes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345615AbiEaTer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:34:47 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290439AE70
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:34:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so28541629ejj.10
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vciXSjfaW02/VYEGr5Tq6nVv485zNM8/g3844G/87Lk=;
        b=Fiw1kO8Q/vQtbP+qcVJew7rjj5E5R/mhagZtdACfCHM0odpG0gWldk858blwB18SJs
         W0vyXwtQ2aAwVOpnb3nWWEibIbyshzWHr6TNIT/WXuJz5opIcyxvXoEuhpBef5ayEv8p
         RhzG2W+9q855HI0VYygPRt+qVF/Uj290IJr1hhQ30ssaI64qXAdthZliYJVJ/QAUN2Wb
         J6GdbBIzCLb8axjXG6fyF9etSLCv94k/Y72MMKRIsmNjysdBy3iW7PYEFb821OHoQfg1
         BnhO2Z6UuyQ02b2U9htMv6n6IFAn9sv51RXWnKFjMqgtpT4yLJ1XfLQcFOkVPqvqwZag
         D8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vciXSjfaW02/VYEGr5Tq6nVv485zNM8/g3844G/87Lk=;
        b=X2nkTUxdvXsMI/oylMahuJ1G+UGEnt1a7I2c0f/3pUHN3tBDHalVtq/71vVviJnx6+
         KvrjLHY3qRglREmrEsBB+UBg5jgl9LRtd+8a0ed6MxB3/QyNJPfi6BhaKn1VTCQVSzD/
         sFVLYF5ygwEqezx9hLm9XWboqjkjzIsQc6JMuDFeWMIL7FuU27S8WtCYc3YdDaCAoSxF
         n1Jx31Wn+YiC9UhG+ys/AGPfwgzg+UrOABin+9avpDwtFMZs15fNAcvFDglTxm2HVWZe
         glsvga0t/QyrcZiDa2b34TItZNpQtnzdguONgzk1yaIU46LqbRjlhDIV8JKOOPQrwAqO
         XWyw==
X-Gm-Message-State: AOAM5302T++BETNP78q/o/l6n9rjleU+3hoYOZVY8PGTAAw//u+SDE4v
        g8l9MTxV14IMmunAKFMlx1L08w==
X-Google-Smtp-Source: ABdhPJwPZukpQ3ix4bG0nIEo8KdV55XMSQss6EoDKQsazuSxKpcw0iDpvz/95Aprb7dZeQTmJZqRbg==
X-Received: by 2002:a17:907:3f92:b0:6ff:19ff:a528 with SMTP id hr18-20020a1709073f9200b006ff19ffa528mr27219305ejc.91.1654025684703;
        Tue, 31 May 2022 12:34:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k9-20020a50c089000000b0042617ba63c3sm8749129edf.77.2022.05.31.12.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 12:34:44 -0700 (PDT)
Date:   Tue, 31 May 2022 21:34:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpZt0mRaeZqrp4gU@nanopsycho>
References: <YpB9cwqcSAMslKLu@nanopsycho>
 <20220527171038.52363749@kernel.org>
 <YpHmrdCmiRagdxvt@nanopsycho>
 <20220528120253.5200f80f@kernel.org>
 <YpM7dWye/i15DBHF@nanopsycho>
 <20220530125408.3a9cb8ed@kernel.org>
 <YpW/n3Nh8fIYOEe+@nanopsycho>
 <20220531080555.29b6ec6b@kernel.org>
 <YpY5iKHR073DNF7D@nanopsycho>
 <20220531090852.2b10c344@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220531090852.2b10c344@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 31, 2022 at 06:08:52PM CEST, kuba@kernel.org wrote:
>On Tue, 31 May 2022 17:51:36 +0200 Jiri Pirko wrote:
>> Tue, May 31, 2022 at 05:05:55PM CEST, kuba@kernel.org wrote:
>> >> Group of what? Could you provide me example what you mean?  
>> >
>> >Group of components. As explained component has an existing meaning,
>> >we can't reuse the term with a different one now.  
>> 
>> I still don't follow. I don't want to reuse it.
>> Really, could you be more specific and show examples, please?
>
>What you had in your previous examples, just don't call it components
>but come up with a new term:
>
>$ devlink dev info
>pci/0000:01:00.0:
>  driver mlxsw_spectrum2
>  versions:
>      fixed:
>        hw.revision A0
>        fw.psid MT_0000000199
>      running:
>        fw.version 29.2010.2302
>        fw 29.2010.2302
>  groups? sections? subordinates? :                         <= here
>    lc1:
>      versions:
>        fixed:
>          hw.revision 0
>          fw.psid MT_0000000111
>        running:
>          fw 19.2010.1310
>          ini.version 4
>
>Note that lc1 is not a nest at netlink level but user space can group
>the attrs pretty trivially.

Awesome! I think now it is clearer. To be in sync with devlink dev
flash cmd option, we have to have "lc 1" here, have to think how that
can be done.


>
>> >> But to be consistent with the output, we would have to change "devlink   
>> >> dev info" to something like:                                             
>> >> pci/0000:01:00.0:                                                        
>> >>   versions:                                                              
>> >>       running:                                                           
>> >>         fw 1.2.3                                                         
>> >>         fw.mgmt 10.20.30                                                 
>> >>         lc 2 fw 19.2010.1310                                               
>> >
>> >Yup.  
>> 
>> Set, you say "yup" but below you say it should be in a separate nest.
>> That is confusing me.
>
>Ah, sorry. I hope the above is clear.
>                                                  
>> >> But that would break the existing JSON output, because "running" is an array:
>> >>                 "running": {                                             
>> >>                     "fw": "1.2.3",                                       
>> >>                     "fw.mgmt": "10.20.30"                                
>> >>                 },                                                         
>> >
>> >No, the lc versions should be in separate nests. Since they are not
>> >updated when flashing main FW mixing them into existing versions would
>> >break uAPI.  
>> 
>> Could you please draw it out for me exacly as you envision it? We are
>> dancing around it, I can't really understand what exactly do you mean.
>
>Why would I prototype your feature for you? I prefer a separate dl
>instance. If you want to explore other options the "drawing out" is
>on you :/

Well, you are basically leading my arm when I'm drawing the thing. Looks
like you exactly know what you are looking for. That is why.
If you let me to the stuff my way, we would be already done.
You have to decide which way you want this.

And again, for the record, I strongly believe that a separate dl
instance for this does not make any sense at all :/ I wonder why you
still think it does.


>
>> >> So probably better to stick to "lcx.y" notation in both devlink dev info
>> >> and flash and split/squash to attributes internally. What do you think?  
>> >
>> >BTW how do you intend to activate the new FW? Extend the reload command?  
>> 
>> Not sure now. Extending reload is an option. Have to think about it.
>
>😑
