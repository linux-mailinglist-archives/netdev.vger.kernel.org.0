Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA635223A0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348596AbiEJSRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349428AbiEJSQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:16:44 -0400
Received: from smtpcmd13146.aruba.it (smtpcmd13146.aruba.it [62.149.156.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ECC27A821
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:12:36 -0700 (PDT)
Received: from dfiloni-82ds ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id oULYnuZc1TRWPoULZnceAZ; Tue, 10 May 2022 20:12:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652206354; bh=tXg3JwEAq3x7kb47JWPESvZY0ObIuCiw9hWWWEOrXEA=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=KsGr0LnAvr/Q7ZDjCUlzh4u1DKoPxDYKniZ5LwAuAhSpa950lhvOIc6f0RBqNed73
         JQp6KQrEVUh6ngO/JHjfHDgWodIqdACj3bivaUXcwBSuh6Ll9iT7pCwPDNzTciqX+E
         Y65gmQEZj6hOfk0PzFmf6d2Ffwdslfy6OxUI/M8jyFQteSRL7IQIHxYZ+OOgZv41kL
         MKx1268R4TZyhgFe03cF/EvtrNIfa3g/CcIMseMSPxjZg1jW+1Htf1UWU3gPIlkl5i
         CZonL3/Pm/TNfgA9YFmhBXtEOdrp4AZz6fmw15PSEbSWk4juquUbovXWm/rHdQXaxT
         29PalAnv/+uoQ==
Message-ID: <a8ea7199230682f3fd53e0b5975afa7287bd5ac0.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND 0/2] j1939: make sure that sent DAT/CTL frames
 are marked as TX
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
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
Date:   Tue, 10 May 2022 20:12:32 +0200
In-Reply-To: <20220510043406.GB10669@pengutronix.de>
References: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
         <20220510043406.GB10669@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfFs8gjkPKwq+M5nU/1hYGsZB+Fu5X7eaNMR/Ks5Nn6GXz/kXgxKa9okTnw2l0zl5XYXkNqHN4idPrlLjVKQO9FjAIresmAASSX6lezZRvO/h3OrKaDse
 Oy9Gu+yhVsRBPsfPr+CUJHioU204vHd79A79Lwx6HwuKPIgkb7z51okeI58PbOlMITkXKohcoww/i6a4l3Z64cFGnFZ9wprUhyu+S2IBR6jczx2dwQ+Q9sKv
 UTu46SJqNrzD6hamhkXpT6E0EB9d4JLHWx22mefp3A0Dxcl+Yo7CBee/SlYJh/dcC/O54OqR8n92kdrNOEVZvx2oTj1ceC95u/wTcjMgHe+EzsyqCkyt1379
 o/PfZBuGtErHGN1aATy9bLtA7/CBUigebEcUTKxeiGiif9DfaHmxCW89gPWCu5TldHvZBL9mzQohUhU957QqUuL68mVnse620qkaOQMeSfubH2+JFqv92agZ
 G2A3HnqRoYHvXgCF+/XPewHuDInRiw8xHFVlhRRF1ZwqYFTe9MCDmy84xiUteOwFLMaoB5aKCLV339ET6CDY/aOmHA4klpE0LApQFfHNUxVao7N3TNd+4j56
 2FaGNnIjpx++ARNrL60byTSr+7dlzdpEnTXFjiZg1JmdzyWF4/IqRFXiA3OzVj0+AmQ=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Tue, 2022-05-10 at 06:34 +0200, Oleksij Rempel wrote:
> Hi Devid,
> 
> On Mon, May 09, 2022 at 07:07:44PM +0200, Devid Antonio Filoni wrote:
> > Hello,
> > 
> > If candump -x is used to dump CAN bus traffic on an interface while a J1939
> > socket is sending multi-packet messages, then the DAT and CTL frames
> > show up as RX instead of TX.
> > 
> > This patch series sets to generated struct sk_buff the owning struct sock
> > pointer so that the MSG_DONTROUTE flag can be set by recv functions.
> > 
> > I'm not sure that j1939_session_skb_get is needed, I think that session->sk
> > could be directly passed as can_skb_set_owner parameter. This patch
> > is based on j1939_simple_txnext function which uses j1939_session_skb_get.
> > I can provide an additional patch to remove the calls to
> > j1939_session_skb_get function if you think they are not needed.
> 
> Thank you for your patches. By testing it I noticed that there is a memory
> leak in current kernel and it seems to be even worse after this patches.
> Found by this test:
> https://github.com/linux-can/can-tests/blob/master/j1939/run_all.sh#L13
> 
> 
> Can you please investigate it (or wait until I get time to do it).
> 
> Regards,
> Oleksij
> 

I checked the test you linked and I can see that the number of the
instances of the can_j1939 module increases on each
j1939_ac_100k_dual_can.sh test execution (then the script exits),
however this doesn't seem to be worse with my patches, I have the same
results with the original kernel. Did you execute a particular test to
verify that the memory leak is worse with my patches?
I tried to take a look at all code that I changed in my patches but the
used ref counters seem to be handled correctly in called functions. I
suspected that the issue may be caused by the ref counter increased
in can_skb_set_owner() function but, even if I remove that call from the
j1939_simple_txnext() function in original kernel, I can still reproduce
the memory leak.
I think the issue is somewhere else, I'll try to give another look but I
can't assure nothing.

Best Regards,
Devid

