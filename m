Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BD6318E95
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 16:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhBKP3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:29:40 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:33562 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhBKPYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:24:53 -0500
Received: by mail-wr1-f50.google.com with SMTP id 7so4601782wrz.0;
        Thu, 11 Feb 2021 07:24:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r73cmlC1j2cHDWraNmDzLtHimsKfOTe23uRKBUQvTXY=;
        b=RZQN5nMovh/qjggaZkLfWtEGAYH+4Hhxg+uE++JXkd71lRZPbj7QwqaUMeRscBeDwu
         FfEvBKXTDVnQ7SfEzgjIU+vFYVxLbPvPoMbsk2ur2J0MyJj2jT3dn4TvZirSpjGP4yQ+
         Qbf4eJUqBls4KnpkkwUNT/Ted3iluR2MiZV9Pf64V3DYq03QvBjLcFRd5GvCzhHucLse
         zmKC5DZYOxPI8uLW18nTWk4yeW6u3OEY64cU7nwFcod1R72uMEbdT1D1CqRBy17JcFhe
         RwIjoeGHYYVz3N3A6wIgrIIGfyu4TUefYr3JFHNMHPCPt8Ns0qd+x0eyTuRTJYV3SuFN
         oogQ==
X-Gm-Message-State: AOAM532+FqK66rpCooZ0PxjDbQsxyGHnJAQns+nx0gIEsSwl5j3mSBWT
        3hNwiAGEc90IszEX63AbKY8XW7Ihx3Y=
X-Google-Smtp-Source: ABdhPJw0ZNLx6cIm1oi5TPu/ZBGpav6tW7wPmN3XoUi4E90WuF9Eo8rynhy/JWMbDVpCiMzyDv1snA==
X-Received: by 2002:adf:9bcf:: with SMTP id e15mr6042718wrc.276.1613057051742;
        Thu, 11 Feb 2021 07:24:11 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id c5sm5469871wrn.77.2021.02.11.07.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 07:24:11 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:24:09 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 4/8] xen/netback: fix spurious event detection for
 common event case
Message-ID: <20210211152409.knullq66jv3bkis2@liuwe-devbox-debian-v2>
References: <20210211101616.13788-1-jgross@suse.com>
 <20210211101616.13788-5-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211101616.13788-5-jgross@suse.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:16:12AM +0100, Juergen Gross wrote:
> In case of a common event for rx and tx queue the event should be
> regarded to be spurious if no rx and no tx requests are pending.
> 
> Unfortunately the condition for testing that is wrong causing to
> decide a event being spurious if no rx OR no tx requests are
> pending.
> 
> Fix that plus using local variables for rx/tx pending indicators in
> order to split function calls and if condition.
> 
> Fixes: 23025393dbeb3b ("xen/netback: use lateeoi irq binding")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Wei Liu <wl@xen.org>
