Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0A71EED
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733073AbfGWSSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:18:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60744 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfGWSSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:18:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hpzMD-0003HF-HK; Tue, 23 Jul 2019 20:17:49 +0200
Message-ID: <5f6c264c75f3ffe6c2cbcab2d174ad2c4c4c0bd6.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Date:   Tue, 23 Jul 2019 20:17:47 +0200
In-Reply-To: <20190723110206.4cb1f6b1@hermes.lan> (sfid-20190723_200215_305541_DF26DFA5)
References: <cover.1556806084.git.mkubecek@suse.cz>
         <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
         <20190723110206.4cb1f6b1@hermes.lan> (sfid-20190723_200215_305541_DF26DFA5)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-23 at 11:02 -0700, Stephen Hemminger wrote:
> 
> There are some cases where netlink related to IPv4 does not send nested
> flag. You risk breaking older iproute2 and other tools being used on newer
> kernel. I.e this patch may break binary compatibility. Have you tried running
> with this on a very old distro (like Redhat Linux 9)?


There are *tons* of places where this (and other things) wasn't done
right, but the validation is only added for

 * all attributes on _new operations_ (that old userspace couldn't have
   been using since they're introduced after this patch)
 * _new attributes_ (dito, if the policy 'strict start' is filled)

johannes

