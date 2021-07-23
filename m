Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612593D3C1D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbhGWOTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbhGWOTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:19:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F3AC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 08:00:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p5-20020a17090a8685b029015d1a9a6f1aso6485587pjn.1
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 08:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X/sj371l4Ef0K7i0evjzPNm0b0sGeYMdh2i8EIusb6A=;
        b=2L1+AakXtm36vbT/F8JOJZGIuaxXVyy8xkq1Ef/lNm3gTyj8xSphFJWBkiQ3rC1PR6
         J2Mz9bcvavvDuv069erstoybmLyXZqVOodBXbIs1uDlg8cP9CuAlSgZQyWATkioSWHeo
         RDpHUJDuqtSovMqpcIMt2RGqTlP3/H6G1MzphrWQt4ThEKot3f45RcoUSm48SlZs0zoH
         /1rpUQk6eLBG2Dm7aPWCIqdtZdROTn2gNdfnTtqGK29h9jKpsIPmLQscut5rqClEX7Wf
         Sq3OBFCkQGB9C9HRFRVsOI84VxO+qASys/ZjeD8F//36m8UKOXo7ZP3lxWqeVv/nyuXa
         aDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X/sj371l4Ef0K7i0evjzPNm0b0sGeYMdh2i8EIusb6A=;
        b=C8dzZXndSfItdeGo52k4Ap/p623CttHLwJAFnRsVwoezs/xqplCCl5r2lnj3FMQ5Tl
         qSsInUBpZ3INUHM6Re98aEb5s5LrTFiZBmRZWnR6KXo7UAzt2Zhfx9RYqLlszjT6nqRp
         zXSgSIEIgGE5xp500tx5ahc1G0/DbJY7UcEAMaXNIqM0r1i+CbfZX0ES7H9TQjdi01ay
         IpylAHhTifoFc64p9XmFHbWU5bOR0SBB/MYTZB2bWV1LqTP8U/1gxUZxJd1JFddv42a1
         HfL046lXMd/JKZKr31GAOto4MOUJYCS2SBowSjbtYCHLy6ok+Vr0auB26R9OeVwkfony
         brYA==
X-Gm-Message-State: AOAM530Wbkfi0WV6asqzr9PrkCdsOvwTo9g0L97X917Pq1/zqGEmFkEv
        UBUXChvmZdEo750oWsCPHOLzGA==
X-Google-Smtp-Source: ABdhPJyNe10AQ/5tmeRa+A0mUHcYceMWoLPYYOuX0rJenEfA4N1uCfkNZoAvyrfk5xyrujcWHad+qQ==
X-Received: by 2002:aa7:9e1b:0:b029:384:1d00:738 with SMTP id y27-20020aa79e1b0000b02903841d000738mr1112621pfq.71.1627052418756;
        Fri, 23 Jul 2021 08:00:18 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 10sm32959012pjc.41.2021.07.23.08.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 08:00:18 -0700 (PDT)
Date:   Fri, 23 Jul 2021 08:00:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/3] Add, show, link, remove IOAM
 namespaces and schemas
Message-ID: <20210723080015.458bd0df@hermes.local>
In-Reply-To: <20210723075931.722b859f@hermes.local>
References: <20210723144802.14380-1-justin.iurman@uliege.be>
        <20210723144802.14380-2-justin.iurman@uliege.be>
        <20210723075931.722b859f@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Jul 2021 07:59:31 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Fri, 23 Jul 2021 16:48:00 +0200
> Justin Iurman <justin.iurman@uliege.be> wrote:
> 
> > This patch provides support for adding, listing and removing IOAM namespaces
> > and schemas with iproute2. When adding an IOAM namespace, both "data" (=u32)
> > and "wide" (=u64) are optional. Therefore, you can either have none, one of
> > them, or both at the same time. When adding an IOAM schema, there is no
> > restriction on "DATA" except its size (see IOAM6_MAX_SCHEMA_DATA_LEN). By
> > default, an IOAM namespace has no active IOAM schema (meaning an IOAM namespace
> > is not linked to an IOAM schema), and an IOAM schema is not considered
> > as "active" (meaning an IOAM schema is not linked to an IOAM namespace). It is
> > possible to link an IOAM namespace with an IOAM schema, thanks to the last
> > command below (meaning the IOAM schema will be considered as "active" for the
> > specific IOAM namespace).
> > 
> > $ ip ioam
> > Usage:	ip ioam { COMMAND | help }
> > 	ip ioam namespace show
> > 	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]
> > 	ip ioam namespace del ID
> > 	ip ioam schema show
> > 	ip ioam schema add ID DATA
> > 	ip ioam schema del ID
> > 	ip ioam namespace set ID schema { ID | none }
> > 
> > Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> > ---
> >  include/uapi/linux/ioam6_genl.h |  52 +++++
> >  ip/Makefile                     |   2 +-
> >  ip/ip.c                         |   3 +-
> >  ip/ip_common.h                  |   1 +
> >  ip/ipioam6.c                    | 351 ++++++++++++++++++++++++++++++++
> >  5 files changed, 407 insertions(+), 2 deletions(-)
> >  create mode 100644 include/uapi/linux/ioam6_genl.h
> >  create mode 100644 ip/ipioam6.c  
> 
> Please update the man pages as well

Never mind it was in later part of series!
