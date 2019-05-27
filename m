Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF662B675
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfE0Ndb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:33:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55842 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfE0Ndb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 09:33:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id u78so3341748wmu.5
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 06:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F+FptfRjbrCVQX/LekX1svHk/Zk6ikkaVuLOvGkNJfU=;
        b=IBeUYKTImpUhMJ/hYG074WD68wPvaghIGz3Ga9vEA1H1DOE06Z9OVc1NAzULdwkwTR
         baolD3cm+DnEiR4wS+DaBVkaPDFqfFay600FNy4tpBHR0IZ7tjKHA/p33cgN20z7j9i+
         BuwFMNl/HZD9dx+P/o2eXZT602WI0zWImSz3AR0w4MR5cKV04jTAm929aKLeC7JZwTAH
         jmace950+v8rdHnjk2LjKa9WJfehLXL/wzKsONKEyz8cqrXD4KR8QpMgrDcMZCpg1MHr
         pwEGb5OcUFP46rQFIHgBbkJDdmIt6ggYQ2TJZp+Il2qjElMk3tyZ1jlL/1J1+FL2wRJC
         UwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F+FptfRjbrCVQX/LekX1svHk/Zk6ikkaVuLOvGkNJfU=;
        b=fX4JuxDN9Cdek0u6J1gbOP8/f5IvrGRY5YLoVqlHCBKoUTacjM7Kg6FQaGHEhrctBo
         9Jzo7TD4fGWbJ3tDSI/FH1ipBHtGvu7vd+moHvNBo0hV+sc7V9vwboaZbFCmjWZbLy2e
         lbGhmfXfScX/6302YXw+BFWzkxFJ5rqU68IvUxZi/kTZ6cb0LGdLtWqzAc26HKGtXXCv
         S0lTYfj6XI2NJtOPWFaIA6YU9rUNnbM21D0kFvrn2oPE817ZISr8eo8AqmMpl9gDeR6e
         0s1RVODWhsoZ0JyF7ejM3eD0m1LW5DapfWLx8y8ukaklSFFJeqaLXcttBbpvCkTea3kv
         8wGQ==
X-Gm-Message-State: APjAAAXg7XNEV17zBHgMnqFgfQRGDoDxTzZVieasDzJ+lmsgvgR1p/DD
        KQz1XsOl6ZBv+LV+niEHLV9v4BEIIv0=
X-Google-Smtp-Source: APXvYqz2wmGhONoZnZrkdJsvxkzVGR/xTKoJ/ChKr9++P1PvoEfS1NNxf328SOisLUivDpszX57FQQ==
X-Received: by 2002:a7b:cbcc:: with SMTP id n12mr10455211wmi.167.1558964009064;
        Mon, 27 May 2019 06:33:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o6sm1253812wrv.22.2019.05.27.06.33.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 06:33:28 -0700 (PDT)
Date:   Mon, 27 May 2019 15:33:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Message-ID: <20190527133327.GA2236@nanopsycho.orion>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <20190523094510.2317-4-jiri@resnulli.us>
 <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
 <20190524081110.GB2904@nanopsycho>
 <20190524085446.59dc6f2f@cakuba.netronome.com>
 <20190524222635.GA2284@nanopsycho.orion>
 <20190524170852.4fea5e77@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524170852.4fea5e77@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 25, 2019 at 02:08:52AM CEST, jakub.kicinski@netronome.com wrote:
>On Sat, 25 May 2019 00:26:35 +0200, Jiri Pirko wrote:
>> Fri, May 24, 2019 at 05:54:46PM CEST, jakub.kicinski@netronome.com wrote:
>> >On Fri, 24 May 2019 10:11:10 +0200, Jiri Pirko wrote:  
>> >> Thu, May 23, 2019 at 05:19:46PM CEST, dsahern@gmail.com wrote:  
>> >> >On 5/23/19 3:45 AM, Jiri Pirko wrote:    
>> >> >> @@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>> >> >>  	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
>> >> >>  		pr_err("Firmware flash failed: %s\n",
>> >> >>  		       mlxfw_fsm_state_err_str[fsm_state_err]);
>> >> >> +		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
>> >> >>  		return -EINVAL;
>> >> >>  	}
>> >> >>  	if (curr_fsm_state != fsm_state) {
>> >> >>  		if (--times == 0) {
>> >> >>  			pr_err("Timeout reached on FSM state change");
>> >> >> +			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");    
>> >> >
>> >> >FSM? Is the meaning obvious to users?    
>> >> 
>> >> It is specific to mlx drivers.  
>> >
>> >What does it stand for?  Isn't it just Finite State Machine?  
>> 
>> I believe so.
>
>In which case it doesn't really add much, no?  I second David's request
>to make the messages as easy to understand as possible.  

Well, FSM is something that is used in the code and known. I would
change it to "finite state machine" (which I'm still not sure it
really is) but I don't believe that would bring more info to the user.
Well, nothing. On contrary, a MLX engineer might get confused if customer
sends him the message, because he is used to "FSM" :)

Same with "MFA2" in the other message. I only know it is the format
of the binary, have no clue what it actually stands for (other than
it is version 2).


>
>PSID for better or worse I have previously capitulated on, so I guess
>the ship has indeed sailed there :)
>
>$ grep -A4 psid -- Documentation/networking/devlink-info-versions.rst 
>fw.psid
>=======
>
>Unique identifier of the firmware parameter set.
