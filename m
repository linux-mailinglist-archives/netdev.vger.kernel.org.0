Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF08F6DF4E0
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjDLMTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjDLMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:19:16 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3238746A9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:19:14 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B241FC0009;
        Wed, 12 Apr 2023 12:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681301953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LfuvFFV2KXn6eGBArel/84lm38GeWqGtwNLUUb74zJc=;
        b=pLmyAI56xBAjTlJ4ivEjBAolUi+S+pvhzfPejis4zvXGJtxknJABpwj5pU3wUjmFfTIprM
        MJD4QvbUTpkyeigPuhHficVanKjxOHsbpJ48eqboEGEPBTE6KB2kTmprtOKXNrnf7O8P6w
        2Dq4L2Z9n/QGfjWhqdq25ghhcw/aaRglPJkvWc664royCL+stzVMNcHuPZM8kKo1qE6mXj
        HL2/2+mwfDVwz63IvZZ5ofDnOMsu7kzUUpUsz/xhU6xJm9SA+ixT0uEIgkCm2NGXPybbU6
        pgli7LSrxdMpykCvHvHsnUT9HqozoN3bXmcrTTuk3RSPuar1bJx17l1CtOaSYA==
Date:   Wed, 12 Apr 2023 14:19:10 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Michael Walle <michael@walle.cc>, kuba@kernel.org,
        gerhard@engleder-embedded.com, glipus@gmail.com,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com, vadim.fedorenko@linux.dev
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230412141910.23d11026@kmaincent-XPS-13-7390>
In-Reply-To: <20230412110840.vmuudkuh5zb3u426@skbuf>
References: <20230406184646.0c7c2ab1@kernel.org>
        <20230412105034.178936-1-michael@walle.cc>
        <20230412110840.vmuudkuh5zb3u426@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 14:08:40 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, Apr 12, 2023 at 12:50:34PM +0200, Michael Walle wrote:
> > >> +/* Hardware layer of the SO_TIMESTAMPING provider */
> > >> +enum timestamping_layer {
> > >> +	SOF_MAC_TIMESTAMPING =3D (1<<0),
> > >> +	SOF_PHY_TIMESTAMPING =3D (1<<1),  
> > >
> > > What does SOF_ stand for?  
> > 
> > I'd guess start of frame. The timestamp will be taken at the
> > beginning of the frame.  
> 
> I would suggest (with all due respect) that it was an inapt adaptation
> of the Socket Option Flags that can be seen in
> Documentation/networking/timestamping.rst.
> 
> These are not socket option flags (because these settings are not per
> socket), so the namespace/prefix is not really correctly used here.

As Jakub said, who knows maybe one day it will be per socket information,
but indeed for now it is not the case.
I will stick to whatever name the community prefer.
