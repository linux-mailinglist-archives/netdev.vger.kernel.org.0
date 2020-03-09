Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A1F17DEC8
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgCILf7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Mar 2020 07:35:59 -0400
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:39467 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCILf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:35:59 -0400
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id E65E64375E;
        Mon,  9 Mar 2020 12:35:57 +0100 (CET)
Date:   Mon, 09 Mar 2020 12:35:53 +0100
From:   Fabian =?iso-8859-1?q?Gr=FCnbichler?= <f.gruenbichler@proxmox.com>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Alarig Le Lay <alarig@swordarmor.fr>
Cc:     Vincent Bernat <bernat@debian.org>,
        David Ahern <dsahern@gmail.com>, jack@basilfillan.uk,
        netdev@vger.kernel.org, t.lamprecht@proxmox.com
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
        <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
        <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
        <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
        <1583744251.2qt66u32rz.astroid@nora.none>
        <20200309104731.uiqadwdk6ux3sy65@mew.swordarmor.fr>
In-Reply-To: <20200309104731.uiqadwdk6ux3sy65@mew.swordarmor.fr>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1583753634.g3je71bf3z.astroid@nora.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On March 9, 2020 11:47 am, Alarig Le Lay wrote:
> On lun.  9 mars 09:59:30 2020, Fabian Grünbichler wrote:
>> On March 9, 2020 3:15 am, David Ahern wrote:
>> > On 3/8/20 4:57 AM, Alarig Le Lay wrote:
>> >> On sam.  7 mars 17:52:10 2020, David Ahern wrote:
>> >> I have the problem with 5.3 (proxmox 6), so unless FIB handling has been
>> >> changed since then, I doubt that it will works, but I will try on
>> >> Monday.
>> >> 
>> > 
>> > a fair amount of changes went in through 5.4 including improvements to
>> > neighbor handling. 5.4 (I think) also had changes around dumping the
>> > route cache.
>> 
>> FWIW, there is a 5.4-based kernel preview package available in the 
>> pvetest repository for Proxmox VE 6.x:
>> 
>> http://download.proxmox.com/debian/pve/dists/buster/pvetest/binary-amd64/pve-kernel-5.4.22-1-pve_5.4.22-1_amd64.deb
> 
> Thanks for the kernel!
> 
> I’m still having some issues with 5.4:
> root@hv03:~# ip -6 -ts monitor neigh | grep -P 'INCOMPLETE|FAILED'
> [2020-03-09T11:35:51.276329] 2a00:5884:0:6::2 dev vmbr12  router FAILED
> [2020-03-09T11:36:03.308359] fe80::5287:89ff:fef0:ce81 dev vmbr12  router FAILED
> [2020-03-09T11:36:21.996250] 2a00:5884:0:6::1 dev vmbr12  router FAILED
> [2020-03-09T11:36:32.524389] 2a00:5884:0:6::1 dev vmbr12  router FAILED
> [2020-03-09T11:36:34.800303] 2a00:5884:0:6::2 dev vmbr12  router FAILED
> [2020-03-09T11:36:36.588333] 2a00:5884:0:6::1 dev vmbr12  router FAILED
> [2020-03-09T11:36:41.196351] 2a00:5884:0:6::1 dev vmbr12  router FAILED
> 
> And BGP sessions are flapping as well:
> root@hv03:~# birdc6 sh pr | grep bgp
> ibgp_asbr01_ipv6 BGP      master   up     11:40:28    Established
> ibgp_asbr02_ipv6 BGP      master   up     11:41:09    Established
> root@hv03:~# ps -o lstart -p $(pgrep bird6)
>                  STARTED
> Mon Mar  9 11:14:44 2020
> 
> 
> You don’t build linux-perf? I can only find it on the debian repo but
> not on the proxmox one nor
> http://download.proxmox.com/debian/pve/dists/buster/pvetest/binary-amd64/

called 'linux-tools-$KERNEL_ABI', e.g. linux-tools-5.4, in PVE.

