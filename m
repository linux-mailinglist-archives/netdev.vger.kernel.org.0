Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9840467375A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjASLsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjASLsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:48:53 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CED30F8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:48:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so4994033ejc.4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OfApbZNaZr6Z8xIb2jJ8eKCH2W+NHkUdXeZjNWjuExM=;
        b=wRk71RacpT28/nFBKA4seJvhpniWQPuqi5ZADNXVsWB2YH4xD9zKiOrjea+yjyn6t8
         QZF+nfkDog3jK/unutjliAh8EJ/mmnf+z//oqXhtZN3lm3x4ADDvuFJE29Ryd4AL4gkv
         P5NCYiOT9saYrheRYEWyGTw/z7jEEiIy5r5F1XDexU4Wj8yR4jpoNvv2y076/nHgGaq8
         sK9AAqjegyite6tXt+erofB6p+lMWDw8pUD2XO3uZbLMSfzWbTHQrKZKkFBQ6cPA5/Mx
         b2svUQwHCJ4W+aFFOSKH8gBtS6+g7FkzE8u5JrsKKuaeG9E4gwXPQ6PLRrQLIla2SlXT
         pu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfApbZNaZr6Z8xIb2jJ8eKCH2W+NHkUdXeZjNWjuExM=;
        b=x9lzf7xnnRWx9sIAjlIC8jYR1ydRSyY69V4HRgUMTKqcv2w/AWp6W8ldU2LriZ9eHo
         VE+xmNvPyplHpn2086tGelD2fBku2m6SVcAatoZDGEcvwqDQavTj8EdGH613xJherFOy
         JRJ8HT5IHv70NpexR3NNGhANGok5HWQAXmUeIQA7Vea4wEY5M88C1BiUrhKtR+SQnjCm
         d85H1UpLXQQFA6tLk7XLT7gXrVpS6FBG7eEi8bTGlrHmKso//NwmLfsDXQ3xvPD8vzuY
         UjgNY4szogId6qQa/sHCHGAv7QwMkf2kBi8blvwtnR1Aosx9TDQsVCXwJA/n9cyBeixs
         BNUw==
X-Gm-Message-State: AFqh2kpiGU3+CGaVcnZyelaSqvITO136vyjSgsl3r+PZKDm3k2ccsjjh
        QnAdR2hxT0feMYssCy766jhgkQ==
X-Google-Smtp-Source: AMrXdXuVZ6e1vq1DuWiskM3xp3ei42aLAUo7/50sjxdXOkzfqZ7xYsRSzXeQimL6PctKmRJV6oHbkQ==
X-Received: by 2002:a17:906:804e:b0:86b:6a54:36e0 with SMTP id x14-20020a170906804e00b0086b6a5436e0mr9757970ejw.36.1674128928948;
        Thu, 19 Jan 2023 03:48:48 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id o12-20020a170906768c00b0085ff3202ce7sm10454657ejm.219.2023.01.19.03.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 03:48:48 -0800 (PST)
Date:   Thu, 19 Jan 2023 12:48:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Message-ID: <Y8kuH7pfdIA3Dbdk@nanopsycho>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <DM6PR11MB4657644893C565877A71E1F19BC79@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230118161525.01d6b94f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118161525.01d6b94f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 01:15:25AM CET, kuba@kernel.org wrote:
>On Wed, 18 Jan 2023 18:07:53 +0000 Kubalewski, Arkadiusz wrote:
>> Based on today's sync meeting, changes we are going to introduce in next
>> version:
>> - reduce the muxed-pin number (artificial multiplication) on list of dpll's
>> pins, have a single pin which can be connected with multiple parents,
>> - introduce separated get command for the pin attributes,
>> - allow infinite name length of dpll device,
>> - remove a type embedded in dpll's name and introduce new attribute instead,
>> - remove clock class attribute as it is not known by the driver without
>> compliance testing on given SW/HW configuration,
>> - add dpll device "default" quality level attribute, as shall be known
>> by driver for a given hardware.
>
>I converted the patches to use the spec, and pushed them out here:
>
>https://github.com/kuba-moo/ynl/tree/dpll
>
>I kept the conversion step-by-step to help the readers a bit but
>the conversion patches should all be squashed into the main DPLL patch.
>
>The patches are on top of my YNL branch ('main' in that repo). 
>I'll post the YNL patches later today, so hopefully very soon they will
>be upstream.
>
>Two major pieces of work which I didn't do for DPLL:
> - docs - I dropped most of the kdocs, the copy-n-pasting was too much;
>   if you want to keep the docs in the uAPI you need to add the
>   appropriate stuff in the spec (look at the definition of
>   pin-signal-type for an example of a fully documented enum)
> - the notifications are quite unorthodox in the current 
>   implementation, so I faked the enums :S
>   Usually the notification is the same as the response to a get.
>   IIRC 'notify' and 'event' operation types should be used in the spec.

I already pointed this out in the past. This is not he only thing that
was ignored during the dpll review. I have to say I'm a bit annoyed by
that.


>
>There is documentation on the specs in
>Documentation/userspace-api/netlink/ which should give some idea of how
>things work. There is also another example of a spec here:
>https://github.com/kuba-moo/ynl/blob/psp/Documentation/netlink/specs/psp.yaml
>
>To regenerate the C code after changes to YAML:
>
>  ./tools/net/ynl/ynl-regen.sh
>
>if the Python script doing the generation dies and eats the files -
>bring them back with:
>
>  git checkout drivers/dpll/dpll_nl.c drivers/dpll/dpll_nl.h \
>               include/uapi/linux/dpll.h
>
>There is a "universal CLI" script in:
>
>  ./tools/net/ynl/samples/cli.py
>
>which should be able to take in JSON requests and output JSON responses.
>I'm improvising, because I don't have any implementation to try it 
>out, but something like:
>
>  ./tools/net/ynl/samples/cli.py \
>       --spec Documentation/netlink/specs/dpll.yaml \
>       --do device-get --json '{"id": 1}'
>
>should pretty print the info about device with id 1. Actually - it
>probably won't because I didn't fill in all the attrs in the pin nest.
>But with a bit more work on the spec it should work.
>
>Would you be able to finish this conversion. Just LMK if you have any
>problems, the edges are definitely very sharp at this point.
