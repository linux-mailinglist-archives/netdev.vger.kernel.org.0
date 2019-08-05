Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF9C8145F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 10:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfHEIgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 04:36:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40509 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfHEIgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 04:36:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so72145286wmj.5
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 01:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wcX8Ms+eBR5njFsdTaYqDPTlypyRlj8jAxKB1CXuFng=;
        b=hDDgI/D76bo/7bPX2ewajJp1GpcGEkpd0Akx91DEvOl05gMGQlKhmXyBM8e5mcpLl9
         fBZoUTPVaHQr8wfaBDZ6/JC23GEUNcajKQGhWW/30rQIw7CpjQIjyimiFXdTRlXCpeAe
         G6r+9YVt4KYEz2azaAkYK38f8ICLw148oly8T22MvnvIM5xG7n8i5zB6q3trDveQh2o5
         poBplhsr0Ubq9VTag356q5n2bTgzpNj//jmsRIRVgt8cNO9tsD1sOStpeMSLAxHREN6z
         ctV98r+W0TBlRmI/u3zI9qglAR6sScySumABKhAdK53gbsBfVtN5qWsiMrfhGwaH2acP
         wXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wcX8Ms+eBR5njFsdTaYqDPTlypyRlj8jAxKB1CXuFng=;
        b=mx/8gfWjcs9K3ccocdIcejNt3PcruLfAQjBvsN7131/aU2yljPUx0h2fnRGRVHJ8o7
         YbAuBVVU4M+N8lMdLxXlL6KBMHHvLteKxD3KRVKKqJgYD7XLE9y2t4INlreEV15K4RQG
         RtTchpI5VJg6a4QahM4IGrhIP1snV3Kb6OJEpB46pfQEiXVLdgIdS1SWy3VzGuRgQAkI
         s0Q4bDcEIWuid3nNK7Gt+1luKDkEkrGUd71iQNpTsvwqKmAmdziP6y0B48Lm8a3k+OfX
         4Qi0rxfE5vpf0UxacGERT4AktXGS5GVN4uS6/sdl8ZV2xEc8dHIGT1vJehBl34BBjyUm
         CqQg==
X-Gm-Message-State: APjAAAUYZu30qcL9JwVDsfKnLwih2gZZ5FgpQwQ4BFN+HBHqf4zoi00e
        bxO7BOVLP2zbwbEjZskP/IFX9A==
X-Google-Smtp-Source: APXvYqw3nZU+qgoqQFFTZGv0L1r/ogoiNXFs4uUUydyeOI01jBOKc4KOufh9aHaJlBEYnj1pP3fufQ==
X-Received: by 2002:a1c:be11:: with SMTP id o17mr17359663wmf.115.1564994180034;
        Mon, 05 Aug 2019 01:36:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w67sm121270092wma.24.2019.08.05.01.36.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 01:36:19 -0700 (PDT)
Date:   Mon, 5 Aug 2019 10:36:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: Re: [PATCH net-next 1/3,v2] net: sched: use major priority number as
 hardware priority
Message-ID: <20190805083618.GC2349@nanopsycho.orion>
References: <20190802132846.3067-1-pablo@netfilter.org>
 <20190802132846.3067-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802132846.3067-2-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 02, 2019 at 03:28:44PM CEST, pablo@netfilter.org wrote:
>tc transparently maps the software priority number to hardware. Update
>it to pass the major priority which is what most drivers expect. Update
>drivers too so they do not need to lshift the priority field of the
>flow_cls_common_offload object. The stmmac driver is an exception, since
>this code assumes the tc software priority is fine, therefore, lshift it
>just to be conservative.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
