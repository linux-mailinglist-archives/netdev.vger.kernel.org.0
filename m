Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E9E523374
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbiEKMzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242826AbiEKMzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:55:15 -0400
Received: from smtpcmd14161.aruba.it (smtpcmd14161.aruba.it [62.149.156.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EC146B7E2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:55:11 -0700 (PDT)
Received: from dfiloni-82ds ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id olrtnPwzQJtD2olrtnwG5g; Wed, 11 May 2022 14:55:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652273708; bh=BXC7lJze1QSVSShN2eHB9LPUHjnehZrtUc0+mvuHeqE=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=BH574N/G/mQXbVXsD29IQe1qQ9cqakW76Id9piIdGlYSILadeoVT0gPya6ckdl8NU
         NQy2F2soAJWRmnyS5NdsyWoH+WApbx0oixhMpzd3Yu8/WNYIIzFD3HjOzP9p50DBuv
         5xcd9ldqJfWWGETgFW/u33msnEy4GqyqeEYTdf1Rco6oCxBWipaHssO1isvwWBRZq4
         0TRmLQ0M2yfqVBfTxbQ6j9C1hnbT0Uieab+GzSNWYSzVUvQJhRyg29Re4ubVDewHL/
         zVZxz1UyoDGKPkf7MlIOdXrERt7Da9Po6D5ONGjwD4XgSyglqinQfUASj+xxO0sttM
         xAkQh1wdUJ0EA==
Message-ID: <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     David Jander <david@protonic.nl>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:55:04 +0200
In-Reply-To: <20220511110649.21cc1f65@erd992>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
         <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
         <20220510042609.GA10669@pengutronix.de>
         <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
         <20220511084728.GD10669@pengutronix.de> <20220511110649.21cc1f65@erd992>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfC8Ryy1issIuBiRxd66ZxvfTBUsOibYGe/cRlvWMIpPEqb9GcLSEebdGNqHWj2czV7eJL5NgRKWVu+wGABepScEQgsVbMlhVxCSgQ1HGnD+AWsXkCjnZ
 o2xW75pWySSD4iqYhziN7jyW4d4RSd51lYN88bOkevqUgDcld4HbJ90/HPB2kYCP7wQs+bdydEUCLBEZi/deK+Deq9hQ44E4ViD+yo6XsWe3WZPQT7p1zIqD
 pQddQ6rjcsbrO9fPsH8nTN+hJ0h5+1nov+zR+8sIYHzpUMgGwBr/UiTt2woKKo8WGyfYflLT7TpN0VOqQar/4JyAekOKejF+UbJKvrpqEfbImyiObJf9xFY/
 E9zkQh72SDeihJsxUzEhNQRgBX5RtIBhx9BTmK5DtEqkT0vWB0QeyBvZjILzKCG+DuiDu6Lse7N5NR7OWoepz3dlnGO1wu5J6ASAtgWEJkTWQLe0d2NXMMDO
 cyDuXdT3HCcwdV/WS4Z89TWY4vOBLoOY4GVVOWA2M5l+EkTXia9iYuCqTZFo0nBVKrGmjUHnSCpD8cV3o1IL/Oxaqg//wW8TrkIBqk/WAiNSQzNNWy7tNqPx
 uWYC9jQYpJumYRBMp83H2nAnEXk39ZGx9UDuh/YAgX0MVJLXdXRlWpWGmzr90sgsVpKlfO2RUWwHyAjH7BQ3KvkhrWEmdvtH96hEo/6vpy2nh8cC5O9yctbF
 5Bo60Nqoruw=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote:
> Hi,
> 
> On Wed, 11 May 2022 10:47:28 +0200
> Oleksij Rempel <
> o.rempel@pengutronix.de
> > wrote:
> 
> > Hi,
> > 
> > i'll CC more J1939 users to the discussion.
> 
> Thanks for the CC.
> 
> > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Filoni wrote:
> > > Hi,
> > > 
> > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote:  
> > > > Hi,
> > > > 
> > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote:  
> > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote:  
> > > > > > This is not explicitly stated in SAE J1939-21 and some tools used for
> > > > > > ISO-11783 certification do not expect this wait.  
> > > > 
> > > > It will be interesting to know which certification tool do not expect it and
> > > > what explanation is used if it fails?
> > > >   
> > > > > IMHO, the current behaviour is not explicitely stated, but nor is the opposite.
> > > > > And if I'm not mistaken, this introduces a 250msec delay.
> > > > > 
> > > > > 1. If you want to avoid the 250msec gap, you should avoid to contest the same address.
> > > > > 
> > > > > 2. It's a balance between predictability and flexibility, but if you try to accomplish both,
> > > > > as your patch suggests, there is slight time-window until the current owner responds,
> > > > > in which it may be confusing which node has the address. It depends on how much history
> > > > > you have collected on the bus.
> > > > > 
> > > > > I'm sure that this problem decreases with increasing processing power on the nodes,
> > > > > but bigger internal queues also increase this window.
> > > > > 
> > > > > It would certainly help if you describe how the current implementation fails.
> > > > > 
> > > > > Would decreasing the dead time to 50msec help in such case.
> > > > > 
> > > > > Kind regards,
> > > > > Kurt
> > > > >   
> > > > 
> > > >   
> > > 
> > > The test that is being executed during the ISOBUS compliance is the
> > > following: after an address has been claimed by a CF (#1), another CF
> > > (#2) sends a  message (other than address-claim) using the same address
> > > claimed by CF #1.
> > > 
> > > As per ISO11783-5 standard, if a CF receives a message, other than the
> > > address-claimed message, which uses the CF's own SA, then the CF (#1):
> > > - shall send the address-claim message to the Global address;
> > > - shall activate a diagnostic trouble code with SPN = 2000+SA and FMI =
> > > 31
> > > 
> > > After the address-claim message is sent by CF #1, as per ISO11783-5
> > > standard:
> > > - If the name of the CF #1 has a lower priority then the one of the CF
> > > #2, the the CF #2 shall send its address-claim message and thus the CF
> > > #1 shall send the cannot-claim-address message or shall execute again
> > > the claim procedure with a new address
> > > - If the name of the CF #1 has higher priority then the of the CF #2,
> > > then the CF #2 shall send the cannot-claim-address message or shall
> > > execute the claim procedure with a new address
> > > 
> > > Above conflict management is OK with current J1939 driver
> > > implementation, however, since the driver always waits 250ms after
> > > sending an address-claim message, the CF #1 cannot set the DTC. The DM1
> > > message which is expected to be sent each second (as per J1939-73
> > > standard) may not be sent.
> > > 
> > > Honestly, I don't know which company is doing the ISOBUS compliance
> > > tests on our products and which tool they use as it was choosen by our
> > > customer, however they did send us some CAN traces of previously
> > > performed tests and we noticed that the DM1 message is sent 160ms after
> > > the address-claim message (but it may also be lower then that), and this
> > > is something that we cannot do because the driver blocks the application
> > > from sending it.
> > > 
> > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > > with other CF's address
> > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > > Claim - SA = F0
> > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF  //DM1
> > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > > with other CF's address
> > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > > Claim - SA = F0
> > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF  //DM1
> > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > > with other CF's address
> > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > > Claim - SA = F0
> > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > 
> > > Since the 250ms wait is not explicitly stated, IMHO it should be up to
> > > the user-space implementation to decide how to manage it.
> 
> I think this is not entirely correct. AFAICS the 250ms wait is indeed
> explicitly stated.
> The following is taken from ISO 11783-5:
> 
> In "4.4.4.3 Address violation" it states that "If a CF receives a message,
> other than the address-claimed message, which uses the CF’s own SA, then the
> CF [...] shall send the address-claim message to the Global address."
> 
> So the CF shall claim its address again. But further down, in "4.5.2 Address
> claim requirements" it is stated that "...No CF shall begin, or resume,
> transmission on the network until 250 ms after it has successfully claimed an
> address".
> 
> At this moment, the address is in dispute. The affected CFs are not allowed to
> send any other messages until this dispute is resolved, and the standard
> requires a waiting time of 250ms which is minimally deemed necessary to give
> all participants time to respond and eventually dispute the address claim.
> 
> If the offending CF ignores this dispute and keeps sending incorrect messages
> faster than every 250ms, then effectively the other CF has no chance to ever
> resume normal operation because its address is still disputed.
> 
> According to 4.4.4.3 it is also required to set a DTC, but it will not be
> allowed to send the DM1 message unless the address dispute is resolved.
> 
> This effectively leads to the offending CF to DoS the affected CF if it keeps
> sending offending messages. Unfortunately neither J1939 nor ISObus takes into
> account adversarial behavior on the CAN network, so we cannot do anything
> about this.
> 
> As for the ISObus compliance tool that is mentioned by Devid, IMHO this
> compliance tool should be challenged and fixed, since it is broken.
> 
> The networking layer is prohibiting the DM1 message to be sent, and the
> networking layer has precedence above all superior protocol layers, so the
> diagnostics layer is not able to operate at this moment.
> 
> Best regards,
> 
> 

Hi David,

I get your point but I'm not sure that it is the correct interpretation
that should be applied in this particular case for the following
reasons:

- In "4.5.2 Address claim requirements" it is explicitly stated that
"The CF shall claim its own address when initializing and when
responding to a command to change its NAME or address" and this seems to
completely ignore the "4.4.4.3 Address violation" that states that the
address-claimed message shall be sent also when "the CF receives a
message, other than the address-claimed message, which uses the CF's own
SA".
Please note that the address was already claimed by the CF, so I think
that the initialization requirements should not apply in this case since
all disputes were already resolved.

- If the offending CF ignores the dispute, as you said, then the other
CF has no chance to ever resume normal operation and so the network
cannot be aware that the other CF is not working correctly because the
offending CF is spoofing its own address. This seems to make useless the
requirement that states to activate the DTC in "4.4.4.3 Address
violation".

Regards,
Devid

