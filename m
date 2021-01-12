Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C460B2F3A57
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406796AbhALT1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406210AbhALT1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 14:27:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC4D2070B;
        Tue, 12 Jan 2021 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610479616;
        bh=oRIGBpyvZ+0fAXif4CHdxgH/R6ugad6L0Gt2jTZOVS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f9VdN/FBQO4rp589y5ycRx3ZZB52N++lsSg8muuZghakndcbwalYovrqlI7as7NIW
         cIOMiqpkO+Y1YhOEpHUZYkoIPkOZCxVTrhtkPCM79t5W1HeIZshdHOa0fVK5rwGYQ8
         asZkkX7gjldUYC898MRy+PdIpVzL2EDqz2hrigbKYvwZoCbyBsK6fSlKK2SwaBGuzp
         sz4cD19pmIZS+dtin5MUdW+C7pTRYeaa+zdxj542bl0S3mpybW2XcfGn8el3x0j/Ne
         j6JZdPNSEL2Q69tlEF8ku05ExTN14CQrFJ5/fRrGNKxbi9pzQM839yQpquoy+ZUtXq
         2tiBCUtuRr0Rg==
Received: by pali.im (Postfix)
        id 896BE856; Tue, 12 Jan 2021 20:26:53 +0100 (CET)
Date:   Tue, 12 Jan 2021 20:26:47 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
Message-ID: <20210112192647.ainhrkwhruejke4v@pali>
References: <20210102140254.16714-1-pali@kernel.org>
 <20210102183952.4155-1-pali@kernel.org>
 <20210110163824.awdrmf3etndlyuls@pali>
 <16eaf3ce-3e76-5e34-5909-be065502abca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16eaf3ce-3e76-5e34-5909-be065502abca@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 10 January 2021 20:57:50 Alejandro Colomar (man-pages) wrote:
> [ CC += netdev ]
> 
> On 1/10/21 5:38 PM, Pali Rohár wrote:
> > On Saturday 02 January 2021 19:39:52 Pali Rohár wrote:
> >> Also add description for struct in6_ifreq which is used for IPv6 addresses.
> >>
> >> SIOCSIFADDR and SIOCDIFADDR can be used to add or delete IPv6 address and
> >> pppd is using these ioctls for a long time. Surprisingly SIOCDIFADDR cannot
> >> be used for deleting IPv4 address but only for IPv6 addresses.
> >>
> >> Signed-off-by: Pali Rohár <pali@kernel.org>
> >> ---
> >>  man7/netdevice.7 | 50 +++++++++++++++++++++++++++++++++++++++++-------
> >>  1 file changed, 43 insertions(+), 7 deletions(-)
> > 
> > Hello! Is something else needed for this patch?
> 
> Hello Pali,
> 
> Sorry, I forgot to comment a few more formatting/wording issues: see
> below.  Apart from that, I'd prefer Michael to review this one.
> 
> Thanks,
> 
> Alex

Hello Alex! I will try to explain configuring IPv4 and IPv6 addresses on
network interfaces, so you probably could have better way how to improve
description in "official" manpage. I'm not native English speaker, so I
would follow any suggestions from you.


AF_INET (via struct ifreq)

* SIOCGIFADDR - returns first/primary IPv4 address for ifr_name
* SIOCSIFADDR - changes first/primary IPv4 address for ifr_name
* SIOCDIFADDR - unsupported, returns error
* SIOCGIFDSTADDR - returns first/primary IPv4 peer/destination address
* SIOCSIFDSTADDR - changes first/primary IPv4 peer/destination address

Non-primary IPv4 addresses with label are present in virtual network
interfaces which have ':label' suffix. E.g. non-primary address for eth0
with label 0 can be changed by SIOCSIFADDR by specifying 'eth0:0' as
interface name. Non-primary IPv4 address which do not have assigned
label are invisible for SIOCGIFADDR / SIOCSIFADDR. Primary IPv4
addresses can be deleted by changing address to 0.0.0.0 via SIOCSIFADDR.
Similarly also for non-primary address with label. Non-primary IPv4
addresses without label can be listed, added or removed only via
rtnetlink interface.

SIOCGIFDSTADDR / SIOCSIFDSTADDR are like SIOCGIFADDR / SIOCSIFADDR
(including labels for non-primary).


AF_INET6 (via struct in6_ifreq):

* SIOCGIFADDR - unsupported, returns error
* SIOCSIFADDR - adds a new IPv6 address for ifr6_ifindex
* SIOCDIFADDR - deletes specified IPv6 address for ifr6_ifindex
* SIOCGIFDSTADDR - unsupported
* SIOCSIFDSTADDR - unsupported for IPv6 addresses

IPv6 addresses can be listed only via /proc/net/if_inet6 file or via
rtnetlink interface. SIOCSIFADDR for AF_INET6 (unlike AF_INET) adds a
new IPv6 address to interface (not change first/primary IPv6 address).
For IPv6 they do not have concept of first address and therefore for
deleting is needed to use different ioctl SIOCSIFADDR (not setting zero
address via SIOCSIFADDR as in IPv4).

Retrieving, adding and deleting IPv6 peer/destination addresses (e.g.
for point to point protocols) can be only via rtnetlink interface. IIRC
there is no other way, there is no ioctl/sysfs/procfs interface.


There is some strange way how to setup a new SIT (IPv6-in-IPv4) tunnel.
It is by using AF_INET6 SIOCSIFDSTADDR ioctl on sit0 master interface
(field ifr6_ifindex) with IPv4 address of remote peer set in low 32 bits
of 128 bit IPv6 address (field ifr6_addr). Other bits of IPv6 storage
needs to be zero. So SIOCSIFDSTADDR is there also for AF_INET6 socket,
but is doing something totally different as for AF_INET and what is
described in current netdevice.7 manpage. Also note that I have not
found a way how to retrieve this IPv4 peer address in other way than via
rtnetlink.

You can try this via 'ifconfig sit0 inet6 tunnel ::10.0.0.1' call to
create a new IPv6-in-IPv4 interface (sitN, N first unused) which
forwards IPv6 traffic encapsulated in IPv4 to IPv4 server 10.0.0.1.


Another thing which makes debugging hard, strace does not support
decoding these ioctl calls for AF_INET6 sockets and thinks that passed
structure is IPv4's struct ifreq, which is just a garbage on screen.

> > 
> >> diff --git a/man7/netdevice.7 b/man7/netdevice.7
> >> index 488e83d9a..12f94bfd7 100644
> >> --- a/man7/netdevice.7
> >> +++ b/man7/netdevice.7
> >> @@ -55,9 +55,26 @@ struct ifreq {
> >>  .EE
> >>  .in
> >>  .PP
> >> +AF_INET6 is an exception.
> 
> [
> .B AF_INET6
> is an exception.
> ]
> 
> Sorry, this was my mistake on the previous review,
> as I mixed expected output with actual code, and confused you.
> 
> >> +It passes an
> >> +.I in6_ifreq
> >> +structure:
> >> +.PP
> >> +.in +4n
> >> +.EX
> >> +struct in6_ifreq {
> >> +    struct in6_addr     ifr6_addr;
> >> +    u32                 ifr6_prefixlen;
> >> +    int                 ifr6_ifindex; /* Interface index */
> >> +};
> >> +.EE
> >> +.in
> >> +.PP
> >>  Normally, the user specifies which device to affect by setting
> >>  .I ifr_name
> >> -to the name of the interface.
> >> +to the name of the interface or
> >> +.I ifr6_ifindex
> >> +to the index of the interface.
> >>  All other members of the structure may
> >>  share memory.
> >>  .SS Ioctls
> >> @@ -142,13 +159,32 @@ IFF_ISATAP:Interface is RFC4214 ISATAP interface.
> >>  .PP
> >>  Setting the extended (private) interface flags is a privileged operation.
> >>  .TP
> >> -.BR SIOCGIFADDR ", " SIOCSIFADDR
> >> -Get or set the address of the device using
> >> -.IR ifr_addr .
> >> -Setting the interface address is a privileged operation.
> >> -For compatibility, only
> >> +.BR SIOCGIFADDR ", " SIOCSIFADDR ", " SIOCDIFADDR
> >> +Get, set or delete the address of the device using
> 
> [Get, set, or delete ...]
> 
> Note the extra comma (Oxford comma).
> 
> >> +.IR ifr_addr ,
> >> +or
> >> +.I ifr6_addr
> >> +with
> >> +.IR ifr6_prefixlen .
> >> +Setting or deleting the interface address is a privileged operation.
> >> +For compatibility,
> >> +.B SIOCGIFADDR
> >> +returns only
> >>  .B AF_INET
> >> -addresses are accepted or returned.
> >> +addresses,
> >> +.B SIOCSIFADDR
> >> +accepts
> >> +.B AF_INET
> >> +and
> >> +.B AF_INET6
> >> +addresses and
> 
> [addresses, and]
> 
> Rationale: clearly separate SIOCS* text from SIOCD* text.
> 
> >> +.B SIOCDIFADDR
> >> +deletes only
> >> +.B AF_INET6
> >> +addresses.
> >> +.B AF_INET
> >> +address can be deleted by setting zero address via
> 
> Suggestion:
> 
> [
> A
> .B XXX
> address ... by setting it to zero via
> ]
> 
> Although I don't know exactly how all this works,
> so it's only a suggestion, but that needs some wording fix.
> 
> >> +.BR SIOCSIFADDR .
> >>  .TP
> >>  .BR SIOCGIFDSTADDR ", " SIOCSIFDSTADDR
> >>  Get or set the destination address of a point-to-point device using
> >> -- 
> >> 2.20.1
> >>
> 
> 
> -- 
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
> http://www.alejandro-colomar.es/
