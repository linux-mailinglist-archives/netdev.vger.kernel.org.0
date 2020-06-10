Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93F31F5D5F
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgFJUso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgFJUsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 16:48:43 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11124C03E96F
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:48:43 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c17so4220476lji.11
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkhkcPvpAeE4x4kAO1HjblduVWOEiZ+eHHO4eca07FY=;
        b=IgN05Fh0uREALZZU/s8t66dRm0ApTxlnvcL6Nnx/SwIGy9zTKN1m9HDCNywJFvcZ2U
         1xEVjk51dwqTD6l0sgKb+Vtjqr4s6SbTFzUJ0kDAKBXdGB7diNzJzQphVdL+BPgjm0Ga
         CNO9Wx8KMuwTuBeK1fJ+X3/7/j11L4DzwfyzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wkhkcPvpAeE4x4kAO1HjblduVWOEiZ+eHHO4eca07FY=;
        b=lHqCsV8r9I7tj/vGdDVkDq054xykdhmdG5WMznCQ5b7Ey5VB988jjlcONoVMCiOdx+
         ysu86DR870V8s7TI2m2KQTeERHncbe+NgkhEetY2aZZoQysS9lnrus0dfr+DwSgTIZJq
         gSu0rvDN6y20pS/OnFb/Ny0GJGOgMP79B/bfO017E0XNfuFP3hY/WT13NyaDE7dvjQlz
         EhO7SWBIf5IRvfCh8UcPEpK7au3gvJUy5/H+9XWohFy3eUt5zZq5akSCPrT0O8nsj3yx
         f3ZnhR5aMr84hQWJ74xgpsqqlMC/yXSL60lG7VWpAYQJDPn5k/d2RT+qHIArmCBFglbD
         nJig==
X-Gm-Message-State: AOAM533Qc/NQ8EoZYJP8zdj4uRKxFdBn8D09phgyANNX6Ax8OCptDBkJ
        5Yv7xBhOPg5pBena7MxcF3haulmpZx4=
X-Google-Smtp-Source: ABdhPJz4qKmA1Ca0rKL3fhwteXDLAp+5Zmvi2eFO7rnZHp2LPJaE9guU7ZsQ7CQJppHilWAfhxrSVw==
X-Received: by 2002:a05:651c:547:: with SMTP id q7mr2455752ljp.437.1591822120840;
        Wed, 10 Jun 2020 13:48:40 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id p68sm199956lfa.71.2020.06.10.13.48.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 13:48:39 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id x18so4255982lji.1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:48:38 -0700 (PDT)
X-Received: by 2002:a2e:b5d7:: with SMTP id g23mr2510079ljn.70.1591822118508;
 Wed, 10 Jun 2020 13:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200610004455-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200610004455-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Jun 2020 13:48:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiyR6X=SkHXMM3BWcePBryF4pmBNYMFWAnz5CfZwAp_Wg@mail.gmail.com>
Message-ID: <CAHk-=wiyR6X=SkHXMM3BWcePBryF4pmBNYMFWAnz5CfZwAp_Wg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features, fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        anshuman.khandual@arm.com, anthony.yznaga@oracle.com,
        arei.gonglei@huawei.com, Qian Cai <cai@lca.pw>,
        clabbe@baylibre.com, Dan Williams <dan.j.williams@intel.com>,
        David Miller <davem@davemloft.net>,
        David Hildenbrand <david@redhat.com>, dyoung@redhat.com,
        Markus Elfring <elfring@users.sourceforge.net>,
        Alexander Potapenko <glider@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        guennadi.liakhovetski@linux.intel.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, hulkci@huawei.com,
        imammedo@redhat.com, Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, kernelfans@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>, lingshan.zhu@intel.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel test robot <lkp@intel.com>, longpeng2@huawei.com,
        matej.genci@nutanix.com, Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, osalvador@suse.com,
        Oscar Salvador <osalvador@suse.de>,
        pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com,
        Pasha Tatashin <pavel.tatashin@microsoft.com>,
        Rafael Wysocki <rafael@kernel.org>,
        Wei Yang <richard.weiyang@gmail.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        stable <stable@vger.kernel.org>, stefanha@redhat.com,
        teawaterz@linux.alibaba.com, Vlastimil Babka <vbabka@suse.cz>,
        zou_wei@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 9:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   I also upgraded the machine I used to sign
> the tag (didn't change the key) - hope the signature is still ok. If not
> pls let me know!

All looks normal as far as I can tell,

                Linus
