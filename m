Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7746CD534C
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 01:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfJLX1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 19:27:24 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:40001 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJLX1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 19:27:24 -0400
Received: by mail-pf1-f169.google.com with SMTP id x127so8224770pfb.7
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 16:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FhaLNSVkBA6Nck+9rg3UHafkeRh3UXEbIF9NNJwBTb4=;
        b=KQ3vtW1SBtGdmJAOXEKaPbq1v95F3Ed/n2zn+IlDUsq0heGp3PJ/TImZ4eEHYOxe1G
         5I/m+cpHOT2T/NvVHyvGD/BBpJGfZmJNvOWXcutPR9rQoPKJjgGVIV2yc/CbPrrM4ds1
         7B+vBPThV80F6RgfeljEhzZSynI0ZWP2Krh2573qqHZyXwtDXyl4PDljDN9uv86BOMIw
         7zyAyFVu8UtNCQpkxaz9I9UyaZx0tXfogsIelCEm4NHV/KbEKW2MNtPesHqAMKaRl90d
         GOfQWUnyF56rzvwlAkUzpJaSOjagc13zSyy/lWoMhCI+KZTMPp/sEKOc598nPb39ay+q
         /Ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FhaLNSVkBA6Nck+9rg3UHafkeRh3UXEbIF9NNJwBTb4=;
        b=taHXlilqSpihhlmjkR3ixHGkTdzk3enUnseSqbLawk7utG4FaIiTYv6b6B/LrnmKMC
         wbnAOueuQoWeYpQAhVVy0Q9fY3Mja5vPciNuRDNgDsSDV84FYsliuxCWAqAgakXE6D5z
         zzH1dEjx61paF0Uz1/TqfyfZWSVlrzF9M04f7tf3netqxPkvACfmHiZLo1YeZK/uxTNl
         jJpqQosrV48YnXkqejPHDdD5Lw3HY90Iradg/igcS9cXwXiGiGk9dvsG8TkS8uvtwjyy
         FDgn34nyduBASAOoKKdLYZGqEIsYtWN6rOdzLxGbz05Z4wtQ9+eh6JQmB5cYYbezTf7B
         KGMg==
X-Gm-Message-State: APjAAAX4s8a6OVTLUQdjz4TSkPNYVcvHsQ57WOCJOlb1sOi7AFM6wpw8
        OloXRCwKt2duOIWNqD9GPNw=
X-Google-Smtp-Source: APXvYqyEQjVxc4JdNjesWZEngUU/ht7ZHaflDjdTUZ46sllGO2CppnqtCzzXm/r724R6DOCKuieWuA==
X-Received: by 2002:a63:1718:: with SMTP id x24mr24409757pgl.180.1570922842191;
        Sat, 12 Oct 2019 16:27:22 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v1sm16651265pjd.22.2019.10.12.16.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 16:27:21 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:27:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Brandon Streiff <brandon.streiff@ni.com>
Subject: Re: [net-next v3 3/7] mv88e6xxx: reject unsupported external
 timestamp flags
Message-ID: <20191012232719.GA7148@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-4-jacob.e.keller@intel.com>
 <20191012182409.GD3165@localhost>
 <02874ECE860811409154E81DA85FBB5896926B0B@ORSMSX121.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB5896926B0B@ORSMSX121.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 07:36:31PM +0000, Keller, Jacob E wrote:
> Right, so in practice, unless it supports both edges, it should reject setting both RISING and FALLING together.

Enforcing that now *could* break existing user space, but I wonder
whether any programs would actually be affected.

Maybe we can add a STRICT flag than requests strict checking.  If user
space uses the "2" ioctl, then we would add this flag before invoking
the driver callback.

Thanks,
Richard
