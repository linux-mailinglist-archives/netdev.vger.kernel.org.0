Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE284D4299
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbiCJIe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiCJIeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:34:24 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C448B6007C;
        Thu, 10 Mar 2022 00:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646901164;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=FiKLOzBJqZeT14/Dwh8Jsps9hv2dGAai/3016irFtbc=;
    b=su15oql55v8tofUD893dgSsq0fPpXxNCJJHApdT7szUBcYJHUWxczku93lIPDoMdA1
    lk3QftHF7RhSIY0NnIXX53XoRqfeOfVFbcrM9YXZSwRPCCfQMSsY5Pggkbu5PSlsFRJD
    yAq//o4nTdA8TBUKD5bppT3DTSQvC7BAZXNyjOzDESGGZX4InBvAe7jd+VC8WqK2mPT/
    GVKa7wN3tcgmhh+A8GevFdH5GA7+RvDXV7tXuMcIFOyB4sh5KUhjpXMtT6qNkvHo136k
    yQ1eqWB5v7eTnLKWl/+lnoyS3kcrE8UApWSRKYyuAmNjyoSP3b8+vXNZU/NL8k0voO7K
    ny0A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCs/87J3I0="
X-RZG-CLASS-ID: mo00
Received: from oxapp05-03.back.ox.d0m.de
    by smtp-ox.front (RZmta 47.40.1 AUTH)
    with ESMTPSA id 646b0ey2A8WiKzS
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 10 Mar 2022 09:32:44 +0100 (CET)
Date:   Thu, 10 Mar 2022 09:32:44 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com, horms@verge.net.au
Message-ID: <697549723.108632.1646901164630@webmail.strato.com>
In-Reply-To: <20220310082545.rt6yp3wqsig52qoi@pengutronix.de>
References: <20220309162609.3726306-1-uli+renesas@fpond.eu>
 <20220310082545.rt6yp3wqsig52qoi@pengutronix.de>
Subject: Re: [PATCH v4 0/4] can: rcar_canfd: Add support for V3U flavor
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev39
X-Originating-Client: open-xchange-appsuite
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 03/10/2022 9:25 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> 
>  
> On 09.03.2022 17:26:05, Ulrich Hecht wrote:
> > This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP supports up
> > to eight channels and has some other minor differences to the Gen3 variety:
> 
> Should I take the whole series via linux-can/next?

That would be great, thanks.

CU
Uli
