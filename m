Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41AE1281E6
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfLTSID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:08:03 -0500
Received: from mail-qk1-f170.google.com ([209.85.222.170]:40143 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfLTSIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:08:02 -0500
Received: by mail-qk1-f170.google.com with SMTP id c17so8348223qkg.7
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 10:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=er1bssFX4Auf5RyExJsmYghz8eNB/FYzbhbQpUQ1esg=;
        b=TxjPdUMmqpj87X1+gnS6MRlDRYFgebGiIBv8e1QWTU7Ob/i0ivhlDpQALgwrA96aDr
         xLdwOdFZaFMTqGbUStA17KAifj5iMXDivUi3VuyYBZ4OerDPiaQcy9tmh+wQwofEHEGR
         niXO0S5tFHZCV66mdNx/oaaFXNv23pJ534k1SuhSVmGJaqK6J54OwfNp/b6UVCcUlbof
         mV8E2/FKQkQvRo4Ln0sHsC5fBCds2sXS4GJXojqxOZTjrBxWdIudUMACb4dmO2mOaSVl
         //1JTxKoiIZSYUTYJYnavuMxz9agAyaKVlj8Gga9tjoiZHC399Ep8I8B99mDI3pdjt2o
         D7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=er1bssFX4Auf5RyExJsmYghz8eNB/FYzbhbQpUQ1esg=;
        b=We1Q6NiqU1knKvsjHAA6UCl4762ZX/U04vZiX3c+1M4VwAh2NPrv9JVN9h0oJE5ozz
         VxPgrrvc39y/6sMW4k28LFm9lMOt8FOVGe0dIujuzB2jclmZWeKWYQun1K4RFKC2iJSs
         dwEFYFaNEvTm1gVFJM7qwoSnmWiQfRVz4W2JeNSJdnwZm9EpgbjIVKM0UgJNEe1RLbKN
         mjw95axQ/YwyZjCyqBIjZTiH1jlnpwC8Y/np5hT2tS++Gmer1PQxTlVIoxd6gM2Bo0z2
         hAXBtDg9gF/yUjA38V7lJH6OS4iGzrFTvK144a7G93iXI9tzgctekG35x90TKlqg9fQC
         AeXQ==
X-Gm-Message-State: APjAAAVGMIVWADpHN3depQPsGlrHYWperJja589ypIxUatWTH+ZNyMsQ
        ktB2pWmwfJ1ja1dKtbWD95o=
X-Google-Smtp-Source: APXvYqwPde5Mu/8WEJzIA9VY8dPBkW8A1SqWHCUR22zUKTJTmNwK9Wqn85eeYZ553QIaA+nkbUf8Xw==
X-Received: by 2002:a05:620a:6d7:: with SMTP id 23mr13986459qky.299.1576865281671;
        Fri, 20 Dec 2019 10:08:01 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:d462:ea64:486f:4002? ([2601:282:800:fd80:d462:ea64:486f:4002])
        by smtp.googlemail.com with ESMTPSA id q35sm3351956qta.19.2019.12.20.10.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 10:08:01 -0800 (PST)
Subject: Re: [patch net-next 2/4] net: push code from net notifier reg/unreg
 into helpers
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
References: <20191220123542.26315-1-jiri@resnulli.us>
 <20191220123542.26315-3-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8cff200c-b944-5b05-61da-9ef5fb0dfec4@gmail.com>
Date:   Fri, 20 Dec 2019 11:07:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191220123542.26315-3-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19 5:35 AM, Jiri Pirko wrote:
> @@ -1784,6 +1784,42 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_netdevice_notifier);
>  
> +static int __register_netdevice_notifier_net(struct net *net,
> +					     struct notifier_block *nb,
> +					     bool ignore_call_fail)
> +{
> +	int err;
> +
> +	err = raw_notifier_chain_register(&net->netdev_chain, nb);
> +	if (err)
> +		return err;
> +	if (dev_boot_phase)
> +		return 0;
> +
> +	err = call_netdevice_register_net_notifiers(nb, net);
> +	if (err && !ignore_call_fail)
> +		goto chain_unregister;
> +
> +	return 0;
> +
> +chain_unregister:
> +	raw_notifier_chain_unregister(&netdev_chain, nb);

why is the error path using the global netdev_chain when the register is
relative to a namespace? yes, I realize existing code does that and this
is maintaining that behavior.

