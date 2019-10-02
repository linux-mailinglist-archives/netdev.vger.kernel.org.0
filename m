Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5286BC9054
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfJBSBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:01:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52835 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBSBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:01:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id r19so8167775wmh.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XkmQZyUMscutwGUDg2S2KGkj41Umby2/D52C7Gh1s/g=;
        b=OSd5P2any0G8tg9HCT047ouNCslJ4gy11yjAXzsYZpe1kOjPOrbkVp/X4mGdMVVeIW
         zHinOOOue6/aWYKdCSJXInQa56HeryLrWIVBu5wlRX34Xj+lzSIa1lnWBTPMjcn6tZqJ
         ww4DwTzYbCJKtXtR3mkxaYAvNo2Kuy/TakKrD/RiU01PS+kNYhxBYdiuihUBrw8komvg
         5/JStsoKBfgB/LLYe2KviW76aIM4eItMPBgTwwwzJ+bddF6TfF658RHnY7vFk6qlZgiE
         BXmqJBGXXSRuvaGrYD01yv1x4acvW8h42dwf4CCHBzPLTh/4Ln6qVAG4PnqYqSNqTeOZ
         pkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XkmQZyUMscutwGUDg2S2KGkj41Umby2/D52C7Gh1s/g=;
        b=AgcTIBOBJRGsVITPV7AdkE3QNfjWiYrpXr7wMMxSJjw4uGCw3a6IsOiE+OiJJzaQnu
         7hVX5c2wWRAwuxk9AU0Cx0hE89bZz4UwpiBPu9VC6hlFEHbBwXrQzIMGzEOMAvcCeC7C
         a9oqrlqqJhjhca9GMJF8ffrWfyozfV0XszBKDpxK+SAN2dciMaauSrIrt0YPhYUdGHah
         TeiJp+WiZG0k4nLEsxM3TDItFmq4MYmRt2SCI+d2FDIUW+NEv1rKt4sAoX6nhLMt1WnL
         i8ACSeOGXMZfbgQE0nF3J33FPRaDoATAb0L8YdCXmWDGQFzSZETu0MTTrLuWHih1Wm37
         Vosw==
X-Gm-Message-State: APjAAAV7LBOXDCTuoJ8HuSiF/jnxUpdXBMHTMp3Xj/L5izVv7n2LFET8
        PVQuKNwEg8Gqba5kFw2Vtxqzmw==
X-Google-Smtp-Source: APXvYqySAx7fdbkGV12EjxWWLPvrrClKVxHl8AugBsymlZc0CEWm/W5hujLVawQj0bavruEeRSS6nA==
X-Received: by 2002:a7b:caaa:: with SMTP id r10mr4086620wml.100.1570039305838;
        Wed, 02 Oct 2019 11:01:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d9sm191984wrc.44.2019.10.02.11.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:01:45 -0700 (PDT)
Date:   Wed, 2 Oct 2019 20:01:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 08/15] mlxsw: spectrum_router: Start using
 new IPv4 route notifications
Message-ID: <20191002180144.GD2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-9-idosch@idosch.org>
 <20191002175230.GC2279@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002175230.GC2279@nanopsycho>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 07:52:30PM CEST, jiri@resnulli.us wrote:
>Wed, Oct 02, 2019 at 10:40:56AM CEST, idosch@idosch.org wrote:
>>From: Ido Schimmel <idosch@mellanox.com>
>>
>>With the new notifications mlxsw does not need to handle identical
>>routes itself, as this is taken care of by the core IPv4 code.
>>
>>Instead, mlxsw only needs to take care of inserting and removing routes
>>from the device.
>>
>>Convert mlxsw to use the new IPv4 route notifications and simplify the
>>code.
>>
>
>[...]
>
>
>>@@ -6246,9 +6147,10 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
>> 		err = mlxsw_sp_router_fib_rule_event(event, info,
>> 						     router->mlxsw_sp);
>> 		return notifier_from_errno(err);
>>-	case FIB_EVENT_ENTRY_ADD:
>>+	case FIB_EVENT_ENTRY_ADD: /* fall through */
>> 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
>> 	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
>
>Why don't you skip the three above with just return of NOTIFY_DONE?

if (info->family == AF_INET)
	return NOTIFY_DONE;

>
>
>>+	case FIB_EVENT_ENTRY_REPLACE_TMP:
>> 		if (router->aborted) {
>> 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
>> 			return notifier_from_errno(-EINVAL);
>>-- 
>>2.21.0
>>
