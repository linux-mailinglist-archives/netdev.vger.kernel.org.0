Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E191DA2FE
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgESUn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgESUn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:43:26 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB5BC08C5C0;
        Tue, 19 May 2020 13:43:26 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id p12so766746qtn.13;
        Tue, 19 May 2020 13:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OFP9BVkYTwegi8w3Sxc3QS5TMs6p15mFNHj0QYGw7JQ=;
        b=aDRXBQUAF2HFW3F5NrZfQPjaxIFEsbwTpp/7banEbidmG2NxnKOGUYZAAbxQYfsgnn
         bDHzPhEly8Q/+kq2U6/ElZe8zVvRg8nL/aNDTaNtwvlEXnb0s0r0DUtJVxGzu0JLXKAl
         kCVuWFQ+XDjDOj/Epg6uQpMXSTc9RvxviwhBQowGArEQvXvx8ZFtOMF59g8nDIODiRVL
         /hu0xYUjm145/GhaV5iSIZRPDIzHoKg6wBtYW3p0oRSLYh4WrociuKJnQ7qK1/LwvYOV
         +MurNtRiZTBdw19P0vgvY2z9TZUjX5wRdCc2FRh0FgtQbxCqwFCHEB3bqy510WMtlfSc
         KGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFP9BVkYTwegi8w3Sxc3QS5TMs6p15mFNHj0QYGw7JQ=;
        b=VVEQV1Tt5ujJ1B19fa/Cmp7ILP0uNndycj6vJXMfYJ6ozdO49n1cnRKo96uHwDahZc
         vCln3hC8d0lx8hHPly2OHQ1rhayjznOdL5xvQo/JlQ5GoiftQDDnvOSrQcFNA/FUIrHa
         XxoEcms7IBv7xs5eaLQcxzapASsD95q/k9nhcFvwlw3oVrVPaszIN8mEXOk0QxDVRGBZ
         L5KPM2PqZIRPYWzCNpX7Sx9mY9KrQ7s/61acBxdRNPoZDw6EE5swxRK9dJ0v2Mb2fpnR
         ILFE7SJHoruAS5Qezs+EPvvnTZUhkItmm45YVQZ8f3NWsLY0vOH2Kyf9gcac2LPFijwC
         PtEA==
X-Gm-Message-State: AOAM532bkJk3Fvl+AeRC9BdcFdNTGCq0pZ4EGUhKR/MUuRKOjC/tIj9c
        fr0baJpKtyaxY/QqAdqKGYN5m6leOps=
X-Google-Smtp-Source: ABdhPJxeNLjkfZ+Y10RPicorhTB/4Cdwo5pWfk/pH89v9eZEAg0NzYL87OoT0rW1NOcdkVl69wvMtw==
X-Received: by 2002:ac8:2c28:: with SMTP id d37mr1880993qta.68.1589921005768;
        Tue, 19 May 2020 13:43:25 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:fa5d:572c:344c:b561:94e0])
        by smtp.gmail.com with ESMTPSA id c26sm501829qkm.98.2020.05.19.13.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 13:43:24 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4380FC08DA; Tue, 19 May 2020 17:43:22 -0300 (-03)
Date:   Tue, 19 May 2020 17:43:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, jere.leppanen@nokia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sctp: Don't add the shutdown timer if its already been
 added
Message-ID: <20200519204322.GR2491@localhost.localdomain>
References: <20200519200405.857632-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519200405.857632-1-nhorman@tuxdriver.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 04:04:05PM -0400, Neil Horman wrote:
> This BUG halt was reported a while back, but the patch somehow got
> missed:
> 
> PID: 2879   TASK: c16adaa0  CPU: 1   COMMAND: "sctpn"
>  #0 [f418dd28] crash_kexec at c04a7d8c
>  #1 [f418dd7c] oops_end at c0863e02
>  #2 [f418dd90] do_invalid_op at c040aaca
>  #3 [f418de28] error_code (via invalid_op) at c08631a5
>     EAX: f34baac0  EBX: 00000090  ECX: f418deb0  EDX: f5542950  EBP: 00000000
>     DS:  007b      ESI: f34ba800  ES:  007b      EDI: f418dea0  GS:  00e0
>     CS:  0060      EIP: c046fa5e  ERR: ffffffff  EFLAGS: 00010286
>  #4 [f418de5c] add_timer at c046fa5e
>  #5 [f418de68] sctp_do_sm at f8db8c77 [sctp]
>  #6 [f418df30] sctp_primitive_SHUTDOWN at f8dcc1b5 [sctp]
>  #7 [f418df48] inet_shutdown at c080baf9
>  #8 [f418df5c] sys_shutdown at c079eedf
>  #9 [f418df70] sys_socketcall at c079fe88
>     EAX: ffffffda  EBX: 0000000d  ECX: bfceea90  EDX: 0937af98
>     DS:  007b      ESI: 0000000c  ES:  007b      EDI: b7150ae4
>     SS:  007b      ESP: bfceea7c  EBP: bfceeaa8  GS:  0033
>     CS:  0073      EIP: b775c424  ERR: 00000066  EFLAGS: 00000282
> 
> It appears that the side effect that starts the shutdown timer was processed
> multiple times, which can happen as multiple paths can trigger it.  This of
> course leads to the BUG halt in add_timer getting called.
> 
> Fix seems pretty straightforward, just check before the timer is added if its
> already been started.  If it has mod the timer instead to min(current
> expiration, new expiration)
> 
> Its been tested but not confirmed to fix the problem, as the issue has only
> occured in production environments where test kernels are enjoined from being
> installed.  It appears to be a sane fix to me though.  Also, recentely,
> Jere found a reproducer posted on list to confirm that this resolves the
> issues
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Vlad Yasevich <vyasevich@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: jere.leppanen@nokia.com
> CC: marcelo.leitner@gmail.com
> CC: netdev@vger.kernel.org

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
