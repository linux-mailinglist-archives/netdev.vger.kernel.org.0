Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2F0303155
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 02:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbhAZBec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 20:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbhAZBbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:31:00 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9546EC061D7D;
        Mon, 25 Jan 2021 17:18:07 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i7so10169972pgc.8;
        Mon, 25 Jan 2021 17:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djoxYJmsOZ1/qDKONU/ZNcJ23IikuKwPiR4LrPsXI+4=;
        b=nUJeFh5M44YpyPYhGLVlmddPIlhE7LBjGH2///V2I6TtpjDtPTwBneYeisv2lcmyCo
         wa3MTE7JvmFPM46cX+SnV1Hq0ftDcCnteGV8Of0BowhEdcTHeVNCKiQVJsrXuaG0IKKp
         HqLqgGcU0I1/s3rRFJ4WiBJbRFPLCbh2AG6mr3yHYn1OnsV9OWnNLZMFh/T7K16KQYaa
         mmMxWWa5T55nWwLbBKYcCZIP4Qh1MquFBlV5kpUMmN/zh3sPhSAXeTLBvq3PGzN3j3/m
         0tKIvs6lK/TWkwHAtmO31OtyaKy7I6rYAsNibLzxZEFeT4Djly+26YHq7gUbJnLKWeyo
         eZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=djoxYJmsOZ1/qDKONU/ZNcJ23IikuKwPiR4LrPsXI+4=;
        b=HotfO2RjL+6LaXm/EIemdEPQYiHaNc6cMkwQwzdOcxAAK20qQtosZbs4uMqZNDg8dN
         TBX+ucgRixIuCT9v0+I6J7CQjDar5S0wBnr2yF2qxQtxcWTqcMuIZ/nZ2v0lIj6k8HlW
         rYt3yikTemcl6uAJHm30G5MeK1zoRXO0xuQPvD7nGLxNoqkcuiAKAZWsh0jDO04Znybi
         AOmluvtrvYw8ma0brY4lLf8pRjh1z+hw7AAnIMk2cY428wQprtuGKNkjJ5NCA4OFq61O
         ATBOgXYuvKah/omqOthpdqP/9lLJcnCDm4tZwwcNNrN0mXiGOu+HwEbGWk6UcAdvzzCP
         Bsrw==
X-Gm-Message-State: AOAM531uoGZq22s2g6yWAUSIv1Lr5vYb0wl6rm81bQdwC63BWjruUd8f
        DKvjc7HuH2mUoDTXg3vgsiE4uOZJ9pSZX4MG
X-Google-Smtp-Source: ABdhPJwRoo7fr09DqKYHdQkx1DKFpnkce8taxjUZfdL78rrfEwNouY9t+6ESEvLWy04FB+wZmW/avg==
X-Received: by 2002:a63:4301:: with SMTP id q1mr3223682pga.430.1611623887019;
        Mon, 25 Jan 2021 17:18:07 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm17050638pfi.131.2021.01.25.17.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 17:18:06 -0800 (PST)
Date:   Tue, 26 Jan 2021 09:17:51 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv16 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210126011751.GM1421720@Leo-laptop-t470s>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210122074652.2981711-4-liuhangbin@gmail.com>
 <20210125122724.GA18646@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125122724.GA18646@ranger.igk.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 01:27:24PM +0100, Maciej Fijalkowski wrote:
> Hangbin,
> 
> before you submit next revision, could you try to apply imperative mood to
> your commit messages?
> 
> From Documentation/process/submitting-patches.rst:
> 
> <quote>
> Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
> instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
> to do frotz", as if you are giving orders to the codebase to change
> its behaviour.
> </quote>
> 
> That's the thing I'm trying to remind people internally and it feels like
> we keep on forgetting about that.

Hi Maciej,

Thanks for the reminder. I just see your reply after post the new version.
As I'm not a native speaker, I always not very sure what kind of mood/words
I should use in the commit message. So I just try to as polite as possible
(although I may pick some rude works that I didn't realize) and not order
people or something else based on our culture/background. I guess that's also
the reason some people forget to use "imperative mood".

I will keep this in mind for future works.

Thanks
Hangbin
