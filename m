Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037512A120
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404379AbfEXW0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:26:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36733 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404287AbfEXW0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:26:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id v22so3330248wml.1
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HDDYYPXPbeE0ekcTCqDzaZ3kAYxBiZVPe3O36mC4kF4=;
        b=KABMGPwfPCiW/DudvVMx/YGyRjLc3X8Px/OIAvQU4mB5oPec1JFiP1PWUkHXUbs1pw
         xWA15BSX+IsQkBwDet5JhN9FsOVEWClM7rjPaZIssnGVKajiQU8isMQm5mNg5qM5jBzK
         gSaA8bzzV3ombJJ1uZee7wtRuIW7Br15xm+ugjaCoKLxje4wATeQenaXHvv7qJmSXSPZ
         URfh7sFuHSn49Zeon/7MrUNfyWLDGveVPt2sfIReYwfy2pYm3witC+MITwF5bHdNW/8Q
         WxeHof8h8zozczIyycpRI+/j3occ1PxKbv7eJzcD/7WbxwuwLoisSX4ZJjqntn2CKWjb
         /NZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HDDYYPXPbeE0ekcTCqDzaZ3kAYxBiZVPe3O36mC4kF4=;
        b=oYde1c00g+vpsSABfOGNm/WAPRUKqalUdmk5TNm7RwZlYKYBgPSzxcBXwPKUlMs2CK
         taDRTE2MT0gDGpCjOZndySBpWWyZepP017riC1Ggy5bEILD1lOUiZTnpgckyUzeBF/Rr
         1AbHeGvEm/col1tI742EgpkVGSWWXuYOkaG+0c289USjPf20wEjtKt6HDoq1O9sJR4Cq
         UhBVV+TjWh67As+p41u6Kln1CF8lIh3K7C73hXjU1D5W4bCuEuEpQTJTZgN3wDvTDVah
         riiqXO2J+8iKyCFTm8HZxzE0PR71mSqmcmkblyVbBN9SCZP9NgFKnfX4zglAYf0PYzU1
         Tp1Q==
X-Gm-Message-State: APjAAAVPK9z/5byUI8pUq30vyeouO19O+7+No21lhvo3euKlMTdRI1J7
        kUPikzft2fmwy+JIWavsrojmWgZ2BjE=
X-Google-Smtp-Source: APXvYqzyCK01ZwQSQubZnBjV4cYHMsRwlHVBwoWl4ZyfcZAa/ouqloC5Pn/dVQH0fWM+S16M5CtfQg==
X-Received: by 2002:a1c:9dc7:: with SMTP id g190mr17133921wme.121.1558736796576;
        Fri, 24 May 2019 15:26:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z1sm2387083wrl.91.2019.05.24.15.26.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 15:26:35 -0700 (PDT)
Date:   Sat, 25 May 2019 00:26:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Message-ID: <20190524222635.GA2284@nanopsycho.orion>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <20190523094510.2317-4-jiri@resnulli.us>
 <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
 <20190524081110.GB2904@nanopsycho>
 <20190524085446.59dc6f2f@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524085446.59dc6f2f@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 24, 2019 at 05:54:46PM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 24 May 2019 10:11:10 +0200, Jiri Pirko wrote:
>> Thu, May 23, 2019 at 05:19:46PM CEST, dsahern@gmail.com wrote:
>> >On 5/23/19 3:45 AM, Jiri Pirko wrote:  
>> >> @@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>> >>  	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
>> >>  		pr_err("Firmware flash failed: %s\n",
>> >>  		       mlxfw_fsm_state_err_str[fsm_state_err]);
>> >> +		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
>> >>  		return -EINVAL;
>> >>  	}
>> >>  	if (curr_fsm_state != fsm_state) {
>> >>  		if (--times == 0) {
>> >>  			pr_err("Timeout reached on FSM state change");
>> >> +			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");  
>> >
>> >FSM? Is the meaning obvious to users?  
>> 
>> It is specific to mlx drivers.
>
>What does it stand for?  Isn't it just Finite State Machine?

I believe so.
