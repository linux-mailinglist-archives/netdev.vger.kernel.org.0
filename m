Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4563F3E9590
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhHKQIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHKQIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:08:44 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6291C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:08:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so10456006pjs.0
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 09:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K6DsowF4AXsH3BFFA3k6Be+XAx2AtPHFs6GabMLgMxY=;
        b=jpLDNLf0Who2ZcMaRDYORzQfKNNj26HnhIVDr/xXhKX1k4KZORlnISeFIChldsTElc
         nDkPTO/uOrJEXWqsgaDVnawEzlKddFhalBxN0DpfTyhnlSviuE228Xs8HPizYvWmhjHa
         lk4BLK/6JGb9E9ojYGOEUnSh3Efwo4x4qW6kDvFd2VOpfa4Ti0Pa3uwAbqqilHuFqsBI
         NmH4MmdRSjakPYskdCa599e47jBfVUaxPlMMmkpFbPSm7DT3DUHqbHgf19cqV1hfy3Xs
         hiCzgXUsv5L8SD89uJw5MB4bPjVUbslXwju+dVwBGABq6exzztwgiVzrQwj89d/ZNv0t
         UXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K6DsowF4AXsH3BFFA3k6Be+XAx2AtPHFs6GabMLgMxY=;
        b=Z3u7VUjHNMz09ReDxAeTA0SLCHrU31KJ6DbCTeV3CaiZxtRRRYRfe3R/Sjy4ss5cx4
         /ADe5TGenYnrbcXK/wkXpOvswsIQ8mytPo+xNESI+X7mm/NRonlBVVyqhffX/nTLfuah
         1Nx5gO7JPZf0/pCwhEccPv9ziXkcEH+Iheu55CIydad02D9NCY1tLssSFqbWQuIJXtha
         eXirvLK9czKWMTSjMud1rrfVLJHCmvUAgK7F1UpPNEQe+4ZQHBDb9gmoAP5kcjonAbIT
         DYxOj9zAoxqFjxioZxUXebgQspxEFr0VNkXzC6q4sMtwWmmO0+ssIyKhzNYpeX+3X4Fp
         fOVA==
X-Gm-Message-State: AOAM5301I+mYqPWK5756iFuGlZyDRJqOKyj2pmz/WAwWsJSitz5sQLeL
        rNlBRsA0ehyvUYRNrm4KSz0Q7w==
X-Google-Smtp-Source: ABdhPJzN5Plj/ZcjaQDhV4yDMOQKPYG2udnnS9lV7XAZDbv1fKAjOOvQThsXTjt2PA6UDuWIDnzLFA==
X-Received: by 2002:a05:6a00:16d6:b029:32a:ffe9:76a with SMTP id l22-20020a056a0016d6b029032affe9076amr35205366pfc.60.1628698099350;
        Wed, 11 Aug 2021 09:08:19 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id t8sm7297513pja.41.2021.08.11.09.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:08:18 -0700 (PDT)
Date:   Wed, 11 Aug 2021 09:08:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, haliu@redhat.com
Subject: Re: [PATCH iproute2] lib: bpf_glue: remove useless assignment
Message-ID: <20210811090815.0a6363db@hermes.local>
In-Reply-To: <YROUi1WhHneQR/qz@renaissance-vector>
References: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
        <20210810200048.27099697@hermes.local>
        <YROUi1WhHneQR/qz@renaissance-vector>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 11:12:43 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Tue, Aug 10, 2021 at 08:00:48PM -0700, Stephen Hemminger wrote:
> > On Sat,  7 Aug 2021 18:58:02 +0200
> > Andrea Claudi <aclaudi@redhat.com> wrote:
> >   
> > > -	while ((s = fgets(buf, sizeof(buf), fp)) != NULL) {
> > > +	while (fgets(buf, sizeof(buf), fp) != NULL) {
> > >  		if ((s = strstr(buf, "libbpf.so.")) != NULL) {  
> > 
> > Ok. but it would be good to get rid of the unnecessary assignment in conditional as well.
> >   
> Hi Stephen,
> That's not unnecessary, s is used as the second parameter in the following strncpy().
> 


It is bad style in C to do assignment in a conditional.
It causes errors, and is not anymore efficient.

