Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD9E124FA4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfLRRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:47:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43001 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRRr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:47:28 -0500
Received: by mail-pl1-f195.google.com with SMTP id p9so1285880plk.9
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 09:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oIE/497lOI7LXc9jgu4fcSd10UVgyYO9WDSbuj+M5ig=;
        b=wFMRrqMsTXCYjfDjvWyZohde2LR/IevgpQJF96FF6Eb1BeaG44rQelM2V2uJH0kX31
         tmy8KVdBRh/vLeJtwdEOVP72KkmXfL/aTACuSkf4oXfLIaoNVSRU3U3lf59Rq/pdNSw4
         zI6uprq3bmbWl4WAXYL+5x8a+o5L/AVBifW3RPuuXmORdJN3xpERd7FSIxFaBh8iLi3h
         ChEOvBbl1eAH/a+FSzSH7JktEFYDGQyvKE8Go432aX4FvqUlIEGh3rIMHK4hmBy4+vtQ
         9K5HS/hVh9lXt2KvqR2Wxe8Y9/0gBx/sjzb3ulqSJC3RKY/Q5gtUD6KaqiYQfOAqRHMX
         cq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oIE/497lOI7LXc9jgu4fcSd10UVgyYO9WDSbuj+M5ig=;
        b=hceDOQsNIPh7g1HGecdZyIrnMpysgNZnJspKzIVLSbsJgEmjzogd2xzmQkEx2cudZD
         vtUE37EE5MqEnbxuAxLR5yIb9BrhVZINiDQAB713sE+/tOVIxS/iZRE/1uJzNC12yXMR
         aoDwQScUwnVbTsY73ap/FAl24/DpoDWRA8U8WC9YNlSlnd7VKuSI9SVpA4474UVmH8m0
         wXPuIPSL5Gl2s5sCX/k2T4RqTGD2Iev+iUZAXL+y5kcLNc7TScLvegSzyd8qVL27/jhl
         ldaTHeXmPLRcNWLeIZ4QDLlOTuL80linUpTqjulYD7xuSmZmY8YZTZmZakCxkzmpdwVX
         R/6Q==
X-Gm-Message-State: APjAAAVfYDfPobIMVIpHSENUITkzSy7KQ+jMLNHMmREWGha6sWpY4gvc
        65Jr07fz9k5oyr8J1nSWps0ofw==
X-Google-Smtp-Source: APXvYqzrW1Ni4SADZX2cj4+UeYnZzyfvgqMwNH562anPy2ilqN4FNH/QwSxO2WTiRWGpevJElK4Xxw==
X-Received: by 2002:a17:90a:974a:: with SMTP id i10mr4410453pjw.0.1576691247884;
        Wed, 18 Dec 2019 09:47:27 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::5])
        by smtp.gmail.com with ESMTPSA id a10sm4021874pgm.81.2019.12.18.09.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:47:27 -0800 (PST)
Date:   Wed, 18 Dec 2019 09:47:23 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 2/8] xdp: simplify cpumap cleanup
Message-ID: <20191218094723.13ab0d54@cakuba.netronome.com>
In-Reply-To: <20191218105400.2895-3-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
        <20191218105400.2895-3-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 11:53:54 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> After the RCU flavor consolidation [1], call_rcu() and
> synchronize_rcu() waits for preempt-disable regions (NAPI) in addition
> to the read-side critical sections. As a result of this, the cleanup
> code in cpumap can be simplified
>=20
> * There is no longer a need to flush in __cpu_map_entry_free, since we
>   know that this has been done when the call_rcu() callback is
>   triggered.
>=20
> * When freeing the map, there is no need to explicitly wait for a
>   flush. It's guaranteed to be done after the synchronize_rcu() call
>   in cpu_map_free().
>=20
> [1] https://lwn.net/Articles/777036/
>=20
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Probably transient but:

../kernel/bpf/cpumap.c: In function "cpu_map_free":
../kernel/bpf/cpumap.c:502:6: warning: unused variable "cpu" [-Wunused-vari=
able]
  502 |  int cpu;
      |      ^~~

I think there are also warnings in patch 4.
