Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC106642CB6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiLEQXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiLEQXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:23:09 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502D113D66
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:23:08 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 140so11863167pfz.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 08:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lr1vlnFfE/YbSYOXWNlO4g9ddEEJvBqDAiFb0U/PSDw=;
        b=X9NzJeActl4QujAw1UC7jS3RDQzfeUqeviGuc8EMzz/6Lre9bbF6Sb7B8AtmD8xcgj
         nf/25/yquzaW1YJdeGubI5PgOPy9BM3J5OQGBrQZqpMELDt5XqaY+qCmpUSYpIxJ34u8
         +pdaa088FbsdadpdmB5NcNhvD5UpXyNR0PpJF5Or9EjqYoL5kLcu2hgZxgkrv5ADOS4F
         b8/gXx9cy8VdcGUyHsAB+jzo0VNYCZS496JJQyRtbLqSywdb39+jJjKX5XT5O/xaNsQa
         tI+0RgWD1udyLCEgHbtQWXrLZ63VFz1qzKDTM0Y/A/xuelcP5VlWGNhsxmoYamS1HGfZ
         kOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lr1vlnFfE/YbSYOXWNlO4g9ddEEJvBqDAiFb0U/PSDw=;
        b=UeYBRbMjaL8G+IbqZ6Ae7SuvRQlgKCRqWFMScQ3agsiwccpS7RHQXY8pjugPUKFfr1
         5QFux+aXZ6JSlT94ROoaAynv8AjfJg6ECYFru6qdpFlTthla515BGsfeMKx78S6wbMVY
         F0qeL6kZKqTk1D7KD63OolWfqb1FOncGHVuIHiCdqR48NmuVejtSNt/8DpeO9srLT1aD
         W/Q7txZG1OBCgD56N6AM+TwO0B8xwLfgbusq2Q71VyynouN7UfB0oyUgGu/2j7G83MN7
         Fc1GwZMDWpRqkN0DRpbHazZSQrrULNyi9CPQZ6vKHn204FiHbBDyEJDToAryJDXygrGg
         A7xw==
X-Gm-Message-State: ANoB5pk0rkL/q/XZ5WtQTeasLuudlzMoOfBg3IlBOHIl8ZZPSkmnuCXH
        DmeAtlw7YNvamQKYKzoBy/vDew==
X-Google-Smtp-Source: AA0mqf53wGkHtQnWlI/NW8w33ktYGqcY4BYRUg7PeISK6bkpY0NiiwpLPcJFFATD7I9dMiJB1Pqeqg==
X-Received: by 2002:a63:4c01:0:b0:478:b7ab:2f70 with SMTP id z1-20020a634c01000000b00478b7ab2f70mr5579686pga.13.1670257387757;
        Mon, 05 Dec 2022 08:23:07 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902ca0500b00180033438a0sm10808228pld.106.2022.12.05.08.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 08:23:07 -0800 (PST)
Date:   Mon, 5 Dec 2022 08:23:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     <Daniel.Machon@microchip.com>
Cc:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Message-ID: <20221205082305.51964674@hermes.local>
In-Reply-To: <Y426Pzdw5341RbCP@DEN-LT-70577>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
        <20221202092235.224022-2-daniel.machon@microchip.com>
        <20221203090052.65ff3bf1@hermes.local>
        <Y40hjAoN4VcUCatp@DEN-LT-70577>
        <20221204175257.75e09ff1@hermes.local>
        <Y426Pzdw5341RbCP@DEN-LT-70577>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Dec 2022 09:19:06 +0000
<Daniel.Machon@microchip.com> wrote:

> > > Trying to understand your comment.
> > >
> > > Are you talking about not producing any JSON output with the symbolic
> > > PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT_FP
> > > in case of printing in JSON context?
> > >
> > > /Daniel  
> > 
> > What does output look like in json and non-json versions?  
> 
> non-JSON: pcp-prio 1de:1
> JSON    : {"pcp_prio":[["1de",1]]}

Would the JSON be better as:
	{ "pcp_prio" :[ { "1de":1 } ] }

It looks like the PCP values are both unique and used in a name/value manner.

> 
> > My concern that the json version would be awkward and have colons in it, but looks
> > like it won't.  
> 
> Yeah, the "%s:" format is only used in non-JSON context, so we are good
> here.
> 
> > 
> > For the unknown key type is printing error necessary? Maybe just show it in numeric form.  
> 
> No not necessary, I'll get rid of it.

