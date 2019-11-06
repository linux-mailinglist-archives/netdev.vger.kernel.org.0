Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3252CF1171
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfKFIvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:51:40 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40975 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfKFIvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:51:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so24683741wrm.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 00:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tMI+uyADeuaQY+vhqwW6B68TWxqNPN066tTFYjJHa5A=;
        b=rcStTffRbGoQt3vf9nRzkdGpIHs+hHfr9wH3N7X3c4lVDlN29Q4QsyKdGUZgSoQTgK
         h3IIhECXsCp7mfInQyEnCT9l8d7H/RGLvifjYjNb6+2FrN/963DBvt6zVNORLJCogz6n
         gmgMT72MjgcbXlNtUE3hbOSsmJ9uBlY9mWPtVyLt0qxJVwP/K3arRbeBg9V2ukyO20vh
         2sr6ynNEmvrK4DlXv+p/GxkXC7BpWATS6pYyWt6bqZtPW9zOnS9S2qadPMx3Z5attA7f
         jD9Vy7X8GDRN8/gkrKfIO91B/vgTixpjH3pOX450RIUSmOymp7QhpAK0ZjBFdg7VpSMu
         jjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tMI+uyADeuaQY+vhqwW6B68TWxqNPN066tTFYjJHa5A=;
        b=lQYfXwxUZrPVlW2gaYAq8lO7cQaOPmpQTlQ8MJRNvEbov0nSRAThPibNI/zHiy9nqx
         uyg6JMr6GXH1m5pXa+mW2etGdbYCSy+n7/H/Wd73mvqjlbhiVFgTrZPmPbtJ9u2AbqJw
         hsB4dIQ1BZUy3K7fFDdrbx33jiFXi5HD3IzFW6QUuyQTAn6np7N+sP5pr554QqvDbonB
         17NeG4pG6pX1vmE1PSerTz34KUAWV6A9ufiHY1W93v+GsWvPGYP1vWEcfM1sHaG4z1Sx
         jdDyyWQUn3Hf6U/N2qLHhrZqDS3RZuxcEfu1RdkCqaBkCTVMM61XSL6AewdQ+TrBzr5B
         SG0w==
X-Gm-Message-State: APjAAAUu6scrrMiidV9zUetv8GFbwVGw8G2xMSzIEqG2HiKk1DgX/ZGe
        3bLfnrEV2EqmAWn9/VpD6ume4g==
X-Google-Smtp-Source: APXvYqxEeMHPVVTMfbfjil4o4rO6SAibC/pqHWnNnnbAwXjGIAuF1h+tZnI8PW4iduk7gHXXUhU6Qw==
X-Received: by 2002:adf:ee10:: with SMTP id y16mr1474849wrn.67.1573030298251;
        Wed, 06 Nov 2019 00:51:38 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id a11sm2040016wmh.40.2019.11.06.00.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:51:37 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:51:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH iproute2-next 1/3] devlink: fix referencing namespace by
 PID
Message-ID: <20191106085137.GC2112@nanopsycho>
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
 <20191105211707.10300-2-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105211707.10300-2-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:17:05PM CET, jakub.kicinski@netronome.com wrote:
>netns parameter for devlink reload is supposed to take PID
>as well as string name. However, the PID parsing has two
>bugs:
> - the opts->netns member is unsigned so the < 0
>   condition is always false;
> - the parameter list is not rewinded after parsing as
>   a name, so parsing as a pid uses the wrong argument.
>
>Fixes: 08e8e1ca3e05 ("devlink: extend reload command to add support for network namespace change")
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks for fixing this.
