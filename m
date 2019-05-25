Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53952A258
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 04:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfEYCHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 22:07:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43741 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEYCHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 22:07:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so5966750pgv.10;
        Fri, 24 May 2019 19:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f/rPQU5iU7Vv0FUS2+DXMBiiQI1yztk+kw7hy8YbcMA=;
        b=ditw4KNh4hSV5GK6MO3eR/T212Zai3HXPZk1X7GDiSzWFH60yy/jP7Gg/hNYfuCpv4
         qIof+UEg/WfaaQ+bMW5SfFAfhqvi3UsC698VG24++I/xQKpTguzh1Ti5yukTrctcGKq7
         Vp6Yd6+dxy2wL67sF3kLoClaWp2BjnXOELK3Eb5hml5MiFixCPvQfwscYEdTc4WIp4va
         6394U7ZtVhrdMIZbM2m2OiopDLbMd4/ziYApESUQ08H/3doTMR0mAM6WWDr4oTH4fDV6
         Z/2HMTsx+0JX1GrLV/bycWON3azmqHkieWOGqiMX71C8TQmg8suJLjo7rkvPjIB7q3FY
         A7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f/rPQU5iU7Vv0FUS2+DXMBiiQI1yztk+kw7hy8YbcMA=;
        b=g6pVu5PsueQzlO+8TgWw6pofq0WtWsdQVbQWEYs3txBQj/FAuEcMFF0tYLKzKFZtzs
         XJriIACxkzA7TIL8rw45RznrGNeZLhApog32hAlI7bjhRr2p/4ehHgi9j17cHgbtx26E
         CxBtAWms0d8HqT9EyfOCLySZH9es3rLApTXykxoNuVeELfb2j/7thuI0aU1+w7DgKBKt
         6o38aW04LPIv0pnyM6SpwgGGlik7YaHIv24ALyDVgetIWZWS9TQxFBzhcddAbHZ9v2jS
         Lsuu4IEqELU3nOVr/xi1grRVJxa7HgjWO4QLNgx55K4LFfmA5yE4sj/Yi5KlLHpG1kcd
         MvdQ==
X-Gm-Message-State: APjAAAX12fvvG/T37H8nu9RGdQUW3Nl6Yi866pXIsEk0RQUowJGR9gZe
        OUC0JQohxAMlV3zdLeIeJ98=
X-Google-Smtp-Source: APXvYqxUN7CPjOellvE1NxJEEICT3nCI8m8kbjiFtmal6DKoH5fbcb/lb+yAvtyUJYnt/7MTGQji3A==
X-Received: by 2002:a17:90a:248:: with SMTP id t8mr13607099pje.119.1558750061249;
        Fri, 24 May 2019 19:07:41 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::c3a5])
        by smtp.gmail.com with ESMTPSA id t5sm1203620pgh.46.2019.05.24.19.07.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 19:07:40 -0700 (PDT)
Date:   Fri, 24 May 2019 19:07:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH v9 bpf-next 00/17] bpf: eliminate zero extensions for
 sub-register writes
Message-ID: <20190525020736.gty5sdcu5jakffet@ast-mbp.dhcp.thefacebook.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 11:25:11PM +0100, Jiong Wang wrote:
> v9:
>   - Split patch 5 in v8.
>     make bpf uapi header file sync a separate patch. (Alexei)

9th time's a charm? ;)

Applied.
Thanks a lot for all the hard work.
It's a great milestone.

Please follow up with an optimization for bpf_patch_insn_data()
to make it scaleable and undo that workaround in scale tests.

Thanks!

