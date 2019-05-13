Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9235C1B73A
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfEMNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:42:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfEMNmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 09:42:14 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9F2D43082E6A;
        Mon, 13 May 2019 13:42:14 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.40.205.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E32845D9C9;
        Mon, 13 May 2019 13:42:08 +0000 (UTC)
Date:   Mon, 13 May 2019 15:42:06 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, Dan Winship <danw@redhat.com>
Subject: Re: [PATCH net] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
Message-ID: <20190513134206.GA13340@bistromath.localdomain>
References: <8b128a64bba02b9d3b703e22f9ec4e7f3803255f.1557751584.git.sd@queasysnail.net>
 <a9ba6631-4403-67e0-152a-b2d85aa70d72@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9ba6631-4403-67e0-152a-b2d85aa70d72@6wind.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 13 May 2019 13:42:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-13, 15:17:33 +0200, Nicolas Dichtel wrote:
> Le 13/05/2019 à 15:01, Sabrina Dubroca a écrit :
> > Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> > iflink == ifindex.
> > 
> > In some cases, a device can be created in a different netns with the
> > same ifindex as its parent. That device will not dump its IFLA_LINK
> > attribute, which can confuse some userspace software that expects it.
> > For example, if the last ifindex created in init_net and foo are both
> > 8, these commands will trigger the issue:
> > 
> >     ip link add parent type dummy                   # ifindex 9
> >     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
> > 
> > So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> > always put the IFLA_LINK attribute as well.
> > 
> > Thanks to Dan Winship for analyzing the original OpenShift bug down to
> > the missing netlink attribute.
> Good catch.
> 
> > 
> > Analyzed-by: Dan Winship <danw@redhat.com>
> > Fixes: a54acb3a6f85 ("dev: introduce dev_get_iflink()")
> I don't agree with the Fixes tag. The test 'iflink != ifindex' is here at least
> since the beginning of the git history.

Hmpf, right, now that I re-blamed, I see. I don't know why I stopped
on your patch, sorry.

> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Thanks!

I'll repost with a correct Fixes tag and your Ack.

-- 
Sabrina
