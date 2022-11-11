Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71237625725
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiKKJoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbiKKJoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:44:03 -0500
Received: from smtpcmd15177.aruba.it (smtpcmd15177.aruba.it [62.149.156.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 359981EEFF
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:43:39 -0800 (PST)
Received: from [192.168.1.56] ([79.0.204.227])
        by Aruba Outgoing Smtp  with ESMTPSA
        id tQZPoPQQp3YgotQZPoJOfp; Fri, 11 Nov 2022 10:43:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668159818; bh=+bEx1uEoRaO/z2uxx/3nL0xnRHJSgE5xQ63RH40pIpY=;
        h=Date:MIME-Version:Subject:To:From:Content-Type;
        b=bAJfv5/xdvV2IHNU4A/dbbT28v9oplXtogXmL7IOu4uEVwnrA7PP+sz8LjkKjKc1f
         y3GYAVqMCBYg2Sc606ICEHLqs4T1C+PhHHzNXmP/TLKGzEoTXlP8tR2etphlK7A6Fq
         jwWw1oNtKY9gGQR4WVJ2njNAzi2Z3OIO63F5OozumZyTVqbftZkFWAmVQdBPMT8KXa
         RK+w8lDvr/EU+H2nJRxZ4UcbEkZYHfiBaqUAv6qhTqVbEqlmgDCvzAgr7/wELYujbg
         5V6FDgTCX90P+wnSQQMmcduG/ixEeF1jBP45PSnHSE/bSUgpZx8JbMgOLE2uncXkUG
         Sig+s0m0KtRXg==
Message-ID: <114c9c4c-57b0-5cf5-2217-8bee3c94e6c7@enneenne.com>
Date:   Fri, 11 Nov 2022 10:43:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net br_netlink.c:y allow non "disabled" state for
 !netif_oper_up() links
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221109152410.3572632-1-giometti@enneenne.com>
 <20221109152410.3572632-2-giometti@enneenne.com> <Y2vkwYyivfTqAfEp@lunn.ch>
 <1c6ce1f3-a116-7a17-145e-712113a99f1e@enneenne.com>
 <Y2v1hORCE+dPkjwW@lunn.ch>
From:   Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <Y2v1hORCE+dPkjwW@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfO6RsjuGEopdU4gbcI6ej55cmBqeVnA3zWu+rKCBzKpM36QmG9z5Ww2mr/h/esnDcVP5ZIPwsDzGWK6n/stwzAv02IIrjewGNxaltqsrfnHn8UtMswyt
 5EBr7DNsNqr8tI3LeWB7/96Cew/AiWvrfUeT7IweniiaSYOQAsiokc6XJKj7thmAznd7gbQLoKEpXoh1HL9Z3Jyq1INhnFiAEeMRBiZvzg0qoXoqqqfML9KA
 9/wQOfpPN+ENqQDuQiHKsHDIV9iYnrBYoBuqMYjijxKD7+6xwZcAaNYkIskal1UWn2InQDTP5Y/sLYuEVq4EQ2P2It74e200mHCCBGqT6G/255oPkzd7om+p
 NCWEy9a1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE,T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/22 19:46, Andrew Lunn wrote:
> On Wed, Nov 09, 2022 at 07:19:22PM +0100, Rodolfo Giometti wrote:
>> On 09/11/22 18:34, Andrew Lunn wrote:
>>> On Wed, Nov 09, 2022 at 04:24:10PM +0100, Rodolfo Giometti wrote:
>>>> A generic loop-free network protocol (such as STP or MRP and others) may
>>>> require that a link not in an operational state be into a non "disabled"
>>>> state (such as listening).
>>>>
>>>> For example MRP states that a MRM should set into a "BLOCKED" state (which is
>>>> equivalent to the LISTENING state for Linux bridges) one of its ring
>>>> connection if it detects that this connection is "DOWN" (that is the
>>>> NO-CARRIER status).
>>>
>>> Does MRP explain Why?
>>>
>>> This change seems odd, and "Because the standard says so" is not the
>>> best of explanations.
>>
>> A MRM instance has two ports: primary port (PRM_RPort) and secondary port
>> (SEC_RPort).
>>
>> When both ports are UP (that is the CARRIER is on) the MRM is into the
>> Ring_closed state and the PRM_RPort is in forwarding state while the
>> SEC_RPort is in blocking state (remember that MRP blocking is equal to Linux
>> bridge listening).
>>
>> If the PRM_RPort losts its carrier and the link goes down the normative states that:
>>
>> - ports role swap (PRM_RPort becomes SEC_RPort and vice versa).
>>
>> - SEC_RPort must be set into blocking state.
>>
>> - PRM_RPort must be set into forwarding state.
>>
>> Then the MRM moves into a new state called Primary-UP. In this state, when
>> the SEC_RPort returns to UP state (that is the CARRIER is up) it's returns
>> into the Ring_closed state where both ports have the right status, that is
>> the PRM_RPort is in forwarding state while the SEC_RPort is in blocking
>> state.
>>
>> This is just an example of one single case, but consider that, in general,
>> when the carrier is lost the port state is moved into blocking so that when
>> the carrier returns the port it's already into the right state.
>>
>> Hope it's clearer now.
> 
> Yes, please add this to the commit message. The commit message is
> supposed to explain Why, and this is a good example.

OK. I'm going to do it in v2.

>> However, despite this special case, I think that kernel code should
>> implement mechanisms and not policies, shouldn't it? If user space needs a
>> non operational port (that is with no carrier) into the listening state, why
>> we should prevent it?
> 
> Did you dig deeper? Does the bridge make use of switchdev to tell the
> hardware about this state change while the carrier is down?

I think so since the function br_set_state() do it.

> I also
> wonder what the hardware drivers do? Since this is a change in
> behaviour, they might not actually do anything.

For instance Marvell switches just set the state (see 
linux/drivers/net/dsa/mv88e6xxx/port.c) without checking for carrier status:

int mv88e6xxx_port_set_state(struct mv88e6xxx_chip *chip, int port, u8 state)
{
         u16 reg;
         int err;

         err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
         if (err)
                 return err;

         reg &= ~MV88E6XXX_PORT_CTL0_STATE_MASK;

         switch (state) {
         case BR_STATE_DISABLED:
                 state = MV88E6XXX_PORT_CTL0_STATE_DISABLED;
                 break;
         case BR_STATE_BLOCKING:
         case BR_STATE_LISTENING:
                 state = MV88E6XXX_PORT_CTL0_STATE_BLOCKING;
                 break;
         case BR_STATE_LEARNING:
                 state = MV88E6XXX_PORT_CTL0_STATE_LEARNING;
                 break;
         case BR_STATE_FORWARDING:
                 state = MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
                 break;
         default:
                 return -EINVAL;
         }

         reg |= state;

         err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
         if (err)
                 return err;

         dev_dbg(chip->dev, "p%d: PortState set to %s\n", port,
                 mv88e6xxx_port_state_names[state]);

         return 0;
}

> So then you have to
> consider does it make sense for the bridge to set the state again
> after the carrier comes up?

Yes, of course we can do it but (in case of MRP) the state machine must be 
altered in several points and, again, why the kernel should force such behaviour 
(i.e. introducing a policy) when drivers just don't consider it (see the above 
example).

The kernel should implement mechanisms while all policies should be into user space.

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti

