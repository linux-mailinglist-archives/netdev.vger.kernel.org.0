Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED1E0336
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbfJVLnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:43:22 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:35272 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730515AbfJVLnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 07:43:22 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id 354F1A36DE;
        Tue, 22 Oct 2019 13:43:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1571744598;
        bh=PL+MS9WK2NxE5fJ6IsanL5YnouIlzoCz8e3JcSi9SiE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AzTQz9pYhDZOCi91CgiwkkbtNt12CVtYy4QsoUb7wWKndEklWRtIZfgW+gmNclpLA
         eQ4yhItpShkPRWwmzhGEakDlj/3+ZDHX2lhoCsaPFSCZRzbdJIH3E0NUAblBi4E+g8
         TkOqT16lZ+UARIyFWNnqWln83hW5MLf/8SWJ2qPY=
Subject: Re: [PATCH net-next v2 00/16] net: dsa: turn arrays of ports into a
 list
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <821609f6-5430-5c46-82a4-a30a6eb85531@ysoft.com>
Date:   Tue, 22 Oct 2019 13:43:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21. 10. 19 22:51, Vivien Didelot wrote:
> The dsa_switch structure represents the physical switch device itself,
> and is allocated by the driver. The dsa_switch_tree and dsa_port structures
> represent the logical switch fabric (eventually composed of multiple switch
> devices) and its ports, and are allocated by the DSA core.
> 
> This branch lists the logical ports directly in the fabric which simplifies
> the iteration over all ports when assigning the default CPU port or configuring
> the D in DSA in drivers like mv88e6xxx.
> 
> This also removes the unique dst->cpu_dp pointer and is a first step towards
> supporting multiple CPU ports and dropping the DSA_MAX_PORTS limitation.
> 
> Because the dsa_port structures are not tight to the dsa_switch structure
> anymore, we do not need to provide an helper for the drivers to allocate a
> switch structure. Like in many other subsystems, drivers can now embed their
> dsa_switch structure as they wish into their private structure. This will
> be particularly interesting for the Broadcom drivers which were currently
> limited by the dynamically allocated array of DSA ports.
> 
> The series implements the list of dsa_port structures, makes use of it,
> then drops dst->cpu_dp and the dsa_switch_alloc helper.

I just tried the whole series on our imx6dl-yapp4-hydra with QCA8334
switch and did not notice any problems as well. Thank you.

Tested-by: Michal Vokáč <michal.vokac@ysoft.com>
