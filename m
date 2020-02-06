Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15E1154644
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgBFOdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:33:45 -0500
Received: from UPDC19PA20.eemsg.mail.mil ([214.24.27.195]:50490 "EHLO
        UPDC19PA20.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFOdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:33:45 -0500
X-EEMSG-check-017: 55627480|UPDC19PA20_ESA_OUT02.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.70,409,1574121600"; 
   d="scan'208";a="55627480"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UPDC19PA20.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 06 Feb 2020 14:33:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1580999620; x=1612535620;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pbl0LJsEmI5d5aoCawRfKPQ+RXEFO/1PPozjt4Y8z1s=;
  b=igfsSw9oF47zu4pXTMajGk/TB+SvOoXbhOhbi6S3iGSQBEKTfOZcFM81
   VHa+JBWup7aTLsVnphGnHPyUsQEOlUPD4Y7DDD0qaimbDjBmfFamHL3RU
   J1l/VvXohMPElLSlW5e08G6VhutRN/h7YvutV6pW7YLdy/3q7r+w8S2uc
   cD8umwZKWvHBdovWv2iXhmo1jxBIhaf8ri9uCgyQr1mb3w5Dp0Ni2ngYo
   H6AaDE5juVCgwhWcjBwNlE2I296bxsHekgEq+TvB3+U7/RCwcqnzkzCtF
   Rl7KlufhzqB+ZPj8KPVW5hwom/WQEJk1t/G3HT+GumZk+iJ5L0yR4U1Bh
   A==;
X-IronPort-AV: E=Sophos;i="5.70,409,1574121600"; 
   d="scan'208";a="32757981"
IronPort-PHdr: =?us-ascii?q?9a23=3AQCjYgRQRvaqmVM1wZrwd5036/9psv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa67ZRSOt8tkgFKBZ4jH8fUM07OQ7/m8HzFbqsja+DBaKdoQDk?=
 =?us-ascii?q?RD0Z1X1yUbQ+e9QXXhK/DrayFoVO9jb3RCu0+BDE5OBczlbEfTqHDhpRQbGx?=
 =?us-ascii?q?H4KBYnbr+tQt2agMu4zf299IPOaAtUmjW9falyLBKrpgnNq8Uam4RvJrs+xx?=
 =?us-ascii?q?fTonZFdetayGJmKFmOmxrw+tq88IRs/ihNtf8t7dJMXbn/c68lUbFWETMqPn?=
 =?us-ascii?q?wv6sb2rxfDVwyP5nUdUmUSjBVFBhXO4Q/5UJnsrCb0r/Jx1yaGM8L4S7A0Qi?=
 =?us-ascii?q?mi4LxwSBD0kicHNiU2/3/Rh8dtka9UuhOhpxh4w47JfIGYMed1c63Bcd8GQ2?=
 =?us-ascii?q?dKQ91cXDJdDIyic4QPDvIBPedGoIn7u1sOtga1CQ21CO/y1jNEmnr60Ks03O?=
 =?us-ascii?q?Q7FQHNwRIuEdQAvn/JqNn5LbkeXOSwwKTO0D7Nbe5Z2S3l5YbVch4vv/+MU7?=
 =?us-ascii?q?F+f8XfxkYgFR/KgFqLpIz5PT6YzPgBv3SV4udiU++klm4pqxt2ojiq3soil5?=
 =?us-ascii?q?XJiZwNylDE6yp5xps+K8C9SEFhZd6kFIVftiGHPIZxWcMtXnpotT0myrwGpZ?=
 =?us-ascii?q?G7fC8KxI4hxx7EcfOLaYeI4hX9VOuIJzpzmXxreLW6hxmo8EigzPXxVsqq31?=
 =?us-ascii?q?ZQqCpKjN3MumoK1xzJ5ciKTOZ28ES52TuXygze5e5JLVo0mKbGMZIt3LE9mo?=
 =?us-ascii?q?QJvUjeGCL9hV/4g7WMdko+/+il8+HnYrL7qZCCL4J0kQT+Mrg2msy4HOQ4Lh?=
 =?us-ascii?q?ACX2iF9uS4073u5VH5T69Qjv03j6nZq4rWJcUdpq63BA9VyZgs5AqlAze60N?=
 =?us-ascii?q?UXgXkHLFVfdBKBk4fpIE3BLOr9Dfe+h1SgiDZrx/bYMb39GpjBM3fOnbj7cb?=
 =?us-ascii?q?t99kJQ0hQ/wN9B655OF70NOPfzVVXwtNzcAB85KQu0w+P/BdVmy4weQnmCAr?=
 =?us-ascii?q?OZMazOsV+I4fgjI++XZIAPojr9JP8l5+D2gX8jhVAdZbWp3YcQaH2gA/tpOV?=
 =?us-ascii?q?uZbmTpgtoaDGgFpBQ+Q/LviF2GVj5TaWqyU7g65j4lFIKsFZ3DSZy1gLydwC?=
 =?us-ascii?q?e7GYVbZmRBClCWD3jocYSFW/AXZSKdJc9hlTMEVby/RIM7yR6uswr6waJ9Lu?=
 =?us-ascii?q?XI4i0YqY7j1N9t6uLJkBE97yF7ANqG3m6XVGF0m3gHRzss3Kxlp0xy1EuD27?=
 =?us-ascii?q?Big/NEDdxT++9JUgAiOJ7a0eN6F839VRzfftqSVlamTcupASsrQtIy3dAOeU?=
 =?us-ascii?q?B9FMumjhzZ2CqqGbAVnaSRBJMo6qLcw2TxJ8FlxnbDzqYggFomT9BWNW26h6?=
 =?us-ascii?q?5z7RHTB5PTnEWdi6mqcqEc3CvX+GifymqOuRIQbAklG4nMQ3ETLnCQ5fH44k?=
 =?us-ascii?q?fPVfXmXbguLAZE4cKLNKZPbtrnkRNASeu1a/rEZGfkoHu9HRaFwPu3aYPuf2?=
 =?us-ascii?q?gMlHHGBFMsjxEY/XHAMxM3QCimvTSNX3RVCVvzbha0oqFFo3ShQxpxllvbYg?=
 =?us-ascii?q?=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2ALDQA5Hjxe/wHyM5BmHAEBAQEBBwEBEQEEBAEBgXsCg?=
 =?us-ascii?q?XuBGFQhEiqEFYglXoZlAQEBBoESihWPUYF6CQEBAQEBAQEBARsQDAEBhEACg?=
 =?us-ascii?q?mE8Ag0CEAEBAQQBAQEBAQUDAQFshTcMgjspAYMCBiMVQRAlAiYCAlcGDQYCA?=
 =?us-ascii?q?QGCYz8BglYlD6tWgTKENQGEeYE4BoEOKgGMPHmBB4ERJwwDgxuHW4JeBJc+R?=
 =?us-ascii?q?pdngkSCToR8jnYGG5sKAS2XIZRfC4FYKwgCGAghD4MnEz0YDY4pFxWIT4VdI?=
 =?us-ascii?q?wMwAgGORwEB?=
Received: from tarius.tycho.ncsc.mil (HELO tarius.infosec.tycho.ncsc.mil) ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 06 Feb 2020 14:33:39 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.infosec.tycho.ncsc.mil (8.14.7/8.14.4) with ESMTP id 016EWiWq070117;
        Thu, 6 Feb 2020 09:32:46 -0500
Subject: BUG: sock_init_data() assumes socket is embedded in socket_alloc,
 tun/tap does not
From:   Stephen Smalley <sds@tycho.nsa.gov>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     lorenzo@google.com, amade@asmblr.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        maxk@qti.qualcomm.com
References: <20200124002306.3552-1-casey.ref@schaufler-ca.com>
 <20200124002306.3552-1-casey@schaufler-ca.com>
 <22585291-b7e0-5a22-6682-168611d902fa@tycho.nsa.gov>
 <6b717a13-3586-5854-0eee-617798f92d34@schaufler-ca.com>
 <de97dc66-7f5b-21f0-cf3d-a1485acbc1c9@tycho.nsa.gov>
 <628f018e-5a88-295b-9e4d-b4c6a49645b5@tycho.nsa.gov>
Message-ID: <5cc30771-f16b-1444-0b31-91ca02796b9a@tycho.nsa.gov>
Date:   Thu, 6 Feb 2020 09:34:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <628f018e-5a88-295b-9e4d-b4c6a49645b5@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 86741ec25462e4c8cdce6df2f41ead05568c7d5e ("net: core: Add a 
UID field to struct sock.") circa v4.10, sock_init_data() dereferences 
SOCK_INODE(sock) whenever sock is non-NULL, thereby requiring all 
callers that provide a socket to have embedded it within a struct 
socket_alloc.  However, the tun and tap drivers embed a struct socket 
within their own data structures (tun_file and tap_queue), call 
sock_init_data() on these sockets, and were not updated to wrap these 
sockets within socket_alloc. I haven't checked whether there may be 
other cases beyond tun/tap.  A bug report with RFC patches was posted by 
amade@asmblr.net back in September to address the tun/tap case here:
https://lore.kernel.org/netdev/20190929110502.2284-1-amade@asmblr.net/ 
seemingly without any response or follow-up that I could see in the 
archives.

Is sock_init_data() wrong to make this assumption, and if so, how should 
it be fixed?  Or should tun/tap and any other callers be updated to 
embed their sockets within socket_alloc structures?  Or should they not 
call sock_init_data() on their sockets?

Sorry if this has been discussed elsewhere but I couldn't find anything 
beyond what I cited above.

