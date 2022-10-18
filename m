Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA486028CE
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJRJzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJRJzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:55:22 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE73A02DD;
        Tue, 18 Oct 2022 02:55:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sc25so30847130ejc.12;
        Tue, 18 Oct 2022 02:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ezse1qs61ywJKaWI6GQ5oG9AI3Vzl0WMY+NM494WQY4=;
        b=D+6rZt1RQiwvRVqD63cJ19HebnHGec0qlCI2w7BHrtTbkq8hCNzhBIYSbby9OGqtA5
         oF1MesMyrmZk6JBEfK3z36Exd/fPzRFxg3sJUaKLeZ6fU3+ZDxJVsm+53wqgYEyP65G8
         PPLtrdT3Y/gR6BhVkKA3Vsf6MeudkUkkvmytL9FrINIOHPuigYEmt+oGYGXEgN8mHDUp
         T1D+VDL5Tslw6DlHuJdkUTUsYUSVx2j33QstbR722+cqEPALnW6MkHQLEBw8PewyNgP3
         2Vk/8B88/nCmlWDbRQcY7K4Uz5EwnEvk6xZ0Vl9bSiOU7TRI4m5+ZbSz4rEdjEejUCw7
         rmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezse1qs61ywJKaWI6GQ5oG9AI3Vzl0WMY+NM494WQY4=;
        b=kMQNkOMcYudcFUL3agPoQprNmFv/DTnDHgCjL5h2ozkFqJFNUUntf3kT6+Yal6XYZS
         GkmFZqSG2V+nNSq77PreSVbEZ+8iXTM+aR4x5IliLv5/yXgnb648FN1vG2VT/1BVhb74
         ouj8z1FvPauqYdKCDRG3XMXi6h376bYd6wkjxGenr0FrKaTPqD1/GnZK/EThDFhRHcq9
         XV0Fhq7P73AnicaySAxed4+7bLwXU3mVMdaJI6K3uAMLGiI66VqTCJPtw//xx3VuLJ5O
         eRh6kC6B16yhyfHCcwzf8BEaOaQMjm1WCYgVIBIyEy7o+QZGOPtbO90wqUDdV4d+FQ17
         dSnw==
X-Gm-Message-State: ACrzQf2jVWVHMtw0ZwtvKTlCwQM0GcKf9y7m32kZl0HArXq3VYNdd6NQ
        SjFuRGnauL/nd2eQKlT7S1c=
X-Google-Smtp-Source: AMsMyM7aepROuPXPuVh7r276WkRVP4fFBkx6fqn77BknscK5bi7fmwahMfq/i6lyYvuoDuPb7ccwvQ==
X-Received: by 2002:a17:906:eec9:b0:73d:c369:690f with SMTP id wu9-20020a170906eec900b0073dc369690fmr1709745ejb.767.1666086918399;
        Tue, 18 Oct 2022 02:55:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b0078d9cd0d2d6sm7478888ejo.11.2022.10.18.02.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:55:17 -0700 (PDT)
Date:   Tue, 18 Oct 2022 12:55:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Message-ID: <20221018095515.tnhqjlyvu3dmtn3q@skbuf>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
 <20221017184649.meh7snyhvuepan25@skbuf>
 <ce76fa72ad1dd9d4f86a0bdcbd2ae473e2f29262.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce76fa72ad1dd9d4f86a0bdcbd2ae473e2f29262.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:29:17AM +0000, Arun.Ramadoss@microchip.com wrote:
> > On Fri, Oct 14, 2022 at 08:58:51PM +0530, Arun Ramadoss wrote:
> > > The LAN937x switch has capable for supporting IEEE 1588 PTP protocol. This
> > > patch series add gPTP profile support and tested using the ptp4l application.
> > > LAN937x has the same PTP register set similar to KSZ9563, hence the
> > > implementation has been made common for the ksz switches. But the testing is
> > > done only for lan937x switch.
> > 
> > Unrelated to the proposed implementation. What user space stack do you
> > use for gPTP bridging?
> 
> I had used LinuxPTP stack for testing this patch set and in specific
> linuxptp/configs/gptp.cfg 
> 
> Test Setup is of
> LAN9370 DUT1 <LAN1> --- LAN9370 DUT2 <LAN1>
> 
> Ran the below command in both DUTS
> #ptp4l -f ~/linuxptp/configs/gptp.cfg -i lan1

gPTP bridges are when you specify "-i" more than once, similar to how
1588 boundary clocks are created in ptp4l. Linuxptp does not support
gPTP bridges; the time information needs to be relayed differently
compared to both a BC and a TC, and there is also a Follow_Up information
TLV which needs to be updated.

So I guess the answer is, you don't test gPTP bridging, ok.
