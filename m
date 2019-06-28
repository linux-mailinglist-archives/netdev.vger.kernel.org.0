Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE95A5FD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfF1Ul1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:41:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37727 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbfF1Ul1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:41:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id y57so7857029qtk.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2o95IpzpIGuE7bNPijU9yPvgn6IPI6eywNRjn6aZsq8=;
        b=fWpMtCjIwnMn680IU/FH/Kt4UP7ixPUBX06DDcxD5XAjRRrkE8hpkT21WidzsaiqQw
         AkysVt7i/iltK+Ssg6vA0/TBHvolg73zLP280aufwNd7mzj0n0/U/+QY2EP1Ii311x/u
         wPzInot9suts7kl7RwoPt0HMSMi53AjwPkARQjWK5Vbk2uazQx1Z4yq6meQXb1v3+Yog
         +/2htHMETIGrczcoj+BJeU9XG+D7We7CzlMiJvULd0oSsvtilSzOpeAfdp2rH+ri1Fnf
         IwiYkuWwCtZKER9L43W7A8yPsaG+2mDoJ9Yss+r2xbe4PMiAnTIm2fDQai0LEK8rtEBC
         Ip6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2o95IpzpIGuE7bNPijU9yPvgn6IPI6eywNRjn6aZsq8=;
        b=SwabiE+2NmV6yhho2TnMhRAGXbZSCTUoZj8QLqh0M8iOHa8TRirbnu1DMKw9nWUj4n
         IbIlxQNQpZ8QAQhUuirId8kb5Bc67wPMHYcfejLgJuw2/R1HTRQVbzKD/57XwnOAaF16
         nf4apYKdxZEWlTxd+3GJOwiQSsF7qDtDhqGWXmA5BJkNBMuAXEBQ5n8QVB1kms1w22FC
         KPCS6CsmAJVMHSGSD4nTKjdFp9RyIoT82S0W4aB73uUdeabmRRclVkh6UqHCIgqC0icZ
         kVqOxIK5UCK9Rwz2EAEX9FBqI2R7UgOqdyIituPAtpaQwSGBOQOw4ObQjH3bfcPGpXQZ
         cohA==
X-Gm-Message-State: APjAAAUTWwPO+k8C3VRLeQs02WDbe+GdiUn9mudBVNGVxbspGveeRCOL
        10mbRcoV7KYNWTyR5ZRT4dWS/w==
X-Google-Smtp-Source: APXvYqzKqRHYKyU4u9kTpFUbiOjzjd3rBW5086TwVrTUDD/eLndtHf18ZMDzPg6ZYQ0SF151jnAiNw==
X-Received: by 2002:ac8:384c:: with SMTP id r12mr9806455qtb.153.1561754486307;
        Fri, 28 Jun 2019 13:41:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d31sm1565725qta.39.2019.06.28.13.41.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 13:41:26 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:41:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, saeedm@mellanox.com,
        maximmi@mellanox.com, brouer@redhat.com, kernel-team@fb.com
Subject: Re: [PATCH 2/6 bpf-next] Clean up xsk reuseq API
Message-ID: <20190628134121.2f54c349@cakuba.netronome.com>
In-Reply-To: <8E97A6A3-2B8D-4E03-960B-8625DA3BA4FF@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
        <20190627220836.2572684-3-jonathan.lemon@gmail.com>
        <20190627153856.1f4d4709@cakuba.netronome.com>
        <8E97A6A3-2B8D-4E03-960B-8625DA3BA4FF@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 19:31:26 -0700, Jonathan Lemon wrote:
> On 27 Jun 2019, at 15:38, Jakub Kicinski wrote:
> 
> > On Thu, 27 Jun 2019 15:08:32 -0700, Jonathan Lemon wrote:  
> >> The reuseq is actually a recycle stack, only accessed from the kernel 
> >> side.
> >> Also, the implementation details of the stack should belong to the 
> >> umem
> >> object, and not exposed to the caller.
> >>
> >> Clean up and rename for consistency in preparation for the next 
> >> patch.
> >>
> >> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> >
> > Prepare/swap is to cater to how drivers should be written - being able
> > to allocate resources independently of those currently used.  Allowing
> > for changing ring sizes and counts on the fly.  This patch makes it
> > harder to write drivers in the way we are encouraging people to.
> >
> > IOW no, please don't do this.  
> 
> The main reason I rewrote this was to provide the same type
> of functionality as realloc() - no need to allocate/initialize a new
> array if the old one would still end up being used.  This would seem
> to be a win for the typical case of having the interface go up/down.
> 
> Perhaps I should have named the function differently?

Perhaps add a helper which calls both parts to help poorly architected
drivers? 
