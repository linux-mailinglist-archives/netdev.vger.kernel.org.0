Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9ABB4E2B3E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349646AbiCUOwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345489AbiCUOwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:52:36 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D5C12AD7;
        Mon, 21 Mar 2022 07:51:09 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p15so14267531lfk.8;
        Mon, 21 Mar 2022 07:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=V9QJhItuGj131X5U24BIjE6xMJa7ckWXlhf3pX2Qb7w=;
        b=hVNxEkMPFhWNhQ6oKe5bcnNri0UMhznsBewxDmrB8a18rPDQXU3w3+ibFl3giYgcO7
         3LN7H+LGrRc8+f9qHNriFO15Z1jKztavMZK70q4eTDKCHkuQR88FoUssKCzIGjwdOSxe
         qZQNNLp0xRmS6obHoFrpMzCT/FYV73BTqJY31XKRw/zPyPF46kovinfnipbgxvR9QuDc
         pCCb4FMiYS40owPPP25hJu0RaJq/CIQ/NEaJUnQ8HV0t3Gdljf2j0pYGjvYfr9ShOHnL
         wlnXEPW8WEFbrLzBP3BqMFI2Pi0JtDjaVvcDx0NVEP6+oQB2HcrzMxIoxsLTWr+2qdeR
         U5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=V9QJhItuGj131X5U24BIjE6xMJa7ckWXlhf3pX2Qb7w=;
        b=O2ejeiXANLA0uIv9NVON1IqjAv11xLOjfuU6qgEBxL6BDuYYaRcYNs0ZsC4urA8axo
         CAIMjtadbAfIMWMO6az6mQC3z5x+xsTXSBxabSaZkFgVA1Ebn0PEvh8aRxb39x/0oUO9
         VzvcF1HeQ5cfsOSSFt4y0GNDrCumu6ffXk8Yr4UcEfGqHeNRyUMVH9s+w5PXNd/iMq6g
         92PYGGbAjvUGspcaQ6LZF9VnT/OFjPG6ZWjMGK3mdUB0Yvrd8VZDKoNXwA4RTKZ5cgnv
         boVSLosuPpWtK//5DiSA5exGSMwuJKxiC8wp5MtkP4Mzx0lnhqxBo55SWD8naWCG0f+Q
         vlqw==
X-Gm-Message-State: AOAM532CNZ672kG46dbTsoKULSUBUXxiVCC7EuNggPYyMC5uzVj/H+7k
        OXoESFLHURjhQNavgkC+UZpKiVodmq8=
X-Google-Smtp-Source: ABdhPJy/zkuOFRI5NSGnx6DSDrPaX00+ZIvAAggAOHT0Nhrt9aFLL0ndDJXWs/3Gt43hJTyUnWwrbQ==
X-Received: by 2002:ac2:4ed4:0:b0:44a:212e:fa1a with SMTP id p20-20020ac24ed4000000b0044a212efa1amr7065503lfr.372.1647874265558;
        Mon, 21 Mar 2022 07:51:05 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id bu1-20020a056512168100b004437db5e773sm1829487lfb.94.2022.03.21.07.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 07:51:05 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Hans Schultz <schultz.hans@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
In-Reply-To: <YjNDgnrYaYfviNTi@lunn.ch>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf> <86r17495gk.fsf@gmail.com>
 <20220316233447.kwyirxckgancdqmh@skbuf> <86lex9hsg0.fsf@gmail.com>
 <YjNDgnrYaYfviNTi@lunn.ch>
Date:   Mon, 21 Mar 2022 15:51:02 +0100
Message-ID: <86czifxstl.fsf@gmail.com>
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

On tor, mar 17, 2022 at 15:19, Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Mar 17, 2022 at 09:52:15AM +0100, Hans Schultz wrote:
>> On tor, mar 17, 2022 at 01:34, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Mon, Mar 14, 2022 at 11:46:51AM +0100, Hans Schultz wrote:
>> >> >> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>> >> >>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>> >> >>  				    entry.mac, entry.portvec, spid);
>> >> >>  		chip->ports[spid].atu_miss_violation++;
>> >> >> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
>> >> >> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
>> >> >> +									    chip->ports[spid].port,
>> >> >> +									    &entry,
>> >> >> +									    fid);
>> >> >
>> >> > Do we want to suppress the ATU miss violation warnings if we're going to
>> >> > notify the bridge, or is it better to keep them for some reason?
>> >> > My logic is that they're part of normal operation, so suppressing makes
>> >> > sense.
>> >> >
>> >> 
>> >> I have been seeing many ATU member violations after the miss violation is
>> >> handled (using ping), and I think it could be considered to suppress the ATU member
>> >> violations interrupts by setting the IgnoreWrongData bit for the
>> >> port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?
>> >
>> > So the first packet with a given MAC SA triggers an ATU miss violation
>> > interrupt.
>> >
>> > You program that MAC SA into the ATU with a destination port mask of all
>> > zeroes. This suppresses further ATU miss interrupts for this MAC SA, but
>> > now generates ATU member violations, because the MAC SA _is_ present in
>> > the ATU, but not towards the expected port (in fact, towards _no_ port).
>> >
>> > Especially if user space decides it doesn't want to authorize this MAC
>> > SA, it really becomes a problem because this is now a vector for denial
>> > of service, with every packet triggering an ATU member violation
>> > interrupt.
>> >
>> > So your suggestion is to set the IgnoreWrongData bit on locked ports,
>> > and this will suppress the actual member violation interrupts for
>> > traffic coming from these ports.
>> >
>> > So if the user decides to unplug a previously authorized printer from
>> > switch port 1 and move it to port 2, how is this handled? If there isn't
>> > a mechanism in place to delete the locked FDB entry when the printer
>> > goes away, then by setting IgnoreWrongData you're effectively also
>> > suppressing migration notifications.
>> 
>> I don't think such a scenario is so realistic, as changing port is not
>> just something done casually, besides port 2 then must also be a locked
>> port to have the same policy.
>
> I think it is very realistic. It is also something which does not work
> is going to cause a lot of confusion. People will blame the printer,
> when in fact they should be blaming the switch. They will be rebooting
> the printer, when in fact, they need to reboot the switch etc.
>
> I expect there is a way to cleanly support this, you just need to
> figure it out.
>
>> The other aspect is that the user space daemon that authorizes catches
>> the fdb add entry events and checks if it is a locked entry. So it will
>> be up to said daemon to decide the policy, like remove the fdb entry
>> after a timeout.
>> 
>> >
>> > Oh, btw, my question was: could you consider suppressing the _prints_ on
>> > an ATU miss violation on a locked port?
>> 
>> As there will only be such on the first packet, I think it should be
>> logged and those prints serve that purpose, so I think it is best to
>> keep the print.
>> If in the future some tests or other can argue for suppressing the
>> prints, it is an easy thing to do.
>
> Please use a traffic generator and try to DOS one of your own
> switches. Can you?
>
> 	  Andrew

Here is a trafgen report, where I sent packets to a locked port with random SAs:

    42527020 packets outgoing
  3104472460 bytes outgoing
         329 sec, 989345 usec on CPU0 (5835746 packets)
         329 sec, 985243 usec on CPU1 (2119061 packets)
         329 sec, 997323 usec on CPU2 (5656546 packets)
         329 sec, 989475 usec on CPU3 (5617322 packets)
         330 sec, 5228 usec on CPU4 (6034671 packets)
         330 sec, 1603 usec on CPU5 (5833505 packets)
         329 sec, 989319 usec on CPU6 (5709841 packets)
         329 sec, 989294 usec on CPU7 (5720328 packets)

I could do 'bridge fdb show' after stopping the traffic, printing out a
very long list (minutes to print). The ATU was normal, so there is an
issue of the soft FDB locked entries not ageing out.

I saw many reports of suppressed IRQs in the kernel log.
