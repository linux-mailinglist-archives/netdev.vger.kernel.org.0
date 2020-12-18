Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42222DDCA8
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 02:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbgLRBbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 20:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLRBbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 20:31:15 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B8EC061282;
        Thu, 17 Dec 2020 17:30:35 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l200so1145299oig.9;
        Thu, 17 Dec 2020 17:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P3OTeu7kWnFvQqcA3deigdxkkwkznGURwG/tb4r401Y=;
        b=Q+99nG0nv35q9MrE9XBnSCKG9HlWfJDKkO3dlssQE/O9k8weODhO/sATNVFBEneToi
         KKM8txYXChXrW6ixidU6JtqDEvZSibEHd7+b8mGRUlG7JnXlhvZ278L8opZAticJ2FPF
         UzIUWN/iqDFe7n3+ZkvcABvbMYIIbhbgJJGGvDZi6UPIBK2U72nkSCJlqf/+wKFBVAfU
         ftzekCBk6ecB2s4Pu9wnho7Vqtl/tuPupCG29AblctXxRWE8E/PGi6XYtZitGMLp9iva
         zzfdZy1AiAzD5ZPWfRVyy+CgxFLk4ra5K23SGT/HTaZbrcSZqbz2gfQgD25VWnm4w5Rf
         f1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P3OTeu7kWnFvQqcA3deigdxkkwkznGURwG/tb4r401Y=;
        b=NwHf8EY+8LemwbVsC4vm2XT0BIhP8v+yj57y7Wo1yobXantxC/bvuMy3LOFowykDJa
         KQP+PWHfjGiP8XO6AwB6PZ19i89wqEdHhOZpLZbmM+uccjqeR0+HSK5m4UmOG59qCUpd
         MsyLYB7pKOFcgTdMc0Fj9fkY9dXqM3BkBEN1jlooRawTME1fET/ZqIvntGysFIJCxdRT
         0IdS07656haPXqZdhvMxjuzcszAmp/kJcupiyTjV0wJdDLnSsYbQ59D9uIAeeHPDWmAj
         qe7vRbqrtH5hHXWY9ZsAb+GTYgpC5i5UMvUJPORi2nQxuc6K52mpMNCnQBolQK9cJcsH
         5Hvg==
X-Gm-Message-State: AOAM530C81HSj5aHqprER3ZK7tA9mzTS3TFSB6zCDMJlDiodQe2Kk3kb
        ohY+x6sXtL2FAvdtYBtkWG4=
X-Google-Smtp-Source: ABdhPJyNh0NjW3II/BpiruwzC0EAVxEhG2D1LeEP4uxUmk91oXbYi8d4fmgthaFQovzyHVDvgIr4hg==
X-Received: by 2002:aca:c6d7:: with SMTP id w206mr1310540oif.76.1608255035083;
        Thu, 17 Dec 2020 17:30:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id x20sm1621479oov.33.2020.12.17.17.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 17:30:34 -0800 (PST)
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
Date:   Thu, 17 Dec 2020 18:30:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/20 3:53 PM, Alexander Duyck wrote:
> The problem in my case was based on a past experience where east-west
> traffic became a problem and it was easily shown that bypassing the
> NIC for traffic was significantly faster.

If a deployment expects a lot of east-west traffic *within a host* why
is it using hardware based isolation like a VF. That is a side effect of
a design choice that is remedied by other options.
