Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD9134A906
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhCZNwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCZNvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 09:51:53 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0582C0613AA;
        Fri, 26 Mar 2021 06:51:52 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id g8so2943311qvx.1;
        Fri, 26 Mar 2021 06:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=b0CiRMY941uzWEOm2V2nllzUFX6+uutSdpEYBUThiQc=;
        b=sxB47fBq2T9tGROGzMHdyYDLFNgGQHvy44Vpctkki/CZoKl6WtF/m1I8h/MSkHEntJ
         AO0Ug3UtrsNPyqGoW45wM3VmZYhJ6UENb3MiSFYfKyQoHh1hR5KZGwC0zhYUlY8E/ugJ
         qIzJ+z7M6TD0N96C966yAJla9V7UExxzAl40XMbov4eEpXatRtVjgO63M4lZp6CWJA1W
         iHLCvX0YL/IJRfCO5lcnbeG5YrBlOmFPwfrPZR+m2FcWHVHXbhnMwoElUH4NmRgZ4zyl
         HKuKHwpabL8r2Sxc3P0GxM6tiI4BWUopoEqpbC9Z5GFiTaYPOdWiMJ1sv4A6O2UOLezi
         q+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b0CiRMY941uzWEOm2V2nllzUFX6+uutSdpEYBUThiQc=;
        b=nsWSXFykhUBGp9ZsWUvohFU9rRL8uz37e15UsBl4xRYHL6k3ABSz7l2YE/ERSP7PXQ
         1h4zfxxFgS4ZXKpIYf+El3bKCsjkb2urynaMrZY3nYttraayQ+1K+nrA7D7gNP2CHuPJ
         mdsKkfx18GIDBJUF4FqwMFnLOWId7UJWvvfa4rf4+UZ/I9cG85CcHl923TwyaUCalvZm
         ZsvJXizqUjKwNUy4VxcbN9M8o/5gpPVdq1HdKHTLeuYNQsv1tpYoq0DyHhY/KFCYF9Oe
         fi7GBcnlkRYzjvYHwlAwNsXL+zuPL1QnkFJETfP7oDLahpurE+bIBkjGLX5RCpQCqzhs
         lJRA==
X-Gm-Message-State: AOAM533ZfJ7AQw4qxFqW+K1ueY5mUBX2v+JmhteIGyojb9tVqA97QBFT
        9JHCh26iskLklfwpnbh98A0XYjvPfJ3Qmg==
X-Google-Smtp-Source: ABdhPJya1ke0n9ds5ZXa6D/drabtX8zLi0K9jdprfrRXP48PCPkSBt/4veZ6iggIawl9/oAMaAvFQg==
X-Received: by 2002:ad4:50c7:: with SMTP id e7mr13218420qvq.58.1616766712041;
        Fri, 26 Mar 2021 06:51:52 -0700 (PDT)
Received: from horizon.localdomain ([177.220.174.136])
        by smtp.gmail.com with ESMTPSA id i17sm5942930qtr.33.2021.03.26.06.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 06:51:51 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 284C5C07AE; Fri, 26 Mar 2021 10:51:49 -0300 (-03)
Date:   Fri, 26 Mar 2021 10:51:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <YF3m9Xt3DosPr36e@horizon.localdomain>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia>
 <YFjdb7DveNOolSTr@horizon.localdomain>
 <20210324013810.GA5861@salvia>
 <6173dd63-7769-e4a1-f796-889802b0a898@nvidia.com>
 <YFutK3Mn+h5OWNXe@horizon.localdomain>
 <b89d8340-ca1c-1424-bbaa-0e85d37a84bb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b89d8340-ca1c-1424-bbaa-0e85d37a84bb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 10:46:12AM +0200, Oz Shlomo wrote:
> Hi Marcelo,
> 
> On 3/24/2021 11:20 PM, Marcelo Ricardo Leitner wrote:
> > Maybe I'm just missing it but I'm not seeing how removals would only
> > happen after the entry is actually offloaded. As in, if the add queue
> > is very long, and the datapath see a FIN, seems the next gc iteration
> > could try to remove it before it's actually offloaded. I think this is
> > what Pablo meant on his original reply here too, then his idea on
> > having add/del to work with the same queue.
> > 
> 
> The work item will not be allocated if the hw offload is pending.
> 
> nf_flow_offload_work_alloc()
> 	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
> 		return NULL;

Ahá! Right, and with that there can only be 1 flow_offload_work for a
flow at a time, so it can't fetch stats for a flow that is still to be
offloaded too. Got it.

Thanks,
Marcelo
