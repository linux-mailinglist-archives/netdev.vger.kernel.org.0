Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5723B128810
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 09:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfLUIHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 03:07:50 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:46350 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLUIHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 03:07:50 -0500
Received: by mail-wr1-f43.google.com with SMTP id z7so11496167wrl.13
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 00:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7l5mcqM5IiGLEzCF5SrA3gcmu7F9rmvjK3WHaZyOuvo=;
        b=sMfiqO/u+RtvfOm3Ea+klFYQhycMR/UKTTRzOcJ4UCLVLZ5qCLLTJDmLtyMWkAVjaW
         3ylIpIU/ZrLrHNzA3qVwJEs0MQBolmJ0AWr6Ah7LooWCvxEh72/qA8DmQC1AjJJCQQwS
         0/oNMd8D5oEtZRjVtH0axEjALxicr8VHdaqWv2yxwJ8dRqJHcdAgLbwahH/7Bn7zpBYt
         qsN7Xtyr4awfM8tlony3hH1RrgZVeY09Pp/cEHZXT9R9UB9aJJgQRbB/dVkv36Bthddg
         sPqn7X0dw4kxM68Ij5dP/UdF+ntE7YC0M0yKh0PmXvZqk40By9hhUDFdmpQi+TmhAxLR
         j54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7l5mcqM5IiGLEzCF5SrA3gcmu7F9rmvjK3WHaZyOuvo=;
        b=LMTFnBxnq6BA4AzYSz8Oh4IBXxjzuJVOf7IP4bBTMW6W2K2nFaOFbSEKhTSxVbVlKy
         zOqgpC43BFzKEWZHkrec3NMrhMG0A+vnttLOKuP+nFg+ScQ/l3lYYVOPaYQWS6sv0C/B
         DqHrtuUDFe7Z36E6rruQ3TY7XJHndLR5eUTKyh416LxAc7fdx6fp2plPmky3KC9pB8cd
         iEmSInNlVblIje8b6AikR+H3HR64FlEarhYNvcHf8LV8R7njjKVYtCHvujC6V5xPOH7a
         ZfAp0sJR7VBUmLhDMR7sdlmnQz7rFmGhIgsi4705GbD1bhYksRq/YvoReeb1ecjeUrGB
         bOlQ==
X-Gm-Message-State: APjAAAV+mLTTn07sBdknl/We62rrMUawM/eDwPRtwABKSZpEJeIpgWju
        e7jZHWP3D09GqKZBbI0RHX1H7w==
X-Google-Smtp-Source: APXvYqwbxYyzyLbk51ADLy0ZWKv1PMkE3xM2vnQ+TRDbtvvGNcC6ijhssBKC5DPeKASeCL3g4lMEFQ==
X-Received: by 2002:adf:e58d:: with SMTP id l13mr18693749wrm.135.1576915668294;
        Sat, 21 Dec 2019 00:07:48 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o15sm12817707wra.83.2019.12.21.00.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 00:07:47 -0800 (PST)
Date:   Sat, 21 Dec 2019 09:07:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, leon@kernel.org,
        tariqt@mellanox.com, ayal@mellanox.com, vladbu@mellanox.com,
        michaelgur@mellanox.com, moshe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/4] net: push code from net notifier reg/unreg
 into helpers
Message-ID: <20191221080746.GA2246@nanopsycho.orion>
References: <20191220123542.26315-1-jiri@resnulli.us>
 <20191220123542.26315-3-jiri@resnulli.us>
 <8cff200c-b944-5b05-61da-9ef5fb0dfec4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cff200c-b944-5b05-61da-9ef5fb0dfec4@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 20, 2019 at 07:07:59PM CET, dsahern@gmail.com wrote:
>On 12/20/19 5:35 AM, Jiri Pirko wrote:
>> @@ -1784,6 +1784,42 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
>>  }
>>  EXPORT_SYMBOL(unregister_netdevice_notifier);
>>  
>> +static int __register_netdevice_notifier_net(struct net *net,
>> +					     struct notifier_block *nb,
>> +					     bool ignore_call_fail)
>> +{
>> +	int err;
>> +
>> +	err = raw_notifier_chain_register(&net->netdev_chain, nb);
>> +	if (err)
>> +		return err;
>> +	if (dev_boot_phase)
>> +		return 0;
>> +
>> +	err = call_netdevice_register_net_notifiers(nb, net);
>> +	if (err && !ignore_call_fail)
>> +		goto chain_unregister;
>> +
>> +	return 0;
>> +
>> +chain_unregister:
>> +	raw_notifier_chain_unregister(&netdev_chain, nb);
>
>why is the error path using the global netdev_chain when the register is
>relative to a namespace? yes, I realize existing code does that and this

A bug. Will fix. Thanks!

>is maintaining that behavior.
>
