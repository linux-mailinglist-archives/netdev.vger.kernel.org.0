Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAE14DC1EA
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiCQIxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiCQIxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:53:41 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D605D1CFB;
        Thu, 17 Mar 2022 01:52:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id c15so6290697ljr.9;
        Thu, 17 Mar 2022 01:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=utKCqy7VusDzWJzGDfUfuV+/FoQNmgt468RWLPQd6V0=;
        b=NM6sOaIQvQf9NIJbbFjBIfyieIyU0skVM5rgUkl9FvZneQx2HSPloiBsWeAcsEJzIb
         NP+QzwvBMcuqA2GBaLyzFGxWzrlnzsV8VrzL7WNizIZj9AmgCSOpfy8PHPEhYNC07GNK
         uAmgZWBx9AvC75LJ+jAqm51M56zcFNQyiW3wpajVfafRVeSUAesvWV+m1NrZ32VEQ+KY
         ev2CHEKQf6mBiYGgLNdxzKfXjACQoAbLDzyD7hwFj74JBAXw0BfifRaX7j07i4Hvlofx
         BNBp4OySem/jZbF3Bhd8Ssrowh7qIzGpf0ApNsr8qB4IHbqjlzraGU8nhnfdgS8aUZdn
         AXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=utKCqy7VusDzWJzGDfUfuV+/FoQNmgt468RWLPQd6V0=;
        b=S+ziMxVRiBZLxUaDAO2dHcBBf1ghNTZczgvWkxUXPFF2+Cqrg6wSUDwNSM9iRmyPxs
         nes51uc62Wfu5F4CRbEZiKUmtKtoT2JJuKI+bJpi2fQlxBIvIq4QHebpb0NTBPuJrCJl
         LTAb+DFnp+4tfg3JiBpWWgOje3btArkL30Ugbx5KPCkpqdyX4jL9E1RZe2vRtNCmlX7A
         1Dl1yravnFqAt8sUr+y2KFQ3vrV926v0pGYvuDNKKEsMEAl0uKAnOC28r7CUxyteHIVg
         tCpE2LRbTGdxiSNIfD20j6XnshBbczhEdhlYFp63QQSFLIDwTq4rVhwGkixOkyJ4CO3d
         8hOg==
X-Gm-Message-State: AOAM533B+q/Ys74P9eHQb/qP6nWPpQh/gDFpqRa/TEJaWB934WhuKgTU
        Sdv1/+vHP/rL7iinQDhSSjI=
X-Google-Smtp-Source: ABdhPJwoAa1OhOh+IkuyXalL41IHoOBMMg8O2b36bpTO7l5x0ToxGn+f9QvlfvC2lUqe8mYWqoDMiA==
X-Received: by 2002:a2e:bd13:0:b0:246:1ff8:6da1 with SMTP id n19-20020a2ebd13000000b002461ff86da1mr2173758ljq.219.1647507143460;
        Thu, 17 Mar 2022 01:52:23 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id u27-20020ac25bdb000000b004485984616bsm388993lfn.296.2022.03.17.01.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:52:22 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220316233447.kwyirxckgancdqmh@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf> <86r17495gk.fsf@gmail.com>
 <20220316233447.kwyirxckgancdqmh@skbuf>
Date:   Thu, 17 Mar 2022 09:52:15 +0100
Message-ID: <86lex9hsg0.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 17, 2022 at 01:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 14, 2022 at 11:46:51AM +0100, Hans Schultz wrote:
>> >> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>> >>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>> >>  				    entry.mac, entry.portvec, spid);
>> >>  		chip->ports[spid].atu_miss_violation++;
>> >> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
>> >> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
>> >> +									    chip->ports[spid].port,
>> >> +									    &entry,
>> >> +									    fid);
>> >
>> > Do we want to suppress the ATU miss violation warnings if we're going to
>> > notify the bridge, or is it better to keep them for some reason?
>> > My logic is that they're part of normal operation, so suppressing makes
>> > sense.
>> >
>> 
>> I have been seeing many ATU member violations after the miss violation is
>> handled (using ping), and I think it could be considered to suppress the ATU member
>> violations interrupts by setting the IgnoreWrongData bit for the
>> port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?
>
> So the first packet with a given MAC SA triggers an ATU miss violation
> interrupt.
>
> You program that MAC SA into the ATU with a destination port mask of all
> zeroes. This suppresses further ATU miss interrupts for this MAC SA, but
> now generates ATU member violations, because the MAC SA _is_ present in
> the ATU, but not towards the expected port (in fact, towards _no_ port).
>
> Especially if user space decides it doesn't want to authorize this MAC
> SA, it really becomes a problem because this is now a vector for denial
> of service, with every packet triggering an ATU member violation
> interrupt.
>
> So your suggestion is to set the IgnoreWrongData bit on locked ports,
> and this will suppress the actual member violation interrupts for
> traffic coming from these ports.
>
> So if the user decides to unplug a previously authorized printer from
> switch port 1 and move it to port 2, how is this handled? If there isn't
> a mechanism in place to delete the locked FDB entry when the printer
> goes away, then by setting IgnoreWrongData you're effectively also
> suppressing migration notifications.

I don't think such a scenario is so realistic, as changing port is not
just something done casually, besides port 2 then must also be a locked
port to have the same policy.

The other aspect is that the user space daemon that authorizes catches
the fdb add entry events and checks if it is a locked entry. So it will
be up to said daemon to decide the policy, like remove the fdb entry
after a timeout.

>
> Oh, btw, my question was: could you consider suppressing the _prints_ on
> an ATU miss violation on a locked port?

As there will only be such on the first packet, I think it should be
logged and those prints serve that purpose, so I think it is best to
keep the print.
If in the future some tests or other can argue for suppressing the
prints, it is an easy thing to do.
