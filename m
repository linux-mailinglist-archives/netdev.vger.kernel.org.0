Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4639D33A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFGDDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:03:41 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:45024 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGDDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:03:40 -0400
Received: by mail-oi1-f174.google.com with SMTP id d21so16629333oic.11
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 20:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TrgXEL5Zz3Q/eVgntwq+0Ec6TCerq/nYUKCc31b3azM=;
        b=f9lM+Tb0B/mvNfst+5K4CubDUtHVzIgiaCfA3wCO091stUFLWPiOZVqMpzElbQh/RE
         1Z1jskiYtGyTN3tMiKVKMSnyobWwRJoSWkUhrdzxDMDoul/PV2NXdMNxkIpsNcNRJfFL
         ukM+hT/Uml4DfWv2l6YKwWHuIno3Wmxppu7UMa07mFM0A6bnVY1dJLlgqEwvq3GE6PvD
         HMwNzrE/DDaOlBE9t5SqZzDBNDs8ArDo+JhY4aJVyq+4NnJ6FoonzB5IwgoGAHdBpS00
         QZAFsTv5t+WdqIGp+IzBvfM806nfdE+BmmvGMqIZ+IKVXbAGqWXzYpJ8+NX2cJDmQ9oR
         LCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TrgXEL5Zz3Q/eVgntwq+0Ec6TCerq/nYUKCc31b3azM=;
        b=XKQLtNdHP7qShekatrarvQVfbD9iMB5yP+AIahedgZH8wrzk3X+7Re6/UzJ5iBIdEK
         lYRRjwFGvuJpgSL0jIrey1qYhaBMx/Fhbqup/nENktFoN1P0TUr7Z9fERS2pggFhezRb
         ba8psyD+Z9fM6/prlEZRZ/GqQno6HrAyHKWdr1b+KjTm49E0QajzIy0LdaoKjd62z6m7
         mq78OFC/b2DDaDtdp24zDO5SQ6rZTnfJBKjW58CUIxSGXFYLsFnaWDhlFQEDLGkVAEJP
         tHTsaOc2JPR9/bx9o5amvyEy4JeYe1TUmbG93Xf5vl3RKSzNZhyDzYN1686m3B4iM5hT
         nljA==
X-Gm-Message-State: AOAM533phhFHoZ655jnBykR3XTN+lx6mywI4qOH7ayzw1RJ+3EMQhqIr
        XKn+p6kys3Go6e/d1cFEGaQ=
X-Google-Smtp-Source: ABdhPJz55MQReol/fosw5Lekx1BennXGD27/NNFctk7Zf3lfXsqj1/x8WDdKyvaaadqD6xujhf0Rmw==
X-Received: by 2002:aca:bd42:: with SMTP id n63mr17412555oif.73.1623034835801;
        Sun, 06 Jun 2021 20:00:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id c11sm657637oot.25.2021.06.06.20.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 20:00:35 -0700 (PDT)
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210603111901.9888-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
Date:   Sun, 6 Jun 2021 21:00:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210603111901.9888-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/21 5:19 AM, Parav Pandit wrote:
> @@ -3795,7 +3806,7 @@ static void cmd_port_help(void)
>  	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>  	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
>  	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
> -	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
> +	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>  	pr_err("       devlink port del DEV/PORT_INDEX\n");
>  }
>  
> @@ -4324,7 +4335,7 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port);
>  
>  static void cmd_port_add_help(void)
>  {
> -	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
> +	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");

This line and the one above need to be wrapped. This addition puts it
well into the 90s.


