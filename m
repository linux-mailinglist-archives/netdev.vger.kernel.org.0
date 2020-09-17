Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F20E26E6B9
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgIQUX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIQUX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:23:56 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8BCC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:23:56 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e23so3152300otk.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cgjWjqkB5JR83nm/9Q8cs0Q63UTDk2qM52eyeBmA9BA=;
        b=j6uxnnKDIDdBIiZ2SMmsgL6d3NiFL5w5hwlYpduAwiAqHy9JQfRoXTXAgbPUAMZbbU
         NAVDqpMuMlryuJM+AG5UkBFUZQPJPJMRh+sXHNQ2V4CK2kDu0SdjQIO0kkLLxazsdOtz
         XSEEj7GMUvo30VVr9YWWm8crSYQ8VPuxPJSLfoSRdh2j/+P5hOeCEi2rllbE/D5hdnUF
         Dar0XTwZ1OJP1dPY4IMRVELHTcl6XG27UNacfSUdNv8CGStV3JPCWIyWhK9kFjxb/tFl
         zKAePAALBH6NOAEldfRhNGMyAs3sLXpiz6SkQiELEJCaYnEjkMaKUUNQVYvPqmwZ8y3L
         Ky0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgjWjqkB5JR83nm/9Q8cs0Q63UTDk2qM52eyeBmA9BA=;
        b=eU9Di3l7zcBZDHVMjRCkFOdfZc49EJoxBmvbrHYTpW3OazNZeGsb+F4fi+He2+kav3
         Dl4TyJuC6gge/HgiyCX3uTmUIBIXNrRbKSXvJSCIEdD7IMmL20EenUkpHD4REREs+cgf
         00oVBE96Sv353wZmsoXzVWvA8LJ61n0QRTMMSnWv/pVWTo3heOTz4s40m6jOkf101KOm
         tC4x7niU6cyUYIcqxN5vrrAvLUvaYtd98gOeh5emTlx8tEJhTebOMYbTC4qCJw4Bcz0L
         6PM1porBb4Dbh3QwZTYSvsZKbvZA72ndssiUTfW/lQdIcZRjnxCa7EuSLMlpFmO0sV+p
         L00Q==
X-Gm-Message-State: AOAM532gNFBrYBpj8NKJeigPlUQ52aaFlLF5SO1lF7ctaSQ/+aEo07IV
        KxhZrtAyqQrkAapfvwjmzjk=
X-Google-Smtp-Source: ABdhPJxFnGUd3rZj9gV0C5nt0VFKMui+s8kfr/heQzjcaF0sdbSqao/So/ggQNDx09qdRhb7HwjS2A==
X-Received: by 2002:a05:6830:1db5:: with SMTP id z21mr21900455oti.144.1600374236249;
        Thu, 17 Sep 2020 13:23:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:b5c4:4acf:b5cf:24fe])
        by smtp.googlemail.com with ESMTPSA id g21sm741020oos.36.2020.09.17.13.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:23:55 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/8] devlink: Support get and set state of
 port function
To:     Parav Pandit <parav@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-5-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <88de7791-2a50-64b1-6e3d-5c1a8235eb96@gmail.com>
Date:   Thu, 17 Sep 2020 14:23:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917172020.26484-5-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 11:20 AM, Parav Pandit wrote:
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index d152489e48da..c82098cb75da 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -595,6 +598,40 @@ devlink_port_function_hw_addr_fill(struct devlink *devlink, const struct devlink
>  	return 0;
>  }
>  
> +static bool devlink_port_function_state_valid(u8 state)

you have a named enum so why not 'enum devlink_port_function_state state'?


> +{
> +	return state == DEVLINK_PORT_FUNCTION_STATE_INACTIVE ||
> +	       state == DEVLINK_PORT_FUNCTION_STATE_ACTIVE;
> +}
> +
> +static int devlink_port_function_state_fill(struct devlink *devlink, const struct devlink_ops *ops,
> +					    struct devlink_port *port, struct sk_buff *msg,
> +					    struct netlink_ext_ack *extack, bool *msg_updated)
> +{
> +	enum devlink_port_function_state state;
> +	int err;
> +
> +	if (!ops->port_function_state_get)
> +		return 0;
> +
> +	err = ops->port_function_state_get(devlink, port, &state, extack);
> +	if (err) {
> +		if (err == -EOPNOTSUPP)
> +			return 0;
> +		return err;
> +	}
> +	if (!devlink_port_function_state_valid(state)) {
> +		WARN_ON(1);

WARN_ON_ONCE at most.

> +		NL_SET_ERR_MSG_MOD(extack, "Invalid state value read from driver");
> +		return -EINVAL;
> +	}
> +	err = nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_STATE, state);
> +	if (err)
> +		return err;
> +	*msg_updated = true;
> +	return 0;
> +}
> +
>  static int
>  devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
>  				   struct netlink_ext_ack *extack)
