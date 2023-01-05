Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AC065F042
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjAEPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbjAEPkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:40:06 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC43F33D60
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:40:03 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 36so24731798pgp.10
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 07:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/qJ85LB6yXZxVKFmB2K/KRhKzUWYMc3G3shHEn4BJ8=;
        b=5fYaMV3yDX1tYR6PGiQS9T2UOhQLmyt/91i3WwotWyAT8sfMFnr83nWsufbhP9OOyI
         m4hz45xFjybxFgrpv/vsrR+YD7V9Xk+ppb3hJ9+TCwTaTE2UEUBhJB4WhYgzXTCoIqx1
         L9dBblSlLQdN1cZZ5jd+zJsFWqAb2fg59c63WZs7QaQsvSvfw1s7EMekfCXCMCmWoyxN
         eCNwwtrFDyWX+TzGagAdNS7QVicSv6MSROSPaAneV7bxplUdNnmIzE+56FdzbYtUm5bB
         BQtfJbY7o6cDtSnH6hONTxoNPud7zfN3vdCyPN1sxpajp8OgiEFGY9oXKqM+vyGr++8/
         pRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/qJ85LB6yXZxVKFmB2K/KRhKzUWYMc3G3shHEn4BJ8=;
        b=uNDDLnh/KD0paw7OcNVfOOKLb+PrW4j6gUZvl1YMqAm79vDp6uoP3AMscdXdxHK/P2
         qPvwbjDMC53Z6HsQjACZrimUhtLm5HkOg59jOP12cGKWE6X3kK2fZljCvTDeDnArK2Dk
         8D5vyNAFxOqLtG1ttvrcdY5lFzHP2QAboDk6I+lsHC5tEjBke3SIopKnKn3CGJiBP+ST
         RWNeGybsXHPamYjobomXjUMUk0AYy9CJXX6HeL1JgSbiB7y1cvexFg4kuT+VDvSkM95Z
         HKW30+pX8WxVmCjRa2RVptiTR7zXHZCo7RLKI+Pis2mlxe/6SqzcMyQM8DNd5YaGR6RD
         sD3A==
X-Gm-Message-State: AFqh2krRehSsw+i6y+fxj59+NMx6ZD5ieA1TxOrHeoXvi5FLvgXJK06G
        xbNoCk8lyLye4lkZ1Y4n+nHmL+Lnc/RY9ENG/5JUIXWy
X-Google-Smtp-Source: AMrXdXsAxsWvX0POS+FjEX4pICnB5Jyn5kJAvOWNyYCb817hAo0anS5n/FvzvRjIbV/ve0WCnn959Q==
X-Received: by 2002:a62:198a:0:b0:577:d10d:6eab with SMTP id 132-20020a62198a000000b00577d10d6eabmr51840475pfz.21.1672933203331;
        Thu, 05 Jan 2023 07:40:03 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id x5-20020a626305000000b005815017d348sm19012860pfb.179.2023.01.05.07.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 07:40:02 -0800 (PST)
Date:   Thu, 5 Jan 2023 16:39:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [PATCH net-next 0/2] Add support to offload macsec using netlink
 update
Message-ID: <Y7bvT4myLYsSCjHl@nanopsycho>
References: <20230105080442.17873-1-ehakim@nvidia.com>
 <Y7bY+oYkMojpMCJU@nanopsycho>
 <IA1PR12MB6353778987E1DBFA4B3489D2ABFA9@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR12MB6353778987E1DBFA4B3489D2ABFA9@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 04:02:06PM CET, ehakim@nvidia.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Thursday, 5 January 2023 16:05
>> To: Emeel Hakim <ehakim@nvidia.com>
>> Cc: netdev@vger.kernel.org; Raed Salem <raeds@nvidia.com>;
>> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>> pabeni@redhat.com; sd@queasysnail.net; atenart@kernel.org
>> Subject: Re: [PATCH net-next 0/2] Add support to offload macsec using netlink
>> update
>> 
>> External email: Use caution opening links or attachments
>> 
>> 
>> The whole patchset emails, including all patches and coverletter should be marked
>> with the same version number.
>
>Ack, wanted to make it clear that this is being sent for the first time, also 
>do I leave the change log of non-changed patches empty?

If you don't change a patch in between the versions, you can either omit
the "vx->vy:" entry or you say "no change" there.

>should I resend the patches?

Yes.

> 
>>
>> Thu, Jan 05, 2023 at 09:04:40AM CET, ehakim@nvidia.com wrote:
>> >From: Emeel Hakim <ehakim@nvidia.com>
>> >
>> >This series adds support for offloading macsec as part of the netlink
>> >update routine , command example:
>> >ip link set link eth2 macsec0 type macsec offload mac
>> >
>> >The above is done using the IFLA_MACSEC_OFFLOAD attribute hence the
>> >second patch of dumping this attribute as part of the macsec dump.
>> >
>> >Emeel Hakim (2):
>> >  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
>> >  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
>> >
>> > drivers/net/macsec.c | 127 ++++++++++++++++++++++---------------------
>> > 1 file changed, 66 insertions(+), 61 deletions(-)
>> >
>> >--
>> >2.21.3
>> >
