Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A718A1BA0
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfH2Njd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbfH2Njc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:39:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9FC9E8980E7;
        Thu, 29 Aug 2019 13:39:32 +0000 (UTC)
Received: from ceranb (ovpn-204-112.brq.redhat.com [10.40.204.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F8415C258;
        Thu, 29 Aug 2019 13:39:30 +0000 (UTC)
Date:   Thu, 29 Aug 2019 15:39:29 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        allan.nielsen@microchip.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
Message-ID: <20190829153929.357e7391@ceranb>
In-Reply-To: <20190829131543.GB6998@lunn.ch>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
        <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
        <20190829095100.GH2312@nanopsycho>
        <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
        <20190829121811.GI2312@nanopsycho>
        <20190829124412.nrlpz5tzx3fkdoiw@soft-dev3.microsemi.net>
        <20190829145518.393fb99d@ceranb>
        <20190829131543.GB6998@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 29 Aug 2019 13:39:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 15:15:43 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> The problem with this is, the driver only gets called when promisc
> goes from 0 to !0. So, the port is added to the bridge. Promisc goes
> 0->1, and the driver gets called. We can evaluate as you said above,
> and leave the port filtering frames, not forwarding everything. When
> tcpdump is started, the core does promisc 1->2, but does not call into
> the driver. Also, currently sending a notification is not
> unconditional.

Hi Andrew,

got it. What about to change the existing notify call so NETDEV_CHANGE
notification will be also sent when (old_promiscuity !=
new_promiscuity)?

Ivan
