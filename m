Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FE8645B01
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiLGNe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLGNem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:34:42 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CD259FD1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:34:34 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id vv4so14069494ejc.2
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RS2Q+eicEWCc+aOKVPalUgkXPjsF2QqllPQhXU9WIzA=;
        b=E1PEt20o+Y9KVpGofYjYV/dTb2/Oox5L1y8RE8d+I/3rB+4aExTQPm8IqZmwxFTcKj
         JNZYZQ+tjOBnsQjsRYge5HbaZwiDIxJjHO4yHTMYyptkkJj7YdidhG19GU1IvkULulfD
         qH/pcDHeAeVabBv22RXEC0qr4ULAxpWe5rIGUZuc01WJNH73cxLjSra88NWOBC8Iwp5Q
         jfPE5jnpbht497qlPH+Y1aLCbeYDz8VDTP9daV+cN5a9udsfpNi4quWHEkjg9Ij4BwHq
         EFG8Nx1cdlvtoQRrS+LMmnLCyhA4ZHptFCpU2OJojACYp3S9ihcHArTs+0peSuxRmTcl
         ttEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RS2Q+eicEWCc+aOKVPalUgkXPjsF2QqllPQhXU9WIzA=;
        b=oUvgw1TKBwOiLlNKbSNcTqGlYr/aP7kQxZYvlzOJFOwJtt/cIYJ6ceNILM/ZZ8/5kb
         ZZ887CQRrfzaxxB7xKIEqD0ivnfWRPyZKMP/trZg9LSWYMVBxCSCgqaYW5G/tjsitWxU
         anOqovdIfmSqRmwNHojIwyKbZ620ComWHL/qq+mQvGWSA6Hm7QKAsn5k9Z3NseZKdpCN
         VrkXeLVaW+Bdy1eCFS6Qnqm6UMqnnm/e4IM93v6TeLdsrJ5TukjcP2dQEvjrAa1Erae8
         kMOCZpffhxZOW0aAO13Mi32yY2Hew02Bdjz2vvjd9oxXpfBWeMXE1Fw77aUPWoEC2J9a
         qdXg==
X-Gm-Message-State: ANoB5pmEE90ysUZCw04Xwiz1fsA8+rt1voXqAjTzlNuUWNka2UOIKYYO
        E04X8qPjOrTcptW5LmS2UNDGng==
X-Google-Smtp-Source: AA0mqf76tJbxnF1wAKqI0kzHMmxoZxLt7TrENz2g9jc0i7dVpVDIGC7N0SoLFX25zomnnfVYFxqLLw==
X-Received: by 2002:a17:906:8e0a:b0:7b9:bef6:3eea with SMTP id rx10-20020a1709068e0a00b007b9bef63eeamr28379851ejc.487.1670420073265;
        Wed, 07 Dec 2022 05:34:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kz4-20020a17090777c400b0073d796a1043sm8476971ejc.123.2022.12.07.05.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:34:32 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:34:31 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <Y5CWZwq1koVN0V0/@nanopsycho>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com>
 <Y48GR+NShwJiIBTc@nanopsycho>
 <1d1f00e2-6c71-9a60-e83d-4b1e521c82fc@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d1f00e2-6c71-9a60-e83d-4b1e521c82fc@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 07:18:00PM CET, shannon.nelson@amd.com wrote:
>On 12/6/22 1:07 AM, Jiri Pirko wrote:
>> Mon, Dec 05, 2022 at 06:26:26PM CET, shannon.nelson@amd.com wrote:
>> > Some devices have multiple memory banks that can be used to
>> > hold various firmware versions that can be chosen for booting.
>> > This can be used in addition to or along with the FW_LOAD_POLICY
>> > parameter, depending on the capabilities of the particular
>> > device.
>> > 
>> > This is a parameter suggested by Jake in
>> > https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/
>> > 
>> > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> > ---
>> > Documentation/networking/devlink/devlink-params.rst | 4 ++++
>> > include/net/devlink.h                               | 4 ++++
>> > net/core/devlink.c                                  | 5 +++++
>> > 3 files changed, 13 insertions(+)
>> > 
>> > diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> > index 4e01dc32bc08..ed62c8a92f17 100644
>> > --- a/Documentation/networking/devlink/devlink-params.rst
>> > +++ b/Documentation/networking/devlink/devlink-params.rst
>> > @@ -137,3 +137,7 @@ own name.
>> >     * - ``event_eq_size``
>> >       - u32
>> >       - Control the size of asynchronous control events EQ.
>> > +   * - ``fw_bank``
>> > +     - u8
>> > +     - In a multi-bank flash device, select the FW memory bank to be
>> > +       loaded from on the next device boot/reset.
>> 
>> Just the next one or any in the future? Please define this precisely.
>
>I suspect it will depend upon the actual device that uses this.  In our case,

It should not. The behaviour should be predictable for the user.


>all future resets until changed again by this or by a devlink dev flash
>command.  I'll tweak the wording a bit to something like
>    "... to be loaded from on future device boot/resets."
>
>> 
>> 
>> > diff --git a/include/net/devlink.h b/include/net/devlink.h
>> > index 074a79b8933f..8a1430196980 100644
>> > --- a/include/net/devlink.h
>> > +++ b/include/net/devlink.h
>> > @@ -510,6 +510,7 @@ enum devlink_param_generic_id {
>> >        DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
>> >        DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
>> >        DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
>> > +      DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>> > 
>> >        /* add new param generic ids above here*/
>> >        __DEVLINK_PARAM_GENERIC_ID_MAX,
>> > @@ -568,6 +569,9 @@ enum devlink_param_generic_id {
>> > #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
>> > #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
>> > 
>> > +#define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
>> > +#define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
>> > +
>> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> > {                                                                     \
>> >        .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> > diff --git a/net/core/devlink.c b/net/core/devlink.c
>> > index 0e10a8a68c5e..6872d678be5b 100644
>> > --- a/net/core/devlink.c
>> > +++ b/net/core/devlink.c
>> > @@ -5231,6 +5231,11 @@ static const struct devlink_param devlink_param_generic[] = {
>> >                .name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
>> >                .type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
>> >        },
>> > +      {
>> > +              .id = DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>> > +              .name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
>> > +              .type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
>> > +      },
>> > };
>> > 
>> > static int devlink_param_generic_verify(const struct devlink_param *param)
>> > --
>> > 2.17.1
>> > 
