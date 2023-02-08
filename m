Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63C68EF03
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjBHMec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBHMe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:34:29 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4365C48A10
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:34:23 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v10so20213544edi.8
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 04:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FDxxhRv/aPATenk971VHR6eigkZ8rKQf+oX8334/N6o=;
        b=z71JTc9ScXyxQBMrkQ5gVFYuoENsiVbGU3hsjkZa8E6txbtVCMCphsqvvPnzA1t+kg
         OcQEuQGOfkd/4ZNvZ5TbesPSo23bOaFKykIwBFNhkM+OwNH3NkHXlGZi9IqZ0XsmDk56
         QMDceJ6nsH8GyqoxdQnMxCXtnNJmiVyYkMkTtKkZojB9idmAzf1Qyj07H1kh9bYDqdi6
         /hYBLxLTWrO4nU8NTBFp7DKOGzv9WIM5JFYIHDzjDw4zEVT/Xxtp+Z7t4YX/UXWdusZo
         zfmQ6msAhPipaeTPeY9fm7ZNCqSeltzWy6S5TjAsjuMMLF4gm0JopiRSU6zm+hVm34w0
         bq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDxxhRv/aPATenk971VHR6eigkZ8rKQf+oX8334/N6o=;
        b=tIks3t0IIneDRuuVkDbBMkcD5J346/5SZ5IpfUGFSkdzqetKSuFAKxklYjEAJTusbF
         Ho+odJz8s5ZfY7LEpGiuGQw0kVCwibyWIyHEUv5dPoeOlFDZg4LmBtQyirXIzcGdt2Hq
         nus2iolvfHc2nOCs4WqRjDRPmkNpSM7G3yrG/h+sdXP/OCJNktd3F8WgmfOyPNgKsMVn
         z1pNS4hc77vmyj2ANVgPxUxgNAdPSqqo/rWvNWJ+Olwhqgf47+7SUVXGQGT2Dk4BlEZd
         RwZ2O8KvRI6oAJpCyPH6XlPDMlktjPYv5A1bmH6v+YhD/xqWdIoaLOVrCHQJO8q2t6EM
         oh6g==
X-Gm-Message-State: AO0yUKUOt/dzOU/inaK39GQozMNHUcDm8MBn4JEI+XTZTj/MGhsiYisW
        ec4hqzJrPDnIidPriXEAM6pBsA==
X-Google-Smtp-Source: AK7set+jeuRIF2eKG+rwu1/9VaFgAWw0WAuG6UgmX2txhakJmkEGslZsr3SvMEwJ2RkXv9pVOcsdNw==
X-Received: by 2002:a50:9f87:0:b0:4ab:15d0:19c6 with SMTP id c7-20020a509f87000000b004ab15d019c6mr1001804edf.7.1675859662131;
        Wed, 08 Feb 2023 04:34:22 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id v14-20020a50d08e000000b004ab16281309sm1331edd.29.2023.02.08.04.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 04:34:21 -0800 (PST)
Date:   Wed, 8 Feb 2023 13:34:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OWy0prxf5pNWpv@nanopsycho>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <Y+OKPYua5jm7kHz8@nanopsycho>
 <Y+OQmjJFeQeF2kJx@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+OQmjJFeQeF2kJx@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 08, 2023 at 01:07:54PM CET, simon.horman@corigine.com wrote:
>On Wed, Feb 08, 2023 at 12:40:45PM +0100, Jiri Pirko wrote:
>> Mon, Feb 06, 2023 at 04:36:02PM CET, simon.horman@corigine.com wrote:
>> >From: Fei Qin <fei.qin@corigine.com>
>> >
>> >Multiple physical ports of the same NIC may share the single
>> >PCI address. In some cases, assigning VFs to different physical
>> >ports can be demanded, especially under high-traffic scenario.
>> >Load balancing can be realized in virtualised use¬cases through
>> >distributing packets between different physical ports with LAGs
>> >of VFs which are assigned to those physical ports.
>> >
>> >This patch adds new attribute "vf_count" to 'devlink port function'
>> >API which only can be shown and configured under devlink ports
>> >with flavor "DEVLINK_PORT_FLAVOUR_PHYSICAL".
>> 
>> I have to be missing something. That is the meaning of "assigning VF"
>> to a physical port? Why there should be any relationship between
>> physical port and VF other than configured forwarding (using TC for
>> example)?
>> 
>> This seems very wrong. Preliminary NAK.
>
>Of course if TC is involved, then we have flexibility.
>
>What we are talking about here is primarily legacy mode.

I don't see any reason to add knobs for purpose of supporting the legacy
mode, sorry.

If you need this functionality, use TC.



>And the behaviour described would, when enabled allow NFP based NICs
>to behave more like most other multi-port NICs.
>
>That is, we can envisage a VEB with some VFs and one physical port.
>And anther with other VFs and another physical port.
>
>This is as opposed to a single VEB with all VFs, as is currently
>the case on NFP based NICs (but not most other multi-port NICs).
>
