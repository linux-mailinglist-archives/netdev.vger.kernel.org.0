Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA6181675
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 12:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgCKLCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 07:02:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38968 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCKLCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 07:02:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id f7so1583693wml.4
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 04:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZtivpqmkTte76tM5J7QEOZ03j+A2dVs41BoqPQFxurA=;
        b=J/BLW/vOcQVCqzY1Xp0E0E2dI/ZMXKygNBN1j2N7p+w8j/Tz8l46s5bioe7fSUZGHy
         sYAoAeEJKrK7MEvyzJZjCLzan62SZbKhhmEMzaMhLCfcAmidS0760f01f218DgJx+J4V
         dhJJapWRtFgfMln2pjY8A6gcPTh3qgXT0Qlt+4ATy165VgVITOC7++Tcwfk+HLuuz48d
         hGEOUfvbGNRFpWY+wa7LCWLWF/B+hN70Pw0DWHqH+dM5B9itbjb4kgke3ZbaTuHNQZ1M
         6dEv3LPlOs2KJMWDE8MnnXaltEmwouSWdFo2fPMxQzDSM2Lu5z3CHuBrDCMt+Wz+rw/l
         80tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZtivpqmkTte76tM5J7QEOZ03j+A2dVs41BoqPQFxurA=;
        b=t33x2bRNuhSLoAsHaarTNhCAvLbCCEQvwQ/DQQhiySr5JOiwyF7l1ltvQXh3zpEjTO
         6NSGvyb1Dp0G5HLXrZKs+adn4ckL35vbY4I1EuvXKcMYUgH8RAWijnea6BxvLb0i07xd
         xFh+opk49p6GmeU3Pbe6PsqzEqeF13fzpkSpEaIZ4KNnFSyYpo15SUE1LHEqSOnQ86Oo
         pIa2X9uPsoGWlmtAZViXPG+eIdYErOJStrA7Nr/VKPVD/fj+RGOfhY0WjoCnEUPkEDbJ
         w0hDQsz4PcYU7eppRLEwWJS3WvQFHVr96DA6Ac9ern8vzH4bmqTeGwPiPnX2uQiR+uFn
         W7SQ==
X-Gm-Message-State: ANhLgQ2T2/uiysJzzzksMjWKTASbe6vzQQIBABkNkR0aSTg4WPJXX5km
        H8ron3b+Nr3KgPGxdFh0SzL21A==
X-Google-Smtp-Source: ADFU+vvoSvWN3EHx/mwplyPtCmZaNDmcKAYAdqInltC9ZNpO0nW0+zvqBwt7op+kO0cxTdIqWQWqAw==
X-Received: by 2002:a7b:c24e:: with SMTP id b14mr727916wmj.0.1583924518700;
        Wed, 11 Mar 2020 04:01:58 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id l83sm8153770wmf.43.2020.03.11.04.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:01:55 -0700 (PDT)
Date:   Wed, 11 Mar 2020 12:01:54 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
Subject: Re: [oss-drivers] [PATCH 5/7] ionic: Use scnprintf() for avoiding
 potential buffer overflow
Message-ID: <20200311110153.GB304@netronome.com>
References: <20200311083745.17328-1-tiwai@suse.de>
 <20200311083745.17328-6-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311083745.17328-6-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 09:37:43AM +0100, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: oss-drivers@netronome.com
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

