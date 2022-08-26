Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628355A2336
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbiHZIie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343703AbiHZIiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:38:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF8CD59BA
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:37:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id tl26so1096437ejc.9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jykyR+zf1I30R4yEDUKU/XEKf3ZCKoFRCjj/vhhKdZA=;
        b=Lbg2Oxce/DmSaPuWlaoNRrZmUvZxHDfKwD/2rYgJHBwgTM/ScONAuUs1LiB3ipQBRk
         +ATgmcZ0ClrL0bDyPd8t+qSpgrmEcgejCdmLk2IBfOmnRuZnGCTfBS3ITilQ9FVOpdxP
         HD4/5rU8g94XKC/nKNOZX2XNOtIDus8n7AsJb+02CwibtpQLifOrahomUk/ca6NZ3gMf
         njFo6kChEqv+0Q5ClWhrwTSqtOYiVRBHWZ8+xK+klh2jQGKdTNnb3boYMN5n4fBGD+ZZ
         Ip70LTwnF9XLEW8cflkGCMyEhC0GWbLz0UEcQb5CTciXGKoNEiIiHfkDvn0jcIXD5aTO
         /3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jykyR+zf1I30R4yEDUKU/XEKf3ZCKoFRCjj/vhhKdZA=;
        b=J3mRXLOrtb0YXIE3MV8waWmtVH6Isa5VA+u09ySgFuk/tCqh5S06zE9LZAG6JtcM5F
         cUUfb5oKXDy6GlkMD9h5WW5zfmKwxeYkHwyv3IBQR+MbQOmVLSV3lSrVV+aMt2WoRkrE
         RUqk+CM8c7W0uZbIR+4KQfYWYckHlqarb68cOM0C/+68Nr5IRBdIINUESUnLuUdojDo5
         CvKwlesK+ZLmZsr4hXCy2hJM7WuJy6a0O07d7ea3uEPaHxGWKe1BX1PTomaQahlLa/Gv
         BSn4GEJPXvA1JJJwIpQgP7GSiig8xmRo0R04l1ArGuyVf98GDfZWpV6eHbS54cBBPVzZ
         LXLw==
X-Gm-Message-State: ACgBeo103eMYRJlP6owz+sNbuZT0XcsraMle2SbAhLa6etoDzhGSpi0d
        oF19aQQrRAaOm+1NVUs4fpIUKQ==
X-Google-Smtp-Source: AA6agR5nvowmkeFxPyjFKmiSmds1PiSN1vbHlJRBgUpT3bDWmXZ+18rGOD/4KKUIrNVfv6VMeQMmyg==
X-Received: by 2002:a17:907:3da4:b0:73c:d2f4:a633 with SMTP id he36-20020a1709073da400b0073cd2f4a633mr4882349ejc.446.1661503074227;
        Fri, 26 Aug 2022 01:37:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id lb3-20020a170907784300b00730df07629fsm601930ejc.174.2022.08.26.01.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 01:37:53 -0700 (PDT)
Date:   Fri, 26 Aug 2022 10:37:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next 6/7] net: dsa: don't do devlink port setup early
Message-ID: <YwiGX98N8yRqT/V8@nanopsycho>
References: <20220825103400.1356995-1-jiri@resnulli.us>
 <20220825103400.1356995-7-jiri@resnulli.us>
 <20220825224724.nwnczlksk3bgg3v3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825224724.nwnczlksk3bgg3v3@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 12:47:24AM CEST, olteanv@gmail.com wrote:
>On Thu, Aug 25, 2022 at 12:33:59PM +0200, Jiri Pirko wrote:
>> Note there is no longer needed to reinit port as unused if
>> dsa_port_setup() fails, as it unregisters the devlink port instance on
>> the error path.
>> @@ -957,8 +941,6 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
>>  	dsa_switch_unregister_notifier(ds);
>>  
>>  	if (ds->devlink) {
>> -		dsa_switch_for_each_port(dp, ds)
>> -			dsa_port_devlink_teardown(dp);
>>  		devlink_free(ds->devlink);
>>  		ds->devlink = NULL;
>>  	}
>> @@ -1010,11 +992,8 @@ static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
>>  	list_for_each_entry(dp, &dst->ports, list) {
>>  		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
>>  			err = dsa_port_setup(dp);
>> -			if (err) {
>> -				err = dsa_port_reinit_as_unused(dp);
>> -				if (err)
>> -					goto teardown;
>> -			}
>> +			if (err)
>> +				goto teardown;
>>  		}
>>  	}
>
>Please don't delete this, there is still a need.
>
>First of all, dsa_port_setup() for user ports must not fail the probing
>of the switch - see commit 86f8b1c01a0a ("net: dsa: Do not make user
>port errors fatal").

Got it, will leave the unused port here. I will just use
dsa_port_setup() to init it. Something like:

  	list_for_each_entry(dp, &dst->ports, list) {
  		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
  			err = dsa_port_setup(dp);
			if (err) {
				dp->type = DSA_PORT_TYPE_UNUSED;
				err = dsa_port_setup(dp);
				if (err)
					goto teardown;
			}
  		}


>
>Also, DSA exposes devlink regions for unused ports too - those have the
>{DSA_PORT_TYPE,DEVLINK_PORT_FLAVOUR}_UNUSED flavor.

Yep.


>
>I also see some weird behavior when I intentionally break the probing of
>some ports, but I haven't debugged to see exactly why, and it's likely
>I won't have time to debug this week.

Nevermind. Will wait until you have time to test it. Thanks!

