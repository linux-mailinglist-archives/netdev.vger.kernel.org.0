Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11097631204
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 01:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiKTAND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 19:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKTANC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 19:13:02 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 19 Nov 2022 16:12:58 PST
Received: from smtpdh16-1.aruba.it (smtpdh16-1.aruba.it [62.149.155.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EB8B12AF4
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 16:12:58 -0800 (PST)
Received: from [192.168.1.208] ([93.35.145.222])
        by Aruba Outgoing Smtp  with ESMTPSA
        id wXw8oQopwS2o1wXw8o03xK; Sun, 20 Nov 2022 01:11:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668903114; bh=otd9mZwZ4kweJcJjySGw7vRIHFmgujQA44VMmM058s4=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=HSpSMr1FOrqhTolwWJtNFcj7OiG/2xLjPLJHjS0L59LqYvbA1UJLNE1DHk0q0xbC0
         q5hgXCxsYRkUaDRPB5xwruFrOM/CFar22UH7n0IA2nnNU3BbhjI5wkTeHcvHwmjhYG
         qQlmSBaD+wCS2fjtcsU68m1+vqx3hvOjhWug1uIJoey02cl77rULJNog0rVPc6j9cK
         SGLB+0e82sslw7TGs/NATxq1gXvtVF+ejCpjCp3M1PveNv5cjdQ86YsOfpHElyoxkv
         Sc2dskZgxRZLqM3Mo9DeXO1olLPDQ90BbT3wdW5XLBOQviq1iGX6Rn/26QdE3ajdjP
         NzPQ81IB4sKyw==
Message-ID: <6c13c3072ca4c8c3217f9449f56921a8496c32eb.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        kbuild test robot <lkp@intel.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date:   Sun, 20 Nov 2022 01:11:52 +0100
In-Reply-To: <20221119101211.GA7626@pengutronix.de>
References: <20220511162247.2cf3fb2e@erd992>
         <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
         <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
         <20221117162251.5e5933c1@erd992> <20221118060647.GE12278@pengutronix.de>
         <7b575cface09a2817ac53485507985a7fef7b835.camel@egluetechnologies.com>
         <20221118123013.GF12278@pengutronix.de>
         <1fd663d232c7fba5f956faf1ad45fb410a675086.camel@egluetechnologies.com>
         <20221118134447.GG12278@pengutronix.de>
         <a01fe547c052e861d47089d6767aba639250adda.camel@egluetechnologies.com>
         <20221119101211.GA7626@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-CMAE-Envelope: MS4xfA4ZEc99p2k5PoFYcqxhkzwVEtkKmIuQnMneS/ZSD1jwOZlC79ckXyOdJ1BpZio9yVDCBno6LKBLaK/e3D6zkTKY8hKkqVBBSOwq+CyPMJ83hkjY7X/w
 CFOi5ZVNSotFB5Quh9BhSH1bXtt+PUaM7y6pszI817PiAjygIFCfHpwFjd5rEsHOSPupYmcNVrf0/8kLcSwoYYU8CqKtawnIZm2xkCdfc1LC8i2Wl2Ndm9Uq
 Zn/ZhH7kLUnLzJzos8GXeJiKjSJG5DbDWlPD0Fg8lkASnEwkBAUlmPkglU0bEni8diodBUbkWAgyOglF3LWbTMOgPGUOgteCUZUzXz2XZzzU71yNrdMHNJOZ
 gvqciFgzFoEcJIEGscgtXGgBAXI+R2Hhf899Kege5k/LJuOiITTX+PP6cncWYxvg0A+mUT2OwHVnYr0Vpk/RDBGLubuPxtRRvLw5q0bveSSxzGi27KM0qgZ8
 e0XQ4uiyQ44EdQHPu939WgnI6SSW1thsXMHr77lnPxJX5JSyYm6N50VSa0kWI4OpEJwIh2Z6beM8j9C5B9i+GAmncknk/wAYf/N/4WSzI1Rc6Vsba+LKH2jm
 NDfGX9FZHssJtSiaaHTTfL+Ej/VSVg2yfhnfldA5cZBj/TISfFHnavPof0lB/b2G3cjy+ji9XuhB+3Ipnlbfyrtzojni9VpVwBrMbTv9Wdt1mWIXjQ40y33x
 mtZ7PT+BF80=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-11-19 at 11:12 +0100, Oleksij Rempel wrote:
> On Fri, Nov 18, 2022 at 04:12:40PM +0100, Devid Antonio Filoni wrote:
> > Hi Oleksij,
> >=20
> > honestly I would apply proposed patch because it is the easier solution
> > and makes the driver compliant with the standard for the following
> > reasons:
> > - on the first claim, the kernel will wait 250 ms as stated by the
> > standard
> > + on successive claims with the same name, the kernel will not wait
> > 250ms, this implies:
> >   - it will not wait after sending the address-claimed message when the
> > claimed address has been spoofed, but the standard does not explicitly
> > states what to do in this case (see previous emails in this thread), so
> > it would be up to the application developer to decide how to manage the
> > conflict
> >   - it will not wait after sending the address-claimed message when a
> > request for address-claimed message has been received as stated by the
> > standard
>=20
> Standard says:
> 1. No CF _shall_ begin, or resume, transmission on the network until 250 =
ms
>    after it has successfully claimed an address (Figure 4).
> 2. This does not apply when responding to a request for address claimed.
>=20
> With current patch state: 1. is implemented and working as expected, 2.
> is not implemented.
> With this patch: 1. is partially broken and 2. is partially faking
> needed behavior.
>=20
> It will not wait if remote ECU which rebooted for some reasons. With this=
 patch
> we are breaking one case of the standard in favor to fake compatibility t=
o the
> other case. We should avoid waiting only based on presence of RfAC not ba=
sed
> on the old_addr =3D=3D new_addr.

I'm sorry, I don't think I understood the point about reboot ("It will
not wait if remote ECU which rebooted for some reasons"). If another ECU
rebooted, then *it* will have to perform the claim procedure again
waiting 250 ms before beginning the transmission. Your ECU doesn't have
to check if the other ECUs respected the 250 ms wait.

Also, the ISO11783-5 standard, with "Figure 6 (Resolving address
contention between two self-configurable-address CF)" of=C2=A0"4.5.4.2 -
Address-claim prioritization", shows that:
- ECU1 claims the address (time: 0 ms)
- ECU2 claims the same address (time: 0+x ms)
- ECU1 NAME has the higher priority, so ECU1 sends again the address
claimed message as soon as it received the address-claim from ECU2
(time: 0+x+y ms)
- ECU1 starts normal transmission (time: 250 ms)
With current implementation, the ECU1 would start the transmission at
time 0+x+y+250 ms, with proposed patch it would not.
Same is showed in "Figure 7 (Resolving address contention between a non-
configurable address CF and a self-configurable address CF)", the ECU
waits again 250 ms only when claiming a different address.

Also, as previously discussed in this thread, the standard states in
4.4.4.3 - Address violation:
If a CF receives a message, other than the address-claimed message,
which uses the CF's own SA,
then the CF:
- shall send the address-claim message to the Global address;
- shall activate a diagnostic trouble code with SPN =3D 2000+SA and FMI =3D
31
It is not *explicitly* stated that you have to wait 250 ms after the
address-claim message has been sent. Please note that the 250 ms wait is
mentioned only in "4.5 - Network initialization" while above statements
come from "4.4 - Network-management procedures". Also in this case, the
proposed patch is still standard compliant.

So I'm sorry but I have to disagree with you, there are many things
broken in the current implementation because it is forcing the 250 wait
to all cases but it should not.

>=20
> Without words 2. part should be implemented without breaking 1.
>=20
> > Otherwise you will have to keep track of above cases and decide if the
> > wait is needed or not, but this is hard do accomplish because is the
> > application in charge of sending the address-claimed message, so you
> > would have to decide how much to keep track of the request for address-
> > claimed message thus adding more complexity to the code of the driver.
>=20
> Current kernel already tracks all claims on the bus and knows all registe=
red
> NAMEs. I do not see increased complicity in this case.

The kernel tracks the claims but it does *not track* incoming requests
for address-claimed message, it would have to and it would have to allow
the application to answer to it *within a defined time window*. But keep
in mind that there are other cases when the 250 ms wait is wrong or it
is not explicitly stated by the standard.

>=20
> IMHO, only missing part i a user space interface. Some thing like "ip n"
> will do.
>=20
> > Another solution is to let the driver send the address-claimed message
> > waiting or without waiting 250 ms for successive messages depending on
> > the case.
>=20
> You can send "address-claimed message" in any time you wont. Kernel will
> just not resolve the NAME to address until 1. part of the spec will
> apply. Do not forget, the NAME cache is used for local _and_ remote
> names. You can trick out local system, not remote.
>=20
> Even if you implement "smart" logic in user space and will know better
> then kernel, that this application is responding to RfAC. You will newer
> know if address-claimed message of remote system is a response to RfAC.
>=20
> From this perspective, I do not know, how allowing the user space break
> the rules will help to solve the problem?

I think you did not understand this last proposal: since the driver is
already implementing part of the standard, then it might as well send
the address-claimed message when needed and wait 250 ms or not depending
on the case.
In this way, for example, you won't have to keep track of a request for
address-claimed, you just would have to answer to it directly.

Feel free to implement what you think is more appropriate but please
read the ISO11783-5 standard carefully too before changing the code,
there are many cases and it is not possible to simplify everything into
one rule.

Meanwhile I'm going to apply the patch to my own kernel, I've tried to
workaround the limitation using a CAN_RAW socket to send the address-
claimed message but the J1939 driver refuses to send other messages in
the 250 ms time window because it has detected the address-claimed
message sent from the other socket, so I can only apply the patch to
make it compliant with the standard.

>=20
> Regards,
> Oleksij

Best Regards,
Devid

