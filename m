Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A64DCBA5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405968AbfJRQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:36:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36628 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390098AbfJRQgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:36:18 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so3671021pgk.3
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eex7SWWgxlaXP8TznTFgPp6k13Jtc7BVLCC3XaY2af0=;
        b=QXh4kPiDx63M93hwUbPc2LqsbTBhJKMBMaa+pwDZNawbKrdpLHHZerdfEJQhfyhO8k
         JZrTottsQZcudMGtpdc5Fal021Z0Zaa68tb1P0QHDhsVyYGDGyyF7i4MbaNlQVGhms6g
         T7V0ThZdf6IVJDBd2jrbbZUHQhrmJouYwW4AP6fJu8TttdSvOoOYH1FTh4RU057IuM77
         EV4/rOwJUscMttD0pz6q+l4EPQ+6cBLsrZ/pPQS7iOogZy54VjShDsxydcyE6JkgbcAZ
         Wiga4zhZ4dtznHWrs5EkMte9T3HVSgqg2XZAmg3/TjAxl5UCp4SAHU5lvzF+XIz8S4D5
         BhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eex7SWWgxlaXP8TznTFgPp6k13Jtc7BVLCC3XaY2af0=;
        b=rJZWyUectGgwkGOfATc7nPZD2nQMlNyn+OoojN1Lj5nl8a9jM1Gaq10V6mvYK6Jk9K
         i4ihxhArsDli29Vv1eB14wCEkJ2WM628nTiTJgtOAzvG6ITXGRpkHnI18Y/a4FAZgvXh
         R59lZBD6+Aap7gyLr5W9QpAn7IMjQSwQmxtrI17Ksma87FCyp9d6/pHTB1jMcBv0E8OF
         pWTdkkpg66yRQhEzHb1NJfxYuclIMsCCNkXSnZ7jIbXeUYyuuQATWze8PZwfBb5R9oWv
         il6PxuJZ2x5GwoW2j+lzk1ECP7REMavvqMfxqi/mQIDgXRBrQiu9PQM782jnogb4e7qC
         zi/g==
X-Gm-Message-State: APjAAAXoKJ9/OixmH8johFhGHpMBgJp1NWT15TruKKSxkBU+yy720HSB
        LgERKiWOzmqs2klX2gIV2sI+zA==
X-Google-Smtp-Source: APXvYqwR5fGLnT42TZ2HEFmDH+IXOdE9HuKKN0vN8Q8CWh0lgcBBGv6y2qVvZNQDYeQh1xRBUswWpA==
X-Received: by 2002:a63:1403:: with SMTP id u3mr11259310pgl.85.1571416576481;
        Fri, 18 Oct 2019 09:36:16 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g35sm6404843pgg.42.2019.10.18.09.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:36:16 -0700 (PDT)
Date:   Fri, 18 Oct 2019 09:36:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net v2 0/2] net: netem: fix further issues with packet
 corruption
Message-ID: <20191018093614.32a023fd@hermes.lan>
In-Reply-To: <20191018161658.26481-1-jakub.kicinski@netronome.com>
References: <20191018161658.26481-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 09:16:56 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> Hi!
> 
> This set is fixing two more issues with the netem packet corruption.
> 
> First patch (which was previously posted) avoids NULL pointer dereference
> if the first frame gets freed due to allocation or checksum failure.
> v2 improves the clarity of the code a little as requested by Cong.
> 
> Second patch ensures we don't return SUCCESS if the frame was in fact
> dropped. Thanks to this commit message for patch 1 no longer needs the
> "this will still break with a single-frame failure" disclaimer.
> 
> Jakub Kicinski (2):
>   net: netem: fix error path for corrupted GSO frames
>   net: netem: correct the parent's backlog when corrupted packet was
>     dropped
> 
>  net/sched/sch_netem.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 


LGTM

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
