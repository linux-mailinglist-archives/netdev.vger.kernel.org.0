Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA02BC839
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 19:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgKVSZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 13:25:58 -0500
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:42010 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727956AbgKVSZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 13:25:54 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 883C21800AEAD;
        Sun, 22 Nov 2020 18:25:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:4321:5007:6742:6743:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13019:13069:13161:13229:13311:13357:13439:14659:21080:21450:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: stamp54_4305a342735e
X-Filterd-Recvd-Size: 3841
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Sun, 22 Nov 2020 18:25:38 +0000 (UTC)
Message-ID: <ca071decb87cc7e905411423c05a48f9fd2f58d7.camel@perches.com>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
From:   Joe Perches <joe@perches.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, bridge@lists.linux-foundation.org,
        ceph-devel@vger.kernel.org, cluster-devel@redhat.com,
        coreteam@netfilter.org, devel@driverdev.osuosl.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        dri-devel@lists.freedesktop.org, GR-everest-linux-l2@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-can@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-geode@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i3c@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
        op-tee@lists.trustedfirmware.org, oss-drivers@netronome.com,
        patches@opensource.cirrus.com, rds-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, samba-technical@lists.samba.org,
        selinux@vger.kernel.org, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        usb-storage@lists.one-eyed-alien.net,
        virtualization@lists.linux-foundation.org,
        wcn36xx@lists.infradead.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-hardening@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>
Date:   Sun, 22 Nov 2020 10:25:37 -0800
In-Reply-To: <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
References: <cover.1605896059.git.gustavoars@kernel.org>
         <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <202011201129.B13FDB3C@keescook>
         <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <202011220816.8B6591A@keescook>
         <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-22 at 10:21 -0800, James Bottomley wrote:
> Please tell me
> our reward for all this effort isn't a single missing error print.

There were quite literally dozens of logical defects found
by the fallthrough additions.  Very few were logging only.



