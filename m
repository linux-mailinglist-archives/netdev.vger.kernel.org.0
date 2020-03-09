Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C11417DE00
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCIKzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:55:16 -0400
Received: from edrik.securmail.fr ([45.91.125.3]:30019 "EHLO
        edrik.securmail.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIKzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:55:16 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2020 06:55:16 EDT
Received: by edrik.securmail.fr (Postfix, from userid 58)
        id 2105CB0E73; Mon,  9 Mar 2020 11:48:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583750930;
        bh=Hyq12REpSpK2B3QWJlrzz7d5lEQcrvGRpkB/+KJZMeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=UEi3bb0yTSLGrDRyoR6FmcuB6oy+cMVH5+vYBlS2COmEs4JtdjfUgf74f3dxLCIt+
         vP3250USBBOyf6P47W5AjUZir+lFcJWQXyd7Z4GqRU95JjmvxnWKvs4jRdD7MfPTuS
         qG1+BALwug7HhPytxr3jMmA2Q7TqljzJ0V+xZbdA=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on edrik.securmail.fr
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU autolearn=unavailable
        autolearn_force=no version=3.4.2
Received: from mew.swordarmor.fr (mew.swordarmor.fr [IPv6:2a00:5884:102:1::4])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id 84AFBB0E6C;
        Mon,  9 Mar 2020 11:47:36 +0100 (CET)
Authentication-Results: edrik.securmail.fr/84AFBB0E6C; dmarc=none (p=none dis=none) header.from=swordarmor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583750856;
        bh=Hyq12REpSpK2B3QWJlrzz7d5lEQcrvGRpkB/+KJZMeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=GWu1tcCXWb2kqwhOTJyUZRMGYSNi6aA5S96v4Cs2sTRSu9/otR/DC+Y4Ebr4We6s9
         fvOAqiT6TiS6pxlF5r3erDsO64H97svpIjkw1cCJbLxVkB3KfQJY+qpoz1VUDTUI3s
         xBo12KC8H99Xkrj6pe0irv3Af4J7lxcvO8FAW1PY=
Date:   Mon, 9 Mar 2020 11:47:31 +0100
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     Fabian =?utf-8?Q?Gr=C3=BCnbichler?= <f.gruenbichler@proxmox.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Vincent Bernat <bernat@debian.org>, jack@basilfillan.uk,
        netdev@vger.kernel.org
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200309104731.uiqadwdk6ux3sy65@mew.swordarmor.fr>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
 <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
 <1583744251.2qt66u32rz.astroid@nora.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1583744251.2qt66u32rz.astroid@nora.none>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On lun.  9 mars 09:59:30 2020, Fabian Grünbichler wrote:
> On March 9, 2020 3:15 am, David Ahern wrote:
> > On 3/8/20 4:57 AM, Alarig Le Lay wrote:
> >> On sam.  7 mars 17:52:10 2020, David Ahern wrote:
> >> I have the problem with 5.3 (proxmox 6), so unless FIB handling has been
> >> changed since then, I doubt that it will works, but I will try on
> >> Monday.
> >> 
> > 
> > a fair amount of changes went in through 5.4 including improvements to
> > neighbor handling. 5.4 (I think) also had changes around dumping the
> > route cache.
> 
> FWIW, there is a 5.4-based kernel preview package available in the 
> pvetest repository for Proxmox VE 6.x:
> 
> http://download.proxmox.com/debian/pve/dists/buster/pvetest/binary-amd64/pve-kernel-5.4.22-1-pve_5.4.22-1_amd64.deb

Thanks for the kernel!

I’m still having some issues with 5.4:
root@hv03:~# ip -6 -ts monitor neigh | grep -P 'INCOMPLETE|FAILED'
[2020-03-09T11:35:51.276329] 2a00:5884:0:6::2 dev vmbr12  router FAILED
[2020-03-09T11:36:03.308359] fe80::5287:89ff:fef0:ce81 dev vmbr12  router FAILED
[2020-03-09T11:36:21.996250] 2a00:5884:0:6::1 dev vmbr12  router FAILED
[2020-03-09T11:36:32.524389] 2a00:5884:0:6::1 dev vmbr12  router FAILED
[2020-03-09T11:36:34.800303] 2a00:5884:0:6::2 dev vmbr12  router FAILED
[2020-03-09T11:36:36.588333] 2a00:5884:0:6::1 dev vmbr12  router FAILED
[2020-03-09T11:36:41.196351] 2a00:5884:0:6::1 dev vmbr12  router FAILED

And BGP sessions are flapping as well:
root@hv03:~# birdc6 sh pr | grep bgp
ibgp_asbr01_ipv6 BGP      master   up     11:40:28    Established
ibgp_asbr02_ipv6 BGP      master   up     11:41:09    Established
root@hv03:~# ps -o lstart -p $(pgrep bird6)
                 STARTED
Mon Mar  9 11:14:44 2020


You don’t build linux-perf? I can only find it on the debian repo but
not on the proxmox one nor
http://download.proxmox.com/debian/pve/dists/buster/pvetest/binary-amd64/

root@hv03:~# apt search linux-perf
Sorting... Done
Full Text Search... Done
linux-perf/stable 4.19+105+deb10u3 all
  Performance analysis tools for Linux (meta-package)

linux-perf-4.19/stable 4.19.98-1 amd64
  Performance analysis tools for Linux 4.19

root@hv03:~# apt policy linux-perf/stable
N: Unable to locate package linux-perf/stable
root@hv03:~# apt policy linux-perf
linux-perf:
  Installed: (none)
  Candidate: 4.19+105+deb10u3
  Version table:
     4.19+105+deb10u3 500
        500 http://mirror.grifon.fr/debian buster/main amd64 Packages
root@hv03:~# apt policy linux-perf-4.19
linux-perf-4.19:
  Installed: (none)
  Candidate: 4.19.98-1
  Version table:
     4.19.98-1 500
        500 http://mirror.grifon.fr/debian buster/main amd64 Packages
     4.19.67-2+deb10u2 500
        500 http://mirror.grifon.fr/debian-security buster/updates/main amd64 Packages
root@hv03:~#

Regards,
-- 
Alarig
