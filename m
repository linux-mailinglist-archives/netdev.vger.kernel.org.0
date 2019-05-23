Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B522928109
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfEWPTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:19:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42039 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730709AbfEWPTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:19:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id 33so340768pgv.9
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 08:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HadvNzh2RBaOBmVIPsYUPnrsCvq9qjFe/WS9f2Qr80U=;
        b=tCpgJiLrlTdYNYrmAJCK2rVMJP0UQbCGTORdvDjvQjLcWtRfSaO+jdWlxn6G0hlu2H
         jGPHITHY99a61WqT4hFnnX4IQnui8tQWud1d1zgPUopJzbO1TlLwZ276//B3sQWxYth+
         XO0iuExwafN7Shnv4VMsQBhUl9zlhGiVCG0Q4qclR2bCcByQt6CR0Z5kIk331kl8j+Vk
         GTG5UB7gA57YPMKqF4Qb6vY1KnNFtW7kPdWm4bIvt2uE0rvjsS8VLdj1yhXE2P9nMQTO
         vlLrvb3YO23ruzQO8DvOAXP1Qx42K9QMj0hYynfwVP0pu1t0ao8nT1LRT9t1bPEL8Yej
         pSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HadvNzh2RBaOBmVIPsYUPnrsCvq9qjFe/WS9f2Qr80U=;
        b=o+/AFojByi3e9XWeIm/IhA7p47JaXSMpij9BbwNtGV3opBL4QVLML7f9LqOB+DTyIN
         BsxBkmycL3PlWzdtNuDLnl/57/EwA7CXvF2ri60XCZqcuBFl2AB8o7/MnWWnGwp7aURw
         2CEhUn9CjaPN4V96BIkne9lmJQv0nHnLmSpZhaTPuBDHz8iw1cM7DlWmAw9biSeWgsO+
         fQeHLvq4smubGg/JHCj/l2K/qXFT9lX7RwX5XM1Yq9FAA5G4MT8fYWF8gO6Hib4Z0tuf
         PUCz5+kcWkQMrNf64DOUPb7CtPdyaAc8z2PvQhc08eUJeV8pR11szN08YxHSMULfDGFj
         +iUw==
X-Gm-Message-State: APjAAAWQpj0XY2NKe3vp4ESrXL/GvL+JP2PtrNf+GJNe50ULQfPQGLpE
        eh+rlIkrmSrE9juaOzmkODg=
X-Google-Smtp-Source: APXvYqwmls6l2uYHYK/mUh8NT46pJmDz5cWLSxQbpAOtH/+Ie3vGBdqJYoP4FKrz0+ETMZiogYgc6A==
X-Received: by 2002:a17:90a:9504:: with SMTP id t4mr1951655pjo.100.1558624789231;
        Thu, 23 May 2019 08:19:49 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6c53:cc13:22bf:e3cd? ([2601:282:800:fd80:6c53:cc13:22bf:e3cd])
        by smtp.googlemail.com with ESMTPSA id d4sm816808pju.19.2019.05.23.08.19.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:19:48 -0700 (PDT)
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org
References: <20190523094510.2317-1-jiri@resnulli.us>
 <20190523094510.2317-4-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
Date:   Thu, 23 May 2019 09:19:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190523094510.2317-4-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 3:45 AM, Jiri Pirko wrote:
> @@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>  	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
>  		pr_err("Firmware flash failed: %s\n",
>  		       mlxfw_fsm_state_err_str[fsm_state_err]);
> +		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
>  		return -EINVAL;
>  	}
>  	if (curr_fsm_state != fsm_state) {
>  		if (--times == 0) {
>  			pr_err("Timeout reached on FSM state change");
> +			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");

FSM? Is the meaning obvious to users?

>  			return -ETIMEDOUT;
>  		}
>  		msleep(MLXFW_FSM_STATE_WAIT_CYCLE_MS);
> @@ -76,7 +79,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>  
>  static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
>  				 u32 fwhandle,
> -				 struct mlxfw_mfa2_component *comp)
> +				 struct mlxfw_mfa2_component *comp,
> +				 struct netlink_ext_ack *extack)
>  {
>  	u16 comp_max_write_size;
>  	u8 comp_align_bits;
> @@ -96,6 +100,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
>  	if (comp->data_size > comp_max_size) {
>  		pr_err("Component %d is of size %d which is bigger than limit %d\n",
>  		       comp->index, comp->data_size, comp_max_size);
> +		NL_SET_ERR_MSG_MOD(extack, "Component is which is bigger than limit");

Need to drop 'is which'.


...

> @@ -156,6 +163,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
>  					      &component_count);
>  	if (err) {
>  		pr_err("Could not find device PSID in MFA2 file\n");
> +		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");

same here, is PSID understood by user?

