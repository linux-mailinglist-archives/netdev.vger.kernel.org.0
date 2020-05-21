Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18401DC8ED
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 10:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgEUImk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 04:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbgEUImj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 04:42:39 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4FC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 01:42:39 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l21so7849870eji.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 01:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=khKa3VospsGF/zZX2jqzC6B0pFc8OmygKNEDOR+IIDs=;
        b=Wm8lXXMowUblSGIk6/pirZc6GcIOfnLyEBXmgX4cZtvkuC21pO/JvKHEK/tsjsBynd
         qMtn41/nHj55SyL4CM4D0LMOMrOCZ4dHNppjKdKjOw1VOMHAjdaKI06vUEGJlEJ85Oj+
         XVuH8U2sNqYhVGlRE/RsuXUIaB9auvZ1dey7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khKa3VospsGF/zZX2jqzC6B0pFc8OmygKNEDOR+IIDs=;
        b=jyf3lzNdL4QTK2733bwhc6kV8EutjpkzvhLGs5kWDg9icFIHycHRt8iyBurn12K7/1
         hWUlc567uvmkOIRN0FNu+o9UXA9RdIO0veQ5wjlnlFzN0/1J52WPlaVNvAgfDl+4xjND
         5/8KkkmcJnfJMXSxA6cXEMpiWwMCmBVDG+MSsGbh20HsQ61j7lXu8spjYMlMXdxLJp9h
         hPoeAUEPmfd6KU2HUK8gR44FwGQtz0XE4a30pVR88crFBlQTSzs9xnWnyxzvdTZNYNQx
         IO/HnnAFJ3G/ufmsLpv9IuPPXuByQko1K+f/cIseKYTIPhjsV+9DND7emiabcri6BNPH
         Xl8A==
X-Gm-Message-State: AOAM5331T0pdDFtE3pPFD3D18obEHQ51k4y46jIqYXz0GjtNMS/pC2nz
        /kXB6RwI+6O4tVS3hqZQKlADPg==
X-Google-Smtp-Source: ABdhPJx+XOrTFqKgizJY4KIkfc8KjvyzF63/6kJQz1+A7w5KHL1aNfOwXBebe+U2tody6dumUg2S4w==
X-Received: by 2002:a17:906:fa84:: with SMTP id lt4mr2681695ejb.318.1590050557722;
        Thu, 21 May 2020 01:42:37 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id nj6sm4149437ejb.99.2020.05.21.01.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 01:42:37 -0700 (PDT)
Date:   Thu, 21 May 2020 10:42:14 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Petar Penkov <ppenkov@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf] flow_dissector: Drop BPF flow dissector prog ref on
 netns cleanup
Message-ID: <20200521104214.6a1a4f9c@toad>
In-Reply-To: <20200520174000.GA49942@google.com>
References: <20200520172258.551075-1-jakub@cloudflare.com>
        <20200520174000.GA49942@google.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 10:40:00 -0700
sdf@google.com wrote:

> > +static void __net_exit flow_dissector_pernet_pre_exit(struct net *net)
> > +{
> > +	struct bpf_prog *attached;
> > +
> > +	/* We don't lock the update-side because there are no
> > +	 * references left to this netns when we get called. Hence
> > +	 * there can be no attach/detach in progress.
> > +	 */
> > +	rcu_read_lock();
> > +	attached = rcu_dereference(net->flow_dissector_prog);
> > +	if (attached) {
> > +		RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
> > +		bpf_prog_put(attached);
> > +	}
> > +	rcu_read_unlock();
> > +}  
> I wonder, should we instead refactor existing
> skb_flow_dissector_bpf_prog_detach to accept netns (instead of attr)
> can call that here? Instead of reimplementing it (I don't think we
> care about mutex lock/unlock efficiency here?). Thoughts?

I wanted to be nice to container-heavy workloads where network
namespaces get torn down frequently and in parallel and avoid
locking a global mutex. OTOH we already do it today, for instance in
devlink pre_exit callback.

In our case I think there is a way to have the cake and it eat too:

https://lore.kernel.org/bpf/20200521083435.560256-1-jakub@cloudflare.com/

Thanks for reviewing it,
-jkbs
