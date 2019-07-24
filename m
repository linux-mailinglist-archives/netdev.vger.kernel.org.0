Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D473485
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfGXRCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:02:44 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:38673 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbfGXRCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:02:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 764242399;
        Wed, 24 Jul 2019 13:02:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 13:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+fXNsL
        LPuU+CsO2vmRn5FiVuirmwjgG0SED2xeEvO5U=; b=MYujN5khkczTBOydmSios8
        nVkqZuVO8qiWb7SSzXuDWJhehB217S6b5EecvD32zPKUETMgBb9nxGpicGg45E6n
        fjd9H8GqXp++PLeo8FVhSl+JF/CGoVq5aKY6Sdog4YWMMySc99UOLFlhK8fDahQL
        96JFb+98XAKCF5CRNdrspw3N4oZHA6WxLPE15CvSKNCELUlZASNEdKX+WIUknMhb
        ySKyuK+af6urZnkTNwJHoOmQlq9ucJKi5VMUyYkeafyGYPsB193/u8FFK7Gx5oRN
        XC5C/cE50QkDKGIhNTMf1ljX5gZ+G3OTpORWGeFzkbQ5aKUzA16VcQnyUXy66SlA
        ==
X-ME-Sender: <xms:L484XQQrkhLedqsSA4B_DZfcxXZjdwtL1YebTJfqdCFIAA2_GHUg6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:L484XcovBSrQeUnGruvWWLP9Po9aigzKNr3KdSjLQ5FKo7dVb8ySQQ>
    <xmx:L484XYEaCJvkdCNPAJa5xLoIvdh2nlP6vI_6JHU_-GeYuJyI_NXgKw>
    <xmx:L484XaXIPwRHlaYMo0W_U-ZY25FjYa5EhnmsjVqTadvVTInvgz27Jg>
    <xmx:M484XVwzoBBMfitT2iRV16r93YzoSuXh6RsJIvzKn1wMBBY3RHzQcg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD67738008A;
        Wed, 24 Jul 2019 13:02:38 -0400 (EDT)
Date:   Wed, 24 Jul 2019 20:02:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 08/12] drop_monitor: Initialize timer and
 work item upon tracing enable
Message-ID: <20190724170237.GD20252@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-9-idosch@idosch.org>
 <20190724090120.GA2225@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724090120.GA2225@nanopsycho>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:01:20AM +0200, Jiri Pirko wrote:
> Mon, Jul 22, 2019 at 08:31:30PM CEST, idosch@idosch.org wrote:
> > static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
> > {
> >-	int rc;
> >+	int cpu, rc;
> > 
> > 	if (!try_module_get(THIS_MODULE)) {
> > 		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
> > 		return -ENODEV;
> > 	}
> > 
> >+	for_each_possible_cpu(cpu) {
> >+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
> >+
> >+		INIT_WORK(&data->dm_alert_work, send_dm_alert);
> >+		timer_setup(&data->send_timer, sched_send_work, 0);
> 
> So don't you want to remove this initialization from
> init_net_drop_monitor?

It's actually needed because it calls reset_per_cpu_data(), which might
trigger the timer on memory allocation error. I'll try to see if I can
get rid of it. If not, I'll add a comment so that people won't be
tempted to remove it.
