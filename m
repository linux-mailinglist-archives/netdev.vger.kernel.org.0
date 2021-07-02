Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6A3B9A28
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhGBAmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhGBAmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 20:42:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47673C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 17:39:39 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hc16so13395805ejc.12
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 17:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FH/Yexdwghl4Va/I/dL1HXWAhnORk1tKNO1xFcjnG1Y=;
        b=NzYVmdqg8FY6AM2rp+5/Ul94aXTxWUXvYMWlbB4CvwAijuiOFzOhB2OO5wicodGdPW
         d9BadwZw2r9r1zwEr8aBtmEKSJBrSEzgnDfjogesuO6Il8Kow6dU9nMcIhXTM/XqNpVz
         az9M1/BpvZIdwvNDHy9//E4wwKHaC8aSICRLCC36kyfglK9M+X97bTirQTbuUs2nGprO
         AH0/QVemVOPnVczE0SGpuoGsN7kbGNhBsMkW/yXYqkNh0ACVsj882GPcmJ8suu8NIg6V
         v7deqb0sMCcELSdVSdolq9IvGm+2kKeu/MeOJYJERUfL+clebOj7L5nVU5nIXFjLnPpy
         /ckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FH/Yexdwghl4Va/I/dL1HXWAhnORk1tKNO1xFcjnG1Y=;
        b=Bjg9yIP5JHKQOrKs0ZQrmROAKY66w7hwkPr+Wlqu1BYje4sglP1eFTyE19py/5bBDi
         zqxmR4UNcYR/mD+lBHkmIGqtgfMq3+a9atikpcR2u6m9gfgYK7aWrBZivzjTltncJrVy
         WLo1Mj8ziJYeEP94MaGdIkJ9tHz3S/tIKZbTJIV0JrAHp2i1P46eGXR8DHP9ejk0JkDi
         EZscjaF0Cr7OgaE2Im+gOx/XXXCIudBOMcE512Kany6UUbS/Kb7deTBdJzRBAFc3gVBn
         LSUvwCTFxwB1VtdEjSLKTsH+EwKbALm2xYNCFbktt/jj7U8F3jO1TipAWfffWX27bFLo
         AAAg==
X-Gm-Message-State: AOAM531vZAu52gusmWqS0rdfi8MWbbh/sqmMPvWcLgoybBfBYIO1B0Cp
        4mrSVQw/KLak1YWOufVUC+c=
X-Google-Smtp-Source: ABdhPJyPvl/302aeSpGZM6CBavmAzBc+UwGKyg7dvm0V4/xQNudtEnJqStJJUHGTYxjR60G8FxphDw==
X-Received: by 2002:a17:906:7946:: with SMTP id l6mr1097612ejo.216.1625186377729;
        Thu, 01 Jul 2021 17:39:37 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id g3sm462390ejp.2.2021.07.01.17.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 17:39:37 -0700 (PDT)
Date:   Fri, 2 Jul 2021 03:39:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Message-ID: <20210702003936.22m2rz7sajkwusaa@skbuf>
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
 <20210628233835.GB766@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628233835.GB766@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 04:38:35PM -0700, Richard Cochran wrote:
> On Mon, Jun 28, 2021 at 11:25:33AM -0700, Jonathan Lemon wrote:
> > When creating a PTP device, the configuration block allows
> > creation of an associated PPS device.  However, there isn't
> > any way to associate the two devices after creation.
> >
> > Set the PPS cookie, so pps_lookup_dev(ptp) performs correctly.
>
> Setting lookup_cookie is harmless, AFAICT, but I wonder about the use
> case.  The doc for pps_lookup_dev() says,

Harmless you say?

Let's look at the code in a larger context:

 struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 				     struct device *parent)
 {
 	struct ptp_clock *ptp;
 
 	...
 	ptp = kzalloc(...);
 	...
 	ptp->info = info;
 	...
 
 	if (ptp->info->do_aux_work) {
 		...
+		ptp->pps_source->lookup_cookie = ptp;
 	}
 
 	/* Register a new PPS source. */
 	if (info->pps) {
 		struct pps_source_info pps;
 		...
 		ptp->pps_source = pps_register_source(&pps, PTP_PPS_DEFAULTS);
 		...
 	}

Notice anything out of the ordinary?
Like perhaps the fact that ptp->pps_source is an arbitrary NULL pointer
at the time the assignment to ->lookup_cookie is being made, because it
is being created later?

How on earth is this patch supposed to work?
