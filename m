Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FFD567663
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiGES1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGES1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:27:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9995718E2D
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 11:27:17 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e132so12096413pgc.5
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 11:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JdqHzcPX4oGiiLBqKHpCQsJaaSCU20s5i1YlMAF6Bcg=;
        b=qMMm/qNpxmUwI+WJyBlm9l4xScD45QR1hnEZEvrZV0UMfriDbQz2j00hJyPqqtRF+g
         GtqUqtLDJTqjfw+scmGtXt5QPK7rBqHlD7p6PZoR4/UsFhtIrL06w6J96hEIVEDbvBv8
         /9qwq0Sjm+2OvrhphiEkJvmpxPJaC2+8Rx9ZwrKOB6fD5OgKjizBu1NwvYI9vu/oU3II
         /rNZKX8GlvVlDtVQic/QtLVTR7T53xAwffGrMEK7NqXfWbqQTLyZg0g7ptsQ6lrZl4lE
         5YZzB7dbA8slfdE1RjV97CTXvqPbnxufkZbYgyhfhBJiSMOC4aZWRRMBMw2+qd7+KT05
         TKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JdqHzcPX4oGiiLBqKHpCQsJaaSCU20s5i1YlMAF6Bcg=;
        b=bfb/MmriZ+AKjSoOmB58ww2gmBh6hEtEvbW9VYdXS9BDdAiw9ouoAk2ABGhuWBmtOg
         ZLxX2BwYVLBDWU8DSh7/8trmKv9T4R7RYqBQSXPlEab17gLyWYqh84r3nOABwZDdpGlX
         +f/ZUdCsPE39f7d1/8fMCmDD3Sblal2hn1o800ZWTXDuKR/J8vvNee3vc3aupeqHSMSN
         x+3t8fQQIgRRS4TRzld/8uTaXhr4vJoDNFNC8f7DaYyYfk4IFzzbV5sk6wiBrRJwQTpO
         5iQTB7jxuSMkk/ILLKn/8V6PgdX2rUwf9yVGbppRyKS7StNl7bSrpT8Q1bdrfoNAAc9l
         w+Uw==
X-Gm-Message-State: AJIora+blGU0/CoY80BPa6qdPDJajngziDltvPJunFtMSaHTOJjhGRmA
        WqS4sL49LCNky9ZyI9OTFyMIlA==
X-Google-Smtp-Source: AGRyM1sn+ljw7VPJjaeql/NiGTSsY8c1S29siW2527UZbUPjnp6BieUiF4kCejUc9lmo5Q+Lu7t6Vg==
X-Received: by 2002:a65:6b8a:0:b0:3fc:4c06:8a8d with SMTP id d10-20020a656b8a000000b003fc4c068a8dmr30438843pgw.83.1657045636868;
        Tue, 05 Jul 2022 11:27:16 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0016a1e2d148csm10924109plg.32.2022.07.05.11.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 11:27:16 -0700 (PDT)
Date:   Tue, 5 Jul 2022 11:27:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, corbet@lwn.net,
        jdmason@kudzu.us, vburru@marvell.com, jiawenwu@trustnetic.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <20220705112713.644cf3b4@hermes.local>
In-Reply-To: <20220705110634.4a66389a@kernel.org>
References: <20220701044234.706229-1-kuba@kernel.org>
        <Yr8rC9jXtoFbUIQ+@electric-eye.fr.zoreil.com>
        <20220701144010.5ae54364@kernel.org>
        <cbd7e14b3496229497ae49edbb68c04d4c1d7449.camel@redhat.com>
        <20220705110634.4a66389a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 11:06:34 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 05 Jul 2022 08:17:24 +0200 Paolo Abeni wrote:
> > On Fri, 2022-07-01 at 14:40 -0700, Jakub Kicinski wrote:  
> > > 100%, I really wish something like that existed. I have a vague memory
> > > of Fedora or some other distro collecting HW data. Maybe it died because
> > > of privacy issues?    
> > 
> > AFAICS that database still exists and is active:
> > 
> > https://linux-hardware.org/?view=search&vendor=neterion&d=All
> > 
> > It shows no usage at all for the relevant vendor.
> > 
> > On the flip side, it looks like the data points come mostly/exclusively
> > from desktop systems, not very relevant in this specific case.  
> 
> GTK! There is a whole bunch of old Mellanox NICs reported so I think
> there is _some_ server coverage. I'm leaning towards applying the patch.

Looks like S2IO became Neterion and then was acquired by Exar in 2010.
Then MaxLinear acquired Exar in 2017.
Looks like they dropped out of NIC business and only do switches??
