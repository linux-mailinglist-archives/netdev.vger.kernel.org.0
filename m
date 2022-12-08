Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA70646A3E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLHIOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLHIOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:14:37 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8617D31209
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:14:35 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m18so2070083eji.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 00:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wtVgzA0tnlZYI2aQPk1Vlp2tJRyR1xpHtf5sM5xwTWQ=;
        b=sZH1isJgfoNIVB/FF0/v8QvXTxuSipN5HfMpapXocHA4KJCeVgRNKwPjqr/TFZxV1q
         thDN8K+mRT1qgCTnHHxytTPolDk0fksikTbmmfVet5MhYVG3gAzcVmEiYS2AeAjJNQ2T
         D9z3ngNer4R9QgqcKWHe8bMSdePgoD7STyE+Om3va0IdEGAfk95DtDWlDN6yH97WywXL
         wyGuTsa/5FH7nlYlyRHdteo2crpGhXtMV+pdlzhsNr7V9y6APtXvb+ajU0Gd8BOez/z9
         zszhdaVhLCopWCyLZEpEm47xS/L+DoNaIpkbhIFaaeb/yj+hEdHxDzbhlK/NRE2wJijM
         Zskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtVgzA0tnlZYI2aQPk1Vlp2tJRyR1xpHtf5sM5xwTWQ=;
        b=Qy69bg5A72iSWZ9/NXtG5JM/uzFTsa3r9t7HuCT8LCcYQU1mA6pDtL2nGfSJc+hJlo
         L6y8LzzKMSHtFMWplJHkXKXvmSo4DCCcnoTajYWKU1I+tNLhK1xF8bsu9AQLamP4MkeC
         wjxBU/P66CIaJ9TCan1hsyamtKKgcAnQFGzFMP0rB8E6nyu8B3mF4jJTAjxxmsD/ievW
         hvnsUjxrkXuGzlnJ+q7+QSvo/VQc/uJDAY4HjGuKsfZjX1iEuJxcvNIU4k9EPd0L8k2e
         I9TtSOGo0BnHuewT3BYEa92KsHC/4FKVBGeCp9xG9sQ4AuOeCCWY7ibWukH7zP3KRvI+
         2h2w==
X-Gm-Message-State: ANoB5pnJJhhjhSp9SM+FMupRYLDrgrioupB5/nJ5NMUlFOMdVmecUgzU
        a7kGlk6QVGcbRjGgMDKndgxITg==
X-Google-Smtp-Source: AA0mqf4NyhJRCYAiiDE9inktT3l2ge/UojNytsLFHAEpTHJi27kRn68d/faKrdITHVOl8NL+90ZPgg==
X-Received: by 2002:a17:907:d412:b0:7c0:8e62:56f6 with SMTP id vi18-20020a170907d41200b007c08e6256f6mr1586320ejc.56.1670487273940;
        Thu, 08 Dec 2022 00:14:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090609ca00b007ad94422cf6sm9296799eje.198.2022.12.08.00.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:14:33 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:14:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y5Gc6E+mpWeVSBL7@nanopsycho>
References: <Y4nyBwNPjuJFB5Km@nanopsycho>
 <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4okm5TrBj+JAJrV@nanopsycho>
 <20221202212206.3619bd5f@kernel.org>
 <Y43IpIQ3C0vGzHQW@nanopsycho>
 <20221205161933.663ea611@kernel.org>
 <Y48CS98KYCMJS9uM@nanopsycho>
 <20221206092705.108ded86@kernel.org>
 <Y5CQ0qddxuUQg8R8@nanopsycho>
 <20221207085941.3b56bc8c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207085941.3b56bc8c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 05:59:41PM CET, kuba@kernel.org wrote:
>On Wed, 7 Dec 2022 14:10:42 +0100 Jiri Pirko wrote:
>> >> Why do we need this association at all?  
>> >
>> >Someone someday may want netns delegation and if we don't have the
>> >support from the start we may break backward compat introducing it.  
>> 
>> Hmm. Can you imagine a usecase?
>
>Running DPLL control in a namespace / container.
>
>I mean - I generally think netns is overused, but yes, it's what
>containers use, so I think someone may want to develop their
>timer controller SW in as a container?

The netdevices to control are already in the container. Isn't that
enough?


>
>> Link to devlink instance btw might be a problem. In case of mlx5, one
>> dpll instance is going to be created for 2 (or more) PFs. 1 per ConnectX
>> ASIC as there is only 1 clock there. And PF devlinks can come and go,
>> does not make sense to link it to any of them.
>
>If only we stuck to the "one devlink instance per ASIC", huh? :)

Yeah...


>
>> Thinking about it a bit more, DPLL itself has no network notion. The
>> special case is SyncE pin, which is linked to netdevice. Just a small
>> part of dpll device. And the netdevice already has notion of netns.
>> Isn't that enough?
>
>So we can't use devlink or netdev. Hm. So what do we do?
>Make DPLLs only visible in init_net? And require init_net admin?
>And when someone comes asking we add an explicit "move to netns"
>command to DPLL?

Well, as I wrote. The only part needed to be network namespaced are the
netdev related pins. And netdevices have netns support. So my question
again, why is that not enough?

