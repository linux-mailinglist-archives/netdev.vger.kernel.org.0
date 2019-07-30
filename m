Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D767B60A
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 01:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfG3XFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 19:05:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39948 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfG3XFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 19:05:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id s145so47825023qke.7
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 16:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6mgyXmobHTrs2o2ZLLQ56AnGilF0c85DQgnFxa+XkMI=;
        b=QuU+qrhJfM2jTjXqhXXssS/XZh9LJLGSWhSv9yO60iYPN4Mq+Ts9kpLNWoOEmZ1HED
         ACktNCx6UBvtcEVEVz48gUaybxcEDXNxu1m3i48dx2vhJFlzvL6+DnNcXPX6rgvY896u
         qNGxWmIC+5k8bFmdzqO08XOhA1ngF44bDiBvuLBZi/sHoML9eyra5KTSY0cjPsnQhDdJ
         J76QezgICvZea5bzq+e9cIKm47yR1Pz1VAtceE4ELnKvhXiZVvG2dwCYt8mcpP1hYIr7
         ucOiP2+ZTnDZwuy/oImhGobikpIMXwNYtV00jJcd0C4tp6wkElKUAfkwiSETYSIZPspB
         AqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6mgyXmobHTrs2o2ZLLQ56AnGilF0c85DQgnFxa+XkMI=;
        b=lsNKSfmZt7tAiOH1G8l+XZTZCwTZ4fLTZT2mK6FlWZ6KA61pWH30URlqkyJTIc747c
         hWb1kGc+9tNY3f9x3Pjag1JOgSYGrQXdCGO+ZvlZU+SvdtcY8oLNcxVie2ivCvRXrVwP
         5wqlTcka2z/OQW7Lv7VfyA5fB3WQnui8ZggSz0V7b3MTlvIjIdcfmY7HOcwtgIN3Oqdf
         ZxYZa/HAj20o43ml87ccXUElztixstfU+bQaeKW9KSmGunHFZq5BQ/N2XbyeHlyGK/ni
         X32z3GJOcdOJlQZygLfhVUdUnoYzJmDfun9qZUV3UV2MXBBODNe21oUKKvYsg7Ct3+4n
         eoqg==
X-Gm-Message-State: APjAAAV64kjZePXI6hjN319b/3cvUlr9i9SToGFM1HlYhD5b2fc43acy
        jFRv/x5UCNTRlF/L4Oe802w5Eg==
X-Google-Smtp-Source: APXvYqzbX5I3+hBWk4gulwg6diVg/DllgBsEu7H0m1y+lqOv24s1xCA+d3e1MQ2Ef8hInMZsmPTigg==
X-Received: by 2002:a37:ac19:: with SMTP id e25mr78552195qkm.155.1564527916448;
        Tue, 30 Jul 2019 16:05:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r36sm35454012qte.71.2019.07.30.16.05.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 16:05:16 -0700 (PDT)
Date:   Tue, 30 Jul 2019 16:05:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <rdna@fb.com>, <kernel-team@fb.com>, <hechaol@fb.com>
Subject: Re: [PATCH bpf-next] libbpf : make libbpf_num_possible_cpus
 function thread safe
Message-ID: <20190730160502.699d0b9a@cakuba.netronome.com>
In-Reply-To: <20190730222447.3918919-1-ctakshak@fb.com>
References: <20190730222447.3918919-1-ctakshak@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 15:24:47 -0700, Takshak Chahande wrote:
> Having static variable `cpus` in libbpf_num_possible_cpus function without
> guarding it with mutex makes this function thread-unsafe.
> 
> If multiple threads accessing this function, in the current form; it
> leads to incrementing the static variable value `cpus` in the multiple
> of total available CPUs.
> 
> Let caching the number of possile CPUs handled by libbpf's users than
> this library itself; 

Can we just use stack variable for the calculations and
READ_ONCE()/WRITE_ONCE() for assignment to the static?  
libbpf itself uses this helper so caller caching wouldn't
work there.

> and let this function be rock bottom one which reads
> and parse the file (/sys/devices/system/cpu/possible) everytime it gets
> called to simplify the things.

I don't understand can you rephrase?

> Fixes: 6446b3155521 (bpf: add a new API libbpf_num_possible_cpus())
> 

No new line after the fixes tag, also I think you're missing quotation
marks around the commit title?

> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> Acked-by: Andrey Ignatov <rdna@fb.com>
