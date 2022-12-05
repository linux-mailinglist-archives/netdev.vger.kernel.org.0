Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F1264213D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 02:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiLEBxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 20:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiLEBxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 20:53:01 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3547DA1BF
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 17:53:00 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso13433608pjt.0
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 17:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cv01xP8yD1pLQdBMiW8llxOgvujaBzqApEAeFFToLyg=;
        b=Niy6NB+a9RaUEzO4zJBaJsUSsRFmkNuhitheOCLY6vvObVYl8dWZiIUXLkZu5GVZXh
         1okwS/ABV5ZyOnw86Ji3LCHk5EKcte9X1QpZYToWIgWbcoDEXn1aP617cZAOokpD2pj/
         W+i2AfZMGavMdMuwMRml0pjBVTvY/hRPdq4NBbNoWmAy+wrtWvSI9auvmWXUcPz0Evlu
         0RaBzi6dGdS7bpMV6uR+1I/yBsBb4rPG7lzceBxobY/99300AXmsHfRahxE8XU6UCEH7
         EnrXl2KpFYj6PhZdL/IAmUHit/sbg8xghOGKkf6S09QzesjxJyOcZPB+vj5vgSGgpZW7
         eNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cv01xP8yD1pLQdBMiW8llxOgvujaBzqApEAeFFToLyg=;
        b=g2TsP8Zm0DKafBLWke3UT5l6E3SOoHtzf+YZTkfKls4yY8FX1NZWpOG+o89gtR6MuY
         uRZ2XhYgaWEkr/19cNCDQ/5Axb9dpS672cbL3QMsQCeZBk9Z7sOLe4px+EEazf68I6qq
         yObEI7tfhelU9q00gfREU4J7AEu/xiOR4Wqu5RLdVLEodXy4SZon923EbRx6u6hOEBGg
         va2lhMBFQH1hOcKxK+5/hSN+2PYr7LJ2yNCZ6N6M0VDWtAVkRpW4NwFmVBRQzd2F+vvm
         8oRXsUxou7+FDrJmvAja5UK7W1a3szLVYhdFp1EKhshyza/j2uts5ho3MbyTIntO2afB
         mc6w==
X-Gm-Message-State: ANoB5pnI0FmPjAlC1fRRgHengYiWRrkQepGi2Sw7S1lf6eedH8Xom4RN
        c37FdKetnmTkIuZWtx+dDzWDGg==
X-Google-Smtp-Source: AA0mqf7FmmYt0zqBRqFJKdQO8vG64ajZLzxYh4Kh1onKH9BzesKfOGYmOZxLYntQya6IFN/ff8e28Q==
X-Received: by 2002:a17:90a:c68d:b0:219:d415:d787 with SMTP id n13-20020a17090ac68d00b00219d415d787mr2849223pjt.127.1670205179639;
        Sun, 04 Dec 2022 17:52:59 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x17-20020aa79ad1000000b005736209dc01sm8597713pfp.47.2022.12.04.17.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 17:52:59 -0800 (PST)
Date:   Sun, 4 Dec 2022 17:52:57 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     <Daniel.Machon@microchip.com>
Cc:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Message-ID: <20221204175257.75e09ff1@hermes.local>
In-Reply-To: <Y40hjAoN4VcUCatp@DEN-LT-70577>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
        <20221202092235.224022-2-daniel.machon@microchip.com>
        <20221203090052.65ff3bf1@hermes.local>
        <Y40hjAoN4VcUCatp@DEN-LT-70577>
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

On Sun, 4 Dec 2022 22:27:40 +0000
<Daniel.Machon@microchip.com> wrote:

> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Fri, 2 Dec 2022 10:22:34 +0100
> > Daniel Machon <daniel.machon@microchip.com> wrote:
> >   
> > > +static int dcb_app_print_key_pcp(__u16 protocol)
> > > +{
> > > +     /* Print in numerical form, if protocol value is out-of-range */
> > > +     if (protocol > DCB_APP_PCP_MAX) {
> > > +             fprintf(stderr, "Unknown PCP key: %d\n", protocol);
> > > +             return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> > > +     }
> > > +
> > > +     return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
> > > +}  
> > 
> > This is not an application friendly way to produce JSON output.
> > You need to put a key on each one, and value should not contain colon.  
> 
> Hi Stephen,
> 
> Trying to understand your comment.
> 
> Are you talking about not producing any JSON output with the symbolic
> PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT_FP
> in case of printing in JSON context?
> 
> /Daniel

What does output look like in json and non-json versions?
My concern that the json version would be awkward and have colons in it, but looks
like it won't.

For the unknown key type is printing error necessary? Maybe just show it in numeric form.
