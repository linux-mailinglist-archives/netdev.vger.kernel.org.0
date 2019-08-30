Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B26A3A94
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfH3PlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:41:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34045 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbfH3PlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:41:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id b24so4912071pfp.1;
        Fri, 30 Aug 2019 08:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=D8WYuwJPEmbhKXQGImoSc/umRvPMZq3miEtQVpPDIyE=;
        b=GLT3KSbOdxNdWEJziOivaaRl9ftjEIOPYOD44fLe1aCmSkZ6nWkisCmIHxoSlt29Ku
         5M0eD7pyoHUDgSoNDxCjFKgH7XNkqn4056s8pBbWz//nmri3+x93Pt9jjQonUeGt43RR
         y3HXgOTLbQZX48fFF5ZWoBKv0a4aXe7tWlZfkBH8KLMSUpUu4wN1Oe+eYsJHJXQ5faXt
         0orVVe26LBuXYDQSS5SbMasmVp4t3HEyaPz3Ojpdh23P0VLYMo6lshczmd/fElIVmLlb
         esccWSy5iFrKIdkRwNmlmIV9bRGjcDWYyxE9t8k0t6D8Ycz9tyunRhdFtmqf0UE0bNbY
         K87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=D8WYuwJPEmbhKXQGImoSc/umRvPMZq3miEtQVpPDIyE=;
        b=p8zXh3vYDIbxXEN75MSjwh3hR49RMOmbU5X1Vkj0qsvyWiWDsulI3KbPku5hm9ue0t
         k1fhjXro09INjaKMugl6AbsjzsRSVC7ZiDKNVxUxQcCLgpHD/0LHfEZNwkJtV8wgw2hu
         yX+TrIa2NysZHyzrJrsGxFUyEyFdWNyjzPJw1vlN1gcyZ8wQ2pepjowLIhN2B4Sq4tJ7
         OFLgXO1gLQydknQLf+CRuDWO8mQYcKZEYt07JX1GLsR+iUzj6GoSqJxcAaTps7xKjcsI
         t7Vg3+A/VlpPM93rSOUDRcr5Or0prDk8tfgo4i4Is+LRLtDFXSFEFz88KxB5ksH7EzHT
         59iw==
X-Gm-Message-State: APjAAAXdO5CHw+/6UxTNqRzQShBGA0GF6DcA+HVLaMWVDMNwVAR4yEfK
        UBHL3Kz8vMJoOVtaIEK990k=
X-Google-Smtp-Source: APXvYqyAHjdLR4jjf4CFBr/fLQGF4SuwhhatOJggl7ZYFDFH/GYHzRC0hg8JaY/uu7v35x+aaGkCsw==
X-Received: by 2002:a63:5f95:: with SMTP id t143mr13449469pgb.304.1567179683260;
        Fri, 30 Aug 2019 08:41:23 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id q4sm6807211pff.183.2019.08.30.08.41.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:41:22 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 03/12] xsk: add support to allow unaligned
 chunk placement
Date:   Fri, 30 Aug 2019 08:41:21 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <071FC949-1F73-40EB-AE2E-FBFEE4F956B3@gmail.com>
In-Reply-To: <20190827022531.15060-4-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-4-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> Currently, addresses are chunk size aligned. This means, we are very
> restricted in terms of where we can place chunk within the umem. For
> example, if we have a chunk size of 2k, then our chunks can only be placed
> at 0,2k,4k,6k,8k... and so on (ie. every 2k starting from 0).
>
> This patch introduces the ability to use unaligned chunks. With these
> changes, we are no longer bound to having to place chunks at a 2k (or
> whatever your chunk size is) interval. Since we are no longer dealing with
> aligned chunks, they can now cross page boundaries. Checks for page
> contiguity have been added in order to keep track of which pages are
> followed by a physically contiguous page.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
