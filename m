Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31980511F90
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241335AbiD0QF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbiD0QFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:05:09 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDEF2E97B4
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:01:47 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t13so1785449pgn.8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dw+HAYOwCfNXbVbq5HbCrDM1JADR4Mk+mJGW+pVBpEU=;
        b=7MZ12ghjkOxi1opxfKBfWTLR/feI1ZQ0N6le1PnXBKWFkrEsDMfRPfwqtYJtmV4iyP
         RU6g+15l/K56dXIGIWtX1bzbZY1bIqry3SnRynlkdzX9llCUj5Bw7JqxgRiNyNqzcdgB
         X54ooyGSsUqWyJASlulXWQN+mS25UziDmsrX8VgXyLrCC5VxU7xo1o5mm1wnStvMTxlj
         Jyd7DroT79zO/A2vCTro6m13ePOB54KGQOvLbfd4qzCRGX2tL3/59TFdiNc3oGhGycCr
         VtrzuMTYyAjs2LKQ1wMRZ2YS+I92ZpxHnEM1p2tE6ovRwChFR2RR/+Y+ZXdxf9sLESiz
         N7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dw+HAYOwCfNXbVbq5HbCrDM1JADR4Mk+mJGW+pVBpEU=;
        b=3xURX6EnnPhu+L/IWHF/s3JsbAxUSBXsHze1wrdj04QvVBze5OnQy7xQqvRe98kh/5
         XRmQgGhfr2kzoSBjsiDhbC/2zPk5DMJdVUZQjVm3QnH3GfekRXMA9rHDfHb0u/bnw++B
         9vCPo80XNhPG9HTcqvGkvlJxBLw3NZmmEkaT3k0K9liIb9Ct69+OUBiiYF7ZybG9AvYo
         fz8+lacunxTCH97hY0aTqmM/KnSnJNJFnKNmQ1GlGGx+joGVuUGxrBHpX4a8YSqvaUAU
         nlPcdYzw/kFw4QsWtUq62fw7N1JKlPSeAADQVawBQrKVmedCFBnWvjSI4PG3hTbFhYyb
         uzjw==
X-Gm-Message-State: AOAM533ZD5fMctNmeVisZ07lCPHrs2mp4cgBuTLf48AJyzYopVR/7RaW
        NgunRhYFKjj1UJwdiNzpyvDuEA==
X-Google-Smtp-Source: ABdhPJzBsObLXEbeTUUc4N2YEIvyKmMOq6wPw/EETja9ITivzJEkzimyPL0MD9vGY51KX1fQA/iU2Q==
X-Received: by 2002:a65:410a:0:b0:399:38b9:8ba with SMTP id w10-20020a65410a000000b0039938b908bamr24213036pgp.526.1651075306584;
        Wed, 27 Apr 2022 09:01:46 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id w11-20020a17090a4f4b00b001d8abe4bb17sm3198081pjl.32.2022.04.27.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:01:46 -0700 (PDT)
Date:   Wed, 27 Apr 2022 09:01:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH iproute2-next v3 0/2] f_flower: match on the number of
 vlan tags
Message-ID: <20220427090143.20d75544@hermes.local>
In-Reply-To: <20220427143200.GA23481@noodle>
References: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
        <20220426081142.71d58c1b@hermes.local>
        <20220427143200.GA23481@noodle>
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

On Wed, 27 Apr 2022 17:32:00 +0300
Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:

> Hi Stephen,
> 
> On Tue, Apr 26, 2022 at 08:11:42AM -0700, Stephen Hemminger wrote:
> > On Tue, 26 Apr 2022 12:14:15 +0300
> > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> >   
> > > Hi,
> > > 
> > > Our customers in the fiber telecom world have network configurations
> > > where they would like to control their traffic according to the number
> > > of tags appearing in the packet.
> > > 
> > > For example, TR247 GPON conformance test suite specification mostly
> > > talks about untagged, single, double tagged packets and gives lax
> > > guidelines on the vlan protocol vs. number of vlan tags.
> > > 
> > > This is different from the common IT networks where 802.1Q and 802.1ad
> > > protocols are usually describe single and double tagged packet. GPON
> > > configurations that we work with have arbitrary mix the above protocols
> > > and number of vlan tags in the packet.
> > > 
> > > The following patch series implement number of vlans flower filter. They
> > > add num_of_vlans flower filter as an alternative to vlan ethtype protocol
> > > matching. The end result is that the following command becomes possible:
> > > 
> > > tc filter add dev eth1 ingress flower \
> > >   num_of_vlans 1 vlan_prio 5 action drop
> > > 
> > > Also, from our logs, we have redirect rules such that:
> > > 
> > > tc filter add dev $GPON ingress flower num_of_vlans $N \
> > >      action mirred egress redirect dev $DEV
> > > 
> > > where N can range from 0 to 3 and $DEV is the function of $N.
> > > 
> > > Also there are rules setting skb mark based on the number of vlans:
> > > 
> > > tc filter add dev $GPON ingress flower num_of_vlans $N vlan_prio \
> > >     $P action skbedit mark $M
> > > 
> > > Thanks,
> > > Boris.
> > > 
> > > - v3: rebased to the latest iproute2-next
> > > - v2: add missing f_flower subject prefix
> > > 
> > > Boris Sukholitko (2):
> > >   f_flower: Add num of vlans parameter
> > >   f_flower: Check args with num_of_vlans
> > > 
> > >  tc/f_flower.c | 57 ++++++++++++++++++++++++++++++++++++---------------
> > >  1 file changed, 41 insertions(+), 16 deletions(-)  
> > 
> > Can you do this with BPF? instead of kernel change?  
> 
> You may have missed my reply to this question at:
> 
> https://lore.kernel.org/netdev/20220412104514.GB27480@noodle/
> 
> There is also Jamal's reply further at the thread:
> 
> https://lore.kernel.org/netdev/b2c83f63-a2e9-92a2-f262-3aae3491dfc3@mojatatu.com/
> 
> Thanks,
> Boris.

Thanks, there is a tradeoff here, if you add more logic to the kernel, it
impacts every user and creates long term technical debt. Your use case seemed
quite specific to single use case.

But also, it is an example of something where kernel already has the state
information and it might be hard to get with BPF.

Surprised that the people who do BPF at scale did not chime in on this discussion.
