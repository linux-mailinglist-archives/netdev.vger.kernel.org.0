Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D28D100F72
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKRXgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:36:23 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33162 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfKRXgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 18:36:23 -0500
Received: by mail-lj1-f194.google.com with SMTP id t5so21082170ljk.0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 15:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Qmoi2yAGqAvPpdrYm/kV/N3qOxyhtGgGOyHZAdgiWl4=;
        b=qMiVMcI+a3HGnNkJ8+5EhPAsN0WpgPnZBOpnyU31PhDrNM4aWo4bPCAkV6Ufv8jYOn
         u2mfiSyv7QlAy2sFuLe8/IXgemSCDtSVMQ7W6Eh8dbJVpj5vBV726rBphd0tcBY3Of6u
         1WtP1VloIpwvADTeWEOclqewvkT0ku9ZdrXcb1bnEiy9UEb3bgB4oM8f9mfX29wKyvrL
         Qk/79qfGkgWu3aI+fFyaCOnOxYP6XOSwMSofJOQfIimy/4kjCQyps78hDed44GlxpX3z
         cMLuw8cwThJ4JaHDPqfBAMOTZ1Lci250tRwAHKpXWyQ+KNKFR1AyhNKL+iaCZfI2siqk
         Dt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Qmoi2yAGqAvPpdrYm/kV/N3qOxyhtGgGOyHZAdgiWl4=;
        b=HBwwWlKxD/V9BCezLn5G5/TGa8xUs0iq0Q3v/YcxPJUC5XPb34Dg1Ygxc89TyCLSjj
         5RXdIPn4iNVCkvYBXnZphobPzNi58OuZYcdL45YiYb0u90IbP+H6dimA5+U8BW/xBRIm
         RREaYgKFaXNifle9ezAWtluLu30OUoJYW+1xdMYDnAF44ehkxoL4E0VwM1bjz+fH8GHE
         6mFNpU/318h3XUjBngW10pbghMLW2ffQkLWx/HyJuE4tQ1GGbLQzMo/4CWodxOTk4+DI
         Bw4Cb2EFGD1WQD4E7UYR3eHXyJ0WfC7UYZY0JnXvPLriDOwFk4SRPfEk9CP5lc0oX+2I
         NNdQ==
X-Gm-Message-State: APjAAAVPBmFebaVeWn2LIReGy5KQgtcWdnrJWq0ZFqiKGY781qpEf800
        ITntLdAzXlHyUkixzOWSnGhmWw==
X-Google-Smtp-Source: APXvYqxZaVqzVHMmv9Ir2wg3vnUmLucwtT8iPgxpll0D3WgGNVolcet4xyHDi25rLxFCHPVZwhJ5Tw==
X-Received: by 2002:a2e:91d5:: with SMTP id u21mr1470554ljg.32.1574120179051;
        Mon, 18 Nov 2019 15:36:19 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g23sm10574641ljn.63.2019.11.18.15.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 15:36:18 -0800 (PST)
Date:   Mon, 18 Nov 2019 15:36:06 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v4 2/3] cxgb4: check rule prio conflicts before
 offload
Message-ID: <20191118153606.27aa9863@cakuba.netronome.com>
In-Reply-To: <f93ecd0a1607d3eebdbf3f9738abef7d8166eba0.1574089391.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
        <f93ecd0a1607d3eebdbf3f9738abef7d8166eba0.1574089391.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rahul!

Please remember to CC people who have you feedback to make sure we
don't miss the next version of the set.

On Mon, 18 Nov 2019 22:30:18 +0530, Rahul Lakkireddy wrote:
> Only offload rule if it satisfies following conditions:
> 1. The immediate previous rule has priority < current rule's priority.
> 2. The immediate next rule has priority > current rule's priority.

Hm, the strict comparison here looks suspicious.

The most common use case for flower is to insert many non-conflicting
rules (different keys) at the same priority. From looking at this
description and the code:

+	if ((prev_fe->valid && prio < prev_fe->fs.tc_prio) ||
+	    (next_fe->valid && prio > next_fe->fs.tc_prio))
+		valid = false;

I get the feeling that either you haven't tested flower well or these
->valid flags are unreliable?

> Also rework free entry fetch logic to search from end of TCAM, instead
> of beginning, because higher indices have lower priority than lower
> indices. This is similar to how TC auto generates priority values.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> ---
> v4:
> - Patch added in this version.

FWIW in the networking world we like the version history to be included
in the commit message, i.e. above the --- lines. It's useful
information.
