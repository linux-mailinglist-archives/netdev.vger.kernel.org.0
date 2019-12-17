Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C24122345
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfLQEvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:51:55 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45786 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLQEvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:51:55 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so4943212pgk.12
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 20:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BjknurcRoJCC+C5E234vTfPEQKC2nq0BNOmSSdGPDyk=;
        b=cuyyU8RLGLo8elujr6I0xLm9oi5A4O/laA3MkTrsDraN8hphIcBkD3Uh7tlGUn2B+Y
         eurcrqN1diQt7hLIazeGHN+LHUwEAJd3wBxmZIxhMg+9pGDM+3VN2DeguhUKJqORgHbO
         4GD2QkN9xZJG4f9UlSdFqQp0QXulC/SrJVmv9aU1gxZ9kOa9LmH3ScGHeGCZKZOe5x7P
         ujf5j55f0qn85MN8voESqsjTxNmAcYzldRn3rKtomepusFiVk4kewqgBclTb9V3WmbAe
         8zD2gzdt57RinJVggMw6tXi06/wmAQaZybBauxA5oFud5kqsf5/0ts2nwIKlaYGMd+7B
         28PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BjknurcRoJCC+C5E234vTfPEQKC2nq0BNOmSSdGPDyk=;
        b=Pe8ZbzhFicRJv+rErpylUp3oK3oSfghnKFyCV6TnPEmYD50xy7Q95DXt75mOkGavgB
         PzMOiJgJZrDEPTluzwq1Cl4MsIHZsb8XoNPHqLE7cAJS5yU3pa2iX3AFM+t/7D5Yt3E1
         eTaYMEhJnrvOJ6SCdTNqzmW3umzC4O93OWptP3w1FhG6OSgeQir72r1hNj6SPW3GPut3
         W1nV9N1NXnkdfFTT6vJHyA36kUz8jfa6kEnKq/hKWQg9qMnSBXIBirTEkpePkSbU0G4V
         GWLCvWkjNKpWRP0GLaDXSYad5ketDF+XrPe6hcuN6bHPiio0ZG047Fzp/0rL8R0RXl+e
         VzTQ==
X-Gm-Message-State: APjAAAXKQ9PX7T42Q5HVMJI5nlZ5bMcWwqw9M8UlMrDJjLEf6dWuT1ai
        LlhyFQtpGw9qvX5fLFcQpksNOw==
X-Google-Smtp-Source: APXvYqyzzXgHrURuFWhKSrRhJLp0i4i3LLIIGFGAxBsLb+twDRXaDrEMu8fI0FzXgARDmZXwECfOVg==
X-Received: by 2002:aa7:8ad9:: with SMTP id b25mr20239021pfd.70.1576558314814;
        Mon, 16 Dec 2019 20:51:54 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y17sm24403893pfn.86.2019.12.16.20.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 20:51:54 -0800 (PST)
Date:   Mon, 16 Dec 2019 20:51:46 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH iproute2 0/8] bridge vlan tunnelshow fixes
Message-ID: <20191216205146.3cfd561b@hermes.lan>
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 15:43:36 +0900
Benjamin Poirier <bpoirier@cumulusnetworks.com> wrote:

> Fix various problems in and around normal and json output of `bridge vlan
> tunnelshow`.
> 
> Can be tested using:
> ip link add bridge type bridge
> 
> ip link add vxlan0 type vxlan dstport 4789 external
> ip link set dev vxlan0 master bridge
> ip link set dev vxlan0 type bridge_slave vlan_tunnel on
> 
> bridge vlan add dev vxlan0 vid 1000
> bridge vlan add dev vxlan0 vid 1000 tunnel_info id 1000
> bridge vlan add dev vxlan0 vid 1010-1020
> bridge vlan add dev vxlan0 vid 1010-1020 tunnel_info id 1010-1020
> bridge vlan add dev vxlan0 vid 1030
> bridge vlan add dev vxlan0 vid 1030 tunnel_info id 65556
> 
> Benjamin Poirier (8):
>   json_print: Remove declaration without implementation
>   testsuite: Fix line count test
>   bridge: Fix typo in error messages
>   bridge: Fix src_vni argument in man page
>   bridge: Fix BRIDGE_VLAN_TUNNEL attribute sizes
>   bridge: Fix vni printing
>   bridge: Deduplicate vlan show functions
>   bridge: Fix tunnelshow json output
> 
>  bridge/vlan.c                            | 138 ++++++++---------------
>  include/json_print.h                     |   2 -
>  man/man8/bridge.8                        |   4 +-
>  testsuite/Makefile                       |   3 +-
>  testsuite/lib/generic.sh                 |   8 +-
>  testsuite/tests/bridge/vlan/tunnelshow.t |  33 ++++++
>  6 files changed, 88 insertions(+), 100 deletions(-)
>  create mode 100755 testsuite/tests/bridge/vlan/tunnelshow.t
> 

Thanks for cleaning this up. Applied
