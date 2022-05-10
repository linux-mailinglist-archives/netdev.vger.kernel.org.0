Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F89052130A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbiEJLFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 07:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiEJLFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 07:05:46 -0400
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 May 2022 04:01:49 PDT
Received: from smtpweb147.aruba.it (smtpweb147.aruba.it [62.149.158.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27020260877
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 04:01:48 -0700 (PDT)
Received: from dfiloni-82ds ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id oNbenE7sabMeioNbenQdt9; Tue, 10 May 2022 13:00:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652180446; bh=HOtQ3KnLO5XsUQz6lMBn4fhMi4iEVOtrqetfJutDP5Y=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=HyDu/PV5lSUJ8R6AGvr8HjrRlC6CmeykcBvhd3Aj3hsBF04c9ST64I1+1A1YryeRb
         H6AmtFbZDuR856TjExsDpUDr6cwhLc20ckhCk5JxFu0Ka+uD1YcXhbjASxSeUjCygo
         /j5bRXuKuhp2ygj5eZkQQ1+jHdC0Cy2+OlpgW/qElTQwTUbapHeugOtZC/3hFD0mWF
         tdYzQAGMgWvg6OA0LfwSrgxQQtxx49hSqoHvF4Bz1ysH5bgFn/RQe2l/3wId62qjUs
         AbtmrIOTORfS0gCkgniiCUhnZoC+PSdEn+D1WN42r8odkOK6RzIsNyeYdNf0SQ8Iad
         otB0GueCZie8g==
Message-ID: <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Cc:     Robin van der Gracht <robin@protonic.nl>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 May 2022 13:00:41 +0200
In-Reply-To: <20220510042609.GA10669@pengutronix.de>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
         <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
         <20220510042609.GA10669@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKCKKM6c2Ra6nGX+5TZvp2Fc+vvphWm25IW1ZBxuYQgtGpuiJk2Ba4516wIVBoSxdXkm2ndX4inrwlzXNn7Gul6X3feF89NXOqoGpR5xH6gz4FJkirKZ
 A2u0aDp1VaLBdPUzH9Oh4rEe+SOPYYfFd6v8ekY/Crl6okpKtylPCSpNocyh0YnxKKBNc1YuFzbyAWIEdtzR80f+ZP4A5IAvQlctNQDw0vHJC3HgvJBH1ijZ
 UBNNGdjNAMF9nu2xnb9dB3yCsZlqY/OpzbZYcUO0SYskhXLQ/N2OHPVC3OOFaLEF+q8g5wwBb1qvuQvDcvtfPhoC2RQQwrzWE06uvdccNPD9WINNDape4px1
 XGlzMz5RPK3AAvxeLeRlG+XfZXgRjptsNdl9daM98f/yqpnDOkB/tyBrckU2lz6QojAdItb2elXxaCSQ762Ib+nE9EcGCvERs/6Jmx2PtSL+CjatYC+m0AKz
 l/4E4H1FzoB/tNXXAtpGRVHjgeAgo+Qd6H5HuxrW/IwpKXY+5DtAnn8q7UynK4VIMNYhcKuZ3z/ujbIubSHDX23Zi4oMk+G9cbiR6HrvFNDm8QSnGgBs4B9o
 1m7nQmqQVplyxKixgSSnk//GPR7EmUQ/V4oX2jVbCUawLVRWrJJhED/BmYXjnoUtReaPOXm1dOzwO9JOSYAVKy8B6COk3rNYd1Pjmu65r2VxrA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote:
> Hi,
> 
> On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote:
> > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote:
> > > This is not explicitly stated in SAE J1939-21 and some tools used for
> > > ISO-11783 certification do not expect this wait.
> 
> It will be interesting to know which certification tool do not expect it and
> what explanation is used if it fails?
> 
> > IMHO, the current behaviour is not explicitely stated, but nor is the opposite.
> > And if I'm not mistaken, this introduces a 250msec delay.
> > 
> > 1. If you want to avoid the 250msec gap, you should avoid to contest the same address.
> > 
> > 2. It's a balance between predictability and flexibility, but if you try to accomplish both,
> > as your patch suggests, there is slight time-window until the current owner responds,
> > in which it may be confusing which node has the address. It depends on how much history
> > you have collected on the bus.
> > 
> > I'm sure that this problem decreases with increasing processing power on the nodes,
> > but bigger internal queues also increase this window.
> > 
> > It would certainly help if you describe how the current implementation fails.
> > 
> > Would decreasing the dead time to 50msec help in such case.
> > 
> > Kind regards,
> > Kurt
> > 
> 

The test that is being executed during the ISOBUS compliance is the
following: after an address has been claimed by a CF (#1), another CF
(#2) sends a  message (other than address-claim) using the same address
claimed by CF #1.

As per ISO11783-5 standard, if a CF receives a message, other than the
address-claimed message, which uses the CF's own SA, then the CF (#1):
- shall send the address-claim message to the Global address;
- shall activate a diagnostic trouble code with SPN = 2000+SA and FMI =
31

After the address-claim message is sent by CF #1, as per ISO11783-5
standard:
- If the name of the CF #1 has a lower priority then the one of the CF
#2, the the CF #2 shall send its address-claim message and thus the CF
#1 shall send the cannot-claim-address message or shall execute again
the claim procedure with a new address
- If the name of the CF #1 has higher priority then the of the CF #2,
then the CF #2 shall send the cannot-claim-address message or shall
execute the claim procedure with a new address

Above conflict management is OK with current J1939 driver
implementation, however, since the driver always waits 250ms after
sending an address-claim message, the CF #1 cannot set the DTC. The DM1
message which is expected to be sent each second (as per J1939-73
standard) may not be sent.

Honestly, I don't know which company is doing the ISOBUS compliance
tests on our products and which tool they use as it was choosen by our
customer, however they did send us some CAN traces of previously
performed tests and we noticed that the DM1 message is sent 160ms after
the address-claim message (but it may also be lower then that), and this
is something that we cannot do because the driver blocks the application
from sending it.

28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
with other CF's address
28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
Claim - SA = F0
28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF  //DM1
28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
with other CF's address
28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
Claim - SA = F0
28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF  //DM1
28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
with other CF's address
28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
Claim - SA = F0
28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1

Since the 250ms wait is not explicitly stated, IMHO it should be up to
the user-space implementation to decide how to manage it.

Thank you,
Devid

