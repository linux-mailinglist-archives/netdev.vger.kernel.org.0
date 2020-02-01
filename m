Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DCD14F982
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 19:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgBASnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 13:43:22 -0500
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:56011 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726335AbgBASnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 13:43:22 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 86BAF181D3025;
        Sat,  1 Feb 2020 18:43:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1263:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2525:2560:2563:2682:2685:2691:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4659:5007:6117:7514:7809:7974:9010:9025:9388:10004:10049:10400:10848:11232:11256:11657:11658:11914:12043:12296:12297:12555:12740:12760:12895:12986:13184:13229:13439:13891:14093:14096:14097:14181:14659:14721:21080:21221:21324:21325:21451:21611:21627:21691:21990:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: yard08_571b1ee802d3a
X-Filterd-Recvd-Size: 3410
Received: from XPS-9350 (unknown [172.58.95.93])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Sat,  1 Feb 2020 18:43:18 +0000 (UTC)
Message-ID: <08d88848280f93c171e4003027644a35740a8e8e.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
From:   Joe Perches <joe@perches.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 01 Feb 2020 10:41:39 -0800
In-Reply-To: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-02-01 at 13:43 +0100, Lukas Bulwahn wrote:
> Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
> isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
> the terminal slash for the two directories mISDN and hardware. Hence, all
> files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
> but were considered to be part of "THE REST".

Not really.

> Rectify the situation, and while at it, also complete the section with two
> further build files that belong to that subsystem.
> 
> This was identified with a small script that finds all files belonging to
> "THE REST" according to the current MAINTAINERS file, and I investigated
> upon its output.

I believe the MAINTAINERS file will be better with the
proposed patch.

Perhaps this is a defect in the small script as
get_maintainer does already show the directory and
files as being maintained.

ie: get_maintainer.pl does this:

		##if pattern is a directory and it lacks a trailing slash, add one
		if ((-d $value)) {
		    $value =~ s@([^/])$@$1/@;
		}

So:

$ ./scripts/get_maintainer.pl -f drivers/isdn/mISDN
Karsten Keil <isdn@linux-pingi.de> (maintainer:ISDN/mISDN SUBSYSTEM)
netdev@vger.kernel.org (open list:ISDN/mISDN SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

and

$ ./scripts/get_maintainer.pl -f drivers/isdn/mISDN/dsp.h
Karsten Keil <isdn@linux-pingi.de> (maintainer:ISDN/mISDN SUBSYSTEM)
netdev@vger.kernel.org (open list:ISDN/mISDN SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

> Fixes: 6d97985072dc ("isdn: move capi drivers to staging")

And this patch likely does not warrant a 'Fixes:' tag.

> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Arnd, please ack or even pick it.
> It is no functional change, so I guess you could simply pick in your own
> tree for minor fixes.
> 
>  MAINTAINERS | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1f77fb8cdde3..b6a0c4fa8cfd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8908,8 +8908,10 @@ L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
>  L:	netdev@vger.kernel.org
>  W:	http://www.isdn4linux.de
>  S:	Maintained
> -F:	drivers/isdn/mISDN
> -F:	drivers/isdn/hardware
> +F:	drivers/isdn/mISDN/
> +F:	drivers/isdn/hardware/
> +F:	drivers/isdn/Kconfig
> +F:	drivers/isdn/Makefile
>  
>  ISDN/CMTP OVER BLUETOOTH
>  M:	Karsten Keil <isdn@linux-pingi.de>

