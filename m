Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A81B295569
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507388AbgJVALM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442449AbgJVALM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 20:11:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AE6C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 17:11:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id az3so16176pjb.4
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 17:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sd8F01A0fjP3MYfcQsz+f0VIbN1tvxRub+s7hVzqnU0=;
        b=JGNw9vojYWmsRXXisF4hvBMgdaMVJXGA3ZhExfLR1POvOX/F1H8FBck6vgGetpc4lF
         svC6o/lpMWFO4dMDlFLHCC9xIKTKtRTOMIisRbET43lSaNedRnS3996oavGz+z/1FX2J
         sGXvIdb132Up+LEJV5+sXFru/2pUMdxbe+P8GHC7fKlKkpsmAt1HcEyXrGid5YNRiR7Q
         19zsUBYmPylYIqQbaC472A00GiI+GJQWIWk3hC5Povbg8xYk9LZdk7D8OfJy40QTwWkH
         qM7MBccsCtSWUGREOaqJU56BjlxTbEd7UQ19tRA6re3P36i/zLO4SOfHOELhSfjr77P1
         WOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sd8F01A0fjP3MYfcQsz+f0VIbN1tvxRub+s7hVzqnU0=;
        b=hEYrzhp9L1wkGXV492GJ+mdFF8xBIXzw8ygGdrltNCvmhcT8d/jhzztajz1D5ocAvf
         nygI7GmmrQIvq2v7jK6pFgKB3X37NnTwesEKsqclfn7SUzVXhG1xiGDP6+3OUA90Mm/K
         vLx1on6A0tNwZhFpprdQaEMaNT320CKRgnjhlpI9i40UiR/w4agg+L9yr2D2XUfqJ7mM
         8FtAD0lzlOCq+EDJyewW7Wjzx21+DZzMsmhLgYH9Kb0qm35DGRr5kSsIZPyZuPH6T52/
         ilYBt7XKLQd81FaDEcagBgDPMvCE2Sv/NLJBrKSZKFs1sag0W8PhcQrnP4k3bkL+0yW6
         BrBg==
X-Gm-Message-State: AOAM533TcCm07PNmhErwBSe2clVa//DMIsIcceKFON/x+Cw3Y5wmdRy+
        If+oUZbQpLd0jJGuBJxJ40LnaA==
X-Google-Smtp-Source: ABdhPJyj9tkg2BA4Hw+lTrzdP4Fe1UAxLlFf6pV3hmR/H2HHK1rRSy8kP6yBHtGAuGpJalKH0002Wg==
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr98185pjj.101.1603325470046;
        Wed, 21 Oct 2020 17:11:10 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v3sm3014735pfu.165.2020.10.21.17.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 17:11:09 -0700 (PDT)
Date:   Wed, 21 Oct 2020 17:11:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dsahern@gmail.com, john.fastabend@gmail.com, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 15/15] dcb: Add a subtool for the DCB ETS
 object
Message-ID: <20201021171101.60a7bd38@hermes.local>
In-Reply-To: <873627jg2d.fsf@nvidia.com>
References: <20201020114141.53391942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877drkk4qu.fsf@nvidia.com>
        <20201021112838.3026a648@hermes.local>
        <873627jg2d.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 01:48:58 +0200
Petr Machata <me@pmachata.org> wrote:

> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
> > On Tue, 20 Oct 2020 22:43:37 +0200
> > Petr Machata <me@pmachata.org> wrote:
> >  
> >> Jakub Kicinski <kuba@kernel.org> writes:
> >>  
> >> > On Tue, 20 Oct 2020 02:58:23 +0200 Petr Machata wrote:  
> >> >> +static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets *ets)
> >> >> +{
> >> >> +	print_string(PRINT_ANY, "cbs", "cbs %s ", ets->cbs ? "on" : "off");
> >> >> +}  
> >> >
> >> > I'd personally lean in the direction ethtool is taking and try to limit
> >> > string values in json output as much as possible. This would be a good
> >> > fit for bool.  
> >>
> >> Yep, makes sense. The value is not user-toggleable, so the on / off
> >> there is just arbitrary.
> >>
> >> I'll consider it for "willing" as well. That one is user-toggleable, and
> >> the "on" / "off" makes sense for consistency with the command line. But
> >> that doesn't mean it can't be a boolean in JSON.  
> >
> > There are three ways of representing a boolean. You chose the worst.
> > Option 1: is to use a json null value to indicate presence.
> >       this works well for a flag.
> > Option 2: is to use json bool.
> > 	this looks awkward in non-json output
> > Option 3: is to use a string
> >      	but this makes the string output something harder to consume
> > 	in json.  
> 
> What seems to be used commonly for these on/off toggles is the following
> pattern:
> 
> 	print_string(PRINT_FP, NULL, "willing %s ", ets->willing ? "on" : "off");
> 	print_bool(PRINT_JSON, "willing", NULL, true);
> 
> That way the JSON output is easy to query and the FP output is obvious
> and compatible with the command line. Does that work for you?

Yes, that is hybrid, maybe it should be a helper function?
