Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF78D05D2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfJIDUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 23:20:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37773 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbfJIDU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 23:20:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so472878pgi.4
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 20:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qUCuQ5EqyfqYf12E3XBgJOCZ33tJDpx2BZcIyJQZBRA=;
        b=hAK+Arbeo2SW0tzxXROTqxumxsYw9fX5dOcF2fD/61n+8HZ5IgUEnsEZPqgfTr8vqp
         Kv67+trOVahRpPb1r39/RZVqQ+E0iE0dnB5YdZeQSpPFOb3DVBXKoiEliQ0a3o5ztVlL
         R6/HfgVi75TGxTpha4K6JNwP1rQg1JxOGJXVcAEXqZGHRyZr3R1dXGMeawv1MOVmwvDX
         pRDlC5iowDwKl685kFTnzyP2qWPCIT2M3Ym/n2Q7A0Q6MjuRwTRTmZn4CvwNn1qMmGUE
         u30vBV4vdlvnUd+elnfWGUQTYg8EajBNNCXGQZp3ny5RIFdUez0aS22cH//vmbskBZwE
         vpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qUCuQ5EqyfqYf12E3XBgJOCZ33tJDpx2BZcIyJQZBRA=;
        b=cQw3oX6PtICU0s6hLdFzE6fJZZr2dE1TTctie/QrPWCsRueDw6k3xfAvGooMppijt5
         1vSkvL4MtVFyKDX2UFLQV2tutVxqBY8mU/uhxLjMRPcqRJ7AKCWbLspuGfgecNPRT+MF
         KWFEYBGTgg3RLSK4Nn4RLeukODOzNHuSdLA0tyVXqp4iYd/AAlKTjoc25NXuKQAkLm/K
         qqO/7CTnbNto+wKiK5SliJ3dC/BfPaasfKo6z24WQhQs9Ghl3Fh0jXwA4JtCXPgKZuGQ
         P5Y1DNupSiaFUIg8+SkyYTkfAQmHuB0iiw9CEsKXRaNtH6AU1SsV3Batt5gH9A8JlKrr
         h1NQ==
X-Gm-Message-State: APjAAAVZxd83gv6YJ0eVsKKb84pvWhrPX8yFEJD7F1CLlbeRREr7gKUW
        aTopS0x/OlaQTMlk+KK/VNPTow==
X-Google-Smtp-Source: APXvYqzSR69gAtGI/dCY8ldPWCHLb1yBUP17Exu4hcIvcf1a8jbQoyTya1KcNIODrHCFEk+6HXyaLA==
X-Received: by 2002:a17:90a:d152:: with SMTP id t18mr1371136pjw.111.1570591227184;
        Tue, 08 Oct 2019 20:20:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u194sm534135pgc.30.2019.10.08.20.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 20:20:26 -0700 (PDT)
Date:   Tue, 8 Oct 2019 20:20:25 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2] tc: fix segmentation fault on gact action
Message-ID: <20191008202025.3e5d749b@hermes.lan>
In-Reply-To: <b498237ee5b99e4687ba5068de09da91ef315235.1569924170.git.aclaudi@redhat.com>
References: <b498237ee5b99e4687ba5068de09da91ef315235.1569924170.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Oct 2019 12:32:17 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> tc segfaults if gact action is used without action or index:
> 
> $ ip link add type dummy
> $ tc actions add action pipe index 1
> $ tc filter add dev dummy0 parent ffff: protocol ip \
>   pref 10 u32 match ip src 127.0.0.2 flowid 1:10 action gact
> Segmentation fault
> 
> We expect tc to fail gracefully with an error message.
> 
> This happens if gact is the last argument of the incomplete
> command. In this case the "gact" action is parsed, the macro
> NEXT_ARG_FWD() is executed and the next matches() crashes
> because of null argv pointer.
> 
> To avoid this, simply use NEXT_ARG() instead.
> 
> With this change in place:
> 
> $ ip link add type dummy
> $ tc actions add action pipe index 1
> $ tc filter add dev dummy0 parent ffff: protocol ip \
>   pref 10 u32 match ip src 127.0.0.2 flowid 1:10 action gact
> Command line is not complete. Try option "help"
> 
> Fixes: fa4958897314 ("tc: Fix binding of gact action by index.")
> Reported-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Thanks, applied
