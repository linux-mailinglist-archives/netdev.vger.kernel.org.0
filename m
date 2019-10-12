Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DE9D4FC3
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 14:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfJLMna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 08:43:30 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34657 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfJLMla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 08:41:30 -0400
Received: by mail-ed1-f66.google.com with SMTP id p10so10990863edq.1
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 05:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=akcTgSeRf+qddbSglQfwxr/nWa9124rRhmN15UPw3vg=;
        b=FR2OovpWwN2Pwc97ie8vN4KaduScEB16ZPV1z42b2M6FyYDhWHNukvCW5lVRltAb5R
         y4GGS+dBgnrwkEKP46ill9l5IVe+uS36dU2q8vkrXIj9M90iJnDYnki1u0mrdux3Lrop
         smsrsq37mJIYulyih2Zhix95u/UoO91EnSVkLP7mDGonLj4RHEfYaPSP7WqjdmZ9GATN
         njqbibZh8UMC41tH2Voy29FOdS9Uv8lPSYn4DQjNyzmZFJz8RQ9EE9iP4Xbf84is491K
         TF5g8eqFX+0WvLNw972hl+ChnVfiQsP/YMYVBskN3y/Uqh8gMmcE8fNHOxYCOXkXlNl7
         zxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=akcTgSeRf+qddbSglQfwxr/nWa9124rRhmN15UPw3vg=;
        b=Nkcw4Z6x0S62l6M8Bm3T65M3FQ/erNzHsEUfxSjClMXSngW0/2Dxi1tjeOzkag8Uzj
         aW19QOJ3gAg4zWAWS8bd7zu7EkmS27IYUoTIVKnghPh8YoI/pztNNMPjF/INYuT7tTgD
         cs/a2nFFTqMN6krsW0OsoD9MLkR6RRO105JTXtZa/w0FoVxoQNLu0QMjJdfQH8yWYr/u
         DOeENEPoWp6FMGzVPYuK7SGRnABhZK5lMxuUntdbhobPfXoEHvhKH2hKhpVxwY/xIGmL
         xBTBoomUCVmc/cqYlVJ1VVm6wgTT+6xunG9JntmtMw+wl+V9ZpUN66IT9RN4kFdVZKHF
         BBnA==
X-Gm-Message-State: APjAAAXrdI02MMpz16krCGzNk5wMI1gKm/I+nyyK+CWcDOaUFjfz0t/K
        peIKxKg5RYxY41Md1EimncNXhA==
X-Google-Smtp-Source: APXvYqxIu6IqhF8K52bifRJ9w9PiMvBA5WhDuuqeW3ZWDs9mjquvzpGULFyJKCmFPW6Vw4ESHL6RuQ==
X-Received: by 2002:a50:cbcd:: with SMTP id l13mr18477317edi.18.1570884087408;
        Sat, 12 Oct 2019 05:41:27 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id o22sm1990542edv.26.2019.10.12.05.41.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 12 Oct 2019 05:41:26 -0700 (PDT)
Date:   Sat, 12 Oct 2019 14:41:24 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     lkp@intel.com, davem@davemloft.net, john.hurley@netronome.com,
        kbuild-all@01.org, lorenzo@kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH net v2 0/2] net/sched: fix wrong behavior of MPLS
 push/pop action
Message-ID: <20191012124123.iy7cysxvroat3alt@netronome.com>
References: <cover.1570878412.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1570878412.git.dcaratti@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 01:55:05PM +0200, Davide Caratti wrote:
> this series contains two fixes for TC 'act_mpls', that try to address
> two problems that can be observed configuring simple 'push' / 'pop'
> operations:
> - patch 1/2 avoids dropping non-MPLS packets that pass through the MPLS
>   'pop' action.
> - patch 2/2 fixes corruption of the L2 header that occurs when 'push'
>   or 'pop' actions are configured in TC egress path.
> 
> v2: - change commit message in patch 1/2 to better describe that the
>       patch impacts only TC, thanks to Simon Horman
>     - fix missing documentation of 'mac_len' in patch 2/2

Thanks for the follow-up, this looks good to me.

> Davide Caratti (2):
>   net: avoid errors when trying to pop MLPS header on non-MPLS packets
>   net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions
> 
>  include/linux/skbuff.h    |  5 +++--
>  net/core/skbuff.c         | 21 ++++++++++++---------
>  net/openvswitch/actions.c |  5 +++--
>  net/sched/act_mpls.c      | 12 ++++++++----
>  4 files changed, 26 insertions(+), 17 deletions(-)
> 
> -- 
> 2.21.0
> 
