Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858B15E5648
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIUWdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiIUWdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:33:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB819A9CE
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:33:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so268183pjq.3
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=jSQgaxVCr1WD4T3jDJZv1HzRqv2UkzFmJdALUm2+/4A=;
        b=UFlEWd9WqvA6udfHOyikRJwnjOojIPCuoQtAubltxN7X6wCqu/ugrQvEGkvVX4aZTF
         V+Y0EGQBKy4lqsGuL7cdLoFyNGbAH0kCcaFCPpgp5lQ757JtmyDU2jqSrjaamptPh25U
         Qj7Tr0/IObSdks4ci4OJHIFNilz/xQv/lArCsC81dieARGp5Grcvwf9jG/QqcidPwODP
         jb9cWLnAH1fuebbNY7Fy6PhjYsr1I7kdU8iMCYYPq8yHZev18VjDEHuTxsn4aV8GBVrw
         POnqM+P01fllV60p8YTKEPS2CzpgFEs6TKobd+8yIt8I7dbpbowTUiI9xWqT8iYEnVcS
         jDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jSQgaxVCr1WD4T3jDJZv1HzRqv2UkzFmJdALUm2+/4A=;
        b=NhdiEWoxyf1QbKTEeun0wx18YAt4zzH/LIaxN3eHcxihUYB2K102E5M/9jviMumhyI
         beqk47vx/2p1zIzCeqTvr1HCzYdo9e/znjXCOyJuYmwwzCVjP35uMfxiAGAE0R/3YTie
         1MNaqGUeo/Nn8mr+a23txA3gIbc1lvAVKjm5ynU34rXuVz2fdQy5EqH9XttzeotRJgfL
         s6zPz8nxFVU/VxxYv95o0IqzsuUVuvWLa9+s/Sew2xP57Mw8e34eiM6oGucQeAEx0YQ2
         rE8VWjpBeUDbqlHJfAagQsahHRP3Kv/KaDg+U5EzZHwqLBm96V2SrmaCqXv9ImThQ+1K
         yf9w==
X-Gm-Message-State: ACrzQf1l3/peepBVzddPNQ8aRP0hkD89w6TRhCte4a6fepQ85HEK3k+3
        wz3B7vZmciAO3NGEGN82l6OnrA==
X-Google-Smtp-Source: AMsMyM631ddGChMSy0u8nmBiy9BvDUH38+E4NR34yF8LOEdqPQ0HmUQo2z+uqz+vka05tHRTG4HzKQ==
X-Received: by 2002:a17:902:ce8d:b0:178:6e80:bcb4 with SMTP id f13-20020a170902ce8d00b001786e80bcb4mr424129plg.82.1663799631187;
        Wed, 21 Sep 2022 15:33:51 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x16-20020aa79a50000000b00543780ba53asm2680869pfj.124.2022.09.21.15.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:33:51 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:33:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220921153349.0519c35d@hermes.local>
In-Reply-To: <20220921183827.gkmzula73qr4afwg@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
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

On Wed, 21 Sep 2022 18:38:28 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, Sep 21, 2022 at 11:36:37AM -0700, Stephen Hemminger wrote:
> > On Wed, 21 Sep 2022 19:51:05 +0300
> > Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >   
> > > +.BI master " DEVICE"
> > > +- change the DSA master (host network interface) responsible for handling the
> > > +local traffic termination of the given DSA switch user port. The selected
> > > +interface must be eligible for operating as a DSA master of the switch tree
> > > +which the DSA user port is a part of. Eligible DSA masters are those interfaces
> > > +which have an "ethernet" reference towards their firmware node in the firmware
> > > +description of the platform, or LAG (bond, team) interfaces which contain only
> > > +such interfaces as their ports.  
> > 
> > We still need to find a better name for this.
> > DSA predates the LF inclusive naming but that doesn't mean it can't be
> > fixed in user visible commands.  
> 
> Need? Why need? Who needs this and since when?

There is no reason that words with long emotional history need to be used
in network command.

https://inclusivenaming.org/word-lists/

https://inclusivenaming.org/word-lists/tier-1/

I understand that you and others that live in different geographies may
have different feelings about this. But the goal as a community to
not use names and terms that may hinder new diverse people from
being involved.
