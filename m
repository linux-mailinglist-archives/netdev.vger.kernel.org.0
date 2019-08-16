Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FB09073C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfHPRvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 13:51:21 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34273 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfHPRvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 13:51:21 -0400
Received: by mail-qk1-f196.google.com with SMTP id m10so5462579qkk.1
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 10:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=00A8PXEYv7SUacKbSulI1YeAv3mHRh4MRNuFBd4Lqhg=;
        b=YnLbpEqYx0ynG2uh8mLmOVvnxMZfZ8rpx6Q7q2bxKKMooHdqKYmusCXJqCApNGpjhk
         29xkZsTQW/oA6JmFNF5M6/fVAVL1wDnRlyNaNkfQvjR4steNF4ZI2Tirnkd35YYitk3D
         UKQPSmBOzsMC/D7QhwiayrioKPVQwY/OvH5UohORrdgtMRe13y/p5lTaeB3ADRRMkrc8
         xamb86Zw3lIdk5d6qo+E8c7EqO9JovAcxzHhDF4vDGoZ1A5v/wFqZZM8RZfmj9veIz7m
         y5J2EMcwNMrPYu+OICgocF+1neFeDPsGC71sXPHJQj2D9ft2KtReyCUlt8gG1SILBbQE
         6ewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=00A8PXEYv7SUacKbSulI1YeAv3mHRh4MRNuFBd4Lqhg=;
        b=oisc53AQlF3HNh3mHnusLYWa4BKRj8S999EWCxdh+tCmL44y/Zi+9tzFgz7q6UCZGn
         m+895XQMoyRDr+TUJ1E81atRpr9tR4YL+iQhaPozLfVHXBGXglwbPVSe3BkkKuGAcNzG
         rJnVFYet9iBZF5rCYBN55GZwU8l/tvOfkfdlmjsxHU9jHVC+ioNU81OE/t5t0N0BfILS
         eSieDpMRKrKz9ON+xYSEcjlUH73s44nhN4PLEEfWs0e2Vo9X6mkIVgHF2BwEACoVZuF5
         Ga31iEFEUv96sxflcNVFkJeh7VaQjkiMIoV5CC4cIw76QofoelOqNCW6FwIrYk8wcrU6
         AmIw==
X-Gm-Message-State: APjAAAXivwCWryygUaLgkEkoqDc5Xy/3L2J4W2FymtTxGRlZtrYwHbCJ
        dSJhfpXxjzSB7REl8WPqdUcWuw==
X-Google-Smtp-Source: APXvYqyPIeZSUubbpYkFjBLDGn+v8lJZHS00aMD48SIQJFOIfWzk7KWnK9Bg89RW/sYe3fvJKmWtVQ==
X-Received: by 2002:a37:aa88:: with SMTP id t130mr10257725qke.12.1565977880069;
        Fri, 16 Aug 2019 10:51:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k16sm3243369qki.119.2019.08.16.10.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 10:51:19 -0700 (PDT)
Date:   Fri, 16 Aug 2019 10:51:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Subject: Re: [PATCH bpf 0/6] tools: bpftool: fix printf()-like functions
Message-ID: <20190816105102.3a5623b1@cakuba.netronome.com>
In-Reply-To: <CAADnVQLPg8jEsUbKOxzQc5Q1BKrB=urSWiniGwsJhcm=UM7oKA@mail.gmail.com>
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
        <CAADnVQKpPaZ3wJJwSn=JPML9pWzwy_8G9c0H=ToaaxZEJ8isnQ@mail.gmail.com>
        <10602447-213f-fce5-54c7-7952eb3e8712@netronome.com>
        <CAADnVQLPg8jEsUbKOxzQc5Q1BKrB=urSWiniGwsJhcm=UM7oKA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 10:11:12 -0700, Alexei Starovoitov wrote:
> On Fri, Aug 16, 2019 at 9:41 AM Quentin Monnet wrote:
> > 2019-08-15 22:08 UTC-0700 ~ Alexei Starovoitov
> > <alexei.starovoitov@gmail.com>  
> > > On Thu, Aug 15, 2019 at 7:32 AM Quentin Monnet
> > > <quentin.monnet@netronome.com> wrote:  
> > >>
> > >> Hi,
> > >> Because the "__printf()" attributes were used only where the functions are
> > >> implemented, and not in header files, the checks have not been enforced on
> > >> all the calls to printf()-like functions, and a number of errors slipped in
> > >> bpftool over time.
> > >>
> > >> This set cleans up such errors, and then moves the "__printf()" attributes
> > >> to header files, so that the checks are performed at all locations.  
> > >
> > > Applied. Thanks
> > >  
> >
> > Thanks Alexei!
> >
> > I noticed the set was applied to the bpf-next tree, and not bpf. Just
> > checking if this is intentional?  
> 
> Yes. I don't see the _fix_ part in there.

Mm.. these are not critical indeed, but patches 1 and 3 do fix a crash.
Perhaps those should had been a series on their own. 

We'll recalibrate :)

> Looks like cleanup to me.
> I've also considered to push
> commit d34b044038bf ("tools: bpftool: close prog FD before exit on
> showing a single program")
> to bpf-next as well.
> That fd leak didn't feel that necessary to push to bpf tree
> and risk merge conflicts... but I pushed it to bpf at the end.

